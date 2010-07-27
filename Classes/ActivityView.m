    //
//  ActivityView.m
//  rhymeTimeNavigation
//
//  Created by Charles Kubicek on 26/06/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ActivityView.h"


@implementation ActivityView

@synthesize spinnerLabel;
@synthesize spinner;


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)init{
    if ((self = [super initWithNibName:nil bundle:nil])) {
        [self buildLabel];
    }
    return self;
}

- (void)buildLabel{
	spinner = [[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
	spinner.frame=CGRectMake(145, 130, 25, 25);
	spinner.tag  = 1;
	[self.spinner startAnimating];
	
	spinnerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 160, 320, 20)];
	spinnerLabel.textColor = [UIColor whiteColor];
	spinnerLabel.backgroundColor = [UIColor blackColor];
	spinnerLabel.font = [UIFont boldSystemFontOfSize:14.0];
	spinnerLabel.textAlignment = UITextAlignmentCenter;
	
	[self.view addSubview:spinnerLabel];
	[self.view addSubview:spinner];
}

- (void)updateText:(NSString *)text{
	self.spinnerLabel.text = text;
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
