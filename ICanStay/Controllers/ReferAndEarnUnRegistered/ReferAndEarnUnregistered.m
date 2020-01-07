//
//  ReferAndEarnUnregistered.m
//  ICanStay
//
//  Created by Planet on 11/30/17.
//  Copyright © 2017 verticallogics. All rights reserved.
//

#import "ReferAndEarnUnregistered.h"
#import "NotificationScreen.h"
#import "DashboardScreen.h"
#import "GradientButton.h"
#import "RegistrationScreen.h"
#import "LoginScreen.h"
#import "HomeScreenController.h"
#import "SideMenuController.h"

@interface ReferAndEarnUnregistered ()
@property (nonatomic, strong) UIView         *topWhiteBaseView;
@property (nonatomic, strong) UIButton       *backButton;
@property (nonatomic, strong) UIButton       *notificationButton;
@property (nonatomic, strong) UIImageView    *logoIconImgView;
@property (nonatomic, strong) UIView         *tcBaseView;
@end

@implementation ReferAndEarnUnregistered

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    self.topWhiteBaseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,screenRect.size.width , 60)];
    self.topWhiteBaseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.topWhiteBaseView];
    
    self.notificationButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.notificationButton.frame = CGRectMake(self.topWhiteBaseView.frame.size.width - 40 - 10, 25, 24, 24);
    [self.notificationButton setBackgroundImage:[UIImage imageNamed:@"notification1"] forState:UIControlStateNormal];
    [self.notificationButton addTarget:self action:@selector(notificationButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.topWhiteBaseView addSubview:self.notificationButton];
    
    
    
    
    self.logoIconImgView = [[UIImageView alloc]initWithFrame:CGRectMake((self.topWhiteBaseView.frame.size.width - 150)/2, 15, 150, 36)];
    self.logoIconImgView.image = [UIImage imageNamed:@"topBanner"];
    self.logoIconImgView.userInteractionEnabled = YES;
    [self.topWhiteBaseView addSubview:self.logoIconImgView];
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [self.topWhiteBaseView addGestureRecognizer:singleFingerTap];
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.backButton.frame = CGRectMake(20, 25, 30, 20);
    [self.backButton setBackgroundImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.topWhiteBaseView addSubview:self.backButton];
    
    
    [self designBaseView];
    [self tcBaseViewDesign];
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
-(void)designBaseView{
   
    UIView *baseView = [[UIView alloc]init];
    [self.view addSubview:baseView];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        baseView.frame = CGRectMake((self.view.frame.size.width - 360 )/2,self.topWhiteBaseView.frame.size.height , 360, 550);
    }else{
         baseView.frame = CGRectMake(0,self.topWhiteBaseView.frame.size.height , self.view.frame.size.width, self.view.frame.size.height - self.topWhiteBaseView.frame.size.height);
    }
    UIView *bluebaseView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, baseView.frame.size.width, 50)];
    bluebaseView.backgroundColor = [ICSingletonManager colorFromHexString:@"#001d3d"];
    [baseView addSubview:bluebaseView];
    
    UILabel *referEarnLackLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, baseView.frame.size.width, 20)];
    referEarnLackLbl.textColor = [UIColor whiteColor];
    referEarnLackLbl.font = [UIFont boldSystemFontOfSize:18];
    referEarnLackLbl.textAlignment = NSTextAlignmentCenter;
    referEarnLackLbl.text = @"Refer & Earn icanCash Up to ₹1 Lakh";
    [bluebaseView addSubview:referEarnLackLbl];
    
    UILabel *discountLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, referEarnLackLbl.frame.size.height + referEarnLackLbl.frame.origin.y, baseView.frame.size.width, 20)];
    discountLbl.textColor = [UIColor whiteColor];
    discountLbl.font = [UIFont systemFontOfSize:15];
    discountLbl.textAlignment = NSTextAlignmentCenter;
    discountLbl.text = @"Redeem & Get Cashback With Every Purchase";
    [bluebaseView addSubview:discountLbl];
    
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(5,bluebaseView.frame.size.height + bluebaseView.frame.origin.y + 10,baseView.frame.size.width - 10 , 230)];
    webView.scrollView.scrollEnabled = NO;
    webView.userInteractionEnabled = NO;
    NSString *str = @"icanCash is our rewards programme where you can earn cash in your icanstay account simply by referring us to your friends. Every unit of icanCash you earn is equal to one rupee, which you can use to buy a luxury stay voucher or make a last-minute booking on our site or mobile app.";
    
 //   [webView loadHTMLString:[NSString stringWithFormat:@"<div align='justify'>%@<div>", str ]baseURL:nil];
    [webView loadHTMLString:[NSString stringWithFormat:@"<html><body style=\"text-align:justify\"><font color='Gray'><font size='4'> %@ </font></font></body></Html>", str] baseURL:nil];
   
     [baseView addSubview:webView];

    //    UITextView *txtView = [[UITextView alloc]initWithFrame:CGRectMake(5,bluebaseView.frame.size.height + bluebaseView.frame.origin.y + 10,baseView.frame.size.width - 10 , 260)];
