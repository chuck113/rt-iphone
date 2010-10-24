//
//  MotionWindow.m
//  rhymeTimeNavigation
//
//  Created by Charles on 24/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MotionWindow.h"


@implementation MotionWindow

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (event.type == UIEventTypeMotion && event.subtype == UIEventSubtypeMotionShake) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DeviceShaken" object:self];
    }
}

@end
