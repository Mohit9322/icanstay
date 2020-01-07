//
//  BuyCouponViewController.m
//  ICanStay
//
//  Created by Christina Masih on 22/03/16.
//  Copyright © 2016 verticallogics. All rights reserved.
//

#import "BuyCouponViewController.h"
#import "LoginManager.h"
#import "AFNetworking.h"
#import "NSDictionary+JsonString.h"
#import "MBProgressHud.h"
#import "NSString+NSString_Extended.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import <QuartzCore/QuartzCore.h>
#import "HomeScreenController.h"
#import "SideMenuController.h"
#import "UITextField+EmptyText.h"
#import "NSString+Validation.h"
#import "AppDelegate.h"
#import <CCMPopup/CCMPopupTransitioning.h>
#import <MoEngage.h>
#import "MyWishlistViewController.h"
#import "MapScreen.h"
#import "MyCouponViewController.h"
#import "GradientButton.h"

#define kCouponCount                        0
#define ACCEPTABLE_CHARACTERS @"0123456789"
@interface BuyCouponViewController ()<MOInAppDelegate>
{
    NSString *orderID;
    BOOL isff;
    int roomCount;
    BOOL isTermforReg ,isRegButtonTapped;
    BOOL isOfferNewsLetter, isWouldGetaCall;
    IBOutlet UIButton *btn_DisAgree;
    IBOutlet UIButton *btn_Agree;
    
        UIViewController *V2;
        UIButton      *leisureBtn;
        UIButton      *bussinessBtn;
        UIButton      *otherBtn;
        UIView        *baseView;
        UIWebView     * PrWebview;
    UIViewController *paymentController;
    int cancashAmountAvailable;
    UILabel *totalAmountPriceLbl;
    UILabel *discountPriceLbl;
    UILabel *payPriceLbl;
     UILabel *sbiPriceLbl;
    int voucherAmount;
}
@property (strong, nonatomic) IBOutlet UIView *buyVoucherBtnBaseView;
@property (strong, nonatomic) IBOutlet UIView *loginAndGuestBaseView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UILabel *lblPriceCoupon;
@property (weak, nonatomic) IBOutlet UILabel *lblCouponValidity;
@property (strong, nonatomic) IBOutlet UIButton *popupCancelBtn;
@property (strong, nonatomic) IBOutlet UIButton *popupConfmBtn;
@property (weak, nonatomic) IBOutlet UILabel *lblCouponName;
- (IBAction)btnMaleRadioBtnTapped:(id)sender;
- (IBAction)btnFemaleRadioBtnTapped:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnRadioMale;
@property (weak, nonatomic) IBOutlet UIButton *btnRadioFemale;

@property (weak, nonatomic) IBOutlet UIButton *btnCheckboxTermsCondition;
@property (weak, nonatomic) IBOutlet UIButton *btnCheckboxSendNotifications;

- (IBAction)btnCheckboxTermConditionTapped:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constrainstHeightSendNotifications;
- (IBAction)btnClickHereToBuyCouponForFamilyMemberTapped:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *icanCashBaseView;
@property (strong, nonatomic) IBOutlet UIButton *icanCashChkBoxBtn;
@property (strong, nonatomic) IBOutlet UILabel *canCashAmountAvail;

- (IBAction)btnCheckBoxSendNotificationsTapped:(id)sender;
@property (nonatomic,strong)NSDictionary *dictFromServer;

@property (weak, nonatomic) IBOutlet UIView *viewPopUp;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightManageIcanCash;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightforTermVoucher;
@property (strong, nonatomic) IBOutlet UIWebView *txtView_TermVoucher;
@property (weak, nonatomic) IBOutlet UIView *viewBlackTransparent;
- (IBAction)btnShowTermsCondition:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *buyVoucherBtn;

@property (weak, nonatomic) IBOutlet UITextView *txtView;

@property (weak, nonatomic) IBOutlet UILabel *lblHeaderPopUp;
- (IBAction)btnAgreeTapped:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnDisagreeTapped;

@property BOOL isTermsConditionAccepted;

@property (weak, nonatomic) IBOutlet UIView *viewConfirmMobile;
@property (weak, nonatomic) IBOutlet UITextField *txtConfirmMobileNumber;

- (IBAction)btnCancelconfirmMobileTapped:(id)sender;
- (IBAction)btnConfirmMobileNumberTapped:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *lblCouponValidFrom;
@property (weak, nonatomic) IBOutlet UILabel *lblCouponValidTill;
@property (weak, nonatomic) IBOutlet UILabel *lblGiftCouponText;

@property (strong, nonatomic) IBOutlet UIView *viewAfterLogin;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *loginHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *GenderHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *notificationViewHeight;
@property (nonatomic,copy)NSString *strGender;
@property (nonatomic,copy)NSString *strCancash;
@property (nonatomic,copy)NSString *strSbi;
// For Registration Form
@property (strong, nonatomic) IBOutlet UIView *view_Registration;

@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;
@property (weak, nonatomic) IBOutlet UITextField *txtLastName;
@property (weak, nonatomic) IBOutlet UITextField *txtEmailId;
@property (weak, nonatomic) IBOutlet UITextField *txtMobileNum;
//@property (nonatomic,copy)  NSString *strGender;
//@property (nonatomic,strong)   NSDictionary *dictFromServer;
@property (weak, nonatomic) IBOutlet UIButton *btnGenderMale;
@property (weak, nonatomic) IBOutlet UIButton *btnGenderFemale;

@property (strong, nonatomic) IBOutlet UIImageView *img_Check_Offers;
@property (strong, nonatomic) IBOutlet UIImageView *img_GetaCall;

@property (strong, nonatomic) IBOutlet UIButton *btn_ContinueGuest;
@property (strong, nonatomic) IBOutlet UIButton *btn_LogInContinue;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *Height_RegistrationView;

// For Log - In & Continue
@property (strong, nonatomic) IBOutlet UIView *view_LoginForm;
@property (strong, nonatomic) IBOutlet UITextField *txt_MobileNumb;
@property (strong, nonatomic) IBOutlet UITextField *txt_Password;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *height_LoginForm;
@property (strong, nonatomic) IBOutlet UIView *viewForget;
@property (strong, nonatomic) IBOutlet UITextField *txt_ForgetMobNumber;
@property (nonatomic, strong) GradientButton *NewBtn;
@property (nonatomic, strong) GradientButton *loginBtn;
@property (nonatomic, strong) GradientButton *guestBtn;
@property (nonatomic, strong) GradientButton *buyVoucherRegistartionBtn;
@property (nonatomic, strong) GradientButton *buyVoucherLoginBtn;


@end

@implementation BuyCouponViewController

