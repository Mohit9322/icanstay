//
//  CreateWishlistScreen.m
//  ICanStay
//
//  Created by Namit Aggarwal on 26/02/16.
//  Copyright (c) 2016 Harry Patel (Hitaishin). All rights reserved.
//

#import "CreateWishlistScreen.h"
#import "AFNetworking.h"
#import "NSDictionary+JsonString.h"
#import "MBProgressHud.h"
#import "LoginManager.h"
#import "CreateWishlistTableViewCell.h"
#import "BuyCouponViewController.h"
#import "NSDictionary+JsonString.h"
#import <QuartzCore/QuartzCore.h>
#import "MyWishlistViewController.h"
#import "NotificationScreen.h"
#import "DashboardScreen.h"

#define kCoupon                         0
#define kDestination                    1
#define kWishType                       2
#define kFamilyStay                     3
#define kYear                           4
#define kRooms                          5
#define kMonths                         6
#define kDate                           7
#define kSpecialDay                     8
#define kArea                           9
#define kPreferredDestination           10

#define kSaveCityAlertView    103

@interface CreateWishlistScreen ()<UIAlertViewDelegate>
{
    NSMutableArray *mArrayYears,*mArrayMonths,*mArraydate,*mArrayWeek;
    NSMutableArray *mArraySelectedCoupon;
    NSString *selectedSpecialDateId;
    BOOL isFamilyStayMessageClicked,isNotifyMeClicked,isNotEnoughCouponCount;
}

@property (strong, nonatomic) IBOutlet UIButton *addtoWListBtn;
//outlets
@property (weak, nonatomic) IBOutlet UIView *viewBottom;
@property (weak, nonatomic) IBOutlet UITextField *preferredDestination;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *preferredDestinationView;
@property (weak, nonatomic) IBOutlet UITextField *areaName;
@property (weak, nonatomic) IBOutlet UITableView *couponListTableView;
@property (weak, nonatomic) IBOutlet UITextField *selectCoupon;
@property (weak, nonatomic) IBOutlet UITextField *destination;
@property (weak, nonatomic) IBOutlet UITextField *familyStay;
@property (weak, nonatomic) IBOutlet UITextField *roomsCount;
@property (weak, nonatomic) IBOutlet UITextField *wishType;
@property (weak, nonatomic) IBOutlet UITextField *year;
@property (weak, nonatomic) IBOutlet UILabel *yearTitle;
@property (weak, nonatomic) IBOutlet UITextField *month;
@property (weak, nonatomic) IBOutlet UITextField *dateWeek;
@property (weak, nonatomic) IBOutlet UIView *monthView;
@property (weak, nonatomic) IBOutlet UILabel *dateWeekTitle;
@property (weak, nonatomic) IBOutlet UIView *dateWeekView;
@property (weak, nonatomic) IBOutlet UIView *roomsView;
@property (weak, nonatomic) IBOutlet UIView *familyStayView;
@property (weak, nonatomic) IBOutlet UIButton *familStayMessageButton;
@property (weak, nonatomic) IBOutlet UIButton *addToWishlistButton;
@property (weak, nonatomic) IBOutlet UIView *notificationView;
@property (weak, nonatomic) IBOutlet UILabel *selectFamilyStayHeader;
@property (weak, nonatomic) IBOutlet UIButton *isNotifyButton;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UIButton *addToWishlistNotifyViewButton;
@property (weak, nonatomic) IBOutlet UIView *notifySubView;

@property (nonatomic)NSNumber *numCityId;

- (IBAction)btnBackTapped:(id)sender;
- (IBAction)familStayMessageTap:(id)sender;
- (IBAction)addToWishlistTap:(id)sender;
- (IBAction)saveCityTap:(id)sender;
- (IBAction)isNotifyTap:(id)sender;
- (IBAction)addToWishListNotifyTap:(id)sender;

@end

@implementation CreateWishlistScreen

