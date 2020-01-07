//
//  NewSubscription.m
//  ICanStay
//
//  Created by Vertical Logics on 30/03/16.
//  Copyright (c) 2016 Harry Patel (Hitaishin). All rights reserved.
//

#import "NewSubscription.h"

#import "AFNetworking.h"
#import "MBProgressHud.h"
#import "LoginManager.h"
#import "NSString+Validation.h"
#import <QuartzCore/QuartzCore.h>

@interface NewSubscription ()<UITextFieldDelegate>
- (IBAction)btnBackTapped:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
- (IBAction)btnSubmitTapped:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *submitBtn;

@end

@implementation NewSubscription

- (void)viewDidLoad {
//    self.submitBtn.layer.cornerRadius = 10;
//    self.submitBtn.clipsToBounds = YES;
    

    [super viewDidLoad];
     DLog(@"DEBUG-VC");
     [self addBottomBar];
    // Do any additional setup after loading the view.
}

- (void)addBottomBar{
    [[ICSingletonManager sharedManager]addBottomMenuToViewController:self onView:self.viewBottom];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldelegateMethods
- (BOOL)textFieldShouldReturn:(UITextField *)textField{            // called when 'return' key pressed. return NO to ignore.

    [textField resignFirstResponder];
    return YES;

}

-(BOOL)validateEmailAddress{
    
    BOOL ifValidEmail = [self.txtEmail.text isValidEmail];
    if (!ifValidEmail)
        [[ICSingletonManager sharedManager] showAlertViewWithMsg:kEnterValidEmailAddress onController:self];
    
    return  ifValidEmail;
}

#pragma mark - WebService Integration Methods
- (void)startServiceToSubScribeToNewLetter
{
    
    BOOL validEmail=    [self validateEmailAddress];
    if (!validEmail )
        return;
//    if (!self.txtEmail.text.length)
//    {
//        [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Enter the Email" onController:self];
//        return;
//    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    LoginManager *loginManage = [[LoginManager alloc]init];
    NSDictionary *dict = [loginManage isUserLoggedIn];
    NSLog(@"%@",dict);
    
    NSNumber *num = [NSNumber numberWithInt:0];
    NSString *agency = @"Guest";
    if (dict.count>0) {
        num = [dict valueForKey:@"UserId"];
        agency  = [dict valueForKey:@"RoleName"];
    }
    NSString *strParams = [NSString stringWithFormat:@"User_Id=%@&User_Type=%@&Email=%@",num,agency,self.txtEmail.text];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8"
                     forHTTPHeaderField:@"Content-Type"];
    
    
    [manager POST:[NSString stringWithFormat:@"%@/api/UserProfileApi/SubscribeNewsletter?%@",kServerUrl,strParams] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        
        [self.txtEmail setText:@""];
        
        NSLog(@"sucess");
        NSString *msg= [responseObject valueForKey:@"errorMessage"];
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:msg onController:self];
        
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

- (IBAction)btnBackTapped:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnSubmitTapped:(id)sender {
    
    [self startServiceToSubScribeToNewLetter];
}
@end
