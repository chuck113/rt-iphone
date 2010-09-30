//
//  LyricsView.h
//  rhymeTimeNavigation
//
//  Created by Charles on 22/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LyricsView : UIViewController<UIWebViewDelegate> {
	
	IBOutlet UIWebView *webView;
	NSString *url;
	UITextField *browserTextField; 
	UIActivityIndicatorView* spinner;
	UIBarButtonItem* activityItem;
}

@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) UIActivityIndicatorView* spinner;
@property (nonatomic, retain) UIBarButtonItem* activityItem;
@property (nonatomic, retain) UITextField *browserTextField;


@end
