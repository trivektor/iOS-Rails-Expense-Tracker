//
//  AppDelegate.h
//  ExpenseTrackr
//
//  Created by Tri Vuong on 10/12/12.
//  Copyright (c) 2012 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) UIViewController *centerController;
@property (strong, nonatomic) UIViewController *leftController;
@property (strong, nonatomic) UIViewController *rightController;

- (void)saveContext;
- (void)validateAuthenticationToken;
- (NSURL *)applicationDocumentsDirectory;

@end
