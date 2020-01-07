//
//  MyWishlistViewController.m
//  ICanStay
//
//  Created by Christina Masih on 22/03/16.
//  Copyright © 2016 verticallogics. All rights reserved.
//

#import "MyWishlistViewController.h"
#import "AFNetworking.h"
#import "NSDictionary+JsonString.h"
#import "MBProgressHud.h"
#import "LoginManager.h"
#import "MyWishListTableViewCell.h"
#import "CreateWishlistScreen.h"
#import "NotificationScreen.h"
#import "DashboardScreen.h"
#import "MakeAWishlistViewController.h"
#import <MoEngage.h>
#import "SideMenuController.h"
#import "HomeScreenController.h"
#define kCoupon                         0

@interface MyWishlistViewController ()
{
    NSString      *couponCode;
    NSInteger     selectedIndex;
    UITableView   *wishlistTableViewD;
    UIPickerView  *selectCouponPickerView;
    UIView        *basePickerView;
    UIButton      *cancelBtn;
    UIButton      *doneButton;
   
}
@property (weak, nonatomic) IBOutlet UIView *viewBottom;
@property (weak, nonatomic) IBOutlet UITextField *selectCouponCode;
@property (weak, nonatomic) IBOutlet UITableView *wishlistTableView;
@property (strong, nonatomic) IBOutlet UIImageView *lcsLogoImgView;

- (IBAction)btnBackTapped:(id)sender;

@end

@implementation MyWishlistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     DLog(@"DEBUG-VC");
    // Do any additional setup after loading the view.
    [[ICSingletonManager sharedManager]addBottomMenuToViewController:self onView:self.viewBottom];
    couponCode = @"";
    [self addPickerView];
    self.lcsLogoImgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [self.lcsLogoImgView addGestureRecognizer:singleFingerTap];
    
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
-(void)addPickerView
{
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];

    basePickerView = [[UIView alloc]initWithFrame:CGRectMake(0, screenRect.size.height- 220, screenRect.size.width, 220)];
    basePickerView.backgroundColor = [UIColor grayColor];
    cancelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelBtn.frame = CGRectMake(10, 10, 70, 40);
    [cancelBtn setTitle:@"CANCEL" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor ] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelPicker:) forControlEvents:UIControlEventTouchUpInside];
    [basePickerView addSubview:cancelBtn];
    
    doneButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    doneButton.frame = CGRectMake(basePickerView.frame.size.width - 80, 10, 70, 40);
    [doneButton addTarget:self action:@selector(donePicker:) forControlEvents:UIControlEventTouchUpInside];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [doneButton setTitleColor:[UIColor blackColor ] forState:UIControlStateNormal];
    [basePickerView addSubview:doneButton];
    
    selectCouponPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, doneButton.frame.origin.y + doneButton.frame.size.height , basePickerView.frame.size.width, basePickerView.frame.size.height - 40)];
    selectCouponPickerView.backgroundColor = [UIColor whiteColor];
    [selectCouponPickerView setDataSource: self];
    [selectCouponPickerView setDelegate: self];
    selectCouponPickerView.showsSelectionIndicator = YES;
    [basePickerView addSubview:selectCouponPickerView];
  //  [self.view addSubview:basePickerView];
    
    [basePickerView setHidden:YES];
   
}
#pragma mark- Picker Actions

- (void)cancelPicker:(id)sender {
    [basePickerView setHidden:YES];
    [self.view endEditing:YES];
    
    //[self hideShowPickerView];
}

