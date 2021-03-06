#import "DataAccess.h"
#import "RhymePart.h"
#import "Song.h"
#import "Album.h"
#import "Artist.h"
#import "math.h"
#import "Constants.h"

@interface DataAccess()

- (NSArray *)buildResultsArray:(NSArray *)items maxResults:(double)maxResults;
- (NSString *)applicationDocumentsDirectory;
- (NSArray *)allRhymesSorted;
- (NSDictionary *)buildPrefixSearchMap:(NSArray*)allEntries;

-(void)buildEntriesWorker;

@end


@implementation DataAccess

@synthesize managedObjectContext, persistentStoreCoordinator, managedObjectModel;
@synthesize allEntries, prefixSearchMap;

- (DataAccess*)init{
	[self managedObjectContext];
	return self;
}

-(void)buildEntriesAsyc{
	[NSThread detachNewThreadSelector:@selector(buildEntriesWorker) toTarget:self withObject:nil];
}

-(void)buildEntriesWorker{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	self.allEntries = [self allRhymesSorted];
	self.prefixSearchMap = [self buildPrefixSearchMap:self.allEntries];

	[pool release];
}

/**
 *	returns an array of rhymeParts
 */
- (NSArray*)findRhymes:(NSString *)toFind{
	CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
	NSLog(@"Finding rhymes for word: %@", toFind);
	
	NSFetchRequest *req = [[NSFetchRequest alloc] init];
	[req setEntity:[NSEntityDescription entityForName:@"RhymePart" inManagedObjectContext:self.managedObjectContext]];
	
	//NSPredicate *predicate = [NSPredicate predicateWithFormat:@"word like[cd] %@", toFind];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"word = %@", [toFind uppercaseString]];
	[req setPredicate:predicate];
	
	NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"rhymeScore" ascending:NO];
	[req setSortDescriptors:[NSArray arrayWithObject:sortByName]];
		
	NSError *error;
	NSArray *items = [managedObjectContext executeFetchRequest:req error:&error];
	
	[req release];	
	[sortByName release];
	
	NSLog(@"found rhymes: %i, took %f", items.count, (CFAbsoluteTimeGetCurrent() - startTime));
	
	if (![managedObjectContext save:&error]) {
        NSLog(@"Unresolved Core Data Save error %@, %@", error, [error userInfo]);
        return [NSArray init];
    }
	
	return [self buildResultsArray:items maxResults:20.0];
}

- (NSArray*)rhymesWithPrefix:(NSString *)prefix{
	CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
	
	NSFetchRequest *req = [[NSFetchRequest alloc] init];
	NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"RhymePart" inManagedObjectContext:managedObjectContext];
	[req setEntity:entityDesc];
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"word beginswith[c] %@", [prefix uppercaseString]];
	[req setPredicate:predicate];
	
	NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"word" ascending:YES];
	
	[req setSortDescriptors:[NSArray arrayWithObject:sortByName]];
	[req setResultType:NSDictionaryResultType];

	
	NSDictionary *entityProperties = [entityDesc propertiesByName];
	[req setPropertiesToFetch:[NSArray arrayWithObject:[entityProperties objectForKey:@"word"]]];
	[req setReturnsDistinctResults:TRUE];
	
	NSError *error;
	NSArray *items = [managedObjectContext executeFetchRequest:req error:&error];
	
	[req release];
	[sortByName release];
	
	NSLog(@"allRhymes: %i, took %f", items.count, (CFAbsoluteTimeGetCurrent() - startTime));
	
	if (![managedObjectContext save:&error]) {
        NSLog(@"Unresolved Core Data Save error %@, %@", error, [error userInfo]);
        return [NSArray init];
    }
	
	NSMutableArray* strings = [NSMutableArray arrayWithCapacity:[items count]];
	for (int i=0; i<[items count]; i++){
		[strings addObject:[[items objectAtIndex:i] valueForKey:@"word"]];
	}
		 
	NSArray *result = [NSArray arrayWithArray:strings];
	//[strings release];
	//[items release];
	
	return result;
	
}

-(NSString *)randomWord{
	if([self.allEntries count] == 0){
		NSArray *firstWords = [[NSArray alloc] initWithObjects:@"rap", @"commit", @"prevention", @"between", @"ringin", @"explain", NULL];
		NSString *randomWord = [firstWords objectAtIndex:(arc4random() % [firstWords count])];
		[firstWords release];
		return randomWord;
	}
	return [[self.allEntries objectAtIndex:(arc4random() % [self.allEntries count])]valueForKey:@"word"];
}

