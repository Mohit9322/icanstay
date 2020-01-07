//
//  AppDelegate.m
//  ICanStay
//
//  Created by Namit Aggarwal on 23/02/16.
//  Copyright (c) 2016 Harry Patel (Hitaishin). All rights reserved.
//

#import "AppDelegate.h"
#import "MMDrawerController.h"
#import "HomeScreenController.h"
#import "SideMenuController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <Google/Analytics.h>
#import <MoEngage.h>
#import "MapScreen.h"
#import "BuyCouponViewController.h"
#import "MyWishlistViewController.h"
#import "PackagesViewController.h"
#import "CitiesViewController.h"
#import "MyWishlistViewController.h"
#import "Branch.h"
#import <AdSupport/AdSupport.h>
#import <TwitterKit/TwitterKit.h>

#define FACEBOOK_SCHEME  @"fb466010770273280"

@interface AppDelegate ()
{
    int manangeRegisterNotificationDeviceToken;
     NSMutableArray  *arr_result;
}
@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;
@property UINavigationController *navControllerDeepLink;
@property (nonatomic, strong) NSURL *launchedURL;
@end

@implementation AppDelegate
@synthesize fromPageScrollController = _fromPageScrollController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    Branch *branch = [Branch getInstance];
    [branch initSessionWithLaunchOptions:launchOptions andRegisterDeepLinkHandler:^(NSDictionary *params, NSError *error) {
        if (!error && params) {
            // params are the deep linked params associated with the link that the user clicked -> was re-directed to this app
            // params will be empty if no data found
            // ... insert custom logic here ...
            NSLog(@"params: %@", params.description);
        }
    }];
    
//#ifdef DEBUG
//    [[MoEngage sharedInstance] initializeDevWithApiKey:@"YH8IDWGG3QSB923GTDN7BRP9" inApplication:application withLaunchOptions:launchOptions openDeeplinkUrlAutomatically:YES];
//#else
//    [[MoEngage sharedInstance] initializeProdWithApiKey:@"YH8IDWGG3QSB923GTDN7BRP9" inApplication:application withLaunchOptions:launchOptions openDeeplinkUrlAutomatically:YES];
//#endif
  
    [[Twitter sharedInstance] startWithConsumerKey:@"cLlNKQKOvnJwTdUbyQql7gxA6" consumerSecret:@"0QrPXkw1FUbMpwszAZ8aBypIX0ushJz2LRO8cfmpi1wodGpf5O"];
    
#ifdef DEBUG
    [[MoEngage sharedInstance] initializeDevWithApiKey:@"YH8IDWGG3QSB923GTDN7BRP9" inApplication:application withLaunchOptions:launchOptions openDeeplinkUrlAutomatically:YES];
#else
    [[MoEngage sharedInstance] initializeProdWithApiKey:@"YH8IDWGG3QSB923GTDN7BRP9" inApplication:application withLaunchOptions:launchOptions openDeeplinkUrlAutomatically:YES];
#endif

    
    [[MoEngage sharedInstance] registerForRemoteNotificationWithCategories:nil andCategoriesForPreviousVersions:nil andWithUserNotificationCenterDelegate:self];
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeAlert |
          UIRemoteNotificationTypeBadge |
          UIRemoteNotificationTypeSound)];
    } else {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge|UIUserNotificationTypeAlert | UIUserNotificationTypeSound) categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    
     self.launchedURL = [launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];
    
     self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
    globals.isFirstTimeFromPageScrollController = true;
    
