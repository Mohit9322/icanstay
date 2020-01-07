//
//  NotificationScreen.m
//  ICanStay
//
//  Created by Namit Aggarwal on 26/02/16.
//  Copyright (c) 2016 Harry Patel (Hitaishin). All rights reserved.
//

#import "NotificationScreen.h"
#import "NotificationScreenCell.h"
#import "LoginManager.h"
#import "MBProgressHUD.h"
#import <AFNetworking.h>
#import "NotificationList.h"
#import "NotificationData.h"
#import "HomeScreenController.h"
#import "SideMenuController.h"
@interface NotificationScreen ()<UITableViewDataSource,UITableViewDelegate>
//@property (nonatomic)NSMutableArray *arrNotificationList;
@property (weak, nonatomic) IBOutlet UITableView *tblNotifications;
@property (nonatomic,weak)NSLayoutConstraint *constHeight;
@property (nonatomic)NotificationList *notificationList;
- (IBAction)btnMenuTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblNoNotification;
@property (weak, nonatomic) IBOutlet UILabel *lblNotificationsDetail;
@property (strong, nonatomic) IBOutlet UIView *viewBottom;
@property (weak, nonatomic) IBOutlet UILabel *lblNotificationCount;

@end

@implementation NotificationScreen

- (void)viewDidLoad {
    [super viewDidLoad];
     DLog(@"DEBUG-VC");
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    [tracker set:kGAIScreenName value:@"Notification"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    [self startServiceToGetAllNotifications];
  //  self.tblNotifications.rowHeight = UITableViewAutomaticDimension;
   // self.tblNotifications.estimatedRowHeight = 60.0; // set
    
    // Do any additional setup after loading the view.
    //self.arrNotificationList = [[NSMutableArray alloc]init];
//    [self.arrNotificationList addObject:@"New Delhi booking are open for 26 Feb 2016\n[Coupon - Ic00040]"];
//    [self.arrNotificationList addObject:@"New Delhi booking are open for 26 Feb 2016\n[Coupon - Ic00040] New Delhi booking are open for 26 Feb 2016\n[Coupon - Ic00040]\nNew Delhi booking are open for 26 Feb 2016\n[Coupon - Ic00040]"];
//    [self.arrNotificationList addObject:@"New Delhi booking are open for 26 Feb 2016\n[Coupon - Ic00040]"];
//    [self.arrNotificationList addObject:@"New Delhi booking are open for 26 Feb 2016\n[Coupon - Ic00040]"];
//    [self.arrNotificationList addObject:@"New Delhi booking are open for 26 Feb 2016\n[Coupon - Ic00040]"];
//    [self.arrNotificationList addObject:@"New Delhi booking are open for 26 Feb 2016\n[Coupon - Ic00040]"];
//    [self.arrNotificationList addObject:@"New Delhi booking are open for 26 Feb 2016\n[Coupon - Ic00040]"];
//    [self.arrNotificationList addObject:@"New Delhi booking are open for 26 Feb 2016\n[Coupon - Ic00040]"];
    
    //[self addBottomBar];
}
- (void)addBottomBar{
    [[ICSingletonManager sharedManager]addBottomMenuToViewController:self onView:self.viewBottom];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.notificationList.arrNotificationList count];
    //[catagorry count];    //count number of row from counting array hear cataGorry is An Array
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NotificationData *notification = [self.notificationList.arrNotificationList objectAtIndex:indexPath.row];

    NSString *myString = notification.msgNotification;
    UIFont *myFont = [UIFont systemFontOfSize:15];
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
        myFont = [UIFont systemFontOfSize:20];
    }
   
    CGSize myStringSize = [ICSingletonManager findHeightForText:myString havingWidth:SCREEN_WIDTH - 20 andFont:myFont];
    
    if (IS_IPAD) {
        return myStringSize.height + 61;
    }
    else
    {
        return myStringSize.height + 41;
    }
//
//    return 76;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NotificationScreenCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NotificationScreenCell"];
    
    NotificationData *notification = [self.notificationList.arrNotificationList objectAtIndex:indexPath.row];
    cell.lblNotification.text = notification.msgNotification;
    cell.lbldate.text = notification.dateNotification;

    return cell;
}

-(void)startServiceToGetAllNotifications{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    LoginManager *loginManage = [[LoginManager alloc]init];
    NSDictionary *dict = [loginManage isUserLoggedIn];
    NSNumber *num = [dict valueForKey:@"UserId"];
    
    
    NSDictionary *dictParams = @{@"userid":num};
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8"
                     forHTTPHeaderField:@"Content-Type"];
    
    
    [manager GET:[NSString stringWithFormat:@"%@/api/BuyCoupens/GetUserNotificationLogList?",kServerUrl] parameters:dictParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        
        self.notificationList = [NotificationList instanceFromNotificationList:responseObject];
        if (self.notificationList.arrNotificationList.count>0)
        {
            self.lblNotificationCount.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.notificationList.arrNotificationList.count];
            [self.tblNotifications reloadData];
            [self.lblNoNotification setHidden:YES];
        }
        else{
            [self.tblNotifications setHidden:YES];
            [self.lblNoNotification setHidden:NO];
            [self.lblNotificationsDetail setHidden:YES];
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

- (IBAction)btnMenuTapped:(id)sender {
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
    
    if (globals.isWithoutLoginNoti == true) {
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
    else{
       [self.navigationController popViewControllerAnimated:YES]; 
    }
    
}
@end
