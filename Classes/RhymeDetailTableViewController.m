//
//  RhymeDetailTableViewController.m
//  rhymeTimeNavigation
//
//  Created by Charles on 13/09/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RhymeDetailTableViewController.h"
#import "RhymeDetailViewController.h"
#import "RootViewController.h"
#import "HtmlBuilder.h"
#import "Constants.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "Three20/Three20.h"
#import "LyricsView.h"
#import "AppDelegate.h"




@implementation AbstractDetailItem : NSObject

- (void)configureTextCell:(UITableViewCell *)cell text:(NSString *)text{
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 320, 30)];
	label.textColor = [UIColor whiteColor];
	label.backgroundColor = [UIColor blackColor];
	label.text = text;
	[cell addSubview:label];
	cell.accessoryView = [[ UIImageView alloc ]  initWithImage:[UIImage imageNamed:@"AccDisclosure.png" ]];
}

-(id) initWithRhymePart:(RhymePart*)theRhymePart {
	 if ( self = [super init] ) {
		 rhymePart = theRhymePart;
	 }
	return self;
}
@end

@interface TitleItem: AbstractDetailItem<DetailItem>
@end

@implementation TitleItem

- (CGFloat)height{
	return 80.0f;
}

- (void)configureCell:(UITableViewCell *)cell nav:(UINavigationController *)nav{
	cell.selectionStyle = UITableViewCellSelectionStyleNone;

	UILabel *artistLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 320, 20)];
	artistLabel.textColor = [UIColor whiteColor];
	artistLabel.backgroundColor = [UIColor blackColor];
	artistLabel.text = [NSString stringWithFormat:@"%@", [rhymePart.song.album.artist.name uppercaseString]];
	
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 20, 320, 20)];
	titleLabel.textColor = [UIColor whiteColor];
	titleLabel.backgroundColor = [UIColor blackColor];
	titleLabel.text = [NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"%@", rhymePart.song.title]];
	
	[cell addSubview:artistLabel];
	[cell addSubview:titleLabel];
}

- (void)onSelect{
	// do nothing - should be unselectable
}

@end

@interface iTunesItem: AbstractDetailItem<DetailItem>
@end

@implementation iTunesItem

- (CGFloat)height{
	return 40.0f;
}

- (void)configureCell:(UITableViewCell *)cell nav:(UINavigationController *)nav{
	[self configureTextCell:cell text:@"iTunes"];
}

- (void)onSelect{
	NSString *url = [NSString stringWithFormat:@"http://phobos.apple.com/us/%@", rhymePart.song.album.iTunesUsId];
	//[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:wuUrl]]];
	
	
	//NSString *wuUrl = @"http://phobos.apple.com/us/artist/wu-tang-clan/id200986?uo=4";
	//NSString *wuUrl = @"http://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=284417350&mt=8";
	//[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:wuUrl]]];
	
	//[[UIApplication sharedApplication] openURL:[NSURL URLWithString:wuUrl]];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

@end
	 
@interface LyricsItem: AbstractDetailItem<DetailItem>

-(NSString *)encodeUrlString:(NSString *)unencodedString;
@end

@implementation LyricsItem

- (CGFloat)height{
	return 40.0f;
}

-(Boolean)hasSong{
	return [rhymePart.song.lwSongName length] > 0;
}

-(Boolean)hasArtist{
	return [rhymePart.song.album.artist.lwArtistName length] > 0;
}

-(Boolean)canSelect{
	return [self hasSong] || [self hasArtist]; 
}

- (void)configureCell:(UITableViewCell *)cell nav:(UINavigationController *)nav{
	if([self hasSong]){
		[self configureTextCell:cell text:@"Song Lyrics"];
	}else if([self hasArtist]){
		[self configureTextCell:cell text:@"Artist Lyrics"];
	}else{
		[self configureTextCell:cell text:@"(Lyrics Unavailable)"];
	}
}

- (void)onSelect{
	if ([self canSelect]) {
		LyricsView *targetViewController = [[LyricsView alloc] initWithNibName:@"LyricsView" bundle:nil];
		
		NSString *lwUrl = [NSString stringWithFormat:@"http://lyrics.wikia.com/%@:%@", 
						   [self encodeUrlString:rhymePart.song.album.artist.lwArtistName],
						  [self encodeUrlString:rhymePart.song.lwSongName]];
		
		NSLog(@"lyric wiki url is %@", lwUrl);
		targetViewController.url = lwUrl;
		
		AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate]; 	
		[appDelegate.navigationController pushViewController:targetViewController animated:YES];
	}
}

