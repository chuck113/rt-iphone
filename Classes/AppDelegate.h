//
//  rhymeTimeNavigationAppDelegate.h
//  rhymeTimeNavigation
//
//  Created by Charles on 15/05/2010.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "DataAccess.h"


@interface AppDelegate : NSObject <UIApplicationDelegate> {
    
    IBOutlet UIWindow *window;
	UINavigationController *navigationController;
	IBOutlet MainViewController* mainViewController;
}

@property (nonatomic, retain) UINavigationController *navigationController;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet MainViewController* mainViewController;

@end

