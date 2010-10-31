//
//  Rhyme.h
//  rhymeTimeNavigation
//
//  Created by Charles Kubicek on 01/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface Rhyme :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * lines;
@property (nonatomic, retain) NSString * wordsNotInIndex;
@property (nonatomic, retain) NSString * parts;

@end



