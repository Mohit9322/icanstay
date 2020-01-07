//
//  LoginScreen.m
//  ICanStay
//
//  Created by Namit Aggarwal on 25/02/16.
//  Copyright (c) 2016 Harry Patel (Hitaishin). All rights reserved.
//

#import "LoginScreen.h"
#import "ForgotPassword.h"
#import "RegistrationScreen.h"
#import "AFNetworking.h"
#import "NSDictionary+JsonString.h"
#import "LoginManager.h"
#import "ChangePasswordScreen.h"
#import "UITextField+EmptyText.h"
#import "DashboardScreen.h"
#import "MBProgressHud.h"
#import <QuartzCore/QuartzCore.h>
#import "HomeScreenController.h"
#import "AppDelegate.h"
#import "MakeAWishlistViewController.h"
#import "BuyCouponViewController.h"
#import "MyCouponViewController.h"
#import "MyWishlistViewController.h"
#import "CurrentStayScreen.h"
#import "ProfileScreen.h"
#import "AccountScreen.h"
#import "NotificationScreen.h"
#import "GiftVouchersViewController.h"
#import "SideMenuController.h"
#import <MoEngage.h>
#import "MapScreen.h"
#import "GradientButton.h"
#import "ReferAndEarnVC.h"

#define ACCEPTABLE_CHARACTERS @"0123456789"
@interface LoginScreen ()<UITextFieldDelegate>
{
    NSString *strSearchYourStay;
}
@property (weak, nonatomic) IBOutlet UIView *viewBottom;
- (IBAction)btnLoginTapped:(id)sender;
- (IBAction)btnMenuTapped:(id)sender;
- (IBAction)btnForgotPasswordTapped:(id)sender;

- (IBAction)btnRegisterationTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtUserName;
@property (strong, nonatomic) IBOutlet UIButton *RegisterNowBtn;
@property (strong, nonatomic) IBOutlet UIView *BaseView;
@property (strong, nonatomic) IBOutlet UIView *LoginButtonBaseView;


@end

@implementation LoginScreen

