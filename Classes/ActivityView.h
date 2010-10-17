//
//  ActivityView.h
//  rhymeTimeNavigation
//
//  Created by Charles Kubicek on 26/06/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ActivityView : UIViewController {

	UILabel *spinnerLabel;
	UIActivityIndicatorView *spinner;
}

-(void)updateText:(NSString *)text;
- (void)buildLabel;

@property (nonatomic, retain) UILabel *spinnerLabel;
@property (nonatomic, retain) UIActivityIndicatorView *spinner;

@end
