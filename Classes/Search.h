#import <Foundation/Foundation.h>
#import "DataAccess.h"

@protocol SearchCallback

-(void)searchComplete:(NSArray*)result word:(NSString*)word;
-(void)filterSearchComplete:(NSArray*)results;

@end



@interface Search : NSObject {
	id<SearchCallback> searchCallback;
	DataAccess *dataAccess;
}

-(id)initWithDataAccess:(DataAccess*)dataAccessObj searchCallbackObj:(id<SearchCallback>)searchCallbackObj;

-(void)search:(NSString*)text;
-(void)filterSearch:(NSString*)text;

@property (nonatomic, retain) id<SearchCallback> searchCallback;	
@property (nonatomic, retain, readonly) DataAccess *dataAccess;


@end