- (void)viewDidLoad {
    
    DLog(@"DEBUG-VC");
    strSearchYourStay = @"NO";    //self.loginBtn.layer.cornerRadius = 10;
    //self.loginBtn.clipsToBounds = YES;
    [super viewDidLoad];
    
    
    
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
    globals.isFirstTimeFromPageScrollController = false;
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    [tracker set:kGAIScreenName value:@"Login"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    self.txtUserName.delegate = self;
    [self addPaddingToTextFields];
    
    
    NSMutableAttributedString *text =[[NSMutableAttributedString alloc] initWithString:@"Register Now & Earn Up To ₹1 Lakh"];
    
    [text addAttribute:NSForegroundColorAttributeName value:[ICSingletonManager colorFromHexString:@"#bd9854"] range:NSMakeRange(0,12 )];
    [text addAttribute:NSForegroundColorAttributeName value:[ICSingletonManager colorFromHexString:@"#001d3d"] range:NSMakeRange(13,20 )];
    [_RegisterNowBtn setAttributedTitle:text forState:UIControlStateNormal];
    
    UIView *narrowLineVew = [[UIView alloc]init];
    narrowLineVew.backgroundColor = [ICSingletonManager colorFromHexString:@"#bd9854"];
    [_BaseView addSubview:narrowLineVew];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        narrowLineVew.frame = CGRectMake(self.view.frame.size.width /2 -142, 384, 120, 1);
    }else{
          narrowLineVew.frame =  CGRectMake(self.view.frame.size.width /2 -130, 310, 90, 1);
    }
    
    NSString *str = @"Login";
    CGSize stringsize = [str sizeWithFont:[UIFont systemFontOfSize:18]];
    
    GradientButton *registerNowBtn =  [[GradientButton alloc]init];
    registerNowBtn.frame = CGRectMake((self.view.frame.size.width - (stringsize.width + 30))/2,0,stringsize.width + 30,40);
    [registerNowBtn setTitle:@"Login" forState:UIControlStateNormal];
    [registerNowBtn useRedDeleteStyle];
    [registerNowBtn addTarget:self action:@selector(LoginBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.LoginButtonBaseView addSubview:registerNowBtn];
}

-(void)LoginBtnTapped:(id)sender
{
    BOOL ifUserNameEmpty = [self.txtUserName detectIfTextfieldIsEmpty:self.txtUserName.text];
    if (ifUserNameEmpty){
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Enter a mobile number" onController:self];
        return;
    }
    
    BOOL ifPasswordEmpty = [self.txtPassword detectIfTextfieldIsEmpty:self.txtPassword.text];
    if (ifPasswordEmpty){
        [[ICSingletonManager sharedManager] showAlertViewWithMsg:@"Enter a password" onController:self];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *strParams = [NSString stringWithFormat:@"userName=%@&password=%@&isAutoLogin=yes",self.txtUserName.text,self.txtPassword.text];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8"
                     forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:[NSString stringWithFormat:@"%@/api/Loginapi/Login?%@",kServerUrl,strParams] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        
        NSString *status = [responseObject objectForKey:@"status"];
        // NSString *msg = [responseObject valueForKey:@"errorMessage"];
        if ([status isEqualToString:@"SUCCESS"]) {
            
            ICSingletonManager *globals = [ICSingletonManager sharedManager];
            globals.FirstTimeAppLoginOrRegister = @"YES";
            
            
            NSDictionary  *dictUserModel = [responseObject valueForKey:@"userModel" ];
            NSMutableDictionary *dictCleanedUserModel= [self cleanDictionary:[dictUserModel mutableCopy]];
            dictUserModel = [dictCleanedUserModel copy];
            
            LoginManager *loginManage = [[LoginManager alloc]init];
            [loginManage loginUserWithUserDataDictionary:dictUserModel ];
            
            NSDictionary *dict = [loginManage isUserLoggedIn];
            NSLog(@"%@",dict);
            [self postDataToPushNotification];
            [self startServiceToGetCouponsDetails];
            
            /****************** Mo Engage *******************/
            
       //     ICSingletonManager *globals = [ICSingletonManager sharedManager];
            
            
            [[MoEngage sharedInstance] setUserUniqueID:[dict objectForKey:@"UserId"]];
            
            NSData *strDeviceToken = [globals.StrDeviceToken dataUsingEncoding:NSUTF8StringEncoding];
            [[MoEngage sharedInstance]registerForPush:strDeviceToken];
            [MoEngage debug:LOG_ALL];
            
            NSMutableDictionary *purchaseDict = [NSMutableDictionary dictionaryWithDictionary:@{@"Phone":[dict objectForKey:@"Phone1"],@"UserName":[NSString stringWithFormat:@"%@ %@", [dict objectForKey:@"FirstName"],[dict objectForKey:@"LastName"]]}];
            
            
            
            [[MoEngage sharedInstance]trackEvent:@"App Log-In IOS" andPayload:purchaseDict];
            [[MoEngage sharedInstance] syncNow];
            [MoEngage debug:LOG_ALL];
            
            /****************** Mo Engage *******************/
            
            ////            /****************** Google Analytics *******************/
            ////
            //            // Track the Event for UserSuccessfulRegistrationMobile
            //
            //            NSString *actionStr = [NSString stringWithFormat:@"%@ %@", [dict objectForKey:@"FirstName"],[dict objectForKey:@"LastName"]];
            //            id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
            //            [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"App Log-in IOS"
            //                                                                  action:actionStr
            //                                                                   label:@"User Successfully Logged In"
            //                                                                   value:nil] build]];
            ////
            ////            /****************** Google Analytics *******************/
            ////
            
            
            
        }
        else if ([status isEqualToString:@"FAIL"])
        {
            [[ICSingletonManager sharedManager] showAlertViewWithMsg:[responseObject objectForKey:@"errorMessage"] onController:self];
        }
        
        //NSLog(@"sucess");
        //[[ICSingletonManager sharedManager]showAlertViewWithMsg:msg onController:self];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        NSLog(@"error=%@",error.localizedFailureReason);
        NSLog(@"%@",error.localizedDescription);
        [[ICSingletonManager sharedManager] showAlertViewWithMsg:error.localizedDescription onController:self];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
    

}
- (void)addPaddingToTextFields{
    [self.txtPassword addPaddingToTextField];
    [self.txtUserName addPaddingToTextField];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)startServiceToLoginUser{
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnLoginTapped:(id)sender {
    
    // ?userName=9971983440&password=1234a&isAutoLogin={isAutoLogin}
    
    //    self.txtUserName.text = @"8130184684";
    //    self.txtPassword.text = @"E35O";
    
    BOOL ifUserNameEmpty = [self.txtUserName detectIfTextfieldIsEmpty:self.txtUserName.text];
    if (ifUserNameEmpty){
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Enter a mobile number" onController:self];
        return;
    }
    
    BOOL ifPasswordEmpty = [self.txtPassword detectIfTextfieldIsEmpty:self.txtPassword.text];
    if (ifPasswordEmpty){
        [[ICSingletonManager sharedManager] showAlertViewWithMsg:@"Enter a password" onController:self];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *strParams = [NSString stringWithFormat:@"userName=%@&password=%@&isAutoLogin=yes",self.txtUserName.text,self.txtPassword.text];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8"
                     forHTTPHeaderField:@"Content-Type"];
    
     [manager POST:[NSString stringWithFormat:@"%@/api/Loginapi/Login?%@",kServerUrl,strParams] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);

        NSString *status = [responseObject objectForKey:@"status"];
       // NSString *msg = [responseObject valueForKey:@"errorMessage"];
        if ([status isEqualToString:@"SUCCESS"]) {
            
            ICSingletonManager *globals = [ICSingletonManager sharedManager];
            globals.FirstTimeAppLoginOrRegister = @"YES";

            NSDictionary  *dictUserModel = [responseObject valueForKey:@"userModel" ];
            NSMutableDictionary *dictCleanedUserModel= [self cleanDictionary:[dictUserModel mutableCopy]];
            dictUserModel = [dictCleanedUserModel copy];
        
            LoginManager *loginManage = [[LoginManager alloc]init];
            [loginManage loginUserWithUserDataDictionary:dictUserModel ];
            
            NSDictionary *dict = [loginManage isUserLoggedIn];
            NSLog(@"%@",dict);
            [self postDataToPushNotification];
            [self startServiceToGetCouponsDetails];
            
            /****************** Mo Engage *******************/
            
           
            
            
            [[MoEngage sharedInstance] setUserUniqueID:[dict objectForKey:@"UserId"]];
            
            NSData *strDeviceToken = [globals.StrDeviceToken dataUsingEncoding:NSUTF8StringEncoding];
           [[MoEngage sharedInstance]registerForPush:strDeviceToken];
            [MoEngage debug:LOG_ALL];
            
            NSMutableDictionary *purchaseDict = [NSMutableDictionary dictionaryWithDictionary:@{@"Phone":[dict objectForKey:@"Phone1"],@"UserName":[NSString stringWithFormat:@"%@ %@", [dict objectForKey:@"FirstName"],[dict objectForKey:@"LastName"]]}];
            
            
            
          [[MoEngage sharedInstance]trackEvent:@"App Log-In IOS" andPayload:purchaseDict];
            [[MoEngage sharedInstance] syncNow];
            [MoEngage debug:LOG_ALL];
            
            /****************** Mo Engage *******************/
           
////            /****************** Google Analytics *******************/
////            
//            // Track the Event for UserSuccessfulRegistrationMobile
//            
//            NSString *actionStr = [NSString stringWithFormat:@"%@ %@", [dict objectForKey:@"FirstName"],[dict objectForKey:@"LastName"]];
//            id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
//            [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"App Log-in IOS"
//                                                                  action:actionStr
//                                                                   label:@"User Successfully Logged In"
//                                                                   value:nil] build]];
////
////            /****************** Google Analytics *******************/
////            
 
            
            
        }
        else if ([status isEqualToString:@"FAIL"])
        {
            [[ICSingletonManager sharedManager] showAlertViewWithMsg:[responseObject objectForKey:@"errorMessage"] onController:self];
        }
        
        //NSLog(@"sucess");
      //[[ICSingletonManager sharedManager]showAlertViewWithMsg:msg onController:self];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        NSLog(@"error=%@",error.localizedFailureReason);
        NSLog(@"%@",error.localizedDescription);
        [[ICSingletonManager sharedManager] showAlertViewWithMsg:error.localizedDescription onController:self];

        [MBProgressHUD hideHUDForView:self.view animated:YES];

    }];
    

}

-(void)postDataToPushNotification
{
    LoginManager *loginManage = [[LoginManager alloc]init];
    NSDictionary *dict = [loginManage isUserLoggedIn];
    NSLog(@"%@",dict);
    
    NSNumber *userId = [dict valueForKey:@"UserId"];

    AppDelegate *appDelegate= (AppDelegate*)[UIApplication sharedApplication].delegate;

    //          http://www.icanstay.com/api/AppPush/PushIOSInsertUUID?UserId=1&UUID=xxx111

    NSString *strParams = [NSString stringWithFormat:@"UserId=%@&UUID=%@",userId,appDelegate.strDeviceToken];
 NSString *url =   [NSString stringWithFormat:@"%@/api/AppPush/PushIOSInsertUUID?%@",kServerUrl,strParams];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8"
                     forHTTPHeaderField:@"Content-Type"];
    
    [manager GET:[NSString stringWithFormat:@"%@/api/AppPush/PushIOSInsertUUID?%@",kServerUrl,strParams] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
         [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [[ICSingletonManager sharedManager] showAlertViewWithMsg:error.localizedDescription onController:self];
        
        
    }];
}
- (void)startServiceToGetCouponsDetails
{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AppDelegate *delegate =   (AppDelegate *)[[UIApplication sharedApplication] delegate];
   
    
    LoginManager *loginManage = [[LoginManager alloc]init];
    NSDictionary *dict = [loginManage isUserLoggedIn];
    NSNumber *num = [dict valueForKey:@"UserId"];
    
    NSDictionary *dictParams = @{@"userid":num};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8"
                     forHTTPHeaderField:@"Content-Type"];
    
    [manager GET:[NSString stringWithFormat:@"%@/api/BuyCoupens/GetUserDashboardDetail?",kServerUrl] parameters:dictParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
       NSLog(@"responseObject=%@",responseObject);
        
        
        NSString *status = [responseObject valueForKey:@"status"];
        // NSString *msg = [responseObject valueForKey:@"errorMessage"];
        if ([status isEqualToString:@"SUCCESS"]) {
            
            int numCouponCount = [[responseObject valueForKey:@"UserCouponCount"] intValue];
            NSNumber *numPastStayCount = [responseObject valueForKey:@"UserPastStayCount"];
            NSNumber *numWhishlistCount = [responseObject valueForKey:@"UserWishlistCount"];
            
            ICSingletonManager *globals = [ICSingletonManager sharedManager];
            globals.validVoucher = numCouponCount;
            [[NSUserDefaults standardUserDefaults] setInteger:numCouponCount forKey:@"validVoucher"];
            BOOL  isUserFirstTimeLoggedIn=  [loginManage isFirstTimeLogin];
            if ( [globals.userLoginFromReferAndEarn isEqualToString:@"YES"]) {
            
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                globals.userLoginFromReferAndEarn  = @"NO";
                
                ICSingletonManager *globals = [ICSingletonManager sharedManager];
                globals.isFromMenu = true;
                ReferAndEarnVC *refer = [self.storyboard instantiateViewControllerWithIdentifier:@"ReferAndEarnVC"];
                
                SideMenuController *vcSideMenu =     [storyboard instantiateViewControllerWithIdentifier:@"SideMenuController"];
                
                MMDrawerController *drawerController = [[MMDrawerController alloc]initWithCenterViewController:refer
                                                                                      leftDrawerViewController:vcSideMenu];
                [drawerController setRestorationIdentifier:@"MMDrawer"];
                
                
                [drawerController setMaximumLeftDrawerWidth:SCREEN_WIDTH*2/3];
                
                [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
                [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
                drawerController.shouldStretchDrawer = NO;
                
                UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:drawerController];
                [navController setNavigationBarHidden:YES];
                [self.view.window setRootViewController:navController];
                [self.view.window makeKeyAndVisible];
                
            }else if ([globals.isFromDeepLinkToLoginAndRegisterScreen isEqualToString:@"YES"]) {
                globals.isFromDeepLinkToLoginAndRegisterScreen = @"NO";
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
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
                [self.view.window setRootViewController:navController];
                [self.view.window makeKeyAndVisible];
            } else if (isUserFirstTimeLoggedIn)
            {
                ChangePasswordScreen *changePassScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangePasswordScreen"];
                changePassScreen.strOldPass = self.txtPassword.text;
                [self.navigationController pushViewController:changePassScreen animated:YES];
            }else if ([globals.isFromLoginContinueGuestBuyVoucher isEqualToString:@"YES"]){
                
                globals.isFromLoginContinueGuestBuyVoucher = @"NO";
                if (globals.isFromMenuForBuyVoucher == true) {
                    BuyCouponViewController *buyCoupon = [self.storyboard instantiateViewControllerWithIdentifier:@"BuyCouponViewController"];
                    [self.mm_drawerController setCenterViewController:buyCoupon withCloseAnimation:YES completion:nil];
                }

                
            }else
            {
                ICSingletonManager *globals = [ICSingletonManager sharedManager];
                
                if ([globals.strWhichScreen isEqualToString:@"MakeWishList"])
                {
                    if (globals.isFromMenuForMakeWishe == true) {
                        MakeAWishlistViewController *makeWish = [self.storyboard instantiateViewControllerWithIdentifier:@"MakeAWishlistViewController"];
                        [self.mm_drawerController setCenterViewController:makeWish withCloseAnimation:YES completion:nil];
                    }
                    else{
                        ICSingletonManager *globals = [ICSingletonManager sharedManager];
                        globals.isFromMenuForMakeWishe = false;
                        MakeAWishlistViewController *createWishList =[self.storyboard instantiateViewControllerWithIdentifier:@"MakeAWishlistViewController"];
                        [self.navigationController pushViewController:createWishList animated:YES];
                    }
                    
                }
                else if ([globals.strWhichScreen isEqualToString:@"BuyVoucher"] )
                {
                    //                    globals.strWhichScreen = @"";
                    if (globals.isFromMenuForBuyVoucher == true) {
                        BuyCouponViewController *buyCoupon = [self.storyboard instantiateViewControllerWithIdentifier:@"BuyCouponViewController"];
                        [self.mm_drawerController setCenterViewController:buyCoupon withCloseAnimation:YES completion:nil];
                    }
                    else{
                        globals.isFromMenuForMakeWishe = false;
                        BuyCouponViewController *buyCoupon =[self.storyboard instantiateViewControllerWithIdentifier:@"BuyCouponViewController"];
                        [self.navigationController pushViewController:buyCoupon animated:YES];
                    }
                    
                }else if (([globals.strWhichScreen isEqualToString:@"SearchYourStay"]))
                {
                    globals.strMenuFromSearchStay = @"YES";
                    HomeScreenController *vcHomeScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeScreenController"];
                     [self.mm_drawerController setCenterViewController:vcHomeScreen withCloseAnimation:YES completion:nil];
                    strSearchYourStay = @"YES";
                    
                    
                }
                else if ([globals.strWhichScreen isEqualToString:@"MyCoupon"])
                {
                    //                    globals.strWhichScreen = @"";
                    MyCouponViewController *buyCoupon = [self.storyboard instantiateViewControllerWithIdentifier:@"MyCouponViewController"];
                    buyCoupon.str_CoupenCount = [NSString stringWithFormat:@"%d",numCouponCount];
                    [self.mm_drawerController setCenterViewController:buyCoupon withCloseAnimation:YES completion:nil];
                }
                else if ([globals.strWhichScreen isEqualToString:@"MyWishlist"])
                {
                    globals.strWhichScreen = @"";
                    MyWishlistViewController *buyCoupon = [self.storyboard instantiateViewControllerWithIdentifier:@"MyWishlistViewController"];
                    globals.isFromMenuForWishList = YES;
                    [self.mm_drawerController setCenterViewController:buyCoupon withCloseAnimation:YES completion:nil];
                }
                else if ([globals.strWhichScreen isEqualToString:@"CurrentStayScreen"])
                {
                    globals.strWhichScreen = @"";
                    CurrentStayScreen *buyCoupon = [self.storyboard instantiateViewControllerWithIdentifier:@"CurrentStayScreen"];
                    [self.mm_drawerController setCenterViewController:buyCoupon withCloseAnimation:YES completion:nil];
                }
                else if ([globals.strWhichScreen isEqualToString:@"ProfileScreen"])
                {
                    globals.strWhichScreen = @"";
                    ProfileScreen *buyCoupon = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileScreen"];
                    [self.mm_drawerController setCenterViewController:buyCoupon withCloseAnimation:YES completion:nil];
                }
                else if ([globals.strWhichScreen isEqualToString:@"GiftVouchers"])
                {
                    globals.strWhichScreen = @"";
                    GiftVouchersViewController *giftVouchers =[self.storyboard instantiateViewControllerWithIdentifier:@"GiftVouchersViewController"];
                    [self.mm_drawerController setCenterViewController:giftVouchers withCloseAnimation:YES completion:nil];
                }
                else if ([globals.strWhichScreen isEqualToString:@"AccountScreen"])
                {
                    globals.strWhichScreen = @"";
                    AccountScreen *buyCoupon = [self.storyboard instantiateViewControllerWithIdentifier:@"AccountScreen"];
                    [self.mm_drawerController setCenterViewController:buyCoupon withCloseAnimation:YES completion:nil];
                }
                else if (globals.isWithoutLoginNoti)
                {
                    NotificationScreen *notiScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"NotificationScreen"];
                    [self.navigationController pushViewController:notiScreen animated:YES];
                }
                else if (globals.isFromMenu)
                {
                    if ([delegate.fromPageScrollController isEqualToString:@"YES"]) {
                        
                        AppDelegate *delegate =   (AppDelegate *)[[UIApplication sharedApplication] delegate];
                        delegate.fromPageScrollController = @"NO";
                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                        
                        HomeScreenController *vcHomeScreen = [storyboard instantiateViewControllerWithIdentifier:@"HomeScreenController"];
                        SideMenuController *vcSideMenu =     [storyboard instantiateViewControllerWithIdentifier:@"SideMenuController"];
                        
                        MMDrawerController *drawerController = [[MMDrawerController alloc]initWithCenterViewController:vcHomeScreen
                                                                                              leftDrawerViewController:vcSideMenu];
                        [drawerController setRestorationIdentifier:@"MMDrawer"];
                        //    [drawerController setMaximumLeftDrawerWidth:[UIScreen mainScreen].bounds.size.width -[UIScreen mainScreen].bounds.size.width/2 ];
                        [drawerController setMaximumLeftDrawerWidth:SCREEN_WIDTH*2/3];
                        
                        [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
                        [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
                        drawerController.shouldStretchDrawer = NO;
                        
                        UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:drawerController];
                        [navController setNavigationBarHidden:YES];
                        [delegate.window setRootViewController:navController];
                        [delegate.window makeKeyAndVisible];
                        
                    }else{
                        HomeScreenController *homeScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeScreenController"];
                        [self.mm_drawerController setCenterViewController:homeScreen withCloseAnimation:YES completion:nil];
                    }
                    
                    
                    
                    
                   
                }else   {
                    [self.navigationController popViewControllerAnimated:NO];
                }
                
                if ([strSearchYourStay isEqualToString:@"YES"]) {
                    
                }else{
                     [[ICSingletonManager sharedManager] showAlertViewWithMsg:@"Successfully Login!" onController:self];
                }
               
                //Creating issue in sign in
                //[[NSNotificationCenter defaultCenter]postNotificationName:kSwitchToDashBoardScreen object:nil];
            }
            
        }
        
        NSLog(@"sucess");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [[ICSingletonManager sharedManager] showAlertViewWithMsg:error.localizedDescription onController:self];
        
    }];
    
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
    globals.isFromMenuForSearchRedeem = true;
    
    if (buttonIndex==1) {
        MapScreen *mapScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"MapScreen"];
        mapScreen.isByCurrentLocation=YES;
        mapScreen.isByCity = NO;
        [self.mm_drawerController setCenterViewController:mapScreen withCloseAnimation:YES completion:nil];
    }
    else  if (buttonIndex==2)
    {
        MapScreen *mapScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"MapScreen"];
        mapScreen.isByCity = YES;
        mapScreen.isByCurrentLocation = NO;
        [self.mm_drawerController setCenterViewController:mapScreen withCloseAnimation:YES completion:nil];
    }
    
}

