    //
//  RhymeTimeTTStyleSheet.m
//  rhymeTimeNavigation
//
//  Created by Charles Kubicek on 12/07/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Three20/Three20.h>
#import "RhymeTimeTTStyleSheet.h"

@implementation RhymeTimeTTStyleSheet


- (TTStyle*)linesStyle {
	return [TTBoxStyle styleWithPadding:UIEdgeInsetsMake(0, 0, 0, 0) next:
			[TTTextStyle styleWithFont:[UIFont fontWithName:@"Helvetica" size:15] color:[UIColor whiteColor] next:nil]];
}

- (TTStyle*)titleStyle {
	return [TTBoxStyle styleWithMargin:UIEdgeInsetsMake(-10, 0, 0, 0) next:
			[TTTextStyle styleWithFont:[UIFont fontWithName:@"Helvetica" size:14] color:[UIColor darkGrayColor] textAlignment:UITextAlignmentRight next:nil]];
}

- (TTStyle*)instructionsStyle {
	return [TTBoxStyle styleWithMargin:UIEdgeInsetsMake(5, 0, 0, 0) next:
			[TTTextStyle styleWithFont:[UIFont fontWithName:@"Arial" size:18] color:[UIColor grayColor] textAlignment:UITextAlignmentCenter next:nil]];
}

//- (TTStyle*)blueText {
//	return [TTTextStyle styleWithColor:[UIColor blueColor] next:nil];
//}
//
//- (TTStyle*)largeText {
//	return [TTTextStyle styleWithFont:[UIFont systemFontOfSize:32] next:nil];
//}
//
//- (TTStyle*)smallText {
//	return [TTTextStyle styleWithFont:[UIFont systemFontOfSize:12] next:nil];
//}
//
//- (TTStyle*)floated {
//	return [TTBoxStyle styleWithMargin:UIEdgeInsetsMake(0, 0, 5, 5)
//							   padding:UIEdgeInsetsMake(0, 0, 0, 0)
//							   minSize:CGSizeZero position:TTPositionFloatLeft next:nil];
//}
//
//- (TTStyle*)blueBox {
//	return
//    [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:6] next:
//	 [TTInsetStyle styleWithInset:UIEdgeInsetsMake(0, -5, -4, -6) next:
//	  [TTShadowStyle styleWithColor:[UIColor grayColor] blur:2 offset:CGSizeMake(1,1) next:
//	   [TTSolidFillStyle styleWithColor:[UIColor cyanColor] next:
//		[TTSolidBorderStyle styleWithColor:[UIColor grayColor] width:1 next:nil]]]]];
//}
//
//- (TTStyle*)inlineBox {
//	return
//    [TTSolidFillStyle styleWithColor:[UIColor blueColor] next:
//	 [TTBoxStyle styleWithPadding:UIEdgeInsetsMake(5,13,5,13) next:
//	  [TTSolidBorderStyle styleWithColor:[UIColor blackColor] width:1 next:nil]]];
//}
//
//- (TTStyle*)inlineBox2 {
//	return
//    [TTSolidFillStyle styleWithColor:[UIColor cyanColor] next:
//	 [TTBoxStyle styleWithMargin:UIEdgeInsetsMake(5,50,0,50)
//						 padding:UIEdgeInsetsMake(0,13,0,13) next:nil]];
//}

@end
