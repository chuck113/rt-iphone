//
//  LyricsView.m
//  rhymeTimeNavigation
//
//  Created by Charles on 22/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "YouTubeView.h"
#import "AppDelegate.h"
#import  <QuartzCore/QuartzCore.h>

@implementation YouTubeView

@synthesize webView, url, browserTextField, spinner, activityItem;


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
	
	return self;
}

- (void) reachabilityChanged: (NSNotification* )note
{
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
	//[self updateInterfaceWithReachability: curReach];
}

//UIAlertViewDelegate method
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
	NSLog(@"dismissed");
	if (self.navigationItem.rightBarButtonItem == activityItem) {
        [self.navigationItem setRightBarButtonItem:nil animated:NO];
    }
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	[Reachability showAlertIfNoInternetConnectionAsync:self];
	
	self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 400)];
	[self.webView setDelegate:self];

	spinner = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
    [spinner startAnimating];
	activityItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
	
	//self.browserTextField.text = self.url;
	NSLog(@"loading request for %@", self.url);
	[self.view addSubview:webView];
	[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
	
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

- (void)webViewDidStartLoad:(UIWebView *)webViewParam{
	if (!self.navigationItem.rightBarButtonItem) {
        [self.navigationItem setRightBarButtonItem:self.activityItem animated:YES];
    }
	
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
	if (self.navigationItem.rightBarButtonItem == activityItem) {
        [self.navigationItem setRightBarButtonItem:nil animated:YES];
    }
	
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
	NSLog(@"Failed to load due to %@", [error userInfo]);	
}


@end