-(NSString *)encodeUrlString:(NSString *)unencodedString{
	return (NSString *)CFURLCreateStringByAddingPercentEscapes(
																				   NULL,
																				   (CFStringRef)unencodedString,
																				   NULL,
																				   (CFStringRef)@"!*'();:@&=+$,/?%#[]",
																				   kCFStringEncodingUTF8 );
}

@end


@implementation WebViewItem

@synthesize navController;


-(id) init:(RhymePart*)theRhymePart searchCallback:(id<BeginSearchCallback>)searchCallback{
	if ( self = [super init] ) {
		rhymePart = theRhymePart;
		searchCallbackDelegate = searchCallback;
	}
	return self;
}


- (CGFloat)height{
	return 300.0f;
}

- (void)configureCell:(UITableViewCell *)cell nav:(UINavigationController *)nav{
	self.navController = nav;
	CGRect myImageRect = CGRectMake(10.0f, 35.0f, 300.0f, 200.0f);
	UIView *view = [[UIView alloc] initWithFrame:myImageRect];
	view.backgroundColor = [UIColor blackColor];
	
	view.layer.cornerRadius = 6;
	
	view.layer.borderColor = [[UIColor grayColor] CGColor];
	view.layer.borderWidth = 1;
	
	CAGradientLayer *gradient = [self gradient:CGRectMake(0, 0, 320, 480)];
	
	[cell.layer insertSublayer:gradient atIndex:0];
	
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 320, 20)];
	titleLabel.textColor = [UIColor whiteColor];
	titleLabel.backgroundColor = [UIColor blackColor];
	titleLabel.text = @"New Search - use unerlined words";
	
	
	HtmlBuilder *htmlBuilder = [HtmlBuilder alloc]; 
	NSString *html = [htmlBuilder linesForDetailView:rhymePart];
	NSLog(@"using string %@", html);
	
	
	UIWebView *webViewTmp = [[UIWebView alloc] initWithFrame:CGRectMake(13, 40, 292, 185)];
	[webViewTmp loadHTMLString:html baseURL:nil];
	[webViewTmp setDelegate:self];
	webViewTmp.backgroundColor = [UIColor clearColor];
	[webViewTmp setHidden:YES];
	webView = webViewTmp;
	
	[cell addSubview:titleLabel];
	[cell addSubview:view];
	[cell addSubview:webView];
	
	
	[htmlBuilder release];
	[webViewTmp release];
}

- (void)onSelect{
	
}
	 
-(CAGradientLayer *)gradient:(CGRect)frame{
	CAGradientLayer *gradient = [CAGradientLayer layer];
	gradient.frame = frame;
	UIColor* darkerGrey = [UIColor colorWithRed:.05 green:.05 blue:.05 alpha:1];
	UIColor* lighterGrey = [UIColor colorWithRed:.30 green:.30 blue:.30 alpha:1];
	gradient.colors = [NSArray arrayWithObjects:(id)[darkerGrey CGColor], (id)[lighterGrey CGColor], nil];
	
	return gradient;
}
	 
- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[self performSelector:@selector(showWebView) withObject:nil afterDelay:.2];          
}

- (void)showWebView{
	[webView setHidden:NO];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
 
	if([[[request URL] absoluteString] isEqualToString:@"about:blank"]){
		return TRUE;
	}else{	
		NSArray* elements = [[[request URL] path] componentsSeparatedByString:@"/"];
		NSString* lastPathElement = [elements lastObject];
		NSLog(@"lastPathElement %@", lastPathElement);
		
		[searchCallbackDelegate setSearchTextAndDoSearch:lastPathElement];
		[self.navController popViewControllerAnimated:YES];
		
		return FALSE;
	}
}

@end


@implementation RhymeDetailTableViewController

@synthesize items, webViewItem;


#pragma mark -
#pragma mark View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil searchCallback:(id<BeginSearchCallback>)searchCallback searchResult:(RhymePart *)theSearchResult
{
	if (!(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
        return nil;
	
	searchResult = theSearchResult;
	searchCallbackDelegate = searchCallback;
		
	self.tableView.separatorColor = [UIColor darkGrayColor];
	webViewItem = [[WebViewItem alloc] init:theSearchResult searchCallback:searchCallback];
	
	
	items = [[NSArray alloc] initWithObjects:
					 [[TitleItem alloc] init], 
					  [[iTunesItem alloc] init], 
					 [[LyricsItem alloc] init],
					  webViewItem,
					 nil];
	
	return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
	webViewItem.navController = self.navigationController;
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.items count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return [[self.items objectAtIndex:indexPath.row] height];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    	
	[[self.items objectAtIndex:indexPath.row] configureCell:cell nav:self.navigationController];
	
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	return [[self.items objectAtIndex:indexPath.row] onSelect];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

