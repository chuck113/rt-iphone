//
//  Album.h
//  rhymeTimeNavigation
//
//  Created by Charles on 19/09/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Artist;

@interface Album :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) Artist * artist;

@end



