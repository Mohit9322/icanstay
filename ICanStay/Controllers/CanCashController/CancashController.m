//
//  CancashController.m
//  ICanStay
//
//  Created by Planet on 11/16/17.
//  Copyright © 2017 verticallogics. All rights reserved.
//

#import "CancashController.h"
#import "NotificationScreen.h"
#import "DashboardScreen.h"
#import "CanCashDetailTableViewCell.h"
#import "ReferAndEarnVC.h"
#import "ProfileScreen.h"
#import "BuyCouponViewController.h"
#import "LastMinuteViewController.h"
#import "PackagesViewController.h"
#import "SideMenuController.h"
#import "ReferAndEarnWeb.h"
#import "GradientButton.h"
#import "HomeScreenController.h"
#import "SideMenuController.h"

@interface CancashController ()<UITableViewDelegate, UITableViewDataSource>
{
      NSString  *contactSyncOrNot;
}
@property (nonatomic, strong) UIView         *topWhiteBaseView;
@property (nonatomic, strong) UIButton       *backButton;
@property (nonatomic, strong) UIButton       *notificationButton;
@property (nonatomic, strong) UIImageView    *logoIconImgView;
@property (nonatomic, strong) UITableView    *tableView;
@property (nonatomic, strong) NSMutableArray *detailArr;
@end

@implementation CancashController

- (void)viewDidLoad {
   
    [super viewDidLoad];
    _detailArr = [[NSMutableArray alloc]init];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    self.topWhiteBaseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,screenRect.size.width , 64)];
    self.topWhiteBaseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.topWhiteBaseView];
    
    self.notificationButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.notificationButton.frame = CGRectMake(self.topWhiteBaseView.frame.size.width - 40 - 10, 20, 24, 24);
    [self.notificationButton setBackgroundImage:[UIImage imageNamed:@"notification1"] forState:UIControlStateNormal];
    [self.notificationButton addTarget:self action:@selector(notificationButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.topWhiteBaseView addSubview:self.notificationButton];
    
    
    self.logoIconImgView = [[UIImageView alloc]initWithFrame:CGRectMake((self.topWhiteBaseView.frame.size.width - 150)/2, 15, 150, 34)];
    self.logoIconImgView.image = [UIImage imageNamed:@"topBanner"];
    self.logoIconImgView.userInteractionEnabled = YES;
    [self.topWhiteBaseView addSubview:self.logoIconImgView];
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [self.topWhiteBaseView addGestureRecognizer:singleFingerTap];
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.backButton.frame = CGRectMake(20, 22, 30, 20);
    [self.backButton setBackgroundImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.topWhiteBaseView addSubview:self.backButton];
    
    [self getCanCashDetail];
    // Do any additional setup after loading the view.
}
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
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
-(void)getCanCashDetail
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8"
                     forHTTPHeaderField:@"Content-Type"];
    
    LoginManager *loginManage = [[LoginManager alloc]init];
    NSDictionary *dict2 = [loginManage isUserLoggedIn];
    NSNumber *num = [dict2 valueForKey:@"UserId"];
    
    NSString *strUrl = [NSString stringWithFormat:@"%@/api/FAQApi/GetAllNotificationSettings?userId=%@",kServerUrl,num];
    [manager GET:strUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        
        _detailArr = responseObject;
        [self getContactSyncStatus];
        
    //    [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:error.localizedDescription onController:self];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}

-(void)getContactSyncStatus
{
 //   [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8"
                     forHTTPHeaderField:@"Content-Type"];
    
    LoginManager *loginManage = [[LoginManager alloc]init];
    NSDictionary *dict2 = [loginManage isUserLoggedIn];
    NSNumber *num = [dict2 valueForKey:@"UserId"];
    
    NSString *strUrl = [NSString stringWithFormat:@"%@/api/faqapi/UserValidForCancashReferal?userid=%@",kServerUrl,num];
    [manager GET:strUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        
        NSString *str = [responseObject objectForKey:@"ValidForRef"];
        if ([str isEqualToString:@"Yes"]) {
            contactSyncOrNot = @"NO";
        }else{
            contactSyncOrNot = @"YES";
        }
        
      
        [self designBaseView];
        
        
        
        
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:error.localizedDescription onController:self];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}

