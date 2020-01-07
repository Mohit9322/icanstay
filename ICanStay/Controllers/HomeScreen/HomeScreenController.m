//
//  HomeScreenController.m
//  ICanStay
//
//  Created by Namit Aggarwal on 23/02/16.
//  Copyright (c) 2016 Harry Patel (Hitaishin). All rights reserved.
//

#import "HomeScreenController.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"
#import "DashboardScreen.h"
#import "MBProgressHud.h"
#import "LoginManager.h"
#import "MapScreen.h"
#import "BuyCouponViewController.h"
#import "MakeAWishlistViewController.h"
#import "FaqScreen.h"
#import "NotificationScreen.h"
#import "CitiesViewController.h"
#import <Google/Analytics.h>
#import "AppDelegate.h"
#import "MyWishlistViewController.h"
#import "NotificationViewController.h"
#import "PackagesViewController.h"
#import "CCMPopupTransitioning.h"
#import <MoEngage.h>
#import "SideMenuController.h"
#import "LastMinuteViewController.h"
#import "FeedBackRatingView.h"
#import "SaleBuyVoucherVC.h"
#import "RegistrationScreen.h"
#import <Contacts/Contacts.h>
#import "NSDictionary+JsonString.h"
#import "ReferAndEarnVC.h"
#import "KRConfettiView.h"
#import "CancashController.h"
#import "ReferAndEarnUnregistered.h"
#import "ReferAndEarnWeb.h"
#import "BuyCouponNewViewController.h"
#import "GradientButton.h"
@interface HomeScreenController ()<UIWebViewDelegate,MOInAppDelegate, UIAlertViewDelegate>
{
    NSMutableArray  *arr_result;
    UILabel *bigLbl;
    UIView *baseView;
    UIImageView *ImageView;
    int width;
    int height;
    UIViewController *popupController;
    UIPopoverController *popOver;
    UIViewController *weblinkVc;
    NSArray *tempImageArray;
     NSMutableArray                 *arrayOfContacts;
      KRConfettiView *confettiView;
    int firstTimeManageReg;
    UIView *alertContactPopup;
}
- (IBAction)btnMenuTapped:(id)sender;
- (IBAction)btnLoginTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scroolView;
@property (weak, nonatomic) IBOutlet UIView *bottomBaseView;
@property (nonatomic, strong)  UIView *icsCashBaseView;
@property (weak, nonatomic) IBOutlet UIView *viewBottom;
- (IBAction)btnGetStartedTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewGetStarted;
- (IBAction)btnPlanYourStayTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet KIImagePager *imagePager;
@property (strong, nonatomic) IBOutlet UIButton *btnSearchyour;
@property (weak, nonatomic) IBOutlet UIView *logoImageBaseView;
@property (nonatomic, strong) UIView         *contactSyncPopupBaseView;
- (IBAction)btnSearchYourStayTapped:(id)sender;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *searchyourstayHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *makeWishHeisht;
@property (nonatomic, strong) UIImageView *previewImage;
@property (nonatomic, strong) UIImageView *logoImgView;
@property  (nonatomic, strong) UIView *popupView;
@property (nonatomic, strong)  UILabel *pleaseWaitLbl;
// Webview Object for show youtube video

@property (strong, nonatomic) IBOutlet UIWebView *webview;
@property (strong, nonatomic) IBOutlet UIButton *flagBuyNowBtn;
@property (nonatomic, strong) UIView         *topWhiteBaseView;
@property (nonatomic, strong) UIWebView      *packageWebView;
@property (nonatomic, strong) UIButton       *backButton;
@property (nonatomic, strong) UIButton       *notificationButton;
@property (nonatomic, strong) UIImageView    *logoIconImgView;
@property(nonatomic)          BOOL            pageLoaded;
@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) IBOutlet UIImageView *ReferAndEarnHome;
@property (strong, nonatomic) UIView  *contactSharingBaseView;
@property BOOL firstTimeHomeScreenLoad;

@end

@implementation HomeScreenController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    arrayOfContacts = [[NSMutableArray alloc]init];
    AppDelegate *delegate =   (AppDelegate *)[[UIApplication sharedApplication] delegate];
   delegate.fromPageScrollController  = @"YES";
    
    [[MoEngage sharedInstance]handleInAppMessage];
    [MoEngage sharedInstance].delegate = self;
    [[MoEngage sharedInstance] dontShowInAppInViewController:self];
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
  
    firstTimeManageReg = 0;
   if ([globals.firstTimeGifImageLoader isEqualToString:@""]) {
       
    self.view.backgroundColor = [UIColor whiteColor];
    self.scroolView.hidden = YES;
    self.bottomBaseView.hidden = YES;
    self.viewBottom.hidden = YES;
    self.viewGetStarted.hidden = YES;
    self.btnLogin.hidden = YES;
    self.imagePager.hidden = YES;
    self.btnSearchyour.hidden = YES;
    self.logoImageBaseView.hidden = YES;
    
    [self setupGifImage];
       globals.firstTimeGifImageLoader = @"YES";
       
         }
    
     DLog(@"DEBUG-VC");
   
    
    self.firstTimeHomeScreenLoad = false;
//    globals.isFirstTimeFromPageScrollController = false;
    // Do any additional setup after loading the view.
    if (self.view.frame.size.width < 768) {
        CGFloat spacing = 10; // the amount of spacing to appear between image and title
        _btnSearchyour.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 0, spacing);
        _btnSearchyour.titleEdgeInsets = UIEdgeInsetsMake(0, spacing+15, 0, 0);
    }
    else{
        CGFloat spacing = 10; // the amount of spacing to appear between image and title
        _btnSearchyour.imageEdgeInsets = UIEdgeInsetsMake(0, 30, 0, spacing);
        _btnSearchyour.titleEdgeInsets = UIEdgeInsetsMake(0, spacing+30, 0, 0);
    }
    
    
    [[NSNotificationCenter defaultCenter ]addObserver:self selector:@selector(pushToDashBoardScreenAfterLoggingIn) name:kSwitchToDashBoardScreen object:nil];
    // Get Slider Images from Server
    
  
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    [tracker set:kGAIScreenName value:@"Home"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    _imagePager.pageControl.currentPageIndicatorTintColor = [UIColor lightGrayColor];
    _imagePager.pageControl.pageIndicatorTintColor = [UIColor blackColor];
    _imagePager.slideshowTimeInterval = 5.5f;
    _imagePager.backgroundColor = [ICSingletonManager colorFromHexString:@"#001d3d"];
    
 //   _imagePager.slideshowShouldCallScrollToDelegate = YES;
    
    baseView = [[UIView alloc]init];
    baseView.backgroundColor = [self colorWithHexString:@"AE8743"];
    [_bottomBaseView addSubview:baseView];
    ImageView = [[UIImageView alloc]init];
    ImageView.backgroundColor = [UIColor clearColor];
    [baseView addSubview:ImageView];
    
    bigLbl = [[UILabel alloc]init];
    bigLbl.text = @"We are not a regular hotel or vacation booking site. We wish to fulfill aspiration of millions of Indians to stay in a Luxury Hotel.";
    bigLbl.lineBreakMode = NSLineBreakByWordWrapping;
    bigLbl.font = [UIFont systemFontOfSize:17];
    
    bigLbl.textColor = [UIColor whiteColor];
    [_bottomBaseView addSubview:bigLbl];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        baseView.frame = CGRectMake(0, 395, self.view.frame.size.width , 205);
        ImageView.image = [UIImage imageNamed:@"BottomImageIpad"];
        ImageView.contentMode = UIViewContentModeScaleAspectFit;
        ImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        ImageView.frame = CGRectMake(5, 0, baseView.frame.size.width - 10 , 205);
        bigLbl.frame = CGRectMake(5, 600, self.view.frame.size.width - 10, 85);
        bigLbl.numberOfLines = 2;
        bigLbl.textAlignment = NSTextAlignmentCenter;
        bigLbl.adjustsFontSizeToFitWidth = YES;
          self.ReferAndEarnHome.image = [UIImage imageNamed:@"ReferAndEarnHomeIpad"];
        
    }else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        ImageView.image = [UIImage imageNamed:@"OrangeImageHomeScreen"];
        baseView.frame = CGRectMake(0, 293, self.view.frame.size.width , 205);
        ImageView.contentMode = UIViewContentModeScaleAspectFit;
        ImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        ImageView.frame = CGRectMake(4, 0, baseView.frame.size.width -8  , 205);
        bigLbl.frame = CGRectMake(5, 493, self.view.frame.size.width - 10, 150);
        bigLbl.numberOfLines = 3;
        bigLbl.textAlignment = NSTextAlignmentCenter;
        bigLbl.adjustsFontSizeToFitWidth = YES;
        bigLbl.font = [UIFont systemFontOfSize:15];
          self.ReferAndEarnHome.image = [UIImage imageNamed:@"ReferAndEarnHome"];
    }
 //   [self getHotelImageList];
    
    self.webview.tag = 1;
//    [self getFlagManageBuyNowBtn];
    
    LoginManager *loginManage = [[LoginManager alloc]init];
    NSDictionary *dict = [loginManage isUserLoggedIn];
    if ([dict count]>0)
    {
        
        [self checkUserBuyVoucher];
        
    }else{
        if (!globals.isFirstTimeImageDownloadAndVideoUrl) {
            
           
            [self getVideoUrl];
        }else if (globals.isFirstTimeImageDownloadAndVideoUrl){
            
         
            
            ICSingletonManager *globals = [ICSingletonManager sharedManager];
            NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",globals.youtubeVideoUrl]]];
            [_webview loadRequest:request];
       //     [_flagBuyNowBtn setTitle:[globals.btnTextFroHomeScreenArr objectAtIndex:0] forState:UIControlStateNormal];
           
            NSString *htmlStr = [ICSingletonManager getStringValue:[NSString stringWithFormat:@"%@",[globals.htmlTxtArrForHomeScreen objectAtIndex:0]]];
            [self.imagePager.webView loadHTMLString:htmlStr baseURL:nil];
              [self.imagePager reloadData];
            
        }
        
    }
    
    //imageArray = @[[UIImage imageNamed:@"b1"],[UIImage imageNamed:@"b2"],[UIImage imageNamed:@"b3"],[UIImage imageNamed:@"b4"]];
    [self addBottomBar];
//  [self icsCashPopUp];
    if ( [globals.isFromRegisteredNewUser isEqualToString:@"YES"]) {
         [self icsCashPopUp];
       
        [self startServiceToGeticanCash];
       //   [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"User Registered Successfully." onController:self];
        globals.isFromRegisteredNewUser = @"NO";
    }
    
    self.bottomBaseView.backgroundColor = [ICSingletonManager colorFromHexString:@"#001d3d"];
    self.bottomView.backgroundColor = [ICSingletonManager colorFromHexString:@"#001d3d"];
  
    self.ReferAndEarnHome.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapReferAndEarn = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(referAndEarnTapped:)];
    [self.ReferAndEarnHome addGestureRecognizer:tapReferAndEarn];
    
       [self createContactSharingPopup];
     [self ContactSyncPOpup];
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // the user clicked OK
    if (buttonIndex == 0) {
        NSLog(@"Button Tapped");
        
    }else if (buttonIndex == 1){
         [alertView setHidden:YES];
        
    }
}

