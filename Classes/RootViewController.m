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
#import "ActivityView.h"
#import "NoResultsView.h"

@interface RootViewController()

- (NSArray*)findRhymes:(NSString *)toFind;
- (CGFloat)heightOfString:(NSString *)string;
- (NSArray *)buildResultCells:(NSArray *)results;
- (void)searchPopulateAndReload:(NSString*)text;
- (void)showActivityView;
- (void)hideActivityView;
- (void)reloadTableData;
- (void)beginSearch:(NSString *)text;
- (void)searchPopulateAndReloadInNewThread:(NSString*)text;
- (NSArray*)rhymesWithPrefix:(NSString *)prefix;

NSUInteger htmlLoadingsComplete = 0;
bool isAwaitingResults = FALSE;

@end

@implementation RootViewController

@synthesize searchResult;
@synthesize htmlBuilder;
@synthesize searchBar;
@synthesize searchResultTableView;
@synthesize cellCache;
@synthesize tableCellPool;
@synthesize activityView;
@synthesize noResultsView;
@synthesize searchIsActive;
@synthesize searchDisplayController;
@synthesize filteredSearchSuggestions;

// html callback impl
- (void)htmlLoaded{
	htmlLoadingsComplete++;
	NSLog(@"now have %i callbacks", htmlLoadingsComplete);
	if(htmlLoadingsComplete == [searchResult count]){
		for(int i=0; i<[cellCache count]; i++){
			TableCellView *cell = [cellCache objectAtIndex:i];
			[cell setVisible];
		}
		[self performSelector:@selector(hideActivityView) withObject:nil afterDelay:1];   
	}
}

// DOMAIN METHODS
-(void)setSearchTextAndDoSearch:(NSString *)text{
	self.searchResult = [NSArray array];
	self.cellCache = [NSArray array];
	isAwaitingResults = TRUE;
	
	[self reloadTableData];
	
	self.searchBar.placeholder = text;
	self.searchBar.prompt = text;

	[self beginSearch:text];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
	NSLog(@"editing begun");
	if([noResultsView.view isDescendantOfView:self.navigationController.view]){
		[noResultsView.view removeFromSuperview];
	}
}

-(void)reloadTableData{
	[self.searchResultTableView setContentOffset:CGPointMake(0, 0) animated:NO];
	[self.searchResultTableView reloadData];
}

-(void)beginSearch:(NSString *)text{
	[self showActivityView];
	[self searchPopulateAndReloadInNewThread:text];
	isAwaitingResults = TRUE;
}

-(void)showActivityView{
	[self.view addSubview:activityView.view];
}

-(void)hideActivityView{
	[activityView.view removeFromSuperview];
	isAwaitingResults = FALSE;
	[self reloadTableData];
	
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBarRef {	
	// Make the keyboard go away.
	[searchBarRef resignFirstResponder];
	NSLog(@"search text was %@", searchBarRef.text);
	[self beginSearch:searchBarRef.text];
	[self.searchDisplayController setActive:NO animated:TRUE];
}

-(void)searchPopulateAndReloadInNewThread:(NSString*)text{
	[NSThread detachNewThreadSelector:@selector(searchWorker:) toTarget:self withObject:text];
}

-(void)searchWorker:(NSString*)text{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSArray* result = [self findRhymes:text];
	[self performSelectorOnMainThread:@selector(searchComplete:) withObject:result waitUntilDone:NO];
    [pool release];

}

-(void)searchComplete:(NSArray*)result{
	htmlLoadingsComplete = 0;
	self.searchResult = result;
	
	if([result count] == 0){
		[self hideActivityView];
		[self.view addSubview:noResultsView.view];
	}else{
		self.cellCache = [self buildResultCells:self.searchResult];
	}
	
	[self reloadTableData];
}


/**
 *	returns an array of rhymeParts
 */
- (NSArray*)findRhymes:(NSString *)toFind{
	AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate]; 
	return [appDelegate.dataAccess findRhymes:toFind]; 
}

- (NSArray*)rhymesWithPrefix:(NSString *)prefix{
	AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate]; 
	return [appDelegate.dataAccess rhymesWithPrefix:prefix]; 
}

/*
 Builds an array of TableCellView used to display results in the table
 */
