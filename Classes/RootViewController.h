//
//  RootViewController.h
//  rhymeTimeNavigation
//
//  Created by Charles on 15/05/2010.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "TableCellView.h"
#import "HtmlBuilder.h"
#import "ActivityView.h"
#import "NoResultsView.h"

@protocol HtmlLoadedCallback;

@protocol SearchCallback<NSObject>

@required

- (void)setSearchTextAndDoSearch:(NSString *)text;

@end


@interface RootViewController : UITableViewController<SearchCallback, UISearchBarDelegate, HtmlLoadedCallback> {
	NSArray *searchResult;	
	HtmlBuilder* htmlBuilder;	
	NSArray* cellCache;
	UISearchBar* searchBar;
	NSArray* tableCellPool;
	
	ActivityView *activityView;
	NoResultsView *noResultsView;
	
	IBOutlet UITableView *searchResultTableView;
}

- (void)searchWorker:(NSString*)text;

@property (nonatomic, retain) IBOutlet UITableView *searchResultTableView;
@property (nonatomic, retain) UISearchBar *searchBar;
@property (nonatomic, retain) NSArray *searchResult;
@property (nonatomic, retain) HtmlBuilder *htmlBuilder;
@property (nonatomic, retain) NSArray *cellCache;
@property (nonatomic, retain) NSArray *tableCellPool;
@property (nonatomic, retain) UIActivityIndicatorView *spinner;
@property (nonatomic, retain) UILabel *spinnerLabel;
@property (nonatomic, retain) ActivityView *activityView;
@property (nonatomic, retain) NoResultsView *noResultsView;

@end







