//
//  RhymePart.h
//  rhymeTimeIPhoneUI
//
//  Created by Charles on 27/04/2010.
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

@property (nonatomic, retain) NSString * wordsNotInIndex;
@property (nonatomic, retain) NSString * word;
@property (nonatomic, retain) NSString * rhymeParts;
@property (nonatomic, retain) NSString * rhymeLines;
@property (nonatomic, retain) Song * song;

@end