-(void)referAndEarnTapped:(UIGestureRecognizer *)referTapGesture
{
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
    globals.FirstTimeAppLoginOrRegister = @"YES";
    
    LoginManager *loginManage = [[LoginManager alloc]init];
    NSDictionary *dict = [loginManage isUserLoggedIn];
    if ([dict count]>0)
    {
        ICSingletonManager *globals = [ICSingletonManager sharedManager];
        ReferAndEarnVC *refer = [self.storyboard instantiateViewControllerWithIdentifier:@"ReferAndEarnVC"];
        
        globals.isFromMenuLastMinuteDeal = @"YES";
        
        [self.navigationController pushViewController:refer animated:YES];
    }else{
        
        ReferAndEarnUnregistered *refer = [self.storyboard instantiateViewControllerWithIdentifier:@"ReferAndEarnUnregistered"];
        ICSingletonManager *globals = [ICSingletonManager sharedManager];
        globals.ReferAndEarnFromHome = @"NO";
        [self.navigationController pushViewController:refer animated:YES];
    }
}
-(void)icsCashPopUp
{
    self.icsCashBaseView = [[UIView alloc]init];
    self.icsCashBaseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.icsCashBaseView];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
       self.icsCashBaseView.frame = CGRectMake((self.view.frame.size.width - 300)/2, (self.view.frame.size.height -540)/2, 350, 450);
    }else{
         self.icsCashBaseView.frame = CGRectMake(0, 0, self.view.frame.size.width ,self.view.frame.size.height);
    }
    
   
    confettiView = [[KRConfettiView alloc] initWithFrame:CGRectMake(0, 0, _icsCashBaseView.frame.size.width, _icsCashBaseView.frame.size.height)];
    
    // Set colors (default colors are red, green and blue)
    confettiView.colours = @[[ICSingletonManager colorFromHexString:@"#001d3d"],
                             [ICSingletonManager colorFromHexString:@"#bd9854"],
                             [UIColor whiteColor]];
    
    //Set intensity (from 0 - 1, default intensity is 0.5)
    confettiView.intensity = 0.3;
    
    //set type
    confettiView.type = Diamond;
    
    
    [confettiView startConfetti];
    confettiView.userInteractionEnabled = YES;
    confettiView.layer.masksToBounds = YES;
    [self performSelector:@selector(subscribe) withObject:self afterDelay:10.0 ];
    [self.icsCashBaseView addSubview:confettiView];
    
    UILabel *referAndEarnLbl = [[UILabel alloc]init];
    referAndEarnLbl.backgroundColor = [ICSingletonManager colorFromHexString:@"#808080"];
    referAndEarnLbl.text = @"Refer & Earn";
    referAndEarnLbl.textColor = [UIColor whiteColor];
    referAndEarnLbl.textAlignment = NSTextAlignmentCenter;
    referAndEarnLbl.font = [UIFont boldSystemFontOfSize:40];
    [_icsCashBaseView addSubview:referAndEarnLbl];
    
    UIImageView *giftImgView = [[UIImageView alloc]init];
    giftImgView.image = [UIImage imageNamed:@"giftImg"];
    [_icsCashBaseView addSubview:giftImgView];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [cancelBtn setTitle:@"X" forState:UIControlStateNormal];
    [cancelBtn setTintColor:[UIColor blackColor]];
    [cancelBtn addTarget:self action:@selector(icsCashCancelButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:30]];
    [_icsCashBaseView addSubview:cancelBtn];
    
    UILabel *congrtasLbl = [[UILabel alloc]init];
    congrtasLbl.textColor = [UIColor blackColor];
   
    congrtasLbl.adjustsFontSizeToFitWidth = YES;
    congrtasLbl.font = [UIFont boldSystemFontOfSize:18];
    congrtasLbl.textAlignment = NSTextAlignmentCenter;
    congrtasLbl.textColor = [ICSingletonManager colorFromHexString:@"#808080"];
    [_icsCashBaseView addSubview:congrtasLbl];
    
