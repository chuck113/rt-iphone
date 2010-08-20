#import <UIKit/UIKit.h>
#import "RootViewController.h"

@interface RhymeDetailViewController : UIViewController<UIWebViewDelegate>
{
	id<BeginSearchCallback> searchCallbackDelegate;
	IBOutlet UILabel *artistLabel;
	IBOutlet UILabel *titleLabel;
	
	IBOutlet UIView *outerWebViewFrame;
	IBOutlet UIView *innerWebViewFrame;
	UIWebView *webView;
}

@property (nonatomic, retain) id<BeginSearchCallback> searchCallbackDelegate;
@property (nonatomic, retain, readonly) UILabel *artistLabel;
@property (nonatomic, retain, readonly) UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UIView *outerWebViewFrame;
@property (nonatomic, retain) IBOutlet UIView *innerWebViewFrame;
@property (nonatomic, retain) UIWebView *webView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil searchCallback:(id<BeginSearchCallback>)searchCallback searchResult:(RhymePart *)searchResult;
@end
