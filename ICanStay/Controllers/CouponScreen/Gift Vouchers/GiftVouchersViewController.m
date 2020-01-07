//
//  GiftVouchersViewController.m
//  ICanStay
//
//  Created by Hitaishin on 02/02/17.
//  Copyright © 2017 verticallogics. All rights reserved.
//

#import "GiftVouchersViewController.h"
#import "NotificationScreen.h"
#import "NSString+Validation.h"
#import "NSString+NSString_Extended.h"
#import "HomeScreenController.h"
#import "SideMenuController.h"
#define ACCEPTABLE_CHARACTERS @"0123456789"
@interface GiftVouchersViewController ()<UIWebViewDelegate>{
    BOOL isTermReg, isSendNotification, isTermforReg , isff;
    int direction;
    int shakes;
}
@property (strong, nonatomic) IBOutlet UIImageView *icsLogoImgView;

@property (strong, nonatomic) NSMutableArray *arrayCouponList;
@property (strong, nonatomic) NSDictionary *selectedCouponList, *dictFromServer;
@property int pickerSelect;
@property NSString *strDate, *strTime, *strGender;
@end

@implementation GiftVouchersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     DLog(@"DEBUG-VC");
    // Do any additional setup after loading the view.
    NSDateFormatter *formate = [[NSDateFormatter alloc]init];
    [formate setDateFormat:@"dd MMM yyyy"];
    _strDate = [formate stringFromDate:[NSDate date]];
    self.txt_selectDate.text = _strDate;
    
    [formate setDateFormat:@"HH:mm"];
    _strTime = [formate stringFromDate:[NSDate date]];
    self.txt_SelectTime.text = _strTime;
    
    self.txt_SelectTime.enabled = false;
    self.txt_selectDate.enabled = false;
    
    _strGender = @"M";
    
    [self getCouponList];
    
    
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Fetch Coupen Detail from server
-(void)getCouponList
{
    LoginManager *loginManage = [[LoginManager alloc]init];
    NSDictionary *dict = [loginManage isUserLoggedIn];
    NSNumber *num = [dict valueForKey:@"UserId"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *strParams = [NSString stringWithFormat:@"userid=%@",num];
    
    // NSString *strParams = [NSString stringWithFormat:@"userid=%@",num];
//    https://www.icanstay.com/api/Wishlist/GetUserCouponsListForTransfer?userid=71747
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8"
                     forHTTPHeaderField:@"Content-Type"];
    
    [manager GET:[NSString stringWithFormat:@"%@/api/Wishlist/GetUserCouponsListForTransfer?%@",kServerUrl,strParams] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"responseObject=%@",responseObject);
         self.arrayCouponList = [[NSMutableArray alloc]init];
         self.arrayCouponList = [responseObject mutableCopy];
         
         if ([[self.arrayCouponList valueForKey:@"CouponCodeDate"]containsObject:@"--Select Voucher--"]) {
             
             for (int i =0; i<self.arrayCouponList.count ; i++) {
                 if ([[[self.arrayCouponList valueForKey:@"CouponCodeDate"] objectAtIndex:i] isEqualToString:@"--Select Voucher--"]) {
                     [self.arrayCouponList removeObjectAtIndex:i];
                     break;
                 }
             }
         }
         
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         [self startServiceToGetCouponList];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"failure");
         
         [[ICSingletonManager sharedManager]showAlertViewWithMsg:error.localizedDescription onController:self];
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         [self startServiceToGetCouponList];
         
     }];
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
        _dictFromServer = (NSDictionary *)responseObject;
        [self settingCouponInfoFromServer:_dictFromServer];
        
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
        
        NSString *stringTermsCondition = nil;
        stringTermsCondition = [dict valueForKey:@"GiftCouponTerms"];
        NSAttributedString *attrStr = [[NSAttributedString alloc] initWithData:[[stringTermsCondition stringByReplacingOccurrencesOfString:@"Coupon" withString:@"Voucher"] dataUsingEncoding:NSUTF8StringEncoding]
                                                                       options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                 NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}
                                                            documentAttributes:nil error:nil];
        NSLog(@"attrStr======%@",attrStr);
        
        [self.txtv_Term setAttributedText:attrStr];
        
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
#pragma mark - Notificatio Bell Action
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