//     if ([self needsUpdate]) {
//          globals.isShowVersionUpdatePopup = @"YES";
//         HomeScreenController *vcHomeScreen = [storyboard instantiateViewControllerWithIdentifier:@"HomeScreenController"];
//         SideMenuController *vcSideMenu =     [storyboard instantiateViewControllerWithIdentifier:@"SideMenuController"];
//         
//         MMDrawerController *drawerController = [[MMDrawerController alloc]initWithCenterViewController:vcHomeScreen
//                                                                               leftDrawerViewController:vcSideMenu];
//         [drawerController setRestorationIdentifier:@"MMDrawer"];
//         
//         
//         [drawerController setMaximumLeftDrawerWidth:SCREEN_WIDTH*2/3];
//         
//         [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
//         [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
//         drawerController.shouldStretchDrawer = NO;
//         
//         UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:drawerController];
//         [navController setNavigationBarHidden:YES];
//         [self.window setRootViewController:navController];
//         [self.window makeKeyAndVisible];
//     }else if (![self needsUpdate]){
        globals.isShowVersionUpdatePopup = @"NO";
         HomeScreenController *vcHomeScreen = [storyboard instantiateViewControllerWithIdentifier:@"HomeScreenController"];
         SideMenuController *vcSideMenu =     [storyboard instantiateViewControllerWithIdentifier:@"SideMenuController"];
         
         MMDrawerController *drawerController = [[MMDrawerController alloc]initWithCenterViewController:vcHomeScreen
                                                                               leftDrawerViewController:vcSideMenu];
         [drawerController setRestorationIdentifier:@"MMDrawer"];
         
         
         [drawerController setMaximumLeftDrawerWidth:SCREEN_WIDTH*2/3];
         
         [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
         [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
         drawerController.shouldStretchDrawer = NO;
         
         UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:drawerController];
         [navController setNavigationBarHidden:YES];
         [self.window setRootViewController:navController];
         [self.window makeKeyAndVisible];
//     }
   
    //APN Setup
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    
    
//     BOOL isUserLoggedIn= [[ICSingletonManager sharedManager] detectingIfUserLoggedIn];
//    
//    if (isUserLoggedIn == NO) {
//        HomePageScrollViewController *pageScrollController = [storyboard instantiateViewControllerWithIdentifier:@"HomePageScrollViewController"];
//        UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:pageScrollController];
//        [navController setNavigationBarHidden:YES];
//        [self.window setRootViewController:navController];
//        [self.window makeKeyAndVisible];
//    }else if (isUserLoggedIn == YES){
//     
    
    
        
        manangeRegisterNotificationDeviceToken = 0;
//    }

    
    
    [GMSServices provideAPIKey:KGoogleMapApiKey];
    
    //// Google Sign In intilize
    NSError* configureError;
    [[GGLContext sharedInstance] configureWithError: &configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    [GIDSignIn sharedInstance].delegate = self;
    
    [GIDSignIn sharedInstance].shouldFetchBasicProfile = YES;
    
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    // 2
    [[GAI sharedInstance].logger setLogLevel:kGAILogLevelVerbose];
    
    // 3
    [GAI sharedInstance].dispatchInterval = 20;
    
    // 4
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-88094444-1"];
    

    
    // Optional: configure GAI options.
    GAI *gai = [GAI sharedInstance];
    gai.trackUncaughtExceptions = YES;  // report uncaught exceptions
    gai.logger.logLevel = kGAILogLevelVerbose;  // remove before app release
    
    //Facebook intilize
    [FBSDKLoginButton class];
    [FBSDKAccessToken setCurrentAccessToken:nil];
    FBSDKLoginManager *logMeOut = [[FBSDKLoginManager alloc] init];
    [logMeOut logOut];
    return [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 10.0) {
        NSDictionary *pushDictionary = [launchOptions valueForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (pushDictionary) {
            [self customPushHandler:pushDictionary];
        }
    [MoEngage debug:LOG_ALL];
    return YES;
}
}


// Respond to Universal Links
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray *restorableObjects))restorationHandler {
    BOOL handledByBranch = [[Branch getInstance] continueUserActivity:userActivity];
    
    return handledByBranch;
}