- (void)donePicker:(id)sender {
    
    //Code for setting the picker value on Done Tap
    
    if(selectPicker==kCoupon && self.arrayCouponList.count != 0)
    {
        self.selectCouponCode.text = [[self.arrayCouponList valueForKey:@"CouponCodeDate"] objectAtIndex:[selectCouponPickerView selectedRowInComponent:0]];
        couponCode = [[self.arrayCouponList valueForKey:@"CouponCode"] objectAtIndex:[selectCouponPickerView selectedRowInComponent:0]];
        wishlistTableViewD = nil;
        [self getWishlistByCoupon];
    }
    [self.view endEditing:YES];
    [basePickerView setHidden:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:true];
    
       [self getCouponList];
    
    [self.wishlistTableView setHidden:YES];
    self.wishlistTableView.backgroundColor = [UIColor greenColor];
    self.wishlistTableView = nil;
    
    if ([self.isFromPurchasedVooucherScreen isEqualToString:@"YES"]) {
        self.isFromPurchasedVooucherScreen = @"NO";
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@""
                                                                                 message:self.alertMasgFromPurchasedVoucher
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            
            
        }];
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//service to get coupons
-(void)getCouponList
{
    //http://192.168.2.5:8585/api/Wishlist/GetUserCouponsList?userid=31458
    
    LoginManager *loginManage = [[LoginManager alloc]init];
    NSDictionary *dict = [loginManage isUserLoggedIn];
    NSNumber *num = [dict valueForKey:@"UserId"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *strParams = [NSString stringWithFormat:@"userid=%@",num];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8"
                     forHTTPHeaderField:@"Content-Type"];
    
    [manager GET:[NSString stringWithFormat:@"%@/api/Wishlist/GetUserCouponsList?%@",kServerUrl,strParams] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        self.arrayCouponList = [[NSMutableArray alloc]init];
        self.arrayCouponList = [responseObject mutableCopy];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([[self.arrayCouponList valueForKey:@"CouponCodeDate"]containsObject:@"-All-"]) {
            
            for (int i =0; i<self.arrayCouponList.count ; i++) {
                if ([[[self.arrayCouponList valueForKey:@"CouponCodeDate"] objectAtIndex:i] isEqualToString:@"-All-"]) {
                    [self.arrayCouponList removeObjectAtIndex:i];
                    break;
                }
            }
        }
        
        if (self.arrayCouponList.count!=0) {
            
            if (self.selectedIndexCouponCodeMyVoucher) {
                
                NSString *txtField;
                for (NSMutableDictionary *dict  in self.arrayCouponList) {
                    if ([[dict objectForKey:@"CouponCode"] isEqualToString:self.selectedIndexCouponCodeMyVoucher]) {
                        txtField = [dict objectForKey:@"CouponCodeDate"];
                    }
                }
                self.selectCouponCode.text = txtField;
                couponCode = self.selectedIndexCouponCodeMyVoucher;
                [self getWishlistByCoupon];
                self.selectedIndexCouponCodeMyVoucher = nil;
                
            }else{
                self.selectCouponCode.text = [[self.arrayCouponList valueForKey:@"CouponCodeDate"] objectAtIndex:0];
                couponCode = [[self.arrayCouponList valueForKey:@"CouponCode"] objectAtIndex:0];
                [self getWishlistByCoupon];
            }
           
        }
       //self.selectCouponCode.text= [[self.arrayCouponList valueForKey:@"CouponCodeDate"] objectAtIndex:0];
//        self.selectCouponCode.textAlignment = NSTextAlignmentCenter;
        
   //        NSString *status = [responseObject valueForKey:@"status"];
   //        NSString *msg = [responseObject valueForKey:@"errorMessage"];
    //        if ([status isEqualToString:@"SUCCESS"]) {
        //
        //        }
        //
        //        NSLog(@"sucess");
        //        [[ICSingletonManager sharedManager]showAlertViewWithMsg:msg onController:self];
        

    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        NSString *msg = [error description];
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
    
 //   [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *strParams = [NSString stringWithFormat:@"CouponCode=%@",couponCode];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8"
                     forHTTPHeaderField:@"Content-Type"];
    
    
    [manager GET:[NSString stringWithFormat:@"%@/api/Wishlist/GetWishlistDetail?%@",kServerUrl,strParams] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        self.arrayWishList = responseObject;
        if (self.arrayWishList.count  > 0) {
            [self.wishlistTableView setHidden:NO];
        } else {
            [self.wishlistTableView setHidden:YES];
            
        }
        [self.wishlistTableView reloadData];
        
        CGRect screenRect                    = [[UIScreen mainScreen] bounds];
        wishlistTableViewD                 = [[UITableView alloc] init];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
             wishlistTableViewD.frame           = CGRectMake(0, _selectCouponCode.frame.size.height + _selectCouponCode.frame.origin.y +20, screenRect.size.width, 500);
        }else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
             wishlistTableViewD.frame           = CGRectMake(0, _selectCouponCode.frame.size.height + _selectCouponCode.frame.origin.y +20, screenRect.size.width, self.view.frame.size.height - (_selectCouponCode.frame.size.height + _selectCouponCode.frame.origin.y +20));
        }
       
        wishlistTableViewD.delegate        = self;
        wishlistTableViewD.dataSource      = self;
        wishlistTableViewD.allowsSelection = NO;
        [self.view addSubview:wishlistTableViewD];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
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
        NSString *msg = [error description];
        
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:error.localizedDescription onController:self];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
// the cell will be returned to the tableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellID";
    
    NSString *wishListType = @"";
    NSString *destination = @"";
    NSString *startAndEndDate = @"";
    UIImage *heartImg = [UIImage imageNamed:@"heartImgUnselected"];
    
    if ([self.arrayWishList count] > indexPath.row) {
        NSDictionary *wishlistDictionary = [self.arrayWishList objectAtIndex:indexPath.row];
        wishListType =[NSString stringWithFormat:@"%@", [wishlistDictionary objectForKey:@"WishlistType"]];
        
        if ([wishListType isEqualToString:@"1"]) {
            wishListType = @"Month";
            
            NSString *month = [NSString stringWithFormat:@"%@",[wishlistDictionary objectForKey:@"Prf_Month"]];
            if ([month isEqualToString:@"1"]) {
                month = @"Jan";
            }else if ([month isEqualToString:@"2"]){
                month = @"Feb";
            }else if ([month isEqualToString:@"3"]){
                month = @"Mar";
            }else if ([month isEqualToString:@"4"]){
                month = @"Apr";
            }else if ([month isEqualToString:@"5"]){
                month = @"May";
            }else if ([month isEqualToString:@"6"]){
                month = @"Jun";
            }else if ([month isEqualToString:@"7"]){
                month = @"Jul";
            }else if ([month isEqualToString:@"8"]){
                month = @"Aug";
            }else if ([month isEqualToString:@"9"]){
                month = @"Sep";
            }else if ([month isEqualToString:@"10"]){
                month = @"Oct";
            }else if ([month isEqualToString:@"11"]){
                month = @"Nov";
            }else if ([month isEqualToString:@"12"]){
                month = @"Dec";
            }
            
            startAndEndDate = [NSString stringWithFormat:@"%@ %@", month, [wishlistDictionary objectForKey:@"Prf_Year"]];
        }else if ([wishListType isEqualToString:@"2"]){
            wishListType = @"Weak";
            startAndEndDate = [NSString stringWithFormat:@"%@ %@", [wishlistDictionary objectForKey:@"Prf_From_date"], [wishlistDictionary objectForKey:@"Prf_To_date"]];
            
            NSMutableArray *list = [NSMutableArray array];
            for (int i=0; i<startAndEndDate.length; i++) {
                [list addObject:[startAndEndDate substringWithRange:NSMakeRange(i, 1)]];
            }
            
            NSString *yearStr = [NSString stringWithFormat:@"%@%@%@%@",[list objectAtIndex:0],[list objectAtIndex:1],[list objectAtIndex:2],[list objectAtIndex:3]];
            NSString *monthStr = [NSString stringWithFormat:@"%@%@",[list objectAtIndex:5],[list objectAtIndex:6]];
            NSString *dateStr = [NSString stringWithFormat:@"%@%@",[list objectAtIndex:8],[list objectAtIndex:9]];
            if ([monthStr isEqualToString:@"01"]) {
                monthStr = @"Jan";
            }else if ([monthStr isEqualToString:@"02"]){
                monthStr = @"Feb";
            }else if ([monthStr isEqualToString:@"03"]){
                monthStr = @"Mar";
            }else if ([monthStr isEqualToString:@"04"]){
                monthStr = @"Apr";
            }else if ([monthStr isEqualToString:@"05"]){
                monthStr = @"May";
            }else if ([monthStr isEqualToString:@"06"]){
                monthStr = @"Jun";
            }else if ([monthStr isEqualToString:@"07"]){
                monthStr = @"Jul";
            }else if ([monthStr isEqualToString:@"08"]){
                monthStr = @"Aug";
            }else if ([monthStr isEqualToString:@"09"]){
                monthStr = @"Sep";
            }else if ([monthStr isEqualToString:@"10"]){
                monthStr = @"Oct";
            }else if ([monthStr isEqualToString:@"11"]){
                monthStr = @"Nov";
            }else if ([monthStr isEqualToString:@"12"]){
                monthStr = @"Dec";
            }
            NSString *tempDateStr1 = [NSString stringWithFormat:@"%@ %@ %@", dateStr, monthStr, yearStr];
            startAndEndDate = [NSString stringWithFormat:@"%@ %@", [wishlistDictionary objectForKey:@"Prf_From_date"], [wishlistDictionary objectForKey:@"Prf_To_date"]];
            
            NSMutableArray *list2 = [NSMutableArray array];
            for (int i=0; i<startAndEndDate.length; i++) {
                [list2 addObject:[startAndEndDate substringWithRange:NSMakeRange(i, 1)]];
            }
            
            NSString *yearStr2 = [NSString stringWithFormat:@"%@%@%@%@",[list2 objectAtIndex:20],[list2 objectAtIndex:21],[list2 objectAtIndex:22],[list2 objectAtIndex:23]];
            NSString *monthStr2 = [NSString stringWithFormat:@"%@%@",[list2 objectAtIndex:25],[list2 objectAtIndex:26]];
            NSString *dateStr2 = [NSString stringWithFormat:@"%@%@",[list2 objectAtIndex:28],[list2 objectAtIndex:29]];
            
            if ([monthStr2 isEqualToString:@"01"]) {
                monthStr2 = @"Jan";
            }else if ([monthStr2 isEqualToString:@"02"]){
                monthStr2 = @"Feb";
            }else if ([monthStr isEqualToString:@"03"]){
                monthStr2 = @"Mar";
            }else if ([monthStr2 isEqualToString:@"04"]){
                monthStr2 = @"Apr";
            }else if ([monthStr2 isEqualToString:@"05"]){
                monthStr2 = @"May";
            }else if ([monthStr2 isEqualToString:@"06"]){
                monthStr2 = @"Jun";
            }else if ([monthStr2 isEqualToString:@"07"]){
                monthStr = @"Jul";
            }else if ([monthStr2 isEqualToString:@"08"]){
                monthStr2 = @"Aug";
            }else if ([monthStr2 isEqualToString:@"09"]){
                monthStr2 = @"Sep";
            }else if ([monthStr2 isEqualToString:@"10"]){
                monthStr2 = @"Oct";
            }else if ([monthStr2 isEqualToString:@"11"]){
                monthStr2 = @"Nov";
            }else if ([monthStr2 isEqualToString:@"12"]){
                monthStr2 = @"Dec";
            }
            
            
            
            startAndEndDate  = [NSString stringWithFormat:@"%@-%@",tempDateStr1, [NSString stringWithFormat:@"%@ %@ %@", dateStr2, monthStr2, yearStr2]];
            
            
        }else if ([wishListType isEqualToString:@"3"])
        {
            wishListType = @"Date";
            startAndEndDate = [wishlistDictionary objectForKey:@"Prf_From_date"];
            
            
            NSMutableArray *list = [NSMutableArray array];
            for (int i=0; i<startAndEndDate.length; i++) {
                [list addObject:[startAndEndDate substringWithRange:NSMakeRange(i, 1)]];
            }
            
            NSString *yearStr = [NSString stringWithFormat:@"%@%@%@%@",[list objectAtIndex:0],[list objectAtIndex:1],[list objectAtIndex:2],[list objectAtIndex:3]];
            NSString *monthStr = [NSString stringWithFormat:@"%@%@",[list objectAtIndex:5],[list objectAtIndex:6]];
            NSString *dateStr = [NSString stringWithFormat:@"%@%@",[list objectAtIndex:8],[list objectAtIndex:9]];
            if ([monthStr isEqualToString:@"01"]) {
                monthStr = @"Jan";
            }else if ([monthStr isEqualToString:@"02"]){
                monthStr = @"Feb";
            }else if ([monthStr isEqualToString:@"03"]){
                monthStr = @"Mar";
            }else if ([monthStr isEqualToString:@"04"]){
                monthStr = @"Apr";
            }else if ([monthStr isEqualToString:@"05"]){
                monthStr = @"May";
            }else if ([monthStr isEqualToString:@"06"]){
                monthStr = @"Jun";
            }else if ([monthStr isEqualToString:@"07"]){
                monthStr = @"Jul";
            }else if ([monthStr isEqualToString:@"08"]){
                monthStr = @"Aug";
            }else if ([monthStr isEqualToString:@"09"]){
                monthStr = @"Sep";
            }else if ([monthStr isEqualToString:@"10"]){
                monthStr = @"Oct";
            }else if ([monthStr isEqualToString:@"11"]){
                monthStr = @"Nov";
            }else if ([monthStr isEqualToString:@"12"]){
                monthStr = @"Dec";
            }
            
            startAndEndDate = [NSString stringWithFormat:@"%@ %@ %@", dateStr, monthStr, yearStr];
            
            
            
        }else if ([wishListType isEqualToString:@"4"]){
            wishListType = @"Special Day(s)";
            startAndEndDate = [wishlistDictionary objectForKey:@"Prf_From_date"];
            NSMutableArray *list = [NSMutableArray array];
            for (int i=0; i<startAndEndDate.length; i++) {
                [list addObject:[startAndEndDate substringWithRange:NSMakeRange(i, 1)]];
            }
            
            NSString *yearStr = [NSString stringWithFormat:@"%@%@%@%@",[list objectAtIndex:0],[list objectAtIndex:1],[list objectAtIndex:2],[list objectAtIndex:3]];
            NSString *monthStr = [NSString stringWithFormat:@"%@%@",[list objectAtIndex:5],[list objectAtIndex:6]];
            NSString *dateStr = [NSString stringWithFormat:@"%@%@",[list objectAtIndex:8],[list objectAtIndex:9]];
            if ([monthStr isEqualToString:@"01"]) {
                monthStr = @"Jan";
            }else if ([monthStr isEqualToString:@"02"]){
                monthStr = @"Feb";
            }else if ([monthStr isEqualToString:@"03"]){
                monthStr = @"Mar";
            }else if ([monthStr isEqualToString:@"04"]){
                monthStr = @"Apr";
            }else if ([monthStr isEqualToString:@"05"]){
                monthStr = @"May";
            }else if ([monthStr isEqualToString:@"06"]){
                monthStr = @"Jun";
            }else if ([monthStr isEqualToString:@"07"]){
                monthStr = @"Jul";
            }else if ([monthStr isEqualToString:@"08"]){
                monthStr = @"Aug";
            }else if ([monthStr isEqualToString:@"09"]){
                monthStr = @"Sep";
            }else if ([monthStr isEqualToString:@"10"]){
                monthStr = @"Oct";
            }else if ([monthStr isEqualToString:@"11"]){
                monthStr = @"Nov";
            }else if ([monthStr isEqualToString:@"12"]){
                monthStr = @"Dec";
            }
            
            startAndEndDate = [NSString stringWithFormat:@"%@ %@ %@", dateStr, monthStr, yearStr];
            
        }
        heartImg =[UIImage imageNamed:@"heartImgSelected"];
        destination = [wishlistDictionary objectForKey:@"City_Name"];
        
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:
                UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.frame = CGRectMake(0, 0, wishlistTableViewD.frame.size.width, 100);
        
        UIView * baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
        baseView.layer.masksToBounds = YES;
        [cell addSubview:baseView];
        
        UIView *_blueBaseView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, baseView.frame.size.width- 20, baseView.frame.size.height - 20)];
        _blueBaseView.backgroundColor = [UIColor colorWithRed:0.0118 green:0.1176 blue:0.2471 alpha:1];
        _blueBaseView.layer.masksToBounds = YES;
        [baseView addSubview:_blueBaseView];
        
        
        
        
        UIImageView *_heartImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 20, 20)];
        _heartImgView.layer.masksToBounds = YES;
        [_blueBaseView addSubview:_heartImgView];
        
        UILabel *wishListTypeLbl = [[UILabel alloc]initWithFrame:CGRectMake(_heartImgView.frame.size.width + _heartImgView.frame.origin.x +5, _heartImgView.frame.origin.y, 200, 20)];
        wishListTypeLbl.textColor = [UIColor whiteColor];
        wishListTypeLbl.layer.masksToBounds = YES;
        [_blueBaseView addSubview:wishListTypeLbl];
        
        UILabel * _destinationLbl = [[UILabel alloc]initWithFrame:CGRectMake(_heartImgView.frame.origin.x, wishListTypeLbl.frame.origin.y + wishListTypeLbl.frame.size.height , 400, 20)];
        _destinationLbl.layer.masksToBounds = YES;
        
        _destinationLbl.textColor = [UIColor whiteColor];
        [_blueBaseView addSubview:_destinationLbl];
        
        UILabel * _dateLbl = [[UILabel alloc]initWithFrame:CGRectMake(_heartImgView.frame.origin.x, _destinationLbl.frame.origin.y + _destinationLbl.frame.size.height , 400, 20)];
        _dateLbl.textColor = [UIColor whiteColor];
        _dateLbl.layer.masksToBounds = YES;
        [_blueBaseView addSubview:_dateLbl];
        
        UIView *narrowLineView = [[UIView alloc]initWithFrame:CGRectMake(_blueBaseView.frame.size.width/4, _blueBaseView.frame.origin.y + _blueBaseView.frame.size.height +10, _blueBaseView.frame.size.width/2, 1)];
        narrowLineView.backgroundColor = [UIColor colorWithRed:0.7373 green:0.5922 blue:0.3294 alpha:1];
        narrowLineView.layer.masksToBounds = YES;
        [baseView addSubview:narrowLineView];
        
        if ([wishListType isEqualToString:@""] && [destination isEqualToString:@""] && [startAndEndDate isEqualToString:@""]) {
            
            UIButton *createWishlist = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            createWishlist.frame = CGRectMake((_blueBaseView.frame.size.width - 200)/2, (_blueBaseView.frame.size.height - 40)/2, 200, 40);
            [createWishlist setTitle:@"Create Wishlist" forState:UIControlStateNormal];
            [createWishlist setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [createWishlist addTarget:self action:@selector(createWishListBuroonTapped:) forControlEvents:UIControlEventTouchUpInside];
            createWishlist.tag = indexPath.row;
            [_blueBaseView addSubview:createWishlist];
        }else{
            UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            deleteButton.frame = CGRectMake(_blueBaseView.frame.size.width - 50, 10, 20, 20);
            [deleteButton setBackgroundImage:[UIImage imageNamed:@"whiteCross"] forState:UIControlStateNormal];
            [deleteButton addTarget:self action:@selector(deleteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            deleteButton.tag = indexPath.row;
            [_blueBaseView addSubview:deleteButton];
            
            
            UIButton *editButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            editButton.frame = CGRectMake(_blueBaseView.frame.size.width - 50, _blueBaseView.frame.size.height - 30, 20, 20);
            [editButton setBackgroundImage:[UIImage imageNamed:@"Edit_White"] forState:UIControlStateNormal];
            [editButton addTarget:self action:@selector(editButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            editButton.tag = indexPath.row;
            [_blueBaseView addSubview:editButton];

        }
        
        _heartImgView.image = heartImg;
        _destinationLbl.text = destination;
        _dateLbl.text = startAndEndDate;
        
        
        wishListTypeLbl.text = wishListType;
        
        
        
    }
    
    return cell;
}

-(void)createWishListBuroonTapped:(id)sender
{
       UIButton *wishlistEdit =(UIButton *)sender;
    MakeAWishlistViewController *createWishList =[self.storyboard instantiateViewControllerWithIdentifier:@"MakeAWishlistViewController"];
    createWishList.couponCodeFromMyWishlist = self.selectCouponCode.text;
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
    globals.isFromMenuForMakeWishe           = false;
    globals.isFromEditMakeWishlist           = false;
    globals.isFromMywishlistToCreateWishlist = true;
    createWishList.isFromEdit                = false;
    createWishList.couponCodeFromMyWishlist = self.selectCouponCode.text;
    [self.navigationController pushViewController:createWishList animated:YES];
    
}

-(void)editButtonPressed:(id)sender
{
    
    
    UIButton *wishlistEdit =(UIButton *)sender;
        ICSingletonManager *globals = [ICSingletonManager sharedManager];
        globals.isFromMenuForMakeWishe = false;
        globals.isFromEditMakeWishlist = true;
        MakeAWishlistViewController *createWishList =[self.storyboard instantiateViewControllerWithIdentifier:@"MakeAWishlistViewController"];
        createWishList.dictionaryCouponList = [self.arrayWishList objectAtIndex:wishlistEdit.tag];
        createWishList.isFromEdit = true;
    
    
    LoginManager *loginManage = [[LoginManager alloc]init];
    NSDictionary *dict = [loginManage isUserLoggedIn];
    
    
    /****************** Mo Engage *******************/
    
    NSMutableDictionary *purchaseDict = [NSMutableDictionary dictionaryWithDictionary:@{@"Mobile No.": [dict objectForKey:@"Phone1"],@"User name":[NSString stringWithFormat:@"%@ %@", [dict objectForKey:@"FirstName"],[dict objectForKey:@"LastName"]],@"City Name":[[self.arrayWishList objectAtIndex:wishlistEdit.tag]objectForKey:@"City_Name"],@"Email":[dict objectForKey:@"Email"]}];
    
    
    [[MoEngage sharedInstance]trackEvent:@"App Wishlist Modified IOS" andPayload:purchaseDict];
     [[MoEngage sharedInstance] syncNow];
    [MoEngage debug:LOG_ALL];
    
    /****************** Mo Engage *******************/
    
    /****************** Mo Engage *******************/
    
    /****************** Google Analytics *******************/
    // Track the Event for UserSuccessfulRegistrationMobile
    
    NSString *actionStr = [NSString  stringWithFormat:@"%@ %@ %@",[NSString stringWithFormat:@"%@ %@", [dict objectForKey:@"FirstName"],[dict objectForKey:@"LastName"]],[dict objectForKey:@"Phone1"],[[self.arrayWishList objectAtIndex:wishlistEdit.tag]objectForKey:@"City_Name"]];
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"App Wishlist Modified IOS"
                                                          action:actionStr
                                                           label:[dict objectForKey:@"Phone1"]
                                                           value:nil] build]];
    
    /****************** Google Analytics *******************/
    

        [self.navigationController pushViewController:createWishList animated:YES];

}
-(void)deleteButtonPressed:(id)sender
{
    UIButton *wishlistDelete =(UIButton *)sender;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Are you sure to delete wihlist" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self deleteWishlistAlertYesBtnTapped:wishlistDelete.tag];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
       
    }]];
    
   
    dispatch_async(dispatch_get_main_queue(), ^ {
        [self presentViewController:alertController animated:YES completion:nil];
    });
    
   }