#pragma mark - TextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    self.datePicker.backgroundColor = [UIColor whiteColor];
    
    
    if (textField == self.txt_selectDate) {
        [_scrollView setContentOffset:CGPointMake(0, 150) animated:YES];
        _pickerSelect = 2;
        [self.viewPicker setHidden:NO];
        [self.pickerView setHidden:YES];
        [self.datePicker setHidden:NO];
        self.datePicker.datePickerMode = UIDatePickerModeDate;
        self.datePicker.tag = 100;
        self.datePicker.minimumDate = [NSDate date];
        self.txt_SelectTime.text = @"";
        return NO;
    }
    else if (textField == self.txt_SelectTime)
    {
        [_scrollView setContentOffset:CGPointMake(0, 150) animated:YES];
        _pickerSelect = 3;
        [self.viewPicker setHidden:NO];
        [self.pickerView setHidden:YES];
        [self.datePicker setHidden:NO];
        self.datePicker.datePickerMode = UIDatePickerModeTime;
        self.datePicker.minuteInterval = 30;
        self.datePicker.tag = 101;
        
        NSDateFormatter *formate = [[NSDateFormatter alloc]init];
        [formate setDateFormat:@"dd MMM yyyy"];
        NSDate *selectDate = [formate dateFromString:self.txt_selectDate.text];
        if ([selectDate compare:[NSDate date]] == NSOrderedSame) {
            self.datePicker.minimumDate = [NSDate date];
        }
        return NO;
    }
    if (self.txt_Voucher == textField) {
        _pickerSelect = 1;
        [self.viewPicker setHidden:NO];
        [self.datePicker setHidden:YES];
        [self.pickerView reloadAllComponents];
        [self.pickerView setHidden:NO];
        return NO;
    }
    else
    {
        [self.viewPicker setHidden:YES];
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
    if(textField == self.txt_Fname || textField == self.txt_Lname )
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
    
    if (textField == self.txt_Mobileno) {
        if (range.location == 10 || ![string isEqualToString:filtered])
            return NO;
        return YES;
    } else {
        return YES;
        
    }
}

