#import "RhymeDetailViewController.h"
#import "RootViewController.h"
#import "HtmlBuilder.h"
#import "Constants.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "Three20/Three20.h"
#import "LyricsView.h"


@interface RhymeDetailViewController()

-(UILabel *)twitterLinkLabel;
-(UILabel *)iTunesLinkLabel;
-(CAGradientLayer *)gradient:(CGRect)frame;


@end


@implementation RhymeDetailViewController

@synthesize searchCallbackDelegate, artistLabel, titleLabel, outerWebViewFrame, innerWebViewFrame, webView, lyricsButton, itunesButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil searchCallback:(id<BeginSearchCallback>)searchCallback searchResult:(RhymePart *)searchResult
{
	if (!(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
        return nil;
	
	//CGRectMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
	CGRect myImageRect = CGRectMake(10.0f, 80.0f, 300.0f, 200.0f);
	UIView *view = [[UIView alloc] initWithFrame:myImageRect];
	view.backgroundColor = [UIColor blackColor];

	view.layer.cornerRadius = 6;

	view.layer.borderColor = [[UIColor grayColor] CGColor];
	view.layer.borderWidth = 1;
	
	NSSet *set = [searchResult wordsNotInIndexDeserialised];
	NSLog(@"other rhyme words are: %@", set);
	
	HtmlBuilder *htmlBuilder = [HtmlBuilder alloc]; 
	NSString *html = [htmlBuilder linesForDetailView:searchResult];
	NSLog(@"using string %@", html);
	self.searchCallbackDelegate = searchCallback;
    //self.title = [NSString stringWithFormat:@"\"%@\"", [[searchResult.word lowercaseString] capitalizedString]];
	
	UIWebView *webViewTmp = [[UIWebView alloc] initWithFrame:CGRectMake(15, 88, 292, 185)];
	[webViewTmp loadHTMLString:html baseURL:nil];
	[webViewTmp setDelegate:self];
	webViewTmp.backgroundColor = [UIColor clearColor];
	[webViewTmp setHidden:YES];
	self.webView = webViewTmp;
	
	CAGradientLayer *gradient = [self gradient:CGRectMake(0, 0, 320, 480)];

	[self.view.layer insertSublayer:gradient atIndex:0];
	
	self.artistLabel.text = [NSString stringWithFormat:@"%@", [searchResult.song.album.artist.name uppercaseString]];
	self.titleLabel.text = [NSString stringWithFormat:@"%@", searchResult.song.title];
	
	//[self.view addSubview:[self artistTitleLabel:searchResult.song.album.artist.name title:searchResult.song.title]];
	[self.view addSubview:view];
	[self.view addSubview:webView];
	//[self.view addSubview:[self iTunesLinkLabel]];
	//[self.view addSubview:[self twitterLinkLabel]];
	
	[webViewTmp release];

	[htmlBuilder dealloc];
	return self;
}

-(CAGradientLayer *)gradient:(CGRect)frame{
	CAGradientLayer *gradient = [CAGradientLayer layer];
	gradient.frame = frame;
	UIColor* darkerGrey = [UIColor colorWithRed:.05 green:.05 blue:.05 alpha:1];
	UIColor* lighterGrey = [UIColor colorWithRed:.30 green:.30 blue:.30 alpha:1];
	gradient.colors = [NSArray arrayWithObjects:(id)[darkerGrey CGColor], (id)[lighterGrey CGColor], nil];
	
	return gradient;
}


-(UILabel *)twitterLinkLabel{
	NSString* textString = @"twitter";
	UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(10, 315, 300, 40)];
	label.backgroundColor = [UIColor blackColor];
	label.text = textString;
	label.textColor = [UIColor whiteColor];
	label.lineBreakMode = UILineBreakModeWordWrap;
	label.numberOfLines = 2;
	return label;
}


-(UILabel *)iTunesLinkLabel{
	NSString* textString = @"Itunes";
	UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(10, 365, 300, 40)];
	label.backgroundColor = [UIColor blackColor];
	label.text = textString;
	label.textColor = [UIColor whiteColor];
	label.lineBreakMode = UILineBreakModeWordWrap;
	label.numberOfLines = 2;
	return label;
}

-(NSSet *)getOtherRhymeWords:(RhymePart *)searchResult{
	NSString* lines = [searchResult linesDeserialisedAsString];
	AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate]; 
	return [appDelegate.dataAccess rhymingWordsContainedIn:lines]; 
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[self performSelector:@selector(showWebView) withObject:nil afterDelay:.2];          
}

- (void)showWebView{
	[self.webView setHidden:NO];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
	
	if([[[request URL] absoluteString] isEqualToString:@"about:blank"]){
		return TRUE;
	}else{	
		NSArray* elements = [[[request URL] path] componentsSeparatedByString:@"/"];
		NSString* lastPathElement = [elements lastObject];
		NSLog(@"lastPathElement %@", lastPathElement);
		
		[searchCallbackDelegate setSearchTextAndDoSearch:lastPathElement];
		[self.navigationController popViewControllerAnimated:YES];
		
		return FALSE;
	}
}

-(IBAction)itunesButtonTouched{
	NSString *wuUrl = @"http://phobos.apple.com/us/artist/wu-tang-clan/id200986?uo=4";
	//NSString *wuUrl = @"http://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=284417350&mt=8";
	//[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:wuUrl]]];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:wuUrl]];
}

//
// TABLE DELEGATES
//

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	LyricsView *lyricsViewController = [[LyricsView alloc] initWithNibName:@"LyricsView" bundle:nil];
	
	lyricsViewController.url = @"http://www.google.com";
	
	//TODO dont' refer to app delegate
	AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate]; 	
	[appDelegate.navigationController pushViewController:lyricsViewController animated:YES];
	
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailId"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"detailId"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
	
	cell.textLabel.textColor = [UIColor whiteColor];
	cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0f];
	cell.textLabel.text = @"lyrics";
	cell.accessoryView = [[ UIImageView alloc ]  initWithImage:[UIImage imageNamed:@"AccDisclosure.png" ]];
	
	return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}


@end