//    ICSingletonManager *globals = [ICSingletonManager sharedManager];
//    globals.referralCode = self.refferalCodeTxtFld.text;
//    if ([globals.referralCode isEqualToString:@""]) {
//         congrtasLbl.text = @"Congratulations! You got 300 icanCash.";
//    }else{
//         congrtasLbl.text = @"Congratulations! You got 1000 icanCash.";
//    }
     congrtasLbl.text = @"Congratulations!";
  
    UILabel *canCashLbl = [[UILabel alloc]init];
    canCashLbl.textColor = [UIColor blackColor];
     canCashLbl.text = @"You got  ₹1,000 icanCash";
    canCashLbl.adjustsFontSizeToFitWidth = YES;
    canCashLbl.font = [UIFont boldSystemFontOfSize:18];
    canCashLbl.textAlignment = NSTextAlignmentCenter;
    canCashLbl.textColor = [ICSingletonManager colorFromHexString:@"#bd9854"];
    [_icsCashBaseView addSubview:canCashLbl];
    
    UITextView *additionalLbl = [[UITextView alloc]init];
    additionalLbl.text = @"Refer icanstay to your friends and earn ₹5,000 icanCash.";
    additionalLbl.font = [UIFont systemFontOfSize:18];
    additionalLbl.textAlignment = NSTextAlignmentCenter;
    additionalLbl.editable = NO;
    additionalLbl.scrollEnabled = NO;
    additionalLbl.textColor = [ICSingletonManager colorFromHexString:@"#808080"];
    [_icsCashBaseView addSubview:additionalLbl];
    
    UILabel *addLbl = [[UILabel alloc]init];
    addLbl.textColor = [UIColor blackColor];
    addLbl.text = @"In addition, you also earn";
    addLbl.adjustsFontSizeToFitWidth = YES;
    addLbl.font = [UIFont systemFontOfSize:18];
    addLbl.textAlignment = NSTextAlignmentLeft;
    addLbl.textColor = [ICSingletonManager colorFromHexString:@"#808080"];
    [_icsCashBaseView addSubview:addLbl];
    
    UIWebView *webView = [[UIWebView alloc]init];
    
    NSString *htmlString = @"<html><head><style>ul{list-style:none;padding: 1px 0px 0px 0px; }ul li {background-image: url(http://www.icanstay.com/Content/Home/images/rev-slider/dot.png);  background-repeat: no-repeat; background-position: 0 0px; padding: 0px 10px 12px 18px; background-size: 13px;font-size: 15px; color:#808080; line-height: 17px;}</style></head><body><ul><li>₹2,000 icanCash every time your friend registers with your referral code.</li><li>₹1,000 icanCash on every purchase your friend makes.</li><li>₹1,000 Cashback on every purchase.</li></ul></body></html>";
    
    [webView loadHTMLString:[NSString stringWithFormat:@"%@", htmlString ]baseURL:nil];
    webView.scrollView.scrollEnabled = NO;
    [_icsCashBaseView addSubview:webView];
    
    UIView *shareNowBaseView = [[UIView alloc]init];
    shareNowBaseView.backgroundColor = [UIColor whiteColor];
    [_icsCashBaseView addSubview:shareNowBaseView];
    
    UIButton *shareNowBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [shareNowBtn setTitle:@"Start Sharing" forState:UIControlStateNormal];
    [shareNowBtn setTitleColor:[ICSingletonManager colorFromHexString:@"#808080"] forState:UIControlStateNormal];
    [shareNowBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
     [shareNowBtn setTintColor:[ICSingletonManager colorFromHexString:@"#808080"]];
    [shareNowBtn addTarget:self action:@selector(shareNowBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [shareNowBaseView addSubview:shareNowBtn];
    
    UIView *narrowLineView = [[UIView alloc]init];
    narrowLineView.backgroundColor = [ICSingletonManager colorFromHexString:@"#808080"];
    [shareNowBaseView addSubview:narrowLineView];
    
    
    UILabel *getEverytimeLbl = [[UILabel alloc]init];
    getEverytimeLbl.textColor = [UIColor grayColor];
    getEverytimeLbl.text = @"Get ₹1000 icanCash, for every\n friends who registers on icanstay.";
    getEverytimeLbl.font = [UIFont systemFontOfSize:14];
    getEverytimeLbl.textAlignment = NSTextAlignmentCenter;
 //   [_icsCashBaseView addSubview:getEverytimeLbl];
    
    UIButton *icanCashWorkButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [icanCashWorkButton setTitle:@"How icanCash works" forState:UIControlStateNormal];
    [icanCashWorkButton addTarget:self action:@selector(howicanCashBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [icanCashWorkButton setTintColor:[ICSingletonManager colorFromHexString:@"#808080"]];
    [icanCashWorkButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
  
    icanCashWorkButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_icsCashBaseView addSubview:icanCashWorkButton];
    
    UIButton *balanceButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [balanceButton setTitle:@"View My Balance" forState:UIControlStateNormal];
    [balanceButton addTarget:self action:@selector(balanceButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [balanceButton setTintColor:[ICSingletonManager colorFromHexString:@"#808080"]];
    [balanceButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [_icsCashBaseView addSubview:balanceButton];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
       
        referAndEarnLbl.frame = CGRectMake(0, 0, self.icsCashBaseView.frame.size.width, 0);
        cancelBtn.frame = CGRectMake(self.icsCashBaseView.frame.size.width - 60, referAndEarnLbl.frame.size.height + referAndEarnLbl.frame.origin.y +15, 40, 40);
        giftImgView.frame = CGRectMake((self.icsCashBaseView.frame.size.width - 100)/2,referAndEarnLbl.frame.origin.y + referAndEarnLbl.frame.size.height +15 ,100, 100);
        congrtasLbl.frame = CGRectMake(10, giftImgView.frame.size.height + giftImgView.frame.origin.y + 10,self.icsCashBaseView.frame.size.width - 20 , 50);
        congrtasLbl.lineBreakMode = NSLineBreakByWordWrapping;
        congrtasLbl.numberOfLines = 2;
        
        additionalLbl.frame = CGRectMake(10,congrtasLbl.frame.size.height + congrtasLbl.frame.origin.y + 5 , self.icsCashBaseView.frame.size.width - 20, 60);
        webView.frame = CGRectMake(20,additionalLbl.frame.size.height + additionalLbl.frame.origin.y + 5 , self.icsCashBaseView.frame.size.width - 40, 110);
        shareNowBaseView.frame = CGRectMake((_icsCashBaseView.frame.size.width - 160)/2,webView.frame.size.height + webView.frame.origin.y + 5 , 160, 30);
        shareNowBtn.frame = CGRectMake(0, 0, 160, 20);
        narrowLineView.frame = CGRectMake(0, 20, 160, 1);
        icanCashWorkButton.frame = CGRectMake(10, shareNowBaseView.frame.size.height + shareNowBaseView.frame.origin.y + 10, 140, 50);
        balanceButton.frame = CGRectMake(self.icsCashBaseView.frame.size.width - 150,shareNowBaseView.frame.size.height + shareNowBaseView.frame.origin.y + 10 , 140,30);
   
    }else{
        
        referAndEarnLbl.frame = CGRectMake(0, 0, self.icsCashBaseView.frame.size.width, 0);
        cancelBtn.frame = CGRectMake(self.icsCashBaseView.frame.size.width - 60, referAndEarnLbl.frame.size.height + referAndEarnLbl.frame.origin.y + 30, 40, 40);
      giftImgView.frame = CGRectMake((self.icsCashBaseView.frame.size.width - 100)/2,35 ,100, 100);
        congrtasLbl.frame = CGRectMake(10, giftImgView.frame.size.height + giftImgView.frame.origin.y + 20,self.icsCashBaseView.frame.size.width - 20 , 30);
        congrtasLbl.lineBreakMode = NSLineBreakByWordWrapping;
        congrtasLbl.numberOfLines = 1;
        canCashLbl.frame = CGRectMake(10, congrtasLbl.frame.size.height + congrtasLbl.frame.origin.y,self.icsCashBaseView.frame.size.width - 20 , 30);
        canCashLbl.lineBreakMode = NSLineBreakByWordWrapping;
        canCashLbl.numberOfLines = 1;
       
        additionalLbl.frame = CGRectMake(10,canCashLbl.frame.size.height + canCashLbl.frame.origin.y + 20 , self.icsCashBaseView.frame.size.width - 20, 60);
        addLbl.frame = CGRectMake(20,additionalLbl.frame.size.height + additionalLbl.frame.origin.y  , self.icsCashBaseView.frame.size.width - 40, 30);
        webView.frame = CGRectMake(20,addLbl.frame.size.height + addLbl.frame.origin.y  , self.icsCashBaseView.frame.size.width - 40, 150);
        shareNowBaseView.frame = CGRectMake((_icsCashBaseView.frame.size.width - 120)/2,webView.frame.size.height + webView.frame.origin.y + 30 , 130, 30);
        shareNowBtn.frame = CGRectMake(0, 0, 120, 20);
        narrowLineView.frame = CGRectMake(0, 20, 120, 1);
        icanCashWorkButton.frame = CGRectMake(10, self.icsCashBaseView.frame.size.height - 50, 150, 30);
        balanceButton.frame = CGRectMake(self.icsCashBaseView.frame.size.width - 150,self.icsCashBaseView.frame.size.height - 50, 150,30);
    }
    [self createShareContactPopup];
   
    
}
-(void)createShareContactPopup
{
    alertContactPopup = [[UIView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 200)/2, (self.view.frame.size.height - 150 )/2, 200, 150)];
    alertContactPopup.backgroundColor = [UIColor redColor];
//    [self.view addSubview:alertContactPopup];
    
    UILabel *canCashLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, alertContactPopup.frame.size.width, 60)];
    canCashLbl.text = @"Share Contacts & Earn ₹5,000 icanCash";
    canCashLbl.numberOfLines = 2;
    canCashLbl.lineBreakMode = NSLineBreakByWordWrapping;
    canCashLbl.font = [UIFont systemFontOfSize:18];
    [alertContactPopup addSubview:canCashLbl];
    
    UIButton *dontAllowBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [dontAllowBtn setTitle:@"DON'T ALLOW" forState:UIControlStateNormal];
    dontAllowBtn.frame = CGRectMake(0, canCashLbl.frame.origin.y + canCashLbl.frame.size.height + 10, (alertContactPopup.frame.size.width - 2)/2, 40);
    [dontAllowBtn addTarget:self action:@selector(dontallowBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [alertContactPopup addSubview:dontAllowBtn];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(dontAllowBtn.frame.origin.x + dontAllowBtn.frame.size.width + 10,canCashLbl.frame.origin.y + canCashLbl.frame.size.height + 10 , 2, 40)];
    lineView.backgroundColor = [UIColor blackColor];
    [alertContactPopup addSubview:lineView];
  
    UIButton *AllowBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [AllowBtn setTitle:@"ALLOW" forState:UIControlStateNormal];
    AllowBtn.frame = CGRectMake(0, canCashLbl.frame.origin.y + canCashLbl.frame.size.height + 10, (alertContactPopup.frame.size.width - 2)/2, 40);
    [AllowBtn addTarget:self action:@selector(allowBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [alertContactPopup addSubview:AllowBtn];
  
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"Share Contacts & Earn ₹5,000 icanCash" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *allowAction = [UIAlertAction actionWithTitle:@"ALLOW" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        [self allowBtnTapped];
        // Enter code here
    }];
    
    UIAlertAction *dontAllowAction = [UIAlertAction actionWithTitle:@"DON'T ALLOW" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        // Enter code here
        [self dontallowBtnTapped];
    }];
    [alert addAction:allowAction];
     [alert addAction:dontAllowAction];
    
    // Present action where needed
    [self presentViewController:alert animated:YES completion:nil];
    }];
    
}
-(void)allowBtnTapped
{
    [self shareContact];
    self.icsCashBaseView.hidden = YES;
    self.contactSyncPopupBaseView.hidden = YES;
    LoginManager *loginManage = [[LoginManager alloc]init];
    NSDictionary *dict = [loginManage isUserLoggedIn];
    if ([dict count]>0)
    {
        ICSingletonManager *globals = [ICSingletonManager sharedManager];
        ReferAndEarnVC *refer = [self.storyboard instantiateViewControllerWithIdentifier:@"ReferAndEarnVC"];
        refer.fromAllowContactPopup = @"YES";
        globals.isFromMenuLastMinuteDeal = @"YES";
        globals.contactSyncOrNot = @"YES";
        
        
        [self.navigationController pushViewController:refer animated:YES];
    }
}
-(void)dontallowBtnTapped
{
    LoginManager *loginManage = [[LoginManager alloc]init];
    NSDictionary *dict = [loginManage isUserLoggedIn];
    self.icsCashBaseView.hidden = YES;
    self.contactSyncPopupBaseView.hidden = YES;
    if ([dict count]>0)
    {
        ICSingletonManager *globals = [ICSingletonManager sharedManager];
        ReferAndEarnVC *refer = [self.storyboard instantiateViewControllerWithIdentifier:@"ReferAndEarnVC"];
        refer.fromAllowContactPopup = @"NO";
        globals.isFromMenuLastMinuteDeal = @"YES";
        globals.contactSyncOrNot = @"NO";
        
        [self.navigationController pushViewController:refer animated:YES];
    }
}
-(void)shareContact
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        CNContactStore *store = [[CNContactStore alloc] init];
        [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted == YES)
            {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    //Your main thread code goes in here
//                    self.contactSyncPopupBaseView.hidden = NO;
//                });
                
                NSArray *keys = @[CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPhoneNumbersKey, CNContactImageDataKey,CNContactEmailAddressesKey];
                NSString *containerId = store.defaultContainerIdentifier;
                NSPredicate *predicate = [CNContact predicateForContactsInContainerWithIdentifier:containerId];
                NSError *error;
                NSArray *cnContacts = [store unifiedContactsMatchingPredicate:predicate keysToFetch:keys error:&error];
                if (error)
                {
                    NSLog(@"error fetching contacts %@", error);
                }
                else
                {
                    
                    for (CNContact *contact in cnContacts) {
                        NSString *fullName;
                        NSString *firstName;
                        NSString *lastName;
                        NSString *phone1;
                        NSString *phone2;
                        NSString *phone3;
                        NSString *email1;
                        NSString *email2;
                        NSString *email3;
                        NSMutableArray *phoneArray = [[NSMutableArray alloc]init];
                        NSMutableArray *emailArray = [[NSMutableArray alloc]init];
                        
                        // copy data to my custom Contacts class.
                        firstName = contact.givenName;
                        lastName = contact.familyName;
                        
                        
                        if (lastName == nil) {
                            fullName=[NSString stringWithFormat:@"%@",firstName];
                        }else if (firstName == nil){
                            fullName=[NSString stringWithFormat:@"%@",lastName];
                        }
                        else{
                            fullName=[NSString stringWithFormat:@"%@ %@",firstName,lastName];
                        }
                        for (CNLabeledValue *label in contact.phoneNumbers) {
                            
                            [phoneArray addObject:[label.value stringValue]];
                        }
                        NSLog(@"email = %@", contact.emailAddresses);
                        for (CNLabeledValue<NSString*> *email in contact.emailAddresses) {
                            [emailArray addObject:email.value ];
                            
                        }
                        for (int i = 0; i<3; i++) {
                            if (i== 0) {
                                if (phoneArray.count >= 1) {
                                    phone1 = [phoneArray objectAtIndex:i];
                                    
                                }else{
                                    phone1 = @"";
                                    
                                }
                                if (emailArray.count >= 1) {
                                    email1 = [emailArray objectAtIndex:i];
                                }else{
                                    email1 = @"";
                                }
                            }
                            
                            if (i== 1) {
                                if (phoneArray.count >= 2) {
                                    phone2 = [phoneArray objectAtIndex:i];
                                }else{
                                    phone2 = @"";
                                    
                                }
                                if ( emailArray.count >= 2) {
                                    email2 = [emailArray objectAtIndex:i];
                                }else{
                                    email2 = @"";
                                    
                                }
                                
                                
                            }
                            
                            if (i== 2) {
                                if (phoneArray.count >= 3) {
                                    phone3 = [phoneArray objectAtIndex:i];
                                }else{
                                    phone3 = @"";
                                    
                                }
                                if (emailArray.count >= 3) {
                                    email3 = [emailArray objectAtIndex:i];
                                }else{
                                    email3 = @"";
                                    
                                }
                                
                                
                            }
                            
                        }
                        NSDictionary* contactDict = [[NSDictionary alloc] initWithObjectsAndKeys: fullName,@"FullName",email1,@"Email1",email2,@"Email2",email3,@"Email3", phone1,@"Phone1",phone2,@"Phone2",phone3,@"Phone3", nil];
                        [arrayOfContacts addObject:contactDict];
                        
                    }
                    
                }
                
                NSDictionary *dictEx =  @{@"Email1":@"hkdhsddsk@gmail.com",
                                          @"Email2":@"",
                                          @"FullName":@"fdfdf",
                                          @"Email3":@"",
                                          @"Phone1":@"9898898989",
                                          @"Phone2":@"",
                                          @"Phone3":@"",
                                          };
                NSArray *arraEx = [[NSArray alloc]initWithObjects:dictEx, nil];
                NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:arrayOfContacts, @"AppContacts",nil];
                
                
                //      NSString *strParam = [dict jsonStringWithPrettyPrint:YES];
                
                LoginManager *loginManage = [[LoginManager alloc]init];
                NSDictionary *dict2 = [loginManage isUserLoggedIn];
                if ([dict2 count]>0)
                {
                    [dict2 valueForKey:@"Phone1"];
                }
                NSString *strUrl = [NSString stringWithFormat:@"%@/api/AppMarketingContacts/AddEditAppMarketingContactsApi2?ReferenceNo=%@",kServerUrl,[dict2 valueForKey:@"Phone1"]];
                NSLog(@"%@",strUrl);
                
                NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                                initWithURL:[NSURL URLWithString:strUrl]
                                                cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                timeoutInterval:120.0f];
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                                   options:NSJSONWritingPrettyPrinted
                                                                     error:&error];
                NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                NSLog(@"%@", jsonString);
                
                [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                [request setHTTPMethod:@"POST"];
                [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
                
                //      NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[jsonData length]];
                //    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
                [request setHTTPBody:jsonData];
                [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
                 {
                     if (!connectionError)
                     {
                         NSLog(@"response--%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                         NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers error: nil];
                         NSString *status = [responseObject valueForKey:@"status"];
                         NSString *msg = [responseObject valueForKey:@"errorMessage"];
                         if ([status isEqualToString:@"SUCCESS"]) {
                            self.contactSyncPopupBaseView.hidden = YES;
//                             shareContactsButton.hidden = YES;
//                             shareContactsNarrowLine.hidden = YES;
                            self.icsCashBaseView.hidden  = YES;
                             
//                             noThanksBtn.hidden = YES;
//                             noThanksNarrowLineView.hidden = YES;
                             LoginManager *loginManage = [[LoginManager alloc]init];
                             NSDictionary *dict = [loginManage isUserLoggedIn];
                             NSString *userName = [NSString stringWithFormat:@"%@ %@", [dict objectForKey:@"FirstName"], [dict objectForKey:@"LastName"]];
                             
                             
                             /****************** Mo Engage *******************/
                             NSMutableDictionary *purchaseDict = [NSMutableDictionary dictionaryWithDictionary:@{@"Mobile No": [dict objectForKey:@"Phone1"],@"Email":[dict objectForKey:@"Email"], @"Name": userName }];
                             
                             
                             [[MoEngage sharedInstance]trackEvent:@"App Contact Sync IOS" andPayload:purchaseDict];
                             [[MoEngage sharedInstance] syncNow];
                             [MoEngage debug:LOG_ALL];
                             [self startServiceToGeticanCash];
                         }else{
                            self.contactSyncPopupBaseView.hidden = YES;
                             //     shareContactsButton.hidden = YES;
                             //     shareContactsNarrowLine.hidden = YES;
                             [[ICSingletonManager sharedManager] showAlertViewWithMsg:@"Some Error Occured" onController:self];
                            self.icsCashBaseView.hidden  = YES;
                             [self startServiceToGeticanCash];
                         }
                         
                         NSLog(@"%@", connectionError.localizedDescription);
                     }
                     else
                     {
                         NSLog(@"error--%@",connectionError);
                         [[ICSingletonManager sharedManager] showAlertViewWithMsg:connectionError.localizedDescription onController:self];
                         
                         [MBProgressHUD hideHUDForView:self.view animated:YES];
                     }
                 }];
            }else{
                NSLog(@"Contact sync permission not allowed");
            }
            
            
            
        }];
        
    });
    
}


-(void)howicanCashBtnTapped:(id)sender
{
    ReferAndEarnWeb *referAndEarnController = [self.storyboard instantiateViewControllerWithIdentifier:@"ReferAndEarnWeb"];
    
    [self.navigationController pushViewController:referAndEarnController animated:YES];
}

