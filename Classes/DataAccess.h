//
//  DataAccess.h
//  rhymeTimeIPhoneUI
//
//  Created by Charles on 15/05/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataAccess : NSObject {
	
	NSManagedObjectContext *managedObjectContext;
	NSPersistentStoreCoordinator *persistentStoreCoordinator;
	NSManagedObjectModel *managedObjectModel;
}

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;


- (NSArray*)findRhymes:(NSString *)toFind;
-(BOOL)containsWord:(NSString *)word;
-(NSSet *)rhymingWordsContainedIn:(NSString *)words;

- (void)onApplicationTermination:(UIApplication *)application;

@end
