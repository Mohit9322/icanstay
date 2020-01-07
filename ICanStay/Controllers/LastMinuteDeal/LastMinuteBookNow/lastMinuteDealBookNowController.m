//
//  lastMinuteDealBookNowController.m
//  ICanStay
//
//  Created by Planet on 7/4/17.
//  Copyright © 2017 verticallogics. All rights reserved.
//

#import "lastMinuteDealBookNowController.h"
#import "NotificationScreen.h"
#import "DashboardScreen.h"
#import "SideMenuController.h"
#import <MoEngage.h>
#import "MyWishlistViewController.h"
#import "BuyCouponViewController.h"
#import "LoginManager.h"
#import "CurrentStayScreen.h"
#import "LastMinuteViewController.h"
#import "GradientButton.h"
#import "HomeScreenController.h"
#import "SideMenuController.h"

#define ACCEPTABLE_CHARACTERS @"0123456789"

@interface lastMinuteDealBookNowController ()<UIWebViewDelegate, UITextFieldDelegate>
{
    UIImageView *baseImageView;
    UIView *tAcBaseView;
    UILabel *checkInDateLbl;
    UILabel *checkOutDateLbl;
    UILabel *noRoomLbl;
    UIWebView     * PrWebview;
    UILabel *totalamountLbl;
    UILabel *totalAmountPriceLbl;
    UIViewController *paymentController;
    NSString *orderID;
    BOOL isff;
    UILabel *cancashAmountLbl;
    UILabel *cancashAmountPriceLbl;
    UILabel *totalAMontPaidLbl;
    UILabel *totalAmountPaidPriceLbl;
    int cancasHAmount;
    UIView *bottomBaseView;
    UILabel *luxLbl;
}
@property (nonatomic, strong) UIView         *topWhiteBaseView;
@property (nonatomic, strong) UIButton       *backButton;
@property (nonatomic, strong) UIButton       *notificationButton;
@property (nonatomic, strong) UIImageView    *logoIconImgView;
@property (nonatomic, strong) UIButton       *femaleBtn;
@property (nonatomic, strong) UIButton       *maleBtn;
@property (nonatomic, strong) NSString       *strGender;
@property (nonatomic, strong) UIButton       *tmcImgBtn;
@property (nonatomic, strong) UIButton       *tmcLblButton;
@property (nonatomic, strong) UIButton       *canCashImgBtn;
@property (nonatomic, strong) UILabel        *canCashAMountLbl;
@property (nonatomic, strong) GradientButton *payNowButton;
@property (nonatomic, strong) NSString       *tAcStr;
@property (nonatomic, strong) NSString       *tAcStrSelectedOrUnselected;
@property (nonatomic, strong) NSString       *CanCAshStrSelectedOrUnselected;
@property (nonatomic, strong) UIScrollView   *baseSrollView;
@property (nonatomic, strong) UITextField    *nameTxtFld;
@property (nonatomic, strong) UITextField    *lastnameTxtFld;
@property (nonatomic, strong) UITextField    *mobNoTxtFld;
@property (nonatomic, strong) UITextField    *emailIdTxtFld;
@property (nonatomic, strong)  UIView        *priceBaseView;
@property (nonatomic, strong)  UIView        *tmcBaseview;

@end