-(void)balanceButtonTapped:(id)sender
{
    
    CancashController *CancashController = [self.storyboard instantiateViewControllerWithIdentifier:@"CancashController"];
    [self.mm_drawerController setCenterViewController:CancashController withCloseAnimation:YES completion:nil];
    
//    _icsCashBaseView.hidden = YES;
//    ICSingletonManager *globals = [ICSingletonManager sharedManager];
//    CancashController *CancashController = [self.storyboard instantiateViewControllerWithIdentifier:@"CancashController"];
//
//
//    globals.canCashFromRefer = @"YES";
//
//    [self.navigationController pushViewController:CancashController animated:YES];
    
}
-(void)subscribe
{
     [confettiView stopConfetti];
}
-(void)shareNowBtnTapped:(id)sender
{
    
//      ICSingletonManager *globals = [ICSingletonManager sharedManager];
//        ReferAndEarnVC *refer = [self.storyboard instantiateViewControllerWithIdentifier:@"ReferAndEarnVC"];
//
//        globals.isFromMenuLastMinuteDeal = @"YES";
//
//        [self.navigationController pushViewController:refer animated:YES];
//     _icsCashBaseView.hidden = YES;
    
    [self shareContact];
    self.icsCashBaseView.hidden = NO;
    LoginManager *loginManage = [[LoginManager alloc]init];
    NSDictionary *dict = [loginManage isUserLoggedIn];
    if ([dict count]>0)
    {
        ICSingletonManager *globals = [ICSingletonManager sharedManager];
        ReferAndEarnVC *refer = [self.storyboard instantiateViewControllerWithIdentifier:@"ReferAndEarnVC"];
        refer.fromAllowContactPopup = @"YES";
        globals.isFromMenuLastMinuteDeal = @"YES";
        globals.contactSyncOrNot = @"YES";
        
        [self.navigationController pushViewController:refer animated:YES];
    }
    self.contactSyncPopupBaseView.hidden = NO;
}
-(void)icsCashCancelButtonTapped:(id)sender
{
     _icsCashBaseView.hidden = YES;
}
//- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
//    // the user clicked OK
//    if (buttonIndex == 0) {
//
//    }
//    if (buttonIndex == 1) {
//       [alertView setHidden:YES];
//
//
//
//    }
//}
-(void)designImageWebLinkController
{
    _pageLoaded = NO;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    
    
    self.packageWebView = [[UIWebView alloc] init];
    self.packageWebView.tag = 2;
//    NSString *url=@"https://www.icanstay.com/diwali-luxury-sale-start";
//    
//    NSURL *nsurl=[NSURL URLWithString:url];
    self.packageWebView.delegate = self;
 //   NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
//    [self.packageWebView loadRequest:nsrequest];
    self.packageWebView.scrollView.bounces = NO;
    self.packageWebView.delegate = self;
    [weblinkVc.view addSubview:self.packageWebView];
    
    
    
    self.topWhiteBaseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,screenRect.size.width , 64)];
    self.topWhiteBaseView.backgroundColor = [UIColor whiteColor];
    [weblinkVc.view addSubview:self.topWhiteBaseView];
    
    self.notificationButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.notificationButton.frame = CGRectMake(self.topWhiteBaseView.frame.size.width - 40 - 10, 20, 24, 24);
    [self.notificationButton setBackgroundImage:[UIImage imageNamed:@"notification1"] forState:UIControlStateNormal];
    [self.notificationButton addTarget:self action:@selector(notificationButtonTappedWebLink:) forControlEvents:UIControlEventTouchUpInside];
    [self.topWhiteBaseView addSubview:self.notificationButton];
    
    self.logoIconImgView = [[UIImageView alloc]initWithFrame:CGRectMake((self.topWhiteBaseView.frame.size.width - 150)/2, 15, 150, 34)];
    self.logoIconImgView.image = [UIImage imageNamed:@"topBanner"];
    [self.topWhiteBaseView addSubview:self.logoIconImgView];
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.backButton.frame = CGRectMake(20, 22, 30, 20);
    [self.backButton setBackgroundImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.topWhiteBaseView addSubview:self.backButton];
    
    self.packageWebView.frame = CGRectMake(0, self.topWhiteBaseView.frame.size.height + self.topWhiteBaseView.frame.origin.y , screenRect.size.width, screenRect.size.height - (self.topWhiteBaseView.frame.size.height + self.topWhiteBaseView.frame.origin.y) );
    
 

}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    int tagValue = webView.tag;
    NSString *tagVAlue = [NSString stringWithFormat:@"%d", tagValue];
    if ([tagVAlue isEqualToString:@"1"]) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
        
        [self LoadHomePageView];
       
        
        //    ICSingletonManager *globals = [ICSingletonManager sharedManager];
        
        
        //    if ([globals.isShowVersionUpdatePopup isEqualToString:@"YES"]) {
        //        if ([self needsUpdate]) {
        //            self.popupView.hidden = NO;
        //            [self popupDesign];
        //            self.popupView.hidden = NO;
        //       //     self.view.userInteractionEnabled              = NO;
        //            self.scroolView.userInteractionEnabled        = NO;
        //            self.bottomBaseView.userInteractionEnabled = NO;
        //            self.viewBottom.userInteractionEnabled = NO;
        //            self.viewGetStarted.userInteractionEnabled = NO;
        //            self.btnLogin.userInteractionEnabled = NO;
        //            self.imagePager.userInteractionEnabled = NO;
        //            self.btnSearchyour.userInteractionEnabled = NO;
        //            self.logoImageBaseView.userInteractionEnabled = NO;
        //
        //        }
        //    }else if ([globals.isShowVersionUpdatePopup isEqualToString:@"NO"]){
        //
        //        self.popupView.hidden = YES;
        //  //      [self popupDesign];
        //        self.popupView.hidden = YES;
        //        //     self.view.userInteractionEnabled              = NO;
        //        self.scroolView.userInteractionEnabled        = YES;
        //        self.bottomBaseView.userInteractionEnabled = YES;
        //        self.viewBottom.userInteractionEnabled = YES;
        //        self.viewGetStarted.userInteractionEnabled = YES;
        //        self.btnLogin.userInteractionEnabled = YES;
        //        self.imagePager.userInteractionEnabled = YES;
        //        self.btnSearchyour.userInteractionEnabled = YES;
        //        self.logoImageBaseView.userInteractionEnabled = YES;
        //    }

    }
    if ([tagVAlue isEqualToString:@"2"]) {
      [MBProgressHUD hideHUDForView:weblinkVc.view animated:YES];
        NSURL * currentURL = self.packageWebView.request.URL;
        NSLog(@"%@", currentURL);
        self.pageLoaded = YES;

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



-(void)notificationButtonTappedWebLink:(id)sender
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
- (IBAction)notificationButtonTapped:(id)sender
{
    LoginManager *login = [[LoginManager alloc]init];
    if ([[login isUserLoggedIn] count]>0)
    {
        ICSingletonManager *globals = [ICSingletonManager sharedManager];
        globals.isWithoutLoginNoti = false;
        NotificationScreen *notification = [self.storyboard instantiateViewControllerWithIdentifier:@"NotificationScreen"];
        globals.isFromHomeScreenToPackageScreen = @"YES";
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

-(void)backButtonTapped:(id)sender
{
    if ([self.packageWebView canGoBack]) {
        [self.packageWebView goBack];
    }else{
        
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
     [MBProgressHUD hideHUDForView:weblinkVc.view animated:YES];
    NSURL * currentURL = self.packageWebView.request.URL;
    NSLog(@"%@", currentURL);
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    
    NSURL * currentURL = self.packageWebView.request.URL;
    NSLog(@"%@", currentURL);
    
    if( request.URL != nil && [[request.URL absoluteString] hasPrefix:@"whatsapp://"]) {
        // do stuff
        NSLog(@"wahtssup installed");
        NSLog(@"inside Webview");
        BOOL isInstalled = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"whatsapp://"]];
        
        if (isInstalled) {
            
            
        } else {
            //            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"whatsapp://"]]) {
            //                // Safe to launch the facebook app
            //                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/in/app/whatsapp-messenger/id310633997?mt=8"]];
            //            }
            
            NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/in/app/whatsapp-messenger/id310633997?mt=8"];
            
            if (![[UIApplication sharedApplication] openURL:url]) {
                NSLog(@"%@%@",@"Failed to open url:",[url description]);
            }
            
            
            //                [self.navigationController popViewControllerAnimated:YES];
            //
            //                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            //
            //                HomeScreenController *vcHomeScreen = [storyboard instantiateViewControllerWithIdentifier:@"HomeScreenController"];
            //                SideMenuController *vcSideMenu =     [storyboard instantiateViewControllerWithIdentifier:@"SideMenuController"];
            //
            //                MMDrawerController *drawerController = [[MMDrawerController alloc]initWithCenterViewController:vcHomeScreen
            //                                                                                      leftDrawerViewController:vcSideMenu];
            //                [drawerController setRestorationIdentifier:@"MMDrawer"];
            //
            //                [drawerController setMaximumLeftDrawerWidth:SCREEN_WIDTH*2/3];
            //
            //                [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
            //                [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
            //                drawerController.shouldStretchDrawer = NO;
            //
            //                UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:drawerController];
            //                [navController setNavigationBarHidden:YES];
            //                [self.view.window setRootViewController:navController];
            //                [self.view.window makeKeyAndVisible];
            if ([self.packageWebView canGoBack]) {
                [self.packageWebView goBack];
            }
            
        }
        return NO;
    }else{
        NSLog(@"wahtssup not installed");
    }
    
    return YES;
}

-(void)inAppClickedForWidget:(InAppWidget)widget screenName:(NSString*)screenName andDataDict:(NSDictionary *)dataDict{
    // Here the dataDict will have the screen name and the key value pairs.
}

//This delegate will be called when an In-App is shown. You can use this to ensure not showing alerts or pop ups of your own at the same time.
-(void)inAppShownWithCampaignID:(NSString*)campaignID{
    
}
-(void)setupGifImage
{
    
//    NSMutableArray *images = [[NSMutableArray alloc] init];
//
//    [images addObject:[UIImage imageNamed:@"logo1"]];
//    [images addObject:[UIImage imageNamed:@"logo2"]];
//    [images addObject:[UIImage imageNamed:@"logo3"]];
//    [images addObject:[UIImage imageNamed:@"logo4"]];
//    [images addObject:[UIImage imageNamed:@"logo5"]];
//    [images addObject:[UIImage imageNamed:@"logo6"]];
//    [images addObject:[UIImage imageNamed:@"logo7"]];
//    [images addObject:[UIImage imageNamed:@"logo8"]];
//    [images addObject:[UIImage imageNamed:@"logo9"]];
//    [images addObject:[UIImage imageNamed:@"logo10"]];
//    [images addObject:[UIImage imageNamed:@"logo11"]];
//    [images addObject:[UIImage imageNamed:@"logo12"]];
    
    //don't forget to add your images to images array
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        width = 200;
        height = 200;
      
        
    }else {
        width = 150;
        height = 150;
      
    }
    self.logoImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenRect.size.width, screenRect.size.height)];
    self.logoImgView.image = [UIImage imageNamed:@"LaunchImg"];
    [self.view addSubview:self.logoImgView];
    
    _pleaseWaitLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, screenRect.size.height * 0.75, screenRect.size.width, 40)];
    _pleaseWaitLbl.text = @"Checking You In.Please Wait....";
    _pleaseWaitLbl.textAlignment = NSTextAlignmentCenter;
    _pleaseWaitLbl.font = [UIFont systemFontOfSize:16];
    _pleaseWaitLbl.textColor = [ICSingletonManager colorFromHexString:@"#BD9854"];
 //   [self.logoImgView addSubview:_pleaseWaitLbl];
    
    
       
    self.previewImage = [[UIImageView alloc]initWithFrame:CGRectMake((screenRect.size.width - width)/2,(screenRect.size.height - height)/2 ,width, height)];
 //   self.previewImage.animationImages = images;
    self.previewImage.animationDuration = 2.0;
    [self.previewImage startAnimating];
    
    self.previewImage.contentMode = UIViewContentModeScaleAspectFill;
  //  [self.logoImgView addSubview:self.previewImage];
    
    
}



#pragma mark - autortotation Method

