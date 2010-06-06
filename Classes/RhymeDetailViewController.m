#import "RhymeDetailViewController.h"
#import "RootViewController.h"
#import "HtmlBuilder.h"
#import "Constants.h"
#import "AppDelegate.h"


@implementation RhymeDetailViewController

@synthesize searchCallbackDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil searchCallback:(id<SearchCallback>)searchCallback searchResult:(RhymePart *)searchResult
{
	if (!(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
        return nil;
	
	//CGRectMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
	NSString* textString = @"WORD LOOKUP";
	UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 300, 40)];
	label.backgroundColor = [UIColor blackColor];
	label.text = textString;
	label.font = [UIFont fontWithName:@"DBLCDTempBlack" size:12.0];
	label.textColor = [UIColor whiteColor];
	label.lineBreakMode = UILineBreakModeWordWrap;
	label.numberOfLines = 2;
	//[self.view addSubview:label];
	
	CGRect myImageRect = CGRectMake(10.0f, 10.0f, 300.0f, 200.0f);
	UIImageView *imageView = [[UIImageView alloc] initWithFrame:myImageRect];
	[imageView setImage:[UIImage imageNamed:@"whiteBorder.png"]];

	
	NSSet *set = [searchResult wordsNotInIndexDeserialised];
	NSLog(@"other rhyme words are: %@", set);
	
	HtmlBuilder *htmlBuilder = [HtmlBuilder alloc]; 
	NSString *html = [htmlBuilder linesForDetailView:searchResult];
	NSLog(@"using string %@", html);
	self.searchCallbackDelegate = searchCallback;
    self.title = searchResult.word;
	
	[self.view setBackgroundColor:[UIColor blackColor]];

	
	UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(20, 30, 280, 170)];
	[webView loadHTMLString:html baseURL:nil];
	[webView setDelegate:self];
	webView.backgroundColor = [UIColor clearColor];
	
	[self.view addSubview:imageView];
	[self.view addSubview:webView];
	[self.view addSubview:[self iTunesLinkLabel]];
	
	
	[htmlBuilder dealloc];
	return self;
}

-(UILabel *)iTunesLinkLabel{
	NSString* textString = @"Itunes";
	UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(10, 230, 300, 40)];
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
	//}
	
	//NSArray* words = [searchResult.linesDeserialised componentsSeparatedByString:@" "];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
	
	if([[[request URL] absoluteString] isEqualToString:@"about:blank"]){
		return TRUE;
	}else{	
		NSArray* elements = [[[request URL] path] componentsSeparatedByString:@"/"];
		NSString* lastPathElement = [elements lastObject];
		NSLog(@"lastPathElement %@", lastPathElement);
		
		[self.navigationController popViewControllerAnimated:YES];
		[searchCallbackDelegate setSearchTextAndDoSearch:lastPathElement];
		return FALSE;
	}
}


@end
