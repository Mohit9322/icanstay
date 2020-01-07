//
//  ChangePasswordScreen.m
//  ICanStay
//
//  Created by Vertical Logics on 02/03/16.
//  Copyright (c) 2016 Harry Patel (Hitaishin). All rights reserved.
//

#import "ChangePasswordScreen.h"
#import "AFNetworking.h"
#import "LoginManager.h"
#import "NSDictionary+JsonString.h"
#import "NSString+Validation.h"
#import "UITextField+EmptyText.h"
#import "MBProgressHud.h"
#import <QuartzCore/QuartzCore.h>
#import "HomeScreenController.h"
#import "SideMenuController.h"

@interface ChangePasswordScreen ()
@property (strong, nonatomic) IBOutlet UIButton *changePwdBtn;
@property (weak, nonatomic) IBOutlet UITextField *txtOldPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtNewPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtReEnterPass;
- (IBAction)btnSubmitTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewBottom;
- (IBAction)btnBackTapped:(id)sender;

@end

@implementation ChangePasswordScreen

- (void)viewDidLoad {
    
     DLog(@"DEBUG-VC");
//    self.changePwdBtn.layer.cornerRadius = 10;
//    self.changePwdBtn.clipsToBounds = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    [tracker set:kGAIScreenName value:@"Change Password"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    [[ICSingletonManager sharedManager] addBottomMenuToViewController:self onView:self.viewBottom];
    [self addPaddingToTextFields];
    [self.txtOldPassword setText:self.strOldPass];
}

- (void)addPaddingToTextFields{
    [self.txtNewPassword addPaddingToTextField];
    [self.txtOldPassword addPaddingToTextField];
    [self.txtReEnterPass addPaddingToTextField];
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
- (void)postDataForChangePassword
{
    BOOL ifTextFielsDataValidated = [self validateTextFieldData];
    if (!ifTextFielsDataValidated)
        return;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    LoginManager *loginManage = [[LoginManager alloc]init];
    NSDictionary *dict = [loginManage isUserLoggedIn];
    NSLog(@"%@",dict);
    
    NSNumber *userId = [dict valueForKey:@"UserId"];
    NSString *strFirstName = [dict valueForKey:@"FirstName"];
    NSString *strEmail = [dict valueForKey:@"Email"];
    NSString *strPhone =[dict valueForKey:@"Phone1"];
    
    strFirstName = [strFirstName removeEmptyString];
    strEmail =     [strEmail removeEmptyString];
    strPhone =     [strPhone removeEmptyString];
    
    
    //NSDictionary *dictParams = @{@"UserId":userId,@"Password":self.txtOldPassword.text,@"ConfirmPassword":self.txtReEnterPass.text,@"Phone1":strPhone,@"Email":strEmail,@"FirstName":strFirstName};
    //NSString *strParam = [dictParams jsonStringWithPrettyPrint:YES];
   
    //NSString *strUrl =[NSString stringWithFormat:@"%@/api/Loginapi/ChangePasswordMobile",kServerUrl];
    //NSLog(@"%@",strUrl);

    
    /*http://www.icanstay.com/api/Loginapi/ChangePasswordMobile
    
    {
        "OldPassword" : "1234",
        "Password": "12345",
        "ConfirmPassword": "12345",
        "UserId": 71747,
        "Email": "itscoolprashant007@gmail.com",
        "Phone1": "9555039746",
        "FirstName": "Prashant"
    }*/
    
    NSString *strParams = [NSString stringWithFormat:@"UserId=%@&OldPassword=%@&Password=%@&ConfirmPassword=%@&Phone1=%@&Email=%@&FirstName=%@",userId,self.txtOldPassword.text,self.txtNewPassword.text,self.txtReEnterPass.text,strPhone,strEmail,strFirstName];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8"
                     forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:[NSString stringWithFormat:@"%@/api/Loginapi/ChangePasswordMobile?%@",kServerUrl,strParams] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSLog(@"responseObject=%@",responseObject);
        
        NSString *status = [responseObject objectForKey:@"status"];
        // NSString *msg = [responseObject valueForKey:@"errorMessage"];
        if ([status isEqualToString:@"SUCCESS"])
        {
                [self.navigationController popViewControllerAnimated:NO];
        }
        else if ([status isEqualToString:@"FAIL"])
        {
            [[ICSingletonManager sharedManager] showAlertViewWithMsg:[responseObject objectForKey:@"errorMessage"] onController:self];
        }
        
        //NSLog(@"sucess");
        //[[ICSingletonManager sharedManager]showAlertViewWithMsg:msg onController:self];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        NSLog(@"error=%@",error.localizedFailureReason);
        NSLog(@"%@",error.localizedDescription);
        [[ICSingletonManager sharedManager] showAlertViewWithMsg:error.localizedDescription onController:self];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];


}
- (void)startServiceToChangePassword
{
    
    BOOL ifTextFielsDataValidated = [self validateTextFieldData];
    if (!ifTextFielsDataValidated)
        return;

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    LoginManager *loginManage = [[LoginManager alloc]init];
    NSDictionary *dict = [loginManage isUserLoggedIn];
    NSLog(@"%@",dict);
    
    NSNumber *userId = [dict valueForKey:@"UserId"];
    NSString *strFirstName = [dict valueForKey:@"FirstName"];
    NSString *strEmail = [dict valueForKey:@"Email"];
    NSString *strPhone =[dict valueForKey:@"Phone1"];
    
    strFirstName = [strFirstName removeEmptyString];
    strEmail =     [strEmail removeEmptyString];
    strPhone =     [strPhone removeEmptyString];
    
    
    NSDictionary *dictParams = @{@"UserId":userId,@"OldPassword":self.txtOldPassword.text,@"Password":self.txtNewPassword.text,@"ConfirmPassword":self.txtReEnterPass.text,@"Phone1":strPhone,@"Email":strEmail,@"FirstName":strFirstName};

    
    NSString *strParam = [dictParams jsonStringWithPrettyPrint:YES];
    NSString *strUrl =[NSString stringWithFormat:@"%@/api/Loginapi/ChangePasswordMobile?UserId=%@&OldPassword=%@&ConfirmPassword=%@&Email=%@&FirstName=%@&PhoneNo=%@",kServerUrl,userId,self.txtOldPassword.text,self.txtReEnterPass.text,strEmail,strFirstName,strPhone];
        NSLog(@"%@",strUrl);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[NSURL URLWithString:strUrl]
                                    cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                    timeoutInterval:120.0f];
    
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    NSString *postString = strParam;
    NSData * data = [postString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[data length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:data];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!connectionError) {
            NSLog(@"response--%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            NSDictionary* responseDict = [NSJSONSerialization JSONObjectWithData:data
                                                                         options:kNilOptions
                                                                           error:nil];
            [MBProgressHUD hideHUDForView:self.view animated:YES];

            NSString *status = [responseDict objectForKey:@"status"];
            if ([status isEqualToString:@"SUCCESS"])
            {
            //    [[ICSingletonManager sharedManager] showAlertViewWithMsg:[responseDict objectForKey:@"errorMessage"] onController:self];
                
                NSDictionary  *dictUserModel = [[NSDictionary alloc] init];
                NSMutableDictionary *dictCleanedUserModel= [self cleanDictionary:[dict mutableCopy]];
                [dictCleanedUserModel setObject:self.txtNewPassword.text forKey:@"Password"];
                dictUserModel = [dictCleanedUserModel copy];
                
                LoginManager *loginManage = [[LoginManager alloc]init];
                [loginManage loginUserWithUserDataDictionary:dictUserModel ];
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:[responseDict objectForKey:@"errorMessage"] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *allowAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                    
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                                         bundle:[NSBundle mainBundle]];
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
                    //     }
                }];
                
                
                [alert addAction:allowAction];
               
                
               
                [self presentViewController:alert animated:YES completion:nil];
           
            
           
                
            }
            else if ([status isEqualToString:@"FAIL"])
            {
                [[ICSingletonManager sharedManager] showAlertViewWithMsg:[responseDict objectForKey:@"errorMessage"] onController:self];
            }
        } else{
            NSLog(@"error--%@",connectionError);
            [[ICSingletonManager sharedManager] showAlertViewWithMsg:connectionError.localizedDescription onController:self];

        [MBProgressHUD hideHUDForView:self.view animated:YES];
        } 
    }];
}