-(void)adjustView
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationPortrait) {
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            
            CGRect screenRect = [[UIScreen mainScreen] bounds];
            ImageView.image = [UIImage imageNamed:@"OrangeImageHomeScreen"];
            baseView.frame = CGRectMake(0, 293, screenRect.size.width , 205);
            ImageView.frame = CGRectMake(4, 0, baseView.frame.size.width -8  , 205);
            bigLbl.frame = CGRectMake(5, 493, screenRect.size.width - 10, 85);
            bigLbl.numberOfLines = 3;
            bigLbl.textAlignment = NSTextAlignmentCenter;
            bigLbl.adjustsFontSizeToFitWidth = YES;
            
        }else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            CGRect screenRect = [[UIScreen mainScreen] bounds];
            baseView.frame = CGRectMake(0, 395, screenRect.size.width , 205);
            ImageView.image = [UIImage imageNamed:@"BottomImageIpad"];
            ImageView.frame = CGRectMake(5, 0, baseView.frame.size.width - 10 , 205);
            bigLbl.frame = CGRectMake(5, 600, screenRect.size.width - 10, 85);
            bigLbl.numberOfLines = 2;
            bigLbl.textAlignment = NSTextAlignmentCenter;
            bigLbl.adjustsFontSizeToFitWidth = YES;
        }
        
    }else
    {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            CGRect screenRect = [[UIScreen mainScreen] bounds];
            ImageView.image = [UIImage imageNamed:@"OrangeImageHomeScreen"];
            baseView.frame = CGRectMake(0, 293,screenRect.size.width  , 205);
            ImageView.frame = CGRectMake(4, 0, baseView.frame.size.width -8  , 205);
            bigLbl.frame = CGRectMake(5, 493, screenRect.size.width - 10, 85);
            bigLbl.numberOfLines = 3;
            bigLbl.textAlignment = NSTextAlignmentCenter;
            bigLbl.adjustsFontSizeToFitWidth = YES;
        }else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            
            CGRect screenRect = [[UIScreen mainScreen] bounds];
            baseView.frame = CGRectMake(0, 395, screenRect.size.width , 205);
            ImageView.image = [UIImage imageNamed:@"BottomImageIpad"];
            ImageView.frame = CGRectMake(5, 0, baseView.frame.size.width - 10 , 205);
            bigLbl.frame = CGRectMake(5, 600, screenRect.size.width - 10, 85);
            bigLbl.numberOfLines = 2;
            bigLbl.textAlignment = NSTextAlignmentCenter;
            bigLbl.adjustsFontSizeToFitWidth = YES;
        }
    }

}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationPortrait) {
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            
            CGRect screenRect = [[UIScreen mainScreen] bounds];
            ImageView.image = [UIImage imageNamed:@"OrangeImageHomeScreen"];
            baseView.frame = CGRectMake(0, 293, screenRect.size.height , 205);
            ImageView.frame = CGRectMake(4, 0, baseView.frame.size.width -8  , 205);
            bigLbl.frame = CGRectMake(5, 493, screenRect.size.height - 10, 85);
            bigLbl.numberOfLines = 3;
            bigLbl.textAlignment = NSTextAlignmentCenter;
            bigLbl.adjustsFontSizeToFitWidth = YES;
            
            self.previewImage.frame =  CGRectMake((screenRect.size.height - width)/2,(screenRect.size.width - height)/2 ,width, height);
            self.logoImgView.frame = CGRectMake(0,0 ,screenRect.size.height, screenRect.size.width);
            
        }else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            CGRect screenRect = [[UIScreen mainScreen] bounds];
            baseView.frame = CGRectMake(0, 395, screenRect.size.height , 205);
            ImageView.image = [UIImage imageNamed:@"BottomImageIpad"];
            ImageView.frame = CGRectMake(5, 0, baseView.frame.size.width - 10 , 205);
            bigLbl.frame = CGRectMake(5, 600, screenRect.size.height - 10, 85);
            bigLbl.numberOfLines = 2;
            bigLbl.textAlignment = NSTextAlignmentCenter;
            bigLbl.adjustsFontSizeToFitWidth = YES;
            
            self.previewImage.frame = CGRectMake((screenRect.size.height - width)/2,(screenRect.size.width - height)/2 ,width, height);
            self.logoImgView.frame = CGRectMake(0,0, screenRect.size.height, screenRect.size.width);
        }
        
    }else
    {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            CGRect screenRect = [[UIScreen mainScreen] bounds];
            ImageView.image = [UIImage imageNamed:@"OrangeImageHomeScreen"];
            baseView.frame = CGRectMake(0, 293,screenRect.size.height  , 205);
            ImageView.frame = CGRectMake(4, 0, baseView.frame.size.width -8  , 205);
            bigLbl.frame = CGRectMake(5, 493, screenRect.size.height - 10, 85);
            bigLbl.numberOfLines = 3;
            bigLbl.textAlignment = NSTextAlignmentCenter;
            bigLbl.adjustsFontSizeToFitWidth = YES;
            
            self.previewImage.frame = CGRectMake((screenRect.size.height - width)/2,(screenRect.size.height - height)/2 ,width, height);
            self.logoImgView.frame =  CGRectMake(0,0, screenRect.size.height, screenRect.size.width);
        }else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            
            CGRect screenRect = [[UIScreen mainScreen] bounds];
            baseView.frame = CGRectMake(0, 395, screenRect.size.height , 205);
            ImageView.image = [UIImage imageNamed:@"BottomImageIpad"];
            ImageView.frame = CGRectMake(5, 0, baseView.frame.size.width - 10 , 205);
            bigLbl.frame = CGRectMake(5, 600, screenRect.size.height - 10, 85);
            bigLbl.numberOfLines = 2;
            bigLbl.textAlignment = NSTextAlignmentCenter;
            bigLbl.adjustsFontSizeToFitWidth = YES;
            
            self.previewImage.frame = CGRectMake((screenRect.size.height - width)/2,(screenRect.size.width - height)/2 ,width, height);
            self.logoImgView.frame =  CGRectMake(0,0, screenRect.size.height, screenRect.size.width);
        }
    }

    }


#pragma mark - Api Calling Methods
// service to get Slider Images
-(void)getHotelImageList
{
 //   [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8"
                     forHTTPHeaderField:@"Content-Type"];
    
     NSString *strUrl =[NSString stringWithFormat:@"http://www.icanstay.com/api/AppApi/GetSliderImages"];
    [manager GET:strUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        tempImageArray = [responseObject valueForKey:@"Slider"];
        int countImage = [[responseObject valueForKey:@"Count"] intValue];
        
        
        
        NSMutableArray *tempMarray = [[NSMutableArray alloc] initWithCapacity:countImage];
        NSMutableArray *htmlStrArr = [[NSMutableArray alloc]initWithCapacity:countImage];
        NSMutableArray *webImageLinkArr = [[NSMutableArray alloc]initWithCapacity:countImage];
        NSMutableArray *BtnTextArr = [[NSMutableArray alloc]initWithCapacity:countImage];
        
        for (int i=0; i<countImage; i++) {
            
            NSDictionary *tempDict = [tempImageArray objectAtIndex:i];
            int sequenceImage = [[tempDict valueForKey:@"Sequence"] intValue];
            sequenceImage = sequenceImage - 1;
            
            if (IS_IPAD) {
                [tempMarray insertObject:[tempDict valueForKey:@"Image_URL_1536X920"] atIndex:sequenceImage];
                            }
            else{
                if (self.view.frame.size.width == 320) {
                     [tempMarray insertObject:[tempDict valueForKey:@"Image_URL_640X460"] atIndex:sequenceImage];
                                  }
                else if (self.view.frame.size.width < 874){
                     [tempMarray insertObject:[tempDict valueForKey:@"Image_URL_768X460"] atIndex:sequenceImage];
                   
                }
                else {
                     [tempMarray insertObject:[tempDict valueForKey:@"Image_URL_1242X690"] atIndex:sequenceImage];
                    
                }
            }
            
            [htmlStrArr insertObject:[tempDict valueForKey:@"HtmlText"] atIndex:sequenceImage];
            [webImageLinkArr insertObject:[tempDict valueForKey:@"Image_Link"] atIndex:sequenceImage];
            [BtnTextArr insertObject:[tempDict valueForKey:@"btntext"] atIndex:sequenceImage];
         }
        
        imageArray = [tempMarray mutableCopy];
        
        ICSingletonManager *globals = [ICSingletonManager sharedManager];
   //     globals.isFirstTimeImageDownloadAndVideoUrl = true;
        globals.htmlTxtArrForHomeScreen = htmlStrArr;
        globals.imgArrForHomeScreen = imageArray;
        globals.webImageLinkFroHomeScreenArr = webImageLinkArr;
        globals.btnTextFroHomeScreenArr = BtnTextArr;
  //      [_flagBuyNowBtn setTitle:[BtnTextArr objectAtIndex:0] forState:UIControlStateNormal];
      
        NSString *htmlStr = [ICSingletonManager getStringValue:[NSString stringWithFormat:@"%@",[globals.htmlTxtArrForHomeScreen objectAtIndex:0]]];
        [self.imagePager.webView loadHTMLString:htmlStr baseURL:nil];
          [self.imagePager reloadData];
        
        LoginManager *loginManage = [[LoginManager alloc]init];
        NSDictionary *dict = [loginManage isUserLoggedIn];
        if ([dict count]>0){
            NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",globals.youtubeVideoUrl]]];
            
            
            [_webview loadRequest:request];
            

            
        }else{
            if (!globals.isFirstTimeImageDownloadAndVideoUrl) {
                
           //     [self getFlagManageBuyNowBtn];
               
                

            }
            NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",globals.youtubeVideoUrl]]];
            
            
            [_webview loadRequest:request];
            
        }
        
        globals.isFirstTimeImageDownloadAndVideoUrl = true;

        
    //    [MBProgressHUD hideHUDForView:self.view animated:YES];
     //   [self getVideoUrl];
        
        //        [self.hotelTableView reloadData];
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        NSString *msg = [error description];
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:error.localizedDescription onController:self];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self getVideoUrl];
    }];
}

-(void)getFlagManageBuyNowBtn
{
    // [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8"
                     forHTTPHeaderField:@"Content-Type"];
     NSString *strUrl =[NSString stringWithFormat:@"%@/Home/GetFlag",kServerUrl];
    [manager GET:strUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        
        ICSingletonManager *globals = [ICSingletonManager sharedManager];
        globals.flagStatusSale = [responseObject valueForKey:@"flag"];
        
      
        
        LoginManager *loginManage = [[LoginManager alloc]init];
        NSDictionary *dict = [loginManage isUserLoggedIn];
        if ([dict count]>0)
        {
            if ([globals.flagStatusSale isEqualToString:@"0"]) {
             //   [_flagBuyNowBtn setTitle:@"Buy Now " forState:UIControlStateNormal];
            }
            
            if ([globals.flagStatusSale isEqualToString:@"1"]) {
           //     [_flagBuyNowBtn setTitle:@"Pre Register" forState:UIControlStateNormal];
            }
            if ([globals.flagStatusSale isEqualToString:@"2"]) {
             //   [_flagBuyNowBtn setTitle:@"Buy Voucher @ Rs.1,999" forState:UIControlStateNormal];
            }

            [self checkUserBuyVoucher];
            
        }else{
            if (!globals.isFirstTimeImageDownloadAndVideoUrl) {
                
                if ([globals.flagStatusSale isEqualToString:@"0"]) {
                //    [_flagBuyNowBtn setTitle:@"Buy Now " forState:UIControlStateNormal];
                }
                
                if ([globals.flagStatusSale isEqualToString:@"1"]) {
                //    [_flagBuyNowBtn setTitle:@"Pre Register" forState:UIControlStateNormal];
                }
                if ([globals.flagStatusSale isEqualToString:@"2"]) {
                //    [_flagBuyNowBtn setTitle:@"Buy Voucher @ Rs.1,999" forState:UIControlStateNormal];
                }
                [self getVideoUrl];
            }else if (globals.isFirstTimeImageDownloadAndVideoUrl){
                
                //    [self.imagePager reloadData];
                
                if ([globals.flagStatusSale isEqualToString:@"0"]) {
               //     [_flagBuyNowBtn setTitle:@"Buy Now " forState:UIControlStateNormal];
                }
                
                if ([globals.flagStatusSale isEqualToString:@"1"]) {
               //     [_flagBuyNowBtn setTitle:@"Pre Register" forState:UIControlStateNormal];
                }
                if ([globals.flagStatusSale isEqualToString:@"2"]) {
               //     [_flagBuyNowBtn setTitle:@"Buy Voucher @ Rs.1,999" forState:UIControlStateNormal];
                }
                
                ICSingletonManager *globals = [ICSingletonManager sharedManager];
                NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",globals.youtubeVideoUrl]]];
                [_webview loadRequest:request];
                
            }
            
        }
      
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:error.localizedDescription onController:self];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}

