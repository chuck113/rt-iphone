//
//  TableCellView.m
//  play2-list-prototype
//
//  Created by Charles on 18/04/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TableCellView.h"
#import "Constants.h"
#import <QuartzCore/QuartzCore.h>


@implementation TableCellView

@synthesize webView, rawText, delegate;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier height:(CGFloat)height{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        webView = [[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kLinesWidth, height)] autorelease];
		[webView setDelegate:self];
		webView.backgroundColor = [UIColor clearColor];
		webView.opaque = FALSE;
		[self insertSubview:webView atIndex:0];
		self.backgroundColor = [UIColor blackColor];
		self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
		
		CAGradientLayer *gradient = [CAGradientLayer layer];
		gradient.frame = CGRectMake(0, 0, 320, height);
		UIColor* darkterGrey = [UIColor colorWithRed:.10 green:.10 blue:.10 alpha:1];
		gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor blackColor] CGColor], (id)[darkterGrey CGColor], nil];
		[self.layer insertSublayer:gradient atIndex:0];
    }
    return self;
}


//- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
//	NSLog(@"got request %@", [request URL]);
//	if([[[request URL]absoluteString] isEqualToString:@"about:blank"]){
//		return TRUE;
//	}else{
//		NSArray* elements = [[[request URL] path] componentsSeparatedByString:@"/"];
//		NSString* lastPathElement = [elements lastObject];
//		NSLog(@"lastPathElement %@", lastPathElement);
//	
//		[self.delegate setSearchTextAndDoSearch:lastPathElement];
//		return FALSE;
//	}
//}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (void)dealloc {
	// set webView delegate to nill before deallocation webView
	//webView.delegate = nil;
	//[webView dealloc];
	// removing these lines resulted in sending msg to object that has been freed
	
    [super dealloc];
}
	

- (void)setLabelText:(NSString *)_text;{
	[webView loadHTMLString:_text baseURL:nil];
	[webView sizeToFit];
}



@end
