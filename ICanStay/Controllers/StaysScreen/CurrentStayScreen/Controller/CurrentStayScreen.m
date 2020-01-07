//
//  CurrentStayScreen.m
//  ICanStay
//
//  Created by Vertical Logics on 10/03/16.
//  Copyright (c) 2016 Harry Patel (Hitaishin). All rights reserved.
//

#import "CurrentStayScreen.h"
#import "MBProgressHUD.h"
#import <AFNetworking.h>
#import "LoginManager.h"
#import "CurrentStayCell.h"
#import "CurrentStayHotelData.h"
#import "CurrentStayHotelList.h"
//#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>
#import "HomeScreenController.h"
#import "SideMenuController.h"
#import "LastMinutePaymentSuccessPopUpView.h"


#import "ShareExperienceScreen.h"

@interface CurrentStayScreen ()<CurrentStayCellDelegate>
- (IBAction)btnBackTapped:(id)sender;
@property (nonatomic)CurrentStayHotelList *hotelList;
@property (strong, nonatomic) IBOutlet UIButton *searchBtn;

@property (weak, nonatomic) IBOutlet UITableView *tblCurrentStay;
@property (strong, nonatomic) IBOutlet UIView *myCurrentStayVw;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tblVwYConstraint;
- (IBAction)btnSearchPastStayTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnStartDateText;
@property (weak, nonatomic) IBOutlet UIButton *btnEndDateText;
- (IBAction)btnStartDateTapped:(id)sender;

- (IBAction)btnEndDateTapped:(id)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constrainstHeightSearchDateView;
@property (weak, nonatomic) IBOutlet UIView *ViewPicker;

- (IBAction)btnDonePickerTapped:(id)sender;

- (IBAction)btnCancelPickerTapped:(id)sender;

- (IBAction)pickerValueChanged:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblStay;

@property (weak, nonatomic) IBOutlet UILabel *lblStayHeader;


@property (nonatomic)UIButton *btnActive; // UIButton to be used in selcting date from picker view in PastStay Screen

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (nonatomic)NSArray *arrContainingData;
@property(weak, nonatomic)          LastMinutePaymentSuccessPopUpView  *_paymentView;

@end

@implementation CurrentStayScreen
@synthesize _paymentView;

- (void)viewDidLoad {
    [super viewDidLoad];
     DLog(@"DEBUG-VC");
    
//    self.searchBtn.layer.cornerRadius = 10;
//    self.searchBtn.clipsToBounds = YES;
    
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    [tracker set:kGAIScreenName value:@"Stays"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    // Do any additional setup after loading the view.
   // self.constrainstHeightSearchDateView.constant =0;
    [[ICSingletonManager sharedManager]gettingDateStringToBeSendInPastStayApiFromStrDate:@""];
    
    if (!self.isPastStayScreen) {
        [self startServiceToGetCurrentStay];
       // [self.constrainstHeightSearchDateView setConstant: 0];
        [self.lblStay setText:@"Upcoming Stay(s)"];
        [self.lblStayHeader setText:@"Upcoming Stay(s)"];
        
        [self.tblVwYConstraint setConstant:-120];
        [self.myCurrentStayVw setHidden:YES];
    }
    else{
        [self.lblStay setText:@"Completed Stay(s)"];
        [self.lblStayHeader setText:@"Completed Stay(s)"];
        [self.datePicker setMaximumDate:[NSDate date]];

        
        NSDate *todayDate = [NSDate date];
        NSDate *oneDayAgo = [todayDate dateByAddingTimeInterval:-1*24*60*60];
        NSString *strOneDayPrevDate = [self gettingFormattedDateFromDate:oneDayAgo];
        [self.btnEndDateText setTitle:strOneDayPrevDate forState:UIControlStateNormal];
        [self.btnStartDateText setTitle:strOneDayPrevDate forState:UIControlStateNormal];
        //[self startServiceToGetPastStays];
        

    }
    
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
    if ([globals.isFromLastMinuteBookingPaymentSuccess isEqualToString:@"YES"]) {
        globals.isFromLastMinuteBookingPaymentSuccess = @"NO";
        _paymentView = [LastMinutePaymentSuccessPopUpView lastMinutePaymentSuccessPopUpView:self.confirmPaymentJsonDict];
        [self.view addSubview:_paymentView];
       
              }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startServiceToGetCurrentStay{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    LoginManager *loginManage = [[LoginManager alloc]init];
    NSDictionary *dict = [loginManage isUserLoggedIn];
    NSNumber *num = [dict valueForKey:@"UserId"];
    
    
    NSDictionary *dictParams = @{@"userid":num};
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8"
                     forHTTPHeaderField:@"Content-Type"];
    
    
    [manager GET:[NSString stringWithFormat:@"%@/api/StaysApi/GetCurrentStaysDetails?",kServerUrl] parameters:dictParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
       
        NSArray *arr = (NSArray *)responseObject;
        
        if (arr.count>0) {
            
            self.hotelList = [CurrentStayHotelList instanceFromArray:responseObject];
            [self.tblCurrentStay reloadData];

        }
        else{
            [self.hotelList.arrHotelList removeAllObjects];
        
        NSString *msg = nil;
        msg = @"No Current Stay";
        [[ICSingletonManager sharedManager] showAlertViewWithMsg:msg onController:self];
        }
        NSLog(@"sucess");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [[ICSingletonManager sharedManager] showAlertViewWithMsg:error.localizedDescription onController:self];

    }];

}

