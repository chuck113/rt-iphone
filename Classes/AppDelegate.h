//
//  rhymeTimeNavigationAppDelegate.h
//  rhymeTimeNavigation
//
//  Created by Charles on 15/05/2010.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "RootViewController.h"
#import "DataAccess.h"


@interface AppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
	DataAccess *dataAccess;
}

@property (nonatomic, retain) DataAccess *dataAccess;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

