//
//  ReferAndEarnVC.m
//  ICanStay
//
//  Created by Planet on 11/7/17.
//  Copyright © 2017 verticallogics. All rights reserved.
//

#import "ReferAndEarnVC.h"
#import <Contacts/Contacts.h>
#import "GradientButton.h"
#import "BuyCouponViewController.h"
#import "LastMinuteViewController.h"
#import "NotificationScreen.h"
#import "DashboardScreen.h"
#import "CancashController.h"
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <Social/Social.h>
#import <Twitter/TWTweetComposeViewController.h>
#import <TwitterKit/TwitterKit.h>
#import <MoEngage.h>
#import "HomeScreenController.h"
#import "SideMenuController.h"
#import "ReferAndEarnWeb.h"

@interface ReferAndEarnVC ()<UIPopoverControllerDelegate, UIGestureRecognizerDelegate, TWTRComposerViewControllerDelegate>
{
    UILabel *referAndEarnLbl;
    NSMutableArray                 *arrayOfContacts;
    NSString  *contactSyncOrNot;
    GradientButton *shareContactsButton;
    UIView    *shareContactsNarrowLine;
    UIButton *shareViaBtn;
    UIButton *noThanksBtn;
    UIView * noThanksNarrowLineView;
}
@property (nonatomic, strong) UIView         *topWhiteBaseView;
@property (nonatomic, strong) UIButton       *backButton;
@property (nonatomic, strong) UIButton       *notificationButton;
@property (nonatomic, strong) UIImageView    *logoIconImgView;
@property (nonatomic, strong) UIView         *contactSyncPopupBaseView;
@property (nonatomic, strong) UIView         *baseView;
@property (nonatomic, strong) UIView         *tcBaseView;
@property (nonatomic, strong)  UIView        *icsCashBaseView;
@property (nonatomic, strong)   NSString     *myreferalcode;
@end

@implementation ReferAndEarnVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    arrayOfContacts = [[NSMutableArray alloc]init];
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
    
    [self getUserRefferralCode];
    
    
   
   
 
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
-(void)getUserRefferralCode
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8"
                     forHTTPHeaderField:@"Content-Type"];
    
    LoginManager *loginManage = [[LoginManager alloc]init];
    NSDictionary *dict2 = [loginManage isUserLoggedIn];
    NSNumber *num = [dict2 valueForKey:@"UserId"];
    
    NSString *strUrl = [NSString stringWithFormat:@"%@/api/faqapi/ShowReffralCode?userId=%@",kServerUrl,num];
    [manager GET:strUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        
        self.myreferalcode = [responseObject objectForKey:@"myreferalcode"];
       
         [self getContactSyncStatus];
        
        
  //      [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:error.localizedDescription onController:self];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}


-(void)getContactSyncStatus
{
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
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
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {

            [self designBaseViewCheck];
            [self tcBaseViewDesignCheck];
//            [self designBaseViewIpad];
//            [self ContactSyncPOpupIpad];
//            [self tcBaseViewDesignIpad];
//            [self icsCashPopUpIpad];
            [self ContactSyncPOpup];
            [self icsCashPopUp];
        }else{
            
            [self designBaseViewCheck];
            [self tcBaseViewDesignCheck];
            
//            [self designBaseView];
            [self ContactSyncPOpup];
//            [self tcBaseViewDesign];
           [self icsCashPopUp];
        }
       
        
        
        
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:error.localizedDescription onController:self];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}

#pragma mark Iphone Views
-(void)designBaseViewCheck{
    UIScrollView *baseScrollView = [[UIScrollView alloc]init];
   
    
    UIView *baseView = [[UIView alloc]init];
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        baseView.frame = CGRectMake((self.view.frame.size.width - 360 )/2,self.topWhiteBaseView.frame.size.height , 360, 670);
        [self.view addSubview:baseView];
    }else{
         [self.view addSubview:baseScrollView];
        baseView.frame = CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height - self.topWhiteBaseView.frame.size.height);
        baseScrollView.frame = CGRectMake(0, self.topWhiteBaseView.frame.size.height ,self.view.frame.size.width, self.view.frame.size.height - self.topWhiteBaseView.frame.size.height);
        [baseScrollView addSubview:baseView];
    }
    UIView *blueBaseView = [[UIView alloc]initWithFrame:CGRectMake(0, 20,baseView.frame.size.width , 70)];
    blueBaseView.backgroundColor = [ICSingletonManager colorFromHexString:@"#001d3d"];
    [baseView addSubview:blueBaseView];
    
    UILabel *referEarnLackLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, baseView.frame.size.width, 20)];
    referEarnLackLbl.textColor = [UIColor whiteColor];
    referEarnLackLbl.font = [UIFont boldSystemFontOfSize:18];
    referEarnLackLbl.textAlignment = NSTextAlignmentCenter;
    referEarnLackLbl.text = @"Refer & Earn icanCash Up to ₹1 Lakh";
    [blueBaseView addSubview:referEarnLackLbl];
    
    UILabel *discountLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, referEarnLackLbl.frame.size.height + referEarnLackLbl.frame.origin.y, baseView.frame.size.width, 20)];
    discountLbl.textColor = [UIColor whiteColor];
    discountLbl.font = [UIFont systemFontOfSize:15];
    discountLbl.textAlignment = NSTextAlignmentCenter;
    discountLbl.text = @"Redeem & Get Cashback With Every Purchase";
    [blueBaseView addSubview:discountLbl];
    
    
    UIWebView *webView2 = [[UIWebView alloc]init];
    webView2.scrollView.scrollEnabled = NO;
    webView2.userInteractionEnabled = NO;
    NSString *str = @"icanCash is our rewards programme where you can earn cash in your icanstay account simply by referring us to your friends. Every unit of icanCash you earn is equal to one rupee, which you can use to buy a luxury stay voucher or make a last-minute booking on our site or mobile app.";
    
    //   [webView loadHTMLString:[NSString stringWithFormat:@"<div align='justify'>%@<div>", str ]baseURL:nil];
    [webView2 loadHTMLString:[NSString stringWithFormat:@"<html><body style=\"text-align:justify\"><font color='Gray'><font size='4'> %@ </font></font></body></Html>", str] baseURL:nil];
    [baseView addSubview:webView2];
