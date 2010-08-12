    //
//  MainViewController.m
//  rhymeTimeNavigation
//
//  Created by Charles Kubicek on 20/07/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "AppDelegate.h"


@implementation MainViewController

@synthesize tableSearchBar, titleImage, searchDisplayController, searchResultTableView, tableController;

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
	[searchBar resignFirstResponder];
	NSLog(@"search for %@", searchBar.text);
	
	[self.tableController enableScrolling];
	[self.tableController updateResults:[self findRhymes:searchBar.text]];
}

- (void) searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar {
	[self.tableController disableScrolling];
}

- (NSArray*)findRhymes:(NSString *)toFind{
	AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate]; 
	return [appDelegate.dataAccess findRhymes:toFind]; 
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

	UIBarButtonItem *randomButton = [[UIBarButtonItem alloc] initWithTitle:@"RANDOM" 
                                                                  style:UIBarButtonItemStyleBordered 
                                                                 target:self 
                                                                 action:@selector(randomButtonTouched)];    
	
    self.navigationItem.rightBarButtonItem = randomButton;
	
	
}

-(void)randomButtonTouched{
	AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate]; 
	NSString* randomWord = [appDelegate.dataAccess randomWord]; 


	[tableController setSearchTextAndDoSearch:randomWord];
	//self.searchBar.text = @"walk";
	//NSLog(@"random");
}


//-(void)viewWillAppear:(BOOL)animated{
//	[self.navigationController setNavigationBarHidden:NO animated:animated];
//	[super viewWillAppear:animated];
//}
//
//- (void) viewWillDisappear:(BOOL)animated
//{
//	[self.navigationController setNavigationBarHidden:NO animated:animated];
//    [super viewWillDisappear:animated];
//}


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