@implementation lastMinuteDealBookNowController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
  
       DLog(@"DEBUG-VC");
    
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

    
    baseImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, self.topWhiteBaseView.frame.origin.y + self.topWhiteBaseView.frame.size.height, self.view.frame.size.width - 20, 80)];
    baseImageView.image = [UIImage imageNamed:@"PackageBaseImg"];
    [self.view addSubview:baseImageView];
    
    UILabel *luxlbl = [[UILabel alloc]init];
    luxlbl.text     = @"Guest Detail - Book Now";
    luxlbl.textAlignment = NSTextAlignmentCenter;
    luxlbl.textColor = [ICSingletonManager colorFromHexString:@"#bd9854"];
    
    luxlbl.backgroundColor = [UIColor clearColor];
    [baseImageView addSubview:luxlbl];
    
    luxlbl.frame = CGRectMake(0,  20, self.view.frame.size.width , 40);
    luxlbl.font = [UIFont systemFontOfSize:24];

    [self desigmBaseView];
    
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
-(void)desigmBaseView
{
    self.baseSrollView = [[UIScrollView alloc]init];
    self.baseSrollView.layer.masksToBounds = YES;
    [self.view addSubview:self.baseSrollView];
    
    UIView *baseview = [[UIView alloc]init];
    baseview.backgroundColor = [UIColor clearColor];
 //   [self.baseSrollView addSubview:baseview];
    
    self.nameTxtFld = [[UITextField alloc]init];
     self.nameTxtFld.backgroundColor = [UIColor colorWithRed:0.9608 green:0.9608 blue:0.9608 alpha:1.0];
     self.nameTxtFld.placeholder = @"  First Name";
     self.nameTxtFld.layer.cornerRadius = 2.0;
     self.nameTxtFld.layer.borderColor = [UIColor colorWithRed:0.6078 green:0.6000 blue:0.5922 alpha:1.0].CGColor;
    self.nameTxtFld.keyboardType = UIKeyboardTypeDefault;
    self.nameTxtFld.delegate = self;
    [self.baseSrollView addSubview: self.nameTxtFld];
    
    
    self.lastnameTxtFld = [[UITextField alloc]init];
    self.lastnameTxtFld.backgroundColor = [UIColor colorWithRed:0.9608 green:0.9608 blue:0.9608 alpha:1.0];
    self.lastnameTxtFld.placeholder = @"  Last Name";
    self.lastnameTxtFld.layer.cornerRadius = 2.0;
    self.lastnameTxtFld.keyboardType = UIKeyboardTypeDefault;
    self.lastnameTxtFld.delegate = self;
    self.lastnameTxtFld.layer.borderColor = [UIColor colorWithRed:0.6078 green:0.6000 blue:0.5922 alpha:1.0].CGColor;
    [self.baseSrollView addSubview:self.lastnameTxtFld];
    
    
    self.mobNoTxtFld = [[UITextField alloc]init];
    self.mobNoTxtFld.backgroundColor = [UIColor colorWithRed:0.9608 green:0.9608 blue:0.9608 alpha:1.0];
    self.mobNoTxtFld.placeholder = @"  Mobile No.";
    self.mobNoTxtFld.layer.cornerRadius = 2.0;
    self.mobNoTxtFld.keyboardType = UIKeyboardTypePhonePad;
    self.mobNoTxtFld.delegate = self;
    self.mobNoTxtFld.layer.borderColor = [UIColor colorWithRed:0.6078 green:0.6000 blue:0.5922 alpha:1.0].CGColor;
    [self.baseSrollView addSubview:self.mobNoTxtFld];
    
    
    self.emailIdTxtFld = [[UITextField alloc]init];
    self.emailIdTxtFld.backgroundColor = [UIColor colorWithRed:0.9608 green:0.9608 blue:0.9608 alpha:1.0];
    self.emailIdTxtFld.layer.cornerRadius = 2.0;
    self.emailIdTxtFld.placeholder = @"  Email Id";
    self.emailIdTxtFld.layer.borderColor = [UIColor colorWithRed:0.6078 green:0.6000 blue:0.5922 alpha:1.0].CGColor;
    self.emailIdTxtFld.keyboardType = UIKeyboardTypeEmailAddress;
    self.emailIdTxtFld.delegate = self;
    [self.baseSrollView addSubview:self.emailIdTxtFld];
    
    UIView *genderBaseView = [[UIView alloc]init];
    genderBaseView.backgroundColor = [UIColor clearColor];
    [self.baseSrollView addSubview:genderBaseView];
  
    LoginManager *loginManage = [[LoginManager alloc]init];
    NSDictionary *dict = [loginManage isUserLoggedIn];

    
    _maleBtn = [[UIButton alloc]init];
  
   
    [_maleBtn addTarget:self action:@selector(genderMaleBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [genderBaseView addSubview:_maleBtn];
    
    
    UILabel *maleLbl = [[UILabel alloc]init];
    maleLbl.text = @"Male";
    maleLbl.textColor = [UIColor blackColor];
    [genderBaseView addSubview:maleLbl];
    
    _femaleBtn = [[UIButton alloc]init];
   
    [_femaleBtn addTarget:self action:@selector(genderFemaleBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [genderBaseView addSubview:_femaleBtn];
    
    if ([dict count] > 0) {
        if ([[dict valueForKey:@"Gender"] isEqualToString:@"M"]) {
            [_maleBtn  setBackgroundImage:[UIImage imageNamed:@"radio_selected"] forState:UIControlStateNormal];
             [_femaleBtn  setBackgroundImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
            self.strGender = @"M";
        }else{
            [_femaleBtn  setBackgroundImage:[UIImage imageNamed:@"radio_selected"] forState:UIControlStateNormal];
                [_maleBtn  setBackgroundImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
            self.strGender = @"F";
        }
    }else{
        [_maleBtn  setBackgroundImage:[UIImage imageNamed:@"radio_selected"] forState:UIControlStateNormal];
         [self.femaleBtn setBackgroundImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        self.strGender = @"M";
    }
    
    UILabel *femaleLbl = [[UILabel alloc]init];
    femaleLbl.text = @"Female";
    femaleLbl.textColor = [UIColor blackColor];
    [genderBaseView addSubview:femaleLbl];
    
    
    bottomBaseView = [[UIView alloc]init];
    bottomBaseView.backgroundColor = [UIColor clearColor];
    [self.baseSrollView addSubview:bottomBaseView];
    
    
    UILabel *checkInLbl = [[UILabel alloc]init];
    checkInLbl.text = @"Check In";
    checkInLbl.textAlignment = NSTextAlignmentLeft;
    checkInLbl.textColor = [UIColor blackColor];
    [bottomBaseView addSubview:checkInLbl];
    
    
    checkInDateLbl = [[UILabel alloc]init];
//    checkInDateLbl.text = @"5 Jul 2017";
    checkInDateLbl.textAlignment = NSTextAlignmentLeft;
    checkInDateLbl.textColor = [UIColor grayColor];
    [bottomBaseView addSubview:checkInDateLbl];
    
    
    UILabel *checkoutLbl = [[UILabel alloc]init];
    checkoutLbl.text = @"Check Out";
    checkoutLbl.textColor = [UIColor blackColor];
    checkoutLbl.textAlignment = NSTextAlignmentLeft;
    [bottomBaseView addSubview:checkoutLbl];
    
    
    checkOutDateLbl = [[UILabel alloc]init];
//    checkOutDateLbl.text = @"8 Jul 2017";
    checkOutDateLbl.textAlignment = NSTextAlignmentLeft;
    checkOutDateLbl.textColor = [UIColor grayColor];
    [bottomBaseView addSubview:checkOutDateLbl];
    
    
    UILabel *roomLbl = [[UILabel alloc]init];
    roomLbl.text = @"Rooms";
    roomLbl.textAlignment = NSTextAlignmentLeft;
    roomLbl.textColor = [UIColor blackColor];
    [bottomBaseView addSubview:roomLbl];
    
    
    noRoomLbl = [[UILabel alloc]init];
 //   noRoomLbl.text = @"5";
    noRoomLbl.textAlignment = NSTextAlignmentLeft;
    noRoomLbl.textColor = [UIColor grayColor];
    [bottomBaseView addSubview:noRoomLbl];
    
    
  
    
    
    _tmcBaseview = [[UIView alloc]init];
//    _tmcBaseview.backgroundColor = [UIColor yellowColor];
    [bottomBaseView addSubview:_tmcBaseview];
    
    _tmcImgBtn = [[UIButton alloc]init];
    [_tmcImgBtn  setBackgroundImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
    [_tmcImgBtn addTarget:self action:@selector(tmcImgBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    _tAcStrSelectedOrUnselected = @"NO";
    [_tmcBaseview addSubview:_tmcImgBtn];
    
      NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"I agree to the Terms & Conditions"];
    [string addAttribute:NSForegroundColorAttributeName value:[ICSingletonManager colorFromHexString:@"#bd9854"] range:NSMakeRange(0, 7)];
    
    _tmcLblButton = [[UIButton alloc]init];
    [_tmcLblButton setAttributedTitle:string forState:UIControlStateNormal];
    _tmcLblButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    _tmcLblButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_tmcLblButton addTarget:self action:@selector(tmcLblBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [_tmcBaseview addSubview:_tmcLblButton];
    
    _priceBaseView = [[UIView alloc]init];
    //   _priceBaseView.backgroundColor = [UIColor greenColor];
    [_tmcBaseview addSubview:_priceBaseView];
    
    totalamountLbl = [[UILabel alloc]init];
    //   totalamountLbl.text = @"Total Amount ₹14995";
    totalamountLbl.textAlignment = NSTextAlignmentLeft;
    totalamountLbl.font = [UIFont systemFontOfSize:22];
    totalamountLbl.textColor = [UIColor blackColor];
    [_priceBaseView addSubview:totalamountLbl];
    
    totalAmountPriceLbl = [[UILabel alloc]init];
    totalAmountPriceLbl.textAlignment = NSTextAlignmentRight;
    totalAmountPriceLbl.font = [UIFont systemFontOfSize:22];
    totalAmountPriceLbl.textColor = [UIColor blackColor];
    [_priceBaseView addSubview:totalAmountPriceLbl];
  
    cancashAmountLbl = [[UILabel alloc]init];
    
    cancashAmountLbl.textAlignment = NSTextAlignmentLeft;
    cancashAmountLbl.font = [UIFont systemFontOfSize:22];
    cancashAmountLbl.textColor = [UIColor blackColor];
    [_priceBaseView addSubview:cancashAmountLbl];
    
    cancashAmountPriceLbl = [[UILabel alloc]init];
    cancashAmountPriceLbl.textAlignment = NSTextAlignmentLeft;
    cancashAmountPriceLbl.font = [UIFont systemFontOfSize:22];
    cancashAmountPriceLbl.textColor = [UIColor blackColor];
    [_priceBaseView addSubview:cancashAmountPriceLbl];
    
    totalAMontPaidLbl = [[UILabel alloc]init];
    totalAMontPaidLbl.textAlignment = NSTextAlignmentLeft;
    totalAMontPaidLbl.font = [UIFont systemFontOfSize:22];
    totalAMontPaidLbl.textColor = [UIColor blackColor];
    [_priceBaseView addSubview:totalAMontPaidLbl];
   
    
    totalAmountPaidPriceLbl = [[UILabel alloc]init];
    totalAmountPaidPriceLbl.textAlignment = NSTextAlignmentLeft;
    totalAmountPaidPriceLbl.font = [UIFont systemFontOfSize:22];
    totalAmountPaidPriceLbl.textColor = [UIColor blackColor];
    [_priceBaseView addSubview:totalAmountPaidPriceLbl];
    
    
    _canCashImgBtn = [[UIButton alloc]init];
    [_canCashImgBtn  setBackgroundImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
    [_canCashImgBtn addTarget:self action:@selector(canCAshImgBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    _CanCAshStrSelectedOrUnselected = @"NO";
//    [_tmcBaseview addSubview:_canCashImgBtn];
    
    
    _canCashAMountLbl = [[UILabel alloc]init];
   
    _canCashAMountLbl.textColor = [ICSingletonManager colorFromHexString:@"#bd9854"];
 //   [_tmcBaseview addSubview:_canCashAMountLbl];
    
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
     NSString *stringWithoutSpaces = [globals.userCancashAmountAvailable stringByReplacingOccurrencesOfString:@"," withString:@""];
    if ([globals.firstTimeVoucherPurchase isEqualToString:@"YES"]) {
        if ([dict count] > 0) {
            if ([  stringWithoutSpaces intValue] >= 300) {
                cancasHAmount = 300;
                
            }else{
                cancasHAmount = [ stringWithoutSpaces intValue];
                
            }
        }else if ([ stringWithoutSpaces intValue] == 0){
            cancasHAmount = 0;
            
        }
    }else{
        
        if ([dict count] > 0) {
            if ([ stringWithoutSpaces intValue] >= 1000) {
                cancasHAmount = 1000;
                
            }else{
                cancasHAmount = [ stringWithoutSpaces intValue];
                
            }
        }else if ([ stringWithoutSpaces intValue] == 0){
            cancasHAmount = 0;
            
        }
    }
  //  cancasHAmount = 500;
   
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        NSString *CanCashStr  = [NSString stringWithFormat:@"You can use max %d icanCash",cancasHAmount];
        NSString *balanceStr  = [NSString stringWithFormat:@"(Current icanCash =%d)",[globals.userCancashAmountAvailable intValue]];
        int lengthCashStr = [CanCashStr length];
        int lengthBalanceStr = [balanceStr length];
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", CanCashStr,balanceStr]];
        [text addAttribute:NSForegroundColorAttributeName value:[ICSingletonManager colorFromHexString:@"#bd9854"] range:NSMakeRange(0,lengthCashStr )];
        [text addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(lengthCashStr + 1,lengthBalanceStr )];
    //    _canCashAMountLbl.attributedText = text;
    }else{
        NSString *CanCashStr  = [NSString stringWithFormat:@"You can use max %d icanCash",cancasHAmount];
        NSString *balanceStr  = [NSString stringWithFormat:@"(Current icanCash =%d)",[globals.userCancashAmountAvailable intValue]];
        int lengthCashStr = [CanCashStr length];
        int lengthBalanceStr = [balanceStr length];
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@", CanCashStr,balanceStr]];
        int lengthStr = [[NSString stringWithFormat:@"%@\n%@", CanCashStr,balanceStr] length];
        [text addAttribute:NSForegroundColorAttributeName value:[ICSingletonManager colorFromHexString:@"#bd9854"] range:NSMakeRange(0,lengthCashStr )];
        [text addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(lengthStr - lengthBalanceStr ,lengthBalanceStr )];
    //    _canCashAMountLbl.attributedText = text;
    }
   
  
    
    _payNowButton =  [[GradientButton alloc]init];
    [_payNowButton setTitle:@"Pay Now" forState:UIControlStateNormal];
    [_payNowButton setTintColor:[UIColor blackColor]];
    [_payNowButton useRedDeleteStyle];
    [_payNowButton addTarget:self action:@selector(PayNowBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [_tmcBaseview addSubview:_payNowButton];
    
   
    
   
    
    luxLbl = [[UILabel alloc]init];
    luxLbl.text = @" *It's a Luxury Hotel Deal & Hotel Name will be revealed after payment.";
    luxLbl.textAlignment = NSTextAlignmentLeft;
    luxLbl.textColor = [UIColor grayColor];
    [_tmcBaseview addSubview:luxLbl];
    
   
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.baseSrollView.frame = CGRectMake(10, baseImageView.frame.size.height + baseImageView.frame.origin.y, self.view.frame.size.width -10 , self.view.frame.size.height - (baseImageView.frame.size.height + baseImageView.frame.origin.y ) );
        baseview.frame = CGRectMake(20, 10, self.view.frame.size.width - 40, 600);
        self.nameTxtFld.frame = CGRectMake(20, 10,baseview.frame.size.width - 40 , 40);
        self.lastnameTxtFld.frame = CGRectMake(20, self.nameTxtFld.frame.origin.y + self.nameTxtFld.frame.size.height + 10,baseview.frame.size.width - 40 , 40);
        self.mobNoTxtFld.frame =CGRectMake(20, self.lastnameTxtFld.frame.origin.y + self.lastnameTxtFld.frame.size.height + 10,baseview.frame.size.width - 40 , 40);
        self.emailIdTxtFld.frame = CGRectMake(20, self.mobNoTxtFld.frame.origin.y + self.mobNoTxtFld.frame.size.height + 10,baseview.frame.size.width - 40 , 40);

        genderBaseView.frame = CGRectMake(20, self.emailIdTxtFld.frame.origin.y + 40 +10,baseview.frame.size.width - 40 , 40);
        _maleBtn.frame = CGRectMake(0, 5, 20, 20);
        maleLbl.frame = CGRectMake(25, 5, 80, 20);
         _femaleBtn.frame = CGRectMake(200, 5, 20, 20);
        femaleLbl.frame = CGRectMake(225, 5, 80, 20);
        bottomBaseView.frame =CGRectMake(20, genderBaseView.frame.origin.y + genderBaseView.frame.size.height,baseview.frame.size.width - 40 , 350);
        checkInLbl.frame = CGRectMake(1, 0, 140, 20);
        checkInDateLbl.frame = CGRectMake(1, checkInLbl.frame.origin.y + checkInLbl.frame.size.height +5 , 140, 25);
        
        checkoutLbl.frame = CGRectMake(checkInLbl.frame.size.width + checkInLbl.frame.origin.x + 60, 0, 140, 20);
        
        checkOutDateLbl.frame = CGRectMake(checkInLbl.frame.size.width + checkInLbl.frame.origin.x + 60, checkoutLbl.frame.origin.y + checkoutLbl.frame.size.height +5, 140, 25);
        roomLbl.frame = CGRectMake(checkoutLbl.frame.size.width + checkoutLbl.frame.origin.x + 60, 0, 100, 20);
        noRoomLbl.frame = CGRectMake(checkoutLbl.frame.size.width + checkoutLbl.frame.origin.x + 60, roomLbl.frame.origin.y + roomLbl.frame.size.height +5, 100, 25);
        
        _priceBaseView.frame = CGRectMake(0, noRoomLbl.frame.origin.y + noRoomLbl.frame.size.height + 10,  bottomBaseView.frame.size.width - 10, 60);
        totalamountLbl.frame = CGRectMake(1, 5, 150, 30);
        totalAmountPriceLbl.frame = CGRectMake((totalamountLbl.frame.size.width + totalamountLbl.frame.origin.x), 5, _priceBaseView.frame.size.width - (totalamountLbl.frame.size.width + totalamountLbl.frame.origin.x), 30);
        cancashAmountLbl.frame = CGRectMake(1, totalamountLbl.frame.size.height + totalamountLbl.frame.origin.y ,  150, 30);
        cancashAmountLbl.hidden = YES;
        cancashAmountPriceLbl.frame =   CGRectMake((cancashAmountLbl.frame.size.width + cancashAmountLbl.frame.origin.x), 5, _priceBaseView.frame.size.width - (cancashAmountLbl.frame.size.width + cancashAmountLbl.frame.origin.x), 30);
        totalAMontPaidLbl.frame = CGRectMake(1, totalamountLbl.frame.size.height + totalamountLbl.frame.origin.y ,  150, 30);
        totalAMontPaidLbl.hidden = NO;
        totalAmountPaidPriceLbl.frame = CGRectMake((totalAMontPaidLbl.frame.size.width + totalAMontPaidLbl.frame.origin.x), 5, _priceBaseView.frame.size.width - (totalAMontPaidLbl.frame.size.width + totalAMontPaidLbl.frame.origin.x), 30);
        
       
        
        _tmcImgBtn.frame = CGRectMake(1, 5 , 20, 20);
        _tmcLblButton.frame = CGRectMake(0, 5, 300, 20);
        
        if (cancasHAmount == 0) {
            _canCashImgBtn.frame = CGRectMake(1, _tmcImgBtn.frame.size.height + _tmcImgBtn.frame.origin.y + 15 , 20, 20);
            _canCashAMountLbl.frame = CGRectMake(35, _tmcImgBtn.frame.size.height + _tmcImgBtn.frame.origin.y + 15, 500, 20);
            
            _canCashAMountLbl.hidden = YES;
            _canCashImgBtn.hidden = YES;
            _payNowButton.frame =  CGRectMake(10, _tmcLblButton.frame.origin.y + _tmcLblButton.frame.size.height +20, 100, 40);
        }else{
            _canCashImgBtn.frame = CGRectMake(1, _tmcImgBtn.frame.size.height + _tmcImgBtn.frame.origin.y + 15 , 20, 20);
            _canCashAMountLbl.frame = CGRectMake(35, _tmcImgBtn.frame.size.height + _tmcImgBtn.frame.origin.y + 15, 500, 20);
             cancashAmountLbl.hidden = NO;
            
            _payNowButton.frame =  CGRectMake(10, _canCashAMountLbl.frame.origin.y + _canCashAMountLbl.frame.size.height +20, 100, 40);
        }
        
      

        luxLbl.frame = CGRectMake(1, _payNowButton.frame.origin.y + _payNowButton.frame.size.height,bottomBaseView.frame.size.width - 40 , 40);
        
         _tmcBaseview.frame =  CGRectMake(0, _priceBaseView.frame.origin.y + _priceBaseView.frame.size.height + 10,  bottomBaseView.frame.size.width - 10, luxLbl.frame.size.height + luxLbl.frame.origin.y + 10);
        
        self.baseSrollView.contentSize = CGSizeMake(self.view.frame.size.width - 10, bottomBaseView.frame.origin.y + bottomBaseView.frame.size.height );

    }else{
        
        self.baseSrollView.frame = CGRectMake(0, baseImageView.frame.size.height + baseImageView.frame.origin.y, self.view.frame.size.width  , self.view.frame.size.height - (baseImageView.frame.size.height + baseImageView.frame.origin.y ) );
        baseview.frame = CGRectMake(10, 10, self.view.frame.size.width - 20, 600);
        self.nameTxtFld.frame = CGRectMake(10, 10,baseview.frame.size.width - 20 , 40);
        self.lastnameTxtFld.frame = CGRectMake(10, self.nameTxtFld.frame.origin.y + self.nameTxtFld.frame.size.height + 10,baseview.frame.size.width - 20 , 40);
        self.mobNoTxtFld.frame =CGRectMake(10, self.lastnameTxtFld.frame.origin.y + self.lastnameTxtFld.frame.size.height + 10,baseview.frame.size.width - 20 , 40);
        self.emailIdTxtFld.frame = CGRectMake(10, self.mobNoTxtFld.frame.origin.y + self.mobNoTxtFld.frame.size.height + 10,baseview.frame.size.width - 20 , 40);
        
        genderBaseView.frame = CGRectMake(10, self.emailIdTxtFld.frame.origin.y + 40 +10,baseview.frame.size.width - 20 , 40);
        _maleBtn.frame = CGRectMake(0, 5, 20, 20);
        maleLbl.frame = CGRectMake(25, 5, 80, 20);
         _femaleBtn.frame = CGRectMake(150, 5, 20, 20);
        femaleLbl.frame = CGRectMake(175, 5, 80, 20);
       
        bottomBaseView.frame =CGRectMake(0, genderBaseView.frame.origin.y + genderBaseView.frame.size.height,self.view.frame.size.width, 300);
        checkInLbl.frame = CGRectMake(5, 0, 130, 20);
        checkInDateLbl.frame = CGRectMake(5, checkInLbl.frame.origin.y + checkInLbl.frame.size.height +5 , 130, 25);
        
        checkoutLbl.frame = CGRectMake(checkInLbl.frame.size.width + checkInLbl.frame.origin.x, 0, 130, 20);
        
        checkOutDateLbl.frame = CGRectMake(checkInDateLbl.frame.size.width + checkInDateLbl.frame.origin.x, checkoutLbl.frame.origin.y + checkoutLbl.frame.size.height +5, 130, 25);
        roomLbl.frame = CGRectMake(checkoutLbl.frame.size.width + checkoutLbl.frame.origin.x, 0, 100, 20);
        noRoomLbl.frame = CGRectMake(checkOutDateLbl.frame.size.width + checkOutDateLbl.frame.origin.x, roomLbl.frame.origin.y + roomLbl.frame.size.height +5, 70, 25);
        noRoomLbl.textAlignment = NSTextAlignmentCenter;
        
       
       
        _tmcImgBtn.frame = CGRectMake(10, 5 , 20, 20);
        _tmcLblButton.frame = CGRectMake(0, 5, 300, 20);
        
        _priceBaseView.frame = CGRectMake(10, _tmcLblButton.frame.origin.y + _tmcLblButton.frame.size.height + 10,  bottomBaseView.frame.size.width - 20, 60);
      
        totalamountLbl.frame = CGRectMake(1, 5, 150, 30);
        totalAmountPriceLbl.frame = CGRectMake((totalamountLbl.frame.size.width + totalamountLbl.frame.origin.x), 5, _priceBaseView.frame.size.width - (totalamountLbl.frame.size.width + totalamountLbl.frame.origin.x), 30);
        cancashAmountLbl.frame = CGRectMake(1, totalamountLbl.frame.size.height + totalamountLbl.frame.origin.y ,  220, 30);
        cancashAmountPriceLbl.frame =   CGRectMake((cancashAmountLbl.frame.size.width + cancashAmountLbl.frame.origin.x),totalamountLbl.frame.size.height + totalamountLbl.frame.origin.y , _priceBaseView.frame.size.width - (cancashAmountLbl.frame.size.width + cancashAmountLbl.frame.origin.x), 30);
        totalAMontPaidLbl.frame = CGRectMake(1, cancashAmountLbl.frame.size.height + cancashAmountLbl.frame.origin.y ,  150, 30);
        totalAMontPaidLbl.hidden = NO;
        totalAmountPaidPriceLbl.frame = CGRectMake((totalAMontPaidLbl.frame.size.width + totalAMontPaidLbl.frame.origin.x), cancashAmountPriceLbl.frame.size.height + cancashAmountPriceLbl.frame.origin.y, _priceBaseView.frame.size.width - (totalAMontPaidLbl.frame.size.width + totalAMontPaidLbl.frame.origin.x), 30);
        
       
        totalamountLbl.text =  [NSString stringWithFormat:@"Total Amount"];
        totalamountLbl.font = [UIFont systemFontOfSize:15];
        totalamountLbl.textAlignment = NSTextAlignmentLeft;
        totalAmountPriceLbl.text = [NSString stringWithFormat:@"₹%@", self.totalAmount];
        totalAmountPriceLbl.font = [UIFont systemFontOfSize:15];
        totalAmountPriceLbl.textAlignment = NSTextAlignmentRight;
        cancashAmountLbl.text =[NSString stringWithFormat:@"Less icanCash"];
        cancashAmountLbl.font = [UIFont systemFontOfSize:15];
        cancashAmountLbl.textAlignment = NSTextAlignmentLeft;
        cancashAmountPriceLbl.text = [NSString stringWithFormat:@"₹%d",cancasHAmount ];
        cancashAmountPriceLbl.font = [UIFont systemFontOfSize:15];
        cancashAmountPriceLbl.textAlignment = NSTextAlignmentRight;
        totalAMontPaidLbl.text = [NSString stringWithFormat:@"To Pay"];
        totalAMontPaidLbl.font = [UIFont boldSystemFontOfSize:15];
        totalAMontPaidLbl.textAlignment = NSTextAlignmentLeft;
        int paidAmount = [self.totalAmount intValue] - cancasHAmount;
        totalAmountPaidPriceLbl.text = [NSString stringWithFormat:@"₹%d", paidAmount];
        totalAmountPaidPriceLbl.font = [UIFont boldSystemFontOfSize:15];
        totalAmountPaidPriceLbl.textAlignment = NSTextAlignmentRight;
       
         
        if (cancasHAmount == 0) {
             _priceBaseView.frame = CGRectMake(10, _tmcLblButton.frame.origin.y + _tmcLblButton.frame.size.height + 10,  bottomBaseView.frame.size.width - 20, 60);
            
           
            totalAMontPaidLbl.frame = CGRectMake(1, totalamountLbl.frame.size.height + totalamountLbl.frame.origin.y ,  150, 30);
            
            totalAmountPaidPriceLbl.frame = CGRectMake((totalAMontPaidLbl.frame.size.width + totalAMontPaidLbl.frame.origin.x), totalamountLbl.frame.size.height + totalamountLbl.frame.origin.y, _priceBaseView.frame.size.width - (totalAMontPaidLbl.frame.size.width + totalAMontPaidLbl.frame.origin.x), 30);
            
            _canCashImgBtn.frame = CGRectMake(1, _tmcImgBtn.frame.size.height + _tmcImgBtn.frame.origin.y + 15 , 20, 20);
            _canCashAMountLbl.frame = CGRectMake(35, _tmcImgBtn.frame.size.height + _tmcImgBtn.frame.origin.y , 300, 50);
             _payNowButton.frame =  CGRectMake((self.view.frame.size.width - 200)/2, _priceBaseView.frame.origin.y + _priceBaseView.frame.size.height +20, 200, 40);
              _canCashAMountLbl.lineBreakMode = NSLineBreakByWordWrapping;
             _canCashAMountLbl.numberOfLines = 2;
          
            
           
            
          
             _canCashAMountLbl.font = [UIFont systemFontOfSize:17];
            _canCashAMountLbl.hidden = YES;
            cancashAmountPriceLbl.hidden = YES;
            cancashAmountLbl.hidden= YES;
            _canCashImgBtn.hidden = YES;
          
        }else{
             _priceBaseView.frame = CGRectMake(10, _tmcLblButton.frame.origin.y + _tmcLblButton.frame.size.height + 10,  bottomBaseView.frame.size.width - 20, 90);
            
            
            
            _canCashImgBtn.frame = CGRectMake(1, _tmcImgBtn.frame.size.height + _tmcImgBtn.frame.origin.y + 15 , 20, 20);
            _canCashAMountLbl.frame = CGRectMake(35, _tmcImgBtn.frame.size.height + _tmcImgBtn.frame.origin.y, 300, 50);
            _canCashAMountLbl.lineBreakMode = NSLineBreakByWordWrapping;
            _canCashAMountLbl.numberOfLines = 2;
            _payNowButton.frame =  CGRectMake((self.view.frame.size.width - 200)/2, _priceBaseView.frame.origin.y + _priceBaseView.frame.size.height +20, 200, 40);
             _canCashAMountLbl.font = [UIFont systemFontOfSize:17];
            
}
     
        
        luxLbl.frame = CGRectMake(1, _payNowButton.frame.origin.y + _payNowButton.frame.size.height +5,bottomBaseView.frame.size.width - 10 , 50);
        luxLbl.lineBreakMode = NSLineBreakByWordWrapping;
        luxLbl.numberOfLines = 2;
       
        _tmcBaseview.frame =  CGRectMake(0, noRoomLbl.frame.origin.y + noRoomLbl.frame.size.height + 10,  bottomBaseView.frame.size.width - 10, luxLbl.frame.size.height + luxLbl.frame.origin.y + 10);
        self.baseSrollView.contentSize = CGSizeMake(self.view.frame.size.width, bottomBaseView.frame.origin.y + bottomBaseView.frame.size.height );

        
    }
    
  
    
    if ([dict count] > 0) {
        self.nameTxtFld.text = [dict objectForKey:@"FirstName"];
        self.lastnameTxtFld.text = [dict objectForKey:@"LastName"];
        self.mobNoTxtFld.text = [dict objectForKey:@"Phone1"];
        self.emailIdTxtFld.text = [dict objectForKey:@"Email"];
    }
    
    checkInDateLbl.text = self.checkInDate;
    checkOutDateLbl.text = self.checkoutDate;
    noRoomLbl.text = self.noOfRomms;
  
    [self startServiceToGetTermsAndConditions];
    
//    baseview.backgroundColor = [UIColor redColor];
//    genderBaseView.backgroundColor = [UIColor greenColor];
//    _priceBaseView.backgroundColor = [UIColor blueColor];
//    bottomBaseView.backgroundColor = [UIColor orangeColor];
//    _tmcBaseview.backgroundColor = [UIColor redColor];
}

-(void)canCAshImgBtnTapped:(id)sender
{
    if ([_CanCAshStrSelectedOrUnselected isEqualToString:@"NO"]) {
         [_canCashImgBtn  setBackgroundImage:[UIImage imageNamed:@"checkbox_selected"] forState:UIControlStateNormal];
        _CanCAshStrSelectedOrUnselected = @"YES";
        
        _priceBaseView.frame = CGRectMake(0, noRoomLbl.frame.origin.y + noRoomLbl.frame.size.height + 10,  bottomBaseView.frame.size.width - 10, 90);
        totalamountLbl.frame = CGRectMake(1, 0, bottomBaseView.frame.size.width - 10, 30);
        cancashAmountLbl.frame = CGRectMake(1, totalamountLbl.frame.size.height + totalamountLbl.frame.origin.y ,  bottomBaseView.frame.size.width - 10, 30);
        cancashAmountLbl.hidden = NO;
        totalAMontPaidLbl.frame = CGRectMake(1, cancashAmountLbl.frame.size.height + cancashAmountLbl.frame.origin.y ,  bottomBaseView.frame.size.width - 10, 30);
        totalAMontPaidLbl.hidden = NO;
        
        _tmcBaseview.frame =  CGRectMake(0, _priceBaseView.frame.origin.y + _priceBaseView.frame.size.height + 10,  bottomBaseView.frame.size.width - 10, luxLbl.frame.size.height + luxLbl.frame.origin.y + 10);
        self.baseSrollView.contentSize = CGSizeMake(self.view.frame.size.width - 10, bottomBaseView.frame.origin.y + bottomBaseView.frame.size.height );
        
        totalamountLbl.text =  [NSString stringWithFormat:@"Total Amount ₹%@", self.totalAmount];
        totalAMontPaidLbl.text = [NSString stringWithFormat:@"Total Amount to be Paid ₹%d", [self.totalAmount intValue] - cancasHAmount];
        cancashAmountLbl.text =[NSString stringWithFormat:@"Available cancash Amount (-)₹%d",cancasHAmount ];
        
        self.totalAmount = [NSString stringWithFormat:@"%d",[self.totalAmount intValue] - cancasHAmount];
        
    }else{
         [_canCashImgBtn  setBackgroundImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
          _CanCAshStrSelectedOrUnselected = @"NO";
        
        _priceBaseView.frame = CGRectMake(0, noRoomLbl.frame.origin.y + noRoomLbl.frame.size.height + 10,  bottomBaseView.frame.size.width - 10, 60);
        totalamountLbl.frame = CGRectMake(1, 0, bottomBaseView.frame.size.width - 10, 30);
        cancashAmountLbl.frame = CGRectMake(1, totalamountLbl.frame.size.height + totalamountLbl.frame.origin.y ,  bottomBaseView.frame.size.width - 10, 30);
        cancashAmountLbl.hidden = YES;
        totalAMontPaidLbl.frame = CGRectMake(1, totalamountLbl.frame.size.height + totalamountLbl.frame.origin.y ,  bottomBaseView.frame.size.width - 10, 30);
        totalAMontPaidLbl.hidden = NO;
        
        _tmcBaseview.frame =  CGRectMake(0, _priceBaseView.frame.origin.y + _priceBaseView.frame.size.height + 10,  bottomBaseView.frame.size.width - 10, luxLbl.frame.size.height + luxLbl.frame.origin.y + 10);
        self.baseSrollView.contentSize = CGSizeMake(self.view.frame.size.width - 10, bottomBaseView.frame.origin.y + bottomBaseView.frame.size.height );
        
          self.totalAmount = [NSString stringWithFormat:@"%d",[self.totalAmount intValue] + cancasHAmount];
        totalamountLbl.text =  [NSString stringWithFormat:@"Total Amount ₹%@", self.totalAmount];
        totalAMontPaidLbl.text = [NSString stringWithFormat:@"Total Amount to be Paid ₹%d", [self.totalAmount intValue]];
        cancashAmountLbl.text =[NSString stringWithFormat:@"Available cancash Amount (-)₹%d",cancasHAmount ];
        
      
    }
    
}
- (void)startServiceToGetTermsAndConditions {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8"
                     forHTTPHeaderField:@"Content-Type"];
    
    
    [manager POST:[NSString stringWithFormat:@"%@/Api/FAQApi/LastMinutedealTermsCondintions", kServerUrl] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        
        NSLog(@"sucess");
        _tAcStr = [responseObject objectForKey:@"LastMinuteTearms"];
         [self termsAndConditionView];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [[ICSingletonManager sharedManager] showAlertViewWithMsg:error.localizedDescription onController:self];
        
    }];
}


-(void)termsAndConditionView
{
    tAcBaseView = [[UIView alloc]initWithFrame:CGRectMake(10, _topWhiteBaseView.frame.origin.y + _topWhiteBaseView.frame.size.height, self.view.frame.size.width - 20,self.view.frame.size.height - (_topWhiteBaseView.frame.origin.y + _topWhiteBaseView.frame.size.height +5) )];
    tAcBaseView.hidden = YES;
    tAcBaseView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:tAcBaseView];
    
    UILabel *tAcLbl = [[UILabel alloc]initWithFrame:CGRectMake(50, 10, tAcBaseView.frame.size.width - 100, 40)];
    tAcLbl.text = @"Terms & Conditions";
    tAcLbl.textAlignment = NSTextAlignmentCenter;
    tAcLbl.textColor = [UIColor blackColor];
    [tAcBaseView addSubview:tAcLbl];
    
    UIButton *dismissBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    dismissBtn.frame = CGRectMake(tAcBaseView.frame.size.width - 50, 5, 30, 30);
    [dismissBtn setBackgroundImage:[UIImage imageNamed:@"cross"] forState:UIControlStateNormal];
    [dismissBtn addTarget:self action:@selector(tAcDismissBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [tAcBaseView addSubview:dismissBtn];
    
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithData:[[_tAcStr stringByReplacingOccurrencesOfString:@"Coupon" withString:@"Voucher"] dataUsingEncoding:NSUTF8StringEncoding]
                                                                   options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                             NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}
                                                        documentAttributes:nil error:nil];
    
  
   
    UITextView * tAcTxtView = [[UITextView alloc]init];
   
  
    [tAcBaseView addSubview:tAcTxtView];
    
      [tAcTxtView setAttributedText:attrStr];
 
    
    UIButton *agreeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
   
    [agreeBtn setTitle:@"Agree" forState:UIControlStateNormal];
    [agreeBtn addTarget:self action:@selector(agreeBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    agreeBtn.layer.masksToBounds = YES;
    agreeBtn.layer.cornerRadius = 5.0;
    [agreeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [agreeBtn setBackgroundColor:[ICSingletonManager colorFromHexString:@"#bd9854"]];
    [tAcBaseView addSubview:agreeBtn];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(disAgreeBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.layer.masksToBounds = YES;
    cancelBtn.layer.cornerRadius = 5.0;
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn setBackgroundColor:[ICSingletonManager colorFromHexString:@"#bd9854"]];
    [tAcBaseView addSubview:cancelBtn];

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
       
        CGSize size = CGSizeMake(tAcBaseView.frame.size.width, CGFLOAT_MAX);
        CGRect paragraphRect =     [attrStr boundingRectWithSize:size
                                                         options:(NSStringDrawingUsesLineFragmentOrigin)
                                                         context:nil];
        tAcTxtView.userInteractionEnabled = NO;
        tAcTxtView.frame =  CGRectMake(0,tAcLbl.frame.size.height +tAcLbl.frame.origin.y + 5 , tAcBaseView.frame.size.width, paragraphRect.size.height +10);
        agreeBtn.frame = CGRectMake(tAcBaseView.frame.size.width - 240, tAcTxtView.frame.size.height + tAcTxtView.frame.origin.y +5, 100, 40);
        cancelBtn.frame = CGRectMake(tAcBaseView.frame.size.width - 120, tAcTxtView.frame.size.height + tAcTxtView.frame.origin.y +5, 100, 40);
        
        
    }else{
        
         tAcTxtView.userInteractionEnabled = YES;
         tAcTxtView.frame =  CGRectMake(0,tAcLbl.frame.size.height +tAcLbl.frame.origin.y + 5 , tAcBaseView.frame.size.width, tAcBaseView.frame.size.height - (tAcLbl.frame.size.height +tAcLbl.frame.origin.y + 5 + 50));
         agreeBtn.frame = CGRectMake(tAcBaseView.frame.size.width - 240, tAcTxtView.frame.size.height + tAcTxtView.frame.origin.y +5, 100, 40);
        cancelBtn.frame = CGRectMake(tAcBaseView.frame.size.width - 120, tAcTxtView.frame.size.height + tAcTxtView.frame.origin.y +5, 100, 40);
       
    }
}

-(NSAttributedString *) getHTMLAttributedString:(NSString *) string {
    NSError *errorFees=nil;
    NSString *sourceFees = [NSString stringWithFormat:
                            @"<span style=\"font-family: 'JosefinSans-Light';font-size: 18px\">%@</span>",string];
    NSMutableAttributedString* strFees = [[NSMutableAttributedString alloc] initWithData:[sourceFees dataUsingEncoding:NSUTF8StringEncoding]
                                                                                 options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                           NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]}
                                                                      documentAttributes:nil error:&errorFees];
    return strFees;
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField.text.length == 0 && [string isEqualToString:@" "]) {
        return NO;
    }
    if(textField == self.nameTxtFld || textField == self.lastnameTxtFld)
    {
        
        NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"];
        for (int i = 0; i < [string length]; i++)
        {
            unichar c = [string characterAtIndex:i];
            if (![myCharSet characterIsMember:c])
            {
                return NO;
            }
        }
        
        return YES;
    }
    
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERS] invertedSet];
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    if (textField == self.mobNoTxtFld) {
        if ((textField.text.length >= 10 && range.length == 0) || ![string isEqualToString:filtered])
            return NO;
        return YES;
    }
    
    if (textField == _emailIdTxtFld) {
        return YES;
    }
    
    return NO;
}


-(void)tAcDismissBtnTapped:(id)sender
{
    tAcBaseView.hidden = YES;
    [_tmcImgBtn  setBackgroundImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
     _tAcStrSelectedOrUnselected = @"NO";

}
-(void)tmcLblBtnTapped:(id)sender
{
    tAcBaseView.hidden = NO;

}
-(void)agreeBtnTapped:(id)sender
{
     tAcBaseView.hidden = YES;
     _tAcStrSelectedOrUnselected = @"YES";
    [_tmcImgBtn  setBackgroundImage:[UIImage imageNamed:@"checkbox_selected"] forState:UIControlStateNormal];
}
-(void)disAgreeBtnTapped:(id)sender
{
     tAcBaseView.hidden = YES;
    [_tmcImgBtn  setBackgroundImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
     _tAcStrSelectedOrUnselected = @"NO";
}

-(void)PayNowBtnTapped:(id)sender
{
    if ([self.nameTxtFld.text isEqualToString:@""]) {
        
         [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Please Enter The First Name" onController:self];
        
    }else if ([self.lastnameTxtFld.text isEqualToString:@""]){
         [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Please Enter The Last Name" onController:self];
    }else if ([self.mobNoTxtFld.text isEqualToString:@""]){
         [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Please Enter The Mobile Number" onController:self];
        
    }else if ([self.emailIdTxtFld.text isEqualToString:@""]){
         [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Please Eneter The Email Id " onController:self];
        
    }else if ([_tAcStrSelectedOrUnselected isEqualToString:@"NO"]){
         [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Please Accept Terms And Conditions" onController:self];
    }else  {
        
        if ([self validateEmail:self.emailIdTxtFld.text]) {
           
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            paymentController = [storyboard instantiateViewControllerWithIdentifier:@"PaymentControllerGateway"];
            [self designPaymentController];
            [self setupWebView];
            [self.navigationController pushViewController:paymentController animated:YES];
        }else{
             [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Please Eneter Valid Email Id." onController:self];
        }
        
       
    }
    
}

- (BOOL)validateEmail:(NSString *)emailStr
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
}

-(void)PostDataforOrderID
{
    //http://dev.icanstay.businesstowork.com/api/BuyCoupens/GetOrderIDMobile?
    //IsHotelMappedCity parameter
    
    LoginManager *loginManage = [[LoginManager alloc]init];
    NSDictionary *dict = [loginManage isUserLoggedIn];
    NSNumber *num = [dict valueForKey:@"UserId"];
    
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *couponNumber; //= [f numberFromString:self.selectCouponCount.text];
    
    NSNumber *couponPrice; //= [self.dictFromServer valueForKey:@"CouponPrice"];
    couponPrice= [[ICSingletonManager sharedManager]removeNullObjectFromNumber:couponPrice];
    
    NSMutableDictionary *dictPost=[NSMutableDictionary new];
    [dictPost setValue:[NSNumber numberWithInt:0] forKey:@"OrderID"];
    [dictPost setValue:num forKey:@"UserID"];
    [dictPost setValue:[NSNumber numberWithInt:1] forKey:@"TotalCoupons"];
    
    NSString *strOrderDate=  [[ICSingletonManager sharedManager] convertToNSStringFromTodaysDate];
    
    int voucherAmount = 2999;
    
    [dictPost setValue:[NSNumber numberWithInt:voucherAmount] forKey:@"TotalAmount"];
    [dictPost setValue:[NSNumber numberWithInt:voucherAmount] forKey:@"NetAmount"];
    [dictPost setValue:strOrderDate forKey:@"CreatedDate"];
    [dictPost setValue:@"" forKey:@"Status"];
    //  [dictPost setValue:@"1" forKey:@"PaymentMode"];
    [dictPost setValue:@"" forKey:@"EntityKey"];
    
    //  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
    [manager POST:[NSString stringWithFormat:@"%@/api/BuyCoupens/GetOrderIDMobile",kServerUrl] parameters:dictPost success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        
        NSString *status = [responseObject valueForKey:@"status"];
        NSString *msg = [responseObject valueForKey:@"errorMessage"];
        if ([status isEqualToString:@"SUCCESS"]) {
            orderID = msg;
            //  [self setupWebView];
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            paymentController = [storyboard instantiateViewControllerWithIdentifier:@"PaymentControllerGateway"];
            [self designPaymentController];
            [self setupWebView];
            [self.navigationController pushViewController:paymentController animated:YES];
            
        }
        
        NSLog(@"sucess");
        //        [[ICSingletonManager sharedManager]showAlertViewWithMsg:msg onController:self];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:error.localizedDescription onController:self];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}

-(void)designPaymentController
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    UIView *topBluebaseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenRect.size.width, 60)];
    topBluebaseView.backgroundColor = [ICSingletonManager colorFromHexString:@"#001d3d"];[paymentController.view addSubview:topBluebaseView];
    
    UILabel *buyVoucherLbl = [[UILabel alloc]initWithFrame:CGRectMake((topBluebaseView.frame.size.width - 200) / 2, topBluebaseView.frame.size.height - 35, 200, 30)];
    buyVoucherLbl.text = @"Last Minute Deal";
    buyVoucherLbl.font = [UIFont systemFontOfSize:24];
    buyVoucherLbl.textColor = [UIColor whiteColor];
    [topBluebaseView addSubview:buyVoucherLbl];
    
    UIButton *backButtonToBuyVoucher = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    backButtonToBuyVoucher.frame = CGRectMake(20,topBluebaseView.frame.size.height - 25 , 30, 20);
    [backButtonToBuyVoucher  setBackgroundImage:[UIImage imageNamed:@"backIconNew"] forState:UIControlStateNormal];
    backButtonToBuyVoucher.backgroundColor = [UIColor clearColor];
    [backButtonToBuyVoucher addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [topBluebaseView addSubview:backButtonToBuyVoucher];
    PrWebview=[[UIWebView alloc]initWithFrame:CGRectMake(0, topBluebaseView.frame.origin.y + topBluebaseView.frame.size.height, screenRect.size.width,screenRect.size.height - topBluebaseView.frame.size.height - topBluebaseView.frame.origin.y)];
    PrWebview.delegate = self;
    [paymentController.view addSubview:PrWebview];

}
-(void)setupWebView
{
    
    
    LoginManager *loginManage = [[LoginManager alloc]init];
    NSDictionary *dict = [loginManage isUserLoggedIn];
    
    NSString *userName = [NSString stringWithFormat:@"%@ %@", [dict objectForKey:@"FirstName"], [dict objectForKey:@"LastName"]];
    
    
    
    NSNumber *num = [dict valueForKey:@"UserId"];
    NSString *strUserAddress = [dict valueForKey:@"Address"];
    NSString *strState = [dict valueForKey:@"State"];
    NSString *strCity = [dict valueForKey:@"City"];
    NSNumber *numPinCode= [dict valueForKey:@"Zip"];
    
    
    
    NSString *name = [NSString stringWithFormat:@"%@ %@",[dict valueForKey:@"FirstName"],[dict valueForKey:@"LastName"]];
    int amount = 2999;

    NSString *  merchant2 = [NSString stringWithFormat:@"%@|%@|True|False|False",@"1",[dict valueForKey:@"Gender"]];
    
    NSString *merchant3 = [NSString stringWithFormat:@"%@|%@|%@|%@",[dict valueForKey:@"Phone1"],self.mobNoTxtFld.text,self.nameTxtFld.text,self.lastnameTxtFld.text];
    
    NSString *merchant4 = [NSString stringWithFormat:@"%@|0|%@|%@|%@|%@",num,strUserAddress,strState,strCity,numPinCode];
  
    NSString *paymentUrlString =[NSString stringWithFormat:@"%@/PaymentProcess/MobilePaymentResponse",kServerUrl];
    //  NSString *paymentUrlString = @"http://dev.icanstay.com/PaymentProcess/MobilePaymentResponse";
    
    
    NSString *merchant5 = [NSString stringWithFormat:@"%@|%@|%@|False|False|False|False||",self.emailIdTxtFld.text,[dict valueForKey:@"Email"],[dict valueForKey:@"Gender"]];
    
    
    //merchant5 - user etered email/ saved emailid / enter gender/|False|False|False|False||
    
    //  [self.webView setHidden:NO];
    // [self.webView setDelegate:self];
    //    NSString *urlString= [NSString stringWithFormat:@"http://dev.icanstay.businesstowork.com/PaymentProcess/PaymentRequestProcess?UserID=%@&OrderID=%@&Amount=%d&Currency=INR&Language=EN&RedirectURL=%@&CancelURL=%@&MerchantParam1=%@&MerchantParam2=%@&MerchantParam3=%@&MerchantParam4=%@&MerchantParam5=%@&promo_code=null&customer_identifier=%@",num,orderID,amount,paymentUrlString,paymentUrlString,name,merchant2,merchant3,merchant4,merchant5,num];
    
    
    //    NSString *urlString= [NSString stringWithFormat:@"http://dev.icanstay.com/PaymentProcess/PaymentRequestProcess?UserID=%@&OrderID=%@&Amount=%d&Currency=INR&Language=EN&RedirectURL=%@&CancelURL=%@&MerchantParam1=%@&MerchantParam2=%@&MerchantParam3=%@&MerchantParam4=%@&MerchantParam5=%@&promo_code=null&customer_identifier=%@",num,orderID,amount,paymentUrlString,paymentUrlString,name,merchant2,merchant3,merchant4,merchant5,num];
//    
    NSString *urlString= [NSString stringWithFormat:@"%@/PaymentProcess/PaymentRequestProcess?UserID=%@&OrderID=%@&Amount=%d&Currency=INR&Language=EN&RedirectURL=%@&CancelURL=%@&MerchantParam1=%@&MerchantParam2=%@&MerchantParam3=%@&MerchantParam4=%@&MerchantParam5=%@&promo_code=null&customer_identifier=%@",kServerUrl,num,orderID,amount,paymentUrlString,paymentUrlString,name,merchant2,merchant3,merchant4,merchant5,num];
    
    NSString *checkInDate;
    NSString *checkOutDate;
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd-MMM-yyyy"];
    NSDate * dateNotFormatted = [dateFormatter dateFromString:self.checkInDate];
    NSDate * dateNotFormatted1 = [dateFormatter dateFromString:self.checkoutDate];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
   checkInDate = [dateFormatter stringFromDate:dateNotFormatted];
    checkOutDate = [dateFormatter stringFromDate:dateNotFormatted1];
    
    
    
//    NSString *urlstr = [NSString stringWithFormat:@"http://dev.icanstay.com/lastminutedeal/GetApiResultPaymetConnection?cityId=%@&cityname=%@&hotelPrice=2999&hotelId=%@&searchDate=%@&endDate=%@&noOfRooms=%@&fristname=%@&lastname=%@&mobile=%@&emaill=%@&gender=%@",self.cityId,self.cityCeo,self.hotelId, checkInDate,checkOutDate,self.noOfRomms,[dict valueForKey:@"FirstName"],[dict valueForKey:@"LastName"],[dict valueForKey:@"Phone1"],[dict valueForKey:@"Email"],[dict valueForKey:@"Gender"]  ];
    
    NSString *urlstr;
    
    
    if ([_CanCAshStrSelectedOrUnselected isEqualToString:@"YES"]) {
        if ([dict count] > 0) {
            urlstr = [NSString stringWithFormat:@"%@/PaymentProcess/PaymentRequestProcessLastMinuteDeal?userid=%@&amount=%@&cityid=%@&startdate=%@&enddate=%@&hotelid=%@&firstName=%@&firstName=%@&email=%@&mobile=%@&gender=%@&noOfRooms=%@&cancashAmount=%d",kServerUrl,num,self.totalAmount,self.cityId,checkInDate,checkOutDate,self.hotelId,[dict valueForKey:@"FirstName"],[dict valueForKey:@"LastName"],[dict valueForKey:@"Email"],[dict valueForKey:@"Phone1"],self.strGender,self.noOfRomms,cancasHAmount];
           
        }else{
            
            urlstr = [NSString stringWithFormat:@"%@/PaymentProcess/PaymentRequestProcessLastMinuteDeal?userid=%@&amount=%@&cityid=%@&startdate=%@&enddate=%@&hotelid=%@&firstName=%@&firstName=%@&email=%@&mobile=%@&gender=%@&noOfRooms=%@&cancashAmount=0",kServerUrl,num,self.totalAmount,self.cityId,checkInDate,checkOutDate,self.hotelId,_nameTxtFld.text,_lastnameTxtFld.text,_emailIdTxtFld.text,_mobNoTxtFld.text,self.strGender,self.noOfRomms];
        }
    }else{
        if ([dict count] > 0) {
            urlstr = [NSString stringWithFormat:@"%@/PaymentProcess/PaymentRequestProcessLastMinuteDeal?userid=%@&amount=%@&cityid=%@&startdate=%@&enddate=%@&hotelid=%@&firstName=%@&firstName=%@&email=%@&mobile=%@&gender=%@&noOfRooms=%@&cancashAmount=0",kServerUrl,num,self.totalAmount,self.cityId,checkInDate,checkOutDate,self.hotelId,[dict valueForKey:@"FirstName"],[dict valueForKey:@"LastName"],[dict valueForKey:@"Email"],[dict valueForKey:@"Phone1"],self.strGender,self.noOfRomms];
           
        }else{
            
            urlstr = [NSString stringWithFormat:@"%@/PaymentProcess/PaymentRequestProcessLastMinuteDeal?userid=%@&amount=%@&cityid=%@&startdate=%@&enddate=%@&hotelid=%@&firstName=%@&firstName=%@&email=%@&mobile=%@&gender=%@&noOfRooms=%@&cancashAmount=0",kServerUrl,num,self.totalAmount,self.cityId,checkInDate,checkOutDate,self.hotelId,_nameTxtFld.text,_lastnameTxtFld.text,_emailIdTxtFld.text,_mobNoTxtFld.text,self.strGender,self.noOfRomms];
        }
    }
    
    
    
    NSString* webStringURL = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL* url = [NSURL URLWithString:webStringURL];
  //    NSURL *url = [NSURL URLWithString:[self getURLFromString:urlString]];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [PrWebview loadRequest:urlRequest];
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUDForView:paymentController.view animated:YES];
    [MBProgressHUD showHUDAddedTo:paymentController.view animated:YES];
}
//- (void)startServiceToGetCouponsDetailsLastMinuteDeal:(NSDictionary *)json
//{
//
//      [MBProgressHUD showHUDAddedTo:paymentController.view animated:YES];
//    
//
//
//
//}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
   
     [MBProgressHUD hideHUDForView:paymentController.view animated:YES];
    if (isff) {
        isff = NO;
        NSString *currentURL = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName(\"pre\")[0].innerHTML;"];
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:[currentURL dataUsingEncoding:NSUTF8StringEncoding]
                                                             options:kNilOptions
                                                               error:NULL];
        
     //    [self.navigationController popViewControllerAnimated:YES];
        if ([[json objectForKey:@"StatusOfPaymentGetWay"] isEqualToString:@"SUCCESS"]) {
            [self startServiceToGeticanCash:json];
            
        } else if ([[json objectForKey:@"StatusOfPaymentGetWay"] isEqualToString:@"FAIL"] || [[json objectForKey:@"StatusOfPaymentGetWay"] isEqualToString:@"ABORTED"]) {
            
            ICSingletonManager *globals = [ICSingletonManager sharedManager];
            globals.isFromLastMinuteBookingPaymentSuccess = @"NO";
            globals.isFromLastMinuteBookingPaymentFail = @"YES";
            
            [MBProgressHUD hideHUDForView:paymentController.view animated:YES];
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            LastMinuteViewController *lastMinute = [storyboard instantiateViewControllerWithIdentifier:@"LastMinuteViewController"];
            lastMinute.confirmPaymentJsonDict = json;
            SideMenuController *vcSideMenu =     [storyboard instantiateViewControllerWithIdentifier:@"SideMenuController"];
            
            MMDrawerController *drawerController = [[MMDrawerController alloc]initWithCenterViewController:lastMinute leftDrawerViewController:vcSideMenu];
            [drawerController setRestorationIdentifier:@"MMDrawer"];
            //                         [drawerController setMaximumLeftDrawerWidth:[UIScreen mainScreen].bounds.size.width -[UIScreen mainScreen].bounds.size.width/2 ];
            [drawerController setMaximumLeftDrawerWidth:SCREEN_WIDTH*2/3];
            
            [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
            [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
            drawerController.shouldStretchDrawer = NO;
            
            UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:drawerController];
            [navController setNavigationBarHidden:YES];
            
            [navController setNavigationBarHidden:YES];
            paymentController.view.window.rootViewController = navController;
            //            [window setRootViewController:navController];
            [paymentController.view.window makeKeyAndVisible];

                            }
    }
        
        
    
}

- (void)startServiceToGeticanCash:(NSDictionary *)json
{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    LoginManager *loginManage = [[LoginManager alloc]init];
    NSDictionary *dict = [loginManage isUserLoggedIn];
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
    NSNumber *num = [dict valueForKey:@"UserId"];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8"
                     forHTTPHeaderField:@"Content-Type"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/Api/FAQApi/GetCancashAmount?userId=%d",kServerUrl,[num intValue]];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        {
            
            
            LoginManager *loginManage = [[LoginManager alloc]init];
            NSDictionary *dict = [loginManage isUserLoggedIn];
            
            if ([dict count] > 0) {
                ICSingletonManager *globals = [ICSingletonManager sharedManager];
                
                
                if ([[globals.menuLoadArry valueForKey:@"UserPastStayCount"] intValue]!=0) {
                    ICSingletonManager *globals = [ICSingletonManager sharedManager];
                    globals.isFromLastMinuteBookingPaymentSuccess = @"YES";
                    globals.isFromLastMinuteBookingPaymentFail = @"NO";
                    
                    [MBProgressHUD hideHUDForView:paymentController.view animated:YES];
                    
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                    CurrentStayScreen *currentStay = [storyboard instantiateViewControllerWithIdentifier:@"CurrentStayScreen"];
                    currentStay.confirmPaymentJsonDict = json;
                    SideMenuController *vcSideMenu =     [storyboard instantiateViewControllerWithIdentifier:@"SideMenuController"];
                    
                    MMDrawerController *drawerController = [[MMDrawerController alloc]initWithCenterViewController:currentStay leftDrawerViewController:vcSideMenu];
                    [drawerController setRestorationIdentifier:@"MMDrawer"];
                    //                         [drawerController setMaximumLeftDrawerWidth:[UIScreen mainScreen].bounds.size.width -[UIScreen mainScreen].bounds.size.width/2 ];
                    [drawerController setMaximumLeftDrawerWidth:SCREEN_WIDTH*2/3];
                    
                    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
                    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
                    drawerController.shouldStretchDrawer = NO;
                    
                    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:drawerController];
                    [navController setNavigationBarHidden:YES];
                    
                    [navController setNavigationBarHidden:YES];
                    paymentController.view.window.rootViewController = navController;
                    //            [window setRootViewController:navController];
                    [paymentController.view.window makeKeyAndVisible];
                    
                    
                }else {
                    ICSingletonManager *globals = [ICSingletonManager sharedManager];
                    globals.isFromLastMinuteBookingPaymentSuccess = @"YES";
                    globals.isFromLastMinuteBookingPaymentFail = @"NO";
                    globals.firstTimeVoucherPurchase = @"YES";
                    [MBProgressHUD hideHUDForView:paymentController.view animated:YES];
                    
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                    LastMinuteViewController *lastMinute = [storyboard instantiateViewControllerWithIdentifier:@"LastMinuteViewController"];
                    lastMinute.confirmPaymentJsonDict = json;
                    SideMenuController *vcSideMenu =     [storyboard instantiateViewControllerWithIdentifier:@"SideMenuController"];
                    
                    MMDrawerController *drawerController = [[MMDrawerController alloc]initWithCenterViewController:lastMinute leftDrawerViewController:vcSideMenu];
                    [drawerController setRestorationIdentifier:@"MMDrawer"];
                    //                         [drawerController setMaximumLeftDrawerWidth:[UIScreen mainScreen].bounds.size.width -[UIScreen mainScreen].bounds.size.width/2 ];
                    [drawerController setMaximumLeftDrawerWidth:SCREEN_WIDTH*2/3];
                    
                    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
                    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
                    drawerController.shouldStretchDrawer = NO;
                    
                    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:drawerController];
                    [navController setNavigationBarHidden:YES];
                    
                    [navController setNavigationBarHidden:YES];
                    paymentController.view.window.rootViewController = navController;
                    //            [window setRootViewController:navController];
                    [paymentController.view.window makeKeyAndVisible];
                }
                LoginManager *loginManage = [[LoginManager alloc]init];
                NSDictionary *dict = [loginManage isUserLoggedIn];
                NSString *userName = [NSString stringWithFormat:@"%@ %@", [dict objectForKey:@"FirstName"], [dict objectForKey:@"LastName"]];
                
                
                //    NSString *puchasedCouponStr = [json objectForKey:@"PurchasedCouponCount"];
                
                
                
                /****************** Mo Engage *******************/
                NSMutableDictionary *purchaseDict = [NSMutableDictionary dictionaryWithDictionary:@{@"Mobile No": [dict objectForKey:@"Phone1"],@"Email":[dict objectForKey:@"Email"], @"Name": userName,@"No of Voucher":@"1" }];
                
                
                [[MoEngage sharedInstance]trackEvent:@"App Voucher Purchase IOS" andPayload:purchaseDict];
                [[MoEngage sharedInstance] syncNow];
                [MoEngage debug:LOG_ALL];
                
                /****************** Mo Engage *******************/
                
                /****************** Google Analytics *******************/
                
                // Track the Event for UserSuccessfulRegistrationMobile
                
                NSString *actionStr = [NSString stringWithFormat:@"%@ %@ 1", userName,[dict objectForKey:@"Phone1"]];
                id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
                [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"App Voucher Purchase IOS"
                                                                      action:actionStr
                                                                       label:[dict objectForKey:@"Phone1"]
                                                                       value:nil] build]];
                
                /****************** Google Analytics *******************/
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
            }else{
                ICSingletonManager *globals = [ICSingletonManager sharedManager];
                globals.isFromLastMinuteBookingPaymentSuccess = @"YES";
                globals.isFromLastMinuteBookingPaymentFail = @"NO";
                
                [MBProgressHUD hideHUDForView:paymentController.view animated:YES];
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                LastMinuteViewController *lastMinute = [storyboard instantiateViewControllerWithIdentifier:@"LastMinuteViewController"];
                lastMinute.confirmPaymentJsonDict = json;
                SideMenuController *vcSideMenu =     [storyboard instantiateViewControllerWithIdentifier:@"SideMenuController"];
                
                MMDrawerController *drawerController = [[MMDrawerController alloc]initWithCenterViewController:lastMinute leftDrawerViewController:vcSideMenu];
                [drawerController setRestorationIdentifier:@"MMDrawer"];
                //                         [drawerController setMaximumLeftDrawerWidth:[UIScreen mainScreen].bounds.size.width -[UIScreen mainScreen].bounds.size.width/2 ];
                [drawerController setMaximumLeftDrawerWidth:SCREEN_WIDTH*2/3];
                
                [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
                [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
                drawerController.shouldStretchDrawer = NO;
                
                UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:drawerController];
                [navController setNavigationBarHidden:YES];
                
                [navController setNavigationBarHidden:YES];
                paymentController.view.window.rootViewController = navController;
                //            [window setRootViewController:navController];
                [paymentController.view.window makeKeyAndVisible];
            }
            
            NSString *userName = [NSString stringWithFormat:@"%@ %@", [dict objectForKey:@"FirstName"], [dict objectForKey:@"LastName"]];
            
            
            /****************** Mo Engage *******************/
            NSMutableDictionary *purchaseDict = [NSMutableDictionary dictionaryWithDictionary:@{@"Mobile No": [dict objectForKey:@"Phone1"],@"Email":[dict objectForKey:@"Email"], @"Name": userName }];
            
            
            [[MoEngage sharedInstance]trackEvent:@"LastMinuteDeal Booking IOS" andPayload:purchaseDict];
            [[MoEngage sharedInstance] syncNow];
            [MoEngage debug:LOG_ALL];
        }
        
        
        NSString *icansCAshPoint = [responseObject objectForKey:@"cancashpoint"];
        globals.userCancashAmountAvailable = icansCAshPoint;
        
        globals.isFirstTimeMenuLoadWebService = @"YES";
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [[ICSingletonManager sharedManager] showAlertViewWithMsg:error.localizedDescription onController:self];
        
    }];
    
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"Failed to load with error :%@",[error debugDescription]);
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *URLString = [[request URL] absoluteString];
    
    NSLog(@"%@", URLString);
    if ([kServerUrl isEqualToString:@"http://staging.icanstay.com"]) {
        
    
    
    if ([URLString isEqualToString:[NSString stringWithFormat:@"%@/PaymentProcess/MobilePaymentResponseDeal", kServerUrl]])
    {
        isff= true;
        

    }
    }else if ([kServerUrl isEqualToString:@"http://www.icanstay.com"]){
        if ([URLString isEqualToString:[NSString stringWithFormat:@"http://www.icanstay.com/PaymentProcess/MobilePaymentResponseDeal"]])
        {
            isff= true;
            
            
        }
    }
    return YES;
}

-(void)tmcImgBtnTapped:(id)sender
{
    tAcBaseView.hidden = NO;
}
-(void)genderMaleBtnTapped:(id)sender
{
    [self.maleBtn setBackgroundImage:[UIImage imageNamed:@"radio_selected"] forState:UIControlStateNormal];
    [self.femaleBtn setBackgroundImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
    self.strGender = @"M";
//    
//    [self.btnGenderMale setBackgroundImage:[UIImage imageNamed:@"radio_selected"] forState:UIControlStateNormal];
//    [self.btnGenderFemale setBackgroundImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
}
-(void)genderFemaleBtnTapped:(id)sender
{
    [self.maleBtn setBackgroundImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
    [self.femaleBtn setBackgroundImage:[UIImage imageNamed:@"radio_selected"] forState:UIControlStateNormal];
    self.strGender = @"F";
//    
//    [self.btnGenderMale setBackgroundImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
//    [self.btnGenderFemale setBackgroundImage:[UIImage imageNamed:@"radio_selected"] forState:UIControlStateNormal];
}
-(void)backButtonTapped:(id)sender
{
           [self.navigationController popViewControllerAnimated:YES];
        
   
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
