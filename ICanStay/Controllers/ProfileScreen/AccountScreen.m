//
//  AccountScreen.m
//  ICanStay
//
//  Created by Vertical Logics on 15/03/16.
//  Copyright (c) 2016 Harry Patel (Hitaishin). All rights reserved.
//

#import "AccountScreen.h"
#import "LoginManager.h"
#import "ChangePasswordScreen.h"
#import <QuartzCore/QuartzCore.h>
#import "HomeScreenController.h"
@interface AccountScreen ()
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtEmailId;
@property (strong, nonatomic) IBOutlet UIButton *changePwdBtn;

@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtMobileNumber;

@property (weak, nonatomic) IBOutlet UITextField *txtUserId;

- (IBAction)btnShowPassword:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnCheckbox;
- (IBAction)btnBackTapped:(id)sender;
- (IBAction)btnChangePassword:(id)sender;

@end

@implementation AccountScreen

- (void)viewDidLoad {
     DLog(@"DEBUG-VC");
//    self.changePwdBtn.layer.cornerRadius = 10;
//    self.changePwdBtn.clipsToBounds = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}
-(void)viewWillAppear:(BOOL)animated{
    [self gettingUserDetails];
}
- (void)gettingUserDetails{
    LoginManager *loginManage = [[LoginManager alloc]init];
    NSDictionary *dict = [loginManage isUserLoggedIn];
    NSLog(@"%@",dict);
    
    [self.txtEmailId setText:[dict valueForKey:@"Email"]];
    [self.txtName setText:[dict valueForKey:@"FirstName"]];
    [self.txtPassword setText:[dict valueForKey:@"Password"]];
    [self.txtMobileNumber setText:[dict valueForKey:@"UserName"]];
    [self.txtUserId setText:[dict valueForKey:@"UserName"]];
    [self.btnCheckbox setBackgroundImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
    
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    [tracker set:kGAIScreenName value:@"Account Detail"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnShowPassword:(id)sender {
    UIButton *btn = (UIButton *)sender;
    
    UIImage *image = [btn backgroundImageForState:UIControlStateNormal];
    
    if ([image isEqual: [UIImage imageNamed:@"checkbox"]]) {
        image = [UIImage imageNamed:@"checkbox_selected"];
        [self.txtPassword setSecureTextEntry:NO];
        [btn setBackgroundImage:image forState:UIControlStateNormal];

        
    }
    else{
        image = [UIImage imageNamed:@"checkbox"];
        [btn setBackgroundImage:image forState:UIControlStateNormal];
    [self.txtPassword setSecureTextEntry:YES];
    }
    
//    self.txtPassword.enabled = NO;
//    self.txtPassword.secureTextEntry = YES;
//    self.txtPassword.enabled = YES;
    //[self.txtPassword becomeFirstResponder];
}
- (IBAction)btnBackTapped:(id)sender {
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
    
    if (globals.isFromMenu)
    {
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
//    [self.navigationController  popViewControllerAnimated:YES];
}

- (IBAction)btnChangePassword:(id)sender {
    
    ChangePasswordScreen *changePassScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangePasswordScreen"];
    changePassScreen.strOldPass = self.txtPassword.text;
    [self.navigationController pushViewController:changePassScreen animated:YES];

}
- (IBAction)btnLogout:(id)sender {
    LoginManager *login = [[LoginManager alloc]init];
    [login removeUserModelDictionary];
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
   
    globals.isFirstTimeMenuLoadWebService = @"";
    [[ICSingletonManager sharedManager] showAlertViewWithMsg:@"Logout Successfully!" onController:self];
    HomeScreenController *homeScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeScreenController"];
    [self.mm_drawerController setCenterViewController:homeScreen withCloseAnimation:YES completion:nil];
}
@end