-(BOOL) needsUpdate{
    NSDictionary* infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString* appID = infoDictionary[@"CFBundleIdentifier"];
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?bundleId=%@", appID]];
    NSData* data = [NSData dataWithContentsOfURL:url];
    NSDictionary* lookup = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    if ([lookup[@"resultCount"] integerValue] == 1){
        NSString* appStoreVersion = lookup[@"results"][0][@"version"];
        NSString* currentVersion = infoDictionary[@"CFBundleShortVersionString"];
        if (![appStoreVersion isEqualToString:currentVersion]){
            NSLog(@"Need to update [%@ != %@]", appStoreVersion, currentVersion);
            return YES;
        }
    }
    return NO;
}
- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    NSDictionary *userInfo = request.content.userInfo;
    
    // LP_URL is the key that is used from Leanplum to
    // send the image URL in the payload.
    //
    // If there is no LP_URL in the payload than
    // the code will still show the push notification.
    if (userInfo == nil || userInfo[@"LP_URL"] == nil) {
        self.contentHandler(self.bestAttemptContent);
        return;
    }
    
    NSString *attachmentMedia = userInfo[@"LP_URL"];
    
    // If there is an image in the payload, this part
    // will handle the downloading and displaying of the image.
    if (attachmentMedia) {
        NSURL *URL = [NSURL URLWithString:attachmentMedia];
        NSURLSession *LPSession = [NSURLSession sessionWithConfiguration:
                                   [NSURLSessionConfiguration defaultSessionConfiguration]];
        [[LPSession downloadTaskWithURL:URL completionHandler: ^(NSURL *temporaryLocation, NSURLResponse *response, NSError *error) {
            if (error) {
                NSLog(@"Leanplum: Error with downloading rich push: %@",
                      [error localizedDescription]);
                self.contentHandler(self.bestAttemptContent);
                return;
            }
            
            NSString *fileType = [self determineType: [response MIMEType]];
            NSString *fileName = [[temporaryLocation.path lastPathComponent] stringByAppendingString:fileType];
            NSString *temporaryDirectory = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
            [[NSFileManager defaultManager] moveItemAtPath:temporaryLocation.path toPath:temporaryDirectory error:&error];
            
            NSError *attachmentError = nil;
            UNNotificationAttachment *attachment =
            [UNNotificationAttachment attachmentWithIdentifier:@""
                                                           URL:[NSURL fileURLWithPath:temporaryDirectory]
                                                       options:nil
                                                         error:&attachmentError];
            if (attachmentError != NULL) {
                NSLog(@"Leanplum: Error with the rich push attachment: %@",
                      [attachmentError localizedDescription]);
                self.contentHandler(self.bestAttemptContent);
                return;
            }
            self.bestAttemptContent.attachments = @[attachment];
            self.contentHandler(self.bestAttemptContent);
            [[NSFileManager defaultManager] removeItemAtPath:temporaryDirectory error:&error];
        }] resume];
    }
    
}

- (NSString*)determineType:(NSString *) fileType {
    // Determines the file type of the attachment to append to NSURL.
    if ([fileType isEqualToString:@"image/jpeg"]){
        return @".jpg";
    }
    if ([fileType isEqualToString:@"image/gif"]) {
        return @".gif";
    }
    if ([fileType isEqualToString:@"image/png"]) {
        return @".png";
    } else {
        return @".tmp";
    }
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
   [[MoEngage sharedInstance] stop:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
//    LoginManager *login = [[LoginManager alloc]init];
//    if ([[login isUserLoggedIn] count]>0)
//    {
//        SideMenuController *vcSideMenu = [[SideMenuController alloc]init];
//        [vcSideMenu startServiceToGetCouponsDetails];
//    }
    
    
    [[MoEngage sharedInstance] applicationWillEnterForeground:application];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    if (self.launchedURL) {
        [self openLink:self.launchedURL];
        self.launchedURL = nil;
    }
    //Facebook activation calling
    [FBSDKAppEvents activateApp];
    [[MoEngage sharedInstance] applicationBecameActiveinApplication:application];

}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
    [[MoEngage sharedInstance] applicationTerminated:application];
}

#pragma mark - Open URL Methods