#pragma mark - TextField Validations methods
-(BOOL)validateTextFieldData{
    BOOL textFieldValidated =YES;
    BOOL ifTextOldPassEmpty = [self.txtOldPassword detectIfTextfieldIsEmpty:self.txtOldPassword.text];
    BOOL ifTextNewPassEmpty = [self.txtNewPassword detectIfTextfieldIsEmpty:self.txtNewPassword.text];
    
    BOOL ifTextReEnterPassEmpty  = [self.txtReEnterPass detectIfTextfieldIsEmpty:self.txtReEnterPass.text];
    if (![self.txtOldPassword.text isEqualToString:self.strOldPass]) {
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Old Password Not Correct" onController:self];
        textFieldValidated = NO;
    }else if (ifTextOldPassEmpty){
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Enter old password" onController:self];
        textFieldValidated = NO;
    }
    else if (ifTextNewPassEmpty) {
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Enter new password" onController:self];
        textFieldValidated = NO;
    }
    
    else if (ifTextReEnterPassEmpty){
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Re enter new password" onController:self];
        textFieldValidated = NO;
    }
    else if (![self.txtNewPassword.text isEqualToString:self.txtReEnterPass.text])
    {
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Password and Confirm Password not matched" onController:self];
        textFieldValidated = NO;
    }

    return textFieldValidated;
    
}

- (NSMutableDictionary *)cleanDictionary:(NSMutableDictionary *)dictionary {
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (obj == [NSNull null]) {
            [dictionary setObject:@"" forKey:key];
        } else if ([obj isKindOfClass:[NSDictionary class]]) {
            [self cleanDictionary:obj];
        }
    }];
    return  dictionary;
}
- (IBAction)btnSubmitTapped:(id)sender {
    [self startServiceToChangePassword];
}

#pragma  mark - UITextField Delegate Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)btnBackTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
