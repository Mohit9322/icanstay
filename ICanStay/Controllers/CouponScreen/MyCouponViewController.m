//
//  MyCouponViewController.m
//  ICanStay
//
//  Created by Christina Masih on 22/03/16.
//  Copyright © 2016 verticallogics. All rights reserved.
//

#import "MyCouponViewController.h"
#import "AFNetworking.h"
#import "NSDictionary+JsonString.h"
#import "MBProgressHud.h"
#import "LoginManager.h"
#import "MyCouponCollectionViewCell.h"
#import "MyCouponTableViewCell.h"
#import "MapScreen.h"
#import "MakeAWishlistViewController.h"
#import "BuyCouponViewController.h"
#import "GiftedCouponCell.h"
#import "ShareExperienceScreen.h"
#define KTableHeigthForRow      150
#import <QuartzCore/QuartzCore.h>
#import "NotificationScreen.h"
#import "DashboardScreen.h"
#import "MyWishlistViewController.h"
#import "RefundCouponScreen.h"
#import "GradientButton.h"
#import "HomeScreenController.h"
#import "SideMenuController.h"
/*
//#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
//#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
//#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define IS_IPAD_PRO (IS_IPAD && SCREEN_MAX_LENGTH == 1366.0)
*/
@interface MyCouponViewController ()<MyCouponTableViewCellDelegate>

- (IBAction)btnMakeWishListTapped:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *BtnBaseView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constrainstHeightTblView;
@property (strong, nonatomic) IBOutlet UIImageView *icsLogoImgView;

- (IBAction)btnBuyMoreCouponTapped:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *tblViewGiftedCoupons;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstrainstGiftedCoupon;
@property (weak, nonatomic) IBOutlet UIButton *btnMakeWishlist;

@property (weak, nonatomic) IBOutlet UIButton *btnSearchRedeemCoupon;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *redeemedVoucherConst;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *giftedVoucherConst;

@property (weak, nonatomic) IBOutlet UILabel *lblRedeemVoucher;
@property (weak, nonatomic) IBOutlet UILabel *lblGiftVoucher;

@property (weak, nonatomic) IBOutlet UIButton *btnBuyCoupons;
@property (weak, nonatomic) IBOutlet UILabel *lblRedeemCoupons;
@property (weak, nonatomic) IBOutlet UILabel *lblGiftedCoupons;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstrainstCollectionView;
@property (nonatomic, strong) NSMutableArray *modifiedCouponListRefundedArr;
@property (nonatomic, strong) GradientButton *makeAWishListBtn;
@property (nonatomic, strong) GradientButton *searchRedeemBtn;
@property (nonatomic, strong) GradientButton *buyMoreVoucherBtn;
@property (nonatomic, strong) GradientButton *refundVoucherBtn;

@end

@implementation MyCouponViewController

