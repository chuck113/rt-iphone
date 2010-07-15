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
#import "Three20/Three20.h"
#import "RhymeTimeTTStyleSheet.h"

@interface RootViewController()

- (NSArray*)findRhymes:(NSString *)toFind;
- (CGFloat)heightOfString:(NSString *)string;
- (CGFloat)heightOfLinesString:(NSString *)string;
- (NSArray *)buildResultCells:(NSArray *)results;
- (NSArray *)buildResultCellsNEW:(NSArray *)results;
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
@synthesize resultCache;
@synthesize activityView;
@synthesize noResultsView;
@synthesize searchDisplayController;
@synthesize filteredSearchSuggestions;

//
// Search Bar delegates
//

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBarRef {	
	// Make the keyboard go away.
	[searchBarRef resignFirstResponder];
	NSLog(@"search text was %@", searchBarRef.text);
	[self beginSearch:searchBarRef.text];
	[self.searchDisplayController setActive:NO animated:TRUE];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
	if([noResultsView.view isDescendantOfView:self.navigationController.view]){
		[noResultsView.view removeFromSuperview];
	}
}





//
// Html Loaded Delegates
//

- (void)htmlLoaded{
	htmlLoadingsComplete++;
	//NSLog(@"now have %i callbacks", htmlLoadingsComplete);
	if(htmlLoadingsComplete == [searchResult count]){
		for(int i=0; i<[cellCache count]; i++){
			TableCellView *cell = [cellCache objectAtIndex:i];
			[cell setVisible];
		}
		[self performSelector:@selector(hideActivityView) withObject:nil afterDelay:1];   
	}
}





//
// Internal search  methods
//

-(void)setSearchTextAndDoSearch:(NSString *)text{
	self.searchResult = [NSArray array];
	self.cellCache = [NSArray array];
	isAwaitingResults = TRUE;
	
	[self reloadTableData];
	
	self.searchBar.placeholder = text;
	[self beginSearch:text];
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




//
// search threading methods and callback
//

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
		self.resultCache = [self buildResultCellsNEW:self.searchResult];
	}
	
	[self reloadTableData];
}

-(NSArray *)buildResultCellsNEW:(NSArray *)results{
	NSMutableArray* cellBuffer = [NSMutableArray array];

	
	for(RhymePart* part in results){
		CGFloat linesStringheight = [self heightOfLinesString:part.rhymeLines];
		CGFloat titleStringHeight = 30.0f;
		CGFloat marginOffset = 5.0f;
		CGFloat cellHeight = linesStringheight + titleStringHeight + (marginOffset * 2);
		
		UITableViewCell* cell = [[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, 0)] autorelease];
		cell.accessoryView = [self accessoryView];
		
		UIColor* darkterGrey = [UIColor colorWithRed:.15 green:.15 blue:.15 alpha:1];
		CAGradientLayer *gradient = [CAGradientLayer layer];
		gradient.frame = CGRectMake(0, 0, 320, cellHeight);
		gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor blackColor] CGColor], (id)[darkterGrey CGColor], nil];
		
		NSString* linesHtml = [htmlBuilder buildHtmlLines320:part];
		NSLog(@"html is %@", linesHtml);
		TTStyledTextLabel *linesLabel = [[[TTStyledTextLabel alloc] initWithFrame:CGRectMake(5, 5, kLinesWidth, linesStringheight)] autorelease];
		linesLabel.backgroundColor = [UIColor clearColor];
		linesLabel.text = [TTStyledText textFromXHTML:linesHtml];
		//[linesLabel sizeToFit];
		
		UILabel *titlelabel = [[[UILabel alloc] initWithFrame: CGRectMake(5, linesStringheight + (marginOffset), kLinesWidth, titleStringHeight)] autorelease];
		titlelabel.text = [NSString stringWithFormat:@"%@ - %@", [part.song.album.artist.name uppercaseString], part.song.title];
		titlelabel.textColor = [UIColor lightGrayColor];
		titlelabel.font = [UIFont fontWithName:@"Helvetica" size:14];
		titlelabel.textAlignment = UITextAlignmentRight;
		titlelabel.backgroundColor = [UIColor clearColor]; 		

		[cell addSubview:linesLabel];
		[cell addSubview:titlelabel];
		[cell.layer insertSublayer:gradient atIndex:0];
		[cellBuffer addObject:cell];
	}
	
	return [NSArray arrayWithArray:cellBuffer]; 
}

- (UIView*)accessoryView{
	return [[ UIImageView alloc ]  initWithImage:[UIImage imageNamed:@"AccDisclosure.png" ]];
}

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





//
// Table view methods
//

