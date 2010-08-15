//
//  MainViewController.h
//  rhymeTimeNavigation
//
//  Created by Charles Kubicek on 20/07/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"


@interface MainViewController : UIViewController<UISearchBarDelegate> {
	
	IBOutlet UIImage *titleImage;
	IBOutlet UISearchBar *tableSearchBar;
	
	UISearchDisplayController* searchDisplayController;
	IBOutlet UITableView *searchResultTableView;
	IBOutlet RootViewController *tableController;
	UIBarButtonItem *randomButton;
	IBOutlet DataAccess *dataAccess;
}

- (NSArray*)findRhymes:(NSString *)toFind;

@property (nonatomic, retain) IBOutlet UITableView *searchResultTableView;
@property (nonatomic, retain) UISearchDisplayController* searchDisplayController;
@property (nonatomic, retain) IBOutlet UIImage* titleImage;
@property (nonatomic, retain) IBOutlet UISearchBar* tableSearchBar;
@property (nonatomic, retain) IBOutlet RootViewController* tableController;
@property (nonatomic, retain) UIBarButtonItem *randomButton;
@property (nonatomic, retain, readonly) IBOutlet DataAccess *dataAccess;

@end