//// code for google and facebook integration
//- (BOOL)application:(UIApplication *)app  openURL:(NSURL *)url options:(NSDictionary *)options {
//    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//    if([[url host] isEqualToString:@"page"]){
//        if([[url path] isEqualToString:@"/HomeScreen"]){
//            HomeScreenController *vcHomeScreen = [storyboard instantiateViewControllerWithIdentifier:@"HomeScreenController"];
//            UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:vcHomeScreen];
//            [navController setNavigationBarHidden:YES];
//            [self.window setRootViewController:navController];
//            [self.window makeKeyAndVisible];
//            
//        }
//        else if([[url path] isEqualToString:@"/MapScreen"]){
//           
//           HomeScreenController *vcHomeScreen = [storyboard instantiateViewControllerWithIdentifier:@"HomeScreenController"];
//            UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:vcHomeScreen];
//            [navController setNavigationBarHidden:YES];
//            [self.window setRootViewController:navController];
//            [self.window makeKeyAndVisible];
//            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Search Your Stay" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"By Current Location",@"By City", nil];
//            [alert show];        }
//        else if([[url path] isEqualToString:@"/BuyVoucher"]){
//            
//            BuyCouponViewController *buyCoupon =[storyboard instantiateViewControllerWithIdentifier:@"BuyCouponViewController"];
//            UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:buyCoupon];
//            [navController setNavigationBarHidden:YES];
//            [self.window setRootViewController:navController];
//            [self.window makeKeyAndVisible];      }
//        else if([[url path] isEqualToString:@"/MyWishList"]){
//         
//            MyWishlistViewController *buyCoupon =[storyboard instantiateViewControllerWithIdentifier:@"MyWishlistViewController"];
//            UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:buyCoupon];
//            [navController setNavigationBarHidden:YES];
//            [self.window setRootViewController:navController];
//            [self.window makeKeyAndVisible];
//        }
//        
//        return YES;
//    }
//    else{
//        if ([[url scheme] isEqualToString:FACEBOOK_SCHEME])
//        {
//            return [[FBSDKApplicationDelegate sharedInstance] application:app
//                                                                  openURL:url
//                                                        sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
//                                                               annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
//        }else
//        {
//            return [[GIDSignIn sharedInstance] handleURL:url
//                                       sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
//                                              annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
//        }
//        
//    }
//
//    
//}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
    globals.isFromMenuForSearchRedeem = true;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    if (buttonIndex==1) {
        ICSingletonManager *globals = [ICSingletonManager sharedManager];
        globals.isFromDeepLinkToMapScreen = @"YES";
        MapScreen *mapScreen = [storyboard instantiateViewControllerWithIdentifier:@"MapScreen"];
        mapScreen.isByCurrentLocation=YES;
        mapScreen.isByCity = NO;
               UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:mapScreen];
        [navController setNavigationBarHidden:YES];
        [self.window setRootViewController:navController];
        [self.window makeKeyAndVisible];
        
    }
    else  if (buttonIndex==2)
    {
        MapScreen *mapScreen = [storyboard instantiateViewControllerWithIdentifier:@"MapScreen"];
        ICSingletonManager *globals = [ICSingletonManager sharedManager];
        globals.isFromDeepLinkToMapScreen = @"YES";
        mapScreen.isByCity = YES;
        mapScreen.isByCurrentLocation = NO;
        UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:mapScreen];
        [navController setNavigationBarHidden:YES];
        [self.window setRootViewController:navController];
        [self.window makeKeyAndVisible];
        globals.isFromBuyVoucherByCurrentLocation = false;
        globals.isFromBuyVoucherSearchByCity = true;
    }
    
}

//// For iOS 8 and earlier
- (BOOL)application:(UIApplication *)application  openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    NSURL *openUrl = url;
    [[Branch getInstance]
     application:application
     openURL:url
     sourceApplication:sourceApplication
     annotation:annotation];
    if (openUrl)
    {
         return [self openLink:openUrl];
    }else {
        if ([[url scheme] isEqualToString:FACEBOOK_SCHEME])
        {
            return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                  openURL:url
                                                        sourceApplication:sourceApplication
                                                               annotation:annotation
                    ];
            
        }else
        {
            NSDictionary *options = @{UIApplicationOpenURLOptionsSourceApplicationKey: sourceApplication,
                                      UIApplicationOpenURLOptionsAnnotationKey: annotation};
            return [self application:application
                             openURL:url
                             options:options];
        }

    }
   

