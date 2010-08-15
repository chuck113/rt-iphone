    //
//  MainViewController.m
//  rhymeTimeNavigation
//
//  Created by Charles Kubicek on 20/07/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "AppDelegate.h"

@interface MainViewController()

-(void)disableRandomButton;

@end


@implementation MainViewController

@synthesize tableSearchBar, titleImage, searchDisplayController, searchResultTableView, tableController, randomButton;

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
	[searchBar resignFirstResponder];
	NSLog(@"search for %@", searchBar.text);
	
	[self.searchDisplayController.searchResultsTableView removeFromSuperview];
	
	[self.tableController enableScrolling];
	[self.tableController setSearchTextAndDoSearch:searchBar.text];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar {
	[self.tableController disableScrolling];
	self.randomButton.enabled = NO;
}
	 
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
	self.randomButton.enabled = YES;
}

- (NSArray*)findRhymes:(NSString *)toFind{
	return [dataAccess findRhymes:toFind];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:tableSearchBar contentsController:tableController];  
	[tableController setSearchDisplayController:searchDisplayController];
	
    [self.searchDisplayController setDelegate:tableController];  
    [self.searchDisplayController setSearchResultsDataSource:tableController];  
    [self.searchDisplayController setSearchResultsDelegate:tableController];
    [self.searchDisplayController release];
	
	UIImage *image = [UIImage imageNamed: @"header.png"];
	UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 2, 200, 40)];
	imageView.image = image;
	
	self.navigationItem.titleView = imageView;
	self.navigationController.navigationBar.tintColor = [UIColor blackColor];
	
	[imageView release];

	UIBarButtonItem *randomButtonTmp = [[UIBarButtonItem alloc] initWithTitle:@"RANDOM" 
                                                                  style:UIBarButtonItemStyleBordered 
                                                                 target:self 
                                                                 action:@selector(randomButtonTouched)];    
	
    self.navigationItem.rightBarButtonItem = randomButtonTmp;
	self.randomButton = randomButtonTmp;
	[randomButtonTmp release];
}

-(void)randomButtonTouched{
	NSString* randomWord = [dataAccess randomWord]; 
	tableSearchBar.text = randomWord;
	[self.searchDisplayController.searchResultsTableView removeFromSuperview];

	[tableController setSearchTextAndDoSearch:randomWord];
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

