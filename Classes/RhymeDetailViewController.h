#import <UIKit/UIKit.h>
#import "RootViewController.h"

@interface RhymeDetailViewController : UIViewController<UIWebViewDelegate, UITableViewDataSource>
{
	id<BeginSearchCallback> searchCallbackDelegate;
	IBOutlet UILabel *artistLabel;
	IBOutlet UILabel *titleLabel;
	
	IBOutlet UIView *outerWebViewFrame;
	IBOutlet UIView *innerWebViewFrame;
	
	IBOutlet UIButton *lyricsButton;
	IBOutlet UIButton *itunesButton;
	
	
	UIWebView *webView;
}

-(IBAction)itunesButtonTouched;

@property (nonatomic, retain) id<BeginSearchCallback> searchCallbackDelegate;
@property (nonatomic, retain, readonly) UILabel *artistLabel;
@property (nonatomic, retain, readonly) UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UIView *outerWebViewFrame;
@property (nonatomic, retain) IBOutlet UIView *innerWebViewFrame;
@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) IBOutlet UIButton *lyricsButton;
@property (nonatomic, retain) IBOutlet UIButton *itunesButton;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil searchCallback:(id<BeginSearchCallback>)searchCallback searchResult:(RhymePart *)searchResult;
@end