-(void)designBaseView
{
    UIView *baseView = [[UIView alloc]initWithFrame:CGRectMake(0, self.topWhiteBaseView.frame.size.height + self.topWhiteBaseView.frame.origin.y, self.view.frame.size.width, 80)];
    baseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:baseView];
    
    
  UIButton *  referNowBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    referNowBtn.frame = CGRectMake(self.view.frame.size.width - 85,10,80, 20);
    [referNowBtn setTitle:@"View Profile" forState:UIControlStateNormal];
    [referNowBtn addTarget:self action:@selector(referNowBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [referNowBtn setTintColor:[UIColor grayColor]];
    [referNowBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
    [baseView addSubview:referNowBtn];
    
    UIView *shareViaNarrowLine = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 85, referNowBtn.frame.size.height + referNowBtn.frame.origin.y , referNowBtn.frame.size.width, 1)];
    shareViaNarrowLine.backgroundColor = [UIColor grayColor];
    [baseView addSubview:shareViaNarrowLine];
    
    
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
    UILabel *priceLbl = [[UILabel alloc]initWithFrame:CGRectMake(85, 10, self.view.frame.size.width - 170, 20)];
    priceLbl.text = [NSString stringWithFormat:@"Total icanCash Balance"];
    priceLbl.font = [UIFont systemFontOfSize:15];
    priceLbl.textAlignment = NSTextAlignmentCenter;
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"₹%@",globals.userCancashAmountAvailable]];
    int length = [globals.userCancashAmountAvailable length];

    [text addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0,length+1 )];
    [text addAttribute:NSForegroundColorAttributeName value:[ICSingletonManager colorFromHexString:@"#bd9854"] range:NSMakeRange(0,length+1 )];
