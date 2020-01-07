//
//  HelpScreen.m
//  ICanStay
//
//  Created by Vertical Logics on 18/03/16.
//  Copyright (c) 2016 Harry Patel (Hitaishin). All rights reserved.
//

#import "HelpScreen.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"
#import "MBProgressHUD.h"
#import <AFNetworking.h>

@interface HelpScreen ()
@property (weak, nonatomic) IBOutlet UILabel *lblHelp;
- (IBAction)btnHelpTapped:(id)sender;

@end

@implementation HelpScreen

- (void)viewDidLoad {
    [super viewDidLoad];
     DLog(@"DEBUG-VC");
    // Do any additional setup after loading the view.
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    [tracker set:kGAIScreenName value:@"Help"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    [self startServiceToGetHelpData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)startServiceToGetHelpData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *dictParams = @{@"contentID":[NSNumber numberWithInt:15]};
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8"
                     forHTTPHeaderField:@"Content-Type"];
    
    
    [manager GET:[NSString stringWithFormat:@"%@/api/DynamicContentApi/GetContentDetails?",kServerUrl] parameters:dictParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        NSDictionary *dict = (NSDictionary *)responseObject;
        NSString *strHelp =[dict valueForKey:@"ContentDescription"];
        strHelp= [[ICSingletonManager sharedManager]removeNullObjectFromString:strHelp];
        strHelp = [[ICSingletonManager sharedManager] stringByStrippingHTMLFromString:strHelp];
        
        if (strHelp.length == 0) {
            strHelp = @"Please reload after sometime.";
        }

        [self.lblHelp setText:strHelp];
        
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

- (IBAction)btnHelpTapped:(id)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}
@end
