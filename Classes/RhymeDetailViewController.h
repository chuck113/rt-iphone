#import <UIKit/UIKit.h>
#import "RootViewController.h"

@interface RhymeDetailViewController : UIViewController<UIWebViewDelegate>
{
	id<SearchCallback> searchCallbackDelegate;
	IBOutlet UILabel *artistTitleLabel;
	
	IBOutlet UIView *outerWebViewFrame;
	IBOutlet UIView *innerWebViewFrame;
	UIWebView *webView;
}

@property (nonatomic, retain) id<SearchCallback> searchCallbackDelegate;
@property (nonatomic, retain) UILabel *artistTitleLabel;
@property (nonatomic, retain) IBOutlet UIView *outerWebViewFrame;
@property (nonatomic, retain) IBOutlet UIView *innerWebViewFrame;
@property (nonatomic, retain) UIWebView *webView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil searchCallback:(id<SearchCallback>)searchCallback searchResult:(RhymePart *)searchResult;
@end