- (NSArray*)allRhymesSorted{
	CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();

	NSFetchRequest *req = [[NSFetchRequest alloc] init];
	NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"RhymePart" inManagedObjectContext:managedObjectContext];
	[req setEntity:entityDesc];
	
	NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"word" ascending:YES];
	
	[req setSortDescriptors:[NSArray arrayWithObject:sortByName]];
	[req setResultType:NSDictionaryResultType];
	
	
	NSDictionary *entityProperties = [entityDesc propertiesByName];
	[req setPropertiesToFetch:[NSArray arrayWithObject:[entityProperties objectForKey:@"word"]]];
	[req setReturnsDistinctResults:TRUE];
	
	NSError *error;
	NSArray *items = [managedObjectContext executeFetchRequest:req error:&error];
	
	[req release];
	[sortByName release];
	
	if (![managedObjectContext save:&error]) {
        NSLog(@"Unresolved Core Data Save error %@, %@", error, [error userInfo]);
        return [NSArray init];
    }
	
	NSLog(@"allRhymes: took %f", (CFAbsoluteTimeGetCurrent() - startTime));

	
	return items;
}
//
//
-(NSDictionary *)buildPrefixSearchMap:(NSArray*)allRhymes{
	CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();

	NSMutableDictionary *result = [NSMutableDictionary dictionary];

	for(int i=0; i<[allRhymes count];i++){
		//RhymePart *rhymePart = [allRhymes objectAtIndex:i];
		NSString *word = [[allRhymes objectAtIndex:i] valueForKey:@"word"];
		//NSLog(@"word is %@", word);
		
		NSString *subString = [word length] > 2 ? [word substringToIndex:3] : word;
		
		if([result objectForKey:subString] == nil){
			[result setValue:[NSMutableArray array] forKey:subString];
		}
		
		NSMutableArray *words = (NSMutableArray *)[result objectForKey:subString];
		[words addObject:word];
		//NSLog(@"added substring %@, array is now %i", subString, [words count]);
			
	}
	
	NSLog(@"created dictionary of size %i", [result count]);
	//TODO convert mutable arrays to immutable
	NSLog(@"buildPrefixSearchMap: took %f", (CFAbsoluteTimeGetCurrent() - startTime));

	
	return [NSDictionary dictionaryWithDictionary:result];
}

-(NSArray *)rhymesWithPrefixCheap:(NSString *)queryRaw{
	CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();

	NSString* query = [queryRaw uppercaseString];
	//NSLog(@"query length: %i", [query length]);
	//NSLog(@"query length: %@", [self.prefixSearchMap objectForKey:query]);

	if([query length] == 3 && ([self.prefixSearchMap objectForKey:query] != nil)){
		return [self.prefixSearchMap objectForKey:query];
	}else if([query length] > 3){
		NSString *key = [query substringToIndex:3];
		id res = [self.prefixSearchMap objectForKey:key];
		if(res != nil){
			NSArray *entries = (NSArray*)res;
			NSMutableArray *resultArray = [[NSMutableArray alloc] init];
			for(NSString *word in entries){
				if([word hasPrefix:query]){
					[resultArray addObject:word];
				}
			}
			NSLog(@"rhymesWithPrefixCheap: took %f", (CFAbsoluteTimeGetCurrent() - startTime));

			NSArray *res = [NSArray arrayWithArray:resultArray];
			[resultArray release];
			return res;
		}
			
	}
	return [NSArray array];
}

-(NSArray *)buildResultsArray:(NSArray *)items maxResults:(double)maxResults{
	double resultsToShowDouble = fmin(maxResults, [[NSNumber numberWithInt:items.count] doubleValue]);
	NSLog(@"will show %f results", resultsToShowDouble);
	
	int resultsToShow = [[NSNumber numberWithDouble:resultsToShowDouble] intValue];
	NSLog(@"will show %i results", resultsToShow);
	
	NSMutableArray* resultArray = [[NSMutableArray alloc] init];
	NSMutableSet* lines = [NSMutableSet set];
	
	for(int i = 0; (i < [items count]) && ([resultArray count] < resultsToShow); i++){
		RhymePart* part = (RhymePart*)[items objectAtIndex:i];
		if(![lines containsObject:part.rhymeLines]){
			[lines addObject:part.rhymeLines];
			[resultArray addObject:[items objectAtIndex:i]];
		}
	}
	
	NSLog(@"result array has %i entreis", resultArray.count);

	
	NSArray* res = [NSArray arrayWithArray:resultArray];
	[resultArray release];
	return res;
}

/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */
- (void)onApplicationTermination:(UIApplication *)application {
	
    NSError *error = nil;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			/*
			 Replace this implementation with code to handle the error appropriately.
			 
			 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
			 */
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
        } 
    }
}


#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext {
	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
	
	
	return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}

- (void)createEditableCopyOfDatabaseIfNeeded  
{ 
    // First, test for existence. 
    BOOL success; 
    NSFileManager *fileManager = [NSFileManager defaultManager]; 
    NSError *error; 
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
    NSString *documentsDirectory = [paths objectAtIndex:0]; 
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:sqliteFileWithExtension]; 
    success = [fileManager fileExistsAtPath:writableDBPath]; 
    // NSLog(@"path : %@", writableDBPath); 
    if (success) return; 
	// The writable database does not exist, so copy the default to the appropriate location. 
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:sqliteFileWithExtension]; 
    NSLog(@"copying database from %@ to %@", defaultDBPath, writableDBPath);
    
	success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error]; 
	NSLog(@"done copying");
    
    if (!success)  
    { 
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]); 
    } 
}

-(NSURL*)storeUrlFromDocumentsDir{
	//NSString* applicationDocumentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];		
	return [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: sqliteFileWithExtension]];
}

-(NSURL*)storeUrlFromBundle{
    return [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:sqliteFileName ofType:@"sqlite"]];
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	/**
	 *
	 *
	 * RUN THE APP WITH THIS LINE COMMENTED OUT TO CREATE THE EMPTY SQLITE DATABASE.
	 * 
	 *
	 */
	//[self createEditableCopyOfDatabaseIfNeeded];
	
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
	NSURL *storeUrl = [self storeUrlFromBundle];
	
	NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 
		 Typical reasons for an error here include:
		 * The persistent store is not accessible
		 * The schema for the persistent store is incompatible with current managed object model
		 Check the error message to determine what the actual problem was.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
    }    
	
    return persistentStoreCoordinator;
}


#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the path to the application's Documents directory.
 
 May be needed if we need to deploy sqlite file from documents dir
 */
- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}


@end
