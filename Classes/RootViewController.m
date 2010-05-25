//
//  RootViewController.m
//  rhymeTimeNavigation
//
//  Created by Charles on 15/05/2010.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "RootViewController.h"
#import "RhymeDetailViewController.h"
#import "TableCellView.h"
#import "HtmlBuilder.h"
#import "AppDelegate.h"
#import "Constants.h"

@interface RootViewController()

- (NSArray*)findRhymes:(NSString *)toFind;
- (CGFloat)heightOfString:(NSString *)string;
- (NSArray *)buildResultCells:(NSArray *)results;
- (void)searchPopulateAndReload:(NSString*)text;

@end

@implementation RootViewController

@synthesize searchResult;
@synthesize htmlBuilder;
@synthesize searchBar;
@synthesize searchResultTableView;
@synthesize cellCache;

// DOMAIN METHODS
-(void)setSearchTextAndDoSearch:(NSString *)text{
	[self.searchBar setText:text];	
	[self searchPopulateAndReload:text];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBarRef {	
	// Make the keyboard go away.
	[searchBarRef resignFirstResponder];
	[self searchPopulateAndReload:searchBarRef.text];
}

-(void)searchPopulateAndReload:(NSString*)text{
	self.searchResult = [self findRhymes:text];
	self.cellCache = [self buildResultCells:self.searchResult];
	
	// Tell the UITableView to reload its data.	
	[self.searchResultTableView setContentOffset:CGPointMake(0, 0) animated:NO];
	[self.searchResultTableView reloadData];
}

/**
 *	returns an array of rhymeParts
 */
- (NSArray*)findRhymes:(NSString *)toFind{
	NSLog(@"Finding rhymes for word: %@", toFind);
	
	AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate]; 
	return [appDelegate.dataAccess findRhymes:toFind]; 
}

/*
 Builds an array of TableCellView used to display results in the table
 */
-(NSArray *)buildResultCells:(NSArray *)results{
	NSMutableArray* cellBuffer = [NSMutableArray array];
	for(RhymePart* part in results){
		//TODO do we need to pass height in here?
		CGFloat height = [self heightOfString:part.rhymeLines];
		TableCellView* cell = [[[TableCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NEVER" height:height] autorelease];
		NSString* html = [htmlBuilder buildTableResult:part];
		[cell setLabelText:html];
		cell.delegate = self;
		[cellBuffer addObject:cell];
	}

	return [NSArray arrayWithArray:cellBuffer]; 
}

// END DOMAIN METHODS


- (void)viewDidLoad {
    [super viewDidLoad];
	self.htmlBuilder = [HtmlBuilder alloc];
	

	self.navigationItem.title = @"Rhyme Time";
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	UISearchBar *temp = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 320, 45)];
	temp.autocorrectionType=UITextAutocorrectionTypeNo;
	temp.autocapitalizationType=UITextAutocapitalizationTypeNone;
	temp.delegate=self;
	
	//self.tableView.tableHeaderView=temp;
	self.navigationItem.titleView = temp;
	self.searchBar = temp;
	[temp release];
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release anything that can be recreated in viewDidLoad or on demand.
	// e.g. self.myOutlet = nil;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.searchResult count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	RhymePart* rhymePart = (RhymePart*)[self.searchResult objectAtIndex:indexPath.row];
	//NSLog(@"called heightForRowAtIndexPath, returend %f", [self heightOfString:rhymePart.rhymeLines]); 
	
	return [self heightOfString:rhymePart.rhymeLines];
}

// TODO needs refinement
- (CGFloat)heightOfString:(NSString *)string{
	struct CGSize size;
	size = [string sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:14] constrainedToSize:CGSizeMake(kLinesWidth-20, kLinesWidth-20) lineBreakMode:UILineBreakModeCharacterWrap];
	//NSLog(@"heightOfString %f for %@", size.height, string); 
	return size.height +15.0f + 30.0f;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSLog(@"cell is %@", [cellCache objectAtIndex:indexPath.row]);
	return [cellCache objectAtIndex:indexPath.row];
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	self.navigationItem.title = @"back";

	RhymeDetailViewController *targetViewController = [[RhymeDetailViewController alloc] initWithNibName:@"RhymeDetailViewController" bundle:nil searchCallback:self searchResult:[self.searchResult objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:targetViewController animated:YES];
}


- (void)dealloc {
	[self.htmlBuilder dealloc];
    [super dealloc];
}


@end

