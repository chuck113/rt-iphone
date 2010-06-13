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
- (void)buildSpinnerAndDisplay;
- (void)stopSinnerAndHide;
- (void)reloadTableData;
- (void)beginSearch:(NSString *)text;
- (void)searchPopulateAndReloadInNewThread:(NSString*)text;

NSUInteger htmlLoadingsComplete;

@end

@implementation RootViewController

@synthesize searchResult;
@synthesize htmlBuilder;
@synthesize searchBar;
@synthesize searchResultTableView;
@synthesize cellCache;
@synthesize spinner;
@synthesize spinnerLabel;
@synthesize tableCellPool;
@synthesize isAwaitingResults;

// html callback impl
- (void)htmlLoaded{
	htmlLoadingsComplete++;
	NSLog(@"now have %i callbacks", htmlLoadingsComplete);
	if(htmlLoadingsComplete == [searchResult count]){
		for(int i=0; i<[cellCache count]; i++){
			TableCellView *cell = [cellCache objectAtIndex:i];
			[cell setVisible];
		}
		[self performSelector:@selector(stopSinnerAndHide) withObject:nil afterDelay:3];   
	}
}

// DOMAIN METHODS
-(void)setSearchTextAndDoSearch:(NSString *)text{
	self.searchResult = [NSArray array];
	self.cellCache = [NSArray array];
	self.isAwaitingResults = TRUE;
	
	[self reloadTableData];
	[self.searchBar setText:text];	
	[self beginSearch:text];

}

-(void)reloadTableData{
	[self.searchResultTableView setContentOffset:CGPointMake(0, 0) animated:NO];
	[self.searchResultTableView reloadData];
}

-(void)beginSearch:(NSString *)text{
	[self buildSpinnerAndDisplay];
	[self searchPopulateAndReloadInNewThread:text];
	self.isAwaitingResults = TRUE;
}

-(void)buildSpinnerAndDisplay{
	self.spinner = [[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
	self.spinner.frame=CGRectMake(105, 160, 25, 25);
	self.spinner.tag  = 1;
	[self.spinner startAnimating];
	
	spinnerLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 160, 120, 20)];
	spinnerLabel.textColor = [UIColor whiteColor];
	spinnerLabel.backgroundColor = [UIColor blackColor];
	spinnerLabel.font = [UIFont boldSystemFontOfSize:14.0];
	spinnerLabel.text = @"SEARCHING...";
	[self.view addSubview:spinnerLabel];
	[self.view addSubview:self.spinner];
}

-(void)stopSinnerAndHide{
	[self.spinner stopAnimating];
	[self.spinner removeFromSuperview];
	[self.spinnerLabel removeFromSuperview];
	self.isAwaitingResults = FALSE;
	[self reloadTableData];
	
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBarRef {	
	// Make the keyboard go away.
	[searchBarRef resignFirstResponder];
	[self beginSearch:searchBarRef.text];
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
	self.cellCache = [self buildResultCells:self.searchResult];
	
	[self reloadTableData];
}


/**
 *	returns an array of rhymeParts
 */
- (NSArray*)findRhymes:(NSString *)toFind{
	AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate]; 
	return [appDelegate.dataAccess findRhymes:toFind]; 
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
	

	self.navigationItem.title = @"Rhyme Time";
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	UISearchBar *temp = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 320, 45)];
	temp.autocorrectionType=UITextAutocorrectionTypeNo;
	temp.autocapitalizationType=UITextAutocapitalizationTypeNone;
	temp.delegate=self;
	temp.tintColor = [UIColor clearColor];
	
	UINavigationBar *bar = [self.navigationController navigationBar]; 
	[bar setTintColor:[UIColor blackColor]]; 
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
	NSLog(@"get count, result is %@", (self.isAwaitingResults ? @"T" : @"F"));
	return self.isAwaitingResults ? 0 : [self.searchResult count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	RhymePart* rhymePart = (RhymePart*)[self.searchResult objectAtIndex:indexPath.row];
	//NSLog(@"called heightForRowAtIndexPath, returend %f", [self heightOfString:rhymePart.rhymeLines]); 
	
	return [self heightOfString:rhymePart.rhymeLines];
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

