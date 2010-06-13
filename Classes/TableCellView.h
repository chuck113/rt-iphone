//
//  TableCellView.h
//  play2-list-prototype
//
//  Created by Charles on 18/04/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"

@protocol SearchCallback;


@protocol HtmlLoadedCallback<NSObject>

@required

- (void)htmlLoaded;

@end

@interface TableCellView : UITableViewCell<UIWebViewDelegate> {
	UILabel *cellText;

	NSString *rawText;
	UIWebView *webView;
	id<HtmlLoadedCallback> htmlLoadedCallback;
	CGFloat htmlTextHeight;
}

@property (nonatomic, retain) UIWebView* webView;
@property (nonatomic, retain) NSString* rawText;
@property (nonatomic, assign) id<HtmlLoadedCallback> htmlLoadedCallback;
@property (nonatomic, assign) CGFloat htmlTextHeight;

- (void)setLabelText:(NSString *)_text;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier height:(CGFloat)height htmlCallback:(id<HtmlLoadedCallback>)htmlCallback;
- (void)setVisible;

@end

@protocol SearchBarCallback <NSObject>

@required
-(void)setSearchBarText:(NSString *)text;

@end
