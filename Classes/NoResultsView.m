    //
//  NoResultsView.m
//  rhymeTimeNavigation
//
//  Created by Charles Kubicek on 26/06/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NoResultsView.h"


@implementation NoResultsView

@synthesize noResults;


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)init{
    if ((self = [super initWithNibName:nil bundle:nil])) {
       	noResults = [[UILabel alloc] initWithFrame:CGRectMake(40, 120, 240, 50)];
		noResults.textColor = [UIColor whiteColor];
		noResults.backgroundColor = [UIColor blackColor];
		noResults.font = [UIFont boldSystemFontOfSize:14.0];
		noResults.textAlignment = UITextAlignmentCenter;
		noResults.numberOfLines = 2;
		noResults.lineBreakMode = UILineBreakModeWordWrap; 
		
		[self.view addSubview:noResults];
    }
    return self;
}


-(void)updateWord:(NSString*)newWord{
	noResults.text = [NSString stringWithFormat: @"NO RESULTS FOR\n\"%@\"", [newWord uppercaseString]];	
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
