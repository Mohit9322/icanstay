  //
//  MakeAWishlistViewController.m
//  ICanStay
//
//  Created by Hitaishin on 29/12/16.
//  Copyright © 2016 verticallogics. All rights reserved.
//

#import "MakeAWishlistViewController.h"
#import "NotificationScreen.h"
#import "DashboardScreen.h"
#import "BuyCouponViewController.h"
#import "MyWishlistViewController.h"
#import "CreateWishlistTableViewCell.h"
#import "ICSingletonManager.h"
#import "HomeScreenController.h"
#import "SideMenuController.h"

#define kCoupon                         0
#define kDestination                    1
#define kYear                           4
#define kMonths                         5
#define kDate                           6
#define kSpecialDay                     7

@interface MakeAWishlistViewController ()<UITextFieldDelegate>{
    int roomCount;
    NSString * selectedMonth ,* prefered_Type, *selectedSpecialDateId,*familyStay, *selectedCity;
    int selectPicker;
    NSMutableArray *mArrayYears,*mArrayMonths,*mArraydate,*mArrayWeek ,*mArrayWeekNo,*mArraySelectedCoupon;
    
    BOOL isFamilyStayMessageClicked,isNotEnoughCouponCount,isNotifyMeClicked,isOPTChecked,isSetSpecialday;
    IBOutlet UIView *viewBlackTransparent;
    IBOutlet UIView *viewTermsCondition;
    IBOutlet UITextView *txtViewTerm;
    IBOutlet UIButton *btn_GSP_Status;
    IBOutlet UIWebView *webW_Reason;
    IBOutlet UIView *view_GSP_Status;
    NSString *GuaranteedStayApplicable;
    IBOutlet UIView *viewGSPResponce;
    IBOutlet UIButton *btn_closeGSP;
}
@property (strong, nonatomic) IBOutlet UIImageView *icsLogoImgView;

@end

@implementation MakeAWishlistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     DLog(@"DEBUG-VC");
    // Do any additional setup after loading the view.
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        _HeaderViewHeight.constant = 100;
        _voucherLayout.constant = 60;
        _destinationConstraint.constant = 60;
        _yearConstraint.constant = 60;
        _monthContraint.constant = 60;
        _dateContraint.constant = 60;
    }
    
    if (self.isFromEdit) {
        _lbl_MakeAWishList.text = @"Update A Wishlist";
        [_btnAddToWishList setTitle:@"Update A Wishlist" forState:UIControlStateNormal];
    }else if (!self.isFromEdit)
        
        [self setCurrentYear];
    {
        
        
    }
    _opt_Constraint.constant = 0;
    view_GSP_Status.hidden = YES;
    roomCount = 1;
    _lbl_Rooms.text = [NSString stringWithFormat:@"%d",roomCount];
    prefered_Type = @"3";
    selectedSpecialDateId = @"";
    self.arrayMonthList = @[@"January", @"February", @"March", @"April", @"May", @"June", @"July", @"August", @"September", @"October", @"November", @"December"];
    
    self.scrollview.contentSize = CGSizeMake(self.view.frame.size.width, self.btnAddToWishList.frame.origin.y+self.btnAddToWishList.frame.size.height+10);
    _btn_Check_Box2.hidden = YES;
    _lbl_MSG_CheckBox2.hidden =YES;
    isFamilyStayMessageClicked = NO;
    isOPTChecked = NO;
    isNotifyMeClicked = NO;
    self.tbl_List.hidden = YES;
    
    if (self.isFromEdit) {
        [self getCouponList];
         [self getPreferredLocation:@"true"];

    }else{
        [self getCouponList];
        [self getPreferredLocation:@"true"];
        [self getTermconditionforGSP];

    }
    isFamilyStayMessageClicked = true;
    
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
-(void)setCurrentYear
{
  
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    NSString *yearString = [formatter stringFromDate:[NSDate date]];
    self.txt_Year.text = yearString;
    [self.txt_Month setValue:[ICSingletonManager colorFromHexString:@"#BD9854"]forKeyPath:@"_placeholderLabel.textColor"];
    self.dropDown2.image = [UIImage imageNamed:@"dropdownFill"];
    _imgLine2.backgroundColor = [ICSingletonManager colorFromHexString:@"#BD9854"];

}

-(void)viewWillAppear:(BOOL)animated{
    if (self.isFromEdit) {
        id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
        [tracker set:kGAIScreenName value:@"Update WishList"];
        [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    }
    else{
        id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
        [tracker set:kGAIScreenName value:@"Create WishList"];
        [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    }
    
//    if (self.couponCodeFromMyWishlist) {
//        self.txt_Voucher.text = self.couponCodeFromMyWishlist;
//    }
    
}
#pragma mark- Webservice Methods

//service to get coupons
-(void)getCouponList
{
    //http://192.168.2.5:8585/api/Wishlist/GetUserCouponsList?userid=31458
    
    LoginManager *loginManage = [[LoginManager alloc]init];
    NSDictionary *dict = [loginManage isUserLoggedIn];
    NSNumber *num = [dict valueForKey:@"UserId"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *strParams = [NSString stringWithFormat:@"userid=%@",num];
    
    // NSString *strParams = [NSString stringWithFormat:@"userid=%@",num];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8"
                     forHTTPHeaderField:@"Content-Type"];
    
   
    
    [manager GET:[NSString stringWithFormat:@"%@/api/Wishlist/GetUserCouponsList?%@",kServerUrl,strParams] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"responseObject=%@",responseObject);
         self.arrayCouponList = [[NSMutableArray alloc]init];
         self.arrayCouponList = [responseObject mutableCopy];
         
         
         
         
         if ([[self.arrayCouponList valueForKey:@"CouponCodeDate"]containsObject:@"-All-"]) {
             
             for (int i =0; i<self.arrayCouponList.count ; i++) {
                 if ([[[self.arrayCouponList valueForKey:@"CouponCodeDate"] objectAtIndex:i] isEqualToString:@"-All-"]) {
                     [self.arrayCouponList removeObjectAtIndex:i];
                     break;
                 }
             }
         }
         self.arrayValidCoupen = [[NSMutableArray alloc]init];
         self.arrayValidCoupen = [self.arrayCouponList mutableCopy];
         
         if (self.isFromEdit) {
             
             for (int i=0; i<self.arrayCouponList.count; i++)
             {
                 if ([[[self.arrayCouponList objectAtIndex:i] valueForKey:@"CouponCode"]isEqualToString:[self.dictionaryCouponList objectForKey:@"CouponCode"]])
                 {
                     [self ManageWishlistByCoupon:[self.dictionaryCouponList objectForKey:@"CouponCode"]];
                     
                     self.selectedCouponList = [self.arrayCouponList objectAtIndex:i];
                     self.arraySpecialDayList = [[NSArray alloc]init];
                     
                     
                     NSDictionary *dict =  [self.arrayCouponList  objectAtIndex:i];  //tempbyNamit
                     
                     self.txt_Voucher.text = [dict valueForKey:@"CouponCodeDate"];
                     _opt_Constraint.constant = 31;
                     _btn_Check_Box2.hidden = NO;
                     _lbl_MSG_CheckBox2.hidden = NO;
                     
                     prefered_Type = [NSString stringWithFormat:@"%@",[self.dictionaryCouponList valueForKey:@"WishlistType"]];
                     
                     NSString *str=[NSString stringWithFormat:@"%@",self.dictionaryCouponList];
                     NSLog(@"%@",str);
                     
                     [self.txt_Year setText:[[self.dictionaryCouponList valueForKey:@"Prf_Year"] stringValue]];
                     
                     if ([prefered_Type isEqualToString:@"3"]) {
                         [self doClickonDate:self];
                         _imgLine3.backgroundColor = [ICSingletonManager colorFromHexString:@"#BD9854"];
                         _dropDown3.image = [UIImage imageNamed:@"dropdownFill"];
                         _txt_Date.enabled = YES;
                         
                         _imgLine2.backgroundColor = [ICSingletonManager colorFromHexString:@"#BD9854"];
                         _dropDown2.image = [UIImage imageNamed:@"dropdownFill"];
                         _txt_Month.enabled = YES;
                         
                     }
                     else if ([prefered_Type isEqualToString:@"2"]) {
                         [self doClickonWeek:self];
                         _imgLine3.backgroundColor = [ICSingletonManager colorFromHexString:@"#BD9854"];
                         _dropDown3.image = [UIImage imageNamed:@"dropdownFill"];
                         _txt_Date.enabled = YES;
                         
                         _imgLine2.backgroundColor = [ICSingletonManager colorFromHexString:@"#BD9854"];
                         _dropDown2.image = [UIImage imageNamed:@"dropdownFill"];
                         _txt_Month.enabled = YES;
                     }
                     else if ([prefered_Type isEqualToString:@"1"]) {
                         [self doClickonMonth:self];
                         _imgLine2.backgroundColor = [ICSingletonManager colorFromHexString:@"#BD9854"];
                         _dropDown2.image = [UIImage imageNamed:@"dropdownFill"];
                         _txt_Month.enabled = YES;
                     }
                     else if ([prefered_Type isEqualToString:@"4"]) {
                         [self doClickonSpclDay:self];
                         isSetSpecialday = YES;
                         [self getSpecialDayList];
                     }
                     
                     
                     NSNumber *numMonth = [self.dictionaryCouponList valueForKey:@"Prf_Month"];
                     NSString *month = [self.arrayMonthList objectAtIndex:([numMonth intValue] -1)];
                     [self.txt_Month setText:month];
                      [self.txt_Year setText:[[self.dictionaryCouponList valueForKey:@"Prf_Year"] stringValue]];
                     if ([[[self.dictionaryCouponList valueForKey:@"Prf_Day"] stringValue] isEqualToString:@"0"]) {
                         self.txt_Date.text = [NSString stringWithFormat:@"Week %@[%@ - %@]",[self.dictionaryCouponList valueForKey:@"Prf_Week"],[ICSingletonManager  gettingDateFromString:[self.dictionaryCouponList valueForKey:@"Prf_From_date"]],[ICSingletonManager  gettingDateStringFromString:[self.dictionaryCouponList valueForKey:@"Prf_To_date"]]];
                     }
                     else
                     {
                         
                         [self.txt_Date setText:[[self.dictionaryCouponList valueForKey:@"Prf_Day"] stringValue]];
                     }
                     
                      self.txt_Voucher.text = [dict valueForKey:@"CouponCodeDate"];
                 }
             }
             
             self.txt_Destitation.text = [self.dictionaryCouponList objectForKey:@"City_Name"];
             selectedCity = [self.dictionaryCouponList objectForKey:@"City_Id"];
             
             if ([[self.dictionaryCouponList objectForKey:@"FamilyStay"] isEqualToString:@"N"])
             {
                 familyStay = @"NO";
                 [self.btn_CheckBox setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
                 self.lbl_Rooms.text = [[self.dictionaryCouponList objectForKey:@"RoomCount"] stringValue];
                 roomCount = [self.lbl_Rooms.text intValue];
                 
                 
                 isFamilyStayMessageClicked = false;
                 //[self.roomsView setHidden:YES];
                 
             }
             else
             {
                 familyStay = @"YES";
                 self.lbl_Rooms.text = [[self.dictionaryCouponList objectForKey:@"RoomCount"] stringValue];
                 roomCount = [self.lbl_Rooms.text intValue];
             }
             // self.isFromEdit = false;
                    } else
         {
             {
                 
                 _opt_Constraint.constant = 31;
                 
                 for (NSDictionary *dict  in self.arrayCouponList) {
                     
                     if ([self.couponCodeFromMyWishlist isEqualToString:[dict objectForKey:@"CouponCodeDate"]]) {
                         self.selectedCouponList = dict;
                     }
                     
                 }
                 
              //   self.selectedCouponList = [self.arrayCouponList objectAtIndex:[self.pickerView selectedRowInComponent:0]];
              //   self.txt_Voucher.text = [[self.arrayCouponList valueForKey:@"CouponCodeDate"] objectAtIndex:[self.pickerView selectedRowInComponent:0]];
                 
                 self.arrayValidCoupen = [[NSMutableArray alloc]init];
                 self.arrayValidCoupen = [self.arrayCouponList mutableCopy];
                 
                 [self.arrayValidCoupen removeObject:self.selectedCouponList];
                 
                 
                 NSDateFormatter *formate = [[NSDateFormatter alloc]init];
                 [formate setDateFormat:@"dd MMM yyyy"];
                 NSDate *date  =[formate dateFromString: [self.selectedCouponList valueForKey:@"ExpiryDate"]];
                 
                 NSMutableArray *arr_coupen = [[NSMutableArray alloc]init];
                 arr_coupen = [self.arrayValidCoupen mutableCopy];
                 
                 for (int i=0; i<self.arrayValidCoupen.count; i++) {
                     NSDate *date2  =[formate dateFromString: [[self.arrayValidCoupen valueForKey:@"ExpiryDate"] objectAtIndex:i]];
                     if ([date compare:date2] == NSOrderedDescending) {
                         NSDictionary * dict = [self.arrayValidCoupen  objectAtIndex:i];
                         [arr_coupen removeObject:dict];
                     }
                 }
                 self.arrayValidCoupen = [[NSMutableArray alloc]init];
                 self.arrayValidCoupen = [arr_coupen mutableCopy];
                 
                 self.arraySpecialDayList = [[NSArray alloc]init];
                 [self getSpecialDayList];
                 _btn_Check_Box2.hidden = YES;
                 _lbl_MSG_CheckBox2.hidden =YES;
                 view_GSP_Status.hidden = YES;
                 [_btn_Check_Box2 setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
                 isOPTChecked = NO;
                 [self.txt_Destitation setEnabled:NO];
                 [self.txt_Year setEnabled:NO];
                 [self.txt_Month setEnabled:NO];
                 [self.txt_Date setEnabled:NO];
                 
                 [_btn_CheckBox setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
                 [self.txt_Destitation setEnabled:YES];
                 [self.txt_Year setEnabled:YES];
                 
                 _btn_Check_Box2.hidden = NO;
                 _lbl_MSG_CheckBox2.hidden = NO;
                 
                 self.txt_Destitation.text = @"";
                 self.lbl_Rooms.text = @"1";
                 roomCount = 1;
            //     self.txt_Year.text = @"";
                 self.txt_Month.text = @"";
                 self.txt_Date.text = @"";
                 
                 [self.txt_Destitation setValue:[ICSingletonManager colorFromHexString:@"#BD9854"]forKeyPath:@"_placeholderLabel.textColor"];
                 self.destitation_DD.image = [UIImage imageNamed:@"dropdownFill"];
                 _iml_Line1.backgroundColor = [ICSingletonManager colorFromHexString:@"#BD9854"];
                 _lbl_Title_Room.textColor = [ICSingletonManager colorFromHexString:@"#BD9854"];
                 _lbl_PreferredDates.textColor = [ICSingletonManager colorFromHexString:@"#BD9854"];
                 
                 [self.btn_Decreament setEnabled:YES];
                 [self.btn_Increament setEnabled:YES];
                 
             //    [self.btn_Date setEnabled:YES];
           //      [self.btn_Date setTitleColor:[ICSingletonManager colorFromHexString:@"#BD9854"] forState:UIControlStateNormal];
           //      [self.btn_Week setEnabled:YES];
         //        [self.btn_Week setTitleColor:[ICSingletonManager colorFromHexString:@"#BD9854"] forState:UIControlStateNormal];
           //      [self.btn_Month setEnabled:YES];
            //     [self.btn_Month setTitleColor:[ICSingletonManager colorFromHexString:@"#BD9854"] forState:UIControlStateNormal];
            //     [self.btn_SpclDay setEnabled:YES];
            //     [self.btn_SpclDay setTitleColor:[ICSingletonManager colorFromHexString:@"#BD9854"] forState:UIControlStateNormal];
                 
                 
                 [self.txt_Year setValue:[ICSingletonManager colorFromHexString:@"#BD9854"]forKeyPath:@"_placeholderLabel.textColor"];
                 self.dropDown1.image = [UIImage imageNamed:@"dropdownFill"];
                 _imgLine1.backgroundColor = [ICSingletonManager colorFromHexString:@"#BD9854"];
                 
                 _lbl_MSG_Box1.textColor = [UIColor blackColor];
                 [_btn_CheckBox setEnabled:YES];
                 [self ManageWishlistByCoupon:[[self.arrayCouponList valueForKey:@"CouponCode"] objectAtIndex:[self.pickerView selectedRowInComponent:0]]];
                 [self getWishlistByCoupon];
              
                 [self.txt_Date setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
                 self.dropDown3.image = [UIImage imageNamed:@"dropdownFill_gray"];
                 _imgLine3.backgroundColor = [UIColor lightGrayColor];
                 [self.txt_Month setEnabled:YES];
//                 [self.txt_Month setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
//                 self.dropDown2.image = [UIImage imageNamed:@"dropdownFill_gray"];
//                 self.imgLine2.backgroundColor = [UIColor lightGrayColor];
             }         }
         
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"failure");
         
         [[ICSingletonManager sharedManager]showAlertViewWithMsg:error.localizedDescription onController:self];
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         
     }];
    
}
//service to get preferred location
-(void)getWishlistByCoupon
{
    //http://dev.icanstay.businesstowork.com/api/Wishlist/GetAllWishlistDetails?userId=31458&couponCode=IC00027&familyStay=N&&endDate=2016-02-02&cityID=1
    
    //http://dev.icanstay.businesstowork.com/api/Wishlist/GetWishlistDetail
    //IsHotelMappedCity parameter
    
    // [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *strParams = [NSString stringWithFormat:@"CouponCode=%@",[[self.arrayCouponList valueForKey:@"CouponCode"] objectAtIndex:[self.pickerView selectedRowInComponent:0]]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8"
                     forHTTPHeaderField:@"Content-Type"];
    
    [manager GET:[NSString stringWithFormat:@"%@/api/Wishlist/GetWishlistDetail?%@",kServerUrl,strParams] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        self.arrayWishList = responseObject;
        
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
        
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:error.localizedDescription onController:self];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
    
}
//service to get preferred location
-(void)ManageWishlistByCoupon:(NSString *)str_CoupenCode
{
    //http://www.icanstay.com/ManageWishlist/GetCouponDetailapi?CouponCode=IC61107
    //IsHotelMappedCity parameter
    
    // [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *strParams = [NSString stringWithFormat:@"CouponCode=%@",str_CoupenCode];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8"
                     forHTTPHeaderField:@"Content-Type"];
    
    [manager GET:[NSString stringWithFormat:@"%@/ManageWishlist/GetCouponDetailapi?%@",kServerUrl,strParams] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        self.menageGSPData = responseObject;
        [webW_Reason loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
        [webW_Reason loadHTMLString:[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"GSPTable"]] baseURL:nil];
        
        NSAttributedString *attributedText = [self getHTMLAttributedString:[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"GSPTable"]]];
        CGSize size = CGSizeMake(webW_Reason.frame.size.width, CGFLOAT_MAX);
        CGRect paragraphRect =     [attributedText boundingRectWithSize:size
                                                                options:(NSStringDrawingUsesLineFragmentOrigin)
                                                                context:nil];
        
        webW_Reason.frame = CGRectMake(webW_Reason.frame.origin.x, webW_Reason.frame.origin.y, webW_Reason.frame.size.width, paragraphRect.size.height+30);
        
        _btn_Week.enabled = YES;
        _btn_Month.enabled = YES;
        _btn_Increament.enabled = YES;
        _btn_Decreament.enabled = YES;
        _btn_Check_Box2.enabled = YES;
        
        NSString *gspStatus = [responseObject valueForKey:@"GSPStatus"];
        btn_GSP_Status.hidden = YES;
        if (![gspStatus isEqual:[NSNull null]] && gspStatus.length !=0) {
            [btn_GSP_Status setTitle:[responseObject valueForKey:@"GSPStatus"] forState:UIControlStateNormal];
            btn_GSP_Status.titleEdgeInsets = UIEdgeInsetsMake(0, -btn_GSP_Status.imageView.frame.size.width, 0, btn_GSP_Status.imageView.frame.size.width);
            btn_GSP_Status.imageEdgeInsets = UIEdgeInsetsMake(0, btn_GSP_Status.titleLabel.frame.size.width, 0, -btn_GSP_Status.titleLabel.frame.size.width);
            btn_GSP_Status.hidden = NO;
        }
        
        if ([[responseObject valueForKey:@"GuaranteedStayOpt"] boolValue] == true) {
            [_btn_Check_Box2 setImage:[UIImage imageNamed:@"checkbox_selected"] forState:UIControlStateNormal];
            isOPTChecked = YES;
            GuaranteedStayApplicable = @"1";
            
            if (![gspStatus isEqual:[NSNull null]]) {
                _opt_Constraint.constant = 70;
            }
            
            int num = [[responseObject valueForKey:@"Fulfilledwishid"] intValue];
            NSString *fullfill = [NSString stringWithFormat:@"%d",num];
            if (fullfill.length !=0 && num !=0){
                _btn_Check_Box2.enabled = NO;
            }
            roomCount = 1;
            _lbl_Rooms.text = [NSString stringWithFormat:@"%d",roomCount];
            _btn_Increament.enabled=NO;
            _btn_Decreament.enabled=NO;
            _btn_Week.enabled=NO;
            _btn_Month.enabled=NO;
            view_GSP_Status.hidden = NO;
            webW_Reason.scrollView.scrollEnabled = NO;
        }
        else{
            [_btn_Check_Box2 setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
            isOPTChecked = NO;
            _opt_Constraint.constant = 31;
            view_GSP_Status.hidden = YES;
            GuaranteedStayApplicable = @"0";
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:error.localizedDescription onController:self];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
}
-(NSAttributedString *) getHTMLAttributedString:(NSString *) string{
    NSError *errorFees=nil;
    NSString *sourceFees = [NSString stringWithFormat:
                            @"<span style=\"font-family: 'JosefinSans-Light';font-size: 18px\">%@</span>",string];
    NSMutableAttributedString* strFees = [[NSMutableAttributedString alloc] initWithData:[sourceFees dataUsingEncoding:NSUTF8StringEncoding]
                                                                                 options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                           NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]}
                                                                      documentAttributes:nil error:&errorFees];
    return strFees;
    
}
- (IBAction)doClickonShowReasonofGSP:(id)sender {
    [viewGSPResponce setHidden:NO];
    [viewBlackTransparent setHidden:NO];
}
- (IBAction)doClickonClodeOFGSP:(id)sender {
    [viewGSPResponce setHidden:YES];
    [viewBlackTransparent setHidden:YES];
}