- (void)viewDidLoad {
//    self.addToWishlistButton.layer.cornerRadius = 10;
//    self.addToWishlistButton.clipsToBounds = YES;
    [super viewDidLoad];
     DLog(@"DEBUG-VC");
    // Do any additional setup after loading the view.
    NSLog(@"%@",self.dictionaryCouponList);
    [[ICSingletonManager sharedManager]addBottomMenuToViewController:self onView:self.viewBottom];
    selectedSpecialDateId = @"";
    self.arrayFamilyStayList = @[@"YES",@"NO"];
    self.arrayRoomsList = @[@"1",@"2",@"3",@"4"];
    self.arrayWishTypeList = @[@"Date",@"Week",@"Month",@"Special Date"];
    self.arrayMonthList = @[@"January", @"February", @"March", @"April", @"May", @"June", @"July", @"August", @"September", @"October", @"November", @"December"];
    [self.wishType setEnabled:NO];
    if (self.isFromEdit) {
        
        [self.wishType setEnabled:YES];
//        [self.year setEnabled:NO];
//        [self.month setEnabled:NO];
//        [self.dateWeek setEnabled:NO];
    }
    
    [self.isNotifyButton setImage:[UIImage imageNamed:@"checkbox_selected"] forState:UIControlStateNormal];
    isNotifyMeClicked = true;

    self.notificationView.layer.borderWidth = 0.7f;
    self.notificationView.layer.borderColor = [[UIColor blackColor] CGColor];
    [self getCouponList];
    [self getPreferredLocation:@"true"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:true];
    if (self.isFromEdit) {
       // [self.menuButton setTitle:@"Back" forState:UIControlStateNormal];
    }
    else
    {
        //[self.menuButton setTitle:@"Menu" forState:UIControlStateNormal];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    if (self.vouchercodeFromCreateWishlist) {
        _selectCoupon.text = self.vouchercodeFromCreateWishlist;
        
    }
    
    
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

- (IBAction)btnBackTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)familStayMessageTap:(id)sender
{
    if (!isFamilyStayMessageClicked)
    {
        [self.familStayMessageButton setImage:[UIImage imageNamed:@"checkbox_selected"] forState:UIControlStateNormal];
        isFamilyStayMessageClicked = true;
    }
    else
    {
        [self.familStayMessageButton setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
        isFamilyStayMessageClicked = false;
    }
}

- (IBAction)addToWishlistTap:(id)sender
{
    if (![self.roomsCount.text isEqualToString:@""]) {
        if ([self.roomsCount.text integerValue]==1)
        {
            [self.familyStay setText:@"NO"];
        }
        else
        {
            [self.familyStay setText:@"YES"];
        }
    }
//    NSLog(@"%@",self.familyStay.text);
//    NSLog(@"%@",self.roomsCount.text);
    
    
    if ([self.destination.text isEqualToString:@""])
    {
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Please select preferred destination!" onController:self];
    }
    else if ([self.familyStay.text isEqualToString:@""])
    {
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Please select stay!" onController:self];
    }
    else if ([self.roomsCount.text isEqualToString:@""])
    {
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Please select number of room!" onController:self];
    }
    else if ([self.wishType.text isEqualToString:@""])
    {
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Please select wish type!" onController:self];
    }
    else if ([self.wishType.text isEqualToString:@"Date"])
    {
        if ([self.year.text isEqualToString:@""])
        {
            [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Please select year!" onController:self];
        }
        else if ([self.month.text isEqualToString:@""])
        {
            [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Please select month!" onController:self];
        }
        else if ([self.dateWeek.text isEqualToString:@""])
        {
            [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Please select date!" onController:self];
        }
        else if ([self.familyStay.text isEqualToString:@"YES"])
        {
            if ([self.roomsCount.text isEqualToString:@""])
            {
                [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Please select number of rooms!" onController:self];
            }
            else if (!isFamilyStayMessageClicked)
            {
                [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Please accept terms of Stay!" onController:self];
            }
            else
            {
                if (self.arrayCouponList.count-1 < [self.roomsCount.text intValue])
                {
                    self.selectFamilyStayHeader.text = [NSString stringWithFormat:@"Select Voucher(s) (%@)",self.roomsCount.text] ;
                    [self.scrollView setContentOffset:CGPointZero animated:YES];
                    [self.scrollView setScrollEnabled:NO];
                    [self.notificationView setHidden:NO];
                    [self.blackTransparentView setHidden:false];
                    [self.notifySubView setHidden:NO];
                    isNotEnoughCouponCount = true;
                    [self.addToWishlistNotifyViewButton setTitle:@"Buy Voucher(s)" forState:UIControlStateNormal];

//                    self.addToWishlistNotifyViewButton.titleLabel.text = @"BUY Voucher(S)";
                }
                else
                {
                    mArraySelectedCoupon = [[NSMutableArray alloc]init];
                    [mArraySelectedCoupon addObject:[self.selectedCouponList objectForKey:@"CouponCode"]];
                    self.selectFamilyStayHeader.text = [NSString stringWithFormat:@"Select Voucher(s) (%@)",self.roomsCount.text] ;
                    [self.scrollView setContentOffset:CGPointZero animated:YES];
                    [self.scrollView setScrollEnabled:NO];
                    [self.couponListTableView reloadData];
                    [self.notificationView setHidden:NO];
                    [self.blackTransparentView setHidden:false];
                    [self.notifySubView setHidden:YES];
                    isNotEnoughCouponCount = false;
                    [self.addToWishlistNotifyViewButton setTitle:@"Add To Wishlist" forState:UIControlStateNormal];

//                    self.addToWishlistNotifyViewButton.titleLabel.text = @"ADD TO WISHLIST";
                }
            }
        }
        else
        {
            if (self.arrayWishList.count <5)
            {
                if (self.isFromEdit) {
                    [self postDataToEditWishlist];

                }
                else
                [self postDataToCreateWishlist];
                
            }
            else
            {
                [[ICSingletonManager sharedManager]showAlertViewWithMsg:[NSString stringWithFormat:@"Wishes for one Voucher are limited to Five Only, Please Buy More Voucher to add More Wishes."] onController:self];
            }
        }
    }
    else if ([self.wishType.text isEqualToString:@"Week"])
    {
        if ([self.year.text isEqualToString:@""])
        {
            [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Please select year!" onController:self];
        }
        else if ([self.month.text isEqualToString:@""])
        {
            [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Please select month!" onController:self];
        }
        else if ([self.dateWeek.text isEqualToString:@""])
        {
            [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Please select week!" onController:self];
        }
        else if ([self.familyStay.text isEqualToString:@"YES"])
        {
            if ([self.roomsCount.text isEqualToString:@""])
            {
                [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Please select number of rooms!" onController:self];
            }
            else if (!isFamilyStayMessageClicked)
            {
                [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Please accept terms of Stay!" onController:self];
            }
            else
            {
                if (self.arrayCouponList.count-1 < [self.roomsCount.text intValue])
                {
                    self.selectFamilyStayHeader.text = [NSString stringWithFormat:@"Select Voucher(s) (%@)",self.roomsCount.text] ;
                    [self.scrollView setContentOffset:CGPointZero animated:YES];
                    [self.scrollView setScrollEnabled:NO];
                    [self.notificationView setHidden:NO];
                    [self.blackTransparentView setHidden:false];
                    [self.notifySubView setHidden:NO];
                    isNotEnoughCouponCount = true;
                    [self.addToWishlistNotifyViewButton setTitle:@"Buy Voucher(s)" forState:UIControlStateNormal];
//                    self.addToWishlistNotifyViewButton.titleLabel.text = @"BUY Voucher(S)";
                    
                }
                else
                {
                    mArraySelectedCoupon = [[NSMutableArray alloc]init];
                    [mArraySelectedCoupon addObject:[self.selectedCouponList objectForKey:@"CouponCode"]];
                    self.selectFamilyStayHeader.text = [NSString stringWithFormat:@"Select Voucher(s) (%@)",self.roomsCount.text] ;
                    [self.scrollView setContentOffset:CGPointZero animated:YES];
                    [self.scrollView setScrollEnabled:NO];
                    [self.couponListTableView reloadData];
                    [self.notificationView setHidden:NO];
                    [self.blackTransparentView setHidden:false];
                    [self.notifySubView setHidden:YES];
                    isNotEnoughCouponCount = false;
                    [self.addToWishlistNotifyViewButton setTitle:@"Add To Wishlist" forState:UIControlStateNormal];

//                    self.addToWishlistNotifyViewButton.titleLabel.text = @"ADD TO WISHLIST";
                }
            }
        }
        else
        {
            if (self.arrayWishList.count <5)
            {
                if (self.isFromEdit) {
                    [self postDataToEditWishlist];
                    
                }
                else
                [self postDataToCreateWishlist];
            }
            else
            {
                [[ICSingletonManager sharedManager]showAlertViewWithMsg:[NSString stringWithFormat:@"Wishes for one Voucher are limited to Five Only, Please Buy More Voucher to add More Wishes."] onController:self];
            }
        }
    }
    else if ([self.wishType.text isEqualToString:@"Month"])
    {
        if ([self.year.text isEqualToString:@""])
        {
            [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Please select year!" onController:self];
        }
        else if ([self.month.text isEqualToString:@""])
        {
            [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Please select month!" onController:self];
        }
        else if ([self.familyStay.text isEqualToString:@"YES"])
        {
            if ([self.roomsCount.text isEqualToString:@""])
            {
                [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Please select number of rooms!" onController:self];
            }
            else if (!isFamilyStayMessageClicked)
            {
                [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Please accept terms of Stay!" onController:self];
            }
            else
            {
                if (self.arrayCouponList.count-1 < [self.roomsCount.text intValue])
                {
                    self.selectFamilyStayHeader.text = [NSString stringWithFormat:@"Select Voucher(s) (%@)",self.roomsCount.text] ;
                    [self.scrollView setContentOffset:CGPointZero animated:YES];
                    [self.scrollView setScrollEnabled:NO];
                    [self.notificationView setHidden:NO];
                    [self.blackTransparentView setHidden:false];
                    [self.notifySubView setHidden:NO];
                    isNotEnoughCouponCount = true;
                    [self.addToWishlistNotifyViewButton setTitle:@"Buy Voucher(s)" forState:UIControlStateNormal];

//                    self.addToWishlistNotifyViewButton.titleLabel.text = @"BUY Voucher(S)";
                    
                }
                else
                {
                    mArraySelectedCoupon = [[NSMutableArray alloc]init];
                    [mArraySelectedCoupon addObject:[self.selectedCouponList objectForKey:@"CouponCode"]];
                    self.selectFamilyStayHeader.text = [NSString stringWithFormat:@"Select Voucher(s) (%@)",self.roomsCount.text] ;
                    [self.scrollView setContentOffset:CGPointZero animated:YES];
                    [self.scrollView setScrollEnabled:NO];
                    [self.couponListTableView reloadData];
                    [self.notificationView setHidden:NO];
                    [self.blackTransparentView setHidden:false];
                    [self.notifySubView setHidden:YES];
                    isNotEnoughCouponCount = false;
                    [self.addToWishlistNotifyViewButton setTitle:@"Add To Wishlist" forState:UIControlStateNormal];

//                    self.addToWishlistNotifyViewButton.titleLabel.text = @"ADD TO WISHLIST";
                }
            }
        }
        else
        {
            if (self.arrayWishList.count <5)
            {
                if (self.isFromEdit) {
                    [self postDataToEditWishlist];
                    
                }
                else
                [self postDataToCreateWishlist];
            }
            else
            {
                [[ICSingletonManager sharedManager]showAlertViewWithMsg:[NSString stringWithFormat:@"Wishes for one Voucher are limited to Five Only, Please Buy More Voucher to add More Wishes."] onController:self];
            }
        }
    }
    else if ([self.wishType.text isEqualToString:@"Special Date"])
    {
        if ([self.year.text isEqualToString:@""]){
            [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Please select Secial Day!" onController:self];
        }
        else if ([self.familyStay.text isEqualToString:@"YES"])
        {
            if ([self.roomsCount.text isEqualToString:@""])
            {
                [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Please select number of rooms!" onController:self];
            }
            else if (!isFamilyStayMessageClicked)
            {
                [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Please accept terms of Stay!" onController:self];
            }
            else
            {
                if (self.arrayCouponList.count-1 < [self.roomsCount.text intValue])
                {
                    self.selectFamilyStayHeader.text = [NSString stringWithFormat:@"Select Voucher(s) (%@)",self.roomsCount.text] ;
                    [self.scrollView setContentOffset:CGPointZero animated:YES];
                    [self.scrollView setScrollEnabled:NO];
                    [self.notificationView setHidden:NO];
                    [self.blackTransparentView setHidden:false];
                    [self.notifySubView setHidden:NO];
                    isNotEnoughCouponCount = true;
                    [self.addToWishlistNotifyViewButton setTitle:@"Buy Voucher(s)" forState:UIControlStateNormal];

//                    self.addToWishlistNotifyViewButton.titleLabel.text = @"BUY VOUCHER(S)";

                }
                else
                {
                    mArraySelectedCoupon = [[NSMutableArray alloc]init];
                    [mArraySelectedCoupon addObject:[self.selectedCouponList objectForKey:@"CouponCode"]];
                    self.selectFamilyStayHeader.text = [NSString stringWithFormat:@"Select Voucher(s) (%@)",self.roomsCount.text] ;
                    [self.scrollView setContentOffset:CGPointZero animated:YES];
                    [self.scrollView setScrollEnabled:NO];
                    [self.couponListTableView reloadData];
                    [self.notificationView setHidden:NO];
                    [self.blackTransparentView setHidden:false];
                    [self.notifySubView setHidden:YES];
                    isNotEnoughCouponCount = false;
                    [self.addToWishlistNotifyViewButton setTitle:@"Add To Wishlist" forState:UIControlStateNormal];

//                    self.addToWishlistNotifyViewButton.titleLabel.text = @"ADD TO WISHLIST";
                }
            }
        }
        else
        {
            if (self.arrayWishList.count <5)
            {
                if (self.isFromEdit) {
                    [self postDataToEditWishlist];
                    
                }
                else
                [self postDataToCreateWishlist];
            }
            else
            {
                [[ICSingletonManager sharedManager]showAlertViewWithMsg:[NSString stringWithFormat:@"Wishes for one Voucher are limited to Five Only, Please Buy More Voucher to add More Wishes."] onController:self];
            }
        }
    }
}

- (IBAction)saveCityTap:(id)sender
{
    if (self.preferredDestination.text.length) {
        [self startServiceToSaveCity];
    }
    else{
        [[ICSingletonManager sharedManager] showAlertViewWithMsg:@"Please enter preferred city" onController:self];
    }
    
    //tempByNamit
/*    [self.scrollView setScrollEnabled:YES];
    [self.areaName setEnabled:NO];
    self.destination.text = @"";
    [self.preferredDestinationView setHidden:YES];
  */
}


-(void)startServiceToSaveCity{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    LoginManager *loginManage = [[LoginManager alloc]init];
    NSDictionary *dict = [loginManage isUserLoggedIn];
    NSNumber *num = [dict valueForKey:@"UserId"];
    
    NSDate *todayDate = [NSDate date]; // get today date
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; // here we create NSDateFormatter object for change the Format of date..
    [dateFormatter setDateFormat:@"dd-MM-yyyy"]; //Here we can set the format which we need
    NSString *convertedDateString = [dateFormatter stringFromDate:todayDate];// here convert date in
//    NSString NSLog("Today formatted date is %@",convertedDateString);
    
    NSDictionary *dictionary = @{@"UserId":num,@"CityID":self.numCityId,@"CreatedDate":convertedDateString};

    NSString *strJson = [dictionary jsonStringWithPrettyPrint:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    
    
    [manager.requestSerializer setValue:@"application/json; charset=utf-8"
                     forHTTPHeaderField:@"Content-Type"];
    
    
    [manager POST:[NSString stringWithFormat:@"%@/api/Wishlist/SaveCityRequest",kServerUrl] parameters:strJson success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        
        
        NSLog(@"sucess");
        NSString *msg= [responseObject valueForKey:@"errorMessage"];
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:msg message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag = kSaveCityAlertView;
        alert.delegate = self;
        [alert show];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [[ICSingletonManager sharedManager] showAlertViewWithMsg:error.localizedDescription onController:self];
        
    }];

}

#pragma mark - UIAlertViewDelegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == kSaveCityAlertView) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (IBAction)isNotifyTap:(id)sender
{
    if (!isNotifyMeClicked)
    {
        [self.isNotifyButton setImage:[UIImage imageNamed:@"checkbox_selected"] forState:UIControlStateNormal];
        isNotifyMeClicked = true;
    }
    else
    {
        [self.isNotifyButton setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
        isNotifyMeClicked = false;
    }
}

- (IBAction)addToWishListNotifyTap:(id)sender
{
    if (isNotEnoughCouponCount)
    {
        ICSingletonManager *globals = [ICSingletonManager sharedManager];
        globals.isFromMenuForBuyVoucher = false;
        BuyCouponViewController *buyCoupon =[self.storyboard instantiateViewControllerWithIdentifier:@"BuyCouponViewController"];
        [self.navigationController pushViewController:buyCoupon animated:YES];
    }
    else
    {
        if (mArraySelectedCoupon.count == [self.roomsCount.text intValue])
        {
            if (self.arrayWishList.count <5)
            {
                [self postDataToCreateWishlist];
            }
            else
            {
                [[ICSingletonManager sharedManager]showAlertViewWithMsg:[NSString stringWithFormat:@"Wishes for one Voucher are limited to Five Only, Please Buy More Voucher to add More Wishes."] onController:self];
            }
        }
        else
        {
            [[ICSingletonManager sharedManager]showAlertViewWithMsg:[NSString stringWithFormat:@"Please select %@ Voucher(s)",self.roomsCount.text] onController:self];
        }
    }
    
}

- (IBAction)cellButtonTapped:(UIButton*)sender
{
    CreateWishlistTableViewCell *cell = [self.couponListTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
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
        if (mArraySelectedCoupon.count < [self.roomsCount.text intValue])
        {
            [mArraySelectedCoupon addObject:[[self.arrayCouponList objectAtIndex:sender.tag+1] valueForKey:@"CouponCode"]];
        }
        else
        {
            [[ICSingletonManager sharedManager]showAlertViewWithMsg:[NSString stringWithFormat:@"Please select %@ Voucher(s) only",self.roomsCount.text] onController:self];
        }
    }
    [self.couponListTableView reloadData];
}

#pragma mark - UITableview Data source & Delegate

#pragma mark - TableView Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayCouponList.count-1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier1 = @"Cell";
    //Storing dictionary value from array at index
    NSDictionary *couponDictionary = [self.arrayCouponList objectAtIndex:indexPath.row+1];
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


#pragma mark- Webservice Methods

//service to get coupons
-(void)getCouponList
{
    //http://192.168.2.5:8585/api/Wishlist/GetUserCouponsList?userid=31458
    
    LoginManager *loginManage = [[LoginManager alloc]init];
    NSDictionary *dict = [loginManage isUserLoggedIn];
    NSNumber *num = [dict valueForKey:@"UserId"];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
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
        self.arrayCouponList = responseObject;

        if (self.isFromEdit) {

            for (int i=0; i<self.arrayCouponList.count; i++)
            {
                if ([[[self.arrayCouponList objectAtIndex:i] valueForKey:@"CouponCode"]isEqualToString:[self.dictionaryCouponList objectForKey:@"CouponCode"]])
                {
                    NSDictionary *dict =  [self.arrayCouponList  objectAtIndex:i];  //tempbyNamit
                    
                    self.selectCoupon.text = [dict valueForKey:@"CouponCodeDate"];
                    NSNumber *num = [self.dictionaryCouponList valueForKey:@"WishlistType"];
                    
                    NSString *str=[NSString stringWithFormat:@"%@",self.dictionaryCouponList];
                    NSLog(@"%@",str);
                                                               
                    [self.wishType setText: [self settingWishlistType:[num intValue]]];
                    [self.year setText:[[self.dictionaryCouponList valueForKey:@"Prf_Year"] stringValue]];
                    NSNumber *numMonth = [self.dictionaryCouponList valueForKey:@"Prf_Month"];
                    NSString *month = [self.arrayMonthList objectAtIndex:([numMonth intValue] -1)];
                    [self.month setText:month];
                    if ([[[self.dictionaryCouponList valueForKey:@"Prf_Day"] stringValue] isEqualToString:@"0"]) {
                        [self.dateWeekView setHidden:YES];
                    }
                    else
                    {
                        [self.dateWeekView setHidden:NO];
                        [self.dateWeek setText:[[self.dictionaryCouponList valueForKey:@"Prf_Day"] stringValue]];
                    }
                    
                    self.selectedCouponList = [self.arrayCouponList objectAtIndex:i];
                }
            }
           
            self.destination.text = [self.dictionaryCouponList objectForKey:@"City_Name"];
            [self getAreaName:[self.dictionaryCouponList objectForKey:@"City_Id"]];
            
            if ([[self.dictionaryCouponList objectForKey:@"FamilyStay"] isEqualToString:@"N"])
            {
                self.familyStay.text = @"NO";
                [self.familStayMessageButton setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
                self.roomsCount.text = [[self.dictionaryCouponList objectForKey:@"RoomCount"] stringValue];

                isFamilyStayMessageClicked = false;
                //[self.roomsView setHidden:YES];
                [self.roomsView setHidden:NO];
                [self.familyStayView setHidden:NO];
                [self.roomsCount setEnabled:YES];
            }
            else
            {
                self.familyStay.text = @"YES";
                self.roomsCount.text = [[self.dictionaryCouponList objectForKey:@"RoomCount"] stringValue];
                [self.roomsCount setEnabled:YES];
//                [self.roomsView setHidden:NO];
                [self.roomsView setHidden:NO];
                [self.familyStayView setHidden:NO];
            }
           // self.isFromEdit = false;
        }
        else
        {
            [self.destination setEnabled:NO];
            [self.familyStay setEnabled:NO];
            [self.wishType setEnabled:NO];
            [self.year setEnabled:NO];
            [self.month setEnabled:NO];
            [self.dateWeek setEnabled:NO];
            [self.roomsCount setEnabled:NO];
            [self.addToWishlistButton setEnabled:NO];
            [self.areaName setEnabled:NO];
            self.selectCoupon.text = [[self.arrayCouponList valueForKey:@"CouponCodeDate"] objectAtIndex:0];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:error.localizedDescription onController:self];
    //    [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:true];
    self.isFromEdit = NO;
}

-(NSString *)settingWishlistType:(int)num{
    
    NSString *wishlistType = nil;    
    
    if (num == 1) {
        wishlistType = @"Month";
        [self.dateWeekView setHidden:YES];

    }
    else if (num == 2){
        wishlistType = @"Week";
//        self.dateWeekTitle.text = @"Week";
        [self.dateWeekView setHidden:YES];

    }
    else if (num == 3){
        wishlistType = @"Date";
        self.dateWeekTitle.text = @"Date";
        [self.dateWeekView setHidden:NO];
    }
    else{
        wishlistType = @"Special Day(s)";
        [self getSpecialDayList];
        self.yearTitle.text = @"Special Day(s)";
        [self.monthView setHidden:YES];
        [self.dateWeekView setHidden:YES];

    }
    
    return wishlistType;
}
-(void)preSelectingCouponType{
    [self.destination setEnabled:YES];
    [self.familyStay setEnabled:YES];
    [self.wishType setEnabled:YES];
    [self.year setEnabled:NO];
    [self.month setEnabled:NO];
    [self.dateWeek setEnabled:NO];
    [self.roomsCount setEnabled:NO];
    [self.addToWishlistButton setEnabled:YES];
    
    [self.familStayMessageButton setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
    isFamilyStayMessageClicked = false;
  //  [self.roomsView setHidden:YES];
  //  [self.familyStayView setHidden:YES];
    
    
    
    self.wishType.text = @"";
   // self.roomsCount.text = @"";
   // self.familyStay.text = @"NO";
    self.year.text = @"";
    self.month.text = @"";
    self.dateWeek.text = @"";
    //self.selectedCouponList = [self.arrayCouponList objectAtIndex:[self.pickerView selectedRowInComponent:0]];
    [self getWishlistByCoupon];


}

//service to get preferred location
-(void)getWishlistByCoupon
{
    //http://dev.icanstay.businesstowork.com/api/Wishlist/GetAllWishlistDetails?userId=31458&couponCode=IC00027&familyStay=N&&endDate=2016-02-02&cityID=1
    
    //http://dev.icanstay.businesstowork.com/api/Wishlist/GetWishlistDetail
    //IsHotelMappedCity parameter
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *strParams = [NSString stringWithFormat:@"CouponCode=%@",[self.selectedCouponList objectForKey:@"CouponCode"]];
    
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
        //        NSString *status = [responseObject valueForKey:@"status"];
        //        NSString *msg = [responseObject valueForKey:@"errorMessage"];
        //        if ([status isEqualToString:@"SUCCESS"]) {
        //
        //        }
        //
        //        NSLog(@"sucess");
        //        [[ICSingletonManager sharedManager]showAlertViewWithMsg:msg onController:self];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        NSString *msg = [error description];
        
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:error.localizedDescription onController:self];
        //    [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
    
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
            [self.mArrayDestinationList addObject:dict];

        } else {
            self.arrayPreferredDestinationList = responseObject;
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

//service to get preferred location
-(void)getAreaName:(NSString*)cityID
{
    //http://192.168.2.5:8585/F18api/SearchHotelApi/GetAreaByCity?Cityid=1
    //IsHotelMappedCity parameter
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *strParams = [NSString stringWithFormat:@"Cityid=%@",cityID];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8"
                     forHTTPHeaderField:@"Content-Type"];
    
    [manager GET:[NSString stringWithFormat:@"%@/api/SearchHotelApi/GetAreaByCity?%@",kServerUrl,strParams] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        self.mArrayAreaNameList = [[NSMutableArray alloc]init];
        NSArray *temp = responseObject;
        if (temp.count > 0) {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
            [dict setValue:@"All" forKey:@"Text"];
            [self.mArrayAreaNameList addObject:dict];// insertObject:dict atIndex:0];
            for (int i=0; i<temp.count ; i++) {
                [self.mArrayAreaNameList addObject:[temp objectAtIndex:i]];
            }
            self.areaName.text = @"ALL";
            [self.areaName setEnabled:YES];
        } else {
            self.areaName.text = @"ALL";
            [self.areaName setEnabled:NO];
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
    NSString *day,*week,*yearString,*monthString,*specialDay,*familyStay,*roomC,*notify,*selectedArrayCouponList,*wishType;
    for (int i= 0; i < self.arrayMonthList.count; i++)
    {
        if ([self.month.text isEqualToString:[self.arrayMonthList objectAtIndex:i]])
        {
            monthString = [NSString stringWithFormat:@"%d",i+1];
        }
    }
    if ([self.wishType.text isEqualToString:@"Date"])
    {
        wishType = @"1";

        yearString =self.year.text;
        day = self.dateWeek.text;
        week = @"0";
        specialDay = @"0";
    }
    else if ([self.wishType.text isEqualToString:@"Week"])
    {
        wishType = @"2";

        yearString =self.year.text;
        day = @"0";
        week = self.dateWeek.text;
        specialDay = @"0";
    }
    else if ([self.wishType.text isEqualToString:@"Month"])
    {
        wishType = @"3";
        yearString =self.year.text;
        day = @"0";
        week = @"0";
        specialDay = @"0";
    }
    else if ([self.wishType.text isEqualToString:@"Special Date"])
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
    if ([self.familyStay.text isEqualToString:@"YES"])
    {
        familyStay = @"Y";
        roomC = self.roomsCount.text;
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
    else if ([self.familyStay.text isEqualToString:@"NO"])
    {
        familyStay = @"N";
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
    [dictPost setValue:[self.selectedCity objectForKey:@"CITY_ID"] forKey:@"CityID"];
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
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];

    [manager POST:[NSString stringWithFormat:@"%@/api/Wishlist/CreateWishlistMobile",kServerUrl] parameters:dictPost success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSLog(@"responseObject=%@",responseObject);
        
        NSString *status = [responseObject valueForKey:@"status"];
        NSString *msg = [responseObject valueForKey:@"errorMessage"];
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:msg message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];

        if ([status isEqualToString:@"SUCCESS"])
        {
            MyWishlistViewController *createWishList =[self.storyboard instantiateViewControllerWithIdentifier:@"MyWishlistViewController"];
            [self.navigationController pushViewController:createWishList animated:YES];

//            [self.navigationController popViewControllerAnimated:YES];
        }
        NSLog(@"sucess");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NSLog(@"failure");
        
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:error.localizedDescription onController:self];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];

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
    
    NSString *day,*week,*yearString,*monthString,*specialDay,*familyStay,*roomC,*notify,*selectedArrayCouponList,*wishType;
    for (int i= 0; i < self.arrayMonthList.count; i++)
    {
        if ([self.month.text isEqualToString:[self.arrayMonthList objectAtIndex:i]])
        {
            monthString = [NSString stringWithFormat:@"%d",i+1];
        }
    }
    wishType = self.wishType.text;
    if ([self.wishType.text isEqualToString:@"Date"])
    {
        yearString =self.year.text;
        day = self.dateWeek.text;
        week = @"0";
        specialDay = @"0";
        wishType = @"3";
    }
    else if ([self.wishType.text isEqualToString:@"Week"])
    {
        yearString =self.year.text;
        day = @"0";
        week = self.dateWeek.text;
        specialDay = @"0";
        wishType = @"2";
    }
    else if ([self.wishType.text isEqualToString:@"Month"])
    {
        yearString =self.year.text;
        day = @"0";
        week = @"0";
        specialDay = @"0";
        wishType = @"1";
    }
    else if ([self.wishType.text isEqualToString:@"Special Date"])
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
    
    if ([self.familyStay.text isEqualToString:@"YES"])
    {
        familyStay = @"Y";
        roomC = self.roomsCount.text;
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
    else if ([self.familyStay.text isEqualToString:@"NO"])
    {
        familyStay = @"N";
        roomC = @"1";
        notify = @"False";
        selectedArrayCouponList = @"";
    }
    
    NSMutableDictionary *dictPost=[NSMutableDictionary new];
    [dictPost setValue:[self.dictionaryCouponList objectForKey:@"Prf_Dest_id"] forKey:@"Prf_Dest_id"];
    [dictPost setValue:[self.dictionaryCouponList objectForKey:@"Wishlist_ID"] forKey:@"Wishlist_ID"];
//    [dictPost setValue:[self.dictionaryCouponList objectForKey:@"Prf_Seq"] forKey:@"Prf_Seq"];
    [dictPost setValue:[NSNumber numberWithInt:0] forKey:@"Prf_Seq"];

    [dictPost setValue:[self.selectedCouponList objectForKey:@"CouponCode"] forKey:@"CouponCode"];
    [dictPost setValue:[self.selectedCouponList objectForKey:@"CouponYear"] forKey:@"CouponYear"];
    [dictPost setValue:[self.selectedCouponList objectForKey:@"CouponMonth"] forKey:@"CouponMonth"];
    [dictPost setValue:[self.selectedCouponList objectForKey:@"CouponDay"] forKey:@"CouponDay"];
    [dictPost setValue:[self.selectedCity objectForKey:@"CITY_ID"] forKey:@"CityID"];
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
    
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    

    
    [manager POST:[NSString stringWithFormat:@"%@/api/Wishlist/CreateWishlistMobile",kServerUrl] parameters:dictPost success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        
        NSString *status = [responseObject valueForKey:@"status"];
        NSString *msg = [responseObject valueForKey:@"errorMessage"];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        [[ICSingletonManager sharedManager]showAlertViewWithMsg:msg onController:self];
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:msg message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        if ([status isEqualToString:@"SUCCESS"]) {
            
        [self.navigationController popViewControllerAnimated:YES];
        }
        
        NSLog(@"sucess");
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        NSString *msg = [error description];
        
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:error.localizedDescription onController:self];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
    
}



#pragma mark- Picker Actions

- (IBAction)cancelPicker:(id)sender
{
    [self.viewPicker setHidden:YES];
    [self.view endEditing:YES];
}

- (IBAction)donePicker:(id)sender
{
    //Code for setting the picker value on Done Tap
    if(selectPicker==kCoupon)
    {
        self.selectCoupon.text = [[self.arrayCouponList valueForKey:@"CouponCodeDate"] objectAtIndex:[self.pickerView selectedRowInComponent:0]];
        if ([self.selectCoupon.text isEqualToString:@"-All-"])
        {
            [self.destination setEnabled:NO];
            [self.familyStay setEnabled:NO];
            [self.wishType setEnabled:NO];
            [self.year setEnabled:NO];
            [self.month setEnabled:NO];
            [self.dateWeek setEnabled:NO];
            [self.roomsCount setEnabled:NO];
            [self.addToWishlistButton setEnabled:NO];
            [self.areaName setEnabled:NO];
            [self.familStayMessageButton setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
            isFamilyStayMessageClicked = false;
           // [self.roomsView setHidden:YES];
            [self.roomsView setHidden:NO];
            [self.familyStayView setHidden:YES];

        }
        else
        {
            [self.destination setEnabled:YES];
            [self.familyStay setEnabled:YES];
            [self.wishType setEnabled:YES];
            [self.year setEnabled:NO];
            [self.month setEnabled:NO];
            [self.dateWeek setEnabled:NO];
         //   [self.roomsCount setEnabled:NO];
             [self.roomsCount setEnabled:YES];
            [self.addToWishlistButton setEnabled:YES];
            
            [self.familStayMessageButton setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
            isFamilyStayMessageClicked = false;
          //  [self.roomsView setHidden:YES];
            [self.roomsView setHidden:NO];
            [self.familyStayView setHidden:NO];
        }
        self.wishType.text = @"";
        self.roomsCount.text = @"";
        self.familyStay.text = @"NO";
        self.year.text = @"";
        self.month.text = @"";
        self.dateWeek.text = @"";
        self.selectedCouponList = [self.arrayCouponList objectAtIndex:[self.pickerView selectedRowInComponent:0]];
        [self getWishlistByCoupon];
    }
    else if (selectPicker==kDestination)
    {
        self.destination.text = [[self.mArrayDestinationList valueForKey:@"CITY_NAME"] objectAtIndex:[self.pickerView selectedRowInComponent:0]];
        self.selectedCity = [self.mArrayDestinationList objectAtIndex:[self.pickerView selectedRowInComponent:0]];
        if ([[[self.mArrayDestinationList valueForKey:@"CITY_NAME"] objectAtIndex:[self.pickerView selectedRowInComponent:0]]isEqualToString:@"Preferred Destination not available?"])
        {
            [self getPreferredLocation:@"false"];
            self.preferredDestination.text = @"";
            [self.scrollView setScrollEnabled:NO];
            [self.preferredDestinationView setHidden:NO];

        }
        else
        {
            [self.scrollView setScrollEnabled:YES];
            [self.preferredDestinationView setHidden:YES];
            [self getAreaName:[[self.mArrayDestinationList valueForKey:@"CITY_ID"] objectAtIndex:[self.pickerView selectedRowInComponent:0]]];
        }
    }
    else if (selectPicker==kPreferredDestination)
    {
        self.preferredDestination.text = [[self.arrayPreferredDestinationList valueForKey:@"CITY_NAME"] objectAtIndex:[self.pickerView selectedRowInComponent:0]];
        
        
        
       self.numCityId =[[self.arrayPreferredDestinationList valueForKey:@"CITY_ID"] objectAtIndex:[self.pickerView selectedRowInComponent:0]];
        //fetch USerId
        //fetchdateformat
        //ApiHit for savecity
        
    }
    else if (selectPicker==kArea)
    {
        self.areaName.text = [[self.mArrayAreaNameList valueForKey:@"Text"] objectAtIndex:[self.pickerView selectedRowInComponent:0]];
    }
    else if (selectPicker==kFamilyStay)
    {
        self.familyStay.text = [self.arrayFamilyStayList objectAtIndex:[self.pickerView selectedRowInComponent:0]];
        if ([self.familyStay.text isEqualToString:@"NO"])
        {
            [self.familStayMessageButton setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
            isFamilyStayMessageClicked = false;
           // [self.roomsView setHidden:YES];
            [self.roomsView setHidden:NO];
            [self.familyStayView setHidden:YES];
            [self.roomsCount setEnabled:NO];

        }
        else if ([self.familyStay.text isEqualToString:@"YES"])
        {
            self.roomsCount.text = @"";
            [self.roomsCount setEnabled:YES];
            [self.roomsView setHidden:NO];
            [self.familyStayView setHidden:NO];
        }
    }
    else if (selectPicker==kWishType)
    {
        self.wishType.text = [self.arrayWishTypeList objectAtIndex:[self.pickerView selectedRowInComponent:0]];
        self.year.text = @"";
        self.month.text = @"";
        self.dateWeek.text = @"";
        self.yearTitle.text = @"Year";
        [self.monthView setHidden:NO];

        if ([self.wishType.text isEqualToString:@"Date"])
        {
            self.dateWeekTitle.text = @"Date";
            [self.dateWeekView setHidden:NO];
        }
        else if ([self.wishType.text isEqualToString:@"Week"])
        {
            self.dateWeekTitle.text = @"Week";
            [self.dateWeekView setHidden:NO];
        }
        else if ([self.wishType.text isEqualToString:@"Special Date"])
        {
            [self getSpecialDayList];
            self.yearTitle.text = @"Special Date";
            [self.monthView setHidden:YES];
            [self.dateWeekView setHidden:YES];
        }
        else
        {
            [self.dateWeekView setHidden:YES];
        }
        [self.year setEnabled:YES];
        [self.month setEnabled:NO];
        [self.dateWeek setEnabled:NO];
    }
    else if (selectPicker==kRooms)
    {
        self.roomsCount.text = [self.arrayRoomsList objectAtIndex:[self.pickerView selectedRowInComponent:0]];
    }
    else if (selectPicker==kYear)
    {
        self.month.text = @"";
        self.dateWeek.text = @"";
        [self.month setEnabled:YES];
        self.year.text = [mArrayYears objectAtIndex:[self.pickerView selectedRowInComponent:0]];
    }
    else if (selectPicker==kMonths)
    {
        self.dateWeek.text = @"";
        [self.dateWeek setEnabled:YES];
        self.month.text = [mArrayMonths objectAtIndex:[self.pickerView selectedRowInComponent:0]];
    }
    else if (selectPicker==kDate)
    {
        if ([self.wishType.text isEqualToString:@"Date"])
        {
            self.dateWeek.text = [mArraydate objectAtIndex:[self.pickerView selectedRowInComponent:0]];
        }
        else if ([self.wishType.text isEqualToString:@"Week"])
        {
            self.dateWeek.text = [mArrayWeek objectAtIndex:[self.pickerView selectedRowInComponent:0]];
        }
    }
    else if (selectPicker==kSpecialDay)
    {
       // self.dateWeek.text = @"";
        self.year.text = [NSString stringWithFormat:@"%@ - %@ (%@) - %@",[[self.arraySpecialDayList objectAtIndex:[self.pickerView selectedRowInComponent:0]] valueForKey:@"EventName"],[[self.arraySpecialDayList objectAtIndex:[self.pickerView selectedRowInComponent:0]] valueForKey:@"Name"],[[self.arraySpecialDayList objectAtIndex:[self.pickerView selectedRowInComponent:0]] valueForKey:@"Relation_Name"],[[self.arraySpecialDayList objectAtIndex:[self.pickerView selectedRowInComponent:0]] valueForKey:@"EventDate"]];
        selectedSpecialDateId = [[self.arraySpecialDayList objectAtIndex:[self.pickerView selectedRowInComponent:0]] valueForKey:@"$id"];
    }
    [self.view endEditing:YES];
    [self.viewPicker setHidden:YES];
}

- (IBAction)cancelButtonTapped:(id)sender {
    [self.scrollView setScrollEnabled:true];
    [self.notificationView setHidden:true];
    [self.blackTransparentView setHidden:true];
    [self.notifySubView setHidden:true];
}

#pragma mark Picker View Delegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}


-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    int count=0;
    
    if (selectPicker==kCoupon)
    {
        count = (int)[self.arrayCouponList count];
    }
    else if (selectPicker==kDestination)
    {
        count = (int)[self.mArrayDestinationList count];
    }
    else if (selectPicker==kPreferredDestination)
    {
        count = (int)[self.arrayPreferredDestinationList count];
    }
    else if (selectPicker==kArea)
    {
        count = (int)[self.mArrayAreaNameList count];
    }
    else if (selectPicker==kFamilyStay)
    {
        count = (int)[self.arrayFamilyStayList count];
    }
    else if (selectPicker==kWishType)
    {
        count = (int)[self.arrayWishTypeList count];
    }
    else if (selectPicker==kRooms)
    {
        count = (int)[self.arrayRoomsList count];
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
        if ([self.wishType.text isEqualToString:@"Date"])
        {
            count = (int)[mArraydate count];
        }
        else if ([self.wishType.text isEqualToString:@"Week"])
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
    // Fill the label text here
    if (selectPicker == kCoupon)
    {
        title=[[self.arrayCouponList objectAtIndex:row] valueForKey:@"CouponCodeDate"];
    }
    else if (selectPicker == kDestination)
    {
        title=[[self.mArrayDestinationList objectAtIndex:row] valueForKey:@"CITY_NAME"];
    }
    else if (selectPicker == kPreferredDestination)
    {
        title=[[self.arrayPreferredDestinationList objectAtIndex:row] valueForKey:@"CITY_NAME"];
    }
    else if (selectPicker == kArea)
    {
        title=[[self.mArrayAreaNameList objectAtIndex:row] valueForKey:@"Text"];
    }
    else if (selectPicker == kFamilyStay)
    {
        title=[self.arrayFamilyStayList objectAtIndex:row];
    }
    else if (selectPicker == kWishType)
    {
        title=[self.arrayWishTypeList objectAtIndex:row];
    }
    else if (selectPicker == kRooms)
    {
        title=[self.arrayRoomsList objectAtIndex:row];
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
        if ([self.wishType.text isEqualToString:@"Date"])
        {
            title=[mArraydate objectAtIndex:row];
        }
        else if ([self.wishType.text isEqualToString:@"Week"])
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

#pragma mark - TextField Delegate
//-(void)textFieldDidBeginEditing:(UITextField *)textField
//{
   

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.selectCoupon)
    {
        selectPicker = kCoupon;
        [self.pickerView reloadAllComponents];
        [self.viewPicker setHidden:NO];
        return NO;
    }
    else if (textField == self.destination)
    {
        selectPicker = kDestination;
        [self.pickerView reloadAllComponents];
        [self.viewPicker setHidden:NO];
        return NO;
    }
    else if (textField == self.preferredDestination)
    {
        selectPicker = kPreferredDestination;
        [self.pickerView reloadAllComponents];
        [self.viewPicker setHidden:NO];
        return NO;
    }
    else if (textField == self.familyStay)
    {
        selectPicker = kFamilyStay;
        [self.pickerView reloadAllComponents];
        [self.viewPicker setHidden:NO];
        return NO;
    }
    else if (textField == self.wishType)
    {
        selectPicker = kWishType;
        [self.pickerView reloadAllComponents];
        [self.viewPicker setHidden:NO];
        return NO;
    }
    else if (textField == self.roomsCount)
    {
        selectPicker = kRooms;
        [self.pickerView reloadAllComponents];
        [self.viewPicker setHidden:NO];
        return NO;
    }
    else if (textField == self.areaName)
    {
        selectPicker = kArea;
        [self.pickerView reloadAllComponents];
        [self.viewPicker setHidden:NO];
        return NO;
    }
    else if (textField == self.year)
    {
        if ([self.yearTitle.text isEqualToString:@"Year"])
        {
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
    else if (textField == self.month)
    {
        mArrayMonths = [[NSMutableArray alloc] init];

        NSDate *date = [NSDate date];
        NSCalendar *gregorian = [NSCalendar currentCalendar];
        NSDateComponents *dateComponents = [gregorian components:(NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear) fromDate:date];
        NSInteger startmonth = [dateComponents month];
        NSInteger startyear = [dateComponents year];
        if ([self.year.text isEqualToString:[NSString stringWithFormat:@"%ld",(long)startyear]])
        {
            for (NSInteger i=startmonth-1; i<12; i++)
            {
                [mArrayMonths addObject: [self.arrayMonthList objectAtIndex:i]];
            }
        }
        else if ([self.year.text isEqualToString:[self convertDateFormat:[self.selectedCouponList objectForKey:@"ExpiryDate"] sourceFormate:@"dd MMM yyyy" targetFormate:@"yyyy"]])
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
    else if (textField == self.dateWeek)
    {
        NSDate *currentdate = [NSDate date];
        NSCalendar *gregorian = [NSCalendar currentCalendar];
        
        NSDateComponents *dateComponents = [gregorian components:(NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear) fromDate:currentdate];
        
        NSRange days = [gregorian rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:currentdate];
        NSInteger daysInGivenMonth= days.length;
        
        NSInteger startDate = [dateComponents day];
        NSInteger startmonth = [dateComponents month];
        NSInteger startyear = [dateComponents year];
        if ([self.wishType.text isEqualToString:@"Date"])
        {
            mArraydate = [[NSMutableArray alloc] init];
            
            if ([self.year.text isEqualToString:[NSString stringWithFormat:@"%ld",(long)startyear]])
            {
                if ([self.month.text isEqualToString:[self.arrayMonthList objectAtIndex:startmonth-1]])
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
                        if ([[self.arrayMonthList objectAtIndex:i]isEqualToString:self.month.text])
                        {
                            
                            NSDateComponents *components1 = [[NSDateComponents alloc] init];
                            // Set your year and month here
                            [components1 setYear:startyear];
                            [components1 setMonth:i+1];
                            NSDate *date1 = [gregorian dateFromComponents:components1];
                            
                            NSRange days1 = [gregorian rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date1];
                            
                            NSInteger daysInGivenMonth1= days1.length;
                            for (NSInteger i=1; i<=daysInGivenMonth1; i++)
                            {
                                [mArraydate addObject:[NSString stringWithFormat:@"%ld",(long)i]];
                            }
                        }
                    }
                }
            }
            else if([self.year.text isEqualToString:[self convertDateFormat:[self.selectedCouponList objectForKey:@"ExpiryDate"] sourceFormate:@"dd MMM yyyy" targetFormate:@"yyyy"]])
            {
                NSDate *expirydate = [self nsdateFromString:[self.selectedCouponList objectForKey:@"ExpiryDate"] dateFormate:@"dd MMM yyyy"];
                NSDateComponents *dateComponents = [gregorian components:(NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear) fromDate:expirydate];
                
                NSInteger endDate = [dateComponents day];
                NSInteger endmonth = [dateComponents month];
                
                if ([self.month.text isEqualToString:[self.arrayMonthList objectAtIndex:endmonth-1]])
                {
                    for (NSInteger i=1; i<=endDate; i++)
                    {
                        [mArraydate addObject:[NSString stringWithFormat:@"%ld",(long)i]];
                    }
                }
                else
                {
                    for (int i = 0; i< self.arrayMonthList.count; i++) {
                        if ([[self.arrayMonthList objectAtIndex:i]isEqualToString:self.month.text])
                        {
                            
                            NSDateComponents *components1 = [[NSDateComponents alloc] init];
                            // Set your year and month here
                            [components1 setYear:startyear];
                            [components1 setMonth:i+1];
                            NSDate *date1 = [gregorian dateFromComponents:components1];
                            
                            NSRange days1 = [gregorian rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date1];
                            
                            NSInteger daysInGivenMonth1= days1.length;
                            for (NSInteger i=1; i<=daysInGivenMonth1; i++)
                            {
                                [mArraydate addObject:[NSString stringWithFormat:@"%ld",(long)i]];
                            }
                        }
                    }
                }
            }
            else
            {
                for (int i = 0; i< self.arrayMonthList.count; i++)
                {
                    if ([[self.arrayMonthList objectAtIndex:i]isEqualToString:self.month.text])
                    {
                        
                        NSDateComponents *components1 = [[NSDateComponents alloc] init];
                        // Set your year and month here
                        [components1 setYear:[self.year.text integerValue]];
                        [components1 setMonth:i+1];
                        NSDate *date1 = [gregorian dateFromComponents:components1];
                        
                        NSRange days1 = [gregorian rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date1];
                        
                        NSInteger daysInGivenMonth1= days1.length;
                        for (NSInteger i=1; i<=daysInGivenMonth1; i++)
                        {
                            [mArraydate addObject:[NSString stringWithFormat:@"%ld",(long)i]];
                        }
                    }
                }
            }
        }
        else if ([self.wishType.text isEqualToString:@"Week"])
        {
              mArrayWeek = [[NSMutableArray alloc] init];
            if ([self.year.text isEqualToString:[NSString stringWithFormat:@"%ld",(long)startyear]])
            {
                for (int j = 0; j< self.arrayMonthList.count; j++)
                {
                    if ([[self.arrayMonthList objectAtIndex:j]isEqualToString:self.month.text])
                    {
                        NSDateComponents *components1 = [[NSDateComponents alloc] init];
                        NSCalendar *gregorian = [NSCalendar currentCalendar];

                        // Set your year and month here
                        [components1 setYear:[self.year.text integerValue]];
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
                                [mArrayWeek addObject:[NSString stringWithFormat:@"Week %d [%ld - %ld %@ %d]",x,(long)i,(long)daysInGivenMonth1,[self.arrayMonthList objectAtIndex:j],[self.year.text integerValue]]];
                            } else {
                                [mArrayWeek addObject:[NSString stringWithFormat:@"Week %d [%ld - %ld %@ %d]",x,(long)i,(long)i+6,[self.arrayMonthList objectAtIndex:j],[self.year.text integerValue]]];
                                tempDayCount = tempDayCount - 7;
                            }
                            [temp addObject:[NSString stringWithFormat:@"%d",i+6]];
                            x++;
                            i = i + 6;
                        }
                    
                        if ([self.month.text isEqualToString:[self.arrayMonthList objectAtIndex:startmonth-1]])
                        {
                            for (int k = 0; k < mArrayWeek.count; k++) {
                                if (startDate < [[temp objectAtIndex:k] integerValue]) {
                                    [mArrayWeek removeObjectAtIndex:0];
                                    [mArrayWeek insertObject:[NSString stringWithFormat:@"Week %d [%ld - %ld %@ %d]",k+1,(long)startDate,(long)[[temp objectAtIndex:k] integerValue],[self.arrayMonthList objectAtIndex:j],[self.year.text integerValue]] atIndex:0];
                                    break;
                                }
                                else
                                {
                                    [mArrayWeek removeObjectAtIndex:0];
                                }
                            }
                        }
                    }
                }
            }
            
            else if ([self.year.text isEqualToString:[self convertDateFormat:[self.selectedCouponList objectForKey:@"ExpiryDate"] sourceFormate:@"dd MMM yyyy" targetFormate:@"yyyy"]])
            {
                NSDate *expirydate = [self nsdateFromString:[self.selectedCouponList objectForKey:@"ExpiryDate"] dateFormate:@"dd MMM yyyy"];

                NSDateComponents *dateComponents = [gregorian components:(NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear) fromDate:expirydate];
                
                NSInteger endDate = [dateComponents day];
                NSInteger endmonth = [dateComponents month];
                for (int j = 0; j< self.arrayMonthList.count; j++)
                {
                    if ([[self.arrayMonthList objectAtIndex:j]isEqualToString:self.month.text])
                    {
                        NSDateComponents *components1 = [[NSDateComponents alloc] init];
                        NSCalendar *gregorian = [NSCalendar currentCalendar];
                        
                        // Set your year and month here
                        [components1 setYear:[self.year.text integerValue]];
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
                                [mArrayWeek addObject:[NSString stringWithFormat:@"Week %d [%ld - %ld %@ %d]",x,(long)i,(long)daysInGivenMonth1,[self.arrayMonthList objectAtIndex:j],[self.year.text integerValue]]];
                            } else {
                                [mArrayWeek addObject:[NSString stringWithFormat:@"Week %d [%ld - %ld %@ %d]",x,(long)i,(long)i+6,[self.arrayMonthList objectAtIndex:j],[self.year.text integerValue]]];
                                tempDayCount = tempDayCount - 7;
                            }
                            [temp addObject:[NSString stringWithFormat:@"%d",i+6]];
                            x++;
                            i = i + 6;
                        }
                        
                        if ([self.month.text isEqualToString:[self.arrayMonthList objectAtIndex:endmonth-1]])
                        {
                            for (NSInteger k = mArrayWeek.count-1; k >= 0; k--) {
                                if (endDate < [[temp objectAtIndex:k] integerValue]) {
                                    if (mArrayWeek.count == 1) {
                                        [mArrayWeek removeObjectAtIndex:k];
                                        [mArrayWeek insertObject:[NSString stringWithFormat:@"Week %d [%d - %ld %@ %d]",k+1,1,(long)endDate,[self.arrayMonthList objectAtIndex:j],[self.year.text integerValue]] atIndex:0];
                                        break;

                                    } else {
                                        [mArrayWeek removeObjectAtIndex:k];
                                    }
                                }
                                else
                                {
                                    [mArrayWeek removeObjectAtIndex:k];
                                    [mArrayWeek insertObject:[NSString stringWithFormat:@"Week %ld [%ld - %ld %@ %d]",(long)k,(long)startDate,(long)[[temp objectAtIndex:k] integerValue],[self.arrayMonthList objectAtIndex:j],[self.year.text integerValue]] atIndex:0];
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
    return YES;
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
