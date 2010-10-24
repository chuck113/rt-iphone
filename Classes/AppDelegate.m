//
//  rhymeTimeNavigationAppDelegate.m
//  rhymeTimeNavigation
//
//  Created by Charles on 15/05/2010.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"


@implementation AppDelegate

@synthesize window;
@synthesize mainViewController;
@synthesize navigationController;
@synthesize splashView;


#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application { 	
	splashView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
	splashView.image = [UIImage imageNamed:@"Default.png"];
	[window addSubview:splashView];
	[window bringSubviewToFront:splashView];
	
	// Do your time consuming setup
	[self performSelector:@selector( hideSplashView) withObject:nil afterDelay:0.5]; 
	
	self.mainViewController = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
	navigationController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
	
    [window makeKeyAndVisible];	
}

-(void)hideSplashView{
	[splashView removeFromSuperview];
	[splashView release];
	
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];
	[[UIApplication sharedApplication] setStatusBarHidden:NO];
	
	[window addSubview:navigationController.view];
    [window makeKeyAndVisible];
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[mainViewController release];
	[window release];
	[super dealloc];
}


@end