-(void)showActivityView{
	[self.view addSubview:activityView.view];
}

-(void)hideActivityView{
	[activityView.view removeFromSuperview];
	isAwaitingResults = FALSE;
	[self reloadTableData];
	
}




//
// dataAccess search methods
//

- (NSArray*)findRhymes:(NSString *)toFind{
	AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate]; 
	return [appDelegate.dataAccess findRhymes:toFind]; 
}

- (NSArray*)rhymesWithPrefix:(NSString *)prefix{
	AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate]; 
	return [appDelegate.dataAccess rhymesWithPrefix:prefix]; 
}




//
// View delegate methods
//

- (void)viewDidLoad {
    [super viewDidLoad];
	self.htmlBuilder = [HtmlBuilder alloc];
	self.activityView = [[ActivityView alloc] init];
	self.noResultsView = [[NoResultsView alloc] init];
	self.filteredSearchSuggestions = [NSMutableArray arrayWithCapacity:0];
	
	self.navigationItem.title = @"Rhyme Time";
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

	[TTStyleSheet setGlobalStyleSheet:[[[RhymeTimeTTStyleSheet alloc] init] autorelease]];
	
	UISearchBar *searchBarTmp = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 320, 45)];
	searchBarTmp.autocorrectionType=UITextAutocorrectionTypeNo;
	searchBarTmp.autocapitalizationType=UITextAutocapitalizationTypeNone;
	searchBarTmp.delegate=self;
	searchBarTmp.tintColor = [UIColor clearColor];
	
	UINavigationBar *bar = [self.navigationController navigationBar]; 
	[bar setTintColor:[UIColor blackColor]]; 
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


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release anything that can be recreated in viewDidLoad or on demand.
	// e.g. self.myOutlet = nil;
}

- (void)dealloc {
	[self.htmlBuilder dealloc];
    [super dealloc];
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
		return [self heightOfLinesString:rhymePart.rhymeLines] + 45.0f;
	}
}

- (CGFloat)heightOfLinesString:(NSString *)string{
	struct CGSize size;
	size = [string sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:15] constrainedToSize:CGSizeMake(kLinesWidth, 10000) lineBreakMode:UILineBreakModeCharacterWrap];
	//NSLog(@"size for string %@ is: %f", string, (size.height +15.0f + 30.0f));
	//return size.height +15.0f + 30.0f;
	return size.height;
}


// TODO needs refinement
- (CGFloat)heightOfString:(NSString *)string{
	struct CGSize size;
	size = [string sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:16] constrainedToSize:CGSizeMake(kLinesWidth-20, kLinesWidth-20) lineBreakMode:UILineBreakModeCharacterWrap];
	//NSLog(@"size for string %@ is: %f", string, (size.height +15.0f + 30.0f));
	return size.height +15.0f + 30.0f;
}

- (UITableViewCell *)createSearchResultCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
	//NSLog(@"returning cell, index: %i", indexPath.row);
	return cell;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (tableView == self.searchDisplayController.searchResultsTableView){	
		return [self createSearchResultCell:tableView cellForRowAtIndexPath:indexPath];
	}
	else
	{
		//NSLog(@"cell is %@", [cellCache objectAtIndex:indexPath.row]);
		//return [cellCache objectAtIndex:indexPath.row];
		
//		NSString *kText = @"This is a test of styled labels.  Styled labels support \
//		<b>bold text</b>, <i>italic text</i>, <a href=\"http://google.com\">some link</a><span class=\"blueText\">colored text</span>, \
//		<span class=\"largeText\">font sizes</span>";
//		
//		TTStyledTextLabel *styledLabel = [[[TTStyledTextLabel alloc] initWithFrame:CGRectMake(0, 0, kLinesWidth, 50)] autorelease];
//		styledLabel.backgroundColor = [UIColor blackColor];
//		styledLabel.textColor = [UIColor whiteColor];
//		styledLabel.text = [TTStyledText textFromXHTML:kText lineBreaks:YES URLs:YES];
//		[styledLabel sizeToFit];
		
		
		//[self.layer insertSublayer:gradient atIndex:0];
		
		UITableViewCell *cell = [self.resultCache objectAtIndex:indexPath.row];
		//UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NONE"] autorelease];

		//TTStyledTextLabel *styledLabel = [self.resultCache objectAtIndex:indexPath.row];
		//[cell addSubview:styledLabel];
		return cell;
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
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {
}


-(void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView {
	tableView.backgroundColor = [UIColor blackColor];
	tableView.separatorColor = [UIColor colorWithRed:.15 green:.15 blue:.15 alpha:1];
}


@end

