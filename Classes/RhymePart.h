//
//  RhymePart.h
//  rhymeTimeNavigation
//
//  Created by Charles Kubicek on 01/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Rhyme;
@class Song;

@interface RhymePart :  NSManagedObject  
{
//	NSString* rhymeLines;
//	NSString* rhymeParts;
//	NSString* wordsNotInIndex;
}


@property (nonatomic, retain) NSNumber * rhymeScore;
@property (nonatomic, retain) NSString * word;
@property (nonatomic, retain) Rhyme * rhyme;
@property (nonatomic, retain) Song * song;

@property (nonatomic, retain, readonly) NSString* rhymeLines;
@property (nonatomic, retain, readonly) NSString* rhymeParts;
@property (nonatomic, retain, readonly) NSString* wordsNotInIndex;

@end



