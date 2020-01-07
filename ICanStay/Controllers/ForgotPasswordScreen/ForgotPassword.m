//
//  ForgotPassword.m
//  ICanStay
//
//  Created by Namit Aggarwal on 25/02/16.
//  Copyright (c) 2016 Harry Patel (Hitaishin). All rights reserved.
//

#import "ForgotPassword.h"
#import "AFNetworking.h"
#import "MBProgressHud.h"
#import "UITextField+EmptyText.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#define ACCEPTABLE_CHARACTERS @"0123456789"
@interface ForgotPassword ()<UITextFieldDelegate>

- (IBAction)btnMenuTapped:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *forgotPwd;

@property (weak, nonatomic) IBOutlet UIView *viewBottom;
- (IBAction)btnSubmitTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;

@end

@implementation ForgotPassword

- (void)viewDidLoad {
    [super viewDidLoad];
     DLog(@"DEBUG-VC");
    // Do any additional setup after loading the view.
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    [tracker set:kGAIScreenName value:@"Forgot Password"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    [[ICSingletonManager sharedManager] addBottomMenuToViewController:self onView:self.viewBottom];
    [self addPaddingToTextFields];
    self.txtPassword.delegate = self;
    //The setup code (in viewDidLoad in your view controller)
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleFingerTap];
}

//The event handling method
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
   // CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    //Do stuff here...
    
    [self.view endEditing:YES];
}

- (void)addPaddingToTextFields{
    [self.txtPassword addPaddingToTextField];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Networking API Implementation

-(void)startServiceToForgotPassword
{
  //  self.txtPassword.text = @"9971983440";
    
    if (!self.txtPassword.text.length)
    {
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:kEnterValidPhoneNumber onController:self];
    }
    else if (self.txtPassword.text.length != 10)
    {
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:kEnterValidPhoneNumber onController:self];
    }
    else
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
          [self.txtPassword resignFirstResponder];
        NSString *strParams = [NSString stringWithFormat:@"registeredemail=%@",self.txtPassword.text];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        
        [manager.requestSerializer setValue:@"application/json; charset=utf-8"
                         forHTTPHeaderField:@"Content-Type"];
        
        
        
        [manager POST:[NSString stringWithFormat:@"%@/api/ForgotPasswordapi/ForgotPasswordapi?%@",kServerUrl,strParams] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"responseObject=%@",responseObject);
            
            NSLog(@"sucess");
            self.txtPassword.text =@"";
           
            NSString *msg= [responseObject valueForKey:@"errorMessage"];
             [MBProgressHUD hideHUDForView:self.view animated:YES];
           // NSString *status = [responseObject valueForKey:@"status"];
        //    [[ICSingletonManager sharedManager]showAlertViewWithMsg:msg onController:self];
            
            if ([[responseObject valueForKey:@"status"] isEqualToString:@"FAIL"]) {
                  [[ICSingletonManager sharedManager]showAlertViewWithMsg:msg onController:self];

            } else if ([[responseObject valueForKey:@"status"] isEqualToString:@"SUCCESS"]){
               
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                [alert addAction:defaultAction];
                
                // Present action where needed
                [self presentViewController:alert animated:YES completion:nil];
            }
           
            
          
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failure");
         [MBProgressHUD hideHUDForView:self.view animated:YES];
            [[ICSingletonManager sharedManager] showAlertViewWithMsg:error.localizedDescription onController:self];

        }];
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

- (IBAction)btnMenuTapped:(id)sender
{
  
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnSubmitTapped:(id)sender {
    [self startServiceToForgotPassword];
}

#pragma  mark - UITextField Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
// may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
{
    [textField resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length == 0 && [string isEqualToString:@" "]) {
        return NO;
    }
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERS] invertedSet];
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    if (textField == self.txtPassword) {
        if (range.location == 10 || ![string isEqualToString:filtered])
            return NO;
        return YES;
    } else {
        return YES;
        
    }
}

@end