//    UITextView *txtView = [[UITextView alloc]init];
//    txtView.text = @"icanCash is our rewards programme where you can earn cash in your icanstay account simply by referring us to your friends through your phone contacts. Every unit of icanCash you earn is equal to one rupee, which you can use to get discounts whenever you buy a luxury stay voucher, make a last-minute booking or buy a holiday package on our site or mobile app.";
//    txtView.scrollEnabled = NO;
//    txtView.userInteractionEnabled = NO;
//    txtView.editable = NO;
//    txtView.font = [UIFont systemFontOfSize:18];
//    [baseView addSubview:txtView];
    
CGFloat height =    [self getLabelHeight:CGSizeMake(baseView.frame.size.width - 10, 230) string:str font:[UIFont systemFontOfSize:18 ]];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        webView2.frame = CGRectMake(5,blueBaseView.frame.size.height + blueBaseView.frame.origin.y + 15,baseView.frame.size.width - 10 , height + 20);
    }else{
         webView2.frame = CGRectMake(5,blueBaseView.frame.size.height + blueBaseView.frame.origin.y + 15,baseView.frame.size.width - 10 , height + 20);
    }
    
    CGFloat heightAdditional =    [self getLabelHeight:CGSizeMake(baseView.frame.size.width - 20, 230) string:@"Refer icanstay to your friends and earn ₹5,000 icanCash" font:[UIFont boldSystemFontOfSize:18]];
    
    UITextView *additionalLbl = [[UITextView alloc]initWithFrame:CGRectMake(10,webView2.frame.size.height + webView2.frame.origin.y + 5 , baseView.frame.size.width - 20, heightAdditional + 20 )];
    additionalLbl.text = @"Refer icanstay to your friends and earn ₹5,000 icanCash";
    additionalLbl.font = [UIFont boldSystemFontOfSize:18];
    additionalLbl.textAlignment = NSTextAlignmentCenter;
    additionalLbl.textColor = [ICSingletonManager colorFromHexString:@"#808080"];
    additionalLbl.editable = NO;
    additionalLbl.scrollEnabled = NO;
    [baseView addSubview:additionalLbl];
    
    
    UILabel *addtionLbl = [[UILabel alloc]initWithFrame:CGRectMake(10,additionalLbl.frame.size.height + additionalLbl.frame.origin.y + 5 , baseView.frame.size.width - 20, 20 )];
    addtionLbl.textColor = [ICSingletonManager colorFromHexString:@"#808080"];
    addtionLbl.font = [UIFont systemFontOfSize:15];
    addtionLbl.textAlignment = NSTextAlignmentLeft;
    addtionLbl.text = @"In addition, you also earn";
    [baseView addSubview:addtionLbl];
    
    
    NSString *htmlString = @"<html><head><style>ul{list-style:none;padding: 1px 0px 0px 0px; }ul li {background-image: url(http://www.icanstay.com/Content/Home/images/rev-slider/dot.png);  background-repeat: no-repeat; background-position: 0 0px; padding: 0px 10px 12px 18px; background-size: 13px;font-size: 15px; color:#808080; line-height: 17px;}</style></head><body><ul><li>₹2,000 icanCash every time your friend registers with your referral code.</li><li>₹1,000 icanCash on every purchase your friend makes.</li><li>₹1,000 Cashback on every purchase.</li></ul></body></html>";
    
    CGSize size = CGSizeMake(baseView.frame.size.width - 20, CGFLOAT_MAX);
       NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:htmlString];
    CGRect paragraphRect =     [attributedText boundingRectWithSize:size
                                                        options:(NSStringDrawingUsesLineFragmentOrigin)
                                                        context:nil];
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(10,addtionLbl.frame.size.height + addtionLbl.frame.origin.y + 5 , baseView.frame.size.width - 20, paragraphRect.size.height)];
   
    [webView loadHTMLString:[NSString stringWithFormat:@"%@", htmlString ]baseURL:nil];
    webView.scrollView.scrollEnabled = NO;
    [baseView addSubview:webView];
    
    
    shareContactsButton =  [[GradientButton alloc]init];
    shareContactsButton.frame = CGRectMake((baseView.frame.size.width - 300)/2, webView.frame.size.height + webView.frame.origin.y + 10 , 300, 40);
    [shareContactsButton setTitle:@"Yes, share with my contacts" forState:UIControlStateNormal];
    [shareContactsButton setTintColor:[UIColor blackColor]];
    [shareContactsButton useRedDeleteStyle];
    [shareContactsButton addTarget:self action:@selector(shareContactButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [baseView addSubview:shareContactsButton];

    
   noThanksBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    noThanksBtn.frame = CGRectMake((baseView.frame.size.width - 90)/2, shareContactsButton.frame.size.height + shareContactsButton.frame.origin.y + 10 , 90, 20);
    [noThanksBtn setTitle:@"No Thanks!" forState:UIControlStateNormal];
    [noThanksBtn addTarget:self action:@selector(noThanksButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [noThanksBtn setTintColor:[ICSingletonManager colorFromHexString:@"#808080"]];
    [noThanksBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [baseView addSubview:noThanksBtn];
    

 
    noThanksNarrowLineView = [[UIView alloc]initWithFrame:CGRectMake((baseView.frame.size.width - 80)/2, noThanksBtn.frame.size.height + noThanksBtn.frame.origin.y  , 80, 1)];
    noThanksNarrowLineView.backgroundColor = [ICSingletonManager colorFromHexString:@"#808080"];
    [baseView addSubview:noThanksNarrowLineView];
    
   ICSingletonManager *globals = [ICSingletonManager sharedManager];
    if ([contactSyncOrNot isEqualToString:@"YES"]) {
        shareContactsButton.hidden = YES;
        shareContactsNarrowLine.hidden = YES;
        noThanksBtn.hidden = YES;
        noThanksNarrowLineView.hidden = YES;
        noThanksBtn.frame = CGRectMake((baseView.frame.size.width - 80)/2, webView.frame.size.height + webView.frame.origin.y + 10 , 80, 20);
    }
    
//    if ([globals.contactSyncOrNot isEqualToString:@"YES"]) {
//        shareContactsButton.hidden = YES;
//        shareContactsNarrowLine.hidden = YES;
//        noThanksBtn.hidden = YES;
//        noThanksNarrowLineView.hidden = YES;
//        noThanksBtn.frame = CGRectMake((baseView.frame.size.width - 80)/2, webView.frame.size.height + webView.frame.origin.y + 10 , 80, 20);
//    }
//
    UIButton *tACButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    tACButton.frame = CGRectMake((baseView.frame.size.width - 140)/2, noThanksNarrowLineView.frame.size.height + noThanksNarrowLineView.frame.origin.y + 10 , 140, 20);
    [tACButton setTitle:@"Terms & Conditions" forState:UIControlStateNormal];
    [tACButton addTarget:self action:@selector(tAcButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [tACButton setTintColor:[ICSingletonManager colorFromHexString:@"#808080"]];
    [tACButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [baseView addSubview:tACButton];
    
    
    
//    if ([globals.contactSyncOrNot isEqualToString:@"YES"]) {
//        shareContactsButton.hidden = YES;
//        shareContactsNarrowLine.hidden = YES;
//        noThanksBtn.hidden = YES;
//        noThanksNarrowLineView.hidden = YES;
//         tACButton.frame = CGRectMake((baseView.frame.size.width - 140)/2, webView.frame.size.height + webView.frame.origin.y + 10 , 140, 20);
//
//    }
    if ([contactSyncOrNot isEqualToString:@"YES"]) {
        shareContactsButton.hidden = YES;
        shareContactsNarrowLine.hidden = YES;
        noThanksBtn.hidden = YES;
        noThanksNarrowLineView.hidden = YES;
        tACButton.frame = CGRectMake((baseView.frame.size.width - 140)/2, webView.frame.size.height + webView.frame.origin.y + 10 , 140, 20);
        
    }
    
    
    UIView *tAcNarrowLine = [[UIView alloc]initWithFrame:CGRectMake((baseView.frame.size.width - 140)/2, tACButton.frame.size.height + tACButton.frame.origin.y , 140, 1)];
    tAcNarrowLine.backgroundColor = [ICSingletonManager colorFromHexString:@"#808080"];
    [baseView addSubview:tAcNarrowLine];

    UIView *grayBaseView = [[UIView alloc]initWithFrame:CGRectMake(0,tAcNarrowLine.frame.size.height + tAcNarrowLine.frame.origin.y +15 +40 , baseView.frame.size.width,170 )];
    grayBaseView.backgroundColor = [ICSingletonManager colorFromHexString:@"#d9dadc"];
    [baseView addSubview:grayBaseView];
    
    UIImageView *voucherImgView = [[UIImageView alloc]initWithFrame:CGRectMake((baseView.frame.size.width - 200)/2, tAcNarrowLine.frame.size.height + tAcNarrowLine.frame.origin.y +15 , 200, 80)];
    voucherImgView.image = [UIImage imageNamed:@"ReferVoucher"];
    voucherImgView.userInteractionEnabled = YES;
    voucherImgView.layer.masksToBounds = YES;
    [baseView addSubview:voucherImgView];
    
   
    
    LoginManager *loginManage = [[LoginManager alloc]init];
    NSDictionary *dict = [loginManage isUserLoggedIn];
    if ([dict count]>0)
    {
        [dict valueForKey:@"Phone1"];
    }
    UILabel *referalCodeLbl  = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 190, 20)];
    referalCodeLbl.text = @"Your referral code";
    referalCodeLbl.userInteractionEnabled = YES;
    referalCodeLbl.textAlignment = NSTextAlignmentCenter;
    referalCodeLbl.textColor = [ICSingletonManager colorFromHexString:@"#808080"];
     referalCodeLbl.font = [UIFont systemFontOfSize:15];
    [voucherImgView addSubview:referalCodeLbl];
   
  //  ICSingletonManager *globals = [ICSingletonManager sharedManager];
   
    
    UILabel *mobileno  = [[UILabel alloc]initWithFrame:CGRectMake(5, referalCodeLbl.frame.size.height + referalCodeLbl.frame.origin.y + 5, 190, 20)];
    mobileno.text = self.myreferalcode;
    mobileno.textAlignment = NSTextAlignmentCenter;
    mobileno.font = [UIFont boldSystemFontOfSize:15];
     mobileno.userInteractionEnabled = YES;
    mobileno.textColor = [ICSingletonManager colorFromHexString:@"#808080"];
    [voucherImgView addSubview:mobileno];
    
    UILabel *clickTocopy  = [[UILabel alloc]initWithFrame:CGRectMake(5, mobileno.frame.size.height + mobileno.frame.origin.y + 5, 190, 20)];
    clickTocopy.text = @"(click to copy)";
    clickTocopy.textAlignment = NSTextAlignmentCenter;
    clickTocopy.textColor = [ICSingletonManager colorFromHexString:@"#808080"];
     clickTocopy.font = [UIFont systemFontOfSize:15];
     clickTocopy.userInteractionEnabled = YES;
    [voucherImgView addSubview:clickTocopy];
                            
    
        if ([dict count]>0)
        {
            [dict valueForKey:@"Phone1"];
          
            UITapGestureRecognizer *lpgr
            = [[UITapGestureRecognizer alloc]
               initWithTarget:self action:@selector(handleLongPress:)];
            [voucherImgView addGestureRecognizer:lpgr];
        }
    
//    UITextView *referaTxtView = [[UITextView alloc]init];
//    referaTxtView.frame =CGRectMake(5, 5, 190, 70);
//
//    referaTxtView.userInteractionEnabled = YES;
//    referaTxtView.scrollEnabled = NO;
//    referaTxtView.editable = NO;
//    referaTxtView.font = [UIFont systemFontOfSize:15];
//    referaTxtView.backgroundColor = [UIColor whiteColor];
//    referaTxtView.textAlignment = NSTextAlignmentCenter;
//    referaTxtView.textColor = [ICSingletonManager colorFromHexString:@"#808080"];
//    [voucherImgView addSubview:referaTxtView];
//
//    if ([dict count]>0)
//    {
//        [dict valueForKey:@"Phone1"];
//        referaTxtView.text = [NSString stringWithFormat:@"Your referral code\n%@ \n (click to copy)",[dict valueForKey:@"Phone1"]];
//        UITapGestureRecognizer *lpgr
//        = [[UITapGestureRecognizer alloc]
//           initWithTarget:self action:@selector(handleLongPress:)];
//        [referaTxtView addGestureRecognizer:lpgr];
//    }else{
//        referaTxtView.text = [NSString stringWithFormat:@"Your referral code\n \n (click to copy)"];
//    }
//
//
    
    
    shareViaBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    shareViaBtn.frame = CGRectMake((grayBaseView.frame.size.width - 100)/2, 60  , 100, 25);
    [shareViaBtn setTitle:@"Share Via" forState:UIControlStateNormal];
    [shareViaBtn addTarget:self action:@selector(shareViaButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [shareViaBtn setTintColor:[ICSingletonManager colorFromHexString:@"#808080"]];
    shareViaBtn.userInteractionEnabled = NO;
    
    [shareViaBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
    [grayBaseView addSubview:shareViaBtn];
    
    UIView *shareViaNarrowLine = [[UIView alloc]initWithFrame:CGRectMake((grayBaseView.frame.size.width - 80)/2, shareViaBtn.frame.size.height + shareViaBtn.frame.origin.y - 4 , 80, 1)];
    shareViaNarrowLine.backgroundColor = [ICSingletonManager colorFromHexString:@"#808080"];
    [grayBaseView addSubview:shareViaNarrowLine];
    
    
    UIButton *faceBookShareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    faceBookShareBtn.frame = CGRectMake((baseView.frame.size.width - 230)/2,shareViaNarrowLine.frame.size.height + shareViaNarrowLine.frame.origin.y +10,40, 40);
    [faceBookShareBtn setBackgroundImage:[UIImage imageNamed:@"FbShareImg"] forState:UIControlStateNormal];
    [faceBookShareBtn.titleLabel setFont:[UIFont systemFontOfSize:17.f]];
    [faceBookShareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal]; // SET the colour for
    // SET the values for your wishes
    [faceBookShareBtn addTarget:self action:@selector(faceBookshareViaButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [grayBaseView addSubview:faceBookShareBtn];
    
    UIButton *wattsUpShareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    wattsUpShareBtn.frame = CGRectMake(faceBookShareBtn.frame.origin.x + 40 + 20,shareViaNarrowLine.frame.size.height + shareViaNarrowLine.frame.origin.y +10,40, 40);
    [wattsUpShareBtn setBackgroundImage:[UIImage imageNamed:@"wattsUpShare"] forState:UIControlStateNormal];
    [wattsUpShareBtn.titleLabel setFont:[UIFont systemFontOfSize:17.f]];
    [wattsUpShareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal]; // SET the colour for
    // SET the values for your wishes
    [wattsUpShareBtn addTarget:self action:@selector(wattsUpshareViaButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [grayBaseView addSubview:wattsUpShareBtn];
    
    
    UIButton *twitterShareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    twitterShareBtn.frame = CGRectMake(wattsUpShareBtn.frame.origin.x + 40 + 20,shareViaNarrowLine.frame.size.height + shareViaNarrowLine.frame.origin.y +10,40, 40);
    [twitterShareBtn setBackgroundImage:[UIImage imageNamed:@"twitterShareBtn"] forState:UIControlStateNormal];
    [twitterShareBtn.titleLabel setFont:[UIFont systemFontOfSize:17.f]];
    [twitterShareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal]; // SET the colour for
    // SET the values for your wishes
    [twitterShareBtn addTarget:self action:@selector(twittershareViaButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [grayBaseView addSubview:twitterShareBtn];
    
    UIButton *otherShareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    otherShareBtn.frame = CGRectMake(twitterShareBtn.frame.origin.x + 40 + 20,shareViaNarrowLine.frame.size.height + shareViaNarrowLine.frame.origin.y +10,40, 40);
    [otherShareBtn setBackgroundImage:[UIImage imageNamed:@"otherShareBtn"] forState:UIControlStateNormal];
    [otherShareBtn.titleLabel setFont:[UIFont systemFontOfSize:17.f]];
    [otherShareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal]; // SET the colour for
    // SET the values for your wishes
    [otherShareBtn addTarget:self action:@selector(othershareViaButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [grayBaseView addSubview:otherShareBtn];

    UIButton *icanCashWorkButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [icanCashWorkButton setTitle:@"How icanCash works" forState:UIControlStateNormal];
    [icanCashWorkButton addTarget:self action:@selector(howicanCashBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [icanCashWorkButton setTintColor:[ICSingletonManager colorFromHexString:@"#808080"]];
    [icanCashWorkButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    
    icanCashWorkButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [grayBaseView addSubview:icanCashWorkButton];
    
    UIButton *balanceButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [balanceButton setTitle:@"View My Balance" forState:UIControlStateNormal];
    [balanceButton addTarget:self action:@selector(balanceButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [balanceButton setTintColor:[ICSingletonManager colorFromHexString:@"#808080"]];
    [balanceButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [grayBaseView addSubview:balanceButton];
    
    icanCashWorkButton.frame = CGRectMake(10, otherShareBtn.frame.size.height + otherShareBtn.frame.origin.y, 150, 30);
    balanceButton.frame = CGRectMake(grayBaseView.frame.size.width - 150,otherShareBtn.frame.size.height + otherShareBtn.frame.origin.y, 150,30);
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        baseView.frame = CGRectMake(0,0 , self.view.frame.size.width, grayBaseView.frame.size.height + grayBaseView.frame.origin.y);
        baseScrollView.contentSize = CGSizeMake(self.view.frame.size.width, baseView.frame.size.height);
        
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
-(CGFloat)getLabelHeight:(CGSize)labelSize string: (NSString *)string font: (UIFont *)font{
    
    CGSize size;
    
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize boundingBox = [string boundingRectWithSize:labelSize
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName:font}
                                              context:context].size;
    
    size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    
    return size.height;
}

-(void)howicanCashBtnTapped:(id)sender
{
    ReferAndEarnWeb *referAndEarnController = [self.storyboard instantiateViewControllerWithIdentifier:@"ReferAndEarnWeb"];
    
    [self.navigationController pushViewController:referAndEarnController animated:YES];
}
-(void)tcBaseViewDesignCheck
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
-(void)crossBtnTc:(id)sender
{
    _tcBaseView.hidden = YES;
}

-(void)termsConditionButtonTapped:(id)sender
{
    _tcBaseView.hidden = NO;
}

-(void)ContactSyncPOpup
{
    self.contactSyncPopupBaseView = [[UIView alloc]init];
    self.contactSyncPopupBaseView.backgroundColor = [UIColor whiteColor];
    self.contactSyncPopupBaseView.hidden = YES;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.contactSyncPopupBaseView.frame = CGRectMake((self.view.frame.size.width - 360)/2,self.topWhiteBaseView.frame.size.height + self.topWhiteBaseView.frame.origin.y  , 360, 700);
    }else{
        self.contactSyncPopupBaseView.frame = CGRectMake(0, self.topWhiteBaseView.frame.size.height + self.topWhiteBaseView.frame.origin.y + referAndEarnLbl.frame.size.height , self.view.frame.size.width, self.view.frame.size.height - (self.topWhiteBaseView.frame.size.height + self.topWhiteBaseView.frame.origin.y + referAndEarnLbl.frame.size.height ));
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
-(void)icsCashPopUp
{
    self.icsCashBaseView = [[UIView alloc]init];
    self.icsCashBaseView.backgroundColor = [UIColor whiteColor];
    if ([self.fromAllowContactPopup isEqualToString:@"YES"]) {
         self.icsCashBaseView.hidden  = NO;
    }else{
         self.icsCashBaseView.hidden  = YES;
    }
   
    [self.view addSubview:self.icsCashBaseView];
    
    UILabel *referAndEarnLbl = [[UILabel alloc]init];
    referAndEarnLbl.backgroundColor = [ICSingletonManager colorFromHexString:@"#001d3d"];
    referAndEarnLbl.text = @"Refer & Earn";
    referAndEarnLbl.textColor = [UIColor whiteColor];
    referAndEarnLbl.textAlignment = NSTextAlignmentCenter;
    referAndEarnLbl.font = [UIFont systemFontOfSize:30];
//    [_icsCashBaseView addSubview:referAndEarnLbl];
    
    UIImageView *giftImgView = [[UIImageView alloc]init];
    giftImgView.image = [UIImage imageNamed:@"giftImg"];
    [_icsCashBaseView addSubview:giftImgView];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [cancelBtn setTitle:@"X" forState:UIControlStateNormal];
    [cancelBtn setTintColor:[UIColor blackColor]];
    [cancelBtn addTarget:self action:@selector(icsCashCancelButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:24]];
    [_icsCashBaseView addSubview:cancelBtn];
    
    UITextView *congrtasLbl = [[UITextView alloc]init];
    congrtasLbl.textColor = [ICSingletonManager colorFromHexString:@"#808080"];
    congrtasLbl.text = @"Congratulations!";
    congrtasLbl.textAlignment = NSTextAlignmentCenter;
    congrtasLbl.font = [UIFont boldSystemFontOfSize:18];
    congrtasLbl.editable = NO;
    congrtasLbl.scrollEnabled = NO;
    [_icsCashBaseView addSubview:congrtasLbl];
    
    UILabel *canCashLbl = [[UILabel alloc]init];
    canCashLbl.textColor = [UIColor blackColor];
    canCashLbl.text = @"You got  ₹5,000 icanCash";
    canCashLbl.adjustsFontSizeToFitWidth = YES;
    canCashLbl.font = [UIFont boldSystemFontOfSize:18];
    canCashLbl.textAlignment = NSTextAlignmentCenter;
    canCashLbl.textColor = [ICSingletonManager colorFromHexString:@"#bd9854"];
    [_icsCashBaseView addSubview:canCashLbl];
    
    UILabel *syncContactLbl = [[UILabel alloc]init];
    syncContactLbl.textColor = [UIColor blackColor];
    syncContactLbl.text = @"You can start using your icanCash right away.\nBuy open voucher for luxury hotel stay and get";
    syncContactLbl.textAlignment = NSTextAlignmentCenter;
    syncContactLbl.textColor = [ICSingletonManager colorFromHexString:@"#666666"];
    [_icsCashBaseView addSubview:syncContactLbl];
    
    UIWebView *webViewIcs = [[UIWebView alloc]init];
    webViewIcs.userInteractionEnabled = NO;
    webViewIcs.scrollView.scrollEnabled = NO;
    NSString *htmlString = @"<html><head><style>;ul{list-style:none;padding: 1px 0px 0px 0px; }ul li {background-image: url(http://www.icanstay.com/Content/Home/images/rev-slider/dot.png);  background-repeat: no-repeat; background-position: 0 0px; padding: 0px 10px 12px 18px; background-size: 13px;font-size: 16px; color:#666666; line-height: 17px;}</style></head><body><ul><li>₹1,000 OFF on first purchase</li><li>+₹1,000 instant cashback into your icanstay account</li></ul></body></html>";
    
    [webViewIcs loadHTMLString:[NSString stringWithFormat:@"%@", htmlString ]baseURL:nil];
    [self.icsCashBaseView addSubview:webViewIcs];
    
    GradientButton *buyVoucher =  [[GradientButton alloc]init];
    [buyVoucher setTitle:@"BUY VOUCHER" forState:UIControlStateNormal];
    [buyVoucher setTintColor:[ICSingletonManager colorFromHexString:@"#666666"]];
    [buyVoucher useRedDeleteStyle];
    [buyVoucher addTarget:self action:@selector(buyVoucherTapped:) forControlEvents:UIControlEventTouchUpInside];
    [_icsCashBaseView addSubview:buyVoucher];
    
   
    
    UIButton *exitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [exitButton setTitle:@"HOME" forState:UIControlStateNormal];
    [exitButton addTarget:self action:@selector(homeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [exitButton setTintColor:[ICSingletonManager colorFromHexString:@"#666666"]];
    [exitButton.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [exitButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.icsCashBaseView addSubview:exitButton];
    
    UIButton *balanceButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
   
    [balanceButton setTitle:@"VIEW MY BALANCE" forState:UIControlStateNormal];
    [balanceButton addTarget:self action:@selector(balanceButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [balanceButton setTintColor:[ICSingletonManager colorFromHexString:@"#666666"]];
    [balanceButton.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
      [balanceButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.icsCashBaseView addSubview:balanceButton];
    
   
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.icsCashBaseView.frame = CGRectMake((self.view.frame.size.width - 360)/2, _topWhiteBaseView.frame.size.height + _topWhiteBaseView.frame.origin.y , 360, 700);
        referAndEarnLbl.frame = CGRectMake(0, 0, self.icsCashBaseView.frame.size.width, 0);
        cancelBtn.frame = CGRectMake(self.icsCashBaseView.frame.size.width - 50, referAndEarnLbl.frame.size.height + referAndEarnLbl.frame.origin.y +5, 20, 20);
        giftImgView.frame = CGRectMake(100,referAndEarnLbl.frame.origin.y + referAndEarnLbl.frame.size.height +10 ,self.icsCashBaseView.frame.size.width - 200, 150);
        congrtasLbl.frame = CGRectMake(10, giftImgView.frame.size.height + giftImgView.frame.origin.y + 10,self.icsCashBaseView.frame.size.width - 20 , 60);
        syncContactLbl.frame = CGRectMake(5, congrtasLbl.frame.size.height + congrtasLbl.frame.origin.y + 10, self.icsCashBaseView.frame.size.width - 10, 60);
        syncContactLbl.numberOfLines = 2;
        syncContactLbl.lineBreakMode = NSLineBreakByWordWrapping;
        webViewIcs.frame = CGRectMake(20,syncContactLbl.frame.size.height + syncContactLbl.frame.origin.y + 5 , self.icsCashBaseView.frame.size.width - 40, 80);
        buyVoucher.frame = CGRectMake((_icsCashBaseView.frame.size.width - 200)/2,webViewIcs.frame.size.height + webViewIcs.frame.origin.y + 10 , 200, 30);
      
        exitButton.frame = CGRectMake(10,buyVoucher.frame.size.height + buyVoucher.frame.origin.y + 20 , 60, 25);
        balanceButton.frame = CGRectMake(self.icsCashBaseView.frame.size.width - 180 ,buyVoucher.frame.size.height + buyVoucher.frame.origin.y + 20 , 170, 25);
        
    }else{
      self.icsCashBaseView.frame = CGRectMake(0, _topWhiteBaseView.frame.size.height + _topWhiteBaseView.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height - (_topWhiteBaseView.frame.size.height + _topWhiteBaseView.frame.origin.y));
        referAndEarnLbl.frame = CGRectMake(0, 0, self.icsCashBaseView.frame.size.width, 0);
        cancelBtn.frame = CGRectMake(self.icsCashBaseView.frame.size.width - 50, referAndEarnLbl.frame.size.height + referAndEarnLbl.frame.origin.y +5, 30, 30);
        giftImgView.frame = CGRectMake((self.icsCashBaseView.frame.size.width - 100)/2,referAndEarnLbl.frame.origin.y + referAndEarnLbl.frame.size.height + 10 ,100, 100);
        congrtasLbl.frame = CGRectMake(10, giftImgView.frame.size.height + giftImgView.frame.origin.y + 20,self.icsCashBaseView.frame.size.width - 20 , 30);
        canCashLbl.frame =  CGRectMake(10, congrtasLbl.frame.size.height + congrtasLbl.frame.origin.y ,self.icsCashBaseView.frame.size.width - 20 , 30);
        syncContactLbl.frame = CGRectMake(10, canCashLbl.frame.size.height + canCashLbl.frame.origin.y + 35, self.icsCashBaseView.frame.size.width - 10, 50);
        syncContactLbl.numberOfLines = 2;
        syncContactLbl.lineBreakMode = NSLineBreakByWordWrapping;
        syncContactLbl.font = [UIFont systemFontOfSize:16];
        webViewIcs.frame = CGRectMake(5,syncContactLbl.frame.size.height + syncContactLbl.frame.origin.y + 5 , self.icsCashBaseView.frame.size.width - 10, 80);
        buyVoucher.frame = CGRectMake((_icsCashBaseView.frame.size.width - 200)/2,webViewIcs.frame.size.height + webViewIcs.frame.origin.y + 35 , 200, 50);
        exitButton.frame = CGRectMake(10,self.icsCashBaseView.frame.size.height - 50 , 60, 25);
        balanceButton.frame = CGRectMake(self.icsCashBaseView.frame.size.width - 180 ,self.icsCashBaseView.frame.size.height - 50  , 170, 25);
    }
}


#pragma mark Ipad Views


#pragma mark Functionality Button
-(void)noThanksButtonTapped:(id)sender
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
-(void)homeButtonTapped:(id)sender
{
    _icsCashBaseView.hidden =YES;
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
-(void)balanceButtonTapped:(id)sender
{
    _icsCashBaseView.hidden = YES;
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
    CancashController *CancashController = [self.storyboard instantiateViewControllerWithIdentifier:@"CancashController"];
    
    
    globals.canCashFromRefer = @"YES";
    
    [self.navigationController pushViewController:CancashController animated:YES];
    
}

-(void)wattsUpshareViaButtonTapped:(id)sender
{
    
    

    NSString * msg = [NSString stringWithFormat:@"Use %@ as referral code to register & get your Rs.1,000 icanCash. You can earn up to Rs.1 Lakh icanCash from one of the most rewarding referral programme. Download free icanstay app now https://itunes.apple.com/in/app/icanstay/id1186747648?mt=8", self.myreferalcode];
    NSString * urlWhats = [NSString stringWithFormat:@"whatsapp://send?text=%@",msg];
    NSURL * whatsappURL = [NSURL URLWithString:[urlWhats stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    if ([[UIApplication sharedApplication] canOpenURL: whatsappURL])
    {
        [[UIApplication sharedApplication] openURL: whatsappURL];
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"WhatsApp not installed." message:@"Your device has no WhatsApp installed." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)faceBookshareViaButtonTapped:(id)sender
{
  
    
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.icanstay.com/app-store?Code=%@", self.myreferalcode]];
    [FBSDKShareDialog showFromViewController:self
                                 withContent:content
                                    delegate:nil];
    

}
-(void)othershareViaButtonTapped:(id)sender
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        LoginManager *loginManage = [[LoginManager alloc]init];
        NSDictionary *dict = [loginManage isUserLoggedIn];
        if ([dict count]>0)
        {
            [dict valueForKey:@"Phone1"];
        }
        
        
        NSArray * activityItems = @[[NSString stringWithFormat:@"Use %@ as referral code to register & get your Rs.1,000 icanCash. You can earn up to Rs.1 Lakh icanCash from one of the most rewarding referral programme. Download free icanstay app now https://itunes.apple.com/in/app/icanstay/id1186747648?mt=8", self.myreferalcode]];
        NSArray * applicationActivities = nil;
        NSArray * excludeActivities = @[UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard, UIActivityTypePostToWeibo, UIActivityTypePrint, UIActivityTypeMessage];
        
        UIActivityViewController * activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:applicationActivities];
        activityController.excludedActivityTypes = excludeActivities;
        
        [self presentViewController:activityController animated:YES completion:nil];
        
    }
    //for iPad
    else {
        // Change Rect as required
        LoginManager *loginManage = [[LoginManager alloc]init];
        NSDictionary *dict = [loginManage isUserLoggedIn];
        if ([dict count]>0)
        {
            [dict valueForKey:@"Phone1"];
        }
        NSArray * activityItems = @[[NSString stringWithFormat:@"Use %@ as referral code to register & get your Rs.1,000 icanCash. You can earn up to Rs.1 Lakh icanCash from one of the most rewarding referral programme. Download free icanstay app now https://itunes.apple.com/in/app/icanstay/id1186747648?mt=8", self.myreferalcode]];
        NSArray * applicationActivities = nil;
        NSArray * excludeActivities = @[UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard, UIActivityTypePostToWeibo, UIActivityTypePrint, UIActivityTypeMessage];
        
        UIActivityViewController * activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:applicationActivities];
        activityController.excludedActivityTypes = excludeActivities;
        
        NSLog(@"iPad");
        activityController.popoverPresentationController.sourceView = self.view;
        //   activityController.popoverPresentationController.sourceRect = self.frame;
        UIPopoverController * popover = [[UIPopoverController alloc] initWithContentViewController:activityController];
        popover.delegate = self;
        //      [popover presentPopoverFromBarButtonItem:shareViaBtn  permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
        [popover presentPopoverFromRect:CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/4, 0, 0)inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        //    [self presentViewController:activityController animated:YES completion:nil];
        
    }
    
}
-(void)twittershareViaButtonTapped:(id)sender
{
    LoginManager *loginManage = [[LoginManager alloc]init];
    NSDictionary *dict = [loginManage isUserLoggedIn];
    if ([dict count]>0)
    {
        [dict valueForKey:@"Phone1"];
    }
  NSString *url=  [NSString stringWithFormat:@"Use %@ as referral code to register & get your Rs.1,000 icanCash. You can earn up to Rs.1 Lakh icanCash from one of the most rewarding referral programme. Download free icanstay app now https://itunes.apple.com/in/app/icanstay/id1186747648?mt=8", self.myreferalcode];
    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
        if (session) {
            TWTRComposer *composer = [[TWTRComposer alloc] init];
            
            [composer setText:url];
           
            
            // Called from a UIViewController
            [composer showFromViewController:self completion:^(TWTRComposerResult result) {
                if (result == TWTRComposerResultCancelled) {
                    NSLog(@"Tweet composition cancelled");
                }
                else {
                    NSLog(@"Sending Tweet!");
                }
            }];
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"No Twitter Accounts Available" message:@"You must log in before presenting a composer." preferredStyle:UIAlertControllerStyleAlert];
          //  [self presentViewController:alert animated:YES completion:nil];
        }
    }];
   
    
//    if ([[Twitter sharedInstance].sessionStore hasLoggedInUsers]) {
//        TWTRComposerViewController *composer = [TWTRComposerViewController emptyComposer];
//        [fromController presentViewController:composer animated:YES completion:nil];
//    } else {
//        [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
//            if (session) {
//                TWTRComposerViewController *composer = [TWTRComposerViewController emptyComposer];
//                [fromController presentViewController:composer animated:YES completion:nil];
//            } else {
//                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"No Twitter Accounts Available" message:@"You must log in before presenting a composer." preferredStyle:UIAlertControllerStyleAlert];
//                [self presentViewController:alert animated:YES completion:nil];
//            }
//        }];
//    }
//
    
//    SLComposeViewController *socialController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
//
//    // present controller
//    [socialController setInitialText:@"Hi, use my code %@ to signup and get Rs1000 cancash. click  https://itunes.apple.com/in/app/icanstay/id1186747648?mt=8 to download the icanstay app."];
//
//    [self presentViewController:socialController animated:YES completion:nil];
//
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
//        LoginManager *loginManage = [[LoginManager alloc]init];
//        NSDictionary *dict = [loginManage isUserLoggedIn];
//        if ([dict count]>0)
//        {
//            [dict valueForKey:@"Phone1"];
//        }
//        NSArray * activityItems = @[[NSString stringWithFormat:@"Hi, use my code %@ to signup and get Rs1000 cancash. click  https://itunes.apple.com/in/app/icanstay/id1186747648?mt=8 to download the icanstay app.",[dict valueForKey:@"Phone1"]]];
//        NSArray * applicationActivities = nil;
//        NSArray * excludeActivities = @[UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard, UIActivityTypePostToWeibo, UIActivityTypePrint, UIActivityTypeMessage];
//
//        UIActivityViewController * activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:applicationActivities];
//        activityController.excludedActivityTypes = excludeActivities;
//
//        [self presentViewController:activityController animated:YES completion:nil];
//
//    }
//    //for iPad
//    else {
//        // Change Rect as required
//        LoginManager *loginManage = [[LoginManager alloc]init];
//        NSDictionary *dict = [loginManage isUserLoggedIn];
//        if ([dict count]>0)
//        {
//            [dict valueForKey:@"Phone1"];
//        }
//        NSArray * activityItems = @[[NSString stringWithFormat:@"Hi, use my code %@ to signup and get Rs1000 cancash. click  https://itunes.apple.com/in/app/icanstay/id1186747648?mt=8 to download the icanstay app.",[dict valueForKey:@"Phone1"]]];
//        NSArray * applicationActivities = nil;
//        NSArray * excludeActivities = @[UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard, UIActivityTypePostToWeibo, UIActivityTypePrint, UIActivityTypeMessage];
//
//        UIActivityViewController * activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:applicationActivities];
//        activityController.excludedActivityTypes = excludeActivities;
//
//        NSLog(@"iPad");
//        activityController.popoverPresentationController.sourceView = self.view;
//        //   activityController.popoverPresentationController.sourceRect = self.frame;
//        UIPopoverController * popover = [[UIPopoverController alloc] initWithContentViewController:activityController];
//        popover.delegate = self;
//        //      [popover presentPopoverFromBarButtonItem:shareViaBtn  permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
//
//        [popover presentPopoverFromRect:CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/4, 0, 0)inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
//        //    [self presentViewController:activityController animated:YES completion:nil];
//
//    }
    
}
//-(void)crossBtnTc:(id)sender
//{
//    _tcBaseView.hidden = YES;
//}
-(void)tAcButtonTapped:(id)sender
{
    _tcBaseView.hidden = NO;
}


-(void)buyVoucherTapped:(id)sender
{
   
  
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
    globals.isFromMenuForBuyVoucher = false;
    
    BuyCouponViewController *buyCoupon =[self.storyboard instantiateViewControllerWithIdentifier:@"BuyCouponViewController"];
    [self.navigationController pushViewController:buyCoupon animated:YES];
    
      self.icsCashBaseView.hidden = YES;
       
   
}
-(void)bookNowBtnTapped:(id)sender
{
    
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
    globals.isFromMenuLastMinuteDeal = @"YES";
    
    LastMinuteViewController *lastMinuteScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"LastMinuteViewController"];
    [self.navigationController pushViewController:lastMinuteScreen animated:YES];
      self.icsCashBaseView.hidden = YES;
}
-(void)icsCashCancelButtonTapped:(id)sender
{
    _icsCashBaseView.hidden = YES;

}
-(void)continueButtonTapped:(id)sender
{
    self.contactSyncPopupBaseView.hidden = YES;
}


-(void)handleLongPress:(UITapGestureRecognizer *)gestureRecognizer
{
    LoginManager *loginManage = [[LoginManager alloc]init];
    NSDictionary *dict = [loginManage isUserLoggedIn];
    if ([dict count]>0)
    {
        [dict valueForKey:@"Phone1"];
    }
    UIPasteboard *pb = [UIPasteboard generalPasteboard];
    [pb setString:[dict valueForKey:@"Phone1"]];
   
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"Copied to clipBoard." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}
-(void)shareViaButtonTapped:(id)sender
{
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        LoginManager *loginManage = [[LoginManager alloc]init];
        NSDictionary *dict = [loginManage isUserLoggedIn];
        if ([dict count]>0)
        {
            [dict valueForKey:@"Phone1"];
        }
         NSArray * activityItems = @[[NSString stringWithFormat:@"Hi, use my code %@ to signup and get Rs1000 cancash. click  http://www.icanstay.com/app-store to download the icanstay app.",[dict valueForKey:@"Phone1"]]];
        NSArray * applicationActivities = nil;
        NSArray * excludeActivities = @[UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard, UIActivityTypePostToWeibo, UIActivityTypePrint, UIActivityTypeMessage];
        
        UIActivityViewController * activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:applicationActivities];
        activityController.excludedActivityTypes = excludeActivities;
        
        [self presentViewController:activityController animated:YES completion:nil];
        
    }
    //for iPad
    else {
        // Change Rect as required
        LoginManager *loginManage = [[LoginManager alloc]init];
        NSDictionary *dict = [loginManage isUserLoggedIn];
        if ([dict count]>0)
        {
            [dict valueForKey:@"Phone1"];
        }
         NSArray * activityItems = @[[NSString stringWithFormat:@"Hi, use my code %@ to signup and get Rs1000 cancash. click  http://www.icanstay.com/app-store to download the icanstay app.",[dict valueForKey:@"Phone1"]]];
        NSArray * applicationActivities = nil;
        NSArray * excludeActivities = @[UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard, UIActivityTypePostToWeibo, UIActivityTypePrint, UIActivityTypeMessage];
        
        UIActivityViewController * activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:applicationActivities];
        activityController.excludedActivityTypes = excludeActivities;
        
                                         NSLog(@"iPad");
                                         activityController.popoverPresentationController.sourceView = self.view;
         //   activityController.popoverPresentationController.sourceRect = self.frame;
    UIPopoverController * popover = [[UIPopoverController alloc] initWithContentViewController:activityController];
        popover.delegate = self;
  //      [popover presentPopoverFromBarButtonItem:shareViaBtn  permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
      
        [popover presentPopoverFromRect:CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/4, 0, 0)inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
 //    [self presentViewController:activityController animated:YES completion:nil];
        
    }
  
}

-(void)shareContactButtonTapped:(id)sender
{
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
    globals.contactSyncOrNot = @"YES";
    self.icsCashBaseView.hidden = NO;
    
    self.contactSyncPopupBaseView.hidden = YES;
    shareContactsButton.hidden = YES;
    shareContactsNarrowLine.hidden = YES;
    self.icsCashBaseView.hidden  = NO;
    noThanksBtn.hidden = YES;
    noThanksNarrowLineView.hidden = YES;
    
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
                    CNContactStore *store = [[CNContactStore alloc] init];
                    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                        if (granted == YES)
                        {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                //Your main thread code goes in here
                                 self.contactSyncPopupBaseView.hidden = YES;
                            });
                            
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
                                         shareContactsButton.hidden = YES;
                                         shareContactsNarrowLine.hidden = YES;
                                         self.icsCashBaseView.hidden  = NO;
                                         noThanksBtn.hidden = YES;
                                         noThanksNarrowLineView.hidden = YES;
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

- (void)startServiceToGeticanCash
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
-(void)backButtonTapped:(id)sender
{
  //   [self.navigationController popViewControllerAnimated:YES];
    
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
    
    
    if ([globals.isFromMenuLastMinuteDeal isEqualToString:@"YES"]) {
        globals.isFromMenuLastMinuteDeal = @"NO";
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    }
  
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

@end
