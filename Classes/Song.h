//
//  Song.h
//  rhymeTimeNavigation
//
//  Created by Charles Kubicek on 01/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Album;

@interface Song :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) Album * album;

@end



