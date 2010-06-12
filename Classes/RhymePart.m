// 
//  RhymePart.m
//  rhymeTimeNavigation
//
//  Created by Charles Kubicek on 07/06/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RhymePart.h"

#import "Song.h"

@implementation RhymePart 

@dynamic rhymeParts;
@dynamic wordsNotInIndex;
@dynamic rhymeScore;
@dynamic rhymeLines;
@dynamic word;
@dynamic song;

- (NSArray *)deSerializeArray:(NSString*)string{
	return [string componentsSeparatedByString:@"%%%"];
}

-(NSString *)linesDeserialisedAsString{
	return [self.rhymeLines stringByReplacingOccurrencesOfString:@"%%%" withString:@" "];
}

-(NSArray *)linesDeserialised{
	return [self deSerializeArray:self.rhymeLines];
}

-(NSSet *)wordsNotInIndexDeserialised{
	return [NSSet setWithArray:[self deSerializeArray:self.wordsNotInIndex]];
}

-(NSArray *)partsDeserialised{
	return [self deSerializeArray:self.rhymeParts];
}

@end
