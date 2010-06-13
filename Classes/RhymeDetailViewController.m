#import "RhymeDetailViewController.h"
#import "RootViewController.h"
#import "HtmlBuilder.h"
#import "Constants.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>


@implementation RhymeDetailViewController

@synthesize searchCallbackDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil searchCallback:(id<SearchCallback>)searchCallback searchResult:(RhymePart *)searchResult
{
	if (!(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
        return nil;
	
	//CGRectMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
	CGRect myImageRect = CGRectMake(10.0f, 58.0f, 300.0f, 200.0f);
	UIImageView *imageView = [[UIImageView alloc] initWithFrame:myImageRect];
	[imageView setImage:[UIImage imageNamed:@"whiteBorder.png"]];

	
	NSSet *set = [searchResult wordsNotInIndexDeserialised];
	NSLog(@"other rhyme words are: %@", set);
	
	HtmlBuilder *htmlBuilder = [HtmlBuilder alloc]; 
	NSString *html = [htmlBuilder linesForDetailView:searchResult];
	NSLog(@"using string %@", html);
	self.searchCallbackDelegate = searchCallback;
    self.title = [NSString stringWithFormat:@"\"%@\"", [[searchResult.word lowercaseString] capitalizedString]];
	
	//[self.view setBackgroundColor:[UIColor darkGrayColor]];
	
	UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(12, 61, 292, 185)];
	[webView loadHTMLString:html baseURL:nil];
	[webView setDelegate:self];
	webView.backgroundColor = [UIColor clearColor];
	
	
	// background colour stuff
	CAGradientLayer *gradient = [CAGradientLayer layer];
	gradient.frame = CGRectMake(0, 0, 320, 480);
	UIColor* darkerGrey = [UIColor colorWithRed:.05 green:.05 blue:.05 alpha:1];
	UIColor* lighterGrey = [UIColor colorWithRed:.30 green:.30 blue:.30 alpha:1];
	gradient.colors = [NSArray arrayWithObjects:(id)[darkerGrey CGColor], (id)[lighterGrey CGColor], nil];
	[self.view.layer insertSublayer:gradient atIndex:0];
	
	[self.view addSubview:[self artistTitleLabel:searchResult.song.album.artist.name title:searchResult.song.title]];
	[self.view addSubview:imageView];
	[self.view addSubview:webView];
	[self.view addSubview:[self instructionLabel]];
	[self.view addSubview:[self iTunesLinkLabel]];
	[self.view addSubview:[self twitterLinkLabel]];

	[htmlBuilder dealloc];
	return self;
}

-(UILabel *)artistTitleLabel:(NSString *)artist title:(NSString *)title{
	UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 49)];
	label.backgroundColor = [UIColor clearColor];
	label.text = [NSString stringWithFormat:@"%@ - %@", [artist uppercaseString], title];
	label.textColor = [UIColor whiteColor];
	label.lineBreakMode = UILineBreakModeWordWrap;
	label.numberOfLines = 2;
	label.font = [UIFont boldSystemFontOfSize:20.0];
	return label;
}

-(UILabel *)instructionLabel{
	NSString* textString = @"Underlined words start new search";
	UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 262, 320, 23)];
	//UILabel* label = [[UILabel alloc] init];
	label.backgroundColor = [UIColor clearColor];
	label.textAlignment = UITextAlignmentCenter;
	label.text = textString;
	label.textColor = [UIColor lightGrayColor];
	label.font = [UIFont boldSystemFontOfSize:14.0];
	label.numberOfLines = 1;
	return label;
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


@end