//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//    if([[url host] isEqualToString:@"page"]){
//        if([[url path] isEqualToString:@"/HomeScreen"]){
//            HomeScreenController *vcHomeScreen = [storyboard instantiateViewControllerWithIdentifier:@"HomeScreenController"];
//            UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:vcHomeScreen];
//            [navController setNavigationBarHidden:YES];
//            [self.window setRootViewController:navController];
//            [self.window makeKeyAndVisible];
//            
//        }
//        else if([[url path] isEqualToString:@"/MapScreen"]){
//            
//            HomeScreenController *vcHomeScreen = [storyboard instantiateViewControllerWithIdentifier:@"HomeScreenController"];
//            UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:vcHomeScreen];
//            [navController setNavigationBarHidden:YES];
//            [self.window setRootViewController:navController];
//            [self.window makeKeyAndVisible];
//            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Search Your Stay" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"By Current Location",@"By City", nil];
//            [alert show];        }
//        else if([[url path] isEqualToString:@"/BuyVoucher"]){
//            
//            BuyCouponViewController *buyCoupon =[storyboard instantiateViewControllerWithIdentifier:@"BuyCouponViewController"];
//            UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:buyCoupon];
//            [navController setNavigationBarHidden:YES];
//            [self.window setRootViewController:navController];
//            [self.window makeKeyAndVisible];      }
//        else if([[url path] isEqualToString:@"/MyWishList"]){
//            
//            MyWishlistViewController *buyCoupon =[storyboard instantiateViewControllerWithIdentifier:@"MyWishlistViewController"];
//            UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:buyCoupon];
//            [navController setNavigationBarHidden:YES];
//            [self.window setRootViewController:navController];
//            [self.window makeKeyAndVisible];
//        }
//        
//        return YES;
//    }
//    else{
//        if ([[url scheme] isEqualToString:FACEBOOK_SCHEME])
//        {
//            return [[FBSDKApplicationDelegate sharedInstance] application:application
//                                                                  openURL:url
//                                                        sourceApplication:sourceApplication
//                                                               annotation:annotation
//                    ];
//            
//        }else
//        {
//            NSDictionary *options = @{UIApplicationOpenURLOptionsSourceApplicationKey: sourceApplication,
//                                      UIApplicationOpenURLOptionsAnnotationKey: annotation};
//            return [self application:application
//                             openURL:url
//                             options:options];
//        }
//
//    }
  
}

