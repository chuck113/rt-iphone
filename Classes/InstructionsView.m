//
//  InstructionsView.m
//  rhymeTimeNavigation
//
//  Created by Charles Kubicek on 17/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "InstructionsView.h"
#import "Three20/Three20.h"

@implementation InstructionsView

@synthesize instructionLabel;

- (id)init{
    if ((self = [super initWithNibName:nil bundle:nil])) {
		
		TTStyledTextLabel *label = [[[TTStyledTextLabel alloc] initWithFrame:CGRectMake(20, 0, 280, 100)] autorelease];
		label.backgroundColor = [UIColor blackColor];
		
		NSString *text = @"<span class='instructionsStyle'>Enter a word into the search box or touch <img height=\"20%\" width=\"20%\" src=\"bundle://R.png\"/> for a random word.</span>";

		label.text = [TTStyledText textFromXHTML:text];
		
		
//		instructionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 280, 100)];
//		instructionLabel.text = @"Enter a word into the seearch box or touch for a random word.";
//		instructionLabel.font = [UIFont fontWithName:@"Arial" size:18.0f];
//		instructionLabel.numberOfLines = 3;
//		instructionLabel.textAlignment = UITextAlignmentCenter;
//		instructionLabel.textColor = [UIColor lightGrayColor];
//		instructionLabel.backgroundColor = [UIColor blackColor];
		
        [self.view addSubview:label];
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}


@end