//service to get preferred location
-(void)getPreferredLocation:(NSString*)IsHotelMappedCity
{
    //http://dev.icanstay.businesstowork.com/api/SearchHotelApi/GetAllCity
    //IsHotelMappedCity parameter
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *strParams = [NSString stringWithFormat:@"IsHotelMappedCity=%@",IsHotelMappedCity];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8"
                     forHTTPHeaderField:@"Content-Type"];
    
    [manager GET:[NSString stringWithFormat:@"%@/api/SearchHotelApi/GetAllCity?%@",kServerUrl,strParams] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        
        if ([IsHotelMappedCity isEqualToString:@"true"]) {
            self.mArrayDestinationList = [[NSMutableArray alloc]init];
            NSArray *temp = responseObject;
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
            [dict setValue:@"Preferred Destination not available?" forKey:@"CITY_NAME"];
            for (int i=0; i<temp.count ; i++) {
                [self.mArrayDestinationList addObject:[temp objectAtIndex:i]];
            }
            //            [self.mArrayDestinationList addObject:dict];
            
        } else {
            //self.arrayPreferredDestinationList = responseObject;
        }
        //        NSString *status = [responseObject valueForKey:@"status"];
        //        NSString *msg = [responseObject valueForKey:@"errorMessage"];
        //        if ([status isEqualToString:@"SUCCESS"]) {
        //
        //        }
        
        NSLog(@"sucess");
        //   [[ICSingletonManager sharedManager]showAlertViewWithMsg:msg onController:self];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:error.localizedDescription onController:self];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}

//service to get coupons
-(void)getSpecialDayList
{
    //http://dev.icanstay.businesstowork.com/api/Wishlist/GetAllSpecialDate?userID=51538&couponCode=IC00114
    
    LoginManager *loginManage = [[LoginManager alloc]init];
    NSDictionary *dict = [loginManage isUserLoggedIn];
    NSNumber *num = [dict valueForKey:@"UserId"];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *strParams = [NSString stringWithFormat:@"userid=%@&couponCode=%@",num,[self.selectedCouponList objectForKey:@"CouponCode"]];
    
    // NSString *strParams = [NSString stringWithFormat:@"userid=%@",num];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8"
                     forHTTPHeaderField:@"Content-Type"];
    
    [manager GET:[NSString stringWithFormat:@"%@/api/Wishlist/GetAllSpecialDate?%@",kServerUrl,strParams] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        
        self.arraySpecialDayList = responseObject;
        
        NSDateFormatter *formate = [[NSDateFormatter alloc]init];
        [formate setDateFormat:@"dd MMM yyyy"];
        NSDate *date  =[formate dateFromString: [self.selectedCouponList valueForKey:@"ExpiryDate"]];
        
        NSMutableArray *arr_coupen = [[NSMutableArray alloc]init];
        arr_coupen = [self.arraySpecialDayList mutableCopy];
        
        for (int i=0; i<self.arraySpecialDayList.count; i++) {
            NSDate *date2  =[formate dateFromString: [[self.arraySpecialDayList valueForKey:@"EventDate"] objectAtIndex:i]];
            if ([date2 compare:date] == NSOrderedDescending) {
                NSDictionary * dict = [self.arraySpecialDayList  objectAtIndex:i];
                [arr_coupen removeObject:dict];
            }
        }
        
        self.arraySpecialDayList = [[NSMutableArray alloc]init];
        self.arraySpecialDayList = [arr_coupen mutableCopy];
        
        if (isSetSpecialday) {
            for (int i=0; i< self.arraySpecialDayList.count; i++)
            {
                NSString* dateString =[self convertDateFormat:[[self.arraySpecialDayList objectAtIndex:i]valueForKey:@"EventDate"] sourceFormate:@"dd MMM yyyy" targetFormate:@"dd MMM yyyy"];
                
                NSString *specialdateString = [self convertDateFormat:[self.dictionaryCouponList valueForKey:@"Prf_From_date"] sourceFormate:@"yyyy-MM-dd'T'HH:mm:ss" targetFormate:@"dd MMM yyyy"];
                NSLog(@"%@",specialdateString);
                if ([dateString isEqualToString:specialdateString]) {
                    self.txt_Year.text = [NSString stringWithFormat:@"%@ - %@ (%@) - %@",[[self.arraySpecialDayList objectAtIndex:i] valueForKey:@"EventName"],[[self.arraySpecialDayList objectAtIndex:i] valueForKey:@"Name"],[[self.arraySpecialDayList objectAtIndex:i] valueForKey:@"Relation_Name"],[[self.arraySpecialDayList objectAtIndex:i] valueForKey:@"EventDate"]];
                }
            }
        }
        
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        NSString *msg = [error description];
        
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:error.localizedDescription onController:self];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//service to get coupons
-(void)getTermconditionforGSP
{
    //http://www.icanstay.com/api/DynamicContentapi/GetContentDetailsios?contentID=26
    
    //    LoginManager *loginManage = [[LoginManager alloc]init];
    //    NSDictionary *dict = [loginManage isUserLoggedIn];
    //    NSNumber *num = [dict valueForKey:@"UserId"];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //NSString *strParams = [NSString stringWithFormat:@"userid=%@&couponCode=%@",num,[self.selectedCouponList objectForKey:@"CouponCode"]];
    
    // NSString *strParams = [NSString stringWithFormat:@"userid=%@",num];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8"
                     forHTTPHeaderField:@"Content-Type"];
    
    [manager GET:[NSString stringWithFormat:@"%@/api/DynamicContentapi/GetContentDetailsios?contentID=26",kServerUrl] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        NSString *termCond = [responseObject valueForKey:@"ContentDescription"];
        NSAttributedString *attrStr = [[NSAttributedString alloc] initWithData:[termCond  dataUsingEncoding:NSUTF8StringEncoding]
                                                                       options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                 NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}
                                                            documentAttributes:nil error:nil];
        NSLog(@"attrStr======%@",attrStr);
        
        [txtViewTerm setAttributedText:attrStr];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:error.localizedDescription onController:self];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
    
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
#pragma mark - DATE
- (IBAction)doClickonDate:(id)sender {
    [self.scrollview setContentSize:CGSizeMake(self.view.frame.size.width, self.btnAddToWishList.frame.origin.y+self.btnAddToWishList.frame.size.height+10)];
    
    [self.viewPicker setHidden:YES];
    [self.view endEditing:YES];
    self.txt_Date.hidden = NO;
    _imgLine3.hidden = NO;
    _dropDown3.hidden = NO;
    
    [self.txt_Date setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    self.dropDown3.image = [UIImage imageNamed:@"dropdownFill_gray"];
    _imgLine3.backgroundColor = [UIColor lightGrayColor];
    
    self.txt_Month.hidden = NO;
    _imgLine2.hidden = NO;
    _dropDown2.hidden = NO;
    
    [self.txt_Month setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    self.dropDown2.image = [UIImage imageNamed:@"dropdownFill_gray"];
    _imgLine2.backgroundColor = [UIColor lightGrayColor];
    
    
    [self.btn_Date setImage:[UIImage imageNamed:@"radio_selected"] forState:UIControlStateNormal];
    [self.btn_Week setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
    [self.btn_Month setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
    [self.btn_SpclDay setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
    
    prefered_Type = @"3";
    
    self.txt_Date.placeholder = @"DATE";
    self.txt_Year.placeholder = @"YEAR";
    
    self.txt_Date.text = @"";
    self.txt_Month.text = @"";
    self.txt_Year.text = @"";
    
    self.txt_Date.enabled = NO;
    self.txt_Month.enabled = YES;
    
    //    [UIView beginAnimations:nil context:NULL];
    //    [UIView setAnimationDuration:0.1];
    //    [UIView setAnimationCurve:0.2];
    //    [UIView setAnimationBeginsFromCurrentState:YES];
    //    self.view_CheckBox.frame = CGRectMake(self.view_CheckBox.frame.origin.x, _imgLine3.frame.origin.y+_imgLine3.frame.size.height+8, self.view_CheckBox.frame.size.width, self.view_CheckBox.frame.size.height);
    //    self.btnAddToWishList.frame = CGRectMake(self.btnAddToWishList.frame.origin.x, _view_CheckBox.frame.origin.y+_view_CheckBox.frame.size.height+18, self.btnAddToWishList.frame.size.width, self.btnAddToWishList.frame.size.height);
    //    self.scrollview.contentSize = CGSizeMake(self.view.frame.size.width, self.btnAddToWishList.frame.origin.y+self.btnAddToWishList.frame.size.height+10);
    //    [UIView commitAnimations];
    
    [self setCurrentYear];
    
}
#pragma mark - WEEK
- (IBAction)doClickonWeek:(id)sender {
    [self.scrollview setContentSize:CGSizeMake(self.view.frame.size.width, self.btnAddToWishList.frame.origin.y+self.btnAddToWishList.frame.size.height+10)];
    
    [self.viewPicker setHidden:YES];
    [self.view endEditing:YES];
    self.txt_Date.hidden = NO;
    _imgLine3.hidden = NO;
    _dropDown3.hidden = NO;
    self.txt_Month.hidden = NO;
    _imgLine2.hidden = NO;
    _dropDown2.hidden = NO;
    
    [self.txt_Date setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    self.dropDown3.image = [UIImage imageNamed:@"dropdownFill_gray"];
    _imgLine3.backgroundColor = [UIColor lightGrayColor];
    
    [self.txt_Month setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    self.dropDown2.image = [UIImage imageNamed:@"dropdownFill_gray"];
    _imgLine2.backgroundColor = [UIColor lightGrayColor];
    
    [self.btn_Date setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
    [self.btn_Week setImage:[UIImage imageNamed:@"radio_selected"] forState:UIControlStateNormal];
    [self.btn_Month setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
    [self.btn_SpclDay setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
    
    prefered_Type = @"2";
    
    self.txt_Date.placeholder = @"WEEK";
    self.txt_Year.placeholder = @"YEAR";
    
    self.txt_Date.text = @"";
    self.txt_Month.text = @"";
    self.txt_Year.text = @"";
    self.txt_Date.enabled = NO;
    self.txt_Month.enabled = YES;
    
    //    [UIView beginAnimations:nil context:NULL];
    //    [UIView setAnimationDuration:0.1];
    //    [UIView setAnimationCurve:0.2];
    //    [UIView setAnimationBeginsFromCurrentState:YES];
    //    self.view_CheckBox.frame = CGRectMake(self.view_CheckBox.frame.origin.x, _imgLine3.frame.origin.y+_imgLine3.frame.size.height+8, self.view_CheckBox.frame.size.width, self.view_CheckBox.frame.size.height);
    //    self.btnAddToWishList.frame = CGRectMake(self.btnAddToWishList.frame.origin.x, _view_CheckBox.frame.origin.y+_view_CheckBox.frame.size.height+18, self.btnAddToWishList.frame.size.width, self.btnAddToWishList.frame.size.height);
    //    self.scrollview.contentSize = CGSizeMake(self.view.frame.size.width, self.btnAddToWishList.frame.origin.y+self.btnAddToWishList.frame.size.height+10);
    //    [UIView commitAnimations];
    
    [self setCurrentYear];
    
}
#pragma mark - MONTH
- (IBAction)doClickonMonth:(id)sender {
    [self.scrollview setContentSize:CGSizeMake(self.view.frame.size.width, self.btnAddToWishList.frame.origin.y+self.btnAddToWishList.frame.size.height+10)];
    
    [self.viewPicker setHidden:YES];
    [self.view endEditing:YES];
    self.txt_Date.hidden = NO;
    _imgLine3.hidden = NO;
    _dropDown3.hidden = NO;
    self.txt_Month.hidden = NO;
    _imgLine2.hidden = NO;
    _dropDown2.hidden = NO;
    
    [self.btn_Date setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
    [self.btn_Week setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
    [self.btn_Month setImage:[UIImage imageNamed:@"radio_selected"] forState:UIControlStateNormal];
    [self.btn_SpclDay setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
    
    prefered_Type = @"1";
    
    self.txt_Date.hidden = YES;
    _imgLine3.hidden = YES;
    _dropDown3.hidden = YES;
    self.txt_Year.placeholder = @"YEAR";
    
    self.txt_Date.text = @"";
    self.txt_Month.text = @"";
    self.txt_Year.text = @"";
    
    self.txt_Date.enabled = NO;
    self.txt_Month.enabled = YES;
    
    [self.txt_Date setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    self.dropDown3.image = [UIImage imageNamed:@"dropdownFill_gray"];
    _imgLine3.backgroundColor = [UIColor lightGrayColor];
    
    [self.txt_Month setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    self.dropDown2.image = [UIImage imageNamed:@"dropdownFill_gray"];
    _imgLine2.backgroundColor = [UIColor lightGrayColor];
    
    //    [UIView beginAnimations:nil context:NULL];
    //    [UIView setAnimationDuration:0.1];
    //    [UIView setAnimationCurve:0.2];
    //    [UIView setAnimationBeginsFromCurrentState:YES];
    //    self.view_CheckBox.frame = CGRectMake(self.view_CheckBox.frame.origin.x, _imgLine2.frame.origin.y+_imgLine2.frame.size.height+8, self.view_CheckBox.frame.size.width, self.view_CheckBox.frame.size.height);
    //    self.btnAddToWishList.frame = CGRectMake(self.btnAddToWishList.frame.origin.x, _view_CheckBox.frame.origin.y+_view_CheckBox.frame.size.height+18, self.btnAddToWishList.frame.size.width, self.btnAddToWishList.frame.size.height);
    //    self.scrollview.contentSize = CGSizeMake(self.view.frame.size.width, self.btnAddToWishList.frame.origin.y+self.btnAddToWishList.frame.size.height+10);
    //    [UIView commitAnimations];
    [self setCurrentYear];
    
}
#pragma mark - SPECIAL DAY
- (IBAction)doClickonSpclDay:(id)sender {
    [self.scrollview setContentSize:CGSizeMake(self.view.frame.size.width, self.btnAddToWishList.frame.origin.y+self.btnAddToWishList.frame.size.height+10)];
    
    [self.viewPicker setHidden:YES];
    [self.view endEditing:YES];
    
    [self.btn_Date setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
    [self.btn_Week setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
    [self.btn_Month setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
    [self.btn_SpclDay setImage:[UIImage imageNamed:@"radio_selected"] forState:UIControlStateNormal];
    
    prefered_Type = @"4";
    
    self.txt_Date.hidden = YES;
    _imgLine3.hidden = YES;
    _dropDown3.hidden = YES;
    self.txt_Month.hidden = YES;
    _imgLine2.hidden = YES;
    _dropDown2.hidden = YES;
    self.txt_Year.placeholder = @"SPECIAL DAY(s)";
    
    self.txt_Date.text = @"";
    self.txt_Month.text = @"";
    self.txt_Year.text = @"";
    
    self.txt_Date.enabled = NO;
    self.txt_Month.enabled = NO;
    
    if (self.arraySpecialDayList.count !=0) {
        [self getSpecialDayList];
    }
    
    
    //    [UIView beginAnimations:nil context:NULL];
    //    [UIView setAnimationDuration:0.1];
    //    [UIView setAnimationCurve:0.2];
    //    [UIView setAnimationBeginsFromCurrentState:YES];
    //    self.view_CheckBox.frame = CGRectMake(self.view_CheckBox.frame.origin.x, _imgLine1.frame.origin.y+_imgLine1.frame.size.height+8, self.view_CheckBox.frame.size.width, self.view_CheckBox.frame.size.height);
    //    self.btnAddToWishList.frame = CGRectMake(self.btnAddToWishList.frame.origin.x, _view_CheckBox.frame.origin.y+_view_CheckBox.frame.size.height+18, self.btnAddToWishList.frame.size.width, self.btnAddToWishList.frame.size.height);
    //    self.scrollview.contentSize = CGSizeMake(self.view.frame.size.width, self.btnAddToWishList.frame.origin.y+self.btnAddToWishList.frame.size.height+50);
    //    [UIView commitAnimations];
    
    [self setCurrentYear];
}
#pragma mark -Decreas Room Count
- (IBAction)doClickonDecreasRoom:(id)sender {
    if (roomCount != 1 ) {
        roomCount--;
        _lbl_Rooms.text = [NSString stringWithFormat:@"%d",roomCount];
    }
}
#pragma mark -Increas Room Count
- (IBAction)doClickonIncreaseRoom:(id)sender {
    if (roomCount != 4 ) {
        roomCount++;
        _lbl_Rooms.text = [NSString stringWithFormat:@"%d",roomCount];
    }
    
}

#pragma mark -Back to View Actions Methods
- (IBAction)doClickonBack:(id)sender {
    
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
    if (globals.isFromEditMakeWishlist == true && globals.isFromMenuForMakeWishe == false) {
        globals.isFromMenuForMakeWishe = false;
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
    if (globals.isFromMenuForMakeWishe)
    {
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    }
    else if ([globals.strWhichScreen isEqualToString:@"MakeWishList"]){
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
         [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    }
    //    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -Notification Actions Methods
- (IBAction)doClickonNotification:(id)sender {
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


#pragma mark - TextField Delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == self.txt_Voucher) {
        selectPicker = kCoupon;
        [self.viewPicker setHidden:NO];
        [self.pickerView reloadAllComponents];
        return NO;
    }
    else if (textField == self.txt_Destitation)
    {
        selectPicker = kDestination;
        [self.pickerView reloadAllComponents];
        [self.viewPicker setHidden:NO];
        return NO;
    }
    else if (textField == self.txt_Year)
    {
        [self.scrollview setContentSize:CGSizeMake(self.view.frame.size.width, self.btnAddToWishList.frame.origin.y+self.btnAddToWishList.frame.size.height+150)];
        [self.scrollview setContentOffset:CGPointMake(0, 100)];
        if ([self.txt_Year.placeholder isEqualToString:@"YEAR"]) {
            selectPicker = kYear;
            mArrayYears = [[NSMutableArray alloc] init];
            int start = [[self stringFromNSDate:[NSDate date] dateFormate:@"yyyy"] intValue];
            int end = [[self convertDateFormat:[self.selectedCouponList objectForKey:@"ExpiryDate"] sourceFormate:@"dd MMM yyyy" targetFormate:@"yyyy"] intValue];
            
            for (int i=start; i<=end; i++)
            {
                [mArrayYears addObject:[NSString stringWithFormat:@"%d",i]];
            }
        }
        else
        {
            selectPicker = kSpecialDay;
        }
        [self.pickerView reloadAllComponents];
        [self.viewPicker setHidden:NO];
        return NO;
    }
    else if (textField == self.txt_Month)
    {
        [self.scrollview setContentSize:CGSizeMake(self.view.frame.size.width, self.btnAddToWishList.frame.origin.y+self.btnAddToWishList.frame.size.height+150)];
        [self.scrollview setContentOffset:CGPointMake(0, 150)];
        mArrayMonths = [[NSMutableArray alloc] init];
        
        

        NSDate *actualdate;
       NSDate *currentdate = [NSDate date];
       NSDate *startDate = [self nsdateFromString:[self.selectedCouponList objectForKey:@"CouponValidFromDate"] dateFormate:@"dd MMM yyyy"];
        
       
        NSTimeInterval distanceBetweenDates = [startDate timeIntervalSinceDate:currentdate];
        double secondsInMinute = 60;
        NSInteger secondsBetweenDates = distanceBetweenDates / secondsInMinute;
        
        if (secondsBetweenDates == 0){
            
            actualdate = currentdate;
            
        }else if (secondsBetweenDates < 0){
            actualdate = currentdate;
            
        }else if (secondsBetweenDates > 0){
            actualdate = startDate;
        }
        
        
        NSCalendar *gregorian = [NSCalendar currentCalendar];
        NSDateComponents *dateComponents = [gregorian components:(NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear) fromDate:actualdate];
        NSInteger startmonth = [dateComponents month];
        startmonth--;
        
        NSInteger startyear = [dateComponents year];
        
        if ([self.txt_Year.text isEqualToString:[NSString stringWithFormat:@"%ld",(long)startyear]])
        {
            NSDate *date = [self nsdateFromString:[self.selectedCouponList objectForKey:@"ExpiryDate"] dateFormate:@"dd MMM yyyy"];
            NSDateComponents *dateComponents = [gregorian components:(NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear) fromDate:date];
            NSInteger endmonth = [dateComponents month];
            NSInteger endyear = [dateComponents year];
            if (startyear != endyear) {
                for (NSInteger i=startmonth; i<12; i++)
                {
                    [mArrayMonths addObject: [self.arrayMonthList objectAtIndex:i]];
                }
            }
            else{
                for (NSInteger i=startmonth; i<endmonth; i++)
                {
                    [mArrayMonths addObject: [self.arrayMonthList objectAtIndex:i]];
                }
            }
            
        }
        else if ([self.txt_Year.text isEqualToString:[self convertDateFormat:[self.selectedCouponList objectForKey:@"ExpiryDate"] sourceFormate:@"dd MMM yyyy" targetFormate:@"yyyy"]])
        {
            NSDate *date = [self nsdateFromString:[self.selectedCouponList objectForKey:@"ExpiryDate"] dateFormate:@"dd MMM yyyy"];
            NSDateComponents *dateComponents = [gregorian components:(NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear) fromDate:date];
            NSInteger endmonth = [dateComponents month];
            
            for (NSInteger i=0; i<endmonth; i++)
            {
                [mArrayMonths addObject: [self.arrayMonthList objectAtIndex:i]];
            }
        }
        else
        {
            for (NSInteger i=0; i<=12; i++)
            {
                [mArrayMonths addObject: [self.arrayMonthList objectAtIndex:i]];
            }
        }
        selectPicker = kMonths;
        [self.pickerView reloadAllComponents];
        [self.viewPicker setHidden:NO];
        
        return NO;
    }
    
    else if (textField == self.txt_Date)
    {
        [self.scrollview setContentSize:CGSizeMake(self.view.frame.size.width, self.btnAddToWishList.frame.origin.y+self.btnAddToWishList.frame.size.height+150)];
        [self.scrollview setContentOffset:CGPointMake(0, 200)];
        
        
        NSDate *actualdate;
        NSDate *currentdate = [NSDate date];
        NSDate *startDate1 = [self nsdateFromString:[self.selectedCouponList objectForKey:@"CouponValidFromDate"] dateFormate:@"dd MMM yyyy"];
        
        
        NSTimeInterval distanceBetweenDates = [startDate1 timeIntervalSinceDate:currentdate];
        double secondsInMinute = 60;
        NSInteger secondsBetweenDates = distanceBetweenDates / secondsInMinute;
        
        if (secondsBetweenDates == 0){
            
            actualdate = currentdate;
            
        }else if (secondsBetweenDates < 0){
            actualdate = currentdate;
            
        }else if (secondsBetweenDates > 0){
            actualdate = startDate1;
        }
        
        
        currentdate = actualdate;
        NSCalendar *gregorian = [NSCalendar currentCalendar];
        
        NSDateComponents *dateComponents = [gregorian components:(NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear) fromDate:currentdate];
        
        NSRange days = [gregorian rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:currentdate];
        NSInteger daysInGivenMonth= days.length;
        
        NSInteger startDate = [dateComponents day];
        NSInteger startmonth = [dateComponents month];
        NSInteger startyear = [dateComponents year];
        if ([self.txt_Date.placeholder isEqualToString:@"DATE"])
        {
            mArraydate = [[NSMutableArray alloc] init];
            
            if ([self.txt_Year.text isEqualToString:[NSString stringWithFormat:@"%ld",(long)startyear]])
            {
                if ([self.txt_Month.text isEqualToString:[self.arrayMonthList objectAtIndex:startmonth-1]])
                {
                    for (NSInteger i=startDate; i<=daysInGivenMonth; i++)
                    {
                        [mArraydate addObject:[NSString stringWithFormat:@"%ld",(long)i]];
                    }
                }
                else
                {
                    for (int i = 0; i< self.arrayMonthList.count; i++)
                    {
                        if ([[self.arrayMonthList objectAtIndex:i]isEqualToString:self.txt_Month.text])
                        {
                            NSDate *expirydate = [self nsdateFromString:[self.selectedCouponList objectForKey:@"ExpiryDate"] dateFormate:@"dd MMM yyyy"];
                            NSDateComponents *dateComponents = [gregorian components:(NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear) fromDate:expirydate];
                            
                            NSInteger endDate = [dateComponents day];
                            NSInteger endmonth = [dateComponents month];
                            
                            NSDateComponents *components1 = [[NSDateComponents alloc] init];
                            // Set your year and month here
                            [components1 setYear:startyear];
                            [components1 setMonth:i+1];
                            NSDate *date1 = [gregorian dateFromComponents:components1];
                            
                            NSRange days1 = [gregorian rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date1];
                            
                            NSInteger daysInGivenMonth1= days1.length;
                            
                            if (endmonth == i+1) {
                                for (NSInteger i=1; i<=endDate; i++)
                                {
                                    [mArraydate addObject:[NSString stringWithFormat:@"%ld",(long)i]];
                                }
                            }
                            else{
                                for (NSInteger i=1; i<=daysInGivenMonth1; i++)
                                {
                                    [mArraydate addObject:[NSString stringWithFormat:@"%ld",(long)i]];
                                }
                            }
                            
                        }
                    }
                }
            }
            else if([self.txt_Year.text isEqualToString:[self convertDateFormat:[self.selectedCouponList objectForKey:@"ExpiryDate"] sourceFormate:@"dd MMM yyyy" targetFormate:@"yyyy"]])
            {
                NSDate *expirydate = [self nsdateFromString:[self.selectedCouponList objectForKey:@"ExpiryDate"] dateFormate:@"dd MMM yyyy"];
                NSDateComponents *dateComponents = [gregorian components:(NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear) fromDate:expirydate];
                
                NSInteger endDate = [dateComponents day];
                NSInteger endmonth = [dateComponents month];
                
                if ([self.txt_Month.text isEqualToString:[self.arrayMonthList objectAtIndex:endmonth-1]])
                {
                    for (NSInteger i=1; i<=endDate; i++)
                    {
                        [mArraydate addObject:[NSString stringWithFormat:@"%ld",(long)i]];
                    }
                }
                else
                {
                    for (int i = 0; i< self.arrayMonthList.count; i++) {
                        if ([[self.arrayMonthList objectAtIndex:i]isEqualToString:self.txt_Month.text])
                        {
                            
                            NSDateComponents *components1 = [[NSDateComponents alloc] init];
                            // Set your year and month here
                            [components1 setYear:startyear];
                            [components1 setMonth:i+1];
                            NSDate *date1 = [gregorian dateFromComponents:components1];
                            
                            NSRange days1 = [gregorian rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date1];
                            
                            NSInteger daysInGivenMonth1= days1.length;
                            if (endmonth == i+1) {
                                for (NSInteger i=1; i<=endDate; i++)
                                {
                                    [mArraydate addObject:[NSString stringWithFormat:@"%ld",(long)i]];
                                }
                            }
                            else{
                                for (NSInteger i=1; i<=daysInGivenMonth1; i++)
                                {
                                    [mArraydate addObject:[NSString stringWithFormat:@"%ld",(long)i]];
                                }
                            }
                        }
                    }
                }
            }
            else
            {
                for (int i = 0; i< self.arrayMonthList.count; i++)
                {
                    if ([[self.arrayMonthList objectAtIndex:i]isEqualToString:self.txt_Month.text])
                    {
                        
                        NSDate *expirydate = [self nsdateFromString:[self.selectedCouponList objectForKey:@"ExpiryDate"] dateFormate:@"dd MMM yyyy"];
                        NSDateComponents *dateComponents = [gregorian components:(NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear) fromDate:expirydate];
                        
                        NSInteger endDate = [dateComponents day];
                        NSInteger endmonth = [dateComponents month];
                        
                        NSDateComponents *components1 = [[NSDateComponents alloc] init];
                        // Set your year and month here
                        [components1 setYear:[self.txt_Year.text integerValue]];
                        [components1 setMonth:i+1];
                        NSDate *date1 = [gregorian dateFromComponents:components1];
                        
                        NSRange days1 = [gregorian rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date1];
                        
                        NSInteger daysInGivenMonth1= days1.length;
                        if (endmonth == i+1) {
                            for (NSInteger i=1; i<=endDate; i++)
                            {
                                [mArraydate addObject:[NSString stringWithFormat:@"%ld",(long)i]];
                            }
                        }
                        else{
                            for (NSInteger i=1; i<=daysInGivenMonth1; i++)
                            {
                                [mArraydate addObject:[NSString stringWithFormat:@"%ld",(long)i]];
                            }
                        }
                    }
                }
            }
        }
        else if ([self.txt_Date.placeholder isEqualToString:@"WEEK"])
        {
            mArrayWeek = [[NSMutableArray alloc] init];
            mArrayWeekNo = [[NSMutableArray alloc] init];
            if ([self.txt_Year.text isEqualToString:[NSString stringWithFormat:@"%ld",(long)startyear]])
            {
                for (int j = 0; j< self.arrayMonthList.count; j++)
                {
                    if ([[self.arrayMonthList objectAtIndex:j]isEqualToString:self.txt_Month.text])
                    {
                        // Expire year and month here
                        NSDate *expirydate = [self nsdateFromString:[self.selectedCouponList objectForKey:@"ExpiryDate"] dateFormate:@"dd MMM yyyy"];
                        
                        NSDateComponents *dateComponents = [gregorian components:(NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear) fromDate:expirydate];
                        
                        NSInteger endDate = [dateComponents day];
                        NSInteger endmonth = [dateComponents month];
                        
                        NSDateComponents *components1 = [[NSDateComponents alloc] init];
                        NSCalendar *gregorian = [NSCalendar currentCalendar];
                        
                        // Set your year and month here
                        [components1 setYear:[self.txt_Year.text integerValue]];
                        [components1 setMonth:j+1];
                        NSDate *date1 = [gregorian dateFromComponents:components1];
                        
                        NSRange days1 = [gregorian rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date1];
                        
                        NSInteger daysInGivenMonth1= days1.length;
                        NSInteger tempDayCount = daysInGivenMonth1;
                        int x = 1;
                        NSMutableArray *temp = [[NSMutableArray alloc]init];
                        for (NSInteger i=1; i<=daysInGivenMonth1; i++)
                        {
                            if (tempDayCount < 7)
                            {
                                [mArrayWeek addObject:[NSString stringWithFormat:@"Week %d [%ld - %ld %@ %ld]",x,(long)i,(long)daysInGivenMonth1,[self.arrayMonthList objectAtIndex:j],[self.txt_Year.text integerValue]]];
                                [mArrayWeekNo addObject:[NSString stringWithFormat:@"%d",x]];
                            } else {
                                [mArrayWeek addObject:[NSString stringWithFormat:@"Week %d [%ld - %ld %@ %ld]",x,(long)i,(long)i+6,[self.arrayMonthList objectAtIndex:j],[self.txt_Year.text integerValue]]];
                                [mArrayWeekNo addObject:[NSString stringWithFormat:@"%d",x]];
                                tempDayCount = tempDayCount - 7;
                            }
                            [temp addObject:[NSString stringWithFormat:@"%ld",i+6]];
                            x++;
                            i = i + 6;
                        }
                        
                        if ([self.txt_Month.text isEqualToString:[self.arrayMonthList objectAtIndex:startmonth-1]])
                        {
                            for (int k = 0; k < mArrayWeek.count; k++) {
                                if (startDate < [[temp objectAtIndex:k] integerValue]) {
                                    [mArrayWeek removeObjectAtIndex:0];
                                    [mArrayWeekNo removeObjectAtIndex:0];
                                    [mArrayWeek insertObject:[NSString stringWithFormat:@"Week %d [%ld - %ld %@ %ld]",k+1,(long)startDate,(long)[[temp objectAtIndex:k] integerValue],[self.arrayMonthList objectAtIndex:j],[self.txt_Year.text integerValue]] atIndex:0];
                                    [mArrayWeekNo insertObject:[NSString stringWithFormat:@"%d",k+1]atIndex:0];
                                    break;
                                }
                                else
                                {
                                    [mArrayWeek removeObjectAtIndex:0];
                                    [mArrayWeekNo removeObjectAtIndex:0];
                                }
                            }
                        }
                        else if (endmonth == j+1){
                            for (NSInteger k = mArrayWeek.count-1; k >= 0; k--) {
                                int date = [[temp objectAtIndex:k] integerValue];
                                if (endDate < date) {
                                    if (mArrayWeek.count == 1) {
                                        [mArrayWeek removeObjectAtIndex:k];
                                        [mArrayWeekNo removeObjectAtIndex:k];
                                        [mArrayWeek insertObject:[NSString stringWithFormat:@"Week %ld [%d - %ld %@ %ld]",k+1,1,(long)endDate,[self.arrayMonthList objectAtIndex:j],[self.txt_Year.text integerValue]] atIndex:0];
                                        [mArrayWeekNo insertObject:[NSString stringWithFormat:@"%ld",k+1]atIndex:k];
                                        break;
                                        
                                    } else {
                                        [mArrayWeek removeObjectAtIndex:k];
                                        [mArrayWeekNo removeObjectAtIndex:k];
                                    }
                                }
                                else
                                {
                                    if (endDate != startDate) {
                                        [mArrayWeek addObject:[NSString stringWithFormat:@"Week %ld [%ld - %ld %@ %ld]",(long)k+2,(long)[[temp objectAtIndex:k] integerValue]+1,(long)endDate,[self.arrayMonthList objectAtIndex:j],[self.txt_Year.text integerValue]]];
                                        [mArrayWeekNo addObject:[NSString stringWithFormat:@"%ld",(long)k+2]];
                                    }
                                    else{
                                        [mArrayWeek removeObjectAtIndex:k];
                                        [mArrayWeekNo removeObjectAtIndex:k];
                                        [mArrayWeek insertObject:[NSString stringWithFormat:@"Week %ld [%ld - %ld %@ %ld]",(long)k+1,(long)[[temp objectAtIndex:k] integerValue],(long)startDate,[self.arrayMonthList objectAtIndex:j],[self.txt_Year.text integerValue]] atIndex:k];
                                        [mArrayWeekNo insertObject:[NSString stringWithFormat:@"%ld",(long)k+1]atIndex:k];
                                    }
                                    
                                    
                                    break;
                                    
                                }
                            }
                        }
                    }
                }
            }
            
            else if ([self.txt_Year.text isEqualToString:[self convertDateFormat:[self.selectedCouponList objectForKey:@"ExpiryDate"] sourceFormate:@"dd MMM yyyy" targetFormate:@"yyyy"]])
            {
                NSDate *expirydate = [self nsdateFromString:[self.selectedCouponList objectForKey:@"ExpiryDate"] dateFormate:@"dd MMM yyyy"];
                
                NSDateComponents *dateComponents = [gregorian components:(NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear) fromDate:expirydate];
                
                NSInteger endDate = [dateComponents day];
                NSInteger endmonth = [dateComponents month];
                for (int j = 0; j< self.arrayMonthList.count; j++)
                {
                    if ([[self.arrayMonthList objectAtIndex:j]isEqualToString:self.txt_Month.text])
                    {
                        NSDateComponents *components1 = [[NSDateComponents alloc] init];
                        NSCalendar *gregorian = [NSCalendar currentCalendar];
                        
                        // Set your year and month here
                        [components1 setYear:[self.txt_Year.text integerValue]];
                        [components1 setMonth:j+1];
                        NSDate *date1 = [gregorian dateFromComponents:components1];
                        
                        NSRange days1 = [gregorian rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date1];
                        
                        NSInteger daysInGivenMonth1= days1.length;
                        NSInteger tempDayCount = daysInGivenMonth1;
                        int x = 1;
                        NSMutableArray *temp = [[NSMutableArray alloc]init];
                        for (NSInteger i=1; i<=daysInGivenMonth1; i++)
                        {
                            if (tempDayCount < 7) {
                                [mArrayWeek addObject:[NSString stringWithFormat:@"Week %d [%ld - %ld %@ %ld]",x,(long)i,(long)daysInGivenMonth1,[self.arrayMonthList objectAtIndex:j],[self.txt_Year.text integerValue]]];
                                [mArrayWeekNo addObject:[NSString stringWithFormat:@"%d",x]];
                            } else {
                                [mArrayWeek addObject:[NSString stringWithFormat:@"Week %d [%ld - %ld %@ %ld]",x,(long)i,(long)i+6,[self.arrayMonthList objectAtIndex:j],[self.txt_Year.text integerValue]]];
                                [mArrayWeekNo addObject:[NSString stringWithFormat:@"%d",x]];
                                tempDayCount = tempDayCount - 7;
                            }
                            [temp addObject:[NSString stringWithFormat:@"%ld",i+6]];
                            x++;
                            i = i + 6;
                        }
                        if (endmonth == j+1){
                            for (NSInteger k = mArrayWeek.count-1; k >= 0; k--) {
                                int date = [[temp objectAtIndex:k] integerValue];
                                if (endDate < date) {
                                    if (mArrayWeek.count == 1) {
                                        [mArrayWeek removeObjectAtIndex:k];
                                        [mArrayWeekNo removeObjectAtIndex:k];
                                        [mArrayWeek insertObject:[NSString stringWithFormat:@"Week %d [%d - %ld %@ %ld]",k+1,1,(long)endDate,[self.arrayMonthList objectAtIndex:j],[self.txt_Year.text integerValue]] atIndex:0];
                                        [mArrayWeekNo insertObject:[NSString stringWithFormat:@"%d",k+1]atIndex:k];
                                        break;
                                        
                                    } else {
                                        [mArrayWeek removeObjectAtIndex:k];
                                        [mArrayWeekNo removeObjectAtIndex:k];
                                    }
                                }
                                else
                                {
                                    if (endDate != startDate) {
                                        [mArrayWeek addObject:[NSString stringWithFormat:@"Week %ld [%ld - %ld %@ %d]",(long)k+2,(long)[[temp objectAtIndex:k] integerValue]+1,(long)endDate,[self.arrayMonthList objectAtIndex:j],[self.txt_Year.text integerValue]]];
                                        [mArrayWeekNo addObject:[NSString stringWithFormat:@"%ld",(long)k+2]];
                                    }
                                    else{
                                        [mArrayWeek removeObjectAtIndex:k];
                                        [mArrayWeekNo removeObjectAtIndex:k];
                                        [mArrayWeek insertObject:[NSString stringWithFormat:@"Week %ld [%ld - %ld %@ %d]",(long)k+1,(long)[[temp objectAtIndex:k] integerValue],(long)startDate,[self.arrayMonthList objectAtIndex:j],[self.txt_Year.text integerValue]] atIndex:k];
                                        [mArrayWeekNo insertObject:[NSString stringWithFormat:@"%ld",(long)k+1]atIndex:k];
                                    }
                                    
                                    
                                    break;
                                    
                                }
                            }
                        }
                        
                       else if ([self.txt_Month.text isEqualToString:[self.arrayMonthList objectAtIndex:endmonth-1]])
                        {
                            for (NSInteger k = mArrayWeek.count-1; k >= 0; k--) {
                                if (endDate < [[temp objectAtIndex:k] integerValue]) {
                                    if (mArrayWeek.count == 1) {
                                        [mArrayWeek removeObjectAtIndex:k];
                                        [mArrayWeekNo removeObjectAtIndex:k];
                                        [mArrayWeek insertObject:[NSString stringWithFormat:@"Week %ld [%d - %ld %@ %ld]",k+1,1,(long)endDate,[self.arrayMonthList objectAtIndex:j],[self.txt_Year.text integerValue]] atIndex:0];
                                        [mArrayWeekNo insertObject:[NSString stringWithFormat:@"%ld",k+1]atIndex:k];
                                        break;
                                        
                                    } else {
                                        [mArrayWeek removeObjectAtIndex:k];
                                        [mArrayWeekNo removeObjectAtIndex:k];
                                    }
                                }
                                else
                                {
                                    [mArrayWeek removeObjectAtIndex:k];
                                    [mArrayWeekNo removeObjectAtIndex:k];
                                    [mArrayWeek insertObject:[NSString stringWithFormat:@"Week %ld [%ld - %ld %@ %ld]",(long)k,(long)startDate,(long)[[temp objectAtIndex:k] integerValue],[self.arrayMonthList objectAtIndex:j],[self.txt_Year.text integerValue]] atIndex:0];
                                    [mArrayWeekNo insertObject:[NSString stringWithFormat:@"%ld",(long)k]atIndex:0];
                                    break;
                                    
                                }
                            }
                        }
                        
                    }
                }
            }
        }
        selectPicker = kDate;
        [self.pickerView reloadAllComponents];
        [self.viewPicker setHidden:NO];
        return NO;
        
    }
    return NO;
}

#pragma mark- Picker Actions

- (IBAction)cancelPicker:(id)sender
{
    [self.scrollview setContentSize:CGSizeMake(self.view.frame.size.width, self.btnAddToWishList.frame.origin.y+self.btnAddToWishList.frame.size.height+10)];
    
    [self.viewPicker setHidden:YES];
    [self.view endEditing:YES];
}

- (IBAction)donePicker:(id)sender
{
    if (selectPicker == kCoupon) {
        if (self.arrayCouponList.count !=0) {
            
            _opt_Constraint.constant = 31;
            
            self.selectedCouponList = [self.arrayCouponList objectAtIndex:[self.pickerView selectedRowInComponent:0]];
            self.txt_Voucher.text = [[self.arrayCouponList valueForKey:@"CouponCodeDate"] objectAtIndex:[self.pickerView selectedRowInComponent:0]];
            
            self.arrayValidCoupen = [[NSMutableArray alloc]init];
            self.arrayValidCoupen = [self.arrayCouponList mutableCopy];
            
            [self.arrayValidCoupen removeObject:self.selectedCouponList];
            
            
            NSDateFormatter *formate = [[NSDateFormatter alloc]init];
            [formate setDateFormat:@"dd MMM yyyy"];
            NSDate *date  =[formate dateFromString: [self.selectedCouponList valueForKey:@"ExpiryDate"]];
            
            NSMutableArray *arr_coupen = [[NSMutableArray alloc]init];
            arr_coupen = [self.arrayValidCoupen mutableCopy];
            
            for (int i=0; i<self.arrayValidCoupen.count; i++) {
                NSDate *date2  =[formate dateFromString: [[self.arrayValidCoupen valueForKey:@"ExpiryDate"] objectAtIndex:i]];
                if ([date compare:date2] == NSOrderedDescending) {
                    NSDictionary * dict = [self.arrayValidCoupen  objectAtIndex:i];
                    [arr_coupen removeObject:dict];
                }
            }
            self.arrayValidCoupen = [[NSMutableArray alloc]init];
            self.arrayValidCoupen = [arr_coupen mutableCopy];
            
            self.arraySpecialDayList = [[NSArray alloc]init];
            [self getSpecialDayList];
            _btn_Check_Box2.hidden = YES;
            _lbl_MSG_CheckBox2.hidden =YES;
            view_GSP_Status.hidden = YES;
            [_btn_Check_Box2 setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
            isOPTChecked = NO;
            [self.txt_Destitation setEnabled:NO];
            [self.txt_Year setEnabled:NO];
            [self.txt_Month setEnabled:NO];
            [self.txt_Date setEnabled:NO];
            
            [_btn_CheckBox setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
            [self.txt_Destitation setEnabled:YES];
            [self.txt_Year setEnabled:YES];
            
            _btn_Check_Box2.hidden = NO;
            _lbl_MSG_CheckBox2.hidden = NO;
            
            self.txt_Destitation.text = @"";
            self.lbl_Rooms.text = @"1";
            roomCount = 1;
            self.txt_Year.text = @"";
            self.txt_Month.text = @"";
            self.txt_Date.text = @"";
            
            [self.txt_Destitation setValue:[ICSingletonManager colorFromHexString:@"#BD9854"]forKeyPath:@"_placeholderLabel.textColor"];
            self.destitation_DD.image = [UIImage imageNamed:@"dropdownFill"];
            _iml_Line1.backgroundColor = [ICSingletonManager colorFromHexString:@"#BD9854"];
            _lbl_Title_Room.textColor = [ICSingletonManager colorFromHexString:@"#BD9854"];
            _lbl_PreferredDates.textColor = [ICSingletonManager colorFromHexString:@"#BD9854"];
            
            [self.btn_Decreament setEnabled:YES];
            [self.btn_Increament setEnabled:YES];
            
            [self.btn_Date setEnabled:YES];
            [self.btn_Date setTitleColor:[ICSingletonManager colorFromHexString:@"#BD9854"] forState:UIControlStateNormal];
            [self.btn_Week setEnabled:YES];
            [self.btn_Week setTitleColor:[ICSingletonManager colorFromHexString:@"#BD9854"] forState:UIControlStateNormal];
            [self.btn_Month setEnabled:YES];
            [self.btn_Month setTitleColor:[ICSingletonManager colorFromHexString:@"#BD9854"] forState:UIControlStateNormal];
            [self.btn_SpclDay setEnabled:YES];
            [self.btn_SpclDay setTitleColor:[ICSingletonManager colorFromHexString:@"#BD9854"] forState:UIControlStateNormal];
            
            
            [self.txt_Year setValue:[ICSingletonManager colorFromHexString:@"#BD9854"]forKeyPath:@"_placeholderLabel.textColor"];
            self.dropDown1.image = [UIImage imageNamed:@"dropdownFill"];
            _imgLine1.backgroundColor = [ICSingletonManager colorFromHexString:@"#BD9854"];
            
            _lbl_MSG_Box1.textColor = [UIColor blackColor];
            [_btn_CheckBox setEnabled:YES];
            [self ManageWishlistByCoupon:[[self.arrayCouponList valueForKey:@"CouponCode"] objectAtIndex:[self.pickerView selectedRowInComponent:0]]];
            [self getWishlistByCoupon];
            [self setCurrentYear];
             self.txt_Voucher.text = [[self.arrayCouponList valueForKey:@"CouponCodeDate"] objectAtIndex:[self.pickerView selectedRowInComponent:0]];
        }
    }
    else if (selectPicker == kDestination){
        if (self.mArrayDestinationList.count !=0){
            self.txt_Destitation.text = [[self.mArrayDestinationList valueForKey:@"CITY_NAME"] objectAtIndex:[self.pickerView selectedRowInComponent:0]];
            selectedCity = [[self.mArrayDestinationList valueForKey:@"CITY_ID"] objectAtIndex:[self.pickerView selectedRowInComponent:0]];
        }
    //    [self setCurrentYear];
    }
    else if (selectPicker==kYear)
    {
        [self.txt_Month setEnabled:YES];
        
        [self.txt_Month setValue:[ICSingletonManager colorFromHexString:@"#BD9854"]forKeyPath:@"_placeholderLabel.textColor"];
        self.dropDown2.image = [UIImage imageNamed:@"dropdownFill"];
        _imgLine2.backgroundColor = [ICSingletonManager colorFromHexString:@"#BD9854"];
        
        self.txt_Date.text = @"";
        self.txt_Month.text = @"";
        if (mArrayYears.count) {
            self.txt_Year.text = [mArrayYears objectAtIndex:[self.pickerView selectedRowInComponent:0]];
        }
      
    }
    else if (selectPicker==kMonths)
    {
        [self.txt_Date setEnabled:YES];
        [self.txt_Date setValue:[ICSingletonManager colorFromHexString:@"#BD9854"]forKeyPath:@"_placeholderLabel.textColor"];
        self.dropDown3.image = [UIImage imageNamed:@"dropdownFill"];
        _imgLine3.backgroundColor = [ICSingletonManager colorFromHexString:@"#BD9854"];
        self.txt_Date.text = @"";
        if (mArrayMonths.count !=0) {
            self.txt_Month.text = [mArrayMonths objectAtIndex:[self.pickerView selectedRowInComponent:0]];
        }
  //      [self setCurrentYear];
    }
    else if (selectPicker==kDate)
    {
        if ([self.txt_Date.placeholder isEqualToString:@"DATE"])
        {
            if (mArraydate.count != 0) {
                self.txt_Date.text = [mArraydate objectAtIndex:[self.pickerView selectedRowInComponent:0]];
            }
            
        }
        else if ([self.txt_Date.placeholder isEqualToString:@"WEEK"])
        {
            if (mArrayWeek.count !=0) {
                selectedMonth = [mArrayWeekNo objectAtIndex:[self.pickerView selectedRowInComponent:0]];;
                self.txt_Date.text = [mArrayWeek objectAtIndex:[self.pickerView selectedRowInComponent:0]];
            }
            
        }
   //     [self setCurrentYear];
    }
    else if (selectPicker==kSpecialDay)
    {
        // self.dateWeek.text = @"";
        if (self.arraySpecialDayList.count != 0) {
            self.txt_Year.text = [NSString stringWithFormat:@"%@ - %@ (%@) - %@",[[self.arraySpecialDayList objectAtIndex:[self.pickerView selectedRowInComponent:0]] valueForKey:@"EventName"],[[self.arraySpecialDayList objectAtIndex:[self.pickerView selectedRowInComponent:0]] valueForKey:@"Name"],[[self.arraySpecialDayList objectAtIndex:[self.pickerView selectedRowInComponent:0]] valueForKey:@"Relation_Name"],[[self.arraySpecialDayList objectAtIndex:[self.pickerView selectedRowInComponent:0]] valueForKey:@"EventDate"]];
            selectedSpecialDateId = [[self.arraySpecialDayList objectAtIndex:[self.pickerView selectedRowInComponent:0]] valueForKey:@"$id"];
        }
      //  [self setCurrentYear];
    }
    
    [self.scrollview setContentSize:CGSizeMake(self.view.frame.size.width, self.btnAddToWishList.frame.origin.y+self.btnAddToWishList.frame.size.height+10)];
    [self.view endEditing:YES];
    [self.viewPicker setHidden:YES];
}

#pragma mark Picker View Delegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}


-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    int count=0;
    
    if (selectPicker == kCoupon) {
        count = (int)[self.arrayCouponList count];
    }
    else if (selectPicker==kDestination)
    {
        count = (int)[self.mArrayDestinationList count];
    }
    else if (selectPicker==kYear)
    {
        count = (int)[mArrayYears count];
    }
    else if (selectPicker==kMonths)
    {
        count = (int)[mArrayMonths count];
    }
    else if (selectPicker==kDate)
    {
        if ([self.txt_Date.placeholder isEqualToString:@"DATE"])
        {
            count = (int)[mArraydate count];
        }
        else if ([self.txt_Date.placeholder isEqualToString:@"WEEK"])
        {
            count = (int)[mArrayWeek count];
        }
    }
    else if (selectPicker==kSpecialDay)
    {
        count = (int)[self.arraySpecialDayList count];
    }
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
    if (selectPicker == kCoupon) {
        title = [[self.arrayCouponList valueForKey:@"CouponCodeDate"] objectAtIndex:row];
    }
    else if (selectPicker == kDestination)
    {
        title=[[self.mArrayDestinationList objectAtIndex:row] valueForKey:@"CITY_NAME"];
    }
    else if (selectPicker == kYear)
    {
        title=[mArrayYears objectAtIndex:row];
    }
    else if (selectPicker == kMonths)
    {
        title=[mArrayMonths objectAtIndex:row];
    }
    else if (selectPicker == kDate)
    {
        if ([self.txt_Date.placeholder isEqualToString:@"DATE"])
        {
            title=[mArraydate objectAtIndex:row];
        }
        else if ([self.txt_Date.placeholder isEqualToString:@"WEEK"])
        {
            title=[mArrayWeek objectAtIndex:row];
        }
    }
    else if (selectPicker == kSpecialDay)
    {
        [tView setFont:[UIFont systemFontOfSize:14]];
        [tView setNumberOfLines:2];
        title=[NSString stringWithFormat:@"%@ - %@ (%@) - %@",[[self.arraySpecialDayList objectAtIndex:row] valueForKey:@"EventName"],[[self.arraySpecialDayList objectAtIndex:row] valueForKey:@"Name"],[[self.arraySpecialDayList objectAtIndex:row] valueForKey:@"Relation_Name"],[[self.arraySpecialDayList objectAtIndex:row] valueForKey:@"EventDate"]];
    }
    
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    tView.attributedText=attString;
    
    return tView;
}

- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated
{
    [self.pickerView selectRow:0 inComponent:0 animated:YES];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
}

- (IBAction)doClickonCheck_Box2:(id)sender {
    viewBlackTransparent.hidden = NO;
    viewTermsCondition.hidden = NO;
    view_GSP_Status.hidden = YES;
}
- (IBAction)doClickonDisagree:(id)sender {
    [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"You are no longer eligible for a guaranteed stay" onController:self];
    [_btn_Check_Box2 setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
    isOPTChecked = NO;
    GuaranteedStayApplicable = @"0";
    _opt_Constraint.constant = 31;
    viewBlackTransparent.hidden = YES;
    viewTermsCondition.hidden = YES;
    view_GSP_Status.hidden = YES;
    _btn_Week.enabled = YES;
    _btn_Month.enabled = YES;
    _btn_Increament.enabled = YES;
    _btn_Decreament.enabled = YES;
}
- (IBAction)doClickonAgree:(id)sender {
    [_btn_Check_Box2 setImage:[UIImage imageNamed:@"checkbox_selected"] forState:UIControlStateNormal];
    isOPTChecked = YES;
    GuaranteedStayApplicable = @"1";
    roomCount = 1;
    _lbl_Rooms.text = [NSString stringWithFormat:@"%d",roomCount];
    [self doClickonDate:self];
    
    // NSUInteger contentHeight = [[webW_Reason stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.body.scrollHeight;"]] intValue];
    _opt_Constraint.constant = 31;
    if (![[self.menageGSPData valueForKey:@"GSPStatus"] isEqual:[NSNull null]] && [[self.menageGSPData valueForKey:@"GSPStatus"]length] !=0 ) {
        _opt_Constraint.constant = 70;
        view_GSP_Status.hidden = NO;
    }
    viewBlackTransparent.hidden = YES;
    viewTermsCondition.hidden = YES;
    _btn_Week.enabled = NO;
    _btn_Month.enabled = NO;
    _btn_Increament.enabled = NO;
    _btn_Decreament.enabled = NO;
    webW_Reason.scrollView.scrollEnabled = NO;
    
}

- (IBAction)doClickonCheckBox:(id)sender {
    if ([[sender imageForState:UIControlStateNormal]isEqual:[UIImage imageNamed:@"checkbox"]]) {
        [_btn_CheckBox setImage:[UIImage imageNamed:@"checkbox_selected"] forState:UIControlStateNormal];
        isFamilyStayMessageClicked = YES;
    }
    else{
        [_btn_CheckBox setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
        isFamilyStayMessageClicked = NO;
    }
}
- (IBAction)doClickonAddToWishList:(id)sender {
    
    if (![self.lbl_Rooms.text isEqualToString:@"0"]) {
        if ([self.lbl_Rooms.text integerValue]==1)
        {
            familyStay = @"NO";
        }
        else
        {
       //     familyStay =  @"YES";
            familyStay = @"NO";
        }
    }
    //    NSLog(@"%@",self.familyStay.text);
    //    NSLog(@"%@",self.roomsCount.text);
    if ([self.txt_Voucher.text isEqualToString:@""])
    {
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Please select voucher!" onController:self];
    }
    
    else if ([self.txt_Destitation.text isEqualToString:@""])
    {
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Please select preferred destination!" onController:self];
    }
//    else if (isFamilyStayMessageClicked == NO)
//    {
//        [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Please accept term & condition!" onController:self];
//    }
    else if ([self.lbl_Rooms.text isEqualToString:@"0"] || [self.lbl_Rooms.text isEqualToString:@""])
    {
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Please select number of room!" onController:self];
    }
    else if ([prefered_Type isEqualToString:@""])
    {
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Please select wish type!" onController:self];
    }
    //    else if (isOPTChecked == NO){
    //        [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Please accept Opt For Guaranteed Stay!" onController:self];
    //    }
    else if ([prefered_Type isEqualToString:@"3"])
    {
        if ([self.txt_Year.text isEqualToString:@""])
        {
            [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Please select year!" onController:self];
        }
        else if ([self.txt_Month.text isEqualToString:@""])
        {
            [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Please select month!" onController:self];
        }
        else if ([self.txt_Date.text isEqualToString:@""])
        {
            [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Please select date!" onController:self];
        }
        else if ([familyStay isEqualToString:@"YES"])
        {
            if ([self.lbl_Rooms.text isEqualToString:@"0"])
            {
                [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Please select number of rooms!" onController:self];
            }
            else if (isFamilyStayMessageClicked == NO)
            {
                [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Please accept Room booking for Self, Spouse and Kids or Parents only!" onController:self];
            }
            else
            {
                if (self.arrayCouponList.count < [self.lbl_Rooms.text intValue])
                {
                    
                    
                    [self.scrollview setContentOffset:CGPointZero animated:YES];
                    [self.scrollview setScrollEnabled:NO];
                    isNotEnoughCouponCount = true;
                    [self createTransparentsView];
                }
                else
                {
                    mArraySelectedCoupon = [[NSMutableArray alloc]init];
                    [mArraySelectedCoupon addObject:[self.selectedCouponList objectForKey:@"CouponCode"]];
                    
                    [self.scrollview setContentOffset:CGPointZero animated:YES];
                    [self.scrollview setScrollEnabled:NO];
                    isNotEnoughCouponCount = false;
                    [self createTransparentsView];
                }
            }
        }
        else
        {
            if (self.arrayWishList.count <5)
            {
                if (self.isFromEdit) {
                    
                    if ([self.lbl_Rooms.text integerValue]==1)
                    {
                       [self postDataToEditWishlist];
                    }
                    else
                    {
                        if (self.arrayCouponList.count < [self.lbl_Rooms.text intValue])
                        {
                            
                            
                            [self.scrollview setContentOffset:CGPointZero animated:YES];
                            [self.scrollview setScrollEnabled:NO];
                            isNotEnoughCouponCount = true;
                            [self createTransparentsView];
                        }
                        else
                        {
                            mArraySelectedCoupon = [[NSMutableArray alloc]init];
                            [mArraySelectedCoupon addObject:[self.selectedCouponList objectForKey:@"CouponCode"]];
                            
                            [self.scrollview setContentOffset:CGPointZero animated:YES];
                            [self.scrollview setScrollEnabled:NO];
                            isNotEnoughCouponCount = false;
                            [self createTransparentsView];
                        }
                    }

                    
                    
                    
                }else{
                    
                    if ([self.lbl_Rooms.text integerValue]==1)
                    {
                        [self postDataToCreateWishlist];
                    }
                    else
                    {
                        if (self.arrayCouponList.count < [self.lbl_Rooms.text intValue])
                        {
                            
                            
                            [self.scrollview setContentOffset:CGPointZero animated:YES];
                            [self.scrollview setScrollEnabled:NO];
                            isNotEnoughCouponCount = true;
                            [self createTransparentsView];
                        }
                        else
                        {
                            mArraySelectedCoupon = [[NSMutableArray alloc]init];
                            [mArraySelectedCoupon addObject:[self.selectedCouponList objectForKey:@"CouponCode"]];
                            
                            [self.scrollview setContentOffset:CGPointZero animated:YES];
                            [self.scrollview setScrollEnabled:NO];
                            isNotEnoughCouponCount = false;
                            [self createTransparentsView];
                        }
                    }

                   
                }
                
                
            }
            else
            {
                [[ICSingletonManager sharedManager]showAlertViewWithMsg:[NSString stringWithFormat:@"Wishes for one Voucher are limited to Five Only, Please Buy More Voucher to add More Wishes."] onController:self];
            }
        }
    }
    else if ([prefered_Type isEqualToString:@"2"])
    {
        if ([self.txt_Year.text isEqualToString:@""])
        {
            [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Please select year!" onController:self];
        }
        else if ([self.txt_Month.text isEqualToString:@""])
        {
            [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Please select month!" onController:self];
        }
        else if ([self.txt_Date.text isEqualToString:@""])
        {
            [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Please select week!" onController:self];
        }
        else if ([familyStay isEqualToString:@"YES"])
        {
            if ([self.lbl_Rooms.text isEqualToString:@"0"])
            {
                [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Please select number of rooms!" onController:self];
            }
            else if (isFamilyStayMessageClicked == NO)
            {
                [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Please accept Room booking for Self, Spouse and Kids or Parents only!" onController:self];
            }
            else
            {
                if (self.arrayCouponList.count < [self.lbl_Rooms.text intValue])
                {
                    [self.scrollview setContentOffset:CGPointZero animated:YES];
                    [self.scrollview setScrollEnabled:NO];
                    isNotEnoughCouponCount = true;
                    [self createTransparentsView];
                    
                }
                else
                {
                    mArraySelectedCoupon = [[NSMutableArray alloc]init];
                    [mArraySelectedCoupon addObject:[self.selectedCouponList objectForKey:@"CouponCode"]];
                    
                    [self.scrollview setContentOffset:CGPointZero animated:YES];
                    [self.scrollview setScrollEnabled:NO];
                    isNotEnoughCouponCount = false;
                    [self createTransparentsView];
                }
            }
        }
        else
        {
            if (self.arrayWishList.count <5)
            {
                if (self.isFromEdit) {
                    if ([self.lbl_Rooms.text integerValue]==1)
                    {
                        [self postDataToEditWishlist];
                    }
                    else
                    {
                        if (self.arrayCouponList.count < [self.lbl_Rooms.text intValue])
                        {
                            
                            
                            [self.scrollview setContentOffset:CGPointZero animated:YES];
                            [self.scrollview setScrollEnabled:NO];
                            isNotEnoughCouponCount = true;
                            [self createTransparentsView];
                        }
                        else
                        {
                            mArraySelectedCoupon = [[NSMutableArray alloc]init];
                            [mArraySelectedCoupon addObject:[self.selectedCouponList objectForKey:@"CouponCode"]];
                            
                            [self.scrollview setContentOffset:CGPointZero animated:YES];
                            [self.scrollview setScrollEnabled:NO];
                            isNotEnoughCouponCount = false;
                            [self createTransparentsView];
                        }
                    }

                   
                    
                }
                else{
                    
                    if ([self.lbl_Rooms.text integerValue]==1)
                    {
                        [self postDataToCreateWishlist];
                    }
                    else
                    {
                        if (self.arrayCouponList.count < [self.lbl_Rooms.text intValue])
                        {
                            
                            
                            [self.scrollview setContentOffset:CGPointZero animated:YES];
                            [self.scrollview setScrollEnabled:NO];
                            isNotEnoughCouponCount = true;
                            [self createTransparentsView];
                        }
                        else
                        {
                            mArraySelectedCoupon = [[NSMutableArray alloc]init];
                            [mArraySelectedCoupon addObject:[self.selectedCouponList objectForKey:@"CouponCode"]];
                            
                            [self.scrollview setContentOffset:CGPointZero animated:YES];
                            [self.scrollview setScrollEnabled:NO];
                            isNotEnoughCouponCount = false;
                            [self createTransparentsView];
                        }
                    }

                }
                
            }
            else
            {
                [[ICSingletonManager sharedManager]showAlertViewWithMsg:[NSString stringWithFormat:@"Wishes for one Voucher are limited to Five Only, Please Buy More Voucher to add More Wishes."] onController:self];
            }
        }
    }
    else if ([prefered_Type isEqualToString:@"1"])
    {
        if ([self.txt_Year.text isEqualToString:@""])
        {
            [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Please select year!" onController:self];
        }
        else if ([self.txt_Month.text isEqualToString:@""])
        {
            [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Please select month!" onController:self];
        }
        else if ([familyStay isEqualToString:@"YES"])
        {
            if ([self.lbl_Rooms.text isEqualToString:@"0"])
            {
                [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Please select number of rooms!" onController:self];
            }
            else if (isFamilyStayMessageClicked == NO)
            {
                [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Please accept Room booking for Self, Spouse and Kids or Parents only!" onController:self];
            }
            else
            {
                if (self.arrayCouponList.count < [self.lbl_Rooms.text intValue])
                {
                    [self.scrollview setContentOffset:CGPointZero animated:YES];
                    [self.scrollview setScrollEnabled:NO];
                    isNotEnoughCouponCount = true;
                    [self createTransparentsView];
                    
                    //                    self.addToWishlistNotifyViewButton.titleLabel.text = @"BUY Voucher(S)";
                    
                }
                else
                {
                    mArraySelectedCoupon = [[NSMutableArray alloc]init];
                    [mArraySelectedCoupon addObject:[self.selectedCouponList objectForKey:@"CouponCode"]];
                    
                    [self.scrollview setContentOffset:CGPointZero animated:YES];
                    [self.scrollview setScrollEnabled:NO];
                    isNotEnoughCouponCount = false;
                    [self createTransparentsView];
                }
            }
        }
        else
        {
            if (self.arrayWishList.count <5)
            {
                if (self.isFromEdit) {
                    if ([self.lbl_Rooms.text integerValue]==1)
                    {
                        [self postDataToEditWishlist];
                    }
                    else
                    {
                        if (self.arrayCouponList.count < [self.lbl_Rooms.text intValue])
                        {
                            
                            
                            [self.scrollview setContentOffset:CGPointZero animated:YES];
                            [self.scrollview setScrollEnabled:NO];
                            isNotEnoughCouponCount = true;
                            [self createTransparentsView];
                        }
                        else
                        {
                            mArraySelectedCoupon = [[NSMutableArray alloc]init];
                            [mArraySelectedCoupon addObject:[self.selectedCouponList objectForKey:@"CouponCode"]];
                            
                            [self.scrollview setContentOffset:CGPointZero animated:YES];
                            [self.scrollview setScrollEnabled:NO];
                            isNotEnoughCouponCount = false;
                            [self createTransparentsView];
                        }
                    }
                    
                }
                else{
                    if ([self.lbl_Rooms.text integerValue]==1)
                    {
                        [self postDataToCreateWishlist];
                    }
                    else
                    {
                        if (self.arrayCouponList.count < [self.lbl_Rooms.text intValue])
                        {
                            
                            
                            [self.scrollview setContentOffset:CGPointZero animated:YES];
                            [self.scrollview setScrollEnabled:NO];
                            isNotEnoughCouponCount = true;
                            [self createTransparentsView];
                        }
                        else
                        {
                            mArraySelectedCoupon = [[NSMutableArray alloc]init];
                            [mArraySelectedCoupon addObject:[self.selectedCouponList objectForKey:@"CouponCode"]];
                            
                            [self.scrollview setContentOffset:CGPointZero animated:YES];
                            [self.scrollview setScrollEnabled:NO];
                            isNotEnoughCouponCount = false;
                            [self createTransparentsView];
                        }
                    }
                    

                }
                
            }
            else
            {
                [[ICSingletonManager sharedManager]showAlertViewWithMsg:[NSString stringWithFormat:@"Wishes for one Voucher are limited to Five Only, Please Buy More Voucher to add More Wishes."] onController:self];
            }
        }
    }
    else if ([prefered_Type isEqualToString:@"4"])
    {
        if ([self.txt_Year.text isEqualToString:@""]){
            [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Please select Secial Day!" onController:self];
        }
        else if ([familyStay isEqualToString:@"YES"])
        {
            if ([self.lbl_Rooms.text isEqualToString:@"0"])
            {
                [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Please select number of rooms!" onController:self];
            }
            else if (isFamilyStayMessageClicked == NO)
            {
                [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Please accept Room booking for Self, Spouse and Kids or Parents only!" onController:self];
            }
            else
            {
                if (self.arrayCouponList.count < [self.lbl_Rooms.text intValue])
                {
                    [self.scrollview setContentOffset:CGPointZero animated:YES];
                    [self.scrollview setScrollEnabled:NO];
                    isNotEnoughCouponCount = true;
                    [self createTransparentsView];
                    
                    
                    //                    self.addToWishlistNotifyViewButton.titleLabel.text = @"BUY VOUCHER(S)";
                    
                }
                else
                {
                    mArraySelectedCoupon = [[NSMutableArray alloc]init];
                    [mArraySelectedCoupon addObject:[self.selectedCouponList objectForKey:@"CouponCode"]];
                    
                    [self.scrollview setContentOffset:CGPointZero animated:YES];
                    [self.scrollview setScrollEnabled:NO];
                    isNotEnoughCouponCount = false;
                    [self createTransparentsView];
                }
            }
        }
        else
        {
            if (self.arrayWishList.count <5)
            {
                if (self.isFromEdit) {
                    if ([self.lbl_Rooms.text integerValue]==1)
                    {
                        [self postDataToEditWishlist];
                    }
                    else
                    {
                        if (self.arrayCouponList.count < [self.lbl_Rooms.text intValue])
                        {
                            
                            
                            [self.scrollview setContentOffset:CGPointZero animated:YES];
                            [self.scrollview setScrollEnabled:NO];
                            isNotEnoughCouponCount = true;
                            [self createTransparentsView];
                        }
                        else
                        {
                            mArraySelectedCoupon = [[NSMutableArray alloc]init];
                            [mArraySelectedCoupon addObject:[self.selectedCouponList objectForKey:@"CouponCode"]];
                            
                            [self.scrollview setContentOffset:CGPointZero animated:YES];
                            [self.scrollview setScrollEnabled:NO];
                            isNotEnoughCouponCount = false;
                            [self createTransparentsView];
                        }
                    }
                    
                }
                else{
                    if ([self.lbl_Rooms.text integerValue]==1)
                    {
                        [self postDataToCreateWishlist];
                    }
                    else
                    {
                        if (self.arrayCouponList.count < [self.lbl_Rooms.text intValue])
                        {
                            
                            
                            [self.scrollview setContentOffset:CGPointZero animated:YES];
                            [self.scrollview setScrollEnabled:NO];
                            isNotEnoughCouponCount = true;
                            [self createTransparentsView];
                        }
                        else
                        {
                            mArraySelectedCoupon = [[NSMutableArray alloc]init];
                            [mArraySelectedCoupon addObject:[self.selectedCouponList objectForKey:@"CouponCode"]];
                            
                            [self.scrollview setContentOffset:CGPointZero animated:YES];
                            [self.scrollview setScrollEnabled:NO];
                            isNotEnoughCouponCount = false;
                            [self createTransparentsView];
                        }
                    }

                }
                               }
            else
            {
                [[ICSingletonManager sharedManager]showAlertViewWithMsg:[NSString stringWithFormat:@"Wishes for one Voucher are limited to Five Only, Please Buy More Voucher to add More Wishes."] onController:self];
            }
        }
    }
    
}

-(void)postDataToEditWishlist
{
    //http://dev.icanstay.businesstowork.com/api/Wishlist/CreateWishlistMobile
    /*
     "Prf_Dest_id": For ADD(0)/For Edit Prf_Dest_ID,
     "Wishlist_ID": 2,
     "Prf_Seq": Sequence Number FROM UI,
     "CouponCode": Coupon Code from Coupon date,
     "CouponYear": Coupon Year from Coupon date,
     "CouponMonth": Coupon Month from Coupon date,
     "CouponDay": Coupon Week Number from Coupon date,
     "CityID": City ID from UI,
     "SelectedYear": Selected Year from UI,
     "SelectedMonth": Selected Month from UI,
     "SelectedWeek": Selected Week number from UI (Can be 0 if   not selected),
     "SelectedDay": selected day from UI (can be 0 if not               selected),
     "SelectedWishType": 1-Month,2-Week,3-Date,4-SpecialDate,
     "SelectedSpecialDay": Special Date if selected else null,
     "FamilyStay": (Y/N),
     "RoomCount": Number of rooms from UI if Family stay Y Else 1,
     "NotifyForEntireFamily": (True/False),
     "SelectedCouponList": (Comma separated coupon code if Family stay Y Else Null)
     */
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *day,*week,*yearString,*monthString,*specialDay,*familyStay2,*roomC,*notify,*selectedArrayCouponList,*wishType;
    roomC = _lbl_Rooms.text;
    for (int i= 0; i < self.arrayMonthList.count; i++)
    {
        if ([self.txt_Month.text isEqualToString:[self.arrayMonthList objectAtIndex:i]])
        {
            monthString = [NSString stringWithFormat:@"%d",i+1];
        }
    }
    
    if ([prefered_Type isEqualToString:@"3"])
    {
        wishType = @"3";
        
        yearString =self.txt_Year.text;
        day = self.txt_Date.text;
        week = @"0";
        specialDay = @"0";
    }
    else if ([prefered_Type isEqualToString:@"2"])
    {
        wishType = @"2";
        
        yearString =self.txt_Year.text;
        day = @"0";
        week = selectedMonth;
        specialDay = @"0";
    }
    else if ([prefered_Type isEqualToString:@"1"])
    {
        wishType = @"1";
        yearString =self.txt_Year.text;
        day = @"0";
        week = @"0";
        specialDay = @"0";
    }
    else if ([prefered_Type isEqualToString:@"4"])
    {
        for (int i=0; i< self.arraySpecialDayList.count; i++)
        {
            if ([[[self.arraySpecialDayList objectAtIndex:i] valueForKey:@"$id"] isEqualToString:selectedSpecialDateId])
            {
                yearString =[self convertDateFormat:[[self.arraySpecialDayList objectAtIndex:i]valueForKey:@"EventDate"] sourceFormate:@"dd MMM yyyy" targetFormate:@"yyyy"];
                monthString =[self convertDateFormat:[[self.arraySpecialDayList objectAtIndex:i]valueForKey:@"EventDate"] sourceFormate:@"dd MMM yyyy" targetFormate:@"MM"];
                day = [self convertDateFormat:[[self.arraySpecialDayList objectAtIndex:i]valueForKey:@"EventDate"] sourceFormate:@"dd MMM yyyy" targetFormate:@"dd"];
            }
        }
        wishType = @"4";
        week = @"0";
        specialDay = @"1";
    }
    
    
    if ([familyStay isEqualToString:@"YES"])
    {
        familyStay2 = @"Y";
        roomC = _lbl_Rooms.text;
        if (isNotifyMeClicked)
        {
            notify = @"True";
        }
        else
        {
            notify = @"False";
        }
        for (int i=0; i<mArraySelectedCoupon.count; i++)
        {
            if (i == 0)
            {
                selectedArrayCouponList =[mArraySelectedCoupon objectAtIndex:i];
            }
            else
            {
                selectedArrayCouponList = [selectedArrayCouponList stringByAppendingString:[mArraySelectedCoupon objectAtIndex:i]];
            }
            
            if (i!=mArraySelectedCoupon.count-1)
            {
                selectedArrayCouponList = [selectedArrayCouponList stringByAppendingString:@","];
            }
        }
    }
    else if ([familyStay isEqualToString:@"NO"])
    {
        familyStay2 = @"N";
        roomC = @"1";
         roomC = _lbl_Rooms.text;
        notify = @"False";
        selectedArrayCouponList = @"";
    }
    
    NSMutableDictionary *dictPost=[NSMutableDictionary new];
    NSString *Wishlist_ID = [NSString stringWithFormat:@"%@",[self.dictionaryCouponList objectForKey:@"Wishlist_ID"] ];
    NSString *Prf_Dest_id = [NSString stringWithFormat:@"%@",[self.dictionaryCouponList objectForKey:@"Prf_Dest_id"]] ;
    [dictPost setValue:Prf_Dest_id forKey:@"Prf_Dest_id"];
    [dictPost setValue:Wishlist_ID forKey:@"Wishlist_ID"];
    //    [dictPost setValue:[self.dictionaryCouponList objectForKey:@"Prf_Seq"] forKey:@"Prf_Seq"];
    [dictPost setValue:[NSNumber numberWithInt:0] forKey:@"Prf_Seq"];
    
    [dictPost setValue:[self.selectedCouponList objectForKey:@"CouponCode"] forKey:@"CouponCode"];
    [dictPost setValue:[self.selectedCouponList objectForKey:@"CouponYear"] forKey:@"CouponYear"];
    [dictPost setValue:[self.selectedCouponList objectForKey:@"CouponMonth"] forKey:@"CouponMonth"];
    [dictPost setValue:[self.selectedCouponList objectForKey:@"CouponDay"] forKey:@"CouponDay"];
    [dictPost setValue:selectedCity  forKey:@"CityID"];
    [dictPost setValue:yearString forKey:@"SelectedYear"];
    [dictPost setValue:monthString forKey:@"SelectedMonth"];//self.month.text
    [dictPost setValue:week forKey:@"SelectedWeek"];
    [dictPost setValue:day forKey:@"SelectedDay"];
    [dictPost setValue:wishType forKey:@"SelectedWishType"];
    [dictPost setValue:specialDay forKey:@"SelectedSpecialDay"];
    [dictPost setValue:familyStay forKey:@"FamilyStay"];
    [dictPost setValue:roomC forKey:@"RoomCount"];
    [dictPost setValue:notify forKey:@"NotifyForEntireFamily"];
    [dictPost setValue:selectedArrayCouponList forKey:@"SelectedCouponList"];
    [dictPost setValue:GuaranteedStayApplicable forKey:@"GuaranteedStayApplicable"];
    
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
    
    [manager POST:[NSString stringWithFormat:@"%@/api/Wishlist/CreateWishlistMobile",kServerUrl] parameters:dictPost success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        
        NSString *status = [responseObject valueForKey:@"status"];
        NSString *msg = [responseObject valueForKey:@"errorMessage"];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            LoginManager *login = [[LoginManager alloc]init];
            if ([[login isUserLoggedIn] count]>0)
            {
                SideMenuController *vcSideMenu = [[SideMenuController alloc]init];
                [vcSideMenu startServiceToGetCouponsDetails];
            }
        });
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:msg message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            
            
            MyWishlistViewController *buyCoupon =[self.storyboard instantiateViewControllerWithIdentifier:@"MyWishlistViewController"];
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
            self.view.window.rootViewController = navController;
        }];
        [alert addAction:defaultAction];
        
            [self presentViewController:alert animated:YES completion:nil];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:error.localizedDescription onController:self];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
    
}


-(void)postDataToCreateWishlist
{
    //http://dev.icanstay.businesstowork.com/api/Wishlist/CreateWishlistMobile
    /*
     "Prf_Dest_id": For ADD(0)/For Edit Prf_Dest_ID,
     "Wishlist_ID": 2,
     "Prf_Seq": Sequence Number FROM UI,
     "CouponCode": Coupon Code from Coupon date,
     "CouponYear": Coupon Year from Coupon date,
     "CouponMonth": Coupon Month from Coupon date,
     "CouponDay": Coupon Week Number from Coupon date,
     "CityID": City ID from UI,
     "SelectedYear": Selected Year from UI,
     "SelectedMonth": Selected Month from UI,
     "SelectedWeek": Selected Week number from UI (Can be 0 if   not selected),
     "SelectedDay": selected day from UI (can be 0 if not               selected),
     "SelectedWishType": 1-Month,2-Week,3-Date,4-SpecialDate,
     "SelectedSpecialDay": Special Date if selected else null,
     "FamilyStay": (Y/N),
     "RoomCount": Number of rooms from UI if Family stay Y Else 1,
     "NotifyForEntireFamily": (True/False),
     "SelectedCouponList": (Comma separated coupon code if Family stay Y Else Null)
     */
    NSString *day,*week,*yearString,*monthString,*specialDay,*familyStay2
    ,*roomC,*notify,*selectedArrayCouponList,*wishType;
    
    roomC = _lbl_Rooms.text;
    for (int i= 0; i < self.arrayMonthList.count; i++)
    {
        if ([self.txt_Month.text isEqualToString:[self.arrayMonthList objectAtIndex:i]])
        {
            monthString = [NSString stringWithFormat:@"%d",i+1];
        }
    }
    if ([prefered_Type isEqualToString:@"3"])
    {
        wishType = @"3";
        
        yearString =self.txt_Year.text;
        day = self.txt_Date.text;
        week = @"0";
        specialDay = @"0";
    }
    else if ([prefered_Type isEqualToString:@"2"])
    {
        wishType = @"2";
        
        yearString =self.txt_Year.text;
        day = @"0";
        week = selectedMonth;
        specialDay = @"0";
    }
    else if ([prefered_Type isEqualToString:@"1"])
    {
        wishType = @"1";
        yearString =self.txt_Year.text;
        day = @"0";
        week = @"0";
        specialDay = @"0";
    }
    else if ([prefered_Type isEqualToString:@"4"])
    {
        for (int i=0; i< self.arraySpecialDayList.count; i++)
        {
            if ([[[self.arraySpecialDayList objectAtIndex:i] valueForKey:@"$id"] isEqualToString:selectedSpecialDateId])
            {
                yearString =[self convertDateFormat:[[self.arraySpecialDayList objectAtIndex:i]valueForKey:@"EventDate"] sourceFormate:@"dd MMM yyyy" targetFormate:@"yyyy"];
                monthString =[self convertDateFormat:[[self.arraySpecialDayList objectAtIndex:i]valueForKey:@"EventDate"] sourceFormate:@"dd MMM yyyy" targetFormate:@"MM"];
                day = [self convertDateFormat:[[self.arraySpecialDayList objectAtIndex:i]valueForKey:@"EventDate"] sourceFormate:@"dd MMM yyyy" targetFormate:@"dd"];
            }
        }
        wishType = @"4";
        week = @"0";
        specialDay = @"1";
    }
    if ([familyStay2 isEqualToString:@"YES"])
    {
        familyStay2 = @"Y";
        roomC = self.lbl_Rooms.text;
        if (isNotifyMeClicked) {
            notify = @"True";
        } else {
            notify = @"False";
        }
        for (int i=0; i<mArraySelectedCoupon.count; i++)
        {
            if (i == 0) {
                selectedArrayCouponList =[mArraySelectedCoupon objectAtIndex:i];
            }
            else
            {
                selectedArrayCouponList = [selectedArrayCouponList stringByAppendingString:[mArraySelectedCoupon objectAtIndex:i]];
            }
            if (i!=mArraySelectedCoupon.count-1)
            {
                selectedArrayCouponList = [selectedArrayCouponList stringByAppendingString:@","];
            }
        }
    }
    else if ([familyStay2 isEqualToString:@"NO"])
    {
        familyStay2 = @"N";
        roomC = @"1";
        notify = @"False";
        selectedArrayCouponList = @"";
    }
    
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    NSMutableDictionary *dictPost=[NSMutableDictionary new];
    [dictPost setValue:@"0" forKey:@"Prf_Dest_id"];
    [dictPost setValue:@"0" forKey:@"Wishlist_ID"];
    [dictPost setValue:@"0" forKey:@"Prf_Seq"];
    [dictPost setValue:[self.selectedCouponList objectForKey:@"CouponCode"] forKey:@"CouponCode"];
    [dictPost setValue:[self.selectedCouponList objectForKey:@"CouponYear"] forKey:@"CouponYear"];
    [dictPost setValue:[self.selectedCouponList objectForKey:@"CouponMonth"] forKey:@"CouponMonth"];
    [dictPost setValue:[self.selectedCouponList objectForKey:@"CouponDay"] forKey:@"CouponDay"];
    [dictPost setValue:selectedCity  forKey:@"CityID"];
    [dictPost setValue:yearString forKey:@"SelectedYear"];
    [dictPost setValue:monthString forKey:@"SelectedMonth"];//self.month.text
    [dictPost setValue:week forKey:@"SelectedWeek"];
    [dictPost setValue:day forKey:@"SelectedDay"];
    [dictPost setValue:wishType forKey:@"SelectedWishType"];
    [dictPost setValue:specialDay forKey:@"SelectedSpecialDay"];
    [dictPost setValue:familyStay2 forKey:@"FamilyStay"];
    [dictPost setValue:roomC forKey:@"RoomCount"];
    [dictPost setValue:notify forKey:@"NotifyForEntireFamily"];
    [dictPost setValue:selectedArrayCouponList forKey:@"SelectedCouponList"];
    [dictPost setValue:GuaranteedStayApplicable forKey:@"GuaranteedStayApplicable"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager POST:[NSString stringWithFormat:@"%@/api/Wishlist/CreateWishlistMobile",kServerUrl] parameters:dictPost success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"responseObject=%@",responseObject);
         
         NSString *status = [responseObject valueForKey:@"status"];
         NSString *msg = [responseObject valueForKey:@"errorMessage"];
        
         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
             
             LoginManager *login = [[LoginManager alloc]init];
             if ([[login isUserLoggedIn] count]>0)
             {
                 SideMenuController *vcSideMenu = [[SideMenuController alloc]init];
                 [vcSideMenu startServiceToGetCouponsDetails];
             }
         });
         
         UIAlertController *alert = [UIAlertController alertControllerWithTitle:msg message:nil preferredStyle:UIAlertControllerStyleAlert];
         UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
             
             // Enter code here
             UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
             
             
             MyWishlistViewController *buyCoupon =[self.storyboard instantiateViewControllerWithIdentifier:@"MyWishlistViewController"];
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
             self.view.window.rootViewController = navController;

         }];
         [alert addAction:defaultAction];
         
         // Present action where needed
         [self presentViewController:alert animated:YES completion:nil];
         
                 NSLog(@"sucess");
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"failure");
                  
         [[ICSingletonManager sharedManager]showAlertViewWithMsg:error.localizedDescription onController:self];
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         
     }];
    
}

- (void)startServiceToGetCouponsDetails
{
    
    //  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    LoginManager *loginManage = [[LoginManager alloc]init];
    NSDictionary *dict = [loginManage isUserLoggedIn];
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
    NSNumber *num = [dict valueForKey:@"UserId"];
    
    NSDictionary *dictParams = @{@"userid":num};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8"
                     forHTTPHeaderField:@"Content-Type"];
    
    [manager GET:[NSString stringWithFormat:@"%@/api/BuyCoupens/GetUserDashboardDetail?",kServerUrl] parameters:dictParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
            
            
        }
        
        NSLog(@"sucess");
        //      [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        //    [MBProgressHUD hideHUDForView:self.view animated:YES];
        [[ICSingletonManager sharedManager] showAlertViewWithMsg:error.localizedDescription onController:self];
        
    }];
    
    
}

-(void)createTransparentsView{
    UIImageView *img_BGTranparent = [[UIImageView alloc]initWithFrame:self.view.frame];
    img_BGTranparent.backgroundColor = [UIColor blackColor];
    img_BGTranparent.alpha = 0.7;
    img_BGTranparent.userInteractionEnabled = YES;
    img_BGTranparent.tag = 11;
    [self.view addSubview:img_BGTranparent];
    [self.view bringSubviewToFront:img_BGTranparent];
    
    UITapGestureRecognizer *singleTapOwner = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(imageOwnerTapped:)];
    singleTapOwner.numberOfTapsRequired = 1;
    singleTapOwner.cancelsTouchesInView = YES;
    [img_BGTranparent addGestureRecognizer:singleTapOwner];
    
    UIView *viewFrontVouchers = [[UIView alloc]initWithFrame:CGRectMake(20, self.view.frame.size.height/2-150, self.view.frame.size.width-40, 300)];
    viewFrontVouchers.backgroundColor = [UIColor whiteColor];
    viewFrontVouchers.layer.cornerRadius = 9;
    viewFrontVouchers.tag =12;
    [self.view addSubview:viewFrontVouchers];
    [self.view bringSubviewToFront:viewFrontVouchers];
    
    UILabel *lbl_Header = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, viewFrontVouchers.frame.size.width, 30)];
    lbl_Header.text = [NSString stringWithFormat:@"  Select Voucher(s) (%@)",self.lbl_Rooms.text];
    lbl_Header.textColor = [UIColor whiteColor];
    //11 30 66
    lbl_Header.backgroundColor = [UIColor colorWithRed:(11.0/255.0) green:(30.0/255.0) blue:(66.0/255.0) alpha:1.0];
    [viewFrontVouchers addSubview:lbl_Header];
    
    UILabel *lbl_MSG = [[UILabel alloc]initWithFrame:CGRectMake(5, lbl_Header.frame.size.height+20, viewFrontVouchers.frame.size.width-5, 50)];
    lbl_MSG.text = [NSString stringWithFormat:@"You don't have enough Voucher(s) to make this Wishlist, Click Here to Buy more Voucher(s)"];
    lbl_MSG.font = [UIFont systemFontOfSize:15];
    lbl_MSG.numberOfLines =0;
    lbl_MSG.textColor = [UIColor darkGrayColor];
    [viewFrontVouchers addSubview:lbl_MSG];
    
    if (isNotEnoughCouponCount == false) {
        self.tbl_List.frame = CGRectMake(25, viewFrontVouchers.frame.origin.y+lbl_Header.frame.size.height+20, self.view.frame.size.width-50, viewFrontVouchers.frame.size.height-(lbl_Header.frame.size.height+80));
        [self.view bringSubviewToFront:_tbl_List];
        self.tbl_List.hidden = NO;
        [self.tbl_List reloadData];
    }
    
    UIButton *btn_BuyVoucher =[[UIButton alloc]initWithFrame:CGRectMake(10, viewFrontVouchers.frame.size.height-35, 130, 30)];
    btn_BuyVoucher.layer.cornerRadius = 8;
    btn_BuyVoucher.clipsToBounds = YES;
    
    if (self.arrayValidCoupen.count < [self.lbl_Rooms.text intValue]-1)
    {
        [btn_BuyVoucher setTitle:@"Buy Voucher(s)" forState:UIControlStateNormal];
    }
    else{
        [btn_BuyVoucher setTitle:@"Add To Wishlist" forState:UIControlStateNormal];
    }
    [btn_BuyVoucher setBackgroundColor:[UIColor colorWithRed:(173.0/255.0) green:(130.0/255.0) blue:(61.0/255.0) alpha:1.0]];
    [btn_BuyVoucher addTarget:self action:@selector(doclickonBuyVoucher:) forControlEvents:UIControlEventTouchUpInside];
    [viewFrontVouchers addSubview:btn_BuyVoucher];
    
    UIButton *btn_cancel =[[UIButton alloc]initWithFrame:CGRectMake(150, viewFrontVouchers.frame.size.height-35, 100, 30)];
    btn_cancel.layer.cornerRadius = 8;
    btn_cancel.clipsToBounds = YES;
    [btn_cancel setTitle:@"Cancel" forState:UIControlStateNormal];
    [btn_cancel setBackgroundColor:[UIColor colorWithRed:(173.0/255.0) green:(130.0/255.0) blue:(61.0/255.0) alpha:1.0]];
    [btn_cancel addTarget:self action:@selector(imageOwnerTapped:) forControlEvents:UIControlEventTouchUpInside];
    [viewFrontVouchers addSubview:btn_cancel];
    
}
- (void)doclickonBuyVoucher:(id)sender
{
    if (isNotEnoughCouponCount)
    {
        ICSingletonManager *globals = [ICSingletonManager sharedManager];
        globals.isFromMenuForBuyVoucher = false;
        BuyCouponViewController *buyCoupon =[self.storyboard  instantiateViewControllerWithIdentifier:@"BuyCouponViewController"];
        [self.navigationController pushViewController:buyCoupon animated:YES];
    }
    else
    {
        if (mArraySelectedCoupon.count == [self.lbl_Rooms.text intValue])
        {
            if (self.arrayWishList.count <5)
            {
                if (self.isFromEdit) {
                     [self postDataToEditWishlist];
                }else{
                    [self postDataToCreateWishlist];
                }
            
               
                
                
                
            }
            else
            {
                [[ICSingletonManager sharedManager]showAlertViewWithMsg:[NSString stringWithFormat:@"Wishes for one Voucher are limited to Five Only, Please Buy More Voucher to add More Wishes."] onController:self];
            }
        }
        else
        {
            [[ICSingletonManager sharedManager]showAlertViewWithMsg:[NSString stringWithFormat:@"Please select %@ Voucher(s)",self.lbl_Rooms.text] onController:self];
        }
    }
    
}
- (IBAction)cellButtonTapped:(UIButton*)sender
{
    CreateWishlistTableViewCell *cell = [self.tbl_List cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
    BOOL isExisted = false;
    int index = 0;
    
    for (int i = 0; i<mArraySelectedCoupon.count;i++)
    {
        if ([cell.couponCode.text isEqualToString:[mArraySelectedCoupon objectAtIndex:i]])
        {
            index = i;
            isExisted = true;
            break;
        } else {
            isExisted = false;
        }
    }
    if (isExisted)
    {
        if (![cell.couponCode.text isEqualToString:[self.selectedCouponList objectForKey:@"CouponCode"]])
        {
            [mArraySelectedCoupon removeObjectAtIndex:index];
        }
    } else
    {
        if (mArraySelectedCoupon.count < [self.lbl_Rooms.text intValue])
        {
            [mArraySelectedCoupon addObject:[[self.arrayValidCoupen objectAtIndex:sender.tag] valueForKey:@"CouponCode"]];
        }
        else
        {
            [[ICSingletonManager sharedManager]showAlertViewWithMsg:[NSString stringWithFormat:@"Please select %@ Voucher(s) only",self.lbl_Rooms.text] onController:self];
        }
    }
    [self.tbl_List reloadData];
}

#pragma mark - UITableview Data source & Delegate

#pragma mark - TableView Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayValidCoupen.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier1 = @"Cell";
    //Storing dictionary value from array at index
    NSDictionary *couponDictionary = [self.arrayValidCoupen objectAtIndex:indexPath.row];
    CreateWishlistTableViewCell *cell;
    //Code for setting table view cell
    cell = (CreateWishlistTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
    if (cell == nil)
    {
        cell = [[CreateWishlistTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier1];
    }
    // Configure the cell...
    cell.couponCode.text = [couponDictionary objectForKey:@"CouponCode"];
    cell.validFrom.text = [couponDictionary objectForKey:@"CouponValidFromDate"];
    cell.validTill.text = [couponDictionary objectForKey:@"ExpiryDate"];
    cell.cellButton.tag = indexPath.row;
    [cell.cellButton addTarget:self action:@selector(cellButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    for (int i=0; i<mArraySelectedCoupon.count; i++)
    {
        if ([[mArraySelectedCoupon objectAtIndex:i]isEqualToString:[couponDictionary objectForKey:@"CouponCode"]])
        {
            [cell.cellButton setImage:[UIImage imageNamed:@"checkbox_selected"] forState:UIControlStateNormal];
            break;
        }
        else
        {
            [cell.cellButton setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 83.0;
}

-(void)imageOwnerTapped:(id)sender {
    [self.scrollview setScrollEnabled:YES];
    [[self.view viewWithTag:11] removeFromSuperview];
    [[self.view viewWithTag:12] removeFromSuperview];
    self.tbl_List.hidden = YES;
}
#pragma mark- Date Custom Actions

-(NSString *)stringFromNSDate:(NSDate *)date dateFormate:(NSString *)dateFormate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:dateFormate];
    NSString *formattedDate = [dateFormatter stringFromDate:date];
    return formattedDate;
    
}

-(NSDate *)nsdateFromString:(NSString *)dateString dateFormate:(NSString *)dateFormate{
    NSDate *date = [[NSDate alloc] init];
    //date formatter for the above string
    NSDateFormatter *dateFormatterWS = [[NSDateFormatter alloc] init];
    [dateFormatterWS setDateFormat:dateFormate];
    date =[dateFormatterWS dateFromString:dateString];
    //NSLog(@"Date %@",date);
    return date;
}

// converts date format from source to target format
-(NSString *) convertDateFormat:(NSString *)dateString sourceFormate:(NSString *)sourceFormate targetFormate:(NSString *)targetFormate {
    //date formatter for the above string
    NSDateFormatter *dateFormatterWS = [[NSDateFormatter alloc] init];
    [dateFormatterWS setDateFormat:sourceFormate];
    NSDate *date =[dateFormatterWS dateFromString:dateString];
    //date formatter that you want
    NSDateFormatter *dateFormatterNew = [[NSDateFormatter alloc] init];
    [dateFormatterNew setDateFormat:targetFormate];
    NSString *stringForNewDate = [dateFormatterNew stringFromDate:date];
    //NSLog(@"Date %@",stringForNewDate);
    return stringForNewDate;
}

@end
