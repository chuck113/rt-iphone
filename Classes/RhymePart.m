// 
//  RhymePart.m
//  rhymeTimeIPhoneUI
//
//  Created by Charles on 27/04/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RhymePart.h"

#import "Song.h"

@implementation RhymePart 

@dynamic word;
@dynamic rhymeParts;
@dynamic rhymeLines;
@dynamic song;

- (NSArray *)deSerializeArray:(NSString*)string{
	return [string componentsSeparatedByString:@"%%%"];
}

-(NSArray *)linesDeserialised{
	return [self deSerializeArray:self.rhymeLines];
}

-(NSArray *)partsDeserialised{
	return [self deSerializeArray:self.rhymeParts];
}

@end
