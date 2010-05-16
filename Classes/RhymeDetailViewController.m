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
	NSString *html = [htmlBuilder linesForDetailView:searchResult];
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
	
	if([[[request URL] absoluteString] isEqualToString:@"about:blank"]){
		return TRUE;
	}else{	
		[self.navigationController popViewControllerAnimated:YES];
		[searchCallbackDelegate setSearchTextAndDoSearch:@"me"];
		return FALSE;
	}
}


@end
