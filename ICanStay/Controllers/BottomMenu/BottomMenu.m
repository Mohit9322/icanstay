//
//  BottomMenu.m
//  ICanStay
//
//  Created by Namit Aggarwal on 25/02/16.
//  Copyright (c) 2016 Harry Patel (Hitaishin). All rights reserved.
//

#import "BottomMenu.h"
#import "NewSubscription.h"
#import "MapScreen.h"
#import "BuyCouponViewController.h"
#import "LoginScreen.h"
#import "LoginManager.h"
#import "DashboardScreen.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"
@interface BottomMenu ()
- (IBAction)btnGiftPackTapped:(id)sender;
- (IBAction)btnEmailTApped:(id)sender;
- (IBAction)btnSearchTapped:(id)sender;

@end

@implementation BottomMenu

- (void)viewDidLoad {
    [super viewDidLoad];
     DLog(@"DEBUG-VC");
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnGiftPackTapped:(id)sender {
    
    
//    LoginManager *manager = [[LoginManager alloc]init];
//    NSDictionary *dict = [manager isUserLoggedIn];
//    if (dict.count>0) {
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
    globals.isFromMenuForBuyVoucher = false;
        BuyCouponViewController *buyCoupon =[self.storyboard instantiateViewControllerWithIdentifier:@"BuyCouponViewController"];
        buyCoupon.ifFromGiftedCoupon = YES;
        [self.navigationController pushViewController:buyCoupon animated:YES];
//    }
//    else
//    {
//        [self switchToLoginScreen];
//    }

}

- (void)switchToLoginScreen{
    
    [[NSNotificationCenter defaultCenter ]addObserver:self selector:@selector(pushToDashBoardScreenAfterLoggingIn) name:kSwitchToDashBoardScreen object:nil];
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
    globals.isFromMenu = false;

    LoginScreen *vcLogin = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginScreen"];
    [self.navigationController pushViewController:vcLogin animated:YES];
}

- (void)pushToDashBoardScreenAfterLoggingIn
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
    globals.isFromMenuForBuyVoucher = false;
    BuyCouponViewController *buyCoupon =[self.storyboard instantiateViewControllerWithIdentifier:@"BuyCouponViewController"];
    buyCoupon.ifFromGiftedCoupon = YES;
    [self.navigationController pushViewController:buyCoupon animated:YES];
//    DashboardScreen *dashboardScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"DashboardScreen"];
//    [self.mm_drawerController setCenterViewController:dashboardScreen withCloseAnimation:NO completion:nil];
}


- (IBAction)btnEmailTApped:(id)sender {
    
    NewSubscription *newSubscribe= [self.storyboard instantiateViewControllerWithIdentifier:@"NewSubscription"];
    [self.navigationController pushViewController:newSubscribe animated:YES];
    
}

- (IBAction)btnSearchTapped:(id)sender {
    
//    MapScreen *mapScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"MapScreen"];
//    [self.navigationController pushViewController:mapScreen animated:YES];
//
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Search Your Stay" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"By Current Location",@"By City", nil];
    [alert show];
    

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
    globals.isFromMenuForSearchRedeem = false;

    if (buttonIndex==1) {
        MapScreen *mapScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"MapScreen"];
        mapScreen.isByCurrentLocation=YES;
        mapScreen.isByCity = NO;
        [self.navigationController pushViewController:mapScreen animated:YES];
    }
    else  if (buttonIndex==2)
    {
        MapScreen *mapScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"MapScreen"];
        mapScreen.isByCity = YES;
        mapScreen.isByCurrentLocation = NO;
        [self.navigationController pushViewController:mapScreen animated:YES];
    }
    
}
@end