- (BOOL)openLink:(NSURL *)urlLink
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
    if([[urlLink host] isEqualToString:@"page"]){
        if([[urlLink path] isEqualToString:@"/HomeScreen"]){
            HomeScreenController *vcHomeScreen = [storyboard instantiateViewControllerWithIdentifier:@"HomeScreenController"];
            SideMenuController *vcSideMenu =     [storyboard instantiateViewControllerWithIdentifier:@"SideMenuController"];
            MMDrawerController *drawerController = [[MMDrawerController alloc]initWithCenterViewController:vcHomeScreen
                                                                                  leftDrawerViewController:vcSideMenu];
            [drawerController setRestorationIdentifier:@"MMDrawer"];
            
            
            [drawerController setMaximumLeftDrawerWidth:SCREEN_WIDTH*2/3];
            
            [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
            [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
            drawerController.shouldStretchDrawer = NO;
            
            UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:drawerController];
            [navController setNavigationBarHidden:YES];
            [self.window setRootViewController:navController];
            [self.window makeKeyAndVisible];
            
        }
        else if([[urlLink path] isEqualToString:@"/MapScreen"]){
            
            HomeScreenController *vcHomeScreen = [storyboard instantiateViewControllerWithIdentifier:@"HomeScreenController"];
            UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:vcHomeScreen];
            [navController setNavigationBarHidden:YES];
            [self.window setRootViewController:navController];
            [self.window makeKeyAndVisible];
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Search Your Stay" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"By Current Location",@"By City", nil];
            [alert show];        }
        else if([[urlLink path] isEqualToString:@"/BuyVoucher"]){
            
            
            globals.isFromDeepLinkToBuyCoupon = @"YES";
            globals.isFromMenuForBuyVoucher = false;
            
            BuyCouponViewController *buyCoupon =[storyboard instantiateViewControllerWithIdentifier:@"BuyCouponViewController"];
            UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:buyCoupon];
            [navController setNavigationBarHidden:YES];
            [self.window setRootViewController:navController];
            [self.window makeKeyAndVisible];
        }
        else if([[urlLink path] isEqualToString:@"/MyWishList"]){
            
            
            [self deepLinkWislist];
        }else if([[urlLink path] isEqualToString:@"/Package"]){
            
            globals.isFromDeepLinkToPackageScreen = @"YES";
            PackagesViewController *package =[storyboard instantiateViewControllerWithIdentifier:@"PackagesViewController"];
            UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:package];
            [navController setNavigationBarHidden:YES];
            [self.window setRootViewController:navController];
            [self.window makeKeyAndVisible];
        }else if([[urlLink path] isEqualToString:@"/ViewHotels"]){
            globals.isFromDeepLinkToViewhotelsScreen = @"YES";
            CitiesViewController *cities =[storyboard instantiateViewControllerWithIdentifier:@"CitiesViewController"];
            UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:cities];
            [navController setNavigationBarHidden:YES];
            [self.window setRootViewController:navController];
            [self.window makeKeyAndVisible];
        }else if([[urlLink path] isEqualToString:@"/LoginAndRegister"]){
            
            globals.isFromDeepLinkToLoginAndRegisterScreen = @"YES";
            ICSingletonManager *globals = [ICSingletonManager sharedManager];
            globals.isFromMenu = true;
            LoginManager *login = [[LoginManager alloc]init];
            [login removeUserModelDictionary];
            globals.isFirstTimeMenuLoadWebService = @"";
            LoginScreen *vcLogin = [storyboard instantiateViewControllerWithIdentifier:@"LoginScreen"];
            UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:vcLogin];
            [navController setNavigationBarHidden:YES];
            [self.window setRootViewController:navController];
            [self.window makeKeyAndVisible];
        }
        return YES;
    }
    return NO;
}

