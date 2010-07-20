    //
//  MainViewController.m
//  rhymeTimeNavigation
//
//  Created by Charles Kubicek on 20/07/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"


@implementation MainViewController

@synthesize searchBar, titleImage, searchDisplayController, searchResultTableView, tableController;

/*
 // The designated initializer. Override to perform setup that is required before the view is loaded.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
 // Custom initialization
 }
 return self;
 }
 */

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
	[searchBar resignFirstResponder];
	NSLog(@"search for %@", searchBar.text);
	[self.searchResultTableView setContentOffset:CGPointMake(0, 0) animated:NO];
	[self.searchResultTableView reloadData];
}

/*
 Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 
 }
 */



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:tableController];  
	
	[self performSelector:@selector(setSearchDisplayController:) withObject:searchDisplayController];
	
    [self.searchDisplayController setDelegate:self];  
    [self.searchDisplayController setSearchResultsDataSource:tableController];  
    [self.searchDisplayController setSearchResultsDelegate:tableController];
    [self.searchDisplayController release];
}



- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end

