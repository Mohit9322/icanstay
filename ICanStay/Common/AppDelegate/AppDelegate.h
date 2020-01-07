//
//  AppDelegate.h
//  ICanStay
//
//  Created by Namit Aggarwal on 23/02/16.
//  Copyright (c) 2016 Harry Patel (Hitaishin). All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "IQKeyboardManager.h"
#import <Google/SignIn.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,GIDSignInDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *strDeviceToken;
@property (nonatomic, strong) NSString *fromPageScrollController;

// Google Sign In Variables
@property (strong, nonatomic) NSString *Google_userId;
@property (strong, nonatomic) NSString *Google_idToken;
@property (strong, nonatomic) NSString *Google_name;
@property (strong, nonatomic) NSString *Google_email;
@property (strong, nonatomic) NSString *Google_Image_Url;


@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