-(void)deleteWishlistAlertNoButtonTapped
{
    
}
-(void)deleteWishlistAlertYesBtnTapped:(int)tag
{
    [self postDataToDeleteWishlist];

}
#pragma mark - UITableViewDelegate
// when user tap the row, what action you want to perform
- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"selected %d row", indexPath.row);
}


- (IBAction)wishlistDeleteTap:(id)sender {
    UIButton *wishlistDelete =(UIButton *)sender;
    selectedIndex = wishlistDelete.tag;
    [self postDataToDeleteWishlist];
}

- (IBAction)wishlistEditTap:(id)sender {
    UIButton *wishlistEdit =(UIButton *)sender;
    
    CreateWishlistScreen *createWishList =[self.storyboard instantiateViewControllerWithIdentifier:@"CreateWishlistScreen"];
    createWishList.dictionaryCouponList = [self.arrayWishList objectAtIndex:wishlistEdit.tag];
    createWishList.isFromEdit = true;
    [self.navigationController pushViewController:createWishList animated:YES];
    
}


-(void)postDataToDeleteWishlist
{
    // http://dev.icanstay.businesstowork.com/api/Wishlist/RemoveWishList
    /*
     : “prf_Dest_id”:  Wishlist details Id from UI

     */
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *strParams = [NSString stringWithFormat:@"Prf_Dest_id=%@",[[self.arrayWishList objectAtIndex:selectedIndex]valueForKey:@"Prf_Dest_id"]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8"
                     forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:[NSString stringWithFormat:@"%@/api/Wishlist/RemoveWishList?%@",kServerUrl,strParams] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        
        NSString *status = [responseObject valueForKey:@"status"];
        NSString *msg = [responseObject valueForKey:@"errorMessage"];
        if ([status isEqualToString:@"SUCCESS"]) {
            [self getWishlistByCoupon];
            wishlistTableViewD = nil;
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
        NSLog(@"sucess");
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:msg onController:self];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            LoginManager *login = [[LoginManager alloc]init];
            if ([[login isUserLoggedIn] count]>0)
            {
                SideMenuController *vcSideMenu = [[SideMenuController alloc]init];
                [vcSideMenu startServiceToGetCouponsDetails];
            }
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        NSString *msg = [error description];
        
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:error.localizedDescription onController:self];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
    
}