// service to get Video URL
-(void)getVideoUrl
{
   // [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8"
                     forHTTPHeaderField:@"Content-Type"];
    
      NSString *strUrl =[NSString stringWithFormat:@"%@/api/AppApi/GetVideoURL",kServerUrl];
    [manager GET:strUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        
        NSString *youtubeVideoUrl = [NSString stringWithFormat:@"%@?rel=0",[responseObject valueForKey:@"VideoURL"]];
        
        ICSingletonManager *globals = [ICSingletonManager sharedManager];
        globals.youtubeVideoUrl  = youtubeVideoUrl;
     //   globals.isFirstTimeImageDownloadAndVideoUrl = true;

               [self getHotelImageList];
        
        
     //    [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:error.localizedDescription onController:self];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}

-(void)checkUserBuyVoucher
{
 //    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8"
                     forHTTPHeaderField:@"Content-Type"];
    LoginManager *loginManage = [[LoginManager alloc]init];
    NSDictionary *dict =  [loginManage isUserLoggedIn];
     NSString *strUrl =[NSString stringWithFormat:@"%@/api/Rating/GetLatestBooking?uesrId=%@",kServerUrl,[dict valueForKey:@"UserId"]];
    [manager GET:strUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        
        ICSingletonManager *globals = [ICSingletonManager sharedManager];
        if (!globals.isFirstTimeImageDownloadAndVideoUrl) {
            
            [self getVideoUrl];
        }else if (globals.isFirstTimeImageDownloadAndVideoUrl){
            
            //    [self.imagePager reloadData];
            ICSingletonManager *globals = [ICSingletonManager sharedManager];
            NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",globals.youtubeVideoUrl]]];
            [_webview loadRequest:request];
        //    [_flagBuyNowBtn setTitle:[globals.btnTextFroHomeScreenArr objectAtIndex:0] forState:UIControlStateNormal];
           
            NSString *htmlStr = [ICSingletonManager getStringValue:[NSString stringWithFormat:@"%@",[globals.htmlTxtArrForHomeScreen objectAtIndex:0]]];
            [self.imagePager.webView loadHTMLString:htmlStr baseURL:nil];
             [self.imagePager reloadData];
            
            [self startServiceToGeticanCash];
            
        }
        if ([responseObject count]>0) {
            
            if ([[[responseObject objectAtIndex:0]valueForKey:@"Check"] isEqualToString:@"0"]) {
                FeedBackRatingView *feedback = [self.storyboard instantiateViewControllerWithIdentifier:@"FeedBackRatingView"];
                feedback.bookingId = [[responseObject objectAtIndex:0]valueForKey:@"BookingId"];
             //   [self.navigationController pushViewController:feedback animated:YES];
            }
           
        }else if ([responseObject count] == 0){
            
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:error.localizedDescription onController:self];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}

- (void)startServiceToGeticanCash
{
    
    //  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
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
-(void)LoadHomePageView
{
    self.previewImage.hidden       = YES;
    self.logoImgView.hidden        = YES;
    self.pleaseWaitLbl.hidden      =  YES;
    
    self.logoImageBaseView.hidden =  NO;
    self.scroolView.hidden =         NO;
    self.bottomBaseView.hidden =     NO;
    self.viewBottom.hidden =         NO;
    self.viewGetStarted.hidden =     NO;
    self.btnLogin.hidden =           NO;
    self.imagePager.hidden =         NO;
    self.btnSearchyour.hidden =      NO;
    
    LoginManager *loginManage = [[LoginManager alloc]init];
    NSDictionary *dict = [loginManage isUserLoggedIn];
    if ([dict count]>0)
    {
        
    }else
    {
        if (firstTimeManageReg == 0) {
            ICSingletonManager *globals = [ICSingletonManager sharedManager];
            if([globals.FirstTimeAppLoginOrRegister isEqualToString:@"NO"])  {
                
              self.contactSharingBaseView.hidden = NO;
                
          //      RegistrationScreen *registerScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"RegistrationScreen"];
                firstTimeManageReg = 1;
             //   globals.registrationBackManage = @"NO";
           //     [self.navigationController pushViewController:registerScreen animated:YES];
            }
            
        }
    }
    
   
   
    
}
-(void)ContactSyncPOpup
{
    self.contactSyncPopupBaseView = [[UIView alloc]init];
    self.contactSyncPopupBaseView.backgroundColor = [UIColor whiteColor];
    self.contactSyncPopupBaseView.hidden = YES;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.contactSyncPopupBaseView.frame = CGRectMake((self.view.frame.size.width - 360)/2,self.topWhiteBaseView.frame.size.height + self.topWhiteBaseView.frame.origin.y  , 360, 700);
    }else{
        self.contactSyncPopupBaseView.frame = CGRectMake(0, 0 , self.view.frame.size.width, self.view.frame.size.height);
    }
    
    [self.view addSubview:self.contactSyncPopupBaseView];
    
    UIImageView *AtImgView = [[UIImageView alloc]initWithFrame:CGRectMake((self.contactSyncPopupBaseView.frame.size.width - 110 )/2  , 15, 110, 110)];
    AtImgView.image = [UIImage imageNamed:@"contactSync"];
    [self.contactSyncPopupBaseView addSubview:AtImgView];
    
    UILabel *syncProgressLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, AtImgView.frame.size.height + AtImgView.frame.origin.y + 30, self.contactSyncPopupBaseView.frame.size.width - 20, 20)];
    syncProgressLbl.text = @"Contact sync is in Progress...";
    syncProgressLbl.textAlignment = NSTextAlignmentCenter;
    syncProgressLbl.font = [UIFont systemFontOfSize:18];
    [self.contactSyncPopupBaseView addSubview:syncProgressLbl];
    
    UILabel *closeAppLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, syncProgressLbl.frame.size.height + syncProgressLbl.frame.origin.y , self.contactSyncPopupBaseView.frame.size.width - 20, 20)];
    closeAppLbl.text = @"Do not close app";
    closeAppLbl.textAlignment = NSTextAlignmentCenter;
    closeAppLbl.font = [UIFont systemFontOfSize:15];
    [self.contactSyncPopupBaseView addSubview:closeAppLbl];
    
    UILabel *completedProgressLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, closeAppLbl.frame.size.height + closeAppLbl.frame.origin.y + 75, self.contactSyncPopupBaseView.frame.size.width -20, 90)];
    completedProgressLbl.text = @"₹5,000 will be credited to your icanstay account after sync completion";
    completedProgressLbl.textAlignment = NSTextAlignmentCenter;
    completedProgressLbl.font = [UIFont systemFontOfSize:18];
    completedProgressLbl.numberOfLines = 3;
    completedProgressLbl.lineBreakMode = NSLineBreakByWordWrapping;
    completedProgressLbl.backgroundColor = [UIColor clearColor];
    [self.contactSyncPopupBaseView addSubview:completedProgressLbl];
    
    
    UILabel *earnUnlimitedCashLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, completedProgressLbl.frame.size.height + completedProgressLbl.frame.origin.y + 10, self.contactSyncPopupBaseView.frame.size.width - 20, 30)];
    earnUnlimitedCashLbl.text = @"Earn Unlimited icanCash!";
    earnUnlimitedCashLbl.textAlignment = NSTextAlignmentCenter;
    //  [self.contactSyncPopupBaseView addSubview:earnUnlimitedCashLbl];
    
    UILabel *ThreeHCashLbl = [[UILabel alloc]initWithFrame:CGRectMake(2, completedProgressLbl.frame.size.height + completedProgressLbl.frame.origin.y + 10, self.contactSyncPopupBaseView.frame.size.width - 4, 20)];
    ThreeHCashLbl.text = @"300 icanCash, if your friend Registers";
    ThreeHCashLbl.textAlignment = NSTextAlignmentCenter;
    ThreeHCashLbl.font = [UIFont systemFontOfSize:17];
    //  [self.contactSyncPopupBaseView addSubview:ThreeHCashLbl];
    
    UILabel *ThreeHCashLbl2 = [[UILabel alloc]initWithFrame:CGRectMake(2, ThreeHCashLbl.frame.size.height + ThreeHCashLbl.frame.origin.y , self.contactSyncPopupBaseView.frame.size.width - 4, 20)];
    ThreeHCashLbl2.text = @"300 icanCash, if your friend do Bookings.";
    ThreeHCashLbl2.textAlignment = NSTextAlignmentCenter;
    ThreeHCashLbl2.font = [UIFont systemFontOfSize:15];
    //    [self.contactSyncPopupBaseView addSubview:ThreeHCashLbl2];
    
    UIButton *continueButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    continueButton.frame = CGRectMake((self.contactSyncPopupBaseView.frame.size.width - 240)/2,self.contactSyncPopupBaseView.frame.size.height - 85  , 240, 20);
    [continueButton setTitle:@"Continue browsing App" forState:UIControlStateNormal];
    [continueButton addTarget:self action:@selector(continueButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [continueButton setTintColor:[UIColor blackColor]];
    [continueButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [self.contactSyncPopupBaseView addSubview:continueButton];
    
    
    UILabel *syncingLbl2 = [[UILabel alloc]initWithFrame:CGRectMake((self.contactSyncPopupBaseView.frame.size.width - 280)/2, continueButton.frame.size.height + continueButton.frame.origin.y  , 280, 20)];
    syncingLbl2.text = @"(syncing will complete in background)";
    syncingLbl2.textAlignment = NSTextAlignmentCenter;
    syncingLbl2.font = [UIFont systemFontOfSize:15];
    [self.contactSyncPopupBaseView addSubview:syncingLbl2];
    
}
-(void)createContactSharingPopup
{
    self.contactSharingBaseView = [[UIView alloc]initWithFrame:CGRectMake(0, 140, self.view.frame.size.width , 500)];
    self.contactSharingBaseView.backgroundColor = [ICSingletonManager colorFromHexString:@"#001d3d"];
    self.contactSharingBaseView.hidden = YES;
    [self.view addSubview:self.contactSharingBaseView];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [closeButton setFrame:CGRectMake(self.contactSharingBaseView.frame.size.width - 50, 5, 30, 30)];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.contactSharingBaseView addSubview:closeButton];
    
    UIView *whiteBaseView = [[UIView alloc]initWithFrame:CGRectMake(0, 40, self.contactSharingBaseView.frame.size.width, self.contactSharingBaseView.frame.size.height - 40)];
    whiteBaseView.backgroundColor = [UIColor whiteColor];
    [self.contactSharingBaseView addSubview:whiteBaseView];
    
    UILabel *referLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, whiteBaseView.frame.size.width, 45)];
    referLbl.text = @"Refer & Earn";
    referLbl.font = [UIFont boldSystemFontOfSize:40];
    referLbl.textAlignment = NSTextAlignmentCenter;
    referLbl.textColor = [ICSingletonManager colorFromHexString:@"#001d3d"];
  //  [whiteBaseView addSubview:referLbl];
    
    UILabel *canCashLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, referLbl.frame.size.height + referLbl.frame.origin.y, whiteBaseView.frame.size.width, 30)];
    canCashLbl.text = @"icanCash Up To ₹ 1 Lakh";
    canCashLbl.font = [UIFont systemFontOfSize:25];
    canCashLbl.textAlignment = NSTextAlignmentCenter;
    canCashLbl.textColor = [ICSingletonManager colorFromHexString:@"#001d3d"];
//    [whiteBaseView addSubview:canCashLbl];
    
    UILabel *spendLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, canCashLbl.frame.size.height + canCashLbl.frame.origin.y, whiteBaseView.frame.size.width, 30)];
    spendLbl.text = @"Spend icanCash on Luxury Hotel Stays";
    spendLbl.font = [UIFont boldSystemFontOfSize:17];
    spendLbl.textAlignment = NSTextAlignmentCenter;
    spendLbl.textColor = [ICSingletonManager colorFromHexString:@"#001d3d"];
//    [whiteBaseView addSubview:spendLbl];
    
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(5,0 , whiteBaseView.frame.size.width - 10, self.contactSharingBaseView.frame.size.height - 110)];
    image.image = [UIImage imageNamed:@"popUpImage"];
    [whiteBaseView addSubview:image];
    
    NSString *str = @"START EARNING";
    CGSize stringsize = [str sizeWithFont:[UIFont systemFontOfSize:18]];
    
    GradientButton *startBtn =  [[GradientButton alloc]init];
    startBtn.frame = CGRectMake((whiteBaseView.frame.size.width - (stringsize.width))/2,image.frame.size.height + image.frame.origin.y+15 , stringsize.width +20, 40);
    [startBtn setTitle:@"START EARNING" forState:UIControlStateNormal];
    [startBtn setTintColor:[UIColor blackColor]];
    [startBtn useRedDeleteStyle];
    [startBtn addTarget:self action:@selector(startEarningBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [whiteBaseView addSubview:startBtn];

    self.contactSharingBaseView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapReferAndEarn = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(referAndEarnTappedImg:)];
    [self.contactSharingBaseView addGestureRecognizer:tapReferAndEarn];
    
}

-(void)referAndEarnTappedImg:(UIGestureRecognizer *)referTapGesture
{
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
    globals.FirstTimeAppLoginOrRegister = @"YES";
    
    self.contactSharingBaseView.hidden = YES;
    
    LoginManager *loginManage = [[LoginManager alloc]init];
    NSDictionary *dict = [loginManage isUserLoggedIn];
    if ([dict count]>0)
    {
        ICSingletonManager *globals = [ICSingletonManager sharedManager];
        ReferAndEarnVC *refer = [self.storyboard instantiateViewControllerWithIdentifier:@"ReferAndEarnVC"];
        
        globals.isFromMenuLastMinuteDeal = @"YES";
        
        [self.navigationController pushViewController:refer animated:YES];
    }else{
        
        ReferAndEarnUnregistered *refer = [self.storyboard instantiateViewControllerWithIdentifier:@"ReferAndEarnUnregistered"];
        ICSingletonManager *globals = [ICSingletonManager sharedManager];
        globals.ReferAndEarnFromHome = @"NO";
        [self.navigationController pushViewController:refer animated:YES];
    }
}
-(void)startEarningBtnPressed:(id)sender
{
    self.contactSharingBaseView.hidden = YES;
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
    globals.FirstTimeAppLoginOrRegister = @"YES";
        
    LoginManager *loginManage = [[LoginManager alloc]init];
    NSDictionary *dict = [loginManage isUserLoggedIn];
    if ([dict count]>0)
    {
        ICSingletonManager *globals = [ICSingletonManager sharedManager];
        ReferAndEarnVC *refer = [self.storyboard instantiateViewControllerWithIdentifier:@"ReferAndEarnVC"];
        
        globals.isFromMenuLastMinuteDeal = @"YES";
        
        [self.navigationController pushViewController:refer animated:YES];
    }else{
        
        ReferAndEarnUnregistered *refer = [self.storyboard instantiateViewControllerWithIdentifier:@"ReferAndEarnUnregistered"];
        ICSingletonManager *globals = [ICSingletonManager sharedManager];
        globals.ReferAndEarnFromHome = @"NO";
        [self.navigationController pushViewController:refer animated:YES];
    }
}
-(void)closeButtonPressed:(id)sender
{
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
    globals.FirstTimeAppLoginOrRegister = @"YES";
     self.contactSharingBaseView.hidden = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addBottomBar{
    [[ICSingletonManager sharedManager]addBottomMenuToViewController:self onView:self.viewBottom];
}


- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
    if ([globals.isFromRegisteredNewUser isEqualToString:@"YES"]) {
        globals.isFromRegisteredNewUser = @"NO";
        //        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Contact Sync"
        //                                                                                 message:@"Do You Wnat To sync Contact"preferredStyle:UIAlertControllerStyleAlert];
        //        //We add buttons to the alert controller by creating UIAlertActions:
        //        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
        //                                                           style:UIAlertActionStyleDefault
        //                                                         handler:^(UIAlertAction * action) {
        //
        //
        //                                                             //Handle your yes please button action here
        //                                                         }]; //You can use a block here to handle a press on this button
        //        [alertController addAction:actionOk];
        //
        //        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Cancel"
        //                                                           style:UIAlertActionStyleDefault
        //                                                         handler:nil];
        //            [alertController addAction:actionCancel];
        //        [self presentViewController:alertController animated:YES completion:nil];
        //        [[ICSingletonManager sharedManager] showAlertViewWithMsg:@"Do You Wnat To sync Contact" onController:self];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Contact Sync"
                                                        message:@"Do You Wnat To sync Contact."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:@"Cancel"];
        [alert show];
        
        [[ICSingletonManager sharedManager] showAlertViewWithMsg:@"User Registered Successfully." onController:self];
        
    }

   

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

