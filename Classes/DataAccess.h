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
	NSArray* allEntries;
	NSDictionary* prefixSearchMap;
}

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain) NSArray* allEntries;
@property (nonatomic, retain) NSDictionary* prefixSearchMap;


- (NSString *)randomWord;
- (NSArray*)findRhymes:(NSString *)toFind;
- (void)onApplicationTermination:(UIApplication *)application;
- (NSArray*)rhymesWithPrefix:(NSString *)prefix;
- (NSArray *)rhymesWithPrefixCheap:(NSString *)query;

-(void)buildEntriesAsyc;

@end
