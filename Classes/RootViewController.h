//
//  RootViewController.h
//  rhymeTimeNavigation
//
//  Created by Charles on 15/05/2010.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "HtmlBuilder.h"
#import "ActivityView.h"
#import "NoResultsView.h"
#import "DataAccess.h"

@protocol HtmlLoadedCallback;

@protocol SearchCallback<NSObject>

@required

- (void)setSearchTextAndDoSearch:(NSString *)text;

@end


@interface RootViewController : UITableViewController<UISearchDisplayDelegate, SearchCallback, UISearchBarDelegate, HtmlLoadedCallback> {
	NSArray *searchResult;	
	HtmlBuilder* htmlBuilder;	
	UISearchBar* searchBar;
	NSArray* tableCellPool;
	NSArray* resultCache;
	
	ActivityView *activityView;
	NoResultsView *noResultsView;
	
	IBOutlet UITableView *searchResultTableView;
	IBOutlet UISearchDisplayController* searchDisplayController;
	NSMutableArray* filteredSearchSuggestions;
}

- (void)searchWorker:(NSString*)text;

//new methods
//- (void)updateResults:(NSArray*)results;

-(void)disableScrolling;
-(void)enableScrolling;

@property (nonatomic, retain) IBOutlet UITableView *searchResultTableView;
@property (nonatomic, retain) UISearchBar *searchBar;
@property (nonatomic, retain) NSArray *searchResult;
@property (nonatomic, retain) HtmlBuilder *htmlBuilder;
@property (nonatomic, retain) NSArray *cellCache;
@property (nonatomic, retain) NSArray *resultCache;
@property (nonatomic, retain) ActivityView *activityView;
@property (nonatomic, retain) NoResultsView *noResultsView;
@property (nonatomic, retain) UISearchDisplayController* searchDisplayController;
@property (nonatomic, retain) NSMutableArray* filteredSearchSuggestions;


@end







