//
//  DASingleton.h
//  rhymeTimeNavigation
//
//  Created by Charles Kubicek on 10/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataAccess.h"

@interface DASingleton : NSObject {

}

-(DataAccess *)dataAccess;
+ (DASingleton*)instance;

@end
