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
- (NSString *)buildHtml:(RhymePart*)rhymePart bodyStyle:(NSString *)bodyStyle withLinks:(BOOL)withLinks;
- (NSString *)buildHtml:(NSString *)headerCss linesDiv:(NSString*)linesDiv;
- (NSString *)detailViewCss;
@end

@implementation HtmlBuilder

- (NSString *)buildLines:(NSArray *)lines{
	NSMutableString* ms = [[NSMutableString alloc] initWithString:@""];
	
	for(int i = 0; i < lines.count-1; i++){
		[ms appendString:[lines objectAtIndex:i]];
		[ms appendString:@" / "];
	}
	[ms appendString:[lines objectAtIndex:(lines.count -1)]];
	
	NSString *res = [NSString stringWithString:ms];
	[ms release];
	return res; 
}

- (NSString *)removePunctuation:(NSString *)line{
	return [line stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
}

//FIXME does not apply formatting to rhymes such as 'me' that rhyme with B.I.G - needs to break down words
- (NSString *)applyFormatToRhymeParts:(NSString *)lines parts:(NSArray *)parts withLinks:(BOOL)withLinks unIndexedWords:(NSSet *)unIndexedWords prefix:(NSString  *)prefix suffix:(NSString *)suffix emphasizeParts:(Boolean)emphasizeParts deEmphasizeUnindexedWords:(Boolean)deEmphasizeUnindexedWords{
	NSSet* partSet = [NSSet setWithArray:parts];
	NSArray* words = [lines componentsSeparatedByString:@" "];
	NSMutableArray* wordBuffer = [[NSMutableArray alloc] init];
	
	for(int i=0; i<words.count; i++){
		NSString* word = [words objectAtIndex:i];
		NSString* decoratedWord = [NSString stringWithString:word];
		NSString* cleanedWord = [self removePunctuation:word];
		NSString* upperCaseCleanedWord = [cleanedWord uppercaseString];
		

		if(deEmphasizeUnindexedWords && [unIndexedWords containsObject:upperCaseCleanedWord]){
			decoratedWord = [NSString stringWithFormat:@"<span style=\"color: gray;\">%@</span>", word];
		}else if(withLinks && !([unIndexedWords containsObject:upperCaseCleanedWord]) 
		   && ![upperCaseCleanedWord isEqualToString:@""]
		   && ![upperCaseCleanedWord isEqualToString:@"I"])
		{
			NSLog(@"word: %@, deemp:%@", word, deEmphasizeUnindexedWords == FALSE ?@"false":@"true");
			decoratedWord = [NSString stringWithFormat:@"<a href=\"rhymetime://local/lookup/%@\">%@</a>", cleanedWord, word];
		}

		
		if(emphasizeParts && [partSet containsObject:upperCaseCleanedWord]){
			decoratedWord = [NSString stringWithFormat:@"%@%@%@", prefix, decoratedWord, suffix];
		}
		
		[wordBuffer addObject:[NSString stringWithFormat:@"%@ ", decoratedWord]];
	}
	
	NSMutableString* stringBuffer = [[NSMutableString alloc] init];
	for(NSString* word in wordBuffer){
		[stringBuffer appendString:word];
	}
	
	[wordBuffer release];
	NSString *res = [NSString stringWithString:stringBuffer];
	[stringBuffer release];
	return [res stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
}

//- (NSString *)testHtml{
//	NSMutableString* ms = [[NSMutableString alloc] initWithString:@"<html><head><title>/title></head><body>"];
//	[ms appendString:@"<p>I pour a hieneken <b>brew</b> to my dececed <b>crew</b> in memory lane</p>"];
//	[ms appendString:@"<p>NAS - Memory Lane</p>"];
//	
//	NSString *res =[NSString stringWithString:ms];
//	[ms release];
//	return res;
//}


- (NSString *)buildStyledHtmlWithLinks:(RhymePart*)rhymePart{
	return [self buildHtml:rhymePart bodyStyle:@"" withLinks:YES ];
}

- (NSString *)buildTableResult:(RhymePart*)rhymePart{
	return [self buildHtml:rhymePart bodyStyle:kResultTablebodyStyle withLinks:NO ];
}

- (NSString *)buildTableResultWithLinesOnly:(RhymePart*)rhymePart{
	return [self buildHtml:rhymePart bodyStyle:kResultTablebodyStyle linesDiv:[self buildHtmlLines:rhymePart styleString:kResultTableLineStyle withLinks:NO emphasizeParts:NO deEmphasizeUnindexedWords:NO] titleDiv:@""];
}

- (NSString *)linesForDetailView:(RhymePart*)rhymePart{
	NSString* linkColorCss = [self detailViewCss];
	return [self buildHtml:linkColorCss linesDiv:[self buildHtmlLines: rhymePart styleString:kDetailLineStyle withLinks:YES emphasizeParts:NO deEmphasizeUnindexedWords:YES]];
}

- (NSString *)linesForTableView:(RhymePart*)rhymePart{
	return [self buildHtmlLines: rhymePart styleString:kResultTableLineStyle withLinks:NO emphasizeParts:YES deEmphasizeUnindexedWords:NO];
}

- (NSString *)buildHtmlLines320:(RhymePart*)rhymePart{
	NSArray *parts = [rhymePart partsDeserialised];
	NSArray *lines = [rhymePart linesDeserialised];
	NSString* line = [self buildLines:lines];

	NSString* divAndStyle = [NSString stringWithFormat:@"<span class='linesStyle'>"];
	
	NSSet* unindexedWords = [NSSet set];
	
	NSString* linesWithFormatting = [self applyFormatToRhymeParts:line parts:parts withLinks:NO unIndexedWords:unindexedWords prefix:@"<b>" suffix:@"</b>" emphasizeParts:YES deEmphasizeUnindexedWords:NO];

	NSLog(@"with quotes '%@'", [self applyQuotes:linesWithFormatting]);
	
	return [NSString stringWithFormat:@"%@%@</span>", divAndStyle, [self applyQuotes:linesWithFormatting]];
}

-(NSString *)applyQuotes:(NSString *)line{
	return [NSString stringWithFormat:@"<b>\"</b>%@<b>\"</b>", line];	
	//return [NSString stringWithFormat:@"<span style=\"font-size:28px;\">\" XX</span>%@<span style=\"font-size:28px;\">\"</span>", line];
}

//-(NSString *)applyQuotes:(NSString *)line{
//	return [NSString stringWithFormat:@"<img src=\"bundle://backQuote.png\"/>%@", line];	
//}

- (NSString *)buildHtmlLines:(RhymePart*)rhymePart styleString:(NSString*)styleString withLinks:(BOOL)withLinks emphasizeParts:(BOOL)emphasizeParts deEmphasizeUnindexedWords:(BOOL)deEmphasizeUnindexedWords{
	NSArray *parts = [rhymePart partsDeserialised];
	NSArray *lines = [rhymePart linesDeserialised];
	NSString* line = [self buildLines:lines];
	
	NSString* divAndStyle = [NSString stringWithFormat:@"<div id=\"lines\" %@>", styleString];
	
	NSMutableSet* unindexedWords = [[NSMutableSet alloc] init];
	if(withLinks){
		[unindexedWords unionSet:[rhymePart wordsNotInIndexDeserialised]];
	}
	
	NSSet *unindexedWordsImmutable = [NSSet setWithSet:unindexedWords];
	
	NSString* linesWithFormatting = [self applyFormatToRhymeParts:line parts:parts withLinks:withLinks unIndexedWords:unindexedWordsImmutable prefix:@"<b>" suffix:@"</b>" emphasizeParts:emphasizeParts deEmphasizeUnindexedWords:deEmphasizeUnindexedWords];
	[unindexedWords release];
	// DEBUG
	//return [NSString stringWithFormat:@"%@%@ DEBUG:%d</div>", divAndStyle, linesWithFormatting, rhymePart.rhymeScore];
	
	return [NSString stringWithFormat:@"%@%@</div>", divAndStyle, linesWithFormatting];
}

- (NSString *)buildHtmlArtistAndTitle:(RhymePart*)rhymePart{
	NSString* divAndStyle =[NSString stringWithFormat:@"<div id=\"title\" %@>", kResultTableArtistStyle];
	
	NSString* title = rhymePart.song.title;
	NSString* artist = rhymePart.song.album.artist.name;
	
	NSString *artistAndTite = [NSString stringWithFormat:@"%@ - %@", [artist uppercaseString], title];
	
	return [NSString stringWithFormat:@"%@%@</div>", divAndStyle, artistAndTite];
}

- (NSString *)buildHtmlArtistAndTitle320:(RhymePart*)rhymePart{
	NSString* divAndStyle =[NSString stringWithFormat:@"<span class='titleStyle'>"];
	
	NSString* title = rhymePart.song.title;
	NSString* artist = rhymePart.song.album.artist.name;
	
	NSString *artistAndTite = [NSString stringWithFormat:@"%@ - %@", [artist uppercaseString], title];
	
	return [NSString stringWithFormat:@"%@%@</span>", divAndStyle, artistAndTite];
}

- (NSString *)buildHtml:(NSString *)headerCss linesDiv:(NSString*)linesDiv {
	NSString *css = [NSString stringWithFormat:@"<style type=\"text/css\">%@</style>", headerCss];
	return [NSString stringWithFormat:@"<html><head><title>/title><head>%@</head><body>%@</body></html>", css, linesDiv];
}


//- (NSString *)buildHtml320:(RhymePart*)rhymePart{
//	NSString *lines= [self buildHtmlLines320:rhymePart];
//	NSString *title = [self buildHtmlArtistAndTitle320:rhymePart];
//	
//	return [NSString stringWithFormat:@"%@<br/><br/>%@", lines, title];
//}

- (NSString *)buildHtml:(RhymePart*)rhymePart bodyStyle:(NSString *)bodyStyle linesDiv:(NSString*)linesDiv titleDiv:(NSString*)titleDiv{
	return [NSString stringWithFormat:@"<html><head><title>/title></head><body %@>%@%@</body></html>", bodyStyle, linesDiv, titleDiv];
}

- (NSString *)buildHtml:(RhymePart*)rhymePart bodyStyle:(NSString *)bodyStyle withLinks:(BOOL)withLinks {
	return [self buildHtml:rhymePart bodyStyle:bodyStyle linesDiv:[self linesForTableView:rhymePart] titleDiv:[self buildHtmlArtistAndTitle:rhymePart]];
}

-(NSString *)detailViewCss{
	//NSString *cssPart = @"{color:white; text-decoration:none; border-bottom: 1px solid gray;}";
	NSString *cssPart = @"{color:white; text-decoration:none; border-bottom: 1px solid gray;}";
	return [NSString stringWithFormat:@"div#lines{position:fixed;top:0px;} body {background-color:black;} A:link %@ A:active %@ A:hover %@ A:visited %@",cssPart,cssPart,cssPart,cssPart];
	
//@"A:link {color:black; text-decoration:none; border-bottom: 1px solid lightgray;}	
//A:active {color:black;text-decoration:none;border-bottom: 1px solid lightgray;}	
//A:hover {color:black;text-decoration:none;border-bottom:1px solid lightgray;}	
//A:visited  {color:black;text-decoration:none;border-bottom:1px solid lightgray;}"
}




@end
