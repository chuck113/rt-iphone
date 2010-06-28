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
        [self buildLabel];
    }
    return self;
}

- (void)buildLabel{
	noResults = [[UILabel alloc] initWithFrame:CGRectMake(80, 160, 220, 20)];
	noResults.textColor = [UIColor whiteColor];
	noResults.backgroundColor = [UIColor blackColor];
	noResults.font = [UIFont boldSystemFontOfSize:14.0];
	noResults.text = @"NO RESULTS, TRY AGAIN";
	
	[self.view addSubview:noResults];
}


/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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
