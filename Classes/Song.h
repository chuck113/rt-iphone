//
//  Song.h
//  rhymeTimeNavigation
//
//  Created by Charles on 19/09/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Album;

@interface Song :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * lwSongName;
@property (nonatomic, retain) Album * album;

@end