-(void)deepLinkWislist
{
    LoginManager *loginManage = [[LoginManager alloc]init];
    NSDictionary *dict = [loginManage isUserLoggedIn];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    if ([dict count] > 0) {
        [MBProgressHUD showHUDAddedTo:self.window animated:YES];
        
        NSNumber *num = [dict valueForKey:@"UserId"];
        
        NSDictionary *dictParams = @{@"userid":num};
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        [manager.requestSerializer setValue:@"application/json; charset=utf-8"
                         forHTTPHeaderField:@"Content-Type"];
        
        [manager GET:[NSString stringWithFormat:@"%@/api/BuyCoupens/GetUserDashboardDetail?",kServerUrl] parameters:dictParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"responseObject=%@",responseObject);
            
            arr_result = [[NSMutableArray alloc]init];
            arr_result = [responseObject mutableCopy];
            NSString *status = [responseObject valueForKey:@"status"];
            // NSString *msg = [responseObject valueForKey:@"errorMessage"];
            [MBProgressHUD hideHUDForView:self.window animated:YES];
            if ([status isEqualToString:@"SUCCESS"]) {
                
                
                
                NSString  *numCouponCount =[NSString stringWithFormat:@"%@", [responseObject valueForKey:@"UserCouponCount"]];
                if ([numCouponCount isEqualToString:@"0"]) {
                    
                    ICSingletonManager *globals = [ICSingletonManager sharedManager];
                    globals.isFromMenuForBuyVoucher = false;
                    globals.isFromDeepLinkToBuyCoupon = @"YES";

                    BuyCouponViewController *buyCoupon =[storyboard instantiateViewControllerWithIdentifier:@"BuyCouponViewController"];
                    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:buyCoupon];
                    [navController setNavigationBarHidden:YES];
                    [self.window setRootViewController:navController];
                    [self.window makeKeyAndVisible];
                   
                }else if (![numCouponCount isEqualToString:@"0"])
                {
                    ICSingletonManager *globals = [ICSingletonManager sharedManager];
                    globals.isFromMenuForWishList = true;
                    
                    globals.isFromDeepLinkToWishListScreen = @"YES";
                    MyWishlistViewController *buyCoupon =[storyboard instantiateViewControllerWithIdentifier:@"MyWishlistViewController"];
                   
                    SideMenuController *vcSideMenu =     [storyboard instantiateViewControllerWithIdentifier:@"SideMenuController"];
                    
                    MMDrawerController *drawerController = [[MMDrawerController alloc]initWithCenterViewController:buyCoupon
                                                                                          leftDrawerViewController:vcSideMenu];
                    [drawerController setRestorationIdentifier:@"MMDrawer"];
                    
                    
                    [drawerController setMaximumLeftDrawerWidth:SCREEN_WIDTH*2/3];
                    
                    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
                    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
                    drawerController.shouldStretchDrawer = NO;
                    
                    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:drawerController];
                    [navController setNavigationBarHidden:YES];
                    [self.window setRootViewController:navController];
                    [self.window makeKeyAndVisible];
                    }
                
                
                
            }
            
            NSLog(@"sucess");
            
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failure");
            [MBProgressHUD hideHUDForView:self.window animated:YES];
            [[ICSingletonManager sharedManager] showAlertViewWithMsg:error.localizedDescription onController:self];
            
        }];
        
    }else{
        ICSingletonManager *globals = [ICSingletonManager sharedManager];
        globals.strWhichScreen = @"BuyVoucher";
        [self switchToLoginScreen];
        
    }
    

}
- (void)switchToLoginScreen
{
     UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    [[NSNotificationCenter defaultCenter ]addObserver:self selector:@selector(pushToDashBoardScreenAfterLoggingIn) name:kSwitchToDashBoardScreen object:nil];
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
    globals.isFromDeepLinkToLoginAndRegisterScreen = @"YES";
    globals.isFromMenu = true;
    LoginManager *login = [[LoginManager alloc]init];
    [login removeUserModelDictionary];
    globals.isFirstTimeMenuLoadWebService = @"";
    LoginScreen *vcLogin = [storyboard instantiateViewControllerWithIdentifier:@"LoginScreen"];
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:vcLogin];
    [navController setNavigationBarHidden:YES];
    [self.window setRootViewController:navController];
    [self.window makeKeyAndVisible];
   
}
#pragma mark - Google Delegate Methods
// Google delegate method for getting user data from Google

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
    // Perform any operations on signed in user here.
    self.Google_userId = user.userID;                  // For client-side use only!
    self.Google_idToken = user.authentication.idToken; // Safe to send to the server
    self.Google_name = user.profile.name;
    self.Google_email = user.profile.email;
    if ([GIDSignIn sharedInstance].currentUser.profile.hasImage)
    {
        NSUInteger dimension = round(300 * [[UIScreen mainScreen] scale]);
        NSURL *imageURL = [user.profile imageURLWithDimension:dimension];
        self.Google_Image_Url = [imageURL absoluteString];
    }    
    if (![[ICSingletonManager getStringValue:self.Google_userId] isEqualToString:@""])
    {
        // Code for sending notification to login module
        [[NSNotificationCenter defaultCenter] postNotificationName:@"googlesigninaction" object:self userInfo:nil];
    }
}

- (void)signIn:(GIDSignIn *)signIn didDisconnectWithUser:(GIDGoogleUser *)user withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
    // ...
}

#pragma mark - Remote Notification Delegate

