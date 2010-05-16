#import <UIKit/UIKit.h>
#import "RootViewController.h"

@interface RhymeDetailViewController : UIViewController<UIWebViewDelegate>
{
	id<SearchCallback> searchCallbackDelegate;
}

@property (nonatomic, retain) id<SearchCallback> searchCallbackDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil searchCallback:(id<SearchCallback>)searchCallback searchResult:(RhymePart *)searchResult;
@end