//     [text addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:22] range:NSMakeRange(23,length +1 )];
//      [text addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(23,length+1)];
   
    

    [baseView addSubview:priceLbl];
    
    UILabel *amountLbl = [[UILabel alloc]initWithFrame:CGRectMake(85,priceLbl.frame.origin.y + priceLbl.frame.size.height , self.view.frame.size.width - 170, 20)];
    amountLbl.attributedText = text;
     amountLbl.textAlignment = NSTextAlignmentCenter;
    [baseView addSubview:amountLbl];
    
    

    UIView *buttonBaseView = [[UIView alloc]initWithFrame:CGRectMake(0,amountLbl.frame.size.height + amountLbl.frame.origin.y , baseView.frame.size.width, 25)];
    
    [baseView addSubview:buttonBaseView];
    
    UIButton *voucherButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
   
  
    [voucherButton addTarget:self action:@selector(voucherButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [voucherButton setTintColor:[ICSingletonManager colorFromHexString:@"#001d3d"]];
   
    voucherButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    [buttonBaseView addSubview:voucherButton];
    
    UIView *voucherNarrowLine = [[UIView alloc]init];
    voucherNarrowLine.backgroundColor = [ICSingletonManager colorFromHexString:@"#001d3d"];
    [buttonBaseView addSubview:voucherNarrowLine];
    
    
    UIButton *hotelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
   
    [hotelButton addTarget:self action:@selector(hotelButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [hotelButton setTintColor:[ICSingletonManager colorFromHexString:@"#001d3d"]];
    
    hotelButton.titleLabel.textAlignment = NSTextAlignmentRight;
    [buttonBaseView addSubview:hotelButton];
    
    UIView *hotelNarrowLine = [[UIView alloc]init];
    hotelNarrowLine.backgroundColor = [ICSingletonManager colorFromHexString:@"#001d3d"];
    [buttonBaseView addSubview:hotelNarrowLine];
    
    UIButton *packageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
   
    [packageButton addTarget:self action:@selector(packageButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [packageButton setTintColor:[ICSingletonManager colorFromHexString:@"#001d3d"]];
  
    packageButton.titleLabel.textAlignment = NSTextAlignmentRight;
 //   [buttonBaseView addSubview:packageButton];
    
    UIView *packageNarrowLine = [[UIView alloc]init];
    packageNarrowLine.backgroundColor = [ICSingletonManager colorFromHexString:@"#001d3d"];
 //   [buttonBaseView addSubview:packageNarrowLine];
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [hotelButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [voucherButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [packageButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
         voucherButton.frame = CGRectMake(10, 0 , 160, 20);
        voucherNarrowLine.frame = CGRectMake(10, voucherButton.frame.size.height + voucherButton.frame.origin.y , 160, 1);
        hotelButton.frame = CGRectMake((buttonBaseView.frame.size.width - 450 - 20)/2 + 160, 0 , 150, 20);
        hotelNarrowLine.frame =  CGRectMake((buttonBaseView.frame.size.width - 450 - 20)/2 + 160, hotelButton.frame.size.height + hotelButton.frame.origin.y , 150, 1);
         packageButton.frame = CGRectMake((buttonBaseView.frame.size.width - 450 - 20) + 160 + 140, 0 , 140, 20);
        packageNarrowLine.frame = CGRectMake((buttonBaseView.frame.size.width - 450 - 20) + 160 + 140, packageButton.frame.size.height + packageButton.frame.origin.y , 140, 1);
          [voucherButton setTitle:@"Buy Luxury Voucher" forState:UIControlStateNormal];
         [hotelButton setTitle:@"Book Luxury Hotel" forState:UIControlStateNormal];
         [packageButton setTitle:@"Holiday Packages" forState:UIControlStateNormal];
        
    }else{
        [hotelButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [voucherButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [packageButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [voucherButton setTitle:@"Buy Luxury Voucher" forState:UIControlStateNormal];
        [hotelButton setTitle:@"Book Luxury Hotel" forState:UIControlStateNormal];
        [packageButton setTitle:@"Holiday Packages" forState:UIControlStateNormal];
     
        voucherButton.frame = CGRectMake(2, 0 , 140, 20);
        voucherNarrowLine.frame = CGRectMake(2, voucherButton.frame.size.height + voucherButton.frame.origin.y , 140, 1);
       
        hotelButton.frame = CGRectMake(buttonBaseView.frame.size.width - 140, 0 ,150, 20);
        hotelNarrowLine.frame =  CGRectMake(hotelButton.frame.origin.x, hotelButton.frame.size.height + hotelButton.frame.origin.y , hotelButton.frame.size.width, 1);
    
        packageButton.frame = CGRectMake((buttonBaseView.frame.size.width - 300 - 4) + 90 + 90, 0 , 120, 20);
        packageNarrowLine.frame = CGRectMake((buttonBaseView.frame.size.width - 300 - 4) + 90 + 90, packageButton.frame.size.height + packageButton.frame.origin.y , 120, 1);
         hotelButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    UIView *bottomBaseView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 136, buttonBaseView.frame.size.width, 0)];
  //  [self.view addSubview:bottomBaseView];
    
    
    /******************  bottom BaseView *************/
    UILabel *sharedContactLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, bottomBaseView.frame.size.width, 20)];
    sharedContactLbl.text = @"Have you shared your phone contacts yet?";
    sharedContactLbl.font = [UIFont systemFontOfSize:15];
    sharedContactLbl.textAlignment = NSTextAlignmentCenter;
    [bottomBaseView addSubview:sharedContactLbl];
    
    UILabel *referLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, sharedContactLbl.frame.size.height + sharedContactLbl.frame.origin.y, bottomBaseView.frame.size.width, 40)];
    referLbl.text = @"Refer icanstay to contacts in your phone and earn additional ₹5,000 icanCash";
    referLbl.font = [UIFont systemFontOfSize:15];
    referLbl.textAlignment = NSTextAlignmentCenter;
    referLbl.lineBreakMode = NSLineBreakByWordWrapping;
    referLbl.numberOfLines = 2;
    [bottomBaseView addSubview:referLbl];
   
    
    GradientButton *shareContactsNowBtn =  [[GradientButton alloc]init];
    [shareContactsNowBtn setTitle:@"SHARE CONTACTS NOW" forState:UIControlStateNormal];
    shareContactsNowBtn.frame = CGRectMake((bottomBaseView.frame.size.width - 200)/2,referLbl.frame.size.height + referLbl.frame.origin.y , 200, 40);
    [shareContactsNowBtn setTintColor:[UIColor blackColor]];
    [shareContactsNowBtn useRedDeleteStyle];
    shareContactsNowBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [shareContactsNowBtn addTarget:self action:@selector(shareContactButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBaseView addSubview:shareContactsNowBtn];
    
    
    UIButton *noThanksButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    noThanksButton.frame = CGRectMake((bottomBaseView.frame.size.width - 85)/2,shareContactsNowBtn.frame.size.height + shareContactsNowBtn.frame.origin.y + 10 , 85, 20);
    [noThanksButton setTitle:@"No thanks!" forState:UIControlStateNormal];
    [noThanksButton addTarget:self action:@selector(noThanksButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [noThanksButton setTintColor:[ICSingletonManager colorFromHexString:@"#001d3d"]];
    [noThanksButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
    noThanksButton.titleLabel.textAlignment = NSTextAlignmentRight;
    [bottomBaseView addSubview:noThanksButton];
    
    UIView *noThanksNarrowLine = [[UIView alloc]initWithFrame:CGRectMake((bottomBaseView.frame.size.width - 85)/2,noThanksButton.frame.size.height + noThanksButton.frame.origin.y  , 85, 1)];
    noThanksNarrowLine.backgroundColor = [ICSingletonManager colorFromHexString:@"#001d3d"];
    [bottomBaseView addSubview:noThanksNarrowLine];
      /******************  bottom BaseView *************/
    
    self.tableView = [[UITableView alloc]init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setSeparatorColor:[UIColor blackColor]];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.view addSubview:self.tableView];
    
    UIView *bottomRedBaseView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 40, self.view.frame.size.width, 0)];
    bottomRedBaseView.backgroundColor = [ICSingletonManager colorFromHexString:@"#d9dadc"];
    [self.view addSubview:bottomRedBaseView];
    
    UILabel *redLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, self.view.frame.size.width, 0)];
    redLbl.text = @"Expiring this month ₹1,000 icanCash";
    redLbl.textColor = [UIColor redColor];
    redLbl.textAlignment = NSTextAlignmentCenter;
 //   [bottomRedBaseView addSubview:redLbl];
    
    if ([contactSyncOrNot isEqualToString:@"YES"]) {
        self.tableView.frame = CGRectMake(0, baseView.frame.size.height + baseView.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height - (baseView.frame.size.height + baseView.frame.origin.y));
        bottomBaseView.hidden = YES;
         bottomRedBaseView.hidden = NO;
    }else{
        self.tableView.frame =    CGRectMake(0, baseView.frame.size.height + baseView.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height - (baseView.frame.size.height + baseView.frame.origin.y) - (bottomBaseView.frame.size.height));
        bottomBaseView.hidden = NO ;
        bottomRedBaseView.hidden = YES;
    }
    
}
-(void)noThanksButtonTapped:(id)sender
{
    ReferAndEarnWeb *referAndEarnController = [self.storyboard instantiateViewControllerWithIdentifier:@"ReferAndEarnWeb"];
    
    [self.navigationController pushViewController:referAndEarnController animated:YES];
}
-(void)shareContactButtonTapped:(id)sender
{
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
    ReferAndEarnVC *refer = [self.storyboard instantiateViewControllerWithIdentifier:@"ReferAndEarnVC"];
    
    globals.isFromMenuLastMinuteDeal = @"YES";
    
    [self.navigationController pushViewController:refer animated:YES];
}
-(void)voucherButtonTapped:(id)sender
{
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
    globals.isFromMenuForBuyVoucher = true;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    BuyCouponViewController *vcHomeScreen = [storyboard instantiateViewControllerWithIdentifier:@"BuyCouponViewController"];
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
-(void)packageButtonTapped:(id)sender
{
      ICSingletonManager *globals = [ICSingletonManager sharedManager];
    globals.isFromMenu = true;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    PackagesViewController *vcHomeScreen = [storyboard instantiateViewControllerWithIdentifier:@"PackagesViewController"];
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
-(void)hotelButtonTapped:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
LastMinuteViewController *vcHomeScreen = [storyboard instantiateViewControllerWithIdentifier:@"LastMinuteViewController"];
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
#pragma mark - Table View Data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:
(NSInteger)section {
    return [_detailArr count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    NSString *detailStr  = [[_detailArr objectAtIndex:indexPath.row] objectForKey:@"comments"];
    detailStr = [self getURLFromString:detailStr];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
         CGFloat height =  [self requiredHeight:detailStr width:200];
          return height + 35;
    }else{
         CGFloat height =  [self requiredHeight:detailStr width:170];
          return height + 35;
    }
   
  
}

-(NSString *)getURLFromString:(NSString *)str{
    
    NSString *urlStr = [str stringByReplacingOccurrencesOfString:@"- " withString:@"\n"];
    return urlStr;
}

- (CGFloat)requiredHeight:(NSString*)labelText width:(int)width{
    
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:16.0];
    UITextView *label = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, width, CGFLOAT_MAX)];
  //  label.numberOfLines = 0;
//    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.font = font;
    label.text = labelText;
    [label sizeToFit];
    return label.frame.size.height;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
(NSIndexPath *)indexPath {

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        NSString *detailStr  = [[_detailArr objectAtIndex:indexPath.row] objectForKey:@"comments"];
        detailStr = [self getURLFromString:detailStr];
        CGFloat height =  [self requiredHeight:detailStr width:200];
        
        NSString *tranType  = [NSString stringWithFormat:@"%@",[[_detailArr objectAtIndex:indexPath.row] objectForKey:@"trantype"]];
        if ([tranType isEqualToString:@"6"]) {
            static NSString *CellIdentifier1      = @"ExpiryCell";
            CanCashDetailTableViewCell *cell           = [[CanCashDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                                                           reuseIdentifier:CellIdentifier1];
            cell.frame = CGRectMake(0, 0, tableView.frame.size.width, height + 35);
            cell.cmmntLbl.frame = CGRectMake(10, 5, 200, height);
            cell.createdLbl.frame = CGRectMake(15, (height + 35) - 30, 200, 30);
            cell.priceLbl.frame = CGRectMake(cell.frame.size.width - 160, 5, 150, 30);
            cell.expiresOnLbl.frame = CGRectMake(cell.frame.size.width - 160, (height + 35) - 50, 150, 30);
            cell.validItyDateLbl.frame = CGRectMake(cell.frame.size.width - 160, (height + 35) - 30, 150, 30);
            cell.epireImgView.frame = CGRectMake((cell.frame.size.width - 140)/2,(cell.frame.size.height - 40)/2 , 140, 40);
            cell.priceLbl.textColor = [ICSingletonManager colorFromHexString:@"#001d3d"];
            cell.cmmntLbl.text = detailStr;
            cell.createdLbl.text = [[_detailArr objectAtIndex:indexPath.row] objectForKey:@"created"];
            cell.priceLbl.text = [NSString stringWithFormat:@"+ ₹%@", [[_detailArr objectAtIndex:indexPath.row] objectForKey:@"cancash"]];
            cell.validItyDateLbl.hidden = NO;
            cell.epireImgView.hidden = NO;
            cell.expiresOnLbl.text = @"(Expires On)";
            cell.expiresOnLbl.hidden = YES;
            cell.validItyDateLbl.text = [[_detailArr objectAtIndex:indexPath.row] objectForKey:@"validity"];
            cell.alpha = 0.6;
            cell.cmmntLbl.alpha = 0.4;
            cell.createdLbl.alpha = 0.4;
            cell.priceLbl.alpha = 0.4;
            cell.validItyDateLbl.alpha = 0.4;
            cell.cmmntLbl.textColor = [UIColor grayColor];
            cell.createdLbl.textColor = [UIColor grayColor];
            cell.expiresOnLbl.textColor = [UIColor grayColor];
            cell.validItyDateLbl.textColor = [UIColor grayColor];
            cell.priceLbl.font = [UIFont boldSystemFontOfSize:15];
             cell.cmmntLbl.font = [UIFont systemFontOfSize:15];
             cell.createdLbl.font = [UIFont systemFontOfSize:15];
             cell.expiresOnLbl.font = [UIFont systemFontOfSize:15];
             cell.validItyDateLbl.font = [UIFont systemFontOfSize:15];
            return cell;
            
        }else if ([tranType isEqualToString:@"3"]) {
            static NSString *CellIdentifier1      = @"redPriceCell";
            CanCashDetailTableViewCell *cell           = [[CanCashDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                                                           reuseIdentifier:CellIdentifier1];
            
            cell.frame = CGRectMake(0, 0, tableView.frame.size.width, height + 35);
            
            cell.cmmntLbl.frame = CGRectMake(10, 5, 200, height);
            cell.createdLbl.frame = CGRectMake(15, (height + 35) - 30, 200, 30);
            cell.priceLbl.frame = CGRectMake(cell.frame.size.width - 160, 5, 150, 30);
            cell.expiresOnLbl.frame = CGRectMake(cell.frame.size.width - 160, (height + 35) - 50, 150, 30);
            cell.validItyDateLbl.frame = CGRectMake(cell.frame.size.width - 160, (height + 35) - 30, 150, 30);
            cell.epireImgView.frame = CGRectMake((cell.frame.size.width - 140)/2,(cell.frame.size.height - 40)/2 , 140, 40);
            cell.priceLbl.textColor = [UIColor redColor];
            cell.cmmntLbl.text = detailStr;
            cell.createdLbl.text = [[_detailArr objectAtIndex:indexPath.row] objectForKey:@"created"];
            NSString *string = [[_detailArr objectAtIndex:indexPath.row] objectForKey:@"cancash"];
         //   int value = [string intValue];
            cell.priceLbl.text = [NSString stringWithFormat:@"- ₹%@", string];
            cell.validItyDateLbl.hidden = YES;
            cell.epireImgView.hidden = YES;
            cell.expiresOnLbl.text = @"(Expires On)";
            cell.expiresOnLbl.hidden = YES;
            cell.validItyDateLbl.text = [[_detailArr objectAtIndex:indexPath.row] objectForKey:@"validity"];
            cell.cmmntLbl.textColor = [UIColor grayColor];
            cell.createdLbl.textColor = [UIColor grayColor];
            cell.expiresOnLbl.textColor = [UIColor grayColor];
            cell.validItyDateLbl.textColor = [UIColor grayColor];
            cell.priceLbl.font = [UIFont boldSystemFontOfSize:15];
            cell.cmmntLbl.font = [UIFont systemFontOfSize:15];
            cell.createdLbl.font = [UIFont systemFontOfSize:15];
            cell.expiresOnLbl.font = [UIFont systemFontOfSize:15];
            cell.validItyDateLbl.font = [UIFont systemFontOfSize:15];
            return cell;
        }else{
            static NSString *CellIdentifier1      = @"greenPriceCell";
            CanCashDetailTableViewCell *cell           = [[CanCashDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                                                           reuseIdentifier:CellIdentifier1];
            cell.frame = CGRectMake(0, 0, tableView.frame.size.width, height + 50);
            cell.cmmntLbl.frame = CGRectMake(10, 5, 200, height);
            cell.createdLbl.frame = CGRectMake(15, (height + 35) - 30, 200, 30);
            cell.priceLbl.frame = CGRectMake(cell.frame.size.width - 160, 5, 150, 30);
            cell.expiresOnLbl.frame = CGRectMake(cell.frame.size.width - 160, (height + 35) - 50, 150, 30);
            cell.validItyDateLbl.frame = CGRectMake(cell.frame.size.width - 160, (height + 35) - 30, 150, 30);
            cell.epireImgView.frame = CGRectMake((cell.frame.size.width - 140)/2,(cell.frame.size.height - 40)/2 , 140, 40);
            cell.priceLbl.textColor = [ICSingletonManager colorFromHexString:@"#001d3d"];
            cell.cmmntLbl.text = detailStr;
            cell.createdLbl.text = [[_detailArr objectAtIndex:indexPath.row] objectForKey:@"created"];
            cell.priceLbl.text = [NSString stringWithFormat:@"+ ₹%@", [[_detailArr objectAtIndex:indexPath.row] objectForKey:@"cancash"]];
            cell.validItyDateLbl.hidden = NO;
            cell.epireImgView.hidden = YES;
            cell.expiresOnLbl.text = @"(Expires On)";
            cell.expiresOnLbl.hidden = NO;
            cell.validItyDateLbl.text = [[_detailArr objectAtIndex:indexPath.row] objectForKey:@"validity"];
            cell.cmmntLbl.textColor = [UIColor grayColor];
            cell.createdLbl.textColor = [UIColor grayColor];
            cell.expiresOnLbl.textColor = [UIColor grayColor];
            cell.validItyDateLbl.textColor = [UIColor grayColor];
            cell.priceLbl.font = [UIFont boldSystemFontOfSize:15];
            cell.cmmntLbl.font = [UIFont systemFontOfSize:15];
            cell.createdLbl.font = [UIFont systemFontOfSize:15];
            cell.expiresOnLbl.font = [UIFont systemFontOfSize:15];
            cell.validItyDateLbl.font = [UIFont systemFontOfSize:15];
            return cell;
        }
    }else{
        NSString *detailStr  = [[_detailArr objectAtIndex:indexPath.row] objectForKey:@"comments"];
        detailStr = [self getURLFromString:detailStr];
        CGFloat height =  [self requiredHeight:detailStr width:170];
        
        NSString *tranType  = [NSString stringWithFormat:@"%@",[[_detailArr objectAtIndex:indexPath.row] objectForKey:@"trantype"]];
        if ([tranType isEqualToString:@"6"]) {
            static NSString *CellIdentifier1      = @"ExpiryCell";
            CanCashDetailTableViewCell *cell           = [[CanCashDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                                                           reuseIdentifier:CellIdentifier1];
            cell.frame = CGRectMake(0, 0, tableView.frame.size.width, height + 50);
            cell.cmmntLbl.frame = CGRectMake(10, 5, 170, height);
            cell.createdLbl.frame = CGRectMake(15, (height + 35) - 30, 100, 30);
            cell.priceLbl.frame = CGRectMake(cell.frame.size.width - 120, 5, 115, 30);
            cell.expiresOnLbl.frame = CGRectMake(cell.frame.size.width - 120, (height + 35) - 50, 115, 30);
            cell.validItyDateLbl.frame = CGRectMake(120, (height + 35) - 30, cell.frame.size.width - 125, 30);
            cell.epireImgView.frame = CGRectMake((cell.frame.size.width - 140)/2,(cell.frame.size.height - 40)/2 , 140, 40);
            cell.priceLbl.textColor = [ICSingletonManager colorFromHexString:@"#001d3d"];
            cell.cmmntLbl.text = detailStr;
            cell.createdLbl.text = [[_detailArr objectAtIndex:indexPath.row] objectForKey:@"created"];
            cell.priceLbl.text = [NSString stringWithFormat:@"+ ₹%@", [[_detailArr objectAtIndex:indexPath.row] objectForKey:@"cancash"]];
            cell.validItyDateLbl.hidden = NO;
             cell.epireImgView.hidden = NO;
            cell.expiresOnLbl.text = @"(Expires On)";
            cell.expiresOnLbl.hidden = YES;
            cell.validItyDateLbl.text = [NSString stringWithFormat:@"Expires On %@",[[_detailArr objectAtIndex:indexPath.row] objectForKey:@"validity"]];
            cell.alpha = 0.6;
            cell.alpha = 0.6;
            cell.cmmntLbl.alpha = 0.4;
            cell.createdLbl.alpha = 0.4;
            cell.priceLbl.alpha = 0.4;
            cell.validItyDateLbl.alpha = 0.4;
            cell.cmmntLbl.textColor = [UIColor grayColor];
            cell.createdLbl.textColor = [UIColor grayColor];
            cell.expiresOnLbl.textColor = [UIColor grayColor];
            cell.validItyDateLbl.textColor = [UIColor grayColor];
            cell.priceLbl.font = [UIFont boldSystemFontOfSize:15];
            cell.cmmntLbl.font = [UIFont systemFontOfSize:15];
            cell.createdLbl.font = [UIFont systemFontOfSize:15];
            cell.expiresOnLbl.font = [UIFont systemFontOfSize:15];
            cell.validItyDateLbl.font = [UIFont systemFontOfSize:15];
             return cell;
        }else if ([tranType isEqualToString:@"3"]) {
            static NSString *CellIdentifier1      = @"redPriceCell";
            CanCashDetailTableViewCell *cell           = [[CanCashDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                                                           reuseIdentifier:CellIdentifier1];
            
            cell.frame = CGRectMake(0, 0, tableView.frame.size.width, height + 35);
            
            cell.cmmntLbl.frame = CGRectMake(10, 5, 170, height);
            cell.createdLbl.frame = CGRectMake(15, (height + 35) - 30, 100, 30);
            cell.priceLbl.frame = CGRectMake(cell.frame.size.width - 120, 5, 115, 30);
            cell.expiresOnLbl.frame = CGRectMake(cell.frame.size.width - 120, (height + 35) - 50, 115, 30);
            cell.validItyDateLbl.frame = CGRectMake(120, (height + 35) - 30, cell.frame.size.width - 125, 30);
            cell.epireImgView.frame = CGRectMake((cell.frame.size.width - 140)/2,(cell.frame.size.height - 40)/2 , 140, 40);
            cell.priceLbl.textColor = [UIColor redColor];
            cell.cmmntLbl.text = detailStr;
            
            cell.createdLbl.text = [[_detailArr objectAtIndex:indexPath.row] objectForKey:@"created"];
            NSString *string = [[_detailArr objectAtIndex:indexPath.row] objectForKey:@"cancash"];
     //       int value = [string intValue];
            cell.priceLbl.text = [NSString stringWithFormat:@"- ₹%@", string];
            cell.validItyDateLbl.hidden = YES;
             cell.epireImgView.hidden = YES;
            cell.expiresOnLbl.text = @"(Expires On)";
            cell.expiresOnLbl.hidden = YES;
            cell.validItyDateLbl.text = [NSString stringWithFormat:@"Expires On %@",[[_detailArr objectAtIndex:indexPath.row] objectForKey:@"validity"]];
            cell.cmmntLbl.textColor = [UIColor grayColor];
            cell.createdLbl.textColor = [UIColor grayColor];
            cell.expiresOnLbl.textColor = [UIColor grayColor];
            cell.validItyDateLbl.textColor = [UIColor grayColor];
            cell.priceLbl.font = [UIFont boldSystemFontOfSize:15];
            cell.cmmntLbl.font = [UIFont systemFontOfSize:15];
            cell.createdLbl.font = [UIFont systemFontOfSize:15];
            cell.expiresOnLbl.font = [UIFont systemFontOfSize:15];
            cell.validItyDateLbl.font = [UIFont systemFontOfSize:15];
            return cell;
        }else{
            static NSString *CellIdentifier1      = @"greenPriceCell";
            CanCashDetailTableViewCell *cell           = [[CanCashDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                                                           reuseIdentifier:CellIdentifier1];
            cell.frame = CGRectMake(0, 0, tableView.frame.size.width, height + 35);
            cell.cmmntLbl.frame = CGRectMake(10, 5, 170, height);
            cell.createdLbl.frame = CGRectMake(15, (height + 35) - 30, 120, 30);
            cell.priceLbl.frame = CGRectMake(cell.frame.size.width - 120, 5, 115, 30);
            cell.expiresOnLbl.frame = CGRectMake(cell.frame.size.width - 120, (height + 35) - 50, 115, 30);
            cell.validItyDateLbl.frame = CGRectMake(120, (height + 35) - 30, cell.frame.size.width - 125, 30);
            cell.epireImgView.frame = CGRectMake((cell.frame.size.width - 140)/2,(cell.frame.size.height - 40)/2 , 140, 40);
            cell.priceLbl.textColor = [ICSingletonManager colorFromHexString:@"#001d3d"];
            cell.cmmntLbl.text = detailStr;
            cell.createdLbl.text = [[_detailArr objectAtIndex:indexPath.row] objectForKey:@"created"];
            cell.priceLbl.text = [NSString stringWithFormat:@"+ ₹%@", [[_detailArr objectAtIndex:indexPath.row] objectForKey:@"cancash"]];
            cell.validItyDateLbl.hidden = NO;
            cell.expiresOnLbl.text = @"(Expires On)";
            cell.expiresOnLbl.hidden = YES;
            cell.validItyDateLbl.text = [NSString stringWithFormat:@"Expires On %@",[[_detailArr objectAtIndex:indexPath.row] objectForKey:@"validity"]];
            cell.epireImgView.hidden = YES;
            cell.cmmntLbl.textColor = [UIColor grayColor];
            cell.createdLbl.textColor = [UIColor grayColor];
            cell.expiresOnLbl.textColor = [UIColor grayColor];
            cell.validItyDateLbl.textColor = [UIColor grayColor];
            cell.priceLbl.font = [UIFont boldSystemFontOfSize:15];
            cell.cmmntLbl.font = [UIFont systemFontOfSize:15];
            cell.createdLbl.font = [UIFont systemFontOfSize:15];
            cell.expiresOnLbl.font = [UIFont systemFontOfSize:15];
            cell.validItyDateLbl.font = [UIFont systemFontOfSize:15];
            return cell;
        }
    }
  

}




#pragma mark - TableView delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:
(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"Section:%d Row:%d selected and its data is %@",
          indexPath.section,indexPath.row,cell.textLabel.text);
}
-(void)referNowBtnTapped:(id)sender
{

    ICSingletonManager *globals = [ICSingletonManager sharedManager];
    ProfileScreen *buyCoupon =[self.storyboard instantiateViewControllerWithIdentifier:@"ProfileScreen"];
    globals.isFromMenu = NO;
    [self.navigationController pushViewController:buyCoupon animated:YES];

}
-(void)backButtonTapped:(id)sender
{
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
   
    if ([ globals.canCashFromRefer isEqualToString:@"YES"]) {
         globals.canCashFromRefer = @"NO";
         [self.navigationController popViewControllerAnimated:YES];
    }else{
          [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    }

}

-(void)notificationButtonTapped:(id)sender
{
    LoginManager *login = [[LoginManager alloc]init];
    if ([[login isUserLoggedIn] count]>0)
    {
        ICSingletonManager *globals = [ICSingletonManager sharedManager];
        globals.isWithoutLoginNoti = false;
        NotificationScreen *notification = [self.storyboard instantiateViewControllerWithIdentifier:@"NotificationScreen"];
        [self.navigationController pushViewController:notification animated:YES];
        
        
        //        NotificationViewController *notification = [self.storyboard instantiateViewControllerWithIdentifier:@"NotificationViewController"];
        //        [self.navigationController pushViewController:notification animated:YES];
        
        
    }
    else
    {
        ICSingletonManager *globals = [ICSingletonManager sharedManager];
        globals.isWithoutLoginNoti = true;
        [self switchToLoginScreen];
    }
    
}
- (void)pushToDashBoardScreenAfterLoggingIn
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    DashboardScreen *dashboardScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"DashboardScreen"];
    [self.mm_drawerController setCenterViewController:dashboardScreen withCloseAnimation:NO completion:nil];
}
- (void)switchToLoginScreen
{
    [[NSNotificationCenter defaultCenter ]addObserver:self selector:@selector(pushToDashBoardScreenAfterLoggingIn) name:kSwitchToDashBoardScreen object:nil];
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
    globals.isFromMenu = false;
    
    LoginScreen *vcLogin = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginScreen"];
    [self.navigationController pushViewController:vcLogin animated:YES];
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

@end
