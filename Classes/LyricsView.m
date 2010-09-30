//
//  LyricsView.m
//  rhymeTimeNavigation
//
//  Created by Charles on 22/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LyricsView.h"
#import  <QuartzCore/QuartzCore.h>

@implementation LyricsView

@synthesize webView, url, browserTextField, spinner, activityItem;


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
	
	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(50, 6, 200, 28)];
	view.backgroundColor = [UIColor whiteColor];
	
	UITextField *text = [[UITextField alloc] initWithFrame:CGRectMake(5, 6, 194, 18)];
	text.text = url;
	text.font = [UIFont fontWithName:@"Arial" size:14];
	text.backgroundColor = [UIColor whiteColor];
	text.keyboardType = UIKeyboardTypeURL;
	text.clearButtonMode = UITextFieldViewModeWhileEditing;
	text.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;

	
	view.layer.borderWidth = 1;
	view.layer.cornerRadius = 4; //This is for achieving the rounded corner.	
	view.layer.borderColor = [[UIColor darkGrayColor] CGColor];
	
	[view addSubview:text];
	
	browserTextField = text;
	self.navigationItem.titleView = view;
	

	spinner = [[[UIActivityIndicatorView alloc]
                                         initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
    [spinner startAnimating];
	activityItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
	
    return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.browserTextField.text = self.url;
	NSLog(@"loading request for %@", self.url);
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
