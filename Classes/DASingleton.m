//
//  DASingleton.m
//  rhymeTimeNavigation
//
//  Created by Charles Kubicek on 10/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DASingleton.h"
#import "DataAccess.h"


static DASingleton *sharedInstance = nil;
static DataAccess *dataAccessInstance = nil;

@implementation DASingleton

#pragma mark -
#pragma mark class instance methods

#pragma mark -
#pragma mark DASingleton methods

+ (DASingleton*)instance
{
    @synchronized(self)
    {
        if (sharedInstance == nil){
			sharedInstance = [[self alloc] init];
			dataAccessInstance = [[DataAccess alloc] init];
			[dataAccessInstance buildEntriesAsyc];
		}
    }
    return sharedInstance;
}

-(DataAccess *)dataAccess{
	return dataAccessInstance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;  // denotes an object that cannot be released
}

- (void)release {
    //do nothing
}

- (id)autorelease {
    return self;
}

@end
