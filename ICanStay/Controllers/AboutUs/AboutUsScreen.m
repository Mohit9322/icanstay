//
//  AboutUsScreen.m
//  ICanStay
//
//  Created by Vertical Logics on 17/03/16.
//  Copyright (c) 2016 Harry Patel (Hitaishin). All rights reserved.
//

#import "AboutUsScreen.h"
#import "MBProgressHUD.h"
#import <AFNetworking.h>
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"
#import "HomeScreenController.h"
#import "SideMenuController.h"

@interface AboutUsScreen ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)btnMenuTapped:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *icsLogoImgView;

@end

@implementation AboutUsScreen

- (void)viewDidLoad {
    [super viewDidLoad];
     DLog(@"DEBUG-VC");
    // Do any additional setup after loading the view.
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    [tracker set:kGAIScreenName value:@"About Us"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    self.icsLogoImgView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [self.icsLogoImgView addGestureRecognizer:singleFingerTap];
    [self startServiceToGetAboutUsData];
    
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


- (void)startServiceToGetAboutUsData{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
     NSDictionary *dictParams = @{@"contentID":[NSNumber numberWithInt:13]};
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8"
                     forHTTPHeaderField:@"Content-Type"];
    // http://www.icanstay.com/api/DynamicContentapi/GetContentDetailsios?contentID=1
    [manager GET:[NSString stringWithFormat:@"%@/api/DynamicContentApi/GetContentDetailsios?",kServerUrl] parameters:dictParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        NSDictionary *dict = (NSDictionary *)responseObject;
        NSString *strAboutUs =[dict valueForKey:@"ContentDescription"];
//        strAboutUs= [[ICSingletonManager sharedManager]removeNullObjectFromString:strAboutUs];
//        strAboutUs = [[ICSingletonManager sharedManager] stringByStrippingHTMLFromString:strAboutUs];
        if (strAboutUs.length == 0) {
            strAboutUs = @"Please reload after sometime.";
        }
        NSString *htmlString = [NSString stringWithFormat:@"<font face='JosefinSans-Light'>%@", strAboutUs];
        [_webView loadHTMLString:htmlString baseURL:nil];

//        [self.txtAboutUs setText:strAboutUs];
        
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
    
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}
@end
