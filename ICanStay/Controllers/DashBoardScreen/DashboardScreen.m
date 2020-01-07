//
//  DashboardScreen.m
//  ICanStay
//
//  Created by Namit Aggarwal on 25/02/16.
//  Copyright (c) 2016 Harry Patel (Hitaishin). All rights reserved.
//

#import "DashboardScreen.h"
#import "DashboardScreenCell.h"
#import "BottomMenu.h"
#import "UIViewController+MMDrawerController.h"
#import "ProfileScreen.h"
#import "SearchStayScreen.h"
#import "MakeAWishlistViewController.h"
#import "NotificationScreen.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "LoginManager.h"
#import "CurrentStayScreen.h"
#import "AccountScreen.h"
#import "MapScreen.h"

#import "MyWishlistViewController.h"
#import "MyCouponViewController.h"
#import "RefundCouponScreen.h"
#import "BuyCouponViewController.h"

@interface DashboardScreen ()//<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,retain)NSMutableArray *arrDasboardItems;
@property (weak, nonatomic) IBOutlet UITableView *tblDashboardItems;

@property (weak, nonatomic) IBOutlet UIView *viewBottom;
- (IBAction)btnMenuTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblCouponCount;
@property (weak, nonatomic) IBOutlet UILabel *lblPastStayCount;
@property (weak, nonatomic) IBOutlet UILabel *lblWhishlistCount;

@property (weak, nonatomic) IBOutlet UILabel *lblMyCouponText;
@property (weak, nonatomic) IBOutlet UILabel *lblmyStayText;
@property (weak, nonatomic) IBOutlet UILabel *lblWhishlistText;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constrainstHiehtWishlistView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constrainstHeightCouponsView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constrainstHeightStaysView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constrainstHeightProfileView;
- (IBAction)btnSearchStayTapped:(id)sender;

- (IBAction)btnNotificationsTapped:(id)sender;

- (IBAction)btnWishListTapped:(id)sender;
- (IBAction)btnCouponsTapped:(id)sender;

- (IBAction)btnStaysTapped:(id)sender;
- (IBAction)btnProfileTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewWishlistViewContainingBtns;


@property (weak, nonatomic) IBOutlet UIButton *btnMakeWishList;
- (IBAction)btnMakeWishListTapped:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnMyWishList;

- (IBAction)btnMyWishListTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnRefundCoupon;

@property (weak, nonatomic) IBOutlet UIButton *btnMyCoupon;

- (IBAction)btnMyCouponTapped:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnBuyCoupon;
- (IBAction)btnBuyCouponTapped:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *btnCurrentStay;

- (IBAction)btnCurrentStayTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnPastStay;
- (IBAction)btnPastStayTapped:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnPersonalInfo;

- (IBAction)btnPersonalTapped:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnAccDetails;
- (IBAction)btnAccountTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewCoupons;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewWishlist;

@property (weak, nonatomic) IBOutlet UIImageView *imgViewStays;

- (IBAction)btnMyStayDashboardMenuTapped:(id)sender;

- (IBAction)btnMyCouponsDashboardMenuTapped:(id)sender;
- (IBAction)btnWishlistDashboardMenuTapped:(id)sender;
- (IBAction)btnRefundCouponsTapped:(id)sender;

@end

@implementation DashboardScreen

