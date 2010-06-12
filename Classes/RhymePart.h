//
//  RhymePart.h
//  rhymeTimeNavigation
//
//  Created by Charles Kubicek on 07/06/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Song;

@interface RhymePart :  NSManagedObject  
{
}


-(NSArray *)linesDeserialised;
-(NSArray *)partsDeserialised;
-(NSString *)linesDeserialisedAsString;
-(NSSet *)wordsNotInIndexDeserialised;

@property (nonatomic, retain) NSString * rhymeParts;
@property (nonatomic, retain) NSString * wordsNotInIndex;
@property (nonatomic, retain) NSNumber * rhymeScore;
@property (nonatomic, retain) NSString * rhymeLines;
@property (nonatomic, retain) NSString * word;
@property (nonatomic, retain) Song * song;

@end



