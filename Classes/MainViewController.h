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
	IBOutlet UISearchBar *searchBar;
	
	UISearchDisplayController* searchDisplayController;
	IBOutlet UITableView *searchResultTableView;
	IBOutlet RootViewController *tableController;
	
}

@property (nonatomic, retain) IBOutlet UITableView *searchResultTableView;
@property (nonatomic, retain) UISearchDisplayController* searchDisplayController;
@property (nonatomic, retain) IBOutlet UIImage* titleImage;
@property (nonatomic, retain) IBOutlet UISearchBar* searchBar;
@property (nonatomic, retain) IBOutlet RootViewController* tableController;


@end