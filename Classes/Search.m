#import "Search.h"

@interface Search()

-(void)searchWorker:(NSString*)text;
-(void)searchComplete:(NSDictionary*)resultParameters;

-(void)filterSearchWorker:(NSString*)text;
-(void)filterSearchComplete:(NSArray*)results;

@end


@implementation Search

@synthesize searchCallback, dataAccess;

-(id)initWithDataAccess:(DataAccess*)dataAccessObj searchCallbackObj:(id<SearchCallback>)searchCallbackObj{
	if (self = [super init]) {
		dataAccess = dataAccessObj;
		searchCallback = searchCallbackObj;
	}
	return self;
}

-(void)search:(NSString*)text{
	[NSThread detachNewThreadSelector:@selector(searchWorker:) toTarget:self withObject:text];
}

//
// search threading methods and callback
//

-(void)searchWorker:(NSString*)text{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSArray* result = [dataAccess findRhymes:text]; 
	NSDictionary *resultParameters = [[NSDictionary alloc] initWithObjectsAndKeys:
									  result, @"result",
									  text, @"text",							  
									  nil];
	[self performSelectorOnMainThread:@selector(searchComplete:) withObject:resultParameters waitUntilDone:NO];
	
	[resultParameters release];
    [pool release];
	
}

-(void)searchComplete:(NSDictionary*)resultParameters{
	NSArray *result = (NSArray *)[resultParameters objectForKey:@"result"];
	NSString *word = (NSString *)[resultParameters objectForKey:@"text"];
	
	[searchCallback searchComplete:result word:word];
}


-(void)filterSearchWorker:(NSString*)text{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSArray *results = [dataAccess rhymesWithPrefixCheap:text];
	
	[self performSelectorOnMainThread:@selector(filterSearchComplete:) withObject:results waitUntilDone:NO];

    [pool release];
}

-(void)filterSearchComplete:(NSArray*)results{
	[searchCallback filterSearchComplete:results];
}

-(void)filterSearch:(NSString*)text{
	[NSThread detachNewThreadSelector:@selector(filterSearchWorker:) toTarget:self withObject:text];
}

@end
