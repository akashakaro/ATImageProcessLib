//
//  IPAppDelegate.h
//  ImageProcess
//
//  Created by Rakesh Kumar on 12/03/13.
//  Copyright (c) 2013 Akaro Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPNotificationView.h"
#import "Facebook.h"

@interface IPAppDelegate : UIResponder <UIApplicationDelegate,MPNotificationViewDelegate,FBSessionDelegate,FBRequestDelegate> {
    UINavigationController *navController;
    
    //Facebook
    Facebook *facebook;
    NSUserDefaults *perfs;
}

@property (strong, nonatomic) UINavigationController *navController;
@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


@property (strong, nonatomic) Facebook *facebook;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
