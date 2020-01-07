//
//  GiftedCouponCell.m
//  
//
//  Created by Vertical Logics on 06/05/16.
//
//

#import "GiftedCouponCell.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "LoginManager.h"
#import "NSDictionary+JsonString.h"

@implementation GiftedCouponCell
@synthesize lblCouponCodeValue,lblDayeOfStayValue,lblGiftedToValue,resendCredentialBtn;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)settingAllValuesFromDict:(NSDictionary *)dict{
    [self.lblCouponCodeValue setText:[dict valueForKey:@"CouponCode"]];
    
    [self.lblGiftedToValue setText:[NSString stringWithFormat:@"%@,%@",[dict valueForKey:@"FIRST_NAME"],[dict valueForKey:@"LAST_NAME"]]];
    [self.lblDayeOfStayValue setText:[[ICSingletonManager sharedManager] gettingNewlyFormattedDateStringFromString:[dict valueForKey:@"GiftDate"]]];
    
    
    
    
}
- (IBAction)btnSendCredentialsTapped:(id)sender {
    
    [self startServiceToResendCredentials];
//    [[ICSingletonManager sharedManager] showAlertViewWithMsg:@"Coming Soon" onController:self];


//    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Coming Soon" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    
//    [alert show];
}

-(void)startServiceToResendCredentials{
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    
    LoginManager *loginManage = [[LoginManager alloc]init];
    NSDictionary *dict = [loginManage isUserLoggedIn];
    NSString *strFirstName = [dict valueForKey:@"FirstName"];
    NSString *strLastName = [dict valueForKey:@"LastName"];
    NSString *strUserName = [dict valueForKey:@"UserName"];
    NSString *strPhone = [dict valueForKey:@"Phone1"];
    NSString *strEmail = [dict valueForKey:@"Email"];
    NSString *strPassword= [dict valueForKey:@"Password"];
//    NSNumber *num = [dict valueForKey:@"UserId"];
//    
//    NSDate *todayDate = [NSDate date]; // get today date
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; // here we create NSDateFormatter object for change the Format of date..
//    [dateFormatter setDateFormat:@"dd-MM-yyyy"]; //Here we can set the format which we need
//    NSString *convertedDateString = [dateFormatter stringFromDate:todayDate];// here convert date in
//    //    NSString NSLog("Today formatted date is %@",convertedDateString);
    
    NSDictionary *dictionary = @{@"FirstName":strFirstName,
                                 @"LastName":strLastName,
                                 @"UserName":strUserName,
                                 @"Password":strPassword,
                                 @"Phone1":strPhone,
                                 @"Email":strEmail};
    
    NSString *strJson = [dictionary jsonStringWithPrettyPrint:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    [manager.requestSerializer setValue:@"application/json; charset=utf-8"
                     forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:[NSString stringWithFormat:@"%@/api/CouponApi/ResendCredential",kServerUrl] parameters:strJson success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        
        NSLog(@"sucess");
      //  NSString *msg= [responseObject valueForKey:@"errorMessage"];
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Credentials resend successfully!" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        alert.delegate = self;
        [alert show];
        [MBProgressHUD hideHUDForView:self animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Credentials resend successfully!" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        alert.delegate = self;
        [alert show];

        [MBProgressHUD hideHUDForView:self animated:YES];
       // [[ICSingletonManager sharedManager] showAlertViewWithMsg:error.localizedDescription onController:self];
        
    }];

}
@end
