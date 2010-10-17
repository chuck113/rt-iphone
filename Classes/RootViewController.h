//
//  RootViewController.h
//  rhymeTimeNavigation
//
//  Created by Charles on 15/05/2010.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "HtmlBuilder.h"
#import "ResultCell.h"
#import "ActivityView.h"
#import "NoResultsView.h"
#import "DataAccess.h"
#import "Search.h"
#import "InstructionsView.h"

@protocol HtmlLoadedCallback;

@protocol BeginSearchCallback<NSObject>

@required

- (void)setSearchTextAndDoSearch:(NSString *)text;

@end


@interface RootViewController : UITableViewController<UISearchDisplayDelegate, BeginSearchCallback, UISearchBarDelegate, SearchCallback> {
	NSArray *searchResult;	
	HtmlBuilder* htmlBuilder;	
	NSArray* tableCellPool;
	NSArray* resultCache;
	
	ActivityView *activityView;
	NoResultsView *noResultsView;
	InstructionsView *instructionsView;
	
	IBOutlet UITableView *searchResultTableView;
	IBOutlet UISearchDisplayController* searchDisplayController;
	NSMutableArray* filteredSearchSuggestions;
	
	ResultCellFactory* resultCellFactory;
	IBOutlet DataAccess *dataAccess;
	Search *search;
	
}

//-(void)searchWorker:(NSString*)text;

-(void)disableScrolling;
-(void)enableScrolling;

@property (nonatomic, retain) IBOutlet UITableView *searchResultTableView;
@property (nonatomic, retain) NSArray *searchResult;
@property (nonatomic, retain) NSArray *resultCache;
@property (nonatomic, retain) ActivityView *activityView;
@property (nonatomic, retain) InstructionsView *instructionsView;
@property (nonatomic, retain) NoResultsView *noResultsView;
@property (nonatomic, retain) UISearchDisplayController* searchDisplayController;
@property (nonatomic, retain) NSMutableArray* filteredSearchSuggestions;
@property (nonatomic, retain, readonly) ResultCellFactory* resultCellFactory;
@property (nonatomic, retain) IBOutlet DataAccess *dataAccess;
@property (nonatomic, retain, readonly) Search *search;


@end