- (void)viewDidLoad {
     DLog(@"DEBUG-VC");
//    self.btnMakeWishlist.layer.cornerRadius = 10;
//    self.btnMakeWishlist.clipsToBounds = YES;
//    
//    self.btnSearchRedeemCoupon.layer.cornerRadius = 10;
//    self.btnSearchRedeemCoupon.clipsToBounds = YES;
//
//    self.btnBuyCoupons.layer.cornerRadius = 10;
//    self.btnBuyCoupons.clipsToBounds = YES;

    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //[self getRedeemedCouponList];
    
    self.makeAWishListBtn =  [[GradientButton alloc]init];
    self.makeAWishListBtn.frame = CGRectMake(0,0,self.view.frame.size.width - 65,45);
    [self.makeAWishListBtn setTitle:@"MAKE A WISHLIST" forState:UIControlStateNormal];
    [self.makeAWishListBtn useRedDeleteStyle];
    [self.makeAWishListBtn addTarget:self action:@selector(wishListTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.BtnBaseView addSubview:self.makeAWishListBtn];
    
    self.searchRedeemBtn =  [[GradientButton alloc]init];
    self.searchRedeemBtn.frame = CGRectMake(0,55,self.view.frame.size.width - 65,45);
    [self.searchRedeemBtn setTitle:@"Search & Redeem" forState:UIControlStateNormal];
 //   self.searchRedeemBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.searchRedeemBtn useRedDeleteStyle];
    [self.searchRedeemBtn addTarget:self action:@selector(searchRedeemBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.BtnBaseView addSubview:self.searchRedeemBtn];
    
    
    self.buyMoreVoucherBtn =  [[GradientButton alloc]init];
    self.buyMoreVoucherBtn.frame = CGRectMake(0,110,self.view.frame.size.width - 65,45);
    [self.buyMoreVoucherBtn setTitle:@"BUY MORE VOUCHER(S)" forState:UIControlStateNormal];
    [self.buyMoreVoucherBtn useRedDeleteStyle];
  //  self.buyMoreVoucherBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.buyMoreVoucherBtn addTarget:self action:@selector(buyMoreVoucherBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.BtnBaseView addSubview:self.buyMoreVoucherBtn];
    
    self.refundVoucherBtn =  [[GradientButton alloc]init];
    self.refundVoucherBtn.frame = CGRectMake(0,165,self.view.frame.size.width - 65,45);
    [self.refundVoucherBtn setTitle:@"REFUND VOUCHER" forState:UIControlStateNormal];
    [self.refundVoucherBtn useRedDeleteStyle];
    [self.refundVoucherBtn addTarget:self action:@selector(refundVoucherBtnRegTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.BtnBaseView addSubview:self.refundVoucherBtn];
    
    self.icsLogoImgView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTapo:)];
    [self.icsLogoImgView addGestureRecognizer:singleFingerTap];

}
- (void)handleSingleTapo:(UITapGestureRecognizer *)recognizer
{
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
    
    
}
-(void)wishListTapped:(id)sender
{
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
    globals.isFromMenuForWishList = true;
    
    MyWishlistViewController *buyCoupon =[self.storyboard instantiateViewControllerWithIdentifier:@"MyWishlistViewController"];
    [self.mm_drawerController setCenterViewController:buyCoupon withCloseAnimation:YES completion:nil];
}
-(void)searchRedeemBtn:(id)sender
{
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"validVoucher"] != 0) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Search Your Stay" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"By Current Location",@"By City", nil];
        [alert show];
    }
    else{
        globals.isFromMenuForBuyVoucher = false;
        BuyCouponViewController *buyCoupon =[self.storyboard instantiateViewControllerWithIdentifier:@"BuyCouponViewController"];
        [self.navigationController pushViewController:buyCoupon animated:YES];
    }
    
}
-(void)buyMoreVoucherBtnTapped:(id)sender
{
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
    globals.isFromMenuForBuyVoucher = false;
    BuyCouponViewController *buyCoupon =[self.storyboard instantiateViewControllerWithIdentifier:@"BuyCouponViewController"];
    [self.navigationController pushViewController:buyCoupon animated:YES];
}
-(void)refundVoucherBtnRegTapped:(id)sender
{
    RefundCouponScreen *refundCoupon =[self.storyboard instantiateViewControllerWithIdentifier:@"RefundCouponScreen"];
    refundCoupon.strVoucherCount = _str_CoupenCount;
    [self.navigationController pushViewController:refundCoupon animated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    [tracker set:kGAIScreenName value:@"My Voucher"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    [[ICSingletonManager sharedManager]addBottomMenuToViewController:self onView:self.viewBottom];
    [self getMyCouponList];
}
-(void)viewDidLayoutSubviews
{
    //CGFloat height = MIN(self.view.bounds.size.height, self.tableView.contentSize.height);
    self.constrainstHeightTblView.constant = self.redeemedCouponTableView.contentSize.height;
    self.heightConstrainstGiftedCoupon.constant = self.tblViewGiftedCoupons.contentSize.height;
    [self.view layoutIfNeeded];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//service to get preferred location
-(void)getMyCouponList
{
    //http://dev.icanstay.businesstowork.com/api/CouponApi/UserCouponDetails?userID=31458
    
    LoginManager *loginManage = [[LoginManager alloc]init];
    NSDictionary *dict = [loginManage isUserLoggedIn];
    NSNumber *num = [dict valueForKey:@"UserId"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *strParams = [NSString stringWithFormat:@"userid=%@",num];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8"
                     forHTTPHeaderField:@"Content-Type"];
    
    //api/CouponApi/UserCouponDetails
    [manager GET:[NSString stringWithFormat:@"%@/api/CouponApi/GetMyCouponDetailMobile?%@",kServerUrl,strParams] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        NSDictionary *dict = (NSDictionary *)responseObject;
        
        self.arrayCouponList = [dict valueForKey:@"CouponDetails"];
//        self.arrayCouponList=[[[self.arrayCouponList reverseObjectEnumerator] allObjects] mutableCopy];
        self.couponTitleMessage.text = [dict valueForKey:@"CouponCountMsg"];
        
        if (self.arrayCouponList.count>0)
        {
        
            self.arrayRedeemedCouponList = [dict valueForKey:@"RedeemedCouponDetails"];
            self.arrGiftedCouponList = [dict valueForKey:@"GiftedCouponList"];
            self.arrayRedeemedCouponList=[[[self.arrayRedeemedCouponList reverseObjectEnumerator] allObjects] mutableCopy];
            self.arrGiftedCouponList=[[[self.arrGiftedCouponList reverseObjectEnumerator] allObjects] mutableCopy];
//
//            
//        if (self.arrayRedeemedCouponList.count > 0) {
//            [self.redeemedCouponTableView reloadData];
//            [self.redeemedCouponTableView setHidden:NO];
//
//        }
//        else{
//            //[self.lblRedeemCoupons setHidden:YES];
//
//            [self.redeemedCouponTableView setHidden:YES];
//        }
//        if (self.arrGiftedCouponList.count >0) {
//            [self.tblViewGiftedCoupons reloadData];
//             [self.tblViewGiftedCoupons setHidden:NO];
//        }
//        else{
//           // [self.lblGiftedCoupons setHidden:YES];
//
//            [self.tblViewGiftedCoupons setHidden:YES];
//        }
            [self.lblGiftVoucher setHidden:YES];
            [self.lblRedeemVoucher setHidden:YES];
            [self.tblViewGiftedCoupons setHidden:YES];
            [self.redeemedCouponTableView setHidden:YES];
            
            [self.view_CoupenDetails setHidden:NO];
            
            self.modifiedCouponListRefundedArr = [[NSMutableArray alloc]initWithArray:self.arrayCouponList];
            
            [self.modifiedCouponListRefundedArr enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                if ([[obj valueForKey:@"Refund_Status"] isEqualToString:@"R"] || [[obj valueForKey:@"Refund_Status"] isEqualToString:@"Y"])
                {
                    if ([self.modifiedCouponListRefundedArr containsObject:obj]) {
                        [self.modifiedCouponListRefundedArr removeObject:obj];
                        [self.modifiedCouponListRefundedArr insertObject:obj atIndex:([self.modifiedCouponListRefundedArr count] )];
                    }
                }
              }];
            [self.myCouponCollectionView reloadData];
        }
        else
        {
            [self.lblGiftVoucher setHidden:YES];
            [self.lblRedeemVoucher setHidden:YES];
            [self.redeemedCouponTableView setHidden:YES];
            [self.tblViewGiftedCoupons setHidden:YES];
            [self.btnMakeWishlist setHidden:YES];
            [self.btnSearchRedeemCoupon setHidden:YES];
            [self.lblGiftedCoupons setHidden:YES];
            [self.lblRedeemCoupons setHidden:YES];
            [self.view_CoupenDetails setHidden:YES];
            [self.heightConstrainstCollectionView setConstant:0];
        }
        ICSingletonManager *globals = [ICSingletonManager sharedManager];
        if ([[ICSingletonManager getStringValue:[NSString stringWithFormat:@"%@",_str_CoupenCount]] isEqualToString:@""])
        {
            _lbl_VoucherCount.text = @"0";
        }else{
            _lbl_VoucherCount.text = globals.myVoucherCount;
        }
        UITapGestureRecognizer *singleFingerTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        self.lblRedeemCoupons.userInteractionEnabled = YES;
        self.lblRedeemCoupons.tag=1;
        [self.lblRedeemCoupons addGestureRecognizer:singleFingerTap1];
        
        UITapGestureRecognizer *singleFingerTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        self.lblGiftedCoupons.userInteractionEnabled = YES;
        self.lblGiftedCoupons.tag=2;
        [self.lblGiftedCoupons addGestureRecognizer:singleFingerTap2];
        

//        NSString *status = [responseObject valueForKey:@"status"];
//        NSString *msg = [responseObject valueForKey:@"errorMessage"];
//        if ([status isEqualToString:@"SUCCESS"]) {
//            
//        }
        
//        NSLog(@"sucess");
//        [[ICSingletonManager sharedManager]showAlertViewWithMsg:msg onController:self];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:error.localizedDescription onController:self];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)tapGesture {
  
    if (tapGesture.view.tag==1)
    {
        if ([self.redeemedCouponTableView isHidden])
        {
            [self.redeemedVoucherConst setConstant:self.arrayRedeemedCouponList.count*155];
            [self.redeemedCouponTableView setHidden:NO];
            [self.lblRedeemVoucher setHidden:NO];

            [self.redeemedCouponTableView reloadData];
        }
        else
        {
            [self.redeemedVoucherConst setConstant:0];
            [self.redeemedCouponTableView setHidden:YES];
            [self.lblRedeemVoucher setHidden:YES];

        }
    }
    else
    {
        
        if ([self.tblViewGiftedCoupons isHidden])
        {
            [self.giftedVoucherConst setConstant:self.arrGiftedCouponList.count*155];
            [self.tblViewGiftedCoupons setHidden:NO];
            [self.lblGiftVoucher setHidden:NO];
            [self.tblViewGiftedCoupons reloadData];
        }
        else
        {
            [self.giftedVoucherConst setConstant:0];
            [self.tblViewGiftedCoupons setHidden:YES];
            [self.lblGiftVoucher setHidden:YES];

        }
    }
}

//service to get preferred location
-(void)getRedeemedCouponList
{
    //http://192.168.2.5:8585/api/CouponApi/UserRedeemedCouponDetails?userID=31458
    //IsHotelMappedCity parameter
    
    LoginManager *loginManage = [[LoginManager alloc]init];
    NSDictionary *dict = [loginManage isUserLoggedIn];
    NSNumber *num = [dict valueForKey:@"UserId"];

    NSString *strParams = [NSString stringWithFormat:@"userid=%@",num];
    //  [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8"
                     forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:[NSString stringWithFormat:@"%@/api/CouponApi/UserRedeemedCouponDetails?%@",kServerUrl,strParams] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        self.arrayRedeemedCouponList = responseObject;
        if (self.arrayRedeemedCouponList.count > 0) {
            [self.redeemedCouponTableView setHidden:NO];
        } else {
            [self.redeemedCouponTableView setHidden:YES];
        }
        [self.redeemedCouponTableView reloadData];

//        NSString *status = [responseObject valueForKey:@"status"];
//        NSString *msg = [responseObject valueForKey:@"errorMessage"];
//        if ([status isEqualToString:@"SUCCESS"]) {
//        }
//        
//        NSLog(@"sucess");
//        [[ICSingletonManager sharedManager]showAlertViewWithMsg:msg onController:self];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        NSString *msg = [error description];
        
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:error.localizedDescription onController:self];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
    
}

#pragma mark - CollectionView
#pragma mark DataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrayCouponList.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
   
    
    static NSString *CellIdentifier = @"Cell";
    NSDictionary *couponDictionary = [self.modifiedCouponListRefundedArr objectAtIndex:indexPath.row];

    MyCouponCollectionViewCell *cell = (MyCouponCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
//    cell.couponStartDate.text = [NSString stringWithFormat:@"Valid From %@",[couponDictionary objectForKey:@"CreatedDate"]];
    cell.couponExpiryDate.text = [NSString stringWithFormat:@"VALID FROM %@ TO %@",[couponDictionary objectForKey:@"CreatedDate"],[couponDictionary objectForKey:@"ExpiryDate"]];
    cell.couponMessage.text = @"LUXURY STAY VOUCHER";
    cell.couponTitle.text = [couponDictionary objectForKey:@"CouponCode"];
    [cell.lblRefundRequested setText:[couponDictionary valueForKey:@"Refund_Status_Desc"]];
    [cell.lblUserName setText:[couponDictionary objectForKey:@"Name"]];
    
    [[cell.contentView viewWithTag:100] removeFromSuperview];
    if ([[couponDictionary valueForKey:@"Refund_Status"] isEqualToString:@"R"] || [[couponDictionary valueForKey:@"Refund_Status"] isEqualToString:@"Y"])
    {
        cell.alpha = 0.56f;
        cell.userInteractionEnabled = NO;
        //rgb(119,117,131)
//        UIImageView *img_Front = [[UIImageView alloc]initWithFrame:cell.contentView.frame];
//        img_Front.tag = 100;
//        img_Front.backgroundColor = [UIColor colorWithRed:(119.0f/255.0f) green:(117.0f/255.0f) blue:(131.0f/255.0f) alpha:0.56f];
//        [cell.contentView addSubview:img_Front];
//        [cell.contentView bringSubviewToFront:img_Front];
        //cell.backgroundColor = [UIColor colorWithRed:0.501f green:0.501f blue:0.501f alpha:1];
        //[[ICSingletonManager sharedManager] addingBorderToUIView:cell withColor:[UIColor yellowColor]];
        [cell.lblRefundRequested setHidden:NO];

    }
    else
    {
        //cell.backgroundColor = [ICSingletonManager colorFromHexString:@"#BD9854"];
//        cell.backgroundColor = [UIColor colorWithRed:0.93725f green:0.54901f blue:0.24705f alpha:1];
        //[[ICSingletonManager sharedManager] addingBorderToUIView:cell withColor:[UIColor lightGrayColor]];
        [cell.lblRefundRequested setHidden:YES];
    }
   
    if (IS_IPHONE_5) {
        cell.couponTitle.font = [UIFont boldSystemFontOfSize:22.0];
        cell.couponMessage.font = [UIFont systemFontOfSize:10.0];
        cell.couponStartDate.font = [UIFont systemFontOfSize:10.0];
        cell.couponExpiryDate.font = [UIFont systemFontOfSize:10.0];

    } else {
        cell.couponTitle.font = [UIFont boldSystemFontOfSize:24.0];
        cell.couponMessage.font = [UIFont systemFontOfSize:13.0];
        cell.couponStartDate.font = [UIFont systemFontOfSize:11.0];
        cell.couponExpiryDate.font = [UIFont systemFontOfSize:11.0];
    }
    return cell;

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (IS_IPHONE_5) {
//        return CGSizeMake(115, 130);
//
//    } else {
        return CGSizeMake(collectionView.frame.size.width-50, 140);
    //}
}
#pragma mark Collection view cell layout / size


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *redeemedCouponDictionary = [self.modifiedCouponListRefundedArr objectAtIndex:indexPath.row];
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
    globals.isFromMenuForWishList = true;
    
    
    
    MyWishlistViewController *buyCoupon =[self.storyboard instantiateViewControllerWithIdentifier:@"MyWishlistViewController"];
    buyCoupon.selectedIndexCouponCodeMyVoucher = [NSString stringWithFormat:@"%@", [redeemedCouponDictionary objectForKey:@"CouponCode"]];
    [self.mm_drawerController setCenterViewController:buyCoupon withCloseAnimation:YES completion:nil];

}

#pragma mark - UITableview Data source & Delegate
    
#pragma mark - TableView Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tblViewGiftedCoupons) {
        return self.arrGiftedCouponList.count;
       // return 5;
    }
    else
    return self.arrayRedeemedCouponList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tblViewGiftedCoupons)
    {
        GiftedCouponCell *cell ;
        cell = (GiftedCouponCell*)[tableView dequeueReusableCellWithIdentifier:@"GiftedCouponCell"];
        NSDictionary *dict = [self.arrGiftedCouponList objectAtIndex:indexPath.row];
        //[cell settingAllValuesFromDict:dict];
        [cell.lblCouponCodeValue setText:[dict valueForKey:@"CouponCode"]];
        
        [cell.lblGiftedToValue setText:[NSString stringWithFormat:@"%@,%@",[dict valueForKey:@"FIRST_NAME"],[dict valueForKey:@"LAST_NAME"]]];
        [cell.lblDayeOfStayValue setText:[[ICSingletonManager sharedManager] gettingNewlyFormattedDateStringFromString:[dict valueForKey:@"GiftDate"]]];
//        cell.resendCredentialBtn.layer.cornerRadius = 10;
//        cell.resendCredentialBtn.clipsToBounds = YES;
        
        return cell;
    }
    else
    {
        static NSString *CellIdentifier1 = @"TableCell";
        NSDictionary *redeemedCouponDictionary = [self.arrayRedeemedCouponList objectAtIndex:indexPath.row];
        MyCouponTableViewCell *cell;
        //Code for setting table view cell
        cell = (MyCouponTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        if (cell == nil) {
            cell = [[MyCouponTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier1];
        }
        // Configure the cell...
        cell.dictCouponData = redeemedCouponDictionary;
        cell.destinationName.text = [redeemedCouponDictionary objectForKey:@"CITY_NAME"];
        cell.couponCode.text = [redeemedCouponDictionary objectForKey:@"CouponCode"];
        cell.dateOfStay.text = [redeemedCouponDictionary objectForKey:@"StayDate"];
        cell.m_delegate =self;
        if ([[redeemedCouponDictionary valueForKey:@"FeedBackStatus"] intValue]  ==1) {
            [cell.btnShareYourFeedback setTitle:@"Feedback Received" forState:UIControlStateNormal];
        }
        else {
            [cell.btnShareYourFeedback setTitle:@"Share Your Experience" forState:UIControlStateNormal];
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return KTableHeigthForRow;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



- (IBAction)backButtonTap:(id)sender {
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
    
    if (globals.isFromMenu)
    {
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }

//    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)redeemedCouponTap:(id)sender {
//    MapScreen *mapScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"MapScreen"];
//    [self.navigationController pushViewController:mapScreen animated:YES];
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"validVoucher"] != 0) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Search Your Stay" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"By Current Location",@"By City", nil];
        [alert show];
    }
    else{
        globals.isFromMenuForBuyVoucher = false;
        BuyCouponViewController *buyCoupon =[self.storyboard instantiateViewControllerWithIdentifier:@"BuyCouponViewController"];
        [self.navigationController pushViewController:buyCoupon animated:YES];
    }
    

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
- (IBAction)btnMakeWishListTapped:(id)sender {
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
    globals.isFromMenuForWishList = true;
    
    MyWishlistViewController *buyCoupon =[self.storyboard instantiateViewControllerWithIdentifier:@"MyWishlistViewController"];
    [self.mm_drawerController setCenterViewController:buyCoupon withCloseAnimation:YES completion:nil];

   
}

- (IBAction)btnBuyMoreCouponTapped:(id)sender {
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
    globals.isFromMenuForBuyVoucher = false;
    BuyCouponViewController *buyCoupon =[self.storyboard instantiateViewControllerWithIdentifier:@"BuyCouponViewController"];
    [self.navigationController pushViewController:buyCoupon animated:YES];

}
- (IBAction)btnRefundVoucherTapped:(id)sender {
    RefundCouponScreen *refundCoupon =[self.storyboard instantiateViewControllerWithIdentifier:@"RefundCouponScreen"];
    refundCoupon.strVoucherCount = _str_CoupenCount;
    [self.navigationController pushViewController:refundCoupon animated:YES];
}

#pragma mark - MyCouponTableViewCellDelegateMethods
-(void)switchToShareExperienceScreenWithDictionary:(NSDictionary *)dict{
    ShareExperienceScreen *shareScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"ShareExperienceScreen"];
    
    if ([[dict valueForKey:@"FeedBackStatus"] intValue]  ==1) {
        
        shareScreen.ifFromfeedBack = YES;
    }
    else {
        shareScreen.ifFromfeedBack = NO;
    }
    
    shareScreen.dictionaryCoupon = dict;// [dict valueForKey:@"CouponCode"];
    [self.navigationController pushViewController:shareScreen animated:YES];
}

#pragma mark -Notification Actions Methods
- (IBAction)notificationButtonTapped:(id)sender
{
    LoginManager *login = [[LoginManager alloc]init];
    if ([[login isUserLoggedIn] count]>0)
    {
        ICSingletonManager *globals = [ICSingletonManager sharedManager];
        globals.isWithoutLoginNoti = false;
        NotificationScreen *notification = [self.storyboard instantiateViewControllerWithIdentifier:@"NotificationScreen"];
        [self.navigationController pushViewController:notification animated:YES];
    }
    else
    {
        ICSingletonManager *globals = [ICSingletonManager sharedManager];
        globals.isWithoutLoginNoti = true;
        [self switchToLoginScreen];
    }
}
- (void)switchToLoginScreen
{
    [[NSNotificationCenter defaultCenter ]addObserver:self selector:@selector(pushToDashBoardScreenAfterLoggingIn) name:kSwitchToDashBoardScreen object:nil];
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
    globals.isFromMenu = false;
    
    LoginScreen *vcLogin = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginScreen"];
    [self.navigationController pushViewController:vcLogin animated:YES];
}
- (void)pushToDashBoardScreenAfterLoggingIn
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    DashboardScreen *dashboardScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"DashboardScreen"];
    [self.mm_drawerController setCenterViewController:dashboardScreen withCloseAnimation:NO completion:nil];
}

@end