- (void)viewDidLoad {
    [super viewDidLoad];
     DLog(@"DEBUG-VC");
    // Do any additional setup after loading the view.
    self.arrDasboardItems =[[NSMutableArray alloc]init];
    [self.arrDasboardItems addObject:@"Search your stay"];
    [self.arrDasboardItems addObject:@"Notifications"];
    [self.arrDasboardItems addObject:@"Wishlist"];
    [self.arrDasboardItems addObject:@"Voucher"];
    [self.arrDasboardItems addObject:@"Stays"];
    [self.arrDasboardItems addObject:@"Profile"];
    [self.tblDashboardItems reloadData];
    [[ICSingletonManager sharedManager]addBottomMenuToViewController:self onView:self.viewBottom];
   // [self contractAllConstrainstView];
    [self startServiceToGetCouponsDetails];
    BOOL isUserLoggedIn= [[ICSingletonManager sharedManager] detectingIfUserLoggedIn] ;
        [self.btnLogin setHidden:isUserLoggedIn];
    
    self.imgViewCoupons.image = [self.imgViewCoupons.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.imgViewCoupons setTintColor:[UIColor colorWithRed:0.819f green:0.929f blue:0.927f alpha:1]];
    
    
    self.imgViewStays.image = [self.imgViewStays.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.imgViewStays setTintColor:[UIColor colorWithRed:0.698f green:0.921f blue:0.788f alpha:1]];
    
    
    self.imgViewWishlist.image = [self.imgViewWishlist.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.imgViewWishlist setTintColor:[UIColor colorWithRed:0.984f green:0.956f blue:0.721f alpha:1]];
    
    
    //Closing all open tabs
    [self btnWishListTapped:nil];
    [self btnCouponsTapped:nil];
    [self btnStaysTapped:nil];
    [self btnProfileTapped:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark - UITableViewDelegate Methods
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;    //count of section
//}
//
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    
//    return [self.arrDasboardItems count];
//    //[catagorry count];    //count number of row from counting array hear cataGorry is An Array
//}
//
//
//
//- (UITableViewCell *)tableView:(UITableView *)tableView
//         cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    DashboardScreenCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DashboardScreenCell"];
//    
//    //    if (cell == nil)
//    //    {
//    //        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
//    //                                       reuseIdentifier:MyIdentifier] autorelease];
//    //    }
//    
//    cell.lblDashboardItems.text = [self.arrDasboardItems objectAtIndex:indexPath.row];
//    [cell.imgVDashboardItems setImage:[UIImage imageNamed:[self.arrDasboardItems objectAtIndex:indexPath.row]]];
//    return cell;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    NSLog(@"%li",(long)indexPath.row);
//    NSLog(@"%lu",(unsigned long)self.arrDasboardItems.count);
//    if (indexPath.row == 0) {
//        SearchStayScreen *vcSearch = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchStayScreen"];
//        [self.navigationController pushViewController:vcSearch animated:YES];
//    }
//    if (indexPath.row ==1) {
//        NotificationScreen *notification = [self.storyboard instantiateViewControllerWithIdentifier:@"NotificationScreen"];
//        [self.navigationController pushViewController:notification animated:YES];
//    }
//    if (indexPath.row == 2) {
//        CreateWishlistScreen *createWishList =[self.storyboard instantiateViewControllerWithIdentifier:@"CreateWishlistScreen"];
//        [self.navigationController pushViewController:createWishList animated:YES];
//    }
//    if (indexPath.row == self.arrDasboardItems.count-1) {
//        ProfileScreen *vcProfile = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileScreen"];
//        [self.navigationController pushViewController:vcProfile  animated:YES];
//    }
//    
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnMenuTapped:(id)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    //[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - WEBSERVICEMETHOD IMPLEMETATION
- (void)startServiceToGetCouponsDetails{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
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
            
            NSNumber *numCouponCount = [responseObject valueForKey:@"UserCouponCount"];
            NSNumber *numPastStayCount = [responseObject valueForKey:@"UserPastStayCount"];
            NSNumber *numWhishlistCount = [responseObject valueForKey:@"UserWishlistCount"];
            
            [self.lblMyCouponText setText:@"My\nVoucher(s)"];
            [self.lblCouponCount setText:[NSString stringWithFormat:@"%@",numCouponCount]];
            [self.lblmyStayText setText:@"My\nStay(s)"];
            [self.lblPastStayCount setText:[NSString stringWithFormat:@"%@",numPastStayCount]];
            [self.lblWhishlistText setText:@"My\nWishlist"];
            [self.lblWhishlistCount setText:[NSString stringWithFormat:@"%@",numWhishlistCount]];
            if (IS_IPHONE_4 || IS_IPHONE_5) {
                [self.lblMyCouponText setFont:[UIFont systemFontOfSize:16]];
                [self.lblmyStayText setFont:[UIFont systemFontOfSize:16]];
                [self.lblWhishlistText setFont:[UIFont systemFontOfSize:16]];
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



#pragma mark - ViewResiging Constrainst Methods
- (void)contractAllConstrainstView{
    [self.constrainstHeightCouponsView setConstant:0];
    [self.constrainstHeightProfileView setConstant:0];
    [self.constrainstHeightStaysView setConstant:0];
    [self.constrainstHiehtWishlistView setConstant:0];
    
    
}

#pragma SearcYourStay Tapped Method

- (IBAction)btnSearchStayTapped:(id)sender {
//    SearchStayScreen *vcSearch = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchStayScreen"];
//            [self.navigationController pushViewController:vcSearch animated:YES];
    
    
    
    
    
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
- (IBAction)btnNotificationsTapped:(id)sender {
    NotificationScreen *notification = [self.storyboard instantiateViewControllerWithIdentifier:@"NotificationScreen"];
            [self.navigationController pushViewController:notification animated:YES];
    
}

- (IBAction)btnWishListTapped:(id)sender {
   // [self contractAllConstrainstView];
    
    //======

    
    [self.constrainstHeightCouponsView setConstant:0];
    [self.btnMyCoupon setHidden:YES];
    [self.btnBuyCoupon setHidden:YES];
    [self.btnRefundCoupon setHidden:YES];
    
    
    [self.constrainstHeightStaysView setConstant:0];
    [self.btnCurrentStay setHidden:YES];
    [self.btnPastStay setHidden:YES];
    
    [self.constrainstHeightProfileView setConstant:0];
    [self.btnPersonalInfo setHidden:YES];
    [self.btnAccDetails setHidden:YES];


    

    
    //==========
    
    if (self.constrainstHiehtWishlistView.constant == 0){
     [self.constrainstHiehtWishlistView setConstant:80];
        
        [self.btnMakeWishList setHidden:NO];
        [self.btnMyWishList setHidden:NO];
    }
    else{
    [self.constrainstHiehtWishlistView setConstant:0];
      
        
        [self.btnMakeWishList setHidden:YES];
        [self.btnMyWishList setHidden:YES];
        
    }
    
}

- (IBAction)btnCouponsTapped:(id)sender {
    [self.constrainstHiehtWishlistView setConstant:0];
    [self.btnMakeWishList setHidden:YES];
    [self.btnMyWishList setHidden:YES];
    
       [self.constrainstHeightStaysView setConstant:0];
    [self.btnCurrentStay setHidden:YES];
    [self.btnPastStay setHidden:YES];
    
    [self.constrainstHeightProfileView setConstant:0];
    [self.btnPersonalInfo setHidden:YES];
    [self.btnAccDetails setHidden:YES];
    

    
    if (self.constrainstHeightCouponsView.constant == 0) {
        [self.constrainstHeightCouponsView setConstant:120];
        [self.btnMyCoupon setHidden:NO];
        [self.btnBuyCoupon setHidden:NO];
        [self.btnRefundCoupon setHidden:NO];
        
    }
    else{
    [self.constrainstHeightCouponsView setConstant:0];
        [self.btnMyCoupon setHidden:YES];
        [self.btnBuyCoupon setHidden:YES];
        [self.btnRefundCoupon setHidden:YES];

    }
    
}

- (IBAction)btnStaysTapped:(id)sender {
    // [self contractAllConstrainstView];
    [self.constrainstHiehtWishlistView setConstant:0];
    [self.btnMakeWishList setHidden:YES];
    [self.btnMyWishList setHidden:YES];
    
    [self.constrainstHeightCouponsView setConstant:0];
    [self.btnMyCoupon setHidden:YES];
    [self.btnBuyCoupon setHidden:YES];
    [self.btnRefundCoupon setHidden:YES];
    
    [self.constrainstHeightProfileView setConstant:0];
    [self.btnPersonalInfo setHidden:YES];
    [self.btnAccDetails setHidden:YES];
    

    
    if (self.constrainstHeightStaysView.constant == 0) {
         [self.constrainstHeightStaysView setConstant:80];
        [self.btnCurrentStay setHidden:NO];
        [self.btnPastStay setHidden:NO];
    }
    else{
    [self.constrainstHeightStaysView setConstant:0];
        [self.btnCurrentStay setHidden:YES];
        [self.btnPastStay setHidden:YES];

    }
}

- (IBAction)btnProfileTapped:(id)sender {
    
    [self.constrainstHiehtWishlistView setConstant:0];
    [self.btnMakeWishList setHidden:YES];
    [self.btnMyWishList setHidden:YES];
    
    [self.constrainstHeightCouponsView setConstant:0];
    [self.btnMyCoupon setHidden:YES];
    [self.btnBuyCoupon setHidden:YES];
    [self.btnRefundCoupon setHidden:YES];
    
    
    [self.constrainstHeightStaysView setConstant:0];
    [self.btnCurrentStay setHidden:YES];
    [self.btnPastStay setHidden:YES];
    
  

    // [self contractAllConstrainstView];
    if (self.constrainstHeightProfileView.constant == 0) {
        [self.constrainstHeightProfileView setConstant:80];
        [self.btnPersonalInfo setHidden:NO];
        [self.btnAccDetails setHidden:NO];
    }
    else{
    [self.constrainstHeightProfileView setConstant:0];
        [self.btnPersonalInfo setHidden:YES];
        [self.btnAccDetails setHidden:YES];

    }
}
- (IBAction)btnMyCouponTapped:(id)sender {
    MyCouponViewController *myCoupon =[self.storyboard instantiateViewControllerWithIdentifier:@"MyCouponViewController"];
    [self.navigationController pushViewController:myCoupon animated:YES];

    
}

- (IBAction)btnBuyCouponTapped:(id)sender {
    
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
    globals.isFromMenuForBuyVoucher = false;
    
    BuyCouponViewController *buyCoupon =[self.storyboard instantiateViewControllerWithIdentifier:@"BuyCouponViewController"];
    [self.navigationController pushViewController:buyCoupon animated:YES];

}


- (IBAction)btnCurrentStayTapped:(id)sender {
    CurrentStayScreen *currentStayScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"CurrentStayScreen"];
    currentStayScreen.isPastStayScreen = NO;
    [self.navigationController pushViewController:currentStayScreen animated:YES];
}


- (IBAction)btnPastStayTapped:(id)sender {
    CurrentStayScreen *currentStayScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"CurrentStayScreen"];
    currentStayScreen.isPastStayScreen = YES;
    [self.navigationController pushViewController:currentStayScreen animated:YES];
}
- (IBAction)btnPersonalTapped:(id)sender {
    ProfileScreen *vcProfile = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileScreen"];
           [self.navigationController pushViewController:vcProfile  animated:YES];

}
- (IBAction)btnAccountTapped:(id)sender {
    AccountScreen *vcAccount = [self.storyboard instantiateViewControllerWithIdentifier:@"AccountScreen"];
    [self.navigationController pushViewController:vcAccount  animated:YES];
}
- (IBAction)btnMakeWishListTapped:(id)sender {
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
    globals.isFromMenuForMakeWishe = false;
    MakeAWishlistViewController *createWishList =[self.storyboard instantiateViewControllerWithIdentifier:@"MakeAWishlistViewController"];
    [self.navigationController pushViewController:createWishList animated:YES];
    

}

- (IBAction)btnMyWishListTapped:(id)sender {
    MyWishlistViewController *createWishList =[self.storyboard instantiateViewControllerWithIdentifier:@"MyWishlistViewController"];
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
    globals.isFromMenuForWishList = NO;
    [self.navigationController pushViewController:createWishList animated:YES];
}


- (IBAction)btnMyCouponsDashboardMenuTapped:(id)sender {
    
    MyCouponViewController *myCoupon =[self.storyboard instantiateViewControllerWithIdentifier:@"MyCouponViewController"];
    myCoupon.str_CoupenCount = self.lblCouponCount.text;
    [self.navigationController pushViewController:myCoupon animated:YES];
    

}

- (IBAction)btnWishlistDashboardMenuTapped:(id)sender {
    
    MyWishlistViewController *createWishList =[self.storyboard instantiateViewControllerWithIdentifier:@"MyWishlistViewController"];
    [self.navigationController pushViewController:createWishList animated:YES];
//    
//    BuyCouponViewController *buyCoupon =[self.storyboard instantiateViewControllerWithIdentifier:@"BuyCouponViewController"];
//    [self.navigationController pushViewController:buyCoupon animated:YES];
    
}



- (IBAction)btnRefundCouponsTapped:(id)sender {
    
    RefundCouponScreen *refundScreen =[self.storyboard instantiateViewControllerWithIdentifier:@"RefundCouponScreen"];
    [self.navigationController pushViewController:refundScreen animated:YES];

   // [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Refund Coupon coming soon" onController:self ];
}

- (IBAction)btnMyStayDashboardMenuTapped:(id)sender{
    
    CurrentStayScreen *currentStayScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"CurrentStayScreen"];
    currentStayScreen.isPastStayScreen = YES;
    [self.navigationController pushViewController:currentStayScreen animated:YES];

    
}

@end
