// 
//  RhymePart.m
//  rhymeTimeNavigation
//
//  Created by Charles Kubicek on 01/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RhymePart.h"

#import "Rhyme.h"
#import "Song.h"

@implementation RhymePart 

@dynamic rhymeScore;
@dynamic word;
@dynamic rhyme;
@dynamic song;

@dynamic rhymeLines;
@dynamic rhymeParts;
@dynamic wordsNotInIndex;


-(NSString *)rhymeLines{
	return self.rhyme.lines;
}

-(NSString *)rhymeParts{
	return self.rhyme.parts;
}

-(NSString *)wordsNotInIndex{
	return self.rhyme.wordsNotInIndex;
}

- (NSArray *)deSerializeArray:(NSString*)string{
      return [string componentsSeparatedByString:@"%%%"];
}

-(NSString *)linesDeserialisedAsString{
       return [self.rhyme.lines stringByReplacingOccurrencesOfString:@"%%%" withString:@" "];
}

-(NSArray *)linesDeserialised{
       return [self deSerializeArray:self.rhyme.lines];
}

-(NSSet *)wordsNotInIndexDeserialised{
       return [NSSet setWithArray:[self deSerializeArray:self.rhyme.wordsNotInIndex]];
}

-(NSArray *)partsDeserialised{
       return [self deSerializeArray:self.rhyme.parts];
}


@end