-(NSArray *)buildResultCells:(NSArray *)results{
	NSMutableArray* cellBuffer = [NSMutableArray array];
	for(RhymePart* part in results){
		CGFloat height = [self heightOfString:part.rhymeLines];
		TableCellView* cell = [[[TableCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NEVER" height:height htmlCallback:self] autorelease];
		NSString* html = [htmlBuilder buildTableResult:part];
		[cell setLabelText:html];
		[cellBuffer addObject:cell];
	}

	return [NSArray arrayWithArray:cellBuffer]; 
}

// END DOMAIN METHODS


- (void)viewDidLoad {
    [super viewDidLoad];
	self.htmlBuilder = [HtmlBuilder alloc];
	self.activityView = [[ActivityView alloc] init];
	self.noResultsView = [[NoResultsView alloc] init];
	self.filteredSearchSuggestions = [NSMutableArray arrayWithCapacity:0];
	self.searchIsActive = [self.searchDisplayController isActive];
    
	self.navigationItem.title = @"Rhyme Time";
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	UISearchBar *searchBarTmp = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 320, 45)];
	searchBarTmp.autocorrectionType=UITextAutocorrectionTypeNo;
	searchBarTmp.autocapitalizationType=UITextAutocapitalizationTypeNone;
	searchBarTmp.delegate=self;
	searchBarTmp.tintColor = [UIColor clearColor];
	
	UINavigationBar *bar = [self.navigationController navigationBar]; 
	[bar setTintColor:[UIColor blackColor]]; 
	//self.navigationItem.titleView = searchBarTmp;
	self.tableView.tableHeaderView = searchBarTmp;
	self.searchBar = searchBarTmp;
	
	self.searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBarTmp contentsController:self];  

	[self performSelector:@selector(setSearchDisplayController:) withObject:searchDisplayController];
	
    [self.searchDisplayController setDelegate:self];  
    [self.searchDisplayController setSearchResultsDataSource:self];  
    [self.searchDisplayController setSearchResultsDelegate:self];
    [self.searchDisplayController release];  
	
	[searchBarTmp release];
}

-(void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView {
	tableView.backgroundColor = [UIColor blackColor];
	tableView.separatorColor = [UIColor colorWithRed:.15 green:.15 blue:.15 alpha:1];
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
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        if([filteredSearchSuggestions count] == 0){
			return 1;
		}else if([filteredSearchSuggestions count] > 40){
			return 40;
		}else{
			return [filteredSearchSuggestions count];
		}
	}
	else
	{
		NSLog(@"get count, result is %@", (isAwaitingResults ? @"T" : @"F"));
		return isAwaitingResults ? 0 : [self.searchResult count];
	}
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        return 40.0f;
    }
	else
	{
		RhymePart* rhymePart = (RhymePart*)[self.searchResult objectAtIndex:indexPath.row];
		//NSLog(@"called heightForRowAtIndexPath, returend %f", [self heightOfString:rhymePart.rhymeLines]); 
		
		return [self heightOfString:rhymePart.rhymeLines];
	}
}

// TODO needs refinement
- (CGFloat)heightOfString:(NSString *)string{
	struct CGSize size;
	size = [string sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:16] constrainedToSize:CGSizeMake(kLinesWidth-20, kLinesWidth-20) lineBreakMode:UILineBreakModeCharacterWrap];
	//NSLog(@"heightOfString %f for %@", size.height, string); 
	return size.height +15.0f + 30.0f;
}




// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (tableView == self.searchDisplayController.searchResultsTableView){	
		static NSString *CellIdentifier = @"searchResultId";
		
		UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
			
		}
        cell.textLabel.textColor = [UIColor whiteColor];
		cell.textLabel.font = [UIFont fontWithName:@"Arial-bold" size:16];
		cell.backgroundView.backgroundColor = [UIColor blackColor];
		if([filteredSearchSuggestions count] == 0){
			cell.textLabel.text = @"";
		}else {
			cell.textLabel.text = [filteredSearchSuggestions objectAtIndex:indexPath.row];
		}
		NSLog(@"returning cell, index: %i", indexPath.row);
		return cell;
    }
	else
	{
		NSLog(@"cell is %@", [cellCache objectAtIndex:indexPath.row]);
		return [cellCache objectAtIndex:indexPath.row];
	}
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (tableView == self.searchDisplayController.searchResultsTableView){	
		[self.searchDisplayController.searchResultsTableView removeFromSuperview];
		[self beginSearch:[filteredSearchSuggestions objectAtIndex:indexPath.row]];
		[filteredSearchSuggestions removeAllObjects];
		[self.searchDisplayController setActive:NO animated:TRUE];
    }
	else
	{
		self.navigationItem.title = @"back";

		RhymeDetailViewController *targetViewController = [[RhymeDetailViewController alloc] initWithNibName:@"RhymeDetailViewController" bundle:nil searchCallback:self searchResult:[self.searchResult objectAtIndex:indexPath.row]];
		[self.navigationController pushViewController:targetViewController animated:YES];
	}
}

#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
	NSLog(@"searchDisplayController, search string is %@", searchString);
	

	if([searchString length] > 2){
		AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate]; 
		NSArray *results = [appDelegate.dataAccess rhymesWithPrefix:searchString];
		
		[filteredSearchSuggestions removeAllObjects];
		
		for (NSString* st in results) {
			[filteredSearchSuggestions addObject:st];
		}
		
		return YES;
	}
	
	return NO;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    return NO;
}

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
	NSLog(@"searchDisplayControllerWillBeginSearch");
	self.searchIsActive = YES;
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {
	NSLog(@"searchDisplayControllerDidEndSearch");
	self.searchIsActive = NO;
}


- (void)dealloc {
	[self.htmlBuilder dealloc];
    [super dealloc];
}


@end