//    txtView.text = @"icanCash is our rewards programme where you can earn cash in your icanstay account simply by referring us to your friends through your phone contacts. Every unit of icanCash you earn is equal to one rupee, which you can use to get discounts whenever you buy a luxury stay voucher, make a last-minute booking or buy a holiday package on our site or mobile app.";
//    txtView.scrollEnabled = NO;
//    txtView.userInteractionEnabled = NO;
//    txtView.editable = NO;
//    txtView.font = [UIFont systemFontOfSize:18];
//    [baseView addSubview:txtView];
    
    GradientButton *registerBtn =  [[GradientButton alloc]init];
    [registerBtn setTitle:@"REGISTER NOW" forState:UIControlStateNormal];
    [registerBtn setTintColor:[UIColor blackColor]];
    [registerBtn useRedDeleteStyle];
    registerBtn.frame = CGRectMake((baseView.frame.size.width - 200)/2,webView.frame.size.height + webView.frame.origin.y + 10 ,200 ,40);
    [registerBtn addTarget:self action:@selector(registerNowTapped:) forControlEvents:UIControlEventTouchUpInside];
    [baseView addSubview:registerBtn];
    
    UILabel *alreadyRegisteredMemberLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, registerBtn.frame.size.height + registerBtn.frame.origin.y + 20, baseView.frame.size.width, 20)];
    alreadyRegisteredMemberLbl.textColor = [ICSingletonManager colorFromHexString:@"#808080"];
    alreadyRegisteredMemberLbl.font = [UIFont systemFontOfSize:15];
    alreadyRegisteredMemberLbl.textAlignment = NSTextAlignmentCenter;
    alreadyRegisteredMemberLbl.text = @"Already registered member?";
    [baseView addSubview:alreadyRegisteredMemberLbl];
    
    GradientButton *logInBtn =  [[GradientButton alloc]init];
    [logInBtn setTitle:@"LOG IN" forState:UIControlStateNormal];
    [logInBtn setTintColor:[UIColor blackColor]];
    [logInBtn useRedDeleteStyle];
    logInBtn.frame = CGRectMake((baseView.frame.size.width - 200 )/2,alreadyRegisteredMemberLbl.frame.size.height + alreadyRegisteredMemberLbl.frame.origin.y +5 ,200 ,40);
    [logInBtn addTarget:self action:@selector(logInNowTapped:) forControlEvents:UIControlEventTouchUpInside];
    [baseView addSubview:logInBtn];
    
   UIButton * termsAndConditionButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    termsAndConditionButton.frame = CGRectMake((baseView.frame.size.width - 150 )/2, baseView.frame.size.height - 40 , 150, 20);
    [termsAndConditionButton setTitle:@"Terms & Conditions" forState:UIControlStateNormal];
    [termsAndConditionButton addTarget:self action:@selector(termsConditionButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [termsAndConditionButton setTintColor:[ICSingletonManager colorFromHexString:@"#808080"]];
    [termsAndConditionButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [baseView addSubview:termsAndConditionButton];
    
    UIView *shareContactsNarrowLine = [[UIView alloc]initWithFrame:CGRectMake((baseView.frame.size.width - 140 )/2, termsAndConditionButton.frame.size.height + termsAndConditionButton.frame.origin.y  , 140, 1)];
    shareContactsNarrowLine.backgroundColor = [ICSingletonManager colorFromHexString:@"#808080"];
    [baseView addSubview:shareContactsNarrowLine];
    
}
-(void)tcBaseViewDesign
{
    self.tcBaseView = [[UIView alloc]init];
    self.tcBaseView.backgroundColor = [UIColor whiteColor];
    self.tcBaseView.hidden = YES;
    
    UIView *tcBaseView = [[UIView alloc]init];
    tcBaseView.backgroundColor = [ICSingletonManager colorFromHexString:@"#001d3d"];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.tcBaseView.frame = CGRectMake((self.view.frame.size.width - 360)/2,self.topWhiteBaseView.frame.size.height + self.topWhiteBaseView.frame.origin.y , 360, 670);
        tcBaseView.frame = CGRectMake(0, 0, self.tcBaseView.frame.size.width, 40);
    }else{
        self.tcBaseView.frame = CGRectMake(0, _topWhiteBaseView.frame.size.height + _topWhiteBaseView.frame.origin.y , self.view.frame.size.width , self.view.frame.size.height - (_topWhiteBaseView.frame.size.height + _topWhiteBaseView.frame.origin.y ));
        tcBaseView.frame = CGRectMake(0, 0, self.tcBaseView.frame.size.width, 40);
    }
    [self.view addSubview:_tcBaseView];
    [_tcBaseView addSubview:tcBaseView];
    
    UILabel *tcLbl = [[UILabel alloc]initWithFrame:CGRectMake(5, 0,tcBaseView.frame.size.width, 40)];
    tcLbl.text = @"Terms and Conditions";
    tcLbl.textColor = [ICSingletonManager colorFromHexString:@"#bd9854"];
    tcLbl.font = [UIFont boldSystemFontOfSize:20];
    [tcBaseView addSubview:tcLbl];
    
    UIButton *crossBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //  [crossBtn setTitle:@"X" forState:UIControlStateNormal];
    [crossBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:24]];
    [crossBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    crossBtn.frame = CGRectMake(tcBaseView.frame.size.width - 50 , 5, 30, 30);
    [crossBtn addTarget:self action:@selector(crossBtnTc:) forControlEvents:UIControlEventTouchUpInside];
    [crossBtn setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [tcBaseView addSubview:crossBtn];
    
    UITextView *detailTxtView = [[UITextView alloc]initWithFrame:CGRectMake(5,tcBaseView.frame.origin.y + tcBaseView.frame.size.height + 5, _tcBaseView.frame.size.width - 10, self.tcBaseView.frame.size.height - 40 - 50 )];
    detailTxtView.text = @"1. By sharing your contacts with icanstay you are allowing us to send SMS to your friends.\n\n2. Your friend will become your referral only after he/she registers with icanstay with your referral code.\n\n3. The contact who is getting registered should be a new user.\n\n4. Your friend will also earn ₹1,000 icanCash after successful registration using your referral code.\n\n5. User can earn maximum ₹1 Lakh icanCash.\n\n6. icanCash can be used for buying vouchers & booking hotel in last minute deals on icanstay App, Website and Mobile site.\n\n7. icanCash is valid for 6 months from the date of its earning. It cannot be extended or claimed after expiry, icanCash can only be redeemed/used while purchasing Vouchers and Hotel Room Booking.\n\n8. This offer cannot be used in conjunction with any other offer.\n\n9. icanCash is non-transferable and non-extendable.\n\n10. By agreeing to all terms and conditions of icanstay’s referral program you can start earning icanCash and can redeem/use maximum ₹1,000 icanCash on your first purchase, ₹300 icanCash on subsequent purchases & ₹100 icanCash for Breakfast payments.\n\n11. icanstay holds the right to modify or withdraw the offer at any point in time without any prior notice.\n\n12. In case of any disputes, icanstay's decision will be final.";
    detailTxtView.textColor = [UIColor blackColor];
    detailTxtView.font = [UIFont systemFontOfSize:15];
    detailTxtView.scrollEnabled = YES;
    detailTxtView.editable = NO;
    detailTxtView.backgroundColor = [UIColor whiteColor];
    [_tcBaseView addSubview:detailTxtView];
    
    
    GradientButton *okBtn =  [[GradientButton alloc]init];
    okBtn.frame = CGRectMake((_tcBaseView.frame.size.width - 100)/2, detailTxtView.frame.size.height + detailTxtView.frame.origin.y + 10, 100, 30);
    [okBtn setTitle:@"OK" forState:UIControlStateNormal];
    [okBtn setTintColor:[UIColor blackColor]];
    [okBtn useRedDeleteStyle];
    [okBtn addTarget:self action:@selector(crossBtnTc:) forControlEvents:UIControlEventTouchUpInside];
    [_tcBaseView addSubview:okBtn];
    
    
    
}
//-(void)tcBaseViewDesign
//{
//    self.tcBaseView = [[UIView alloc]init];
//    self.tcBaseView.backgroundColor = [UIColor whiteColor];
//    self.tcBaseView.hidden = YES;
//
//    UIView *tcBaseView = [[UIView alloc]init];
//    tcBaseView.backgroundColor = [ICSingletonManager colorFromHexString:@"#001d3d"];
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//        self.tcBaseView.frame = CGRectMake((self.view.frame.size.width - 360)/2,self.topWhiteBaseView.frame.size.height + self.topWhiteBaseView.frame.origin.y , 360, 500);
//        tcBaseView.frame = CGRectMake(0, 0, self.tcBaseView.frame.size.width, 40);
//    }else{
//        self.tcBaseView.frame = CGRectMake(0, _topWhiteBaseView.frame.size.height + _topWhiteBaseView.frame.origin.y + 50 , self.view.frame.size.width , self.view.frame.size.height - (_topWhiteBaseView.frame.size.height + _topWhiteBaseView.frame.origin.y + 50));
//        tcBaseView.frame = CGRectMake(0, 0, self.tcBaseView.frame.size.width, 40);
//    }
//    [self.view addSubview:_tcBaseView];
//    [_tcBaseView addSubview:tcBaseView];
//
//    UILabel *tcLbl = [[UILabel alloc]initWithFrame:CGRectMake(5, 0,tcBaseView.frame.size.width, 40)];
//    tcLbl.text = @"Terms And Conditions";
//    tcLbl.textColor = [ICSingletonManager colorFromHexString:@"#bd9854"];
//    tcLbl.font = [UIFont boldSystemFontOfSize:20];
//    [tcBaseView addSubview:tcLbl];
//
//    UIButton *crossBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    //  [crossBtn setTitle:@"X" forState:UIControlStateNormal];
//    [crossBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:24]];
//    [crossBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    crossBtn.frame = CGRectMake(tcBaseView.frame.size.width - 50 , 5, 30, 30);
//    [crossBtn addTarget:self action:@selector(crossBtnTc:) forControlEvents:UIControlEventTouchUpInside];
//    [crossBtn setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
//    [tcBaseView addSubview:crossBtn];
//
//    UITextView *detailTxtView = [[UITextView alloc]initWithFrame:CGRectMake(5,tcBaseView.frame.origin.y + tcBaseView.frame.size.height + 5, _tcBaseView.frame.size.width - 10, 350)];
//    detailTxtView.text = @"1. Your friend will Register using your referral code or your phone number, you both will get 300 icanCash.\n\n""2. Refer to all your contacts & get 3,000 icanCash instantly."  "\n\n" "3. After your friend's successful transaction, you get 300 icanCash." "\n\n" "4. Each icanCash received will be valid for 6 months from the date of issue."  "\n\n" "5. You can earn unlimited icanCash." "\n\n" "6. You can use upto 300 icanCash on all your transaction." "\n\n"
//    "7. icanstay reserves the right to modify the offer at its own discretion.";
//    detailTxtView.textColor = [UIColor blackColor];
//    detailTxtView.font = [UIFont systemFontOfSize:18];
//    detailTxtView.scrollEnabled = YES;
//    detailTxtView.editable = NO;
//    detailTxtView.backgroundColor = [UIColor whiteColor];
//    [_tcBaseView addSubview:detailTxtView];
//
//
//    GradientButton *okBtn =  [[GradientButton alloc]init];
//    okBtn.frame = CGRectMake((_tcBaseView.frame.size.width - 100)/2, detailTxtView.frame.size.height + detailTxtView.frame.origin.y + 10, 100, 30);
//    [okBtn setTitle:@"Ok" forState:UIControlStateNormal];
//    [okBtn setTintColor:[UIColor blackColor]];
//    [okBtn useRedDeleteStyle];
//    [okBtn addTarget:self action:@selector(crossBtnTc:) forControlEvents:UIControlEventTouchUpInside];
//    [_tcBaseView addSubview:okBtn];
//
//
//
//}
-(void)crossBtnTc:(id)sender
{
    _tcBaseView.hidden = YES;
}

-(void)termsConditionButtonTapped:(id)sender
{
     _tcBaseView.hidden = NO;
}
-(void)registerNowTapped:(id)sender
{
    RegistrationScreen *registerScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"RegistrationScreen"];
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
    globals.registrationBackManage = @"NO";
    [self.navigationController pushViewController:registerScreen animated:YES];
}
-(void)logInNowTapped:(id)sender
{
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
    globals.isFromMenu = false;
    globals.userLoginFromReferAndEarn = @"YES";
    LoginScreen *vcLogin = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginScreen"];
    [self.navigationController pushViewController:vcLogin animated:YES];
}
-(void)backButtonTapped:(id)sender
{
    
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
  
    
    if ([globals.ReferAndEarnFromHome isEqualToString:@"NO"]) {
         [self.navigationController popViewControllerAnimated:YES];
    }else if([globals.ReferAndEarnFromHome isEqualToString:@"YES"]){
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    }
    
    
    
    // ICSingletonManager *globals = [ICSingletonManager sharedManager];
    
    
//    if ([globals.isFromMenuLastMinuteDeal isEqualToString:@"YES"]) {
//        globals.isFromMenuLastMinuteDeal = @"NO";
//        [self.navigationController popViewControllerAnimated:YES];
//    }else{
//        [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
//    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


@end