-(void)popupDesign
{
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"New Update Available"
                                 message:@"Please update to get more features like \n -Holiday Packages, Social Login &  \n more !"
                                 preferredStyle:UIAlertControllerStyleAlert];
     ICSingletonManager *globals = [ICSingletonManager sharedManager];
    //Add Buttons
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Update"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/in/app/icanstay/id1186747648?mt=8"];
                                    self.scroolView.userInteractionEnabled        = YES;
                                    self.bottomBaseView.userInteractionEnabled = YES;
                                    self.viewBottom.userInteractionEnabled = YES;
                                    self.viewGetStarted.userInteractionEnabled = YES;
                                    self.btnLogin.userInteractionEnabled = YES;
                                    self.imagePager.userInteractionEnabled = YES;
                                    self.btnSearchyour.userInteractionEnabled = YES;
                                    self.logoImageBaseView.userInteractionEnabled = YES;
                                    
                                    globals.isShowVersionUpdatePopup = @"NO";
                                    if (![[UIApplication sharedApplication] openURL:url]) {
                                        NSLog(@"%@%@",@"Failed to open url:",[url description]);
                                     
                                        
                                    }
                                    //Handle your yes please button action here
                                   
                                }];
    
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:@"Cancel"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   
                                   self.scroolView.userInteractionEnabled        = YES;
                                   self.bottomBaseView.userInteractionEnabled = YES;
                                   self.viewBottom.userInteractionEnabled = YES;
                                   self.viewGetStarted.userInteractionEnabled = YES;
                                   self.btnLogin.userInteractionEnabled = YES;
                                   self.imagePager.userInteractionEnabled = YES;
                                   self.btnSearchyour.userInteractionEnabled = YES;
                                   self.logoImageBaseView.userInteractionEnabled = YES;
                                   
                                   //Handle no, thanks button
                               }];
    
    //Add your buttons to alert controller
    
    [alert addAction:yesButton];
    [alert addAction:noButton];
    
    [self presentViewController:alert animated:YES completion:nil];
    
//    UIPopoverController *popOver = (UIPopoverController *)self.presentedViewController;
//    popupController = [[UIViewController alloc]init];
//    popupController.view.frame = CGRectMake((self.view.frame.size.width - 330)/2, (self.view.frame.size.height - 200) / 2, 330, 180);
//    popupController.view.backgroundColor = [UIColor redColor];
//    [self.view addSubview:popupController.view];
//    
//    
//    self.popupView = [[UIView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 330)/2, (self.view.frame.size.height - 200) / 2, 330, 180)];
//    self.popupView.backgroundColor = [UIColor whiteColor];
//    self.popupView.layer.masksToBounds = YES;
//  //  [self.view addSubview:self.popupView];
//    
//    UILabel *updateHeaderlbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, self.popupView.frame.size.width - 10, 30)];
//    updateHeaderlbl.text = @"New Update Available";
//    updateHeaderlbl.textAlignment = NSTextAlignmentLeft;
//    updateHeaderlbl.font = [UIFont boldSystemFontOfSize:20];
//    [popupController.view addSubview:updateHeaderlbl];
//    
//    UILabel *detailLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, updateHeaderlbl.frame.origin.y + updateHeaderlbl.frame.size.height ,self.popupView.frame.size.width - 10 , 100)];
//    detailLbl.text = @"Please update to get more features like \n -Holiday Packages, Social Login &  \n more !";
//    detailLbl.lineBreakMode = NSLineBreakByWordWrapping;
//    detailLbl.numberOfLines = 3;
//    [popupController.view addSubview:detailLbl];
//    
//    UIButton *updateBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    updateBtn.frame =  CGRectMake(self.popupView.frame.size.width/3, detailLbl.frame.origin.y + detailLbl.frame.size.height, ((self.popupView.frame.size.width *0.66) - 20)/2, 30);
//    [updateBtn addTarget: self action:@selector(updateButtonBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
//    [updateBtn setTitle:@"UPDATE" forState:UIControlStateNormal];
//    updateBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
//    [updateBtn setTitleColor:[self colorWithHexString:@"001d3d"] forState:UIControlStateNormal];
//    [popupController.view addSubview:updateBtn];
//
//    
//    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    cancelBtn.frame = CGRectMake(self.popupView.frame.size.width/3 + 10 + updateBtn.frame.size.width, detailLbl.frame.origin.y + detailLbl.frame.size.height , ((self.popupView.frame.size.width*0.66) - 20)/2, 30);
//    [cancelBtn addTarget: self action:@selector(cancelBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
//    [cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
//    cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
//    [cancelBtn setTitleColor:[self colorWithHexString:@"001d3d"] forState:UIControlStateNormal];
//    [popupController.view addSubview:cancelBtn];
//    
    
}

-(void)cancelBtnPressed:(id)sender
{
    popupController.view.hidden = YES;
    [popupController.view removeFromSuperview];
    
    self.popupView.backgroundColor = [UIColor redColor];
}

-(void)updateButtonBtnPressed:(id)sender
{
    NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/in/app/icanstay/id1186747648?mt=8"];
    
    if (![[UIApplication sharedApplication] openURL:url]) {
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
        
        
    }
    
    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//    
//    HomeScreenController *vcHomeScreen = [storyboard instantiateViewControllerWithIdentifier:@"HomeScreenController"];
//    SideMenuController *vcSideMenu =     [storyboard instantiateViewControllerWithIdentifier:@"SideMenuController"];
//    
//    MMDrawerController *drawerController = [[MMDrawerController alloc]initWithCenterViewController:vcHomeScreen
//                                                                          leftDrawerViewController:vcSideMenu];
//    [drawerController setRestorationIdentifier:@"MMDrawer"];
//    
//    
//    [drawerController setMaximumLeftDrawerWidth:SCREEN_WIDTH*2/3];
//    
//    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
//    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
//    drawerController.shouldStretchDrawer = NO;
//    
//    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:drawerController];
//    [navController setNavigationBarHidden:YES];
//    [self.view.window setRootViewController:navController];
//    [self.view.window makeKeyAndVisible];
}

-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self adjustView];
    
    BOOL isUserLoggedIn= [[ICSingletonManager sharedManager] detectingIfUserLoggedIn];
    [self.btnLogin setHidden:isUserLoggedIn];
     ICSingletonManager *globals = [ICSingletonManager sharedManager];
    if ([globals.strMenuFromSearchStay isEqualToString:@"YES"]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Search Your Stay" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"By Current Location",@"By City", nil];
        [alert show];
        globals.strMenuFromSearchStay = @"NO";
    }
   }

#pragma mark - KIImagePager DataSource
- (NSArray *) arrayWithImages:(KIImagePager*)pager
{
//    return  @[[UIImage imageNamed:@"homeScreenImg1"],[UIImage imageNamed:@"homeScreenImg3"],[UIImage imageNamed:@"homeScreenImg4"], [UIImage imageNamed:@"homeScreenImg2"]];
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
    return globals.imgArrForHomeScreen;
}

- (UIViewContentMode) contentModeForImage:(NSUInteger)image inPager:(KIImagePager *)pager
{
    return UIViewContentModeScaleToFill;
}

- (NSString *) captionForImageAtIndex:(NSUInteger)index inPager:(KIImagePager *)pager
{
    return nil;
}

#pragma mark - KIImagePager Delegate
- (void) imagePager:(KIImagePager *)imagePager didScrollToIndex:(NSUInteger)index
{
   ICSingletonManager *globals = [ICSingletonManager sharedManager];
    
    
    NSString *htmlStr = [ICSingletonManager getStringValue:[NSString stringWithFormat:@"%@",[globals.htmlTxtArrForHomeScreen objectAtIndex:index]]];
    
 //   NSString *btnStr = [ICSingletonManager getStringValue:[NSString stringWithFormat:@"%@",[globals.btnTextFroHomeScreenArr objectAtIndex:index]]];
//    [_flagBuyNowBtn setTitle:btnStr forState:UIControlStateNormal];

   [imagePager.webView loadHTMLString:htmlStr baseURL:nil];
    
    //        [(UIWebView *)[cell.contentView viewWithTag:3] loadHTMLString:[NSString stringWithFormat:@"<html><body bgcolor=\"#001d3d\" text=\"#bd9854\" face=\"Bookman Old Style, Book Antiqua, Garamond\" size=\"5\">%@</body></html>", str ]baseURL:nil];
//    [(UIWebView *)[cell.contentView viewWithTag:3] loadHTMLString:[NSString stringWithFormat:@"%@", htmlStr ]baseURL:nil];

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        NSMutableAttributedString *attString =
        [[NSMutableAttributedString alloc]
         initWithString: @"FOR ₹ 2,999/- (INCL. TAXES)"];
        
        
        [attString addAttribute: NSFontAttributeName
                          value:  [UIFont systemFontOfSize:24]
                          range: NSMakeRange(0,13)];
        
        [attString addAttribute: NSFontAttributeName
                          value:  [UIFont boldSystemFontOfSize:12]
                          range: NSMakeRange(13,14)];
        
        NSString *imageNumber = [NSString stringWithFormat:@"%lu",(unsigned long)index];
        if ([imageNumber isEqualToString:@"0"]) {
            
            imagePager.luxHotlStayLbl.text = @"LUXURY HOTEL STAY";
            imagePager.priceLblBigFont.attributedText =attString;
            imagePager.bottomLbl.text = @"ALL OVER INDIA";
            imagePager.bottomLbl.font = [UIFont systemFontOfSize:17];
            
            
            
        }else if ([imageNumber isEqualToString:@"1"]){
            imagePager.luxHotlStayLbl.text = @"GUARANTEED STAY";
            imagePager.priceLblBigFont.text = @"IN A LUXURY HOTEL";
            imagePager.bottomLbl.attributedText = attString;
            imagePager.priceLblBigFont.font = [UIFont systemFontOfSize:24];
            
        }else if ([imageNumber isEqualToString:@"2"]){
            imagePager.luxHotlStayLbl.text = @"LUXURY HOTEL STAY";
            imagePager.priceLblBigFont.attributedText = attString;
            imagePager.bottomLbl.text = @"VALID FOR 11 MONTHS";
            imagePager.bottomLbl.font = [UIFont systemFontOfSize:17];
            
        }else if ([imageNumber isEqualToString:@"3"]){
            imagePager.luxHotlStayLbl.text = @"LUXURY HOTEL STAY";
            imagePager.priceLblBigFont.attributedText = attString;
            imagePager.bottomLbl.text = @"VOUCHER VALID ALL OVER INDIA";
            imagePager.bottomLbl.font = [UIFont systemFontOfSize:17];
            
        }

    }else{
        NSMutableAttributedString *attString =
        [[NSMutableAttributedString alloc]
         initWithString: @"FOR ₹ 2,999/- (INCL. TAXES)"];
        
        
        [attString addAttribute: NSFontAttributeName
                          value:  [UIFont systemFontOfSize:36]
                          range: NSMakeRange(0,13)];
        
        [attString addAttribute: NSFontAttributeName
                          value:  [UIFont boldSystemFontOfSize:12]
                          range: NSMakeRange(13,14)];
        
        NSString *imageNumber = [NSString stringWithFormat:@"%lu",(unsigned long)index];
        if ([imageNumber isEqualToString:@"0"]) {
            
            imagePager.luxHotlStayLbl.text = @"LUXURY HOTEL STAY";
            imagePager.priceLblBigFont.attributedText =attString;
            imagePager.bottomLbl.text = @"ALL OVER INDIA";
            imagePager.bottomLbl.font = [UIFont systemFontOfSize:24];
            
            
            
        }else if ([imageNumber isEqualToString:@"1"]){
            imagePager.luxHotlStayLbl.text = @"GUARANTEED STAY";
            imagePager.priceLblBigFont.text = @"IN A LUXURY HOTEL";
            imagePager.bottomLbl.attributedText = attString;
            imagePager.priceLblBigFont.font = [UIFont systemFontOfSize:36];
            
        }else if ([imageNumber isEqualToString:@"2"]){
            imagePager.luxHotlStayLbl.text = @"LUXURY HOTEL STAY";
            imagePager.priceLblBigFont.attributedText = attString;
            imagePager.bottomLbl.text = @"VALID FOR 11 MONTHS";
            imagePager.bottomLbl.font = [UIFont systemFontOfSize:24];
            
        }else if ([imageNumber isEqualToString:@"3"]){
            imagePager.luxHotlStayLbl.text = @"LUXURY HOTEL STAY";
            imagePager.priceLblBigFont.attributedText = attString;
            imagePager.bottomLbl.text = @"VOUCHER VALID ALL OVER INDIA";
            imagePager.bottomLbl.font = [UIFont systemFontOfSize:24];
            
        }

    }
   
}