- (IBAction)btnBackTapped:(id)sender{
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
    if ([globals.isFromDeepLinkToWishListScreen isEqualToString:@"YES"]) {
        globals.isFromDeepLinkToWishListScreen = @"NO";
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
        
    }else if (globals.isFromMenuForWishList)
    {
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    }
    else
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }

//    [self.navigationController popToRootViewControllerAnimated:true];
    //[self.navigationController popViewControllerAnimated:YES];
}



#pragma mark Picker View Delegate

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}


-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    int count=0;
    
    if (selectPicker==kCoupon)
    {
        count = (int)[self.arrayCouponList count];
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
    if (selectPicker == kCoupon) {
        title=[[self.arrayCouponList objectAtIndex:row] valueForKey:@"CouponCodeDate"];
    }
    
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    tView.attributedText=attString;
    return tView;
}

- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated{
    [self.pickerView selectRow:0 inComponent:0 animated:YES];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
}

#pragma mark - TextField Delegate
//-(void)textFieldDidBeginEditing:(UITextField *)textField
//{

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

    if (textField == self.selectCouponCode) {
        
        selectPicker = kCoupon;
      //  [self.datePicker setHidden:YES];
      //  [self.pickerView setHidden:NO];
      //  [self.pickerView reloadAllComponents];
     //   [self.viewPicker setHidden:NO];
        
        [selectCouponPickerView reloadAllComponents];
        [basePickerView setHidden:NO];
        [self.view addSubview:basePickerView];
        
        return NO;
    }
    return YES;
}

