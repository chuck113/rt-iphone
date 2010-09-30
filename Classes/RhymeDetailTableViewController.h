//
//  RhymeDetailTableViewController.h
//  rhymeTimeNavigation
//
//  Created by Charles on 13/09/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RhymePart.h"
#import "RootViewController.h"
#import <QuartzCore/QuartzCore.h>


@protocol DetailItem

- (CGFloat)height;
- (void)configureCell:(UITableViewCell *)cell nav:(UINavigationController *)nav;
- (void)onSelect;

@end


@interface AbstractDetailItem : NSObject

RhymePart *rhymePart;
- (void)configureTextCell:(UITableViewCell *)cell text:(NSString *)text;

@end

@interface WebViewItem: AbstractDetailItem<DetailItem, UIWebViewDelegate>

	UIWebView *webView;
	UINavigationController* navController;
	id<BeginSearchCallback> searchCallbackDelegate;

-(CAGradientLayer *)gradient:(CGRect)frame;

@property (nonatomic, retain) UINavigationController* navController;

@end


@interface RhymeDetailTableViewController : UITableViewController<UIWebViewDelegate> {

	RhymePart *searchResult;
	NSArray *items;
	WebViewItem* webViewItem;
}

@property (nonatomic, retain, readonly) NSArray *items;
@property (nonatomic, retain, readonly) WebViewItem* webViewItem;


@end
