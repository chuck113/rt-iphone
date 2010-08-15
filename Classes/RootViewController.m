#import "RootViewController.h"
#import "RhymeDetailViewController.h"
#import "HtmlBuilder.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "ActivityView.h"
#import "NoResultsView.h"
#import "Three20/Three20.h"
#import "RhymeTimeTTStyleSheet.h"

#import "ResultCell.h"

@interface RootViewController()

- (CGFloat)heightOfLinesString:(NSString *)string;
- (NSArray *)buildResultCells:(NSArray *)results;
- (void)searchPopulateAndReload:(NSString*)text;
- (void)showActivityView:(NSString*)text;;
- (void)hideActivityView;
- (void)reloadTableData;
- (void)beginSearch:(NSString *)text;
- (void)searchPopulateAndReloadInNewThread:(NSString*)text;

-(void)searchComplete:(NSDictionary*)resultParameters;
-(void)searchComplete:(NSArray*)result word:(NSString*)word;

bool isAwaitingResults = FALSE;


@end

@implementation RootViewController

@synthesize searchResult;
@synthesize htmlBuilder;
@synthesize searchBar;
@synthesize searchResultTableView;
@synthesize resultCache;
@synthesize activityView;
@synthesize noResultsView;
@synthesize searchDisplayController;
@synthesize filteredSearchSuggestions;

@synthesize resultCellFactory;
@synthesize dataAccess;

//
// Internal search  methods
//

-(void)setSearchTextAndDoSearch:(NSString *)text{
	self.searchDisplayController.searchBar.text = [text uppercaseString];
	[self.searchDisplayController.searchResultsTableView removeFromSuperview];
	
	self.searchResult = [NSArray array];
	isAwaitingResults = TRUE;
	
	[self reloadTableData];	
	[self beginSearch:text];
}

-(void)reloadTableData{
	[self.searchResultTableView setContentOffset:CGPointMake(0, 0) animated:NO];
	[self.searchResultTableView reloadData];
}

-(void)beginSearch:(NSString *)text{
	[self showActivityView:text];
	[self searchPopulateAndReloadInNewThread:text];
}


//
// search threading methods and callback
//

-(void)searchPopulateAndReloadInNewThread:(NSString*)text{
	[NSThread detachNewThreadSelector:@selector(searchWorker:) toTarget:self withObject:text];
}

-(void)searchWorker:(NSString*)text{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSArray* result = [dataAccess findRhymes:text]; 
	NSDictionary *resultParameters = [[NSDictionary alloc] initWithObjectsAndKeys:
		result, @"result",
		text, @"text",							  
		nil];
	[self performSelectorOnMainThread:@selector(searchComplete:) withObject:resultParameters waitUntilDone:NO];
    [pool release];
	
}

-(void)searchComplete:(NSDictionary*)resultParameters{
	NSArray *result = (NSArray *)[resultParameters objectForKey:@"result"];
	NSString *word = (NSString *)[resultParameters objectForKey:@"text"];
	
	[self searchComplete:result word:word];
}

-(void)searchComplete:(NSArray*)result word:(NSString*)word{
	[self performSelector:@selector(hideActivityView) withObject:nil afterDelay:1.5]; 
	[noResultsView.view removeFromSuperview];
	self.searchResult = result;
	
	if([result count] == 0){
		[noResultsView updateWord:word];
		[self hideActivityView];
		[self.view addSubview:noResultsView.view];
	}else{
		self.resultCache = [self buildResultCells:self.searchResult];
	}
	
	[self reloadTableData];
}

-(NSArray *)buildResultCells:(NSArray *)results{
	NSMutableArray* cellBuffer = [NSMutableArray array];
	
	for(RhymePart* part in results){
		ResultCell* cell = [resultCellFactory build:part];
		[cellBuffer addObject:cell];
	}
	
	return [NSArray arrayWithArray:cellBuffer]; 
}


//
// Table view methods
//

-(void)showActivityView:(NSString*)text{
	[activityView updateText:[NSString stringWithFormat:@"SEARCHING \"%@\"", [text uppercaseString]]];
	[self.view addSubview:activityView.view];
}

-(void)hideActivityView{
	[activityView.view removeFromSuperview];
	isAwaitingResults = FALSE;
	[self reloadTableData];
	
}


//
// View delegate methods
//

- (void)viewDidLoad {
    [super viewDidLoad];
	self.activityView = [[ActivityView alloc] init];
	self.noResultsView = [[NoResultsView alloc] init];
	self.filteredSearchSuggestions = [NSMutableArray arrayWithCapacity:0];
	
	resultCellFactory = [[ResultCellFactory alloc] init];
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
        NSInteger filteredSearchCount = [filteredSearchSuggestions count];
		if(filteredSearchCount == 0){
			return 1;
		}else{
			return filteredSearchCount > 40 ? 40 : filteredSearchCount;
		}
	}
	else
	{
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
		ResultCell* cell = [self.resultCache objectAtIndex:indexPath.row];
		return cell.calculatedHeight;
	}
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
	return cell;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (tableView == self.searchDisplayController.searchResultsTableView){	
		return [self createSearchResultCell:tableView cellForRowAtIndexPath:indexPath];
	}
	else
	{
		return [self.resultCache objectAtIndex:indexPath.row];
	}
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (tableView == self.searchDisplayController.searchResultsTableView){
		NSString *word = [filteredSearchSuggestions objectAtIndex:indexPath.row];
		[self enableScrolling];
		
		[filteredSearchSuggestions removeAllObjects];
		[self.searchDisplayController setActive:NO animated:TRUE];
		[self setSearchTextAndDoSearch:word];
    }
	else
	{
		self.navigationItem.title = @"back";
		RhymeDetailViewController *targetViewController = [[RhymeDetailViewController alloc] initWithNibName:@"RhymeDetailViewController" bundle:nil searchCallback:self searchResult:[self.searchResult objectAtIndex:indexPath.row]];
		
		//TODO dont' refer to app delegate
		AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate]; 	
		[appDelegate.navigationController pushViewController:targetViewController animated:YES];
		//[self.parentViewController.navigationController pushViewController:targetViewController animated:YES];
	}
}



//
// scroll disable/enabling methods to stop the user scrolling up the search result table and errouneously
// revealing the result table underneath
//

-(void)disableScrolling{
	self.tableView.scrollEnabled = NO;
}

-(void)enableScrolling{
	self.tableView.scrollEnabled = YES;
}




//
// async search methods
//

-(void)filterSearchPopulateAndReloadInNewThread:(NSString*)text{
	[NSThread detachNewThreadSelector:@selector(filterSearchWorker:) toTarget:self withObject:text];
}

-(void)filterSearchWorker:(NSString*)text{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSArray *results = [dataAccess rhymesWithPrefixCheap:text];
	
	[self performSelectorOnMainThread:@selector(filterSearchComplete:) withObject:results waitUntilDone:NO];
    [pool release];
	
}

-(void)filterSearchComplete:(NSArray*)results{
	[filteredSearchSuggestions removeAllObjects];
	
	for (NSString* st in results) {
		[filteredSearchSuggestions addObject:st];
	}
	
	[self.searchDisplayController.searchResultsTableView reloadData];
}

#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
	if([searchString length] > 2){
		[self filterSearchPopulateAndReloadInNewThread:searchString];
		return NO;
	}else{
		[filteredSearchSuggestions removeAllObjects];
		return YES;
	}
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    return NO;
}


-(void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView {
	tableView.backgroundColor = [UIColor blackColor];
	tableView.separatorColor = [UIColor colorWithRed:.15 green:.15 blue:.15 alpha:1];
}


@end