- (void) imagePager:(KIImagePager *)imagePager didSelectImageAtIndex:(NSUInteger)index
{
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
    
    
    NSString *webLinkStr = [ICSingletonManager getStringValue:[NSString stringWithFormat:@"%@",[ globals.webImageLinkFroHomeScreenArr objectAtIndex:index]]];
    
 //   NSString *btnStr = [ICSingletonManager getStringValue:[NSString stringWithFormat:@"%@",[globals.btnTextFroHomeScreenArr objectAtIndex:index]]];
 //   [_flagBuyNowBtn setTitle:btnStr forState:UIControlStateNormal];
    
    if ([webLinkStr isEqualToString:@"#"]) {
        
    }else  if ([webLinkStr isEqualToString:@"last"]){
        ICSingletonManager *globals = [ICSingletonManager sharedManager];
        globals.isFromMenuLastMinuteDeal = @"YES";
        
        LastMinuteViewController *lastMinuteScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"LastMinuteViewController"];
        [self.navigationController pushViewController:lastMinuteScreen animated:YES];
    }else  if ([webLinkStr isEqualToString:@"buy"]) {
        ICSingletonManager *globals = [ICSingletonManager sharedManager];
        globals.isFromMenuForBuyVoucher = false;
        
        BuyCouponViewController *buyCoupon =[self.storyboard instantiateViewControllerWithIdentifier:@"BuyCouponViewController"];
        [self.navigationController pushViewController:buyCoupon animated:YES];

    }else{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        weblinkVc = [storyboard instantiateViewControllerWithIdentifier:@"weblinkVc"];
        weblinkVc.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [self designImageWebLinkController];
           [MBProgressHUD showHUDAddedTo:weblinkVc.view animated:YES];
            NSURL* url = [NSURL URLWithString:webLinkStr];
        //  NSURL *url = [NSURL URLWithString:[self getURLFromString:urlString]];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
        [self.packageWebView loadRequest:urlRequest];

        [self.navigationController pushViewController:weblinkVc animated:YES];
    }
    
}

#pragma mark - Navigation


#pragma mark - Custom Action Methods

- (IBAction)btnMenuTapped:(id)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (IBAction)btnLoginTapped:(id)sender {
    [self switchToLoginScreen];
}

- (IBAction)btnGetStartedTapped:(id)sender
{
    LoginManager *loginManage = [[LoginManager alloc]init];
    NSDictionary *dict = [loginManage isUserLoggedIn];
    if ([dict count]>0)
    {
        ICSingletonManager *globals = [ICSingletonManager sharedManager];
        ReferAndEarnVC *refer = [self.storyboard instantiateViewControllerWithIdentifier:@"ReferAndEarnVC"];
        
        globals.isFromMenuLastMinuteDeal = @"YES";
        
        [self.navigationController pushViewController:refer animated:YES];
    }else{
     
        ReferAndEarnUnregistered *refer = [self.storyboard instantiateViewControllerWithIdentifier:@"ReferAndEarnUnregistered"];
        ICSingletonManager *globals = [ICSingletonManager sharedManager];
        globals.ReferAndEarnFromHome = @"NO";
        [self.navigationController pushViewController:refer animated:YES];
    }
    
    
//    int value = _imagePager.currentPage;
//    __weak UIButton *btn = sender;
//   NSString *titleBtnStr = btn.titleLabel.text;
//
//   ICSingletonManager *globals = [ICSingletonManager sharedManager];
//    NSString *webLinkStr = [ICSingletonManager getStringValue:[NSString stringWithFormat:@"%@",[ globals.webImageLinkFroHomeScreenArr objectAtIndex:value]]];
//
//    if ([webLinkStr isEqualToString:@"#"]) {
//
//    }else  if ([webLinkStr isEqualToString:@"last"]){
//        ICSingletonManager *globals = [ICSingletonManager sharedManager];
//        globals.isFromMenuLastMinuteDeal = @"YES";
//
//        LastMinuteViewController *lastMinuteScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"LastMinuteViewController"];
//        [self.navigationController pushViewController:lastMinuteScreen animated:YES];
//    }else  if ([webLinkStr isEqualToString:@"buy"]) {
//        ICSingletonManager *globals = [ICSingletonManager sharedManager];
//        globals.isFromMenuForBuyVoucher = false;
//
//        BuyCouponViewController *buyCoupon =[self.storyboard instantiateViewControllerWithIdentifier:@"BuyCouponViewController"];
//        [self.navigationController pushViewController:buyCoupon animated:YES];
//
//    }else{
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//        weblinkVc = [storyboard instantiateViewControllerWithIdentifier:@"weblinkVc"];
//        weblinkVc.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//        [self designImageWebLinkController];
//        [MBProgressHUD showHUDAddedTo:weblinkVc.view animated:YES];
//        NSURL* url = [NSURL URLWithString:webLinkStr];
//        //  NSURL *url = [NSURL URLWithString:[self getURLFromString:urlString]];
//        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
//        [self.packageWebView loadRequest:urlRequest];
//
//        [self.navigationController pushViewController:weblinkVc animated:YES];
//    }
//
//    
    
}



- (IBAction)btnPlanYourStayTapped:(id)sender
{
    
    
    LoginManager *loginManage = [[LoginManager alloc]init];
    NSDictionary *dict = [loginManage isUserLoggedIn];
    
    if ([dict count] > 0) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];

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
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if ([status isEqualToString:@"SUCCESS"]) {
                
                
                
                NSString  *numCouponCount =[NSString stringWithFormat:@"%@", [responseObject valueForKey:@"UserCouponCount"]];
                if ([numCouponCount isEqualToString:@"0"]) {
                    
                    ICSingletonManager *globals = [ICSingletonManager sharedManager];
                    globals.isFromMenuForBuyVoucher = false;
                    
                    BuyCouponViewController *buyCoupon =[self.storyboard instantiateViewControllerWithIdentifier:@"BuyCouponViewController"];
                    [self.navigationController pushViewController:buyCoupon animated:YES];
                }else if (![numCouponCount isEqualToString:@"0"])
                {
                    ICSingletonManager *globals = [ICSingletonManager sharedManager];
                    globals.isFromMenuForWishList = true;
                    
                    
                    MyWishlistViewController *buyCoupon =[self.storyboard instantiateViewControllerWithIdentifier:@"MyWishlistViewController"];
                    [self.mm_drawerController setCenterViewController:buyCoupon withCloseAnimation:YES completion:nil];
                }
                
                
                
            }
            
            NSLog(@"sucess");
            
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failure");
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [[ICSingletonManager sharedManager] showAlertViewWithMsg:error.localizedDescription onController:self];
            
        }];

    }else{
        ICSingletonManager *globals = [ICSingletonManager sharedManager];
        globals.strWhichScreen = @"BuyVoucher";
        [self switchToLoginScreen];

    }
   
   
    
//    LoginManager *manager = [[LoginManager alloc]init];
//    NSDictionary *dict = [manager isUserLoggedIn];
//    if (dict.count>0)
//    {
//        ICSingletonManager *globals = [ICSingletonManager sharedManager];
//        globals.isFromMenuForMakeWishe = false;
//        MakeAWishlistViewController *createWishList =[self.storyboard instantiateViewControllerWithIdentifier:@"MakeAWishlistViewController"];
//        [self.navigationController pushViewController:createWishList animated:YES];
//    }
//    else
//    {
//        ICSingletonManager *globals = [ICSingletonManager sharedManager];
//        globals.strWhichScreen = @"MakeWishList";
//        [self switchToLoginScreen];
//    }
  
}

- (IBAction)btnSearchYourStayTapped:(id)sender {
   
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
    globals.isFromMenu = false;
    
    CitiesViewController *cityScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"CitiesViewController"];
    [self.navigationController pushViewController:cityScreen animated:YES];

  

    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
    globals.isFromMenuForSearchRedeem = false;

    if (buttonIndex==1) {
        MapScreen *mapScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"MapScreen"];
        mapScreen.isByCurrentLocation=YES;
        mapScreen.isByCity = NO;
        globals.isFromMenuForSearchRedeem = NO;
        [self.navigationController pushViewController:mapScreen animated:YES];
    }
    else  if (buttonIndex==2)
    {
        MapScreen *mapScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"MapScreen"];
        mapScreen.isByCity = YES;
        mapScreen.isByCurrentLocation = NO;
         globals.isFromMenuForSearchRedeem = NO;
        [self.navigationController pushViewController:mapScreen animated:YES];
    }

}

- (IBAction)buyButtonTapped:(id)sender {

    
    
//    BuyCouponNewViewController *buyCoupon =[self.storyboard instantiateViewControllerWithIdentifier:@"BuyCouponNewViewController"];
//    [self.navigationController pushViewController:buyCoupon animated:YES];
    
        ICSingletonManager *globals = [ICSingletonManager sharedManager];
        globals.isFromMenuForBuyVoucher = false;

        BuyCouponViewController *buyCoupon =[self.storyboard instantiateViewControllerWithIdentifier:@"BuyCouponViewController"];
        [self.navigationController pushViewController:buyCoupon animated:YES];


//    FeedBackRatingView *feedback = [self.storyboard instantiateViewControllerWithIdentifier:@"FeedBackRatingView"];
//    [self.navigationController pushViewController:feedback animated:YES];
}

- (IBAction)redeemButtonTapped:(id)sender {
    LoginManager *manager = [[LoginManager alloc]init];
    NSDictionary *dict = [manager isUserLoggedIn];
    if (dict.count>0)
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
    else
    {
        ICSingletonManager *globals = [ICSingletonManager sharedManager];
        globals.strWhichScreen = @"SearchYourStay";
        [self switchToLoginScreen];
    }

}

- (IBAction)citiesButtonTapped:(id)sender {
 
    LoginManager *loginManage = [[LoginManager alloc]init];
    NSDictionary *dict = [loginManage isUserLoggedIn];
    if ([dict count]>0)
    {
        ICSingletonManager *globals = [ICSingletonManager sharedManager];
        ReferAndEarnVC *refer = [self.storyboard instantiateViewControllerWithIdentifier:@"ReferAndEarnVC"];
        
        globals.isFromMenuLastMinuteDeal = @"YES";
        
        [self.navigationController pushViewController:refer animated:YES];
    }else{
        
        ReferAndEarnUnregistered *refer = [self.storyboard instantiateViewControllerWithIdentifier:@"ReferAndEarnUnregistered"];
        ICSingletonManager *globals = [ICSingletonManager sharedManager];
        globals.ReferAndEarnFromHome = @"NO";
        [self.navigationController pushViewController:refer animated:YES];
    }
  
//    ICSingletonManager *globals = [ICSingletonManager sharedManager];
//    globals.isFromMenuLastMinuteDeal = @"YES";
//
//     LastMinuteViewController *lastMinuteScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"LastMinuteViewController"];
//    [self.navigationController pushViewController:lastMinuteScreen animated:YES];
    
}

- (IBAction)faqsButtonTapped:(id)sender {
  
//    FaqScreen *faqScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"FaqScreen"];
//    [self.mm_drawerController setCenterViewController:faqScreen withCloseAnimation:YES completion:nil];
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
     PackagesViewController *PackageScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"PackagesViewController"];
    globals.isFromHomeScreenToPackageScreen =  @"YES";
    [self.navigationController pushViewController:PackageScreen animated:YES];

}

@end