- (void)viewDidLoad {
  
    [[MoEngage sharedInstance]handleInAppMessage];
    [MoEngage sharedInstance].delegate = self;
 //   [[MoEngage sharedInstance] dontShowInAppInViewController:self];
    [super viewDidLoad];
     DLog(@"DEBUG-VC");
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    [tracker set:kGAIScreenName value:@"Buy Voucher"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    // Do any additional setup after loading the view.
    
    [self.sbiChkBoxBtn addTarget:self action:@selector(sbiChkBoxBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
  
    self.sbiPayOffLbl.textColor = [ICSingletonManager colorFromHexString:@"#bd9854"];
    
    [self.icanCashChkBoxBtn addTarget:self action:@selector(icanCashChkBoxBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    self.canCashAmountAvail.textColor = [ICSingletonManager colorFromHexString:@"#bd9854"];
   
    self.strCancash = @"YES";
    self.strSbi = @"NO";
    [self performSelector:@selector(LoadViewDidLoadwithSomeDelay) withObject:self afterDelay:0.1];
    
}



-(void)icanCashChkBoxBtnTapped:(id)sender
{
    if ([self.strCancash isEqualToString:@"NO"]) {
        self.strCancash = @"YES";
        [self.icanCashChkBoxBtn setBackgroundImage:[UIImage imageNamed:@"checkbox_selected"] forState:UIControlStateNormal];
    }else{
        self.strCancash = @"NO";
        [self.icanCashChkBoxBtn setBackgroundImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
    }
   
}
-(void)sbiChkBoxBtnTapped:(id)sender
{
      if ([self.strSbi isEqualToString:@"NO"]) {
          self.strSbi = @"YES";
          
          [self.sbiChkBoxBtn setBackgroundImage:[UIImage imageNamed:@"checkbox_selected"] forState:UIControlStateNormal];
      }else{
          self.strSbi = @"NO";
          
          [self.sbiChkBoxBtn setBackgroundImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
      }

    
  
}
-(void)viewDidAppear:(BOOL)animated
{
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        self.sbiPayOffLbl.font = [UIFont systemFontOfSize:17];
         self.canCashAmountAvail.font = [UIFont systemFontOfSize:17];
        
    }else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        self.sbiPayOffLbl.lineBreakMode = NSLineBreakByWordWrapping;
        self.sbiPayOffLbl.numberOfLines = 2;
        
        self.sbiPayOffLbl.font = [UIFont systemFontOfSize:13];
         self.canCashAmountAvail.font = [UIFont systemFontOfSize:13];
        
    }
     LoginManager *login = [[LoginManager alloc]init];
    if ([[login isUserLoggedIn] count] >0) {
        
        /************** when icanscash not hidden ***************/
//        _heightforTermVoucher.constant = 370;
//        _icanCashBaseView.hidden = NO;
//        _heightManageIcanCash.constant = 370;
        self.scrollview.contentSize = CGSizeMake(self.view.frame.size.width, 850);
        /************** when icanscash not hidden ***************/
        
        //            /************** when icanscash  hidden ***************/
        //            _heightforTermVoucher.constant = paragraphRect.size.height+170;
        //            _icanCashBaseView.hidden = YES;
        //            _heightManageIcanCash.constant = 370;
        //             /************** when icanscash  hidden ***************/
    }
    
}
// The enum InAppWidget is for the different types of widgets which can be clicked in the In-App.
-(void)inAppClickedForWidget:(InAppWidget)widget screenName:(NSString*)screenName andDataDict:(NSDictionary *)dataDict{
    // Here the dataDict will have the screen name and the key value pairs.
}

//This delegate will be called when an In-App is shown. You can use this to ensure not showing alerts or pop ups of your own at the same time.
-(void)inAppShownWithCampaignID:(NSString*)campaignID{
    
}
-(void)LoadViewDidLoadwithSomeDelay{
    isOfferNewsLetter = YES;
    isWouldGetaCall = YES;
    
    UITapGestureRecognizer *singleTapOwner = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(imageOwnerTapped:)];
    singleTapOwner.numberOfTapsRequired = 1;
    singleTapOwner.cancelsTouchesInView = YES;
    [_viewBlackTransparent addGestureRecognizer:singleTapOwner];
    
    //For Registration Form
    [self addPaddingToTextFields];
    //    self.scrollview.scrollEnabled = YES;
    LoginManager *login = [[LoginManager alloc]init];
    if ([[login isUserLoggedIn] count]>0)
    {
        _buyVoucherBtn.hidden = NO;
        _view_Registration.hidden = YES;
        _Height_RegistrationView.constant = 0;
        _height_LoginForm.constant = 0;
        _view_LoginForm.hidden = YES;
        _btn_ContinueGuest.hidden = YES;
        _btn_LogInContinue.hidden = YES;
        _loginHeight.constant = 185;
        _GenderHeight.constant = 50;
        _notificationViewHeight.constant = 0;
        self.loginAndGuestBaseView.hidden = YES;
        self.buyVoucherBtnBaseView.hidden = NO;
     
    }
    else{
        _viewAfterLogin.hidden = YES;
   //     self.scrollview.scrollEnabled = NO;
        _view_Registration.hidden = YES;
        //        _Height_RegistrationView.constant = 0;
        //        _height_LoginForm.constant = 0;
        _view_LoginForm.hidden = YES;
        _buyVoucherBtn.hidden = YES;
        _loginHeight.constant = 0;
        _GenderHeight.constant = 0;
        _notificationViewHeight.constant = 0;
        self.loginAndGuestBaseView.hidden = NO;
        self.buyVoucherBtnBaseView.hidden = YES;
//         _heightManageIcanCash.constant = 240;
//        _icanCashBaseView.hidden = YES;
    }
    NSNumberFormatter *numberFormat = [[NSNumberFormatter alloc] init];
    numberFormat.usesGroupingSeparator = YES;
    numberFormat.groupingSeparator = @",";
    numberFormat.groupingSize = 3;
    
    LoginManager *loginManage = [[LoginManager alloc]init];
    NSDictionary *dict = [loginManage isUserLoggedIn];
    cancashAmountAvailable = 0;
      ICSingletonManager *globals = [ICSingletonManager sharedManager];
    NSString *stringWithoutSpaces = [globals.userCancashAmountAvailable stringByReplacingOccurrencesOfString:@"," withString:@""];
    if ([globals.firstTimeVoucherPurchase isEqualToString:@"YES"]) {
        if ([dict count] > 0) {
            if ([stringWithoutSpaces intValue] >= 300) {
                
                cancashAmountAvailable = 300;
                
            }else if ([stringWithoutSpaces intValue] < 300)
            {
                
                cancashAmountAvailable = [stringWithoutSpaces intValue];
                
            }
        }else if ([  stringWithoutSpaces intValue] == 0){
            cancashAmountAvailable = 0;
            
        }
    }else{
        
        if ([dict count] > 0) {
            if ([stringWithoutSpaces intValue] >= 1000) {
                
                cancashAmountAvailable = 1000;
                
            }else if ([stringWithoutSpaces intValue] < 1000)
            {
                
                cancashAmountAvailable = [stringWithoutSpaces intValue];
                
            }
        }else if ([  stringWithoutSpaces intValue] == 0){
            cancashAmountAvailable = 0;
        }
    }
    
    int amountPaid = 2999 - cancashAmountAvailable - 1000;
    NSString * amountformat2 = [numberFormat stringFromNumber: [NSNumber numberWithInt:amountPaid]];
     NSString * amountformat1 = [numberFormat stringFromNumber: [NSNumber numberWithInt:cancashAmountAvailable]];
    NSString *str1 = [NSString stringWithFormat:@"In addition to the superb price of ₹2,999 to stay in Luxury hotels all over India. You can use ₹%@ icanCash as part payment.", amountformat1];
    NSString *str2 = [NSString stringWithFormat:@"You get ₹1,000 Cashback in your icanstay account Effective price for this transaction ₹%@ only.", amountformat2];
    
    NSString *htmlString =[NSString stringWithFormat:@"<html><head><style>ul{list-style:none;padding: 1px 0px 0px 0px; }ul li {  background-repeat: no-repeat; background-position: 0 0px;  background-size: 13px;font-size: 18px; color:#555;  line-height: 20px;}</style></head><body><ul><li>%@</br></br></li><li>%@</li></ul></body></html>", str1,str2];
    NSAttributedString *attributedString = [[NSAttributedString alloc]
                                            initWithData: [htmlString dataUsingEncoding:NSUnicodeStringEncoding]
                                            options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                            documentAttributes: nil
                                            error: nil
                                            ];
    CGSize size = CGSizeMake(self.view.frame.size.width-30, CGFLOAT_MAX);
    CGRect paragraphRect =     [attributedString boundingRectWithSize:size
                                                              options:(NSStringDrawingUsesLineFragmentOrigin)
                                                              context:nil];
    [_txtView_TermVoucher loadHTMLString:[ICSingletonManager getStringValue:htmlString] baseURL:nil];
    _txtView_TermVoucher.scrollView.scrollEnabled = NO;
    
    _txtView_TermVoucher.frame = CGRectMake(0, 0, _txtView_TermVoucher.frame.size.width, paragraphRect.size.height+10);
 
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if ([[login isUserLoggedIn] count] >0) {
            _heightforTermVoucher.constant = paragraphRect.size.height+140;
            _icanCashBaseView.hidden = NO;
            _heightManageIcanCash.constant = 300;
        }else{
            _heightforTermVoucher.constant = paragraphRect.size.height+120;
            _icanCashBaseView.hidden = YES;
            _heightManageIcanCash.constant = 200;
        }
    }else{
        if ([[login isUserLoggedIn] count] >0) {
            
            /************** when icanscash not hidden ***************/
            _heightforTermVoucher.constant = paragraphRect.size.height+370;
            _icanCashBaseView.hidden = NO;
            _heightManageIcanCash.constant = 370;
     //       self.scrollview.contentSize = CGSizeMake(self.view.frame.size.width, 2000);
             /************** when icanscash not hidden ***************/
         
//            /************** when icanscash  hidden ***************/
//            _heightforTermVoucher.constant = paragraphRect.size.height+170;
//            _icanCashBaseView.hidden = YES;
//            _heightManageIcanCash.constant = 370;
//             /************** when icanscash  hidden ***************/
        }else{
            _heightforTermVoucher.constant = paragraphRect.size.height+310;
            _icanCashBaseView.hidden = YES;
            _heightManageIcanCash.constant = 310;
            
        }
    }
    
   
   
   
    
    //Code for setting google button delegate
    [GIDSignIn sharedInstance].uiDelegate = self;
    
    roomCount = 1;
    self.isTermsConditionAccepted = NO;
    [[ICSingletonManager sharedManager]addingBorderToUIView:self.viewPopUp withColor:[UIColor lightGrayColor]];
    
    [[ICSingletonManager sharedManager] addingBorderToUIView:self.viewConfirmMobile withColor:[UIColor lightGrayColor]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self action:@selector(handleSingleTap:)];
    //tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    [[ICSingletonManager sharedManager]addBottomMenuToViewController:self onView:self.viewBottom];
    NSUserDefaults *nsUserDefaults= [NSUserDefaults standardUserDefaults];
    NSDictionary *userData = [nsUserDefaults objectForKey:KUserLogin];
    //  NSLog(@"%@",userData);
    self.fname.text = [userData objectForKey:@"FirstName"];
    self.lname.text = [userData objectForKey:@"LastName"];
    self.mobileNumber.text = [userData objectForKey:@"Phone1"];
    self.email.text = [userData objectForKey:@"Email"];
    
    self.arrayCouponCount = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10"];
    self.selectCouponCount.text = [self.arrayCouponCount objectAtIndex:0];
    
    [self.btnCheckboxTermsCondition setBackgroundImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
    [self.btnCheckboxSendNotifications setBackgroundImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
    [self fetchingUserGender];
    [self startServiceToGetCouponList];
    
    // For Get Google Data From Appdelegate After Login
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(googleButton:) name:@"googlesigninaction" object:nil];
  
      if (globals.isFromBuyVocherToMapScreen) {
          
          self.selectCouponCount.text = [NSString stringWithFormat:@"%@", self.numberOfVoucherRequired];
          
          
      }
   
   
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        NSString *CanCashStr  = [NSString stringWithFormat:@"You can use max %d icanCash",cancashAmountAvailable];
        NSString *balanceStr  = [NSString stringWithFormat:@"(Current icanCash =%d)",[globals.userCancashAmountAvailable intValue]];
        int lengthCashStr = [CanCashStr length];
        int lengthBalanceStr = [balanceStr length];
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", CanCashStr,balanceStr]];
        [text addAttribute:NSForegroundColorAttributeName value:[ICSingletonManager colorFromHexString:@"#bd9854"] range:NSMakeRange(0,lengthCashStr )];
        [text addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(lengthCashStr +1 ,lengthBalanceStr )];
        _canCashAmountAvail.attributedText = text;
    }else{
        NSString *CanCashStr  = [NSString stringWithFormat:@"You can use max %d icanCash",cancashAmountAvailable];
        NSString *balanceStr  = [NSString stringWithFormat:@"(Current icanCash = %d)",[globals.userCancashAmountAvailable intValue]];
        int lengthCashStr = [CanCashStr length];
        int lengthBalanceStr = [balanceStr length];
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@", CanCashStr,balanceStr]];
        int lengthStr = [[NSString stringWithFormat:@"%@\n%@", CanCashStr,balanceStr] length];
        [text addAttribute:NSForegroundColorAttributeName value:[ICSingletonManager colorFromHexString:@"#bd9854"] range:NSMakeRange(0,lengthCashStr )];
        [text addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(lengthStr - lengthBalanceStr ,lengthBalanceStr )];
        _canCashAmountAvail.attributedText = text;
    }
    _canCashAmountAvail.hidden = YES;
    _icanCashChkBoxBtn.hidden = YES;
    
  
  
 //   cancashAmountAvailable = 500;
    UITextView *textLbl = [[UITextView alloc]initWithFrame:CGRectMake(5, 2, self.view.frame.size.width - 30, 70)];
    textLbl.text = @"In addition to the superb price of ₹2,999 to stay in luxury hotel all over India. You can also use icancashto pay the same.";
    textLbl.scrollEnabled = NO;
    textLbl.editable = NO;
    textLbl.font = [UIFont systemFontOfSize:14];
//    [self.icanCashBaseView addSubview:textLbl];
    
  
    
    UILabel *totalAmount = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 150,22)];
    totalAmount.text = @"Total amount";
    totalAmount.textAlignment = NSTextAlignmentLeft;
    totalAmount.font = [UIFont systemFontOfSize:15];
    [self.icanCashBaseView addSubview:totalAmount];
    
    totalAmountPriceLbl = [[UILabel alloc]initWithFrame:CGRectMake( 150, 0 , self.view.frame.size.width - 150 - 30,22)];
      NSString * amountformat = [numberFormat stringFromNumber: [NSNumber numberWithInt:2999]];
    totalAmountPriceLbl.text = [NSString stringWithFormat:@"₹%@",amountformat];
    totalAmountPriceLbl.textAlignment = NSTextAlignmentRight;
     totalAmountPriceLbl.font = [UIFont systemFontOfSize:15];
  [self.icanCashBaseView addSubview:totalAmountPriceLbl];
    
    UILabel *discountLbl = [[UILabel alloc]initWithFrame:CGRectMake(5, totalAmount.frame.size.height + totalAmount.frame.origin.y, 200,22)];
    discountLbl.text = @"Less icanCash";
    discountLbl.textAlignment = NSTextAlignmentLeft;
    discountLbl.font = [UIFont systemFontOfSize:14];
    [self.icanCashBaseView addSubview:discountLbl];
    
    discountPriceLbl = [[UILabel alloc]initWithFrame:CGRectMake( 150, totalAmountPriceLbl.frame.size.height + totalAmountPriceLbl.frame.origin.y, self.view.frame.size.width - 150 - 30,22)];
   
    discountPriceLbl.text = [NSString stringWithFormat:@"(-)₹%@",amountformat1];
    discountPriceLbl.textAlignment = NSTextAlignmentRight;
    discountPriceLbl.font = [UIFont systemFontOfSize:14];
    [self.icanCashBaseView addSubview:discountPriceLbl];
    
    UILabel *paylbl = [[UILabel alloc]initWithFrame:CGRectMake(5, discountLbl.frame.size.height + discountLbl.frame.origin.y, 150,22)];
    paylbl.text = @"To Pay";
    paylbl.textAlignment = NSTextAlignmentLeft;
    paylbl.font = [UIFont boldSystemFontOfSize:15];
//    [self.icanCashBaseView addSubview:paylbl];
   
    payPriceLbl = [[UILabel alloc]initWithFrame:CGRectMake( 150, discountPriceLbl.frame.size.height + discountPriceLbl.frame.origin.y, self.view.frame.size.width - 150 - 30,22)];
    int amountPaid1 = 2999 - cancashAmountAvailable;
      NSString * amountformat21 = [numberFormat stringFromNumber: [NSNumber numberWithInt:amountPaid1]];
    payPriceLbl.text = [NSString stringWithFormat:@"₹%@", amountformat21];
    payPriceLbl.textAlignment = NSTextAlignmentRight;
    payPriceLbl.font = [UIFont boldSystemFontOfSize:15];
 //   [self.icanCashBaseView addSubview:payPriceLbl];
    
    
    
    UILabel *sbilbl = [[UILabel alloc]initWithFrame:CGRectMake(5, discountLbl.frame.size.height + discountLbl.frame.origin.y, 150,22)];
    sbilbl.text = @"To Pay";
    sbilbl.textAlignment = NSTextAlignmentLeft;
    sbilbl.font = [UIFont boldSystemFontOfSize:15];
    //    [self.icanCashBaseView addSubview:paylbl];
    
    sbiPriceLbl = [[UILabel alloc]initWithFrame:CGRectMake( 150, discountPriceLbl.frame.size.height + discountPriceLbl.frame.origin.y, self.view.frame.size.width - 150 - 30,22)];
 
 //   sbiPriceLbl.text = [NSString stringWithFormat:@"₹%@", amountformat21];
    sbiPriceLbl.textAlignment = NSTextAlignmentRight;
    sbiPriceLbl.font = [UIFont boldSystemFontOfSize:15];
    [self.icanCashBaseView addSubview:sbiPriceLbl];
    
    
    [self.buyVoucherBtn setTitle:[NSString stringWithFormat:@"PAY NOW | ₹ %@",amountformat21] forState:UIControlStateNormal];
    
    if (cancashAmountAvailable == 0) {
        discountLbl.hidden = YES;
        discountPriceLbl.hidden = YES;
        
        paylbl.frame = CGRectMake(5, totalAmount.frame.size.height + totalAmount.frame.origin.y, 150,22);
        payPriceLbl.frame = CGRectMake( 150, totalAmountPriceLbl.frame.size.height + totalAmountPriceLbl.frame.origin.y, self.view.frame.size.width - 150 - 30,22);
    }
   
   
    
    self.loginBtn =  [[GradientButton alloc]init];
    self.loginBtn.frame = CGRectMake(0,0,(self.view.frame.size.width - 30 - 10)/2,40);
    [self.loginBtn setTitle:@"LOGIN & CONTINUE" forState:UIControlStateNormal];
    self.loginBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.loginBtn useRedDeleteStyle];
    [self.loginBtn addTarget:self action:@selector(loginBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
 //   [self.loginAndGuestBaseView addSubview:self.loginBtn];
    
    
    self.guestBtn =  [[GradientButton alloc]init];
    self.guestBtn.frame = CGRectMake(self.loginBtn.frame.size.width + self.loginBtn.frame.origin.x + 10,0,(self.view.frame.size.width - 30 - 10)/2,40);
    [self.guestBtn setTitle:@"CONTINUE AS GUEST" forState:UIControlStateNormal];
    [self.guestBtn useRedDeleteStyle];
      self.guestBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.guestBtn addTarget:self action:@selector(guestBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
 //   [self.loginAndGuestBaseView addSubview:self.guestBtn];
    
    self.buyVoucherRegistartionBtn =  [[GradientButton alloc]init];
    self.buyVoucherRegistartionBtn.frame = CGRectMake(5,0,self.view.frame.size.width - 50,40);
    [self.buyVoucherRegistartionBtn setTitle:@"Buy Voucher" forState:UIControlStateNormal];
    [self.buyVoucherRegistartionBtn useRedDeleteStyle];
    [self.buyVoucherRegistartionBtn addTarget:self action:@selector(buyVoucherBtnRegTapped:) forControlEvents:UIControlEventTouchUpInside];
//   [self.RegistrationBuyBaseview addSubview:self.buyVoucherRegistartionBtn];
    
    self.buyVoucherLoginBtn =  [[GradientButton alloc]init];
    self.buyVoucherLoginBtn.frame = CGRectMake(5,0,self.view.frame.size.width - 50,40);
    [self.buyVoucherLoginBtn setTitle:@"Buy Voucher" forState:UIControlStateNormal];
    [self.buyVoucherLoginBtn useRedDeleteStyle];
    [self.buyVoucherLoginBtn addTarget:self action:@selector(buyVoucherBtnLoginTapped:) forControlEvents:UIControlEventTouchUpInside];
//    [self.loginBuyVoucherBtnBaseView addSubview:self.buyVoucherLoginBtn];
    
//    self.buyVoucherBtnBaseView.layer.masksToBounds = YES;
//    self.buyVoucherBtnBaseView.clipsToBounds = YES;
//    self.buyVoucherBtnBaseView.userInteractionEnabled = YES;
    self.NewBtn =  [[GradientButton alloc]init];
    self.NewBtn.frame = CGRectMake(20,0,self.view.frame.size.width - 70,45);
    [self.NewBtn setTitle:@"Buy Voucher" forState:UIControlStateNormal];
    [self.NewBtn useRedDeleteStyle];
    self.NewBtn.userInteractionEnabled = YES;
    self.NewBtn.layer.masksToBounds = YES;
    self.NewBtn.clipsToBounds = YES;
    [self.NewBtn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.buyVoucherBtnBaseView.backgroundColor = [UIColor redColor];
//    self.icanCashBaseView.backgroundColor = [UIColor greenColor];
 //   _viewBlackTransparent.backgroundColor = [UIColor redColor];
 //   [self.buyVoucherBtnBaseView addSubview:self.NewBtn];
    
  UIImage * image = [UIImage imageNamed:@"checkbox_selected"];
    [_btnCheckboxTermsCondition setBackgroundImage:image forState:UIControlStateNormal];
    self.isTermsConditionAccepted = YES;
    
}
-(void)buyVoucherBtnLoginTapped:(id)sender
{
    if (self.isTermsConditionAccepted) {
        BOOL ifUserNameEmpty = [self.txt_MobileNumb detectIfTextfieldIsEmpty:self.txt_MobileNumb.text];
        if (ifUserNameEmpty){
            [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Enter a mobile number" onController:self];
            return;
        }
        
        BOOL ifPasswordEmpty = [self.txt_Password detectIfTextfieldIsEmpty:self.txt_Password.text];
        if (ifPasswordEmpty){
            [[ICSingletonManager sharedManager] showAlertViewWithMsg:@"Enter a password" onController:self];
            return;
        }
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        NSString *strParams = [NSString stringWithFormat:@"userName=%@&password=%@&isAutoLogin=yes",self.txt_MobileNumb.text,self.txt_Password.text];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        [manager.requestSerializer setValue:@"application/json; charset=utf-8"
                         forHTTPHeaderField:@"Content-Type"];
        
        [manager POST:[NSString stringWithFormat:@"%@/api/Loginapi/Login?%@",kServerUrl,strParams] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"responseObject=%@",responseObject);
            
            NSString *status = [responseObject objectForKey:@"status"];
            // NSString *msg = [responseObject valueForKey:@"errorMessage"];
            if ([status isEqualToString:@"SUCCESS"]) {
                
                NSDictionary  *dictUserModel = [responseObject valueForKey:@"userModel" ];
                NSMutableDictionary *dictCleanedUserModel= [self cleanDictionary:[dictUserModel mutableCopy]];
                dictUserModel = [dictCleanedUserModel copy];
                
                LoginManager *loginManage = [[LoginManager alloc]init];
                [loginManage loginUserWithUserDataDictionary:dictUserModel ];
                
                NSDictionary *dict = [loginManage isUserLoggedIn];
                NSLog(@"%@",dict);
                
                [self postDataToPushNotification];
                [self startServiceToGetCouponsDetails];
                
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
    else
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Please accept terms & conditions." onController:self];
}
-(void)buyVoucherBtnRegTapped:(id)sender
{
    if (![self validateFirstNameAndLastName]) {
        return;
    }
    else if (![self validateEmailAddress]) {
        return;
    }
    else if (![self validatePhoneNumber]) {
        return;
    }
    if (self.isTermsConditionAccepted) {
        //        [self.viewBlackTransparent setHidden:NO];
        //        [self.viewConfirmMobile setHidden:NO];
        isRegButtonTapped = YES;
        
        if (isRegButtonTapped == YES) {
            [self startServiceToRegisterNewUser];
            
        }
        
        
    }
    else
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Please accept terms & conditions." onController:self];
}
-(void)btnPressed:(id)sender
{
    if (self.isTermsConditionAccepted) {
        
        
        if ([self isNotZeroLengthString:self.fname.text fieldName:@"FName"] && [self isNotZeroLengthString:self.lname.text fieldName:@"LName"] && [self isNotZeroLengthString:self.mobileNumber.text fieldName:@"Phone"]  &&[self isValidContactNoumber:self.mobileNumber.text] && [self isNotZeroLengthString:self.email.text fieldName:@"Email"] &&[self isValidEmailORUsername:self.email.text] && [self validateAlphabets:self.fname.text fieldName:@"FName"] && [self validateAlphabets:self.lname.text fieldName:@"LName"])
        {
            
            LoginManager *loginManage = [[LoginManager alloc]init];
            NSDictionary *dict = [loginManage isUserLoggedIn];
            //NSLog(@"%@",dict);
            NSString *strGender = [dict valueForKey:@"Gender"];
            /****************** Mo Engage *******************/
            
            NSMutableDictionary *purchaseDict = [NSMutableDictionary dictionaryWithDictionary:@{@"Mobile No.": self.mobileNumber.text,@"User name":[NSString stringWithFormat:@"%@ %@", self.fname.text,self.lname.text],@"Gender":strGender}];
            
            
            [[MoEngage sharedInstance]trackEvent:@"App Tried Voucher Purchase IOS" andPayload:purchaseDict];
            [[MoEngage sharedInstance] syncNow];
            [MoEngage debug:LOG_ALL];
            
            /****************** Mo Engage *******************/
            
            /****************** Google Analytics *******************/
            
            // Track the Event for UserSuccessfulRegistrationMobile
            
            NSString *actionStr = [NSString stringWithFormat:@"%@ %@", self.mobileNumber.text,[NSString stringWithFormat:@"%@ %@", self.fname.text,self.lname.text]];
            id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
            [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"App Tried Voucher Purchase IOS"
                                                                  action:actionStr
                                                                   label:self.mobileNumber.text
                                                                   value:nil] build]];
            
            /****************** Google Analytics *******************/
            [self.viewBlackTransparent setHidden:NO];
            [self.viewConfirmMobile setHidden:NO];
            
            //  [self PostDataforOrderID];
        }
        //        else
        //            [[ICSingletonManager sharedManager] showAlertViewWithMsg:@"Please enter all fields" onController:self];
    }
    else
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Please accept terms & conditions." onController:self];
}
-(void)guestBtnTapped:(id)sender
{
    if (self.isTermsConditionAccepted) {
        _view_LoginForm.hidden = YES;
        _btn_ContinueGuest.alpha = 1.0;
        _btn_LogInContinue.alpha = 0.8;
        [_txtFirstName becomeFirstResponder];
        //        _height_LoginForm.constant = 0;
        
        //        if ([self isNotZeroLengthString:self.fname.text fieldName:@"FName"] && [self isNotZeroLengthString:self.lname.text fieldName:@"LName"] && [self isNotZeroLengthString:self.mobileNumber.text fieldName:@"Phone"]  &&[self isValidContactNoumber:self.mobileNumber.text] && [self isNotZeroLengthString:self.email.text fieldName:@"Email"] &&[self isValidEmailORUsername:self.email.text] && [self validateAlphabets:self.fname.text fieldName:@"FName"] && [self validateAlphabets:self.lname.text fieldName:@"LName"])
        //        {
        self.strGender = @"M";
        _view_Registration.hidden = NO;
        //        _Height_RegistrationView.constant = 480;
        if (IS_IPAD) {
            _Height_RegistrationView.constant = 500;
        }
        self.scrollview.scrollEnabled = YES;
        
        
        //        }
        //        else
        //            [[ICSingletonManager sharedManager] showAlertViewWithMsg:@"Please enter all fields" onController:self];
    }
    else
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Please accept terms & conditions." onController:self];
}
-(void)loginBtnTapped:(id)sender
{
    if (self.isTermsConditionAccepted) {
        
        _btn_ContinueGuest.alpha = 0.8;
        _btn_LogInContinue.alpha = 1.0;
        [_txt_MobileNumb becomeFirstResponder];
        
        self.scrollview.scrollEnabled = YES;
        _view_LoginForm.hidden = NO;
        _view_Registration.hidden = YES;
        //        _Height_RegistrationView.constant = 0;
        //        _height_LoginForm.constant = 340;
        if (IS_IPAD) {
            [self.scrollview setContentOffset:CGPointMake(0, 0)];
            self.scrollview.scrollEnabled = NO;
        }
    }
    else
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Please accept terms & conditions." onController:self];
}
- (void)addPaddingToTextFields{
    [self.txtEmailId addPaddingToTextField];
    [self.txtFirstName addPaddingToTextField];
    [self.txtLastName addPaddingToTextField];
    [self.txtMobileNum addPaddingToTextField];
    [self.txt_Password addPaddingToTextField];
    [self.txt_MobileNumb addPaddingToTextField];
    [self.txt_ForgetMobNumber addPaddingToTextField];
}
- (void)fetchingUserGender{
    LoginManager *loginManage = [[LoginManager alloc]init];
    NSDictionary *dict = [loginManage isUserLoggedIn];
    //NSLog(@"%@",dict);
    NSString *strGender = [dict valueForKey:@"Gender"];
    if ([strGender isEqualToString:@"F"]) {
        [self.btnRadioMale setBackgroundImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        [self.btnRadioFemale setBackgroundImage:[UIImage imageNamed:@"radio_selected"] forState:UIControlStateNormal];
        
        [self.btnGenderMale setBackgroundImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        [self.btnGenderFemale setBackgroundImage:[UIImage imageNamed:@"radio_selected"] forState:UIControlStateNormal];
        self.strGender =@"F";
    }
    else  {
        [self.btnRadioMale setBackgroundImage:[UIImage imageNamed:@"radio_selected"] forState:UIControlStateNormal];
        [self.btnRadioFemale setBackgroundImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        
        [self.btnGenderMale setBackgroundImage:[UIImage imageNamed:@"radio_selected"] forState:UIControlStateNormal];
        [self.btnGenderFemale setBackgroundImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        
        self.strGender = @"M";
    }
   }

- (void)startServiceToGetCouponList {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8"
                     forHTTPHeaderField:@"Content-Type"];
    
    
    [manager GET:[NSString stringWithFormat:@"%@/api/CouponApi/GetBuyCouponDetailMobile?",kServerUrl] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        self.dictFromServer = (NSDictionary *)responseObject;
        [self settingCouponInfoFromServer:self.dictFromServer];
        
        NSLog(@"sucess");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [[ICSingletonManager sharedManager] showAlertViewWithMsg:error.localizedDescription onController:self];
        
    }];
}

- (void)settingCouponInfoFromServer:(NSDictionary *)dict
{
    if (isTermforReg == NO) {
        NSString *str_price = [NSString stringWithFormat:@"%@",[dict valueForKey:@"CouponPrice"]];
        NSMutableString *mu = [NSMutableString stringWithString:str_price];
        
        if (mu.length>3) {
            [mu insertString:@"," atIndex:mu.length-3];
        }
        
        voucherAmount = [str_price intValue];
        [self.lblCouponName setText:[dict valueForKey:@"CouponText"]];
        [self.lblPriceCoupon setText:[NSString stringWithFormat:@"₹%@/-",mu]];
        
        NSString *stringTermsCondition = nil;
        if (self.ifFromGiftedCoupon) {
            stringTermsCondition = [dict valueForKey:@"GiftCouponTerms"];
            [self.lblGiftCouponText setText:[dict valueForKey:@"GiftCouponFooterTerms"]];
        }
        else
            stringTermsCondition =[dict valueForKey:@"BuyCouponTerms"];
        
        //    stringTermsCondition= [[ICSingletonManager sharedManager]removeNullObjectFromString:stringTermsCondition];
        //    stringTermsCondition = [[ICSingletonManager sharedManager] stringByStrippingHTMLFromString:stringTermsCondition];
        
        NSAttributedString *attrStr = [[NSAttributedString alloc] initWithData:[[stringTermsCondition stringByReplacingOccurrencesOfString:@"Coupon" withString:@"Voucher"] dataUsingEncoding:NSUTF8StringEncoding]
                                                                       options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                 NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}
                                                            documentAttributes:nil error:nil];
        NSLog(@"attrStr======%@",attrStr);
        
        [self.txtView setAttributedText:attrStr];
        NSString *strValidFrom =[dict valueForKey:@"CouponValidFrom"];
        strValidFrom= [strValidFrom substringToIndex: MIN(19, strValidFrom.length)];
        NSString *strValidTo = [dict valueForKey:@"CouponValidTill"];
        strValidTo = [strValidTo substringToIndex:MIN(19, strValidTo.length)];
        
        strValidFrom = [[ICSingletonManager sharedManager] returnFormatedStringDateFromString:strValidFrom];
        strValidTo = [[ICSingletonManager sharedManager] returnFormatedStringDateFromString:strValidTo];
        
        [self.lblCouponValidFrom setText:[NSString stringWithFormat:@"Valid From %@",strValidFrom]];
        [self.lblCouponValidTill setText:[NSString stringWithFormat:@"Valid Till %@",strValidTo]];
        
        NSNumberFormatter *numberFormat = [[NSNumberFormatter alloc] init];
        numberFormat.usesGroupingSeparator = YES;
        numberFormat.groupingSeparator = @",";
        numberFormat.groupingSize = 3;
        
        
        _selectCouponCount.text = [NSString stringWithFormat:@"%d",roomCount];
        int amountPaid = voucherAmount*roomCount - cancashAmountAvailable;
        NSString * amountformat = [numberFormat stringFromNumber: [NSNumber numberWithInt:amountPaid]];
        NSString * amountformat1 = [numberFormat stringFromNumber: [NSNumber numberWithInt:voucherAmount*roomCount]];
        totalAmountPriceLbl.text = [NSString stringWithFormat:@"₹%@", amountformat1];
        payPriceLbl.text = [NSString stringWithFormat:@"₹%@", amountformat];
        [self.buyVoucherBtn setTitle:[NSString stringWithFormat:@"PAY NOW |₹%@",amountformat] forState:UIControlStateNormal];
        
        NSString * amountformat3 = [numberFormat stringFromNumber: [NSNumber numberWithInt:cancashAmountAvailable]];
        NSString * amountformat4 = [numberFormat stringFromNumber: [NSNumber numberWithInt:amountPaid - 1000]];
        NSString *str1 = [NSString stringWithFormat:@"In addition to the superb price of ₹%d to stay in Luxury hotels all over India. You can use ₹%@ icanCash as part payment.", voucherAmount,amountformat3];
        NSString *str2 = [NSString stringWithFormat:@"You get ₹1,000 Cashback in your icanstay account Effective price for this transaction ₹%@ only.", amountformat4];
        
        NSString *htmlString =[NSString stringWithFormat:@"<html><head><style>ul{list-style:none;padding: 1px 0px 0px 0px; }ul li {  background-repeat: no-repeat; background-position: 0 0px;  background-size: 13px;font-size: 18px; color:#555;  line-height: 20px;}</style></head><body><ul><li>%@</br></br></li><li>%@</li></ul></body></html>", str1,str2];
        
        [_txtView_TermVoucher loadHTMLString:[ICSingletonManager getStringValue:htmlString] baseURL:nil];
        
    }
    else{
        NSString *stringTermsCondition =[dict valueForKey:@"RegTerms"];
        
        //    stringTermsCondition= [[ICSingletonManager sharedManager]removeNullObjectFromString:stringTermsCondition];
        //    stringTermsCondition = [[ICSingletonManager sharedManager] stringByStrippingHTMLFromString:stringTermsCondition];
        
        NSAttributedString *attrStr = [[NSAttributedString alloc] initWithData:[[stringTermsCondition stringByReplacingOccurrencesOfString:@"Coupon" withString:@"Voucher"] dataUsingEncoding:NSUTF8StringEncoding]
                                                                       options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                 NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}
                                                            documentAttributes:nil error:nil];
        NSLog(@"attrStr======%@",attrStr);
        
        [self.txtView setAttributedText:attrStr];
    }
    
    
    //[[ICSingletonManager sharedManager]gettingNewlyFormattedDateStringFromString:[dict valueForKey:@"CouponValidFrom"]];
    //  NSLog(@"%@",str);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleSingleTap:(UITapGestureRecognizer *) sender
{
    [self.view endEditing:YES];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark- Custom Actions

- (IBAction)buyCouponTap:(id)sender
{
    
    
    if (self.isTermsConditionAccepted) {
        
        
        if ([self isNotZeroLengthString:self.fname.text fieldName:@"FName"] && [self isNotZeroLengthString:self.lname.text fieldName:@"LName"] && [self isNotZeroLengthString:self.mobileNumber.text fieldName:@"Phone"]  &&[self isValidContactNoumber:self.mobileNumber.text] && [self isNotZeroLengthString:self.email.text fieldName:@"Email"] &&[self isValidEmailORUsername:self.email.text] && [self validateAlphabets:self.fname.text fieldName:@"FName"] && [self validateAlphabets:self.lname.text fieldName:@"LName"])
        {
            
            LoginManager *loginManage = [[LoginManager alloc]init];
            NSDictionary *dict = [loginManage isUserLoggedIn];
            //NSLog(@"%@",dict);
            NSString *strGender = [dict valueForKey:@"Gender"];
            /****************** Mo Engage *******************/
            
            NSMutableDictionary *purchaseDict = [NSMutableDictionary dictionaryWithDictionary:@{@"Mobile No.": self.mobileNumber.text,@"User name":[NSString stringWithFormat:@"%@ %@", self.fname.text,self.lname.text],@"Gender":strGender}];
            
            
            [[MoEngage sharedInstance]trackEvent:@"App Tried Voucher Purchase IOS" andPayload:purchaseDict];
             [[MoEngage sharedInstance] syncNow];
            [MoEngage debug:LOG_ALL];
            
            /****************** Mo Engage *******************/
            
            /****************** Google Analytics *******************/
            
            // Track the Event for UserSuccessfulRegistrationMobile
            
            NSString *actionStr = [NSString stringWithFormat:@"%@ %@", self.mobileNumber.text,[NSString stringWithFormat:@"%@ %@", self.fname.text,self.lname.text]];
            id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
            [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"App Tried Voucher Purchase IOS"
                                                                  action:actionStr
                                                                   label:self.mobileNumber.text
                                                                   value:nil] build]];
            
            /****************** Google Analytics *******************/
            [self.viewBlackTransparent setHidden:NO];
            [self.viewConfirmMobile setHidden:NO];
            
            //  [self PostDataforOrderID];
        }
        //        else
        //            [[ICSingletonManager sharedManager] showAlertViewWithMsg:@"Please enter all fields" onController:self];
    }
    else
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Please accept terms & conditions." onController:self];
}

- (IBAction)backButtonTap:(id)sender
{
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
    if ([globals.isFromDeepLinkToBuyCoupon isEqualToString:@"YES"]) {
        globals.isFromDeepLinkToBuyCoupon = @"NO";
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        
        HomeScreenController *vcHomeScreen = [storyboard instantiateViewControllerWithIdentifier:@"HomeScreenController"];
        SideMenuController *vcSideMenu =     [storyboard instantiateViewControllerWithIdentifier:@"SideMenuController"];
        
        MMDrawerController *drawerController = [[MMDrawerController alloc]initWithCenterViewController:vcHomeScreen
                                                                              leftDrawerViewController:vcSideMenu];
        [drawerController setRestorationIdentifier:@"MMDrawer"];
        //                         [drawerController setMaximumLeftDrawerWidth:[UIScreen mainScreen].bounds.size.width -[UIScreen mainScreen].bounds.size.width/2 ];
        [drawerController setMaximumLeftDrawerWidth:SCREEN_WIDTH*2/3];
        
        [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
        [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
        drawerController.shouldStretchDrawer = NO;
        
        UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:drawerController];
        [navController setNavigationBarHidden:YES];
        self.view.window.rootViewController = navController;
    }else if (globals.isFromMenuForBuyVoucher)
    {
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    }
    else if ([globals.strWhichScreen isEqualToString:@"BuyVoucher"] || [globals.strWhichScreen isEqualToString:@"SearchYourStay"]){
        globals.strWhichScreen = @"";
        //// Send to the Home View /////
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        
        HomeScreenController *vcHomeScreen = [storyboard instantiateViewControllerWithIdentifier:@"HomeScreenController"];
        SideMenuController *vcSideMenu =     [storyboard instantiateViewControllerWithIdentifier:@"SideMenuController"];
        
        MMDrawerController *drawerController = [[MMDrawerController alloc]initWithCenterViewController:vcHomeScreen
                                                                              leftDrawerViewController:vcSideMenu];
        [drawerController setRestorationIdentifier:@"MMDrawer"];
        //                         [drawerController setMaximumLeftDrawerWidth:[UIScreen mainScreen].bounds.size.width -[UIScreen mainScreen].bounds.size.width/2 ];
        [drawerController setMaximumLeftDrawerWidth:SCREEN_WIDTH*2/3];
        
        [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
        [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
        drawerController.shouldStretchDrawer = NO;
        
        UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:drawerController];
        [navController setNavigationBarHidden:YES];
        self.view.window.rootViewController = navController;
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    //    [self.navigationController popToRootViewControllerAnimated:YES];
    // [self.navigationController popViewControllerAnimated:YES];
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
    
    //    strUserAddress = @"Satya Sai";
    //    strState = @"Mp";
    //    strCity = @"Indore";
    //    numPinCode = [NSNumber numberWithInt:452001];
    
    NSNumber *couponPrice= [self.dictFromServer valueForKey:@"CouponPrice"];
    couponPrice= [[ICSingletonManager sharedManager]removeNullObjectFromNumber:couponPrice];
    
    int amount = [self.selectCouponCount.text intValue]*[couponPrice intValue];
    int amountToPayment = 0;
    NSString *name = [NSString stringWithFormat:@"%@ %@",[dict valueForKey:@"FirstName"],[dict valueForKey:@"LastName"]];
    NSString *merchant2 =nil;
    
    // merchant2 previous was %@|%@|False|True|False but now changed to
    
    if ([self.strSbi isEqualToString:@"NO"]) {
        if ([self.strCancash isEqualToString:@"YES"]) {
            if (self.ifFromGiftedCoupon) {
                merchant2 = [NSString stringWithFormat:@"%@|%@|True|False|True|%d",self.selectCouponCount.text,[dict valueForKey:@"Gender"],cancashAmountAvailable];
                amountToPayment = amount - cancashAmountAvailable;
                
            }
            else{
                merchant2 = [NSString stringWithFormat:@"%@|%@|True|False|False|%d",self.selectCouponCount.text,[dict valueForKey:@"Gender"],cancashAmountAvailable];
                amountToPayment = amount - cancashAmountAvailable;
            }
        }else if ([self.strCancash isEqualToString:@"NO"]){
            if (self.ifFromGiftedCoupon) {
                merchant2 = [NSString stringWithFormat:@"%@|%@|True|False|True|%d",self.selectCouponCount.text,[dict valueForKey:@"Gender"],0];
                amountToPayment = amount;
                
            }
            else{
                merchant2 = [NSString stringWithFormat:@"%@|%@|True|False|False|%d",self.selectCouponCount.text,[dict valueForKey:@"Gender"],0];
                amountToPayment = amount;
            }
        }
    }else if ([self.strSbi isEqualToString:@"YES"]){
        if ([self.strCancash isEqualToString:@"YES"]) {
            if (self.ifFromGiftedCoupon) {
                merchant2 = [NSString stringWithFormat:@"%@|%@|True|False|True|False|%d",self.selectCouponCount.text,[dict valueForKey:@"Gender"],cancashAmountAvailable];
                amountToPayment = amount - cancashAmountAvailable;
                
            }
            else{
                merchant2 = [NSString stringWithFormat:@"%@|%@|True|False|False|False|%d",self.selectCouponCount.text,[dict valueForKey:@"Gender"],cancashAmountAvailable];
                amountToPayment = amount - cancashAmountAvailable;
            }
        }else if ([self.strCancash isEqualToString:@"NO"]){
            if (self.ifFromGiftedCoupon) {
                merchant2 = [NSString stringWithFormat:@"%@|%@|True|False|True|%d",self.selectCouponCount.text,[dict valueForKey:@"Gender"],0];
                amountToPayment = amount;
                
            }
            else{
                merchant2 = [NSString stringWithFormat:@"%@|%@|True|False|False|%d",self.selectCouponCount.text,[dict valueForKey:@"Gender"],0];
                amountToPayment = amount;
            }
        }
    }
    
   
    
    NSString *merchant3 = [NSString stringWithFormat:@"%@|%@|%@|%@",[dict valueForKey:@"Phone1"],self.mobileNumber.text,self.fname.text,self.lname.text];
    
    NSString *merchant4 = [NSString stringWithFormat:@"%@|0|%@|%@|%@|%@",num,strUserAddress,strState,strCity,numPinCode];
    NSString *paymentUrlString =[NSString stringWithFormat:@"%@/PaymentProcess/MobilePaymentResponse",kServerUrl];
    //  NSString *paymentUrlString = @"http://dev.icanstay.com/PaymentProcess/MobilePaymentResponse";
    
    
    NSString *merchant5 = [NSString stringWithFormat:@"%@|%@|%@|False|False|False|False|IOS|",self.email.text,[dict valueForKey:@"Email"],self.strGender];
    
    
    //merchant5 - user etered email/ saved emailid / enter gender/|False|False|False|False||
    
  //  [self.webView setHidden:NO];
   // [self.webView setDelegate:self];
    //    NSString *urlString= [NSString stringWithFormat:@"http://dev.icanstay.businesstowork.com/PaymentProcess/PaymentRequestProcess?UserID=%@&OrderID=%@&Amount=%d&Currency=INR&Language=EN&RedirectURL=%@&CancelURL=%@&MerchantParam1=%@&MerchantParam2=%@&MerchantParam3=%@&MerchantParam4=%@&MerchantParam5=%@&promo_code=null&customer_identifier=%@",num,orderID,amount,paymentUrlString,paymentUrlString,name,merchant2,merchant3,merchant4,merchant5,num];
    
    
    //    NSString *urlString= [NSString stringWithFormat:@"http://dev.icanstay.com/PaymentProcess/PaymentRequestProcess?UserID=%@&OrderID=%@&Amount=%d&Currency=INR&Language=EN&RedirectURL=%@&CancelURL=%@&MerchantParam1=%@&MerchantParam2=%@&MerchantParam3=%@&MerchantParam4=%@&MerchantParam5=%@&promo_code=null&customer_identifier=%@",num,orderID,amount,paymentUrlString,paymentUrlString,name,merchant2,merchant3,merchant4,merchant5,num];
    
    NSString *urlString;
   
    if ([self.strSbi isEqualToString:@"NO"]) {
        if ([self.strCancash isEqualToString:@"YES"]) {
            urlString   = [NSString stringWithFormat:@"%@/PaymentProcess/PaymentRequestProcess?UserID=%@&OrderID=%@&Amount=%d&Currency=INR&Language=EN&RedirectURL=%@&CancelURL=%@&MerchantParam1=%@&MerchantParam2=%@&MerchantParam3=%@&MerchantParam4=%@&MerchantParam5=%@&promo_code=null&customer_identifier=%@&issbioffer=null",kServerUrl,num,orderID,amountToPayment,paymentUrlString,paymentUrlString,name,merchant2,merchant3,merchant4,merchant5,num];
            
        }else if ([self.strCancash isEqualToString:@"NO"]){
           urlString   = [NSString stringWithFormat:@"%@/PaymentProcess/PaymentRequestProcess?UserID=%@&OrderID=%@&Amount=%d&Currency=INR&Language=EN&RedirectURL=%@&CancelURL=%@&MerchantParam1=%@&MerchantParam2=%@&MerchantParam3=%@&MerchantParam4=%@&MerchantParam5=%@&promo_code=null&customer_identifier=%@&issbioffer=null",kServerUrl,num,orderID,amountToPayment,paymentUrlString,paymentUrlString,name,merchant2,merchant3,merchant4,merchant5,num];
        }
    }else if ([self.strSbi isEqualToString:@"YES"]){
        if ([self.strCancash isEqualToString:@"YES"]) {
             urlString   = [NSString stringWithFormat:@"%@/PaymentProcess/PaymentRequestProcess?UserID=%@&OrderID=%@&Amount=%d&Currency=INR&Language=EN&RedirectURL=%@&CancelURL=%@&MerchantParam1=%@&MerchantParam2=%@&MerchantParam3=%@&MerchantParam4=%@&MerchantParam5=%@&promo_code=null&customer_identifier=%@&issbioffer=1",kServerUrl,num,orderID,amountToPayment,paymentUrlString,paymentUrlString,name,merchant2,merchant3,merchant4,merchant5,num];
        }else if ([self.strCancash isEqualToString:@"NO"]){
           urlString   = [NSString stringWithFormat:@"%@/PaymentProcess/PaymentRequestProcess?UserID=%@&OrderID=%@&Amount=%d&Currency=INR&Language=EN&RedirectURL=%@&CancelURL=%@&MerchantParam1=%@&MerchantParam2=%@&MerchantParam3=%@&MerchantParam4=%@&MerchantParam5=%@&promo_code=null&customer_identifier=%@&issbioffer=1",kServerUrl,num,orderID,amountToPayment,paymentUrlString,paymentUrlString,name,merchant2,merchant3,merchant4,merchant5,num];
        }
    }
    
     
    NSString* webStringURL = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL* url = [NSURL URLWithString:webStringURL];
    //  NSURL *url = [NSURL URLWithString:[self getURLFromString:urlString]];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [PrWebview loadRequest:urlRequest];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUDForView:paymentController.view animated:YES];
    [MBProgressHUD showHUDAddedTo:paymentController.view animated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUDForView:paymentController.view animated:YES];
    
//    self.scrollview.backgroundColor = [UIColor redColor];
//    self.webView.backgroundColor = [UIColor greenColor];
//    
      self.scrollview.contentSize = CGSizeMake(webView.frame.size.width, webView.frame.size.height + 50);
//    self.scrollview.layer.masksToBounds = YES;
//    self.scrollview.userInteractionEnabled = YES;
//    self.webView.userInteractionEnabled = YES;
//    self.webView.layer.masksToBounds = YES;
 //   self.scrollview.contentSize = CGSizeMake(self.scrollview.frame.size.width, self.webView.frame.size.height);
    if (isff) {
        NSString *currentURL = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName(\"pre\")[0].innerHTML;"];
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:[currentURL dataUsingEncoding:NSUTF8StringEncoding]
                                                             options:kNilOptions
                                                               error:NULL];
        if ([[json objectForKey:@"status"] isEqualToString:@"SUCCESS"]) {
          //   [self.navigationController popViewControllerAnimated:YES];
          
            [self startServiceToGetCouponsDetailsLastMinuteDeal:json];
        }else if ([[json objectForKey:@"status"] isEqualToString:@"FAIL"]) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Payment Failed" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Payment Cancelled" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        //    [self.navigationController popViewControllerAnimated:YES];
        //     [self.navigationController popViewControllerAnimated:YES];
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            ICSingletonManager *globals = [ICSingletonManager sharedManager];
            globals.isFromMenuForBuyVoucher = true;
            [self.webView setHidden:YES];
            BuyCouponViewController *buyCoupon = [storyboard instantiateViewControllerWithIdentifier:@"BuyCouponViewController"];
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
            paymentController.view.window.rootViewController = navController;
//            [window setRootViewController:navController];
            [paymentController.view.window makeKeyAndVisible];

//            ICSingletonManager *globals = [ICSingletonManager sharedManager];
//            globals.isFromMenuForBuyVoucher = false;
//              [self.webView setHidden:YES];
//            BuyCouponViewController *buyCoupon =[self.storyboard instantiateViewControllerWithIdentifier:@"BuyCouponViewController"];
//            [self.navigationController pushViewController:buyCoupon animated:YES];
            [alert show];
            


        }
       // [self.webView setHidden:YES];
     //   [self.navigationController popViewControllerAnimated:YES];
        
        
    }
}

- (void)startServiceToGetCouponsDetailsLastMinuteDeal:(NSDictionary *)json
{
    
    [MBProgressHUD showHUDAddedTo:paymentController.view animated:YES];
    
    LoginManager *loginManage = [[LoginManager alloc]init];
    NSDictionary *dict = [loginManage isUserLoggedIn];
    
  //  if ([dict count] > 0) {
        ICSingletonManager *globals = [ICSingletonManager sharedManager];
        NSNumber *num = [dict valueForKey:@"UserId"];
        
        NSDictionary *dictParams = @{@"userid":num};
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        [manager.requestSerializer setValue:@"application/json; charset=utf-8"
                         forHTTPHeaderField:@"Content-Type"];
    
    NSString *strUrl = [NSString stringWithFormat:@"%@/api/BuyCoupens/GetUserDashboardDetail?",kServerUrl];
        [manager GET:strUrl parameters:dictParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"responseObject=%@",responseObject);
            
            globals.menuLoadArry = [responseObject mutableCopy];
            NSString *status = [responseObject valueForKey:@"status"];
            // NSString *msg = [responseObject valueForKey:@"errorMessage"];
            if ([status isEqualToString:@"SUCCESS"]) {
                
                
                
                NSNumber *numCouponCount = [responseObject valueForKey:@"UserCouponCount"];
                NSNumber *numPastStayCount = [responseObject valueForKey:@"UserPastStayCount"];
                NSNumber *numWhishlistCount = [responseObject valueForKey:@"UserWishlistCount"];
                
                
                
                globals.wishlistCount = [NSString stringWithFormat:@"%@",numWhishlistCount];
                globals.myVoucherCount = [NSString stringWithFormat:@"%@",numCouponCount];
                globals.staysCount = [NSString stringWithFormat:@"%@",numPastStayCount];
                
                LoginManager *login = [[LoginManager alloc]init];
                if ([[login isUserLoggedIn] count]>0)
                {
                    SideMenuController *vcSideMenu = [[SideMenuController alloc]init];
                   [vcSideMenu startServiceToGetCouponsDetailsLastMinuteDeal];
                }
               
                [self startServiceToGeticanCash:json];
                
            }
            
            NSLog(@"sucess");
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failure");
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [[ICSingletonManager sharedManager] showAlertViewWithMsg:error.localizedDescription onController:self];
            
        }];
        
    
    
}

- (void)startServiceToGeticanCash:(NSDictionary *)json
{
    
 //   [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
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
        
        ICSingletonManager *globals = [ICSingletonManager sharedManager];
        globals.isFromMenuForWishList = true;
        globals.isFromMenuForBuyVoucher = true;
        
        
        if (globals.isFromBuyVocherToMapScreen) {
            globals.isFromBuyVocherToMapScreen = FALSE;
            
            if (globals.isFromBuyVoucherSearchByCity == true && globals.isFromBuyVoucherByCurrentLocation == false) {
                
                
                MapScreen *mapScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"MapScreen"];
                
                NSString *strToPass = [json objectForKey:@"errorMessage"];
                
                
                NSString *newString1 = [strToPass stringByReplacingOccurrencesOfString:@"Kindly" withString:@""];
                NSString *newString2 = [newString1 stringByReplacingOccurrencesOfString:@"proceed" withString:@""];
                NSString *newString3 = [newString2 stringByReplacingOccurrencesOfString:@"to" withString:@""];
                NSString *newString4 = [newString3 stringByReplacingOccurrencesOfString:@"make" withString:@""];
                NSString *newString5 = [newString4 stringByReplacingOccurrencesOfString:@"wishlist" withString:@""];
                NSString *newString6 = [newString5 stringByReplacingOccurrencesOfString:@"now" withString:@""];
                NSString *strToPassFinal = [newString6 stringByReplacingOccurrencesOfString:@"." withString:@""];
                
                mapScreen.alertMasgFromPurchasedVoucher = strToPassFinal;
                mapScreen.isFromPurchasedVooucherScreen = @"YES";
                mapScreen.isByCity = YES;
                mapScreen.isByCurrentLocation = NO;
                globals.isFromBuyVoucherByCurrentLocation = false;
                globals.isFromBuyVoucherSearchByCity = false;
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                
                
                SideMenuController *vcSideMenu =     [storyboard instantiateViewControllerWithIdentifier:@"SideMenuController"];
                
                MMDrawerController *drawerController = [[MMDrawerController alloc]initWithCenterViewController:mapScreen
                                                                                      leftDrawerViewController:vcSideMenu];
                [drawerController setRestorationIdentifier:@"MMDrawer"];
                
                
                [drawerController setMaximumLeftDrawerWidth:SCREEN_WIDTH*2/3];
                
                [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
                [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
                drawerController.shouldStretchDrawer = NO;
                
                
                UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:drawerController];
                [navController setNavigationBarHidden:YES];
                paymentController.view.window.rootViewController = navController;
                //            [window setRootViewController:navController];
                [paymentController.view.window makeKeyAndVisible];
                
                
                
                
            }else if (globals.isFromBuyVoucherByCurrentLocation == true && globals.isFromBuyVoucherSearchByCity == false  )
            {
                
                MapScreen *mapScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"MapScreen"];
                
                NSString *strToPass = [json objectForKey:@"errorMessage"];
                NSString *newString1 = [strToPass stringByReplacingOccurrencesOfString:@"Kindly" withString:@""];
                NSString *newString2 = [newString1 stringByReplacingOccurrencesOfString:@"proceed" withString:@""];
                NSString *newString3 = [newString2 stringByReplacingOccurrencesOfString:@"to" withString:@""];
                NSString *newString4 = [newString3 stringByReplacingOccurrencesOfString:@"make" withString:@""];
                NSString *newString5 = [newString4 stringByReplacingOccurrencesOfString:@"wishlist" withString:@""];
                NSString *newString6 = [newString5 stringByReplacingOccurrencesOfString:@"now" withString:@""];
                NSString *strToPassFinal = [newString6 stringByReplacingOccurrencesOfString:@"." withString:@""];
                
                mapScreen.alertMasgFromPurchasedVoucher = strToPassFinal;
                mapScreen.isFromPurchasedVooucherScreen = @"YES";
                mapScreen.isByCity = NO;
                mapScreen.isByCurrentLocation = YES;
                globals.isFromBuyVoucherByCurrentLocation = false;
                globals.isFromBuyVoucherSearchByCity = false;
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                
                
                SideMenuController *vcSideMenu =     [storyboard instantiateViewControllerWithIdentifier:@"SideMenuController"];
                
                MMDrawerController *drawerController = [[MMDrawerController alloc]initWithCenterViewController:mapScreen
                                                                                      leftDrawerViewController:vcSideMenu];
                [drawerController setRestorationIdentifier:@"MMDrawer"];
                
                
                [drawerController setMaximumLeftDrawerWidth:SCREEN_WIDTH*2/3];
                
                [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
                [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
                drawerController.shouldStretchDrawer = NO;
                
                
                UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:drawerController];
                [navController setNavigationBarHidden:YES];
                paymentController.view.window.rootViewController = navController;
                [paymentController.view.window makeKeyAndVisible];
                
            }
            
            
        }else{
            
            ICSingletonManager *globals = [ICSingletonManager sharedManager];
            globals.isFromMenu = true;
            globals.firstTimeVoucherPurchase = @"YES";
            MyCouponViewController *buyCoupon =[self.storyboard instantiateViewControllerWithIdentifier:@"MyCouponViewController"];
            buyCoupon.str_CoupenCount = [globals.menuLoadArry valueForKey:@"UserCouponCount"];
            
            [self.mm_drawerController setCenterViewController:buyCoupon withCloseAnimation:YES completion:nil];
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            
            
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
            paymentController.view.window.rootViewController = navController;
            //            [window setRootViewController:navController];
            [paymentController.view.window makeKeyAndVisible];
            
        }
        
        
        LoginManager *loginManage = [[LoginManager alloc]init];
        NSDictionary *dict = [loginManage isUserLoggedIn];
        NSString *userName = [NSString stringWithFormat:@"%@ %@", [dict objectForKey:@"FirstName"], [dict objectForKey:@"LastName"]];
        
        
        /****************** Mo Engage *******************/
        NSMutableDictionary *purchaseDict = [NSMutableDictionary dictionaryWithDictionary:@{@"Mobile No": [dict objectForKey:@"Phone1"],@"Email":[dict objectForKey:@"Email"], @"Name": userName }];
        
        
        [[MoEngage sharedInstance]trackEvent:@"App Voucher Purchase IOS" andPayload:purchaseDict];
        [[MoEngage sharedInstance] syncNow];
        [MoEngage debug:LOG_ALL];
        
        /****************** Mo Engage *******************/
        
        /****************** Google Analytics *******************/
        
        // Track the Event for UserSuccessfulRegistrationMobile
        
        NSString *actionStr = [NSString stringWithFormat:@"%@ %@", userName,[dict objectForKey:@"Phone1"]];
        id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"App Voucher Purchase IOS"
                                                              action:actionStr
                                                               label:[dict objectForKey:@"Phone1"]
                                                               value:nil] build]];
        
        /****************** Google Analytics *******************/
        
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [[ICSingletonManager sharedManager] showAlertViewWithMsg:error.localizedDescription onController:self];
        
    }];
    
    
}