- (IBAction)btnMenuTapped:(id)sender {
    
    
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
    AppDelegate *delegate =   (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if ([globals.isFromDeepLinkToLoginAndRegisterScreen isEqualToString:@"YES"]) {
        globals.isFromDeepLinkToLoginAndRegisterScreen = @"NO";
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
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
        [self.view.window setRootViewController:navController];
        [self.view.window makeKeyAndVisible];
        
    }else if (globals.isFromMenu){
   
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    }else if ([delegate.fromPageScrollController isEqualToString:@"YES"]) {
         globals.userLoginFromReferAndEarn = @"NO";
        [self.navigationController popViewControllerAnimated:YES];
        
    }else if (!globals.isFromMenu)
    {
         [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


- (IBAction)btnForgotPasswordTapped:(id)sender {

    ForgotPassword *vcForgotPass = [self.storyboard instantiateViewControllerWithIdentifier:@"ForgotPassword"];
    [self.navigationController pushViewController:vcForgotPass animated:YES];
   }

- (IBAction)btnRegisterationTapped:(id)sender {
    RegistrationScreen *registerScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"RegistrationScreen"];
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
    globals.registrationBackManage = @"NO";
    [self.navigationController pushViewController:registerScreen animated:YES];
    
}

- (NSMutableDictionary *)cleanDictionary:(NSMutableDictionary *)dictionary {
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (obj == [NSNull null]) {
            [dictionary setObject:@"" forKey:key];
        } else if ([obj isKindOfClass:[NSDictionary class]]) {
            [self cleanDictionary:obj];
        }
    }];
    return  dictionary;
}


#pragma  mark - UITextField Delegate Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length == 0 && [string isEqualToString:@" "]) {
        return NO;
    }
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERS] invertedSet];
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    if (textField == self.txtUserName) {
        if (range.location == 10 || ![string isEqualToString:filtered])
            return NO;
        return YES;
    } else {
        return YES;
        
    }
}

@end