//#pragma mark - UITableViewDataSource
//// number of section(s), now I assume there is only 1 section
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView
//{
//    return 1;
//}
//
//// number of row in the section, I assume there is only 1 row
//- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section
//{
//    return self.arrayWishList.count;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 120;
//}
//// the cell will be returned to the tableView
//- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *cellIdentifier = @"whislistCell";
//    //Storing dictionary value from array at index
//    NSDictionary *wishlistDictionary = [self.arrayWishList objectAtIndex:indexPath.row];
//    
//    MyWishListTableViewCell *cell = (MyWishListTableViewCell *)[theTableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    if (cell == nil) {
//        cell = [[MyWishListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//    }
//    NSString *stayType = [wishlistDictionary valueForKey:@"FamilyStay"];
//    if ([stayType isEqualToString:@"N"]) {
//        [cell.lblStayTypeValue setText:@"Single"];
//    }
//    else
//        [cell.lblStayTypeValue setText:@"Family"];
//    cell.cellHeaderTitle.text = [NSString stringWithFormat:@"Destination %ld",indexPath.row+1];
//    cell.destinationName.text = [wishlistDictionary objectForKey:@"City_Name"];
//  
//    if ([[wishlistDictionary objectForKey:@"WishlistType"] intValue] == 1) {
//        cell.stayType.text = @"Month";
//        cell.whenToStay.text = [self convertDateFormat:[wishlistDictionary objectForKey:@"Prf_From_date"] sourceFormate:@"yyyy-MM-dd'T'HH:mm:ss" targetFormate:@"MMM - yyyy"];
//        
//    }
//    else if ([[wishlistDictionary objectForKey:@"WishlistType"] intValue] == 2){
//        NSString *tempStr = [self convertDateFormat:[wishlistDictionary objectForKey:@"Prf_From_date"] sourceFormate:@"yyyy-MM-dd'T'HH:mm:ss" targetFormate:@"dd MMM yyyy"];
//        tempStr = [tempStr stringByAppendingString:@" - "];
//        tempStr = [tempStr stringByAppendingString:[self convertDateFormat:[wishlistDictionary objectForKey:@"Prf_To_date"] sourceFormate:@"yyyy-MM-dd'T'HH:mm:ss" targetFormate:@"dd MMM yyyy"]];
//
//        cell.whenToStay.text = tempStr;
//        cell.stayType.text = @"Week";
//    }
//    else if ([[wishlistDictionary objectForKey:@"WishlistType"] intValue] == 3){
//        cell.whenToStay.text = [self convertDateFormat:[wishlistDictionary objectForKey:@"Prf_From_date"] sourceFormate:@"yyyy-MM-dd'T'HH:mm:ss" targetFormate:@"dd MMM yyyy"];
//        cell.stayType.text = @"Date";
//    }
//    else{
//        cell.whenToStay.text = [self convertDateFormat:[wishlistDictionary objectForKey:@"Prf_From_date"] sourceFormate:@"yyyy-MM-dd'T'HH:mm:ss" targetFormate:@"dd MMM yyyy"];
//        cell.stayType.text = @"Special Day(s)";
//    }
//    
//    cell.roomsNumber.text = [[wishlistDictionary objectForKey:@"RoomCount"] stringValue];
//    
//    [cell.wishlistDeleteButton addTarget:self action:@selector(wishlistDeleteTap:) forControlEvents:UIControlEventTouchUpInside];
//    [cell.wishlistEditButton addTarget:self action:@selector(wishlistEditTap:) forControlEvents:UIControlEventTouchUpInside];
//    cell.wishlistDeleteButton.tag = indexPath.row;
//    cell.wishlistEditButton.tag = indexPath.row;
//
//    return cell;
//}
//
//#pragma mark - UITableViewDelegate
//// when user tap the row, what action you want to perform
//- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    //NSLog(@"selected %d row", indexPath.row);
//}
//
//
//- (IBAction)wishlistDeleteTap:(id)sender {
//    
//    UIButton *wishlistDelete =(UIButton *)sender;
//    selectedIndex = wishlistDelete.tag;
// 
//    UIAlertController * alert=   [UIAlertController alertControllerWithTitle:@"" message:@"Are you sure you want to delete wishlist?" preferredStyle:UIAlertControllerStyleAlert];
//  
//    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
//                             {
//                                 [alert dismissViewControllerAnimated:YES completion:nil];
//                                 
//                             }];
//    
//    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
//                         {
//                             [self postDataToDeleteWishlist];
//                             [alert dismissViewControllerAnimated:YES completion:nil];
//                             
//                         }];
//    
//    [alert addAction:cancel];
//    [alert addAction:ok];
//    
//    [self presentViewController:alert animated:YES completion:nil];
//    
//}
//
//- (IBAction)wishlistEditTap:(id)sender {
//    UIButton *wishlistEdit =(UIButton *)sender;
//    ICSingletonManager *globals = [ICSingletonManager sharedManager];
//    globals.isFromMenuForMakeWishe = false;
//    MakeAWishlistViewController *createWishList =[self.storyboard instantiateViewControllerWithIdentifier:@"MakeAWishlistViewController"];
//    createWishList.dictionaryCouponList = [self.arrayWishList objectAtIndex:wishlistEdit.tag];
//    createWishList.isFromEdit = true;
//    [self.navigationController pushViewController:createWishList animated:YES];
//
//}

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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
