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
@synthesize dataAccess;
@synthesize navigationController;


#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application { 
	NSLog(@"started");
    // Override point for customization after app launch    
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];
	
	navigationController.view.backgroundColor = [UIColor blackColor];
	
	navigationController = [[UINavigationController alloc]
							initWithRootViewController:mainViewController];
	
	//[window addSubview:mainViewController.view];
	[window addSubview:navigationController.view];
    [window makeKeyAndVisible];
	self.dataAccess = [[DataAccess alloc] init];
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[mainViewController release];
	[window release];
	[dataAccess release];
	[super dealloc];
}


@end

