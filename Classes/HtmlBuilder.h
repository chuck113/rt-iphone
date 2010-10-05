//
//  HtmlBuilder.h
//  rhymeTimeIPhoneUI
//
//  Created by Charles on 06/05/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RhymePart.h"
#import "Song.h"file://localhost/Users/ck/dev/rt-iphone/rt-iphone/Classes/HtmlBuilder.m
#import "Album.h"
#import "Artist.h"

typedef enum {
    HtmlBuilderLinesAndArtistNoLinks,
	HtmlBuilderLinesAndLinks
} HtmlType;

@interface HtmlBuilder : NSObject {

}

- (NSString *)buildHtml:(RhymePart*)rhymePart bodyStyle:(NSString *)bodyStyle linesDiv:(NSString*)linesDiv titleDiv:(NSString*)titleDiv;
- (NSString *)buildTableResultWithLinesOnly:(RhymePart*)rhymePart;
- (NSString *)linesForTableView:(RhymePart*)rhymePart;
- (NSString *)buildHtmlLines:(RhymePart*)rhymePart styleString:(NSString*)styleString withLinks:(BOOL)withLinks emphasizeParts:(BOOL)emphasizeParts deEmphasizeUnindexedWords:(BOOL)deEmphasizeUnindexedWords;
- (NSString*)linesForDetailView:(RhymePart*)rhymePart;
- (NSString*)buildTableResult:(RhymePart*)rhymePart;
- (NSString*)buildStyledHtmlWithLinks:(RhymePart*)rhymePart;
- (NSString *)buildHtmlLines320:(RhymePart*)rhymePart;

//- (NSString *)linesForDetail:(RhymePart*)rhymePart :(NSString*)styleString :(BOOL)withLinks;

@end
