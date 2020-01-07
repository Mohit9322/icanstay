//
//  GiftaStayViewController.m
//  ICanStay
//
//  Created by Hitaishin on 30/01/17.
//  Copyright © 2017 verticallogics. All rights reserved.
//

#import "GiftaStayViewController.h"
#import "NotificationScreen.h"
#import "DashboardScreen.h"
#import "NSString+Validation.h"
#import "NSString+NSString_Extended.h"
#import "HomeScreenController.h"
#import "SideMenuController.h"

#define ACCEPTABLE_CHARACTERS @"0123456789"
@interface GiftaStayViewController ()<UIWebViewDelegate>{
    NSDictionary *dictFromServer;
    BOOL isTermforReg, isSendNotification,isTermAgree;
    int roomCount;
    NSString *strGiftGender, *strYourGender, *strDate, *strTime;
    int direction;
    int shakes;
    BOOL isff;
}
@property (strong, nonatomic) IBOutlet UIImageView *icsLogoImgView;

@end

@implementation GiftaStayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     DLog(@"DEBUG-VC");
    // Do any additional setup after loading the view.
   self.icsLogoImgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [self.icsLogoImgView addGestureRecognizer:singleFingerTap];
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
-(void)viewWillAppear:(BOOL)animated{
    roomCount = 1;
    NSDateFormatter *formate = [[NSDateFormatter alloc]init];
    [formate setDateFormat:@"dd MMM yyyy"];
    strDate = [formate stringFromDate:[NSDate date]];
    self.txt_SelectDate.text = strDate;
    
    [formate setDateFormat:@"HH:mm"];
    strTime = [formate stringFromDate:[NSDate date]];
    self.txt_SelectTime.text = strTime;
    
    self.txt_SelectTime.enabled = false;
    self.txt_SelectDate.enabled = false;
    [self fetchingUserGender];
    [self startServiceToGetCouponList];
    [self SetTermAndCondtionSmall];
}
-(void)SetTermAndCondtionSmall{
    NSString *htmlString = @"<html><head><style>@import url('https://fonts.googleapis.com/css?family=Gotham');ul{list-style:none;padding: 1px 0px 0px 0px; }ul li {background-image: url(http://www.icanstay.com/Content/Home/images/rev-slider/dot.png);  background-repeat: no-repeat; background-position: 0 0px; padding: 0px 10px 12px 18px; background-size: 13px;font-size: 18px; color:#555;  line-height: 20px; font-family:Josefin Sans, Verdana, Segoe, sans-serif;}</style></head><body><ul><li>Voucher valid for 11 months across India at all our Partner Hotel(s) and not for any specific Hotel.</li><li>Luxury Hotel will be confirmed subject to availability at the time of redemption.</li></ul></body></html>";
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
    [_webViewTermCond loadHTMLString:[ICSingletonManager getStringValue:htmlString] baseURL:nil];
    _webViewTermCond.scrollView.scrollEnabled = NO;
    
//    _txtView_TermVoucher.frame = CGRectMake(0, 0, _txtView_TermVoucher.frame.size.width, paragraphRect.size.height);
    
    _heightTermCondWebview.constant = paragraphRect.size.height+10;
}
#pragma mark - Fetch value from Save Preference
- (void)fetchingUserGender{
    LoginManager *loginManage = [[LoginManager alloc]init];
    NSDictionary *dict = [loginManage isUserLoggedIn];
    //NSLog(@"%@",dict);
    NSString *strGender = [dict valueForKey:@"Gender"];
    if ([strGender isEqualToString:@"F"]) {
        [self.btnGiftRadioMale setBackgroundImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        [self.btnGiftRadioFemale setBackgroundImage:[UIImage imageNamed:@"radio_selected"] forState:UIControlStateNormal];
        
        [self.btnYourRadioMale setBackgroundImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        [self.btnYourRadioFemale setBackgroundImage:[UIImage imageNamed:@"radio_selected"] forState:UIControlStateNormal];
        strGiftGender = @"F";
        strYourGender = @"F";
    }
    else {
        [self.btnGiftRadioMale setBackgroundImage:[UIImage imageNamed:@"radio_selected"] forState:UIControlStateNormal];
        [self.btnGiftRadioFemale setBackgroundImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        
        [self.btnYourRadioMale setBackgroundImage:[UIImage imageNamed:@"radio_selected"] forState:UIControlStateNormal];
        [self.btnYourRadioFemale setBackgroundImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        
        strGiftGender = @"M";
        strYourGender = @"M";
    }
   
    
    NSUserDefaults *nsUserDefaults= [NSUserDefaults standardUserDefaults];
    NSDictionary *userData = [nsUserDefaults objectForKey:KUserLogin];
    //  NSLog(@"%@",userData);
    _txt_Yourfname.text = [userData objectForKey:@"FirstName"];
    _txt_Yourlname.text = [userData objectForKey:@"LastName"];
    _txt_YourmobileNumber.text = [userData objectForKey:@"Phone1"];
    _txt_Youremail.text = [userData objectForKey:@"Email"];
}

#pragma mark - Fetch value from API For Coupen Detail
- (void)startServiceToGetCouponList{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8"
                     forHTTPHeaderField:@"Content-Type"];
    
    
    [manager GET:[NSString stringWithFormat:@"%@/api/CouponApi/GetBuyCouponDetailMobile?",kServerUrl] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        dictFromServer = (NSDictionary *)responseObject;
        [self settingCouponInfoFromServer:dictFromServer];
        
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
        
        
        [self.lblCouponName setText:[dict valueForKey:@"CouponText"]];
        [self.lblPriceCoupon setText:[NSString stringWithFormat:@"%@/-",mu]];
        
        NSString *stringTermsCondition = nil;
//        if (self.ifFromGiftedCoupon) {
            stringTermsCondition = [dict valueForKey:@"GiftCouponTerms"];
//            [self.lblGiftCouponText setText:[dict valueForKey:@"GiftCouponFooterTerms"]];
//        }
//        else
//            stringTermsCondition =[dict valueForKey:@"BuyCouponTerms"];
//        
        //    stringTermsCondition= [[ICSingletonManager sharedManager]removeNullObjectFromString:stringTermsCondition];
        //    stringTermsCondition = [[ICSingletonManager sharedManager] stringByStrippingHTMLFromString:stringTermsCondition];
        
        NSAttributedString *attrStr = [[NSAttributedString alloc] initWithData:[[stringTermsCondition stringByReplacingOccurrencesOfString:@"Coupon" withString:@"Voucher"] dataUsingEncoding:NSUTF8StringEncoding]
                                                                       options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                 NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}
                                                            documentAttributes:nil error:nil];
        NSLog(@"attrStr======%@",attrStr);
        
        [self.txtViewTerm setAttributedText:attrStr];
        
        NSString *strValidFrom =[dict valueForKey:@"CouponValidFrom"];
        strValidFrom= [strValidFrom substringToIndex: MIN(19, strValidFrom.length)];
        NSString *strValidTo = [dict valueForKey:@"CouponValidTill"];
        strValidTo = [strValidTo substringToIndex:MIN(19, strValidTo.length)];
        
        strValidFrom = [[ICSingletonManager sharedManager] returnFormatedStringDateFromString:strValidFrom];
        strValidTo = [[ICSingletonManager sharedManager] returnFormatedStringDateFromString:strValidTo];
        
        [self.lblCouponValidFrom setText:[NSString stringWithFormat:@"Valid From %@",strValidFrom]];
        [self.lblCouponValidTill setText:[NSString stringWithFormat:@"Valid Till %@",strValidTo]];
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
        
        //[self.txtView setAttributedText:attrStr];
    }
    
    
    //[[ICSingletonManager sharedManager]gettingNewlyFormattedDateStringFromString:[dict valueForKey:@"CouponValidFrom"]];
    //  NSLog(@"%@",str);
    
}

#pragma mark -Back Button Action
- (IBAction)backButtonTap:(id)sender
{

    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

#pragma mark -Decreas Room Count
- (IBAction)doClickonDecreasRoom:(id)sender {
    if (roomCount != 1 ) {
        roomCount--;
        _selectCouponCount.text = [NSString stringWithFormat:@"%d",roomCount];
    }
}

#pragma mark -Increas Room Count
- (IBAction)doClickonIncreaseRoom:(id)sender {
    if (roomCount != 10 ) {
        roomCount++;
        _selectCouponCount.text = [NSString stringWithFormat:@"%d",roomCount];
    }
}

#pragma mark - Gender Change For Gift Reciepent Detail
- (IBAction)btnGiftMaleRadioBtnTapped:(id)sender {
    [self.btnGiftRadioMale setBackgroundImage:[UIImage imageNamed:@"radio_selected"] forState:UIControlStateNormal];
    [self.btnGiftRadioFemale setBackgroundImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
    strGiftGender = @"M";
}

- (IBAction)btnGiftFemaleRadioBtnTapped:(id)sender {
    [self.btnGiftRadioMale setBackgroundImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
    [self.btnGiftRadioFemale setBackgroundImage:[UIImage imageNamed:@"radio_selected"] forState:UIControlStateNormal];
    strGiftGender = @"F";
}

#pragma mark - Gender Change For Your Detail
- (IBAction)btnYourMaleRadioBtnTapped:(id)sender {
    [self.btnYourRadioMale setBackgroundImage:[UIImage imageNamed:@"radio_selected"] forState:UIControlStateNormal];
    [self.btnYourRadioFemale setBackgroundImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
    strYourGender = @"M";
}

- (IBAction)btnYourFemaleRadioBtnTapped:(id)sender {
    [self.btnYourRadioMale setBackgroundImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
    [self.btnYourRadioFemale setBackgroundImage:[UIImage imageNamed:@"radio_selected"] forState:UIControlStateNormal];
    strYourGender = @"F";
}

#pragma mark - TextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    self.datePicker.backgroundColor = [UIColor whiteColor];
    
    
    if (textField == self.txt_SelectDate) {
        [self.viewDatePicker setHidden:NO];
        self.datePicker.datePickerMode = UIDatePickerModeDate;
        self.datePicker.tag = 100;
        self.datePicker.minimumDate = [NSDate date];
        self.txt_SelectTime.text = @"";
        return NO;
    }
    else if (textField == self.txt_SelectTime)
    {
        [self.viewDatePicker setHidden:NO];
        self.datePicker.datePickerMode = UIDatePickerModeTime;
        self.datePicker.minuteInterval = 30;
        self.datePicker.tag = 101;
        
        NSDateFormatter *formate = [[NSDateFormatter alloc]init];
        [formate setDateFormat:@"dd MMM yyyy"];
        NSDate *selectDate = [formate dateFromString:self.txt_SelectDate.text];
        if ([selectDate compare:[NSDate date]] == NSOrderedSame) {
            self.datePicker.minimumDate = [NSDate date];
        }
        return NO;
    }
    else
    {
        [self.viewDatePicker setHidden:YES];
        return YES;
    }
    return YES;
}
// called when 'return' key pressed. return NO to ignore.
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length == 0 && [string isEqualToString:@" "]) {
        return NO;
    }
    if(textField == self.txt_Giftfname || textField == self.txt_Giftlname || textField == self.txt_Yourfname || textField == self.txt_Yourlname )
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
    
    if (textField == self.txt_GiftmobileNumber || textField == self.txt_YourmobileNumber) {
        if (range.location == 10 || ![string isEqualToString:filtered])
            return NO;
        return YES;
    } else {
        return YES;
        
    }
}



-(NSString *)getURLFromString:(NSString *)str{
    
    NSString *urlStr = [str stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    return urlStr;
}

#pragma mark - DatePicker Value change Action and Done And Cancel Action
- (IBAction)dateandTimeValueChange:(UIDatePicker *)sender {
    
    NSDateFormatter *formate = [[NSDateFormatter alloc]init];
    if (sender.tag == 100) {
        [formate setDateFormat:@"dd MMM yyyy"];
        strDate = [formate stringFromDate:sender.date];
        
    }
    else{
        [formate setDateFormat:@"HH:mm"];
        strTime = [formate stringFromDate:sender.date];
    }
    
}
- (IBAction)doClickedonCancel:(id)sender {
    [self.viewDatePicker setHidden:YES];
}
- (IBAction)doClickedonDone:(id)sender {
    [self.viewDatePicker setHidden:YES];
    self.txt_SelectDate.text = strDate;
    self.txt_SelectTime.text = strTime;
}

#pragma mark - Action For Send Notification Button
- (IBAction)doClickonSendNotification:(UIButton *)sender {
    [self.viewDatePicker setHidden:true];
    if (isSendNotification == NO) {
        isSendNotification = YES;
        [sender setImage:[UIImage imageNamed:@"checkbox_selected"] forState:UIControlStateNormal];
        self.txt_SelectTime.enabled = true;
        self.txt_SelectDate.enabled = true;
    }
    else{
        isSendNotification = NO;
        [sender setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
        self.txt_SelectTime.enabled = false;
        self.txt_SelectDate.enabled = false;
    }
}

#pragma mark - Action ForTerm & Condition Button
- (IBAction)doClickonTermsCondition:(id)sender {
    self.transparentView.hidden = NO;
    self.viewTermsCond.hidden = NO;
}
- (IBAction)doClickedonDisagree:(id)sender {
    self.transparentView.hidden = YES;
    self.viewTermsCond.hidden = YES;
    isTermAgree = NO;
    [_btn_TermCond setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
}
- (IBAction)doClickedonAgree:(id)sender {
    self.transparentView.hidden = YES;
    self.viewTermsCond.hidden = YES;
    isTermAgree = YES;
    [_btn_TermCond setImage:[UIImage imageNamed:@"checkbox_selected"] forState:UIControlStateNormal];
}

#pragma mark - Action For Buy Voucher Button
- (IBAction)doClickonBuyVouchers:(id)sender {
    
    if ([self isNotZeroLengthString:self.txt_Giftfname.text fieldName:@"FName"] && [self isNotZeroLengthString:self.txt_Giftlname.text fieldName:@"LName"] && [self isNotZeroLengthString:self.txt_GiftmobileNumber.text fieldName:@"Phone"]  &&[self isValidContactNoumber:self.txt_GiftmobileNumber.text fieldName:@"Phone"] && [self isNotZeroLengthString:self.txt_Giftemail.text fieldName:@"Email"] &&[self isValidEmailORUsername:self.txt_Giftemail.text fieldName:@"Email"] && [self validateAlphabets:self.txt_Giftfname.text fieldName:@"FName"] && [self validateAlphabets:self.txt_Giftlname.text fieldName:@"LName"]  &&  [self isNotZeroLengthString:self.txt_Yourfname.text fieldName:@"YFName"] && [self isNotZeroLengthString:self.txt_Yourlname.text fieldName:@"YLName"] && [self isNotZeroLengthString:self.txt_YourmobileNumber.text fieldName:@"YPhone"]  &&[self isValidContactNoumber:self.txt_YourmobileNumber.text fieldName:@"YPhone"] && [self isNotZeroLengthString:self.txt_Youremail.text fieldName:@"YEmail"] &&[self isValidEmailORUsername:self.txt_Youremail.text fieldName:@"YEmail"] && [self validateAlphabets:self.txt_Yourfname.text fieldName:@"YFName"] && [self validateAlphabets:self.txt_Yourlname.text fieldName:@"YLName"])
    {
        
        if (isTermAgree) {
            [self PostDataforOrderID];
        }
        else
            [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Please accept terms & conditions." onController:self];
    }
}
#pragma mark - Webservice Delegate

//service to get order id
-(void)PostDataforOrderID
{
    //http://dev.icanstay.businesstowork.com/api/BuyCoupens/GetOrderIDMobile?
    //IsHotelMappedCity parameter
    
    LoginManager *loginManage = [[LoginManager alloc]init];
    NSDictionary *dict = [loginManage isUserLoggedIn];
    NSNumber *num = [NSNumber numberWithInt:0];
    if ([dict valueForKey:@"UserId"] != nil) {
        num = [dict valueForKey:@"UserId"];
    }
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *couponNumber = [f numberFromString:self.selectCouponCount.text];
    
    NSNumber *couponPrice= [dictFromServer valueForKey:@"CouponPrice"];
    couponPrice= [[ICSingletonManager sharedManager]removeNullObjectFromNumber:couponPrice];
    
    NSMutableDictionary *dictPost=[NSMutableDictionary new];
    [dictPost setValue:[NSNumber numberWithInt:0] forKey:@"OrderID"];
    [dictPost setValue:num forKey:@"UserID"];
    [dictPost setValue:couponNumber forKey:@"TotalCoupons"];
    
    NSString *strOrderDate=  [[ICSingletonManager sharedManager] convertToNSStringFromTodaysDate];
    
    
    
    [dictPost setValue:[NSNumber numberWithInt:[couponPrice intValue]*[couponNumber intValue]] forKey:@"TotalAmount"];
    [dictPost setValue:[NSNumber numberWithInt:[couponPrice intValue]*[couponNumber intValue]] forKey:@"NetAmount"];
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
//            orderID = msg;
            [self setupWebView : msg];
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

-(void)setupWebView : (NSString *)orderID
{
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    [tracker set:kGAIScreenName value:@"UserTriedPaymentMobile"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    NSString *strUserAddress = @"";NSString *strState = @"";NSString *strCity = @"";
    NSNumber * numPinCode = [NSNumber numberWithInt:0];
    LoginManager *loginManage = [[LoginManager alloc]init];
    NSDictionary *dict = [loginManage isUserLoggedIn];
    NSNumber *num = [NSNumber numberWithInt:0];;
    if ([dict valueForKey:@"UserId"] != nil) {
        num = [dict valueForKey:@"UserId"];
        strUserAddress = [dict valueForKey:@"Address"];
        strState = [dict valueForKey:@"State"];
        strCity = [dict valueForKey:@"City"];
        numPinCode= [dict valueForKey:@"Zip"];
    }
    
   
    
    
    NSNumber *couponPrice= [dictFromServer valueForKey:@"CouponPrice"];
    couponPrice= [[ICSingletonManager sharedManager]removeNullObjectFromNumber:couponPrice];
    
    int amount = [self.selectCouponCount.text intValue]*[couponPrice intValue];
    NSString *name = [NSString stringWithFormat:@"%@ %@",self.txt_Yourfname.text,self.txt_Yourlname.text];
    NSString *merchant2 =nil;
    
    // merchant2 previous was %@|%@|False|True|False but now changed to
    
    merchant2 = [NSString stringWithFormat:@"%@|%@|True|False|True",self.selectCouponCount.text,strYourGender];
        
    NSString *merchant3 = [NSString stringWithFormat:@"%@|%@|%@|%@",self.txt_YourmobileNumber.text,self.txt_GiftmobileNumber.text,self.txt_Giftfname.text,self.txt_Giftlname.text];
    
    NSString *merchant4 = [NSString stringWithFormat:@"%@|0|%@|%@|%@|%@",num,strUserAddress,strState,strCity,numPinCode];
    NSString *paymentUrlString =[NSString stringWithFormat:@"%@/PaymentProcess/MobilePaymentResponse",kServerUrl];
    //  NSString *paymentUrlString = @"http://dev.icanstay.com/PaymentProcess/MobilePaymentResponse";
    
     strTime =[strTime stringByReplacingOccurrencesOfString:@":" withString:@"colon"];
    NSString *merchant5 = [NSString stringWithFormat:@"%@|%@|%@|False|False|False|True|%@|%@|App",self.txt_Giftemail.text,_txt_Youremail.text,strGiftGender,strDate,strTime];
    
    
    //merchant5 - user etered email/ saved emailid / enter gender/|False|False|False|False||
    
    [self.webView setHidden:NO];
    [self.webView setDelegate:self];
    //    NSString *urlString= [NSString stringWithFormat:@"http://dev.icanstay.businesstowork.com/PaymentProcess/PaymentRequestProcess?UserID=%@&OrderID=%@&Amount=%d&Currency=INR&Language=EN&RedirectURL=%@&CancelURL=%@&MerchantParam1=%@&MerchantParam2=%@&MerchantParam3=%@&MerchantParam4=%@&MerchantParam5=%@&promo_code=null&customer_identifier=%@",num,orderID,amount,paymentUrlString,paymentUrlString,name,merchant2,merchant3,merchant4,merchant5,num];
    
    
    //    NSString *urlString= [NSString stringWithFormat:@"http://dev.icanstay.com/PaymentProcess/PaymentRequestProcess?UserID=%@&OrderID=%@&Amount=%d&Currency=INR&Language=EN&RedirectURL=%@&CancelURL=%@&MerchantParam1=%@&MerchantParam2=%@&MerchantParam3=%@&MerchantParam4=%@&MerchantParam5=%@&promo_code=null&customer_identifier=%@",num,orderID,amount,paymentUrlString,paymentUrlString,name,merchant2,merchant3,merchant4,merchant5,num];
    
    NSString *urlString= [NSString stringWithFormat:@"%@/PaymentProcess/PaymentRequestProcess?UserID=%@&OrderID=%@&Amount=%d&Currency=INR&Language=EN&RedirectURL=%@&CancelURL=%@&MerchantParam1=%@&MerchantParam2=%@&MerchantParam3=%@&MerchantParam4=%@&MerchantParam5=%@&promo_code=null&customer_identifier=%@",kServerUrl,num,orderID,amount,paymentUrlString,paymentUrlString,name,merchant2,merchant3,merchant4,merchant5,num];
    
    
    
    NSString* webStringURL = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL* url = [NSURL URLWithString:webStringURL];
    //  NSURL *url = [NSURL URLWithString:[self getURLFromString:urlString]];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:urlRequest];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (isff) {
        NSString *currentURL = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName(\"pre\")[0].innerHTML;"];
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:[currentURL dataUsingEncoding:NSUTF8StringEncoding]
                                                             options:kNilOptions
                                                               error:NULL];
        if ([[json objectForKey:@"status"] isEqualToString:@"SUCCESS"]) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Payment Successful" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        } else if ([[json objectForKey:@"status"] isEqualToString:@"FAIL"]) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Payment Failed" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Payment Cancelled" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        [self.webView setHidden:YES];
        HomeScreenController *homeScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeScreenController"];
        [self.mm_drawerController setCenterViewController:homeScreen withCloseAnimation:YES completion:nil];
        
        
    }
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
        id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
        [tracker set:kGAIScreenName value:@"UserSuccessfulPaymentMobile"];
        [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    }
    return YES;
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
            self.txt_Giftfname.placeholder=@"Please enter First Name";
            [self shake:self.txt_Giftfname:strMessage];
            [self.txt_Giftfname becomeFirstResponder];
        }
        if ([strFieldName isEqualToString:@"YFName"])
        {
            direction = 1;
            shakes = 0;
            self.txt_Yourfname.placeholder=@"Please enter First Name";
            [self shake:self.txt_Yourfname:strMessage];
            [self.txt_Yourfname becomeFirstResponder];
        }
        else if ([strFieldName isEqualToString:@"LName"])
        {
            direction = 1;
            shakes = 0;
            self.txt_Giftlname.placeholder=@"Please enter Last Name";
            [self shake:self.txt_Giftlname:strMessage];
            [self.txt_Giftlname becomeFirstResponder];
        }
        else if ([strFieldName isEqualToString:@"YLName"])
        {
            direction = 1;
            shakes = 0;
            self.txt_Yourlname.placeholder=@"Please enter Last Name";
            [self shake:self.txt_Yourlname:strMessage];
            [self.txt_Yourlname becomeFirstResponder];
        }
        else if ([strFieldName isEqualToString:@"Email"])
        {
            direction = 1;
            shakes = 0;
            self.txt_Giftemail.placeholder=@"Please enter Email";
            [self shake:self.txt_Giftemail:strMessage];
            [self.txt_Giftemail becomeFirstResponder];
        }
        else if ([strFieldName isEqualToString:@"YEmail"])
        {
            direction = 1;
            shakes = 0;
            self.txt_Youremail.placeholder=@"Please enter Email";
            [self shake:self.txt_Youremail:strMessage];
            [self.txt_Youremail becomeFirstResponder];
        }
        else if ([strFieldName isEqualToString:@"Phone"])
        {
            direction = 1;
            shakes = 0;
            self.txt_GiftmobileNumber.placeholder=@"Please enter Mobile Number";
            [self shake:self.txt_GiftmobileNumber:strMessage];
            [self.txt_GiftmobileNumber becomeFirstResponder];
        }
        else if ([strFieldName isEqualToString:@"YPhone"])
        {
            direction = 1;
            shakes = 0;
            self.txt_YourmobileNumber.placeholder=@"Please enter Mobile Number";
            [self shake:self.txt_YourmobileNumber:strMessage];
            [self.txt_YourmobileNumber becomeFirstResponder];
        }
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
            self.txt_Giftfname.placeholder=@"Please enter valid Fisrt Name";
            [self.txt_Giftfname becomeFirstResponder];
            direction = 1;
            shakes = 0;
            [self shake:self.txt_Giftfname:nil];
        }
    }
    if ([strFieldName isEqualToString:@"YFName"])
    {
        if (!isValid) {
            self.txt_Yourfname.placeholder=@"Please enter valid Fisrt Name";
            [self.txt_Yourfname becomeFirstResponder];
            direction = 1;
            shakes = 0;
            [self shake:self.txt_Yourfname:nil];

        }
    }
    else  if ([strFieldName isEqualToString:@"LName"])
    {
        if (!isValid) {
            self.txt_Giftlname.placeholder=@"Please enter valid Last Name";
            [self.txt_Giftlname becomeFirstResponder];
            direction = 1;
            shakes = 0;
            [self shake:self.txt_Giftlname:nil];
        }
    }
    else  if ([strFieldName isEqualToString:@"YLName"])
    {
        if (!isValid) {
            self.txt_Yourlname.placeholder=@"Please enter valid Last Name";
            [self.txt_Yourlname becomeFirstResponder];
            direction = 1;
            shakes = 0;
            [self shake:self.txt_Yourlname:nil];
        }
    }
    return isValid;
    
}
/// Check the Email Validation
-(BOOL)isValidEmailORUsername:(NSString *)strEmailID fieldName:(NSString *)strFieldName
{
    BOOL isValid=YES;
    if (!([strEmailID isValidEmail]))
    {
        isValid=NO;
        direction = 1;
        shakes = 0;
        if ([strFieldName isEqualToString:@"Email"]) {
            self.txt_Giftemail.placeholder=@"Please enter valid Email Id";
            [self.txt_Giftemail becomeFirstResponder];
            [self shake:self.txt_Giftemail:nil];
        }
        else{
            self.txt_Youremail.placeholder=@"Please enter valid Email Id";
            [self.txt_Youremail becomeFirstResponder];
            [self shake:self.txt_Youremail:nil];
        }
    }
    return isValid;
}

/// Check the Phone number Validation
-(BOOL)isValidContactNoumber:(NSString *) strPhone fieldName:(NSString *)strFieldName
{
    BOOL isValid=YES;
    if (!([strPhone isValidContactNo]))
    {
        isValid=NO;
        direction = 1;
        shakes = 0;
        if ([strFieldName isEqualToString:@"Phone"]) {
            self.txt_GiftmobileNumber.placeholder=@"Please enter valid Mobile number";
            [self.txt_GiftmobileNumber becomeFirstResponder];
            [self shake:self.txt_GiftmobileNumber:nil];
        }
        else{
            self.txt_YourmobileNumber.placeholder=@"Please enter valid Mobile number";
            [self.txt_YourmobileNumber becomeFirstResponder];
            [self shake:self.txt_YourmobileNumber:nil];
        }
        
    }
    return isValid;
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
-(IBAction)doClickedonNotificationBell:(id)sender
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
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
    globals.isFromMenu = false;
    
    LoginScreen *vcLogin = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginScreen"];
    [self.navigationController pushViewController:vcLogin animated:YES];
}
@end