- (void)startServiceToGetPastStays{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    LoginManager *loginManage = [[LoginManager alloc]init];
    NSDictionary *dict = [loginManage isUserLoggedIn];
    NSNumber *num = [dict valueForKey:@"UserId"];
    
    if (self.btnEndDateText.currentTitle.length ==0 || self.btnStartDateText.currentTitle.length==0) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        [[ICSingletonManager sharedManager] showAlertViewWithMsg:@"Enter a valid date" onController:self];
        return;
    }
    
    NSString *fromDate = [[ICSingletonManager sharedManager] gettingDateStringToBeSendInPastStayApiFromStrDate:self.btnStartDateText.titleLabel.text];
    NSString *endDate = [[ICSingletonManager sharedManager] gettingDateStringToBeSendInPastStayApiFromStrDate:self.btnEndDateText.titleLabel.text];
    
    
    
    
    NSDictionary *dictParams = @{@"userid":num,@"fromdate":fromDate,@"todate":endDate};
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8"
                     forHTTPHeaderField:@"Content-Type"];
    
    
    [manager GET:[NSString stringWithFormat:@"%@/api/StaysApi/GetPastStaysDetails?",kServerUrl] parameters:dictParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        
        self.arrContainingData = (NSArray *)responseObject;
        
        if (self.arrContainingData.count>0) {
            self.hotelList = [CurrentStayHotelList instanceFromArray:responseObject];
            [self.tblCurrentStay reloadData];
        }
        else
        {
            [self.hotelList.arrHotelList removeAllObjects];
            [self.tblCurrentStay reloadData];
            NSString *msg = nil;
//            if ([self.lblStayHeader.text isEqualToString:@"Current Stay"]) {
//                msg = @"No Curret Stay";
//            }
//            else
           // {
                msg = @"No past stay between selected dates";
            //}
            [[ICSingletonManager sharedManager] showAlertViewWithMsg:msg onController:self];
        }
        
        
        NSLog(@"sucess");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [[ICSingletonManager sharedManager] showAlertViewWithMsg:error.localizedDescription onController:self];

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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   return self.hotelList.arrHotelList.count;
      //count number of row from counting array hear cataGorry is An Array
    
    //return ;
    
    //return 5;
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CurrentStayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CurrentStayCell"];
    CurrentStayHotelData *currentStayData = [self.hotelList.arrHotelList objectAtIndex:indexPath.row];
    [cell settingHotelData:currentStayData];
//    cell.btnFeedBackReceived.layer.cornerRadius = 10;
//    cell.btnFeedBackReceived.clipsToBounds = YES;

    cell.m_delegate =self;
    cell.dictionary = nil;
    cell.dictionary = [self.arrContainingData objectAtIndex:indexPath.row];
    
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 280;
}
- (IBAction)btnBackTapped:(id)sender {
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
     [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
//    if (globals.isFromMenu)
//    {
//        [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
//    }
//    else
//    {
//        if (self.comingFromMapScreen)
//        {
//            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//            
//            
//           HomeScreenController *vcHomeScreen = [storyboard instantiateViewControllerWithIdentifier:@"HomeScreenController"];
//            SideMenuController *vcSideMenu =     [storyboard instantiateViewControllerWithIdentifier:@"SideMenuController"];
//            
//            MMDrawerController *drawerController = [[MMDrawerController alloc]initWithCenterViewController:vcHomeScreen
//                                                                                  leftDrawerViewController:vcSideMenu];
//            [drawerController setRestorationIdentifier:@"MMDrawer"];
//            
//            
//            [drawerController setMaximumLeftDrawerWidth:SCREEN_WIDTH*2/3];
//            
//            [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
//            [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
//            drawerController.shouldStretchDrawer = NO;
//            
//            UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:drawerController];
//            [navController setNavigationBarHidden:YES];
//            self.view.window.rootViewController = navController;
//        }
//        
//        
//        else
//            [self.navigationController popViewControllerAnimated:YES];
//    }
    
   
}


- (IBAction)btnSearchPastStayTapped:(id)sender {
    
    
    [self.ViewPicker setHidden:YES];
    
    NSDate *startDate = [[ICSingletonManager sharedManager]gettingDateFromString:self.btnStartDateText.titleLabel.text];
    NSDate *endDate   = [[ICSingletonManager sharedManager]gettingDateFromString:self.btnEndDateText.titleLabel.text];
    
    if([startDate compare: endDate] == NSOrderedDescending) // if start is later in time than end
    {
        // do something
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Start date should be greater than end date" onController:self ];
        return;
    }
    
    [self startServiceToGetPastStays];
}


- (IBAction)btnStartDateTapped:(id)sender {
    self.btnActive = (UIButton *)sender;
    [self.ViewPicker setHidden:NO];
}

- (IBAction)btnEndDateTapped:(id)sender {
    self.btnActive = (UIButton *)sender;
    [self.ViewPicker setHidden:NO];
}

- (IBAction)btnDonePickerTapped:(id)sender {
    
    self.btnActive = nil;
    [self.ViewPicker setHidden:YES];
}

- (IBAction)btnCancelPickerTapped:(id)sender {
    [self.btnActive setTitle:@"" forState:UIControlStateNormal];
    self.btnActive = nil;
    [self.ViewPicker setHidden:YES];
}

- (IBAction)pickerValueChanged:(id)sender {
    UIDatePicker *datePicker = (UIDatePicker *)sender;
    NSString *str = [self gettingFormattedDateFromDate:datePicker.date];
    [self.btnActive setTitle:str forState:UIControlStateNormal];
}

- (NSString *)gettingFormattedDateFromDate:(NSDate *)date{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    dateFormat.dateStyle=NSDateFormatterMediumStyle;
    [dateFormat setDateFormat:@"dd MMM yyyy"];
    NSString *str=[NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:date]];
    return str;
}

#pragma mark - CurrentStayCellDelegate Method
-(void)switchToShareExperienceScreenWithDictionary:(NSDictionary *)diction{
//    NSDictionary *dict = [self dictionaryWithPropertiesOfObject: data];
//    NSLog(@"dict = %@",dict);
    
    
    ShareExperienceScreen *shareScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"ShareExperienceScreen"];
    
    if ([[diction valueForKey:@"FeedBackStatus"] intValue]  ==1) {
        
        shareScreen.ifFromfeedBack = YES;
    }
    else {
        shareScreen.ifFromfeedBack = NO;
    }
    
    shareScreen.dictionaryCoupon = diction;// [dict valueForKey:@"CouponCode"];
    [self.navigationController pushViewController:shareScreen animated:YES];

}



////Add this utility method in your class.
//- (NSDictionary *) dictionaryWithPropertiesOfObject:(id)obj
//{
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    
//    unsigned count;
//    objc_property_t *properties = class_copyPropertyList([obj class], &count);
//    
//    for (int i = 0; i < count; i++) {
//        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
//        [dict setObject:[obj valueForKey:key] forKey:key];
//    }
//    
//    free(properties);
//    
//    return [NSDictionary dictionaryWithDictionary:dict];
//}

@end