#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:   (UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
    [[MoEngage sharedInstance]didRegisterForUserNotificationSettings:notificationSettings];
    
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString   *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}
#endif
#pragma mark Remote Notification Delegate

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    [UIApplication sharedApplication].applicationIconBadgeNumber +=1;
    
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive) {
        NSString *message= [[userInfo valueForKey:@"aps"] valueForKey:@"alert"];
        
        UIAlertView *alert11 = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil,nil];
        [alert11 show];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationRecieved" object:nil];
    }
     [[MoEngage sharedInstance]didReceieveNotificationinApplication:application withInfo:userInfo openDeeplinkUrlAutomatically:YES];
    [MoEngage debug:LOG_ALL];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 10.0) {
        [self customPushHandler:userInfo];
    }
}
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    completionHandler((UNNotificationPresentationOptionSound
                       | UNNotificationPresentationOptionAlert ));
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void (^)())completionHandler{
    
    [[MoEngage sharedInstance] userNotificationCenter:center didReceiveNotificationResponse:response];
    //Custom Handler
    NSDictionary *pushDictionary = response.notification.request.content.userInfo;
    if (pushDictionary) {
        [self customPushHandler:pushDictionary];
    }
    completionHandler();
    
}

+(NSString *)advertiserID{
    NSString *advertiserID = nil;
    if ([ASIdentifierManager class]) {
        ASIdentifierManager *manager = [ASIdentifierManager sharedManager];
        if([manager isAdvertisingTrackingEnabled]){
            advertiserID = [[manager advertisingIdentifier] UUIDString];
        }
    }
    return advertiserID;
}
- (void) customPushHandler:(NSDictionary *)notification {
    if (notification !=nil && [notification objectForKey:@"app_extra"] != nil) {
        NSDictionary* app_extra_dict = [notification objectForKey:@"app_extra"];
        NSLog(@"%@",app_extra_dict);
        // Here based on the extras key-value pair, you can open specific screens that's part of your app
    }
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(nonnull NSError *)error
{
    //NSLog(@"%@",error);
    [[MoEngage sharedInstance]didFailToRegisterForPush];
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken {
    //gettiing and parsing device token.
    NSString* deviceTokenApple = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString: @""] stringByReplacingOccurrencesOfString:@">" withString: @""] stringByReplacingOccurrencesOfString:@" " withString: @""];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    // saving an NSString
    [prefs setValue:deviceTokenApple forKey:@"deviceToken"];
    //  [Global showAlertMessageWithOkButtonAndTitle:APP_NAME andMessage:deviceTokenApple];
    NSLog(@"%@",deviceTokenApple);
    [prefs synchronize];
    self.strDeviceToken = [NSString stringWithString:deviceTokenApple];
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
    globals.StrDeviceToken = [NSString stringWithString:deviceTokenApple];

    
    
    if (manangeRegisterNotificationDeviceToken == 0) {
        
    
    if (self.strDeviceToken) {
        [self postDataToPushNotification];
    }
    
    [[MoEngage sharedInstance]registerForPush:deviceToken];
        manangeRegisterNotificationDeviceToken = 1;
    }
}
-(void)postDataToPushNotification
{
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
    //Fire api
    
    AppDelegate *appDelegate= (AppDelegate*)[UIApplication sharedApplication].delegate;
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
    globals.isFirstTimeFromPageScrollController = true;
    if (appDelegate.strDeviceToken && globals.isFirstTimeFromPageScrollController == true) {
        NSString *strParams = [NSString stringWithFormat:@"UserId=%@&UUID=%@",[NSString stringWithFormat:@"%@", @"0"],appDelegate.strDeviceToken];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        [manager.requestSerializer setValue:@"application/json; charset=utf-8"
                         forHTTPHeaderField:@"Content-Type"];
        [manager GET:[NSString stringWithFormat:@"%@/api/AppPush/PushIOSInsertUUID?%@",kServerUrl,strParams] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"responseObject=%@",responseObject);
            //                dispatch_async(dispatch_get_main_queue(), ^{
            //                });
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failure");
            //                dispatch_async(dispatch_get_main_queue(), ^{
            //                });
            [[ICSingletonManager sharedManager] showAlertViewWithMsg:error.localizedDescription onController:self];
            
        }];
    }
    
       });
    
    
}
#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "verticallogics.ICanStay" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ICanStay" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ICanStay.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
