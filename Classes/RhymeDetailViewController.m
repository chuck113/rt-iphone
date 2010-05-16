#import "RhymeDetailViewController.h"
#import "RootViewController.h"
#import "HtmlBuilder.h"
#import "Constants.h"


@implementation RhymeDetailViewController

@synthesize searchCallbackDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil searchCallback:(id<SearchCallback>)searchCallback searchResult:(RhymePart *)searchResult
{
	if (!(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
        return nil;

	HtmlBuilder *htmlBuilder = [HtmlBuilder alloc]; 
	NSString *html = [htmlBuilder buildHtmlLines:searchResult styleString:kDetailLineStyle withLinks:YES];
	self.searchCallbackDelegate = searchCallback;
    self.title = searchResult.word;
	UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
	[webView loadHTMLString:html baseURL:nil];
	[webView setDelegate:self];
	[self.view addSubview:webView];
	[htmlBuilder dealloc];
	return self;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
	//NSString* baseURL = [[request URL] baseURL];
	NSLog(@"[request URL] %@", [request URL] );
	NSLog(@"[[request URL] baseURL] %@", [[request URL] baseURL] );
	
	if([[[request URL] absoluteString] isEqualToString:@"about:blank"]){
		return TRUE;
	}else{	
		//RootViewController *targetViewController = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil];
		[self.navigationController popViewControllerAnimated:YES];
		[searchCallbackDelegate setSearchTextAndDoSearch:@"me"];
	return FALSE;
	}
}


@end