-(void)dismissPressed:(id)sender
{
    [V2 dismissViewControllerAnimated:YES completion:nil];
}
-(void)designPopup
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(V2.view.frame.size.width  - 50, 14, 28, 28);
    [btn setTitle:@"X" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor colorWithRed:0.7412 green:0.5725 blue:0.3451 alpha:1.0];
    btn.layer.cornerRadius = 14.0;
    btn.titleLabel.font = [UIFont systemFontOfSize:28];
    [btn addTarget:self action:@selector(dismissPressed:) forControlEvents:UIControlEventTouchUpInside];
    [V2.view addSubview:btn];
    
    UILabel *successLbl = [[UILabel alloc]initWithFrame:CGRectMake(20, btn.frame.size.height + btn.frame.origin.y,V2.view.frame.size.width  - 40 , 60)];
    successLbl.text = @"Thank you for the purchase you have successfully purchased 1 Voucher(s)";
    successLbl.lineBreakMode = NSLineBreakByWordWrapping;
    successLbl.numberOfLines = 2;
    successLbl.adjustsFontSizeToFitWidth = YES;
    successLbl.textColor = [UIColor grayColor];
    successLbl.font = [UIFont systemFontOfSize:16];
    [V2.view addSubview:successLbl];
    
    UILabel *transactionLbl = [[UILabel alloc]initWithFrame:CGRectMake(20, successLbl.frame.size.height + successLbl.frame.origin.y -10,V2.view.frame.size.width  - 40 , 60)];
    transactionLbl.text = @"The     transaction     Id     for     your     purchase     306003071035";
    transactionLbl.lineBreakMode = NSLineBreakByWordWrapping;
    transactionLbl.numberOfLines = 2;
    transactionLbl.adjustsFontSizeToFitWidth = YES;
    transactionLbl.font = [UIFont systemFontOfSize:18];
    transactionLbl.textColor = [UIColor grayColor];
    [V2.view addSubview:transactionLbl];
    
    UILabel *proceedLbl = [[UILabel alloc]initWithFrame:CGRectMake(20, transactionLbl.frame.size.height + transactionLbl.frame.origin.y - 10,V2.view.frame.size.width  - 40 , 30)];
    proceedLbl.text = @"Kindly proceed to make wishlist now.";
    proceedLbl.lineBreakMode = NSLineBreakByWordWrapping;
    proceedLbl.numberOfLines = 1;
    proceedLbl.textColor = [UIColor grayColor];
    proceedLbl.adjustsFontSizeToFitWidth = YES;
    proceedLbl.font = [UIFont systemFontOfSize:18];
    [V2.view addSubview:proceedLbl];
    
    UILabel *expectLbl = [[UILabel alloc]initWithFrame:CGRectMake(30, proceedLbl.frame.size.height + proceedLbl.frame.origin.y,V2.view.frame.size.width  - 60 , 30)];
    expectLbl.text = @"You expect to redeem this Voucher for";
    expectLbl.lineBreakMode = NSLineBreakByWordWrapping;
    expectLbl.textAlignment = NSTextAlignmentCenter;
    expectLbl.adjustsFontSizeToFitWidth = YES;
    expectLbl.textColor = [UIColor grayColor];
    expectLbl.font = [UIFont systemFontOfSize:14];
    [V2.view addSubview:expectLbl];
    
    
    
    
    [V2.view addSubview:[self addCheckBoxView:CGRectMake(0, expectLbl.frame.size.height + expectLbl.frame.origin.y,V2.view.frame.size.width , 40)]];
    
    UIButton *wishlistBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    wishlistBtn.frame = CGRectMake(150, baseView.frame.origin.y + baseView.frame.size.height + 10, V2.view.frame.size.width  - 150 , 40);
    [wishlistBtn setTitle:@"Continue to Make a Wishlist" forState:UIControlStateNormal];
    [wishlistBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    wishlistBtn.backgroundColor = [UIColor colorWithRed:0.7412 green:0.5725 blue:0.3451 alpha:1.0];
    wishlistBtn.layer.cornerRadius = 10.0;
    wishlistBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [wishlistBtn addTarget:self action:@selector(wishlistBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [V2.view addSubview:wishlistBtn];
    
    
}
-(UIView *)addCheckBoxView:(CGRect)rect
{
    
    baseView = [[UIView alloc]initWithFrame:rect];
    
    leisureBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    leisureBtn.frame = CGRectMake(2, 7, 25, 25);
    [leisureBtn setBackgroundImage:[UIImage imageNamed:@"checkBoxUnselected"] forState:UIControlStateNormal];
    [leisureBtn setBackgroundImage:[UIImage imageNamed:@"checkboxselected"] forState:UIControlStateSelected];
    [leisureBtn addTarget:self action:@selector(checkboxTapped:) forControlEvents:UIControlEventTouchUpInside];
    leisureBtn.tag = 1;
    [baseView addSubview:leisureBtn];
    
    UILabel *leisureLbl = [[UILabel alloc]initWithFrame:CGRectMake(leisureBtn.frame.origin.x + leisureBtn.frame.size.width  +2, 5, (V2.view.frame.size.width - 75) / 3, 30)];
    leisureLbl.text = @"For Leisure";
    leisureLbl.textColor = [UIColor grayColor];
    leisureLbl.adjustsFontSizeToFitWidth = YES;
    [baseView addSubview:leisureLbl];
    
    
    bussinessBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    bussinessBtn.frame = CGRectMake(leisureLbl.frame.origin.x + leisureLbl.frame.size.width + 5, 7, 25, 25);
    [bussinessBtn setBackgroundImage:[UIImage imageNamed:@"checkBoxUnselected"] forState:UIControlStateNormal];
    [bussinessBtn setBackgroundImage:[UIImage imageNamed:@"checkboxselected"] forState:UIControlStateSelected];
    [bussinessBtn addTarget:self action:@selector(checkboxTapped:) forControlEvents:UIControlEventTouchUpInside];
    bussinessBtn.tag = 2;
    [baseView addSubview:bussinessBtn];
    
    UILabel *bussinessLbl = [[UILabel alloc]initWithFrame:CGRectMake(bussinessBtn.frame.origin.x + bussinessBtn.frame.size.width  +2, 5, (V2.view.frame.size.width - 75)/3, 30)];
    bussinessLbl.text = @"For Bussiness";
    bussinessLbl.textColor = [UIColor grayColor];
    bussinessLbl.adjustsFontSizeToFitWidth = YES;
    [baseView addSubview:bussinessLbl];
    
    
    otherBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    otherBtn.frame = CGRectMake(bussinessLbl.frame.origin.x + bussinessLbl.frame.size.width + 5,7, 25, 25);
    [otherBtn setBackgroundImage:[UIImage imageNamed:@"checkBoxUnselected"] forState:UIControlStateNormal];
    [otherBtn setBackgroundImage:[UIImage imageNamed:@"checkboxselected"] forState:UIControlStateSelected];
    [otherBtn addTarget:self action:@selector(checkboxTapped:) forControlEvents:UIControlEventTouchUpInside];
    otherBtn.tag = 3;
    [baseView addSubview:otherBtn];
    
    UILabel *otherLbl = [[UILabel alloc]initWithFrame:CGRectMake(otherBtn.frame.origin.x + otherBtn.frame.size.width  +2, 7, (V2.view.frame.size.width - 75)/3, 30)];
    otherLbl.text = @"For other";
    otherLbl.adjustsFontSizeToFitWidth = YES;
    otherLbl.textColor = [UIColor grayColor];
    [baseView addSubview:otherLbl];
    
    return baseView;
}
-(void)checkboxTapped:(id)sender
{
    __weak UIButton *btn = sender;
    
    if (btn.tag == 1) {
        [leisureBtn setSelected:YES];
        [bussinessBtn setSelected:NO];
        [otherBtn setSelected:NO];
    }else if (btn.tag == 2){
        [leisureBtn setSelected:NO];
        [bussinessBtn setSelected:YES];
        [otherBtn setSelected:NO];
    }else if (btn.tag == 3){
        [leisureBtn setSelected:NO];
        [bussinessBtn setSelected:NO];
        [otherBtn setSelected:YES];
    }
    
}
-(void)wishlistBtnPressed:(id)sender
{
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"Failed to load with error :%@",[error debugDescription]);
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *URLString = [[request URL] absoluteString];
    
    if ([URLString isEqualToString:[NSString stringWithFormat:@"%@/PaymentProcess/MobilePaymentResponse",kServerUrl]])
    {
        isff= true;
        
    }
    return YES;
}
#pragma mark- Picker Actions

- (IBAction)cancelPicker:(id)sender {
    [self.viewPicker setHidden:YES];
    [self.view endEditing:YES];
    
    //[self hideShowPickerView];
}

- (IBAction)donePicker:(id)sender {
    
    //Code for setting the picker value on Done Tap
    
    if(selectPicker==kCouponCount)
    {
        self.selectCouponCount.text = [self.arrayCouponCount objectAtIndex:[self.pickerView selectedRowInComponent:0]];
    }
    
    [self.view endEditing:YES];
    [self.viewPicker setHidden:YES];
}

#pragma mark Picker View Delegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}


-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    int count=0;
    
    if (selectPicker==kCouponCount)
    {
        count = (int)[self.arrayCouponCount count];
    }
    
    return count;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = @"";
    if (selectPicker == kCouponCount) {
        title=[self.arrayCouponCount objectAtIndex:row];
    }
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    return attString;
    
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *strItem;
    if (selectPicker==kCouponCount) {
        strItem=[self.arrayCouponCount objectAtIndex:row];
    }
    return strItem;
}

- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated{
    [self.pickerView selectRow:0 inComponent:0 animated:YES];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
}

#pragma mark - Webservice Delegate

//service to get order id
-(void)PostDataforOrderID
{
    //http://dev.icanstay.businesstowork.com/api/BuyCoupens/GetOrderIDMobile?
    //IsHotelMappedCity parameter
    
    LoginManager *loginManage = [[LoginManager alloc]init];
    NSDictionary *dict = [loginManage isUserLoggedIn];
    NSNumber *num = [dict valueForKey:@"UserId"];
    
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *couponNumber = [f numberFromString:self.selectCouponCount.text];
    
    NSNumber *couponPrice= [self.dictFromServer valueForKey:@"CouponPrice"];
    couponPrice= [[ICSingletonManager sharedManager]removeNullObjectFromNumber:couponPrice];
    
    NSMutableDictionary *dictPost=[NSMutableDictionary new];
    [dictPost setValue:[NSNumber numberWithInt:0] forKey:@"OrderID"];
    [dictPost setValue:num forKey:@"UserID"];
    [dictPost setValue:couponNumber forKey:@"TotalCoupons"];
    
    NSString *strOrderDate=  [[ICSingletonManager sharedManager] convertToNSStringFromTodaysDate];
    
    
    if ([self.strSbi isEqualToString:@"YES"]) {
        [dictPost setValue:[NSNumber numberWithInt:[couponPrice intValue]*[couponNumber intValue] - cancashAmountAvailable] forKey:@"TotalAmount"];
        [dictPost setValue:[NSNumber numberWithInt:[couponPrice intValue]*[couponNumber intValue] - cancashAmountAvailable] forKey:@"NetAmount"];
    }else{
        [dictPost setValue:[NSNumber numberWithInt:[couponPrice intValue]*[couponNumber intValue]] forKey:@"TotalAmount"];
        [dictPost setValue:[NSNumber numberWithInt:[couponPrice intValue]*[couponNumber intValue]] forKey:@"NetAmount"];
    }
   
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

#pragma mark -Decreas Room Count
- (IBAction)doClickonDecreasRoom:(id)sender {
    if (roomCount != 1 ) {
        roomCount--;
      
        NSNumberFormatter *numberFormat = [[NSNumberFormatter alloc] init];
        numberFormat.usesGroupingSeparator = YES;
        numberFormat.groupingSeparator = @",";
        numberFormat.groupingSize = 3;
       
        
        _selectCouponCount.text = [NSString stringWithFormat:@"%d",roomCount];
        int amountPaid = voucherAmount*roomCount - cancashAmountAvailable;
         NSString * amountformat = [numberFormat stringFromNumber: [NSNumber numberWithInt:amountPaid]];
        NSString * amountformat1 = [numberFormat stringFromNumber: [NSNumber numberWithInt:voucherAmount*roomCount]];
        totalAmountPriceLbl.text = [NSString stringWithFormat:@"₹%@", amountformat1];
        payPriceLbl.text = [NSString stringWithFormat:@"₹%@", amountformat];
         [self.buyVoucherBtn setTitle:[NSString stringWithFormat:@"PAY NOW |₹%@",amountformat] forState:UIControlStateNormal];
        
        NSString * amountformat3 = [numberFormat stringFromNumber: [NSNumber numberWithInt:cancashAmountAvailable]];
        NSString * amountformat4 = [numberFormat stringFromNumber: [NSNumber numberWithInt:amountPaid - 1000]];
        NSString *str1 = [NSString stringWithFormat:@"In addition to the superb price of ₹%d to stay in Luxury hotels all over India. You can use ₹%@ icanCash as part payment.", voucherAmount,amountformat3];
        NSString *str2 = [NSString stringWithFormat:@"You get ₹1,000 Cashback in your icanstay account Effective price for this transaction ₹%@ only.", amountformat4];
        
        NSString *htmlString =[NSString stringWithFormat:@"<html><head><style>ul{list-style:none;padding: 1px 0px 0px 0px; }ul li {  background-repeat: no-repeat; background-position: 0 0px;  background-size: 13px;font-size: 18px; color:#555;  line-height: 20px;}</style></head><body><ul><li>%@</br></br></li><li>%@</li></ul></body></html>", str1,str2];
        
        [_txtView_TermVoucher loadHTMLString:[ICSingletonManager getStringValue:htmlString] baseURL:nil];
    }
}
#pragma mark -Increas Room Count
- (IBAction)doClickonIncreaseRoom:(id)sender {
    if (roomCount != 10 ) {
        roomCount++;
        NSNumberFormatter *numberFormat = [[NSNumberFormatter alloc] init];
        numberFormat.usesGroupingSeparator = YES;
        numberFormat.groupingSeparator = @",";
        numberFormat.groupingSize = 3;
        
        _selectCouponCount.text = [NSString stringWithFormat:@"%d",roomCount];
        int amountPaid = voucherAmount*roomCount - cancashAmountAvailable;
        NSString * amountformat = [numberFormat stringFromNumber: [NSNumber numberWithInt:amountPaid]];
        NSString * amountformat1 = [numberFormat stringFromNumber: [NSNumber numberWithInt:voucherAmount*roomCount]];
         totalAmountPriceLbl.text = [NSString stringWithFormat:@"₹%@", amountformat1];
        payPriceLbl.text = [NSString stringWithFormat:@"₹%@", amountformat];
         [self.buyVoucherBtn setTitle:[NSString stringWithFormat:@"PAY NOW |₹%@",amountformat] forState:UIControlStateNormal];
        
         NSString * amountformat3 = [numberFormat stringFromNumber: [NSNumber numberWithInt:cancashAmountAvailable]];
        NSString * amountformat4 = [numberFormat stringFromNumber: [NSNumber numberWithInt:amountPaid - 1000]];
        NSString *str1 = [NSString stringWithFormat:@"In addition to the superb price of ₹%d to stay in Luxury hotels all over India. You can use ₹%@ icanCash as part payment.",voucherAmount, amountformat3];
        NSString *str2 = [NSString stringWithFormat:@"You get ₹1,000 Cashback in your icanstay account Effective price for this transaction ₹%@ only.", amountformat4];
        
        NSString *htmlString =[NSString stringWithFormat:@"<html><head><style>ul{list-style:none;padding: 1px 0px 0px 0px; }ul li {  background-repeat: no-repeat; background-position: 0 0px;  background-size: 13px;font-size: 18px; color:#555;  line-height: 20px;}</style></head><body><ul><li>%@</br></br></li><li>%@</li></ul></body></html>", str1,str2];
        
        [_txtView_TermVoucher loadHTMLString:[ICSingletonManager getStringValue:htmlString] baseURL:nil];
    }
}


#pragma mark - TextField Delegate
//-(void)textFieldDidBeginEditing:(UITextField *)textField
//{
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (textField == self.selectCouponCount) {
        selectPicker = kCouponCount;
        [self.pickerView setHidden:NO];
        [self.pickerView reloadAllComponents];
        [self.viewPicker setHidden:NO];
        return NO;
    }
    else
    {
        [self.viewPicker setHidden:YES];
        return YES;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{              // called when 'return' key pressed. return NO to ignore.
    
    [textField resignFirstResponder];
    return YES;
}

-(NSString *)getURLFromString:(NSString *)str{
    
    NSString *urlStr = [str stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    return urlStr;
}

#pragma pragma mark -  Validation Check

-(BOOL)isNotZeroLengthString:(NSString *)str fieldName:(NSString *)strFieldName{
    BOOL isValid=YES;
    
    if ([str length] == 0)
    {
        NSString *strMessage =[NSString stringWithFormat:@"Please enter %@.",strFieldName];
        isValid=NO;
        if ([strFieldName isEqualToString:@"FName"])
        {
            direction = 1;
            shakes = 0;
            self.fname.placeholder=@"Please enter First Name";
            [self shake:self.fname:strMessage];
            [self.fname becomeFirstResponder];
        }
        else if ([strFieldName isEqualToString:@"LName"])
        {
            direction = 1;
            shakes = 0;
            self.lname.placeholder=@"Please enter Last Name";
            [self shake:self.lname:strMessage];
            [self.lname becomeFirstResponder];
        }
        else if ([strFieldName isEqualToString:@"Email"])
        {
            direction = 1;
            shakes = 0;
            self.email.placeholder=@"Please enter Email";
            [self shake:self.email:strMessage];
            [self.email becomeFirstResponder];
        }
        else if ([strFieldName isEqualToString:@"Phone"])
        {
            direction = 1;
            shakes = 0;
            self.mobileNumber.placeholder=@"Please enter Mobile Number";
            [self shake:self.mobileNumber:strMessage];
            [self.mobileNumber becomeFirstResponder];
            
            
        }
    }
    return isValid;
}

/// Check the Email Validation
-(BOOL)isValidEmailORUsername:(NSString *)strEmailID
{
    BOOL isValid=YES;
    if (!([strEmailID isValidEmail]))
    {
        isValid=NO;
        self.email.placeholder=@"Please enter valid Email Id";
        [self.email becomeFirstResponder];
        direction = 1;
        shakes = 0;
        [self shake:self.email:nil];
    }
    return isValid;
}

/// Check the Phone number Validation
-(BOOL)isValidContactNoumber:(NSString *) strPhone
{
    BOOL isValid=YES;
    if (!([strPhone isValidContactNo]))
    {
        isValid=NO;
        self.mobileNumber.placeholder = @"Please enter valid Mobile number";
        [self.mobileNumber becomeFirstResponder];
        direction = 1;
        shakes = 0;
        [self shake:self.mobileNumber:nil];
    }
    return isValid;
}

// Check the Name Validtion
-(BOOL) validateAlphabets: (NSString *)alpha fieldName:(NSString *)strFieldName
{
    NSString *abnRegex = @"[A-Za-z]+" "[A-Za-z]+"; // check for one or more occurrence of string you can also use * instead + for ignoring null value
    NSPredicate *abnTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", abnRegex];
    BOOL isValid=[abnTest evaluateWithObject:alpha];
    
    if ([strFieldName isEqualToString:@"FName"])
    {
        if (!isValid) {
            self.fname.placeholder=@"Please enter valid Fisrt Name";
            [self.fname becomeFirstResponder];
            direction = 1;
            shakes = 0;
            [self shake:self.fname:nil];
        }
    }
    else  if ([strFieldName isEqualToString:@"LName"])
    {
        if (!isValid) {
            self.lname.placeholder=@"Please enter valid Last Name";
            [self.lname becomeFirstResponder];
            direction = 1;
            shakes = 0;
            [self shake:self.lname:nil];
        }
    }
    return isValid;
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField.text.length == 0 && [string isEqualToString:@" "]) {
        return NO;
    }
    if(textField == self.txtFirstName || textField == self.txtLastName || textField == self.fname || textField == self.lname )
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
    
    if (textField == self.txtMobileNum || textField == self.mobileNumber || textField == self.txt_MobileNumb || textField == self.txt_ForgetMobNumber || textField == self.txtConfirmMobileNumber) {
        if ((textField.text.length >= 10 && range.length == 0) || ![string isEqualToString:filtered])
            return NO;
        return YES;
    } else {
        return YES;
        
    }
}

#pragma pragma mark -  UITextfiled Shake

-(void)shake:(UITextField *)textfieldShakingAnimation :(NSString *)errorText
{
    [UIView animateWithDuration:0.5 animations:^
     {
         textfieldShakingAnimation.transform = CGAffineTransformMakeTranslation(2*direction, 0);
     }
                     completion:^(BOOL finished)
     {
         if(shakes >= 4)
         {
             textfieldShakingAnimation.transform = CGAffineTransformIdentity;
             [textfieldShakingAnimation setValue:[UIColor lightGrayColor]
                                      forKeyPath:@"_placeholderLabel.textColor"];
             return;
         }
         textfieldShakingAnimation.text=@"";
         
         [textfieldShakingAnimation setValue:[UIColor redColor]
                                  forKeyPath:@"_placeholderLabel.textColor"];
         
         // textfieldShakingAnimation.placeholder=errorText;
         shakes++;
         direction = direction * -1;
         [self shake:textfieldShakingAnimation:errorText];
     }];
}

- (IBAction)btnMaleRadioBtnTapped:(id)sender {
    
    [self.btnRadioMale setBackgroundImage:[UIImage imageNamed:@"radio_selected"] forState:UIControlStateNormal];
    [self.btnRadioFemale setBackgroundImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
    self.strGender = @"M";
    
    [self.btnGenderMale setBackgroundImage:[UIImage imageNamed:@"radio_selected"] forState:UIControlStateNormal];
    [self.btnGenderFemale setBackgroundImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
    
    //    UIButton *btn = (UIButton *)sender;
    //    UIImage *image = [btn backgroundImageForState:UIControlStateNormal];
    //
    //    if ([image isEqual: [UIImage imageNamed:@"radio"]]) {
    //        image = [UIImage imageNamed:@"radio_selected"];
    //        [btn setBackgroundImage:image forState:UIControlStateNormal];
    //        [self.btnRadioFemale setBackgroundImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
    //        self.strGender = @"M";
    //    }
    //    else{
    //        image = [UIImage imageNamed:@"radio"];
    //        [btn setBackgroundImage:image forState:UIControlStateNormal];
    //        [self.btnRadioFemale setBackgroundImage:[UIImage imageNamed:@"radio_selected"] forState:UIControlStateNormal];
    //        self.strGender = @"F";
    //    }
}

- (IBAction)btnFemaleRadioBtnTapped:(id)sender {
    
    [self.btnRadioMale setBackgroundImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
    [self.btnRadioFemale setBackgroundImage:[UIImage imageNamed:@"radio_selected"] forState:UIControlStateNormal];
    self.strGender = @"F";
    
    [self.btnGenderMale setBackgroundImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
    [self.btnGenderFemale setBackgroundImage:[UIImage imageNamed:@"radio_selected"] forState:UIControlStateNormal];
    
    //    UIButton *btn = (UIButton *)sender;
    //    UIImage *image = [btn backgroundImageForState:UIControlStateNormal];
    //
    //    if ([image isEqual: [UIImage imageNamed:@"radio"]]) {
    //        image = [UIImage imageNamed:@"radio_selected"];
    //        [btn setBackgroundImage:image forState:UIControlStateNormal];
    //        [self.btnRadioMale setBackgroundImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
    //        self.strGender = @"F";
    //    }
    //    else{
    //        image = [UIImage imageNamed:@"radio"];
    //        [btn setBackgroundImage:image forState:UIControlStateNormal];
    //        [self.btnRadioMale setBackgroundImage:[UIImage imageNamed:@"radio_selected"] forState:UIControlStateNormal];
    //        self.strGender = @"M";
    //    }
}

- (IBAction)btnCheckboxTermConditionTapped:(id)sender {
    UIButton *btn = (UIButton *)sender;
    UIImage *image = [btn backgroundImageForState:UIControlStateNormal];
    
    if ([image isEqual: [UIImage imageNamed:@"checkbox"]]) {
        image = [UIImage imageNamed:@"checkbox_selected"];
        [btn setBackgroundImage:image forState:UIControlStateNormal];
        self.isTermsConditionAccepted = YES;
    }
    else{
        image = [UIImage imageNamed:@"checkbox"];
        [btn setBackgroundImage:image forState:UIControlStateNormal];
        self.isTermsConditionAccepted = NO;
    }
    
}

- (IBAction)btnClickHereToBuyCouponForFamilyMemberTapped:(id)sender {
    
    [self.constrainstHeightSendNotifications setConstant:40];
    [self.selectCouponCount setText:@"1"];
    [self.fname setPlaceholder:@"Enter First Name"];
    [self.lname setPlaceholder:@"Enter Last Name"];
    [self.mobileNumber setPlaceholder:@"Enter Mobile No."];
    [self.email setPlaceholder:@"Enter Email Id"];
    [self.fname setText:@""];
    [self.lname setText:@""];
    [self.mobileNumber setText:@""];
    [self.email setText:@""];
    
}

- (IBAction)btnCheckBoxSendNotificationsTapped:(id)sender {
    UIButton *btn = (UIButton *)sender;
    UIImage *image = [btn backgroundImageForState:UIControlStateNormal];
    
    if ([image isEqual: [UIImage imageNamed:@"checkbox"]]) {
        image = [UIImage imageNamed:@"checkbox_selected"];
        [btn setBackgroundImage:image forState:UIControlStateNormal];
        
    }
    else{
        image = [UIImage imageNamed:@"checkbox"];
        [btn setBackgroundImage:image forState:UIControlStateNormal];
        
    }
    
}

- (IBAction)btnShowTermsCondition:(UIButton *)sender {
    if (sender.tag == 11) {
        isTermforReg = NO;
        btn_Agree.hidden = NO;
        btn_DisAgree.hidden = NO;
        [self settingCouponInfoFromServer:self.dictFromServer];
    }
    else{
        btn_Agree.hidden = YES;
        btn_DisAgree.hidden = YES;
        isTermforReg = YES;
        [self settingCouponInfoFromServer:self.dictFromServer];
    }
    [self.viewBlackTransparent setHidden:NO];
    [self.viewPopUp setHidden:NO];
}


- (IBAction)btnAgreeTapped:(id)sender {
    
    [self.viewPopUp setHidden:YES];
    [self.viewBlackTransparent setHidden:YES];
    
    [self.btnCheckboxTermsCondition setBackgroundImage:[UIImage imageNamed:@"checkbox_selected"] forState:UIControlStateNormal];
    self.isTermsConditionAccepted = YES;
}

-(void)imageOwnerTapped:(id)sender {
    [self.viewPopUp setHidden:YES];
    [self.viewBlackTransparent setHidden:YES];
    [self.viewForget setHidden:YES];
    [self.viewConfirmMobile setHidden:YES];
}
- (IBAction)doClickonCrossButton:(id)sender {
    [self.viewPopUp setHidden:YES];
    [self.viewBlackTransparent setHidden:YES];
    [self.viewForget setHidden:YES];
    [self.viewConfirmMobile setHidden:YES];
}


- (IBAction)btnDisagreeTapped:(id)sender
{
    [self.viewPopUp setHidden:YES];
    [self.viewBlackTransparent setHidden:YES];
    
    [self.btnCheckboxTermsCondition setBackgroundImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
    self.isTermsConditionAccepted = NO;
}

- (IBAction)btnCancelconfirmMobileTapped:(id)sender
{
    [self.viewBlackTransparent setHidden:YES];
    [self.viewConfirmMobile setHidden:YES];
}
- (IBAction)btnConfirmMobileNumberTapped:(id)sender
{
    
    if (![self.txtConfirmMobileNumber.text isEqualToString:@""]) {
        if ([self.txtConfirmMobileNumber.text isEqualToString:self.mobileNumber.text]  )
        {
            [self.view endEditing:YES];
            [self.viewBlackTransparent setHidden:YES];
            [self.viewConfirmMobile setHidden:YES];
//            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//            paymentController = [storyboard instantiateViewControllerWithIdentifier:@"PaymentControllerGateway"];
//            [self designPaymentController];
            [self PostDataforOrderID];
//            [self setupWebView];
//            [self.navigationController pushViewController:paymentController animated:YES];

           
    }else if ([self.txtConfirmMobileNumber.text isEqualToString:self.txtMobileNum.text])
    {
        
        
        
    }else{
        
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Mobile number should be same" onController:self];
        
        }
    }
    else
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Mobile number should be same" onController:self];
}


-(void)designPaymentController
{
    self.webView.hidden = YES;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    UIView *topBluebaseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenRect.size.width, 60)];
    topBluebaseView.backgroundColor = [self colorWithHexString:@"001d3d"];
    [paymentController.view addSubview:topBluebaseView];
    
    UILabel *buyVoucherLbl = [[UILabel alloc]initWithFrame:CGRectMake((topBluebaseView.frame.size.width - 200) / 2, topBluebaseView.frame.size.height - 35, 200, 30)];
    buyVoucherLbl.text = @"Buy Voucher(s)";
    buyVoucherLbl.font = [UIFont systemFontOfSize:24];
    buyVoucherLbl.textColor = [UIColor whiteColor];
    [topBluebaseView addSubview:buyVoucherLbl];
    
    UIButton *backButtonToBuyVoucher = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    backButtonToBuyVoucher.frame = CGRectMake(20,topBluebaseView.frame.size.height - 35 , 35, 25);
    [backButtonToBuyVoucher  setBackgroundImage:[UIImage imageNamed:@"backIconNew"] forState:UIControlStateNormal];
    backButtonToBuyVoucher.backgroundColor = [UIColor clearColor];
    [backButtonToBuyVoucher addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [topBluebaseView addSubview:backButtonToBuyVoucher];
    PrWebview=[[UIWebView alloc]initWithFrame:CGRectMake(0, topBluebaseView.frame.origin.y + topBluebaseView.frame.size.height, screenRect.size.width,screenRect.size.height - topBluebaseView.frame.size.height - topBluebaseView.frame.origin.y)];
    PrWebview.delegate = self;
    [paymentController.view addSubview:PrWebview];
   

}

-(void)backButtonTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
#pragma mark - For Registration Form
- (IBAction)didTaponContinueAsGuest:(id)sender {
    if (self.isTermsConditionAccepted) {
        _view_LoginForm.hidden = YES;
        _btn_ContinueGuest.alpha = 1.0;
        _btn_LogInContinue.alpha = 0.8;
        [_txtFirstName becomeFirstResponder];
        //        _height_LoginForm.constant = 0;
        
        //        if ([self isNotZeroLengthString:self.fname.text fieldName:@"FName"] && [self isNotZeroLengthString:self.lname.text fieldName:@"LName"] && [self isNotZeroLengthString:self.mobileNumber.text fieldName:@"Phone"]  &&[self isValidContactNoumber:self.mobileNumber.text] && [self isNotZeroLengthString:self.email.text fieldName:@"Email"] &&[self isValidEmailORUsername:self.email.text] && [self validateAlphabets:self.fname.text fieldName:@"FName"] && [self validateAlphabets:self.lname.text fieldName:@"LName"])
        //        {
        self.strGender = @"M";
        _view_Registration.hidden = NO;
        //        _Height_RegistrationView.constant = 480;
        if (IS_IPAD) {
            _Height_RegistrationView.constant = 500;
        }
        self.scrollview.scrollEnabled = YES;
        
        
        //        }
        //        else
        //            [[ICSingletonManager sharedManager] showAlertViewWithMsg:@"Please enter all fields" onController:self];
    }
    else
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Please accept terms & conditions." onController:self];
    
}
- (IBAction)doClickonOffers:(id)sender {
    if (isOfferNewsLetter == NO) {
        isOfferNewsLetter = YES;
        self.img_Check_Offers.image = [UIImage imageNamed:@"checkbox_selected"];
    }
    else
    {
        isOfferNewsLetter = NO;
        self.img_Check_Offers.image = [UIImage imageNamed:@"checkbox"];
    }
}
- (IBAction)doClickonGetaCall:(id)sender {
    if (isWouldGetaCall == NO) {
        isWouldGetaCall = YES;
        self.img_GetaCall.image = [UIImage imageNamed:@"checkbox_selected"];
    }
    else
    {
        isWouldGetaCall = NO;
        self.img_GetaCall.image = [UIImage imageNamed:@"checkbox"];
    }
}
- (IBAction)doClickonRegistration:(id)sender {
    if (![self validateFirstNameAndLastName]) {
        return;
    }
    else if (![self validateEmailAddress]) {
        return;
    }
    else if (![self validatePhoneNumber]) {
        return;
    }
    if (self.isTermsConditionAccepted) {
//        [self.viewBlackTransparent setHidden:NO];
//        [self.viewConfirmMobile setHidden:NO];
        isRegButtonTapped = YES;
        
        if (isRegButtonTapped == YES) {
            [self startServiceToRegisterNewUser];
            
        }

        
    }
    else
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Please accept terms & conditions." onController:self];
}

#pragma mark -------------------------------------------
- (void)startServiceToRegisterNewUser{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *dictParams = @{@"Gender":[NSString stringWithFormat:@"%@",self.strGender],@"FirstName":[NSString stringWithFormat:@"%@",self.txtFirstName.text],@"LastName":[NSString stringWithFormat:@"%@",self.txtLastName.text],@"Phone1":[NSString stringWithFormat:@"%@",self.txtMobileNum.text],@"Email":[NSString stringWithFormat:@"%@",self.txtEmailId.text]};
    
    NSString *strParam = [dictParams jsonStringWithPrettyPrint:YES];
    NSString *strUrl =[NSString stringWithFormat:@"%@/api/Registrationapi/MobileRegister",kServerUrl];
    NSLog(@"%@",strUrl);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[NSURL URLWithString:strUrl]
                                    cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                    timeoutInterval:120.0f];
    
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    NSString *postString = strParam;
    NSData * data = [postString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[data length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:data];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         if (!connectionError)
         {
             NSLog(@"response--%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
             NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers error: nil];
             NSString *status = [responseObject valueForKey:@"status"];
             NSString *msg = [responseObject valueForKey:@"errorMessage"];
             if ([status isEqualToString:@"SUCCESS"])
             {
                 NSDictionary  *dictUserModel = [responseObject valueForKey:@"userModel"];
                 if ([[responseObject valueForKey:@"userModel"] isEqual:[NSNull null]])
                 {
                     
                     UIAlertController *alertController = [UIAlertController  alertControllerWithTitle:msg  message:nil  preferredStyle:UIAlertControllerStyleAlert];
                     [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                         
                         if ([msg isEqualToString:@"Mobile no. already registered."]) {
                            
                       //      [self dismissViewControllerAnimated:YES completion:nil];
                             
                             UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                             
                             ICSingletonManager *globals = [ICSingletonManager sharedManager];
                             globals.isFromLoginContinueGuestBuyVoucher = @"YES";
                             globals.isFromMenuForBuyVoucher = true;
                             LoginScreen *vcLogin = [storyboard instantiateViewControllerWithIdentifier:@"LoginScreen"];
                             SideMenuController *vcSideMenu =     [storyboard instantiateViewControllerWithIdentifier:@"SideMenuController"];
                             
                             MMDrawerController *drawerController = [[MMDrawerController alloc]initWithCenterViewController:vcLogin
                                                                                                   leftDrawerViewController:vcSideMenu];
                             [drawerController setRestorationIdentifier:@"MMDrawer"];
                             //                         [drawerController setMaximumLeftDrawerWidth:[UIScreen mainScreen].bounds.size.width -[UIScreen mainScreen].bounds.size.width/2 ];
                             [drawerController setMaximumLeftDrawerWidth:SCREEN_WIDTH*2/3];
                             
                             [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
                             [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
                             drawerController.shouldStretchDrawer = NO;
                             
                             UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:drawerController];
                             [navController setNavigationBarHidden:YES];
                             self.view.window.rootViewController = navController;
                             
                             
                     //        [self.navigationController pushViewController:vcLogin animated:YES];
                      //       [self.mm_drawerController setCenterViewController:vcLogin withCloseAnimation:YES completion:nil];
                             
                         }else{
                             [[ICSingletonManager sharedManager] showAlertViewWithMsg:msg onController:self];
                         }
                        
                         
                     }]];
                     
                     
                     [self presentViewController:alertController animated:YES completion:nil];
                     
                 }
                 else
                 {
                     
                             [self.viewBlackTransparent setHidden:NO];
                             [self.viewConfirmMobile setHidden:NO];

                     NSMutableDictionary *dictCleanedUserModel= [self cleanDictionary:[dictUserModel mutableCopy]];
                     dictUserModel = [dictCleanedUserModel copy];
                     
                     LoginManager *loginManage = [[LoginManager alloc]init];
                     [loginManage loginUserWithUserDataDictionary:dictUserModel ];
                     
                     NSDictionary *dict = [loginManage isUserLoggedIn];
                     NSLog(@"%@",dict);
                     
                     self.mobileNumber.text = self.txtMobileNum.text;
                     self.fname.text = self.txtFirstName.text;
                     self.lname.text = self.txtLastName.text;
                     self.email.text = self.txtEmailId.text;
                 //    [self PostDataforOrderID];
                 }
             }
             else if ([status isEqualToString:@"FAIL"])
             {
                 [[ICSingletonManager sharedManager] showAlertViewWithMsg:[responseObject objectForKey:@"errorMessage"] onController:self];
             }
             
             [MBProgressHUD hideHUDForView:self.view animated:YES];
         }
         else
         {
             NSLog(@"error--%@",connectionError);
             [[ICSingletonManager sharedManager] showAlertViewWithMsg:connectionError.localizedDescription onController:self];
             
             [MBProgressHUD hideHUDForView:self.view animated:YES];
         }
     }];
    
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

#pragma mark Google

- (IBAction)googleButtonTap:(id)sender
{
    [[GIDSignIn sharedInstance] signOut];
    [[GIDSignIn sharedInstance] signIn];
}
-(void)googleButton:(NSNotification*)notification
{
    //loginCheck = GOOGLE;
    //[self startServiceToRegisterNewUser];
    [self getSocialData:nil type:@"Google"];
}

#pragma mark Facebook
- (IBAction)facebookButtonTap:(id)sender
{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logOut];
    //    if ([FBSDKAccessToken currentAccessToken])
    //    {
    //        //NSLog(@"Token is available : %@",[[FBSDKAccessToken currentAccessToken]tokenString]);
    //        [self fetchUserInformationOfFacebook];
    //    }
    //    else
    //    {
    [login logInWithReadPermissions:@[@"email"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
     {
         if (error)
         {
             //NSLog(@"Login process error");
         }
         else if (result.isCancelled)
         {
             //NSLog(@"User cancelled login");
         }
         else
         {
             //NSLog(@"Login Success");
             
             if ([result.grantedPermissions containsObject:@"email"])
             {
                 //NSLog(@"result is:%@",result);
                 [self fetchUserInformationOfFacebook];
             }
             else
             {
                 //[SVProgressHUD showErrorWithStatus:@"Facebook email permission error"];
             }
         }
     }];
    //    }
    
}

#pragma mark - Custom Methods

-(void)fetchUserInformationOfFacebook
{
    if ([FBSDKAccessToken currentAccessToken])
    {
        //NSLog(@"Token is available : %@",[[FBSDKAccessToken currentAccessToken]tokenString]);
        
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, email, gender, first_name, last_name, picture.width(300).height(300)"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error)
             {
                 //NSLog(@"results:%@",result);
                 facebookDict = result;
                 
                 [self getSocialData:result type:@"FB"];
                 NSString *email = [result objectForKey:@"email"];
                 
                 if (email.length >0 )
                 {
                     //Start you app Todo
                 }
                 else
                 {
                     //NSLog(@"Facebook email is not verified");
                 }
             }
             else
             {
                 //NSLog(@"Error %@",error);
             }
         }];
    }
}

- (void)getSocialData:(NSDictionary *) socialDict type:(NSString *)type
{
    if ([type isEqualToString:@"FB"])
    {
        self.txtEmailId.text = [ICSingletonManager getStringValue:[socialDict objectForKey:@"email"]];
        self.txtFirstName.text = [ICSingletonManager getStringValue:[socialDict objectForKey:@"first_name"]];;
        self.txtLastName.text = [ICSingletonManager getStringValue:[socialDict objectForKey:@"last_name"]];;
        
        NSString * strGender = [ICSingletonManager getStringValue:[socialDict objectForKey:@"gender"]];
        if ([strGender isEqualToString:@"male"])
        {
            [self.btnRadioMale setBackgroundImage:[UIImage imageNamed:@"radio_selected"] forState:UIControlStateNormal];
            [self.btnRadioFemale setBackgroundImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
            self.strGender = @"M";
        }else
        {
            [self.btnRadioMale setBackgroundImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
            [self.btnRadioFemale setBackgroundImage:[UIImage imageNamed:@"radio_selected"] forState:UIControlStateNormal];
            self.strGender = @"F";
        }
        
    }else{
        
        AppDelegate *appDelegate= APPDELEGATE;
        self.txtEmailId.text = [ICSingletonManager getStringValue:appDelegate.Google_email];
        NSString * strName = [ICSingletonManager getStringValue:appDelegate.Google_name];
        NSArray * arr = [strName componentsSeparatedByString:@" "];
        NSLog(@"Array values are : %@",arr);
        self.txtFirstName.text = [arr objectAtIndex:0];
        self.txtLastName.text = [arr objectAtIndex:1];
        
        //        NSString * strGender = [ICSingletonManager getStringValue:[socialDict objectForKey:@"gender"]];
        //        if ([strGender isEqualToString:@"Male"])
        //        {
        //            [self.btnRadioMale setBackgroundImage:[UIImage imageNamed:@"radio_selected"] forState:UIControlStateNormal];
        //            [self.btnRadioFemale setBackgroundImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        //            self.strGender = @"M";
        //        }else
        //        {
        //            [self.btnRadioMale setBackgroundImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        //            [self.btnRadioFemale setBackgroundImage:[UIImage imageNamed:@"radio_selected"] forState:UIControlStateNormal];
        //            self.strGender = @"F";
        //        }
    }
    
}

#pragma mark - For Log - In & Continue
- (IBAction)doClickonLoginContinue:(id)sender {
    if (self.isTermsConditionAccepted) {
        
        _btn_ContinueGuest.alpha = 0.8;
        _btn_LogInContinue.alpha = 1.0;
        [_txt_MobileNumb becomeFirstResponder];
        
        self.scrollview.scrollEnabled = YES;
        _view_LoginForm.hidden = NO;
        _view_Registration.hidden = YES;
        //        _Height_RegistrationView.constant = 0;
        //        _height_LoginForm.constant = 340;
        if (IS_IPAD) {
            [self.scrollview setContentOffset:CGPointMake(0, 0)];
            self.scrollview.scrollEnabled = NO;
        }
    }
    else
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Please accept terms & conditions." onController:self];
    
}
- (IBAction)doClickonLogin:(id)sender {
    
    if (self.isTermsConditionAccepted) {
        BOOL ifUserNameEmpty = [self.txt_MobileNumb detectIfTextfieldIsEmpty:self.txt_MobileNumb.text];
        if (ifUserNameEmpty){
            [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Enter a mobile number" onController:self];
            return;
        }
        
        BOOL ifPasswordEmpty = [self.txt_Password detectIfTextfieldIsEmpty:self.txt_Password.text];
        if (ifPasswordEmpty){
            [[ICSingletonManager sharedManager] showAlertViewWithMsg:@"Enter a password" onController:self];
            return;
        }
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        NSString *strParams = [NSString stringWithFormat:@"userName=%@&password=%@&isAutoLogin=yes",self.txt_MobileNumb.text,self.txt_Password.text];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        [manager.requestSerializer setValue:@"application/json; charset=utf-8"
                         forHTTPHeaderField:@"Content-Type"];
        
        [manager POST:[NSString stringWithFormat:@"%@/api/Loginapi/Login?%@",kServerUrl,strParams] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"responseObject=%@",responseObject);
            
            NSString *status = [responseObject objectForKey:@"status"];
            // NSString *msg = [responseObject valueForKey:@"errorMessage"];
            if ([status isEqualToString:@"SUCCESS"]) {
                
                NSDictionary  *dictUserModel = [responseObject valueForKey:@"userModel" ];
                NSMutableDictionary *dictCleanedUserModel= [self cleanDictionary:[dictUserModel mutableCopy]];
                dictUserModel = [dictCleanedUserModel copy];
                
                LoginManager *loginManage = [[LoginManager alloc]init];
                [loginManage loginUserWithUserDataDictionary:dictUserModel ];
                
                NSDictionary *dict = [loginManage isUserLoggedIn];
                NSLog(@"%@",dict);
                
                [self postDataToPushNotification];
                [self startServiceToGetCouponsDetails];
                
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
    else
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Please accept terms & conditions." onController:self];
    
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
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8"
                     forHTTPHeaderField:@"Content-Type"];
    
    [manager GET:[NSString stringWithFormat:@"%@/api/AppPush/PushIOSInsertUUID?%@",kServerUrl,strParams] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [[ICSingletonManager sharedManager] showAlertViewWithMsg:error.localizedDescription onController:self];
        
        
    }];
}
- (void)startServiceToGetCouponsDetails
{
    
    
    
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
            
            ICSingletonManager *globals = [ICSingletonManager sharedManager];
            globals.validVoucher = numCouponCount;
            [[NSUserDefaults standardUserDefaults] setInteger:numCouponCount forKey:@"validVoucher"];
            NSDictionary *dict = [loginManage isUserLoggedIn];
            NSLog(@"%@",dict);
            
            self.mobileNumber.text = self.txt_MobileNumb.text;
            self.fname.text = [dict valueForKey:@"FirstName"];
            self.lname.text = [dict valueForKey:@"LastName"];
            self.email.text = [dict valueForKey:@"Email"];
            [self PostDataforOrderID];
            
        }
        
        NSLog(@"sucess");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [[ICSingletonManager sharedManager] showAlertViewWithMsg:error.localizedDescription onController:self];
        
    }];
    
    
}
- (IBAction)doClickonNotMember:(id)sender {
    self.strGender = @"M";
    _view_LoginForm.hidden = YES;
    //    _height_LoginForm.constant = 0;
    _view_Registration.hidden = NO;
    //    _Height_RegistrationView.constant = 480;
    if (IS_IPAD) {
        //        _Height_RegistrationView.constant = 550;
    }
}
#pragma mark - Forget View Controller
- (IBAction)doClickonForgotPassword:(id)sender {
    
    [self.viewBlackTransparent setHidden:NO];
    [self.viewForget setHidden:NO];
}
- (IBAction)doClickonSubmit:(id)sender {
    if ([self isValidContactNoumber:self.txt_ForgetMobNumber.text]) {
        [self startServiceToForgotPassword];
    }
}
#pragma mark - Networking API Implementation

-(void)startServiceToForgotPassword
{
    //  self.txtPassword.text = @"9971983440";
    
    if (!self.txt_ForgetMobNumber.text.length)
    {
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:kEnterValidPhoneNumber onController:self];
    }
    else if (self.txt_ForgetMobNumber.text.length != 10)
    {
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:kEnterValidPhoneNumber onController:self];
    }
    else
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        NSString *strParams = [NSString stringWithFormat:@"registeredemail=%@",self.txt_ForgetMobNumber.text];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        
        [manager.requestSerializer setValue:@"application/json; charset=utf-8"
                         forHTTPHeaderField:@"Content-Type"];
        
        [manager POST:[NSString stringWithFormat:@"%@/api/ForgotPasswordapi/ForgotPasswordapi?%@",kServerUrl,strParams] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"responseObject=%@",responseObject);
            
            [self.viewBlackTransparent setHidden:YES];
            [self.viewForget setHidden:YES];
            
            NSLog(@"sucess");
            self.txt_ForgetMobNumber.text =@"";
            NSString *msg= [responseObject valueForKey:@"errorMessage"];
            // NSString *status = [responseObject valueForKey:@"status"];
            [[ICSingletonManager sharedManager]showAlertViewWithMsg:msg onController:self];
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failure");
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [[ICSingletonManager sharedManager] showAlertViewWithMsg:error.localizedDescription onController:self];
            
        }];
    }
}

