//
//  TableCellView.m
//  play2-list-prototype
//
//  Created by Charles on 18/04/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TableCellView.h"
#import "Constants.h"


@implementation TableCellView


//@synthesize lines, artist, title;
@synthesize webView, rawText, delegate;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier height:(CGFloat)height{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        webView = [[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kLinesWidth, height)] autorelease];
		[webView setDelegate:self];
		[self addSubview:webView];
		self.accessoryType = UITableViewCellAccessoryDisclosureIndicator; 
    }
    return self;
}


- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
	NSLog(@"got request %@", [[request URL]absoluteString]);
	NSLog(@"got request base %@", [[request URL]baseURL]);
	
	if([[[request URL]absoluteString] isEqualToString:@"about:blank"]){
		return TRUE;
	}else{
	
		NSArray* elements = [[[request URL] path] componentsSeparatedByString:@"/"];
		NSString* lastPathElement = [elements lastObject];
		NSLog(@"lastPathElement %@", lastPathElement);
	
		[self.delegate setSearchBarText:lastPathElement];
		return FALSE;
	}
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (void)dealloc {
	// set webView delegate to nill before deallocation webView
	webView.delegate = nil;
	[webView dealloc];
    [super dealloc];
}
	

- (void)setLabelText:(NSString *)_text;{
	[webView loadHTMLString:_text baseURL:nil];
	[webView sizeToFit];
}



@end
