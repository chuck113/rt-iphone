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
//    UITableViewCellAccessoryDisclosureIndicator,    // regular chevron. doesn't track
//    UITableViewCellAccessoryDetailDisclosureButton, // blue button w/ chevron. tracks
//    UITableViewCellAccessoryCheckmark               // checkmark. doesn't track
} HtmlType;

@interface HtmlBuilder : NSObject {

}

- (NSString*)buildStyledHtml:(RhymePart*)rhymePart;
- (NSString*)buildStyledHtmlWithLinks:(RhymePart*)rhymePart;
- (NSString *)buildHtmlLines:(RhymePart*)rhymePart styleString:(NSString*)styleString withLinks:(BOOL)withLinks;

@end
