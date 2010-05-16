//
//  HtmlBuilder.h
//  rhymeTimeIPhoneUI
//
//  Created by Charles on 06/05/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RhymePart.h"
#import "Song.h"
#import "Album.h"
#import "Artist.h"

typedef enum {
    HtmlBuilderLinesAndArtistNoLinks,
	HtmlBuilderLinesAndLinks
} HtmlType;

@interface HtmlBuilder : NSObject {

}

- (NSString *)linesForTableView:(RhymePart*)rhymePart;
- (NSString *)buildHtmlLines:(RhymePart*)rhymePart styleString:(NSString*)styleString withLinks:(BOOL)withLinks;
- (NSString*)linesForDetailView:(RhymePart*)rhymePart;
- (NSString*)buildTableResult:(RhymePart*)rhymePart;
- (NSString*)buildStyledHtmlWithLinks:(RhymePart*)rhymePart;
//- (NSString *)linesForDetail:(RhymePart*)rhymePart :(NSString*)styleString :(BOOL)withLinks;

@end
