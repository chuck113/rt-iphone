//
//  HtmlBuilder.m
//  rhymeTimeIPhoneUI
//
//  Created by Charles on 06/05/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "HtmlBuilder.h"
#import "Constants.h"

@interface HtmlBuilder() 
- (NSString *)buildHtml:(RhymePart*)rhymePart withLinks:(BOOL)withLinks htmlStyle:(NSString *)htmlStyle;

@end

@implementation HtmlBuilder

- (NSString *)buildLines:(NSArray *)lines{
	NSMutableString* ms = [[NSMutableString alloc] initWithString:@""];
	
	for(int i = 0; i < lines.count-1; i++){
		[ms appendString:[lines objectAtIndex:i]];
		[ms appendString:@" / "];
	}
	[ms appendString:[lines objectAtIndex:(lines.count -1)]];
	return [[NSString alloc] initWithString:ms];
}

- (NSString *)removePunctuation:(NSString *)line{
	return [line stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
}

//FIXME does not apply formatting to rhymes such as 'me' that rhyme with B.I.G - needs to break down words
- (NSString *)applyFormatToRhymeParts:(NSString *)lines parts:(NSArray *)parts withLinks:(BOOL)withLinks unIndexedWords:(NSSet *)unIndexedWords prefix:(NSString  *)prefix suffix:(NSString *)suffix{
	NSSet* partSet = [NSSet setWithArray:parts];
	NSArray* words = [lines componentsSeparatedByString:@" "];
	NSMutableArray* wordBuffer = [[NSMutableArray alloc] init];
	
	for(int i=0; i<words.count; i++){
		NSString* word = [words objectAtIndex:i];
		NSString* decoratedWord = [NSString stringWithString:word];
		NSString* upperCaseCleanedWord = [self removePunctuation:[word uppercaseString]];
		NSString* cleanedWord = [self removePunctuation:word];

		if(withLinks && !([unIndexedWords containsObject:upperCaseCleanedWord])){
			decoratedWord = [NSString stringWithFormat:@"<a href=rhymetime://local/lookup/%@>%@</a>", cleanedWord, word];
		}
		
		if([partSet containsObject:upperCaseCleanedWord]){
			decoratedWord = [NSString stringWithFormat:@"%@%@%@", prefix, decoratedWord, suffix];
		}
		
		[wordBuffer addObject:[NSString stringWithFormat:@"%@ ", decoratedWord]];
	}
	
	NSMutableString* stringBuffer = [[NSMutableString alloc] init];
	for(NSString* word in wordBuffer){
		[stringBuffer appendString:word];
	}
	
	[wordBuffer dealloc];
	return [NSString stringWithString:stringBuffer];
}

- (NSString *)testHtml{
	NSMutableString* ms = [[NSMutableString alloc] initWithString:@"<html><head><title>/title></head><body>"];
	[ms appendString:@"<p>I pour a hieneken <b>brew</b> to my dececed <b>crew</b> in memory lane</p>"];
	[ms appendString:@"<p>NAS - Memory Lane</p>"];
	return [[NSString alloc] initWithString:ms];
}


- (NSString *)buildStyledHtmlWithLinks:(RhymePart*)rhymePart{
	return [self buildHtml:rhymePart withLinks:YES htmlStyle:@""];
}

- (NSString *)buildTableResult:(RhymePart*)rhymePart{
	return [self buildHtml:rhymePart withLinks:NO htmlStyle:kResultTableHtmlStyle];
}

- (NSString *)buildTableResultWithLinesOnly:(RhymePart*)rhymePart{
	return [self buildHtml:rhymePart htmlStyle:kResultTableHtmlStyle linesDiv:[self buildHtmlLines:rhymePart styleString:kResultTableLineStyle withLinks:NO] titleDiv:@""];
}

- (NSString *)linesForDetailView:(RhymePart*)rhymePart{
	NSLog(@"built html: %@", [self buildHtmlLines: rhymePart styleString:kDetailLineStyle withLinks:YES]);
	return [self buildHtmlLines: rhymePart styleString:kDetailLineStyle withLinks:YES];
}

- (NSString *)linesForTableView:(RhymePart*)rhymePart{
	return [self buildHtmlLines: rhymePart styleString:kResultTableLineStyle withLinks:NO];
}

- (NSString *)buildHtmlLines:(RhymePart*)rhymePart styleString:(NSString*)styleString withLinks:(BOOL)withLinks{
	NSArray *parts = [rhymePart partsDeserialised];
	NSArray *lines = [rhymePart linesDeserialised];
	//NSString* line = [NSString stringWithFormat:@"<b>\"</b>%@<b>\"</b>", [self buildLines:lines]];
	NSString* line = [self buildLines:lines];
	
	NSString* divAndStyle = [NSString stringWithFormat:@"<div id=\"lines\" %@>", styleString];
	
	NSSet* unindexedWords = [[NSSet alloc] init];
	if(withLinks){
		unindexedWords = [rhymePart wordsNotInIndexDeserialised]; 
	}
	
	NSString* linesWithFormatting = [self applyFormatToRhymeParts:line parts:parts withLinks:withLinks unIndexedWords:unindexedWords prefix:@"<b>" suffix:@"</b>"];

	return [NSString stringWithFormat:@"%@%@</div>", divAndStyle, linesWithFormatting];
}

- (NSString *)buildHtmlArtistAndTitle:(RhymePart*)rhymePart{
	NSString* divAndStyle =[NSString stringWithFormat:@"<div id=\"title\" %@>", kResultTableArtistStyle];
	
	NSString* title = rhymePart.song.title;
	NSString* artist = rhymePart.song.album.artist.name;
	
	NSString *artistAndTite = [NSString stringWithFormat:@"%@ - %@", [artist uppercaseString], title];
	
	return [NSString stringWithFormat:@"%@%@</div>", divAndStyle, artistAndTite];
}

- (NSString *)buildHtml:(RhymePart*)rhymePart htmlStyle:(NSString *)htmlStyle linesDiv:(NSString*)linesDiv titleDiv:(NSString*)titleDiv{
	return [NSString stringWithFormat:@"<html><head><title>/title></head><body %@>%@%@</body></html>", htmlStyle, linesDiv, titleDiv];

}

- (NSString *)buildHtml:(RhymePart*)rhymePart withLinks:(BOOL)withLinks htmlStyle:(NSString *)htmlStyle{
	return [self buildHtml:rhymePart htmlStyle:htmlStyle linesDiv:[self linesForTableView:rhymePart] titleDiv:[self buildHtmlArtistAndTitle:rhymePart]];
}



@end