#pragma mark - Validating UITextField
- (BOOL)validateFirstNameAndLastName
{
    BOOL ifFirstNameLastNameValidated =YES;
    
    BOOL ifFirstNameEmpty = [self.txtFirstName detectIfTextfieldIsEmpty:self.txtFirstName.text];
    if (ifFirstNameEmpty)
    {
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:kEnterValidFirstName onController:self];
        ifFirstNameLastNameValidated = NO;
    }
    else if (self.txtFirstName.text.length<2)
    {
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"First name should be minimum Two cahracters" onController:self];
        ifFirstNameLastNameValidated = NO;
    }
    else
    {
        BOOL ifLastNameEmpty = [self.txtLastName detectIfTextfieldIsEmpty:self.txtLastName.text];
        if (ifLastNameEmpty)
        {
            [[ICSingletonManager sharedManager]showAlertViewWithMsg:kEnterValidLastName onController:self];
            ifFirstNameLastNameValidated = NO;
        }
        else if (self.txtLastName.text.length<2)
        {
            [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Last name should be minimum Two cahracters" onController:self];
            ifFirstNameLastNameValidated = NO;
        }
        else
        {
            NSInteger combOfFirstSecond=self.txtLastName.text.length+self.txtFirstName.text.length;
            
            if (combOfFirstSecond<5) {
                [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"First name, Second name combination should be minimum Five characters" onController:self];
                ifFirstNameLastNameValidated = NO;
            }
        }
    }
    return ifFirstNameLastNameValidated;
    
}

-(BOOL)validateEmailAddress{
    
    BOOL ifValidEmail = [self.txtEmailId.text isValidEmail];
    if (!ifValidEmail)
        [[ICSingletonManager sharedManager] showAlertViewWithMsg:kEnterValidEmailAddress onController:self];
    
    return  ifValidEmail;
}

- (BOOL)validatePhoneNumber
{
    BOOL ifValidPhoneNumber = [self.txtMobileNum.text isValidatePhone];
    if (!ifValidPhoneNumber)
    {
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:kEnterValidPhoneNumber onController:self];
    }
    return ifValidPhoneNumber;
}


- (BOOL)validateTermsCondition{
    if (self.isTermsConditionAccepted) {
        //        image = [UIImage imageNamed:@"checkbox_selected"];
        return YES;
    }
    else
    {
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:kAcceptTermsCondition onController:self];
        return NO;
    }
    
}
@end