#pragma mark- Gender Change Action
- (IBAction)doClickedonMale:(id)sender {
    _strGender = @"M";
    [_btn_Male setImage:[UIImage imageNamed:@"radio_selected"] forState:UIControlStateNormal];
    [_btn_Female setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
}
- (IBAction)doClickedonFemale:(id)sender {
    _strGender = @"F";
    [_btn_Male setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
    [_btn_Female setImage:[UIImage imageNamed:@"radio_selected"] forState:UIControlStateNormal];
}

#pragma mark- Term & condition Action
- (IBAction)doClickedonTermandCondition:(UIButton *)sender {
    _blackTransparentView.hidden = NO;
    _viewTermCond.hidden = NO;
}
- (IBAction)doClickedonDisAgree:(id)sender {
    isTermReg = NO;
    [_btnTermcond setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
    _blackTransparentView.hidden = YES;
    _viewTermCond.hidden = YES;
}
- (IBAction)doClickedonAgree:(id)sender {
    isTermReg = YES;
    [_btnTermcond setImage:[UIImage imageNamed:@"checkbox_selected"] forState:UIControlStateNormal];
    _blackTransparentView.hidden = YES;
    _viewTermCond.hidden = YES;
}

- (IBAction)doClickedonSendNotification:(id)sender {
    [self.viewPicker setHidden:true];
    if (isSendNotification == NO) {
        isSendNotification = YES;
        [sender setImage:[UIImage imageNamed:@"checkbox_selected"] forState:UIControlStateNormal];
        self.txt_SelectTime.enabled = true;
        self.txt_selectDate.enabled = true;
    }
    else{
        isSendNotification = NO;
        [sender setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
        self.txt_SelectTime.enabled = false;
        self.txt_selectDate.enabled = false;
    }
}


#pragma mark Picker View Delegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}


-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    int count=0;
    count = (int)[self.arrayCouponList count];
    return count;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    NSString *title;
    UILabel* tView = (UILabel*)view;
    if (!tView)
    {
        tView = [[UILabel alloc] init];
        [tView setNumberOfLines:1];
        [tView setFont:[UIFont systemFontOfSize:17]];
        [tView setTextAlignment:NSTextAlignmentCenter];
    }
    
    title = [[self.arrayCouponList valueForKey:@"CouponCodeDate"] objectAtIndex:row];
    
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    tView.attributedText=attString;
    
    return tView;
}

- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated
{
    [self.pickerView selectRow:0 inComponent:0 animated:YES];
}

#pragma mark - DatePicker Value change Action and Done And Cancel Action
- (IBAction)dateandTimeValueChange:(UIDatePicker *)sender {
    
    NSDateFormatter *formate = [[NSDateFormatter alloc]init];
    if (sender.tag == 100) {
        [formate setDateFormat:@"dd MMM yyyy"];
        _strDate = [formate stringFromDate:sender.date];
        self.txt_selectDate.text = _strDate;
        
    }
    else{
        [formate setDateFormat:@"HH:mm"];
        _strTime = [formate stringFromDate:sender.date];
        self.txt_SelectTime.text = _strTime;
    }
    
}

#pragma mark - Picker Done and Cancel Action
- (IBAction)doClickonPickerCancel:(id)sender {
    [self.viewPicker setHidden:YES];
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}
- (IBAction)doClickonPickerDone:(id)sender {
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    if (_pickerSelect == 1 && [self.arrayCouponList count] !=0) {
        self.selectedCouponList = [self.arrayCouponList objectAtIndex:[self.pickerView selectedRowInComponent:0]];
        self.txt_Voucher.text = [[self.arrayCouponList valueForKey:@"CouponCodeDate"] objectAtIndex:[self.pickerView selectedRowInComponent:0]];
    }    
    [self.viewPicker setHidden:YES];
}

#pragma mark - API Calling for Buy Voucher
- (IBAction)doClickonBuyVoucher:(id)sender {
    if ([self isNotZeroLengthString:self.txt_Voucher.text fieldName:@"Voucher"] && [self isNotZeroLengthString:self.txt_Fname.text fieldName:@"FName"] && [self isNotZeroLengthString:self.txt_Lname.text fieldName:@"LName"] && [self isNotZeroLengthString:self.txt_Emailid.text fieldName:@"Email"] && [self isValidEmailORUsername:self.txt_Emailid.text fieldName:@"Email"] && [self isNotZeroLengthString:self.txt_Mobileno.text fieldName:@"Phone"] && [self isValidContactNoumber:self.txt_Mobileno.text fieldName:@"Phone"])
    {
        
        if (isTermReg) {
            [self setupWebView];
        }
        else
            [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Please accept terms & conditions." onController:self];
    }
    
}

-(void)setupWebView
{
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    [tracker set:kGAIScreenName value:@"UserTriedPaymentMobile"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    LoginManager *loginManage = [[LoginManager alloc]init];
    NSDictionary *dict = [loginManage isUserLoggedIn];
    NSNumber *num = [dict valueForKey:@"UserId"];
    
    NSNumber *couponPrice= [_dictFromServer valueForKey:@"CouponPrice"];
    couponPrice= [[ICSingletonManager sharedManager]removeNullObjectFromNumber:couponPrice];
    
    int amount = [couponPrice intValue];
    
    
    NSString *urlString= [NSString stringWithFormat:@"%@/PaymentProcess/MobileTransferVoucher?OrderID=0&CouponId=0&UserId=%@&FirstName=%@&LastName=%@&MobileNo=%@&RegisteredMobileNo=%@&RegisteredEmail=%@&Email=%@&NoOfCoupons=1&&ReedemPoints=0&&NetAmount=%d&Status=false&IsAuthenticated=true&Gender=%@&NotificationOnRegisteredMobile=false&IsGiftStay=true&PersonFirstName=%@&PersonLastName=%@&PersonGender=%@&GiftTo_User_Id=0&ForFamilyStay=false&ForBusiness=false&ForGift=false&GiftNotificationSent=true&GiftNotifyDate=%@&GiftNotifyTime=%@&TotalCouponAmount=0&RedeemCouponAmount=0&RedeemCouponCount=0&wishListId=0&Prf_Dest_id=0&HotelSelected=0&CouponCode=%@&Source=App&CorporateId=0&ForOffer=false",kServerUrl,num,[dict valueForKey:@"FirstName"],[dict valueForKey:@"LastName"],_txt_Mobileno.text,[dict valueForKey:@"Phone1"],[dict valueForKey:@"Email"],self.txt_Emailid.text,amount,[dict valueForKey:@"Gender"],self.txt_Fname.text,self.txt_Lname.text,_strGender,self.txt_selectDate.text,self.txt_SelectTime.text,[self.selectedCouponList valueForKey:@"CouponCode"]];
    
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
    [manager GET:[self getURLFromString:urlString] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        
//        NSString *status = [responseObject valueForKey:@"status"];
        NSString *msg = [responseObject valueForKey:@"errorMessage"];
        if (![msg isEqual:[NSNull null]]) {
            if ([msg isEqualToString:@"Voucher Gifted Successfully"]) {
                //            orderID = msg;
                HomeScreenController *homeScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeScreenController"];
                [self.mm_drawerController setCenterViewController:homeScreen withCloseAnimation:YES completion:nil];
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
                    LoginManager *login = [[LoginManager alloc]init];
                    if ([[login isUserLoggedIn] count]>0)
                    {
                        SideMenuController *vcSideMenu = [[SideMenuController alloc]init];
                        [vcSideMenu startServiceToGetCouponsDetails];
                    }
                });
                
                
            }
        }
        
        
        NSLog(@"sucess");
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:msg onController:self];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
                
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:error.localizedDescription onController:self];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}
-(NSString *)getURLFromString:(NSString *)str{
    
    NSString *urlStr = [str stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    return urlStr;
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
        [self.paymentWebview setHidden:YES];
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
        if ([strFieldName isEqualToString:@"Voucher"])
        {
            direction = 1;
            shakes = 0;
            self.txt_Voucher.placeholder=@"Please select voucher";
            [self shake:self.txt_Voucher:strMessage];
            [self.txt_Voucher becomeFirstResponder];
        }
        if ([strFieldName isEqualToString:@"FName"])
        {
            direction = 1;
            shakes = 0;
            self.txt_Fname.placeholder=@"Please enter First Name";
            [self shake:self.txt_Fname:strMessage];
            [self.txt_Fname becomeFirstResponder];
        }
        else if ([strFieldName isEqualToString:@"LName"])
        {
            direction = 1;
            shakes = 0;
            self.txt_Lname.placeholder=@"Please enter Last Name";
            [self shake:self.txt_Lname:strMessage];
            [self.txt_Lname becomeFirstResponder];
        }
        else if ([strFieldName isEqualToString:@"Email"])
        {
            direction = 1;
            shakes = 0;
            self.txt_Emailid.placeholder=@"Please enter Email";
            [self shake:self.txt_Emailid:strMessage];
            [self.txt_Emailid becomeFirstResponder];
        }
        else if ([strFieldName isEqualToString:@"Phone"])
        {
            direction = 1;
            shakes = 0;
            self.txt_Mobileno.placeholder=@"Please enter Mobile Number";
            [self shake:self.txt_Mobileno:strMessage];
            [self.txt_Mobileno becomeFirstResponder];
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
            self.txt_Fname.placeholder=@"Please enter valid Fisrt Name";
            [self.txt_Fname becomeFirstResponder];
            direction = 1;
            shakes = 0;
            [self shake:self.txt_Fname:nil];
        }
    }
    if ([strFieldName isEqualToString:@"LName"])
    {
        if (!isValid) {
            self.txt_Lname.placeholder=@"Please enter valid Last Name";
            [self.txt_Lname becomeFirstResponder];
            direction = 1;
            shakes = 0;
            [self shake:self.txt_Lname:nil];
            
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
            self.txt_Emailid.placeholder=@"Please enter valid Email Id";
            [self.txt_Emailid becomeFirstResponder];
            [self shake:self.txt_Emailid:nil];
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
            self.txt_Mobileno.placeholder=@"Please enter valid Mobile number";
            [self.txt_Mobileno becomeFirstResponder];
            [self shake:self.txt_Mobileno:nil];
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


@end
