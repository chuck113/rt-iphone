//
//  DataAccess.m
//  rhymeTimeIPhoneUI
//
//  Created by Charles on 15/05/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

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
- (NSArray *)allRhymesUnsorted;

@end

@implementation DataAccess

@synthesize managedObjectContext, persistentStoreCoordinator, managedObjectModel;
@synthesize allEntries;

- (DataAccess*)init{
	[self managedObjectContext];
	
	self.allEntries = [self allRhymesUnsorted];
	return self;
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
	RhymePart *part = [self.allEntries objectAtIndex:(arc4random() % [self.allEntries count])];
	return part.word;
}

- (NSArray*)allRhymesUnsorted{
	NSFetchRequest *req = [[NSFetchRequest alloc] init];
	NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"RhymePart" inManagedObjectContext:managedObjectContext];
	[req setEntity:entityDesc];
	
	NSError *error;
	NSArray *items = [managedObjectContext executeFetchRequest:req error:&error];
	
	[req release];	
	
	if (![managedObjectContext save:&error]) {
        NSLog(@"Unresolved Core Data Save error %@, %@", error, [error userInfo]);
        return [NSArray init];
    }
	
	return items;
}
//
//
//-(NSDictionary *)buildPrefixSearchMap{
//	NSArray *allRhymes = [self allRhymes];
//	NSMutableDictionary *result = [NSMutableDictionary dictionary];
//
//	for(int i=0; i<[allRhymes count];i++){
//		//RhymePart *rhymePart = [allRhymes objectAtIndex:i];
//		NSString *word = [[allRhymes objectAtIndex:i] valueForKey:@"word"];
//		//NSLog(@"word is %@", word);
//		
//		NSString *subString = [word length] > 2 ? [word substringToIndex:3] : word;
//		
//		if([result objectForKey:subString] == nil){
//			[result setValue:[NSMutableArray array] forKey:subString];
//		}
//		
//		NSMutableArray *words = (NSMutableArray *)[result objectForKey:subString];
//		[words addObject:word];
//		//NSLog(@"added substring %@, array is now %i", subString, [words count]);
//			
//	}
//	
//	NSLog(@"created dictionary of size %i", [result count]);
//	//TODO convert mutable arrays to immutable
//	
//	return [NSDictionary dictionaryWithDictionary:result];
//}

//-(NSSet *)rhymingWordsContainedIn:(NSString *)words{
//	NSMutableSet* buffer = [[NSMutableSet alloc] init];
//	NSArray* wordsArray = [words componentsSeparatedByString:@" "];
//	
//	for(NSString *st in wordsArray){
//		if([self containsWord:st]){
//			[buffer addObject:st];
//		}
//	}
//	NSSet* result =	[NSSet setWithSet:buffer];
//	[buffer dealloc];
//	return result;	
//}
//
//-(BOOL)containsWord:(NSString *)word{
//	NSFetchRequest *req = [[NSFetchRequest alloc] init];
//	[req setEntity:[NSEntityDescription entityForName:@"RhymePart" inManagedObjectContext:self.managedObjectContext]];
//	
//	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"word like[cd] %@", word];
//	[req setPredicate:predicate];
//	
//	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"score" ascending:NO];
//	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
//	[req setSortDescriptors:sortDescriptors];
//	
//	[req setIncludesSubentities:NO]; //Omit subentities. Default is YES (i.e. include subentities)
//	
//	NSError *err;
//	NSUInteger count = [managedObjectContext countForFetchRequest:req error:&err];
//	if(count == NSNotFound) {
//		//Handle error
//	}	
//	[req release];
//	NSLog(@"count for %@ was %i", word, count);
//	
//	return count != 0;
//}
//
-(NSArray *)buildResultsArray:(NSArray *)items maxResults:(double)maxResults{
	double resultsToShowDouble = fmin(maxResults, [[[NSNumber alloc] initWithInt:items.count] doubleValue]);
	NSLog(@"will show %f results", resultsToShowDouble);
	
	int resultsToShow = [[[NSNumber alloc] initWithDouble:resultsToShowDouble] intValue];
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
	
	NSArray* result = [NSArray arrayWithArray:resultArray];
	[resultArray dealloc];
	return result;
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

-(void)installTestData{

	RhymePart* part = [[RhymePart alloc] init];
	part.word = @"crack";
	part.rhymeParts=@"mack%%%attack";
	part.rhymeLines=@"some sill words that someone once said";
	//part.
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


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	[self createEditableCopyOfDatabaseIfNeeded];
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
	//NSString* applicationDocumentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];	
    //NSString *databasePath = [[NSBundle mainBundle] pathForResource:sqliteFileName ofType:@"sqlite"];
	
	NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: sqliteFileWithExtension]];
	//NSURL *storeUrl = [NSURL fileURLWithPath:databasePath]; 
	
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
