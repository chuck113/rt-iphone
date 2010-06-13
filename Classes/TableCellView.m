//
//  TableCellView.m
//  play2-list-prototype
//
//  Created by Charles on 18/04/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TableCellView.h"
#import "RootViewController.h"
#import "Constants.h"
#import <QuartzCore/QuartzCore.h>


@implementation TableCellView

@synthesize webView, rawText, htmlLoadedCallback, htmlTextHeight;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier height:(CGFloat)height htmlCallback:(id<HtmlLoadedCallback>)htmlCallback{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
		self.htmlLoadedCallback = htmlCallback;
		htmlTextHeight = height;
		CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
		webView = [[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kLinesWidth, height)] autorelease];
		NSLog(@"web view call took %f", (CFAbsoluteTimeGetCurrent() - startTime));
		[webView setDelegate:self];
		webView.backgroundColor = [UIColor clearColor];
		webView.opaque = FALSE;
		[webView setHidden:YES];
		[self insertSubview:webView atIndex:0];
		self.backgroundColor = [UIColor blackColor];
		self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
		
//		CAGradientLayer *gradient = [CAGradientLayer layer];
//		gradient.frame = CGRectMake(0, 0, 320, height);
//		UIColor* darkterGrey = [UIColor colorWithRed:.20 green:.20 blue:.20 alpha:1];
//		gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor blackColor] CGColor], (id)[darkterGrey CGColor], nil];
//		[self.layer insertSublayer:gradient atIndex:0];
    }
    return self;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[self.htmlLoadedCallback htmlLoaded];
}

-(void)setVisible{
	NSLog(@"called setVisible at %f", CFAbsoluteTimeGetCurrent());
	[self performSelector:@selector(showWebView) withObject:nil afterDelay:3];          
}


-(void)showWebView{
	NSLog(@"called showWebView at %f", CFAbsoluteTimeGetCurrent());
	CAGradientLayer *gradient = [CAGradientLayer layer];
	gradient.frame = CGRectMake(0, 0, 320, htmlTextHeight);
	UIColor* darkterGrey = [UIColor colorWithRed:.15 green:.15 blue:.15 alpha:1];
	gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor blackColor] CGColor], (id)[darkterGrey CGColor], nil];
	[self.layer insertSublayer:gradient atIndex:0];
	[webView setHidden:NO];
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
