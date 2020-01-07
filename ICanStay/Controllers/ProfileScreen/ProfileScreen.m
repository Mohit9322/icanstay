//
//  ProfileScreen.m
//  ICanStay
//
//  Created by Namit Aggarwal on 25/02/16.
//  Copyright (c) 2016 Harry Patel (Hitaishin). All rights reserved.
//

#import "ProfileScreen.h"
#import "MBProgressHUD.h"
#import <AFNetworking.h>
#import "LoginManager.h"
#import "UserProfileData.h"
#import "FamilyProfileData.h"
#import "NSDictionary+JsonString.h"
#import "FamilyDetailScreen.h"
#import "FamilyDetailCell.h"
#import <QuartzCore/QuartzCore.h>

@interface ProfileScreen ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,FamilyDetailCellDelegate,NSCopying,NSURLSessionDelegate>
- (IBAction)btnBackTapped:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *viewBottom;

@property (weak, nonatomic) IBOutlet UITextField *txtUserName;
@property (weak, nonatomic) IBOutlet UITextField *txtEmailId;
@property (weak, nonatomic) IBOutlet UITextField *txtMobNum;
@property (weak, nonatomic) IBOutlet UITextField *txtGender;
@property (weak, nonatomic) IBOutlet UITextField *txtMaritalStatus;
@property (weak, nonatomic) IBOutlet UITextField *txtDOB;
@property (weak, nonatomic) IBOutlet UITextField *txtKids;

@property (weak, nonatomic) IBOutlet UITextField *txtCityOfBirth;



@property (weak, nonatomic) IBOutlet UITextField *txtTite;
@property (weak, nonatomic) IBOutlet UITextField *txtAddress;
@property (weak, nonatomic) IBOutlet UITextField *txtState;
@property (weak, nonatomic) IBOutlet UITextField *txtLastName;

@property (nonatomic)UserProfileData *userProfileData;
//@property (nonatomic)FamilyProfileData *familyData;
- (IBAction)btnEditTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnEdit;
@property (weak, nonatomic) IBOutlet UIButton *btnAddFamilyDetail;

- (IBAction)btnCancelTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (weak, nonatomic) IBOutlet UIView *viewDatePicker;
- (IBAction)cancelDatePickerTapped:(id)sender;
- (IBAction)doneDatePickerTapped:(id)sender;
- (IBAction)pickerValueChanged:(id)sender;

- (IBAction)btnAddFamilyDetaiTapped:(id)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constrainstHeightTblViewFamilyDetail;

@property (weak, nonatomic) IBOutlet UITableView *tblfamilyDetail;

@end

@implementation ProfileScreen

- (void)viewDidLoad {
    [super viewDidLoad];
     DLog(@"DEBUG-VC");
       
//    self.btnEdit.layer.cornerRadius = 10;
//    self.btnEdit.clipsToBounds = YES;
//    self.btnAddFamilyDetail.layer.cornerRadius = 10;
//    self.btnAddFamilyDetail.clipsToBounds = YES;
//    self.btnCancel.layer.cornerRadius = 10;
//    self.btnCancel.clipsToBounds = YES;
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    [tracker set:kGAIScreenName value:@"My Profile"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    // Do any additional setup after loading the view.
    [[ICSingletonManager sharedManager]addBottomMenuToViewController:self onView:self.viewBottom];
    [self startServiceTogetUserProfileData];
            [self.datePicker setMaximumDate:[NSDate date]];
}

- (void)disablingEditableTextFieldEnabled:(BOOL)isEnable{
//        [self.txtCityOfBirth setEnabled:isEnable];
        [self.txtDOB setEnabled:isEnable];
       // [self.txtEmailId setEnabled:isEnable];
        [self.txtGender setEnabled:isEnable];
        [self.txtKids setEnabled:isEnable];
        [self.txtAddress setEnabled:isEnable];
        [self.txtState setEnabled:isEnable];
        [self.txtMaritalStatus setEnabled:isEnable];
       // [self.txtMobNum setEnabled:isEnable];
        [self.txtUserName setEnabled:isEnable];
        //[self.txtTite setEnabled:isEnable];
       // [self.txtLastName setEnabled:isEnable];
    
}

//api/UserProfileApi/GetUserProfileDetailApi
-(void)startServiceTogetUserProfileData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    LoginManager *loginManage = [[LoginManager alloc]init];
    NSDictionary *dict = [loginManage isUserLoggedIn];
    NSNumber *num = [dict valueForKey:@"UserId"];
    
    NSDictionary *dictParams = @{@"userid":num};
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8"
                     forHTTPHeaderField:@"Content-Type"];
    NSString *strUrl =     [NSString stringWithFormat:@"%@/api/UserProfileApi/GetUserProfileDetailApiMobile?userid=%@",kServerUrl,num];
    
    [manager GET:strUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        
        
        self.userProfileData = [UserProfileData instanceFromDictionary:responseObject];
        [self removeNullFromAllUserDataObject];
        
        if (self.userProfileData.strProfilePic.length)
            [self replaceProfilePicInUserDefaults:loginManage withProfilePicString:self.userProfileData.strProfilePic];
        
        if ([self.userProfileData.strAniversaryDate isEqual:[NSNull null]]) {
            NSLog(@"NULL data");
        }
                [self settingAllDataValuesFromUserProfileData];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [[ICSingletonManager sharedManager] showAlertViewWithMsg:error.localizedDescription onController:self];

        
    }];

}

- (void)replaceProfilePicInUserDefaults:(LoginManager *)loginManage withProfilePicString:(NSString *)str{
    //Getting previously stored dictionary and updating below parameters

    NSDictionary *dictionaryPrev = [loginManage isUserLoggedIn];
    NSMutableDictionary *tempDict = [dictionaryPrev mutableCopy];
    
    
    NSLog(@"%@",tempDict);
    [tempDict removeObjectForKey:@"ProfilePic"];
    
    [tempDict setObject:str forKey:@"ProfilePic"];
    
    //Removing previous dictionary and saving new dictionary to local userdefaults
    [loginManage loginUserWithUserDataDictionary:[tempDict copy]];
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

- (IBAction)btnBackTapped:(id)sender {
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
    
    if (globals.isFromMenu)
    {
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    }
    else
    {
          globals.isFromMenu = YES;
        [self.navigationController popViewControllerAnimated:YES];
    }
//    [self.navigationController popViewControllerAnimated:YES];
}

- (void)settingAllDataValuesFromUserProfileData{
    //Displaying these 4 values from local dictionary object which we when user gets loggedin
    [self.txtUserName setText:self.userProfileData.strUserFirstName];
    [self.txtEmailId setText:self.userProfileData.strUserEmail];
    [self.txtMobNum setText:self.userProfileData.strUserName];
    [self.txtGender setText:[[ICSingletonManager sharedManager]gettingGenderFromString:self.userProfileData.strUserGender]];
    [self.txtMaritalStatus setText:self.userProfileData.strMaritalStatus];
    [self.txtDOB setText:[[ICSingletonManager sharedManager] returnFormatedStringDateFromString:self.userProfileData.strDOB]];
    [self.txtKids setText:[self.userProfileData.numOfKids stringValue]];
    [self.txtLastName setText:self.userProfileData.strUserLastName];
    [self.txtTite setText:self.userProfileData.strUserTitle];
    [self.txtAddress setText:self.userProfileData.strUserAddress];
//    [self.txtCityOfBirth setText:self.userProfileData.strCityLiving];
    [self.txtState setText:self.userProfileData.strUserState];
    if (self.userProfileData.arrUserFamilyInfoList.count >0) {
        [self.tblfamilyDetail reloadData];
        [self.constrainstHeightTblViewFamilyDetail setConstant:self.userProfileData.arrUserFamilyInfoList.count *200 ];
    }
}




- (void)removeNullFromAllUserDataObject{
    self.userProfileData.strAniversaryDate=      [self removeNullObjectFromString:self.userProfileData.strAniversaryDate];
    self.userProfileData.strCityLiving=          [self removeNullObjectFromString:self.userProfileData.strCityLiving];
    self.userProfileData.strCityWorking  =       [self removeNullObjectFromString:self.userProfileData.strCityWorking];
    self.userProfileData.strDOB =                [self removeNullObjectFromString:self.userProfileData.strDOB];
    self.userProfileData.strGender=              [self removeNullObjectFromString:self.userProfileData.strGender];
    self.userProfileData.strMaritalStatus=       [self removeNullObjectFromString:self.userProfileData.strMaritalStatus];
    self.userProfileData.numOfKids=              [self removeNullObjectFromNumber:self.userProfileData.numOfKids ];
    self.userProfileData.strProfilePic=          [self removeNullObjectFromString:self.userProfileData.strProfilePic];
    self.userProfileData.strUserFirstName =      [self removeNullObjectFromString:self.userProfileData.strUserFirstName];
    self.userProfileData.strUserGender =         [self removeNullObjectFromString:self.userProfileData.strUserGender];
    self.userProfileData.strUserName =           [self removeNullObjectFromString:self.userProfileData.strUserName];
    self.userProfileData.strUserEmail =          [self removeNullObjectFromString:self.userProfileData.strUserEmail];
    self.userProfileData.strUserState = [self removeNullObjectFromString:self.userProfileData.strUserState];
    self.userProfileData.strUserLastName = [self removeNullObjectFromString:self.userProfileData.strUserLastName];
    self.userProfileData.strUserAddress = [self removeNullObjectFromString:self.userProfileData.strUserAddress];
    self.userProfileData.strUserTitle = [self removeNullObjectFromString:self.userProfileData.strUserTitle];
    
    //self.userProfileData.strUserDetailId=   [self removeNullObjectFromString:self.userProfileData.strUserDetailId];
    //
}

- (NSNumber *)removeNullObjectFromNumber:(NSNumber *)num{
    NSNumber *numNew = [NSNumber numberWithInt:0];
    if ([num isEqual:[NSNull null]]) {
        numNew = [NSNumber numberWithInt:0];
    }
    else
        numNew = num;
    
    return numNew;
}

-(NSString *)removeNullObjectFromString:(NSString *)str{
    if ([str isEqual:[NSNull null]]) {
        str = @"";
    }
    
    return str;
}

- (IBAction)btnEditTapped:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if ([btn.currentTitle isEqualToString:@"UPDATE"]) {
        
        [self startServiceToUpdateUserProfile];
        
    }
    else{
        [self.btnEdit setTitle:@"UPDATE" forState:UIControlStateNormal];
        [self.btnCancel setHidden:NO];
        [self.btnAddFamilyDetail setHidden:YES];
        [self disablingEditableTextFieldEnabled:YES];
        [self.txtUserName becomeFirstResponder];
        
    }
}
- (IBAction)btnCancelTapped:(id)sender {
    
    [self.btnEdit setTitle:@"EDIT" forState:UIControlStateNormal];
    [self.btnCancel setHidden:YES];
    [self.btnAddFamilyDetail setHidden:NO];
    [self disablingEditableTextFieldEnabled:NO];
    
    
}

#pragma mark- UITextFieldDelegate Methods
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{        // return NO to disallow editing.
    if (textField == self.txtDOB) {
        [self.viewDatePicker setHidden:NO];
        [textField resignFirstResponder];
        [self.view endEditing:YES];

        return NO;
    }
            return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.text.length == 0 && [string isEqualToString:@" "]) {
        return NO;
    }
    if (textField == self.txtMobNum){
        
        return (textField.text.length >= 10 && range.length == 0) ? NO : YES;
        
//        if (self.txtMobNum.text.length >= 10) {
//            [[ICSingletonManager sharedManager] showAlertViewWithMsg:@"Mobile number cannot be greater than 10 digits" onController:self];
//            return NO;
//        }
    }

    
    return YES;
}// return NO to not change text

- (BOOL)textFieldShouldReturn:(UITextField *)textField{              // called when 'return' key pressed. return NO to ignore.
    [textField resignFirstResponder];
    return YES;
}
//- (void)textFieldDidEndEditing:(UITextField *)textField{             // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
//    [textField resignFirstResponder];
//}

- (void)startServiceToUpdateUserProfile{
    
   
  [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
   
    BOOL ifTextFieldEmpty = [self detectIfAnyTextFieldIsEmpty];
    if (!ifTextFieldEmpty) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Any fields cannot be blank" onController:self];
        return;
    }
      [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    LoginManager *loginManage = [[LoginManager alloc]init];
    NSDictionary *dict = [loginManage isUserLoggedIn];
    //NSLog(@"%@",dict);
    NSNumber *numUserId = [dict valueForKey:@"UserId"];
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *numOfKids = [f numberFromString:self.txtKids.text];
    NSNumber *userDetailid = [NSNumber numberWithInt:0];
    self.txtGender.text = @"M";
    NSArray *array = [[NSArray alloc]init];
    NSDictionary *dictParams = @{@"USER_ID":numUserId,
                                 @"TITLE":@"1",
                                 @"Gender":self.txtGender.text,
                                 @"FIRST_NAME":self.txtUserName.text,
                                 @"LAST_NAME":self.txtLastName.text,
                                 @"ADDRESS":self.txtAddress.text,
                                 @"CITY":@"newdelhi",
                                 @"STATE":self.txtState.text,
                                 @"ZIP":@"203206",
                                 @"PHONE1":self.txtMobNum.text,
                                 @"EMAIL":self.txtEmailId.text,
                                 @"userDetail":@{@"USER_Details_ID":userDetailid,
                                                 @"USER_ID":numUserId,
                                                 @"Gender":self.txtGender.text,
                                                 @"Marital_Status":@"Married",
                                                 @"Date_of_Birth":self.txtDOB.text,
                                                 @"Anniversary_Date":self.txtDOB.text,
                                                 @"NO_OF_KIDS":numOfKids,
                                                 @"City_Living":@"newdelhi",
                                                 @"City_Working":@"",
                                                 @"ProfilePic":@"",
                                                 @"userFamilyInfoList":array,
                                                 }
                                 };
    
    
    NSString *strParam = [dictParams jsonStringWithPrettyPrint:YES];
     NSError *error;
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
     NSString *str = [NSString stringWithFormat:@"%@/api/UserProfileApi/UpdateUserProfileApi",kServerUrl];
     NSURL *url = [NSURL URLWithString:str];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPMethod:@"POST"];
  
    NSData *postData = [NSJSONSerialization dataWithJSONObject:dictParams options:0 error:&error];
    [request setHTTPBody:postData];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
           
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers error: nil];
                NSString *status = [responseObject valueForKey:@"status"];
                NSString *msg = [responseObject valueForKey:@"errorMessage"];
                NSDictionary *dictionaryPrev = [loginManage isUserLoggedIn];
                NSMutableDictionary *tempDict = [dictionaryPrev mutableCopy];
                
                
                NSLog(@"%@",tempDict);
                [tempDict removeObjectForKey:@"FirstName"];
                [tempDict removeObjectForKey:@"Email"];
                [tempDict removeObjectForKey:@"UserName"];
                [tempDict removeObjectForKey:@"Gender"];
                [tempDict removeObjectForKey:@"Address"];
                [tempDict removeObjectForKey:@"City"];
                [tempDict removeObjectForKey:@"LastName"];
                [tempDict removeObjectForKey:@"Zip"];
                [tempDict removeObjectForKey:@"State"];
                
                [tempDict setObject:self.txtUserName.text forKey:@"FirstName"];
                [tempDict setObject:self.txtEmailId.text forKey:@"Email"];
                [tempDict setObject:self.txtMobNum.text forKey:@"UserName"];
                [tempDict setObject:[[ICSingletonManager sharedManager] gettingGenderFromString:self.txtGender.text] forKey:@"Gender"];
                [tempDict setObject:self.txtLastName.text forKey:@"LastName"];
                [tempDict setObject:@"New Delhi" forKey:@"City"];
                [tempDict setObject:@"0" forKey:@"Zip"];
                [tempDict setObject:self.txtAddress.text forKey:@"Address"];
                [tempDict setObject:self.txtState.text forKey:@"State"];
                //Removing previous dictionary and saving new dictionary to local userdefaults
                [loginManage loginUserWithUserDataDictionary:[tempDict copy]];
                NSLog(@"%@",tempDict);
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                //  [self startServiceTogetUserProfileData];
                
                [self.btnEdit setTitle:@"EDIT" forState:UIControlStateNormal];
                [self.btnCancel setHidden:YES];
                [self.btnAddFamilyDetail setHidden:NO];
                [self disablingEditableTextFieldEnabled:NO];
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                 [[ICSingletonManager sharedManager]showAlertViewWithMsg:msg onController:self];
            });
           
            
        }];
         [postDataTask resume];
    });
   
   
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
//    [manager.requestSerializer setValue:@"application/json; charset=utf-8"
//                     forHTTPHeaderField:@"Content-Type"];
//
//    NSString *str = [NSString stringWithFormat:@"%@/api/UserProfileApi/UpdateUserProfileApi",kServerUrl];
//    [manager POST:str parameters:strParam success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"responseObject=%@",responseObject);
//        NSString *msg= [responseObject valueForKey:@"errorMessage"];
//        NSString *status = [responseObject valueForKey:@"status"];
//
//
//        Getting previously stored dictionary and updating below parameters
//        NSDictionary *dictionaryPrev = [loginManage isUserLoggedIn];
//        NSMutableDictionary *tempDict = [dictionaryPrev mutableCopy];
//
//
//        NSLog(@"%@",tempDict);
//        [tempDict removeObjectForKey:@"FirstName"];
//        [tempDict removeObjectForKey:@"Email"];
//        [tempDict removeObjectForKey:@"UserName"];
//        [tempDict removeObjectForKey:@"Gender"];
//        [tempDict removeObjectForKey:@"Address"];
//        [tempDict removeObjectForKey:@"City"];
//        [tempDict removeObjectForKey:@"LastName"];
//        [tempDict removeObjectForKey:@"Zip"];
//        [tempDict removeObjectForKey:@"State"];
//
//        [tempDict setObject:self.txtUserName.text forKey:@"FirstName"];
//        [tempDict setObject:self.txtEmailId.text forKey:@"Email"];
//        [tempDict setObject:self.txtMobNum.text forKey:@"UserName"];
//        [tempDict setObject:[[ICSingletonManager sharedManager] gettingGenderFromString:self.txtGender.text] forKey:@"Gender"];
//         [tempDict setObject:self.txtLastName.text forKey:@"LastName"];
//         [tempDict setObject:@"New Delhi" forKey:@"City"];
//         [tempDict setObject:@"0" forKey:@"Zip"];
//          [tempDict setObject:self.txtAddress.text forKey:@"Address"];
//        [tempDict setObject:self.txtState.text forKey:@"State"];
//        //Removing previous dictionary and saving new dictionary to local userdefaults
//        [loginManage loginUserWithUserDataDictionary:[tempDict copy]];
//        NSLog(@"%@",tempDict);
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//
//      //  [self startServiceTogetUserProfileData];
//
//        [self.btnEdit setTitle:@"EDIT" forState:UIControlStateNormal];
//        [self.btnCancel setHidden:YES];
//        [self.btnAddFamilyDetail setHidden:NO];
//        [self disablingEditableTextFieldEnabled:NO];
//
//
//        [[ICSingletonManager sharedManager]showAlertViewWithMsg:msg onController:self];
//
//
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"failure");
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        [[ICSingletonManager sharedManager] showAlertViewWithMsg:error.localizedDescription onController:self];
//        [self.btnEdit setTitle:@"EDIT" forState:UIControlStateNormal];
//        [self.btnCancel setHidden:YES];
//        [self.btnAddFamilyDetail setHidden:NO];
//
//    }];
//
}

- (BOOL)detectIfAnyTextFieldIsEmpty{
    if ( !self.txtDOB.text.length|| !self.txtEmailId.text.length||
        !self.txtGender.text.length||  ! self.txtKids.text.length|| !self.txtMaritalStatus.text.length|| !self.txtMobNum.text.length|| !self.txtUserName.text.length || !self.txtState.text.length || !self.txtAddress || !self.txtTite || !self.txtLastName) {
        return NO;
    }
    else
        return YES;
}

- (NSString *)gettingFormattedDateFromDate:(NSDate *)date{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    dateFormat.dateStyle=NSDateFormatterMediumStyle;
    [dateFormat setDateFormat:@"dd MMM yyyy"];
    NSString *str=[NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:date]];
    return str;
}


- (IBAction)cancelDatePickerTapped:(id)sender {
    [self.viewDatePicker setHidden:YES];
}

- (IBAction)doneDatePickerTapped:(id)sender {
    [self.viewDatePicker setHidden:YES];
}

- (IBAction)pickerValueChanged:(id)sender {
    
    UIDatePicker *datePicker = (UIDatePicker *)sender;
    NSString *str = [self gettingFormattedDateFromDate:datePicker.date];
    [self.txtDOB setText:str];
}


- (IBAction)btnAddFamilyDetaiTapped:(id)sender {
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshingProfileDetailOnNewFamilyMemberAdded) name:kUpdateFamilyDetail object:nil];
    
    FamilyDetailScreen *familyDetail = [self.storyboard instantiateViewControllerWithIdentifier:@"FamilyDetailScreen"];
    [self.navigationController pushViewController:familyDetail animated:YES];
}

- (void)refreshingProfileDetailOnNewFamilyMemberAdded{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [self startServiceTogetUserProfileData];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


#pragma mark - UITableViewDelegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.userProfileData.arrUserFamilyInfoList count];
    //[catagorry count];    //count number of row from counting array hear cataGorry is An Array
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    FamilyDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FamilyDetailCell"];
    [cell.lblFamilyDetail setText:[NSString stringWithFormat:@"Family Detail %i",(indexPath.row+1)]];
    cell.m_delegate =self;
    FamilyProfileData *data = [self.userProfileData.arrUserFamilyInfoList objectAtIndex:indexPath.row];
    
    [cell settingfamilyDetailFromFamilyDetaildata:data];
    
    
   
    return cell;
}


//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//}

#pragma mark - FamilyDetailCellDelegate Methods
- (void)editButtonTappedWithfamilyData:(FamilyProfileData *)familyData
{
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshingProfileDetailOnNewFamilyMemberAdded) name:kUpdateFamilyDetail object:nil];
    FamilyDetailScreen *familyDetail = [self.storyboard instantiateViewControllerWithIdentifier:@"FamilyDetailScreen"];
    familyDetail.profileData = familyData;
    [self.navigationController pushViewController:familyDetail animated:YES];
    
}

- (void)deleteButtonTappedWithFamilyData:(FamilyProfileData *)familyData
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    LoginManager *loginManage = [[LoginManager alloc]init];
    NSDictionary *dict = [loginManage isUserLoggedIn];
    NSNumber *num = [dict valueForKey:@"UserId"];
    
//    NSDictionary *dictParams = @{@"user_id":num,@"familyinfo_ID":familyData.numFamilyInfoId};
//    NSString *strParam = [dictParams jsonStringWithPrettyPrint:YES];
    
    NSString *strUrl =[NSString stringWithFormat:@"%@/api/UserProfileApi/DeleteUserFamilyDetailApi?faminfo_ID=%@&user_id=%@",kServerUrl,familyData.numFamilyInfoId,num];
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[NSURL URLWithString:strUrl]
                                    cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                    timeoutInterval:120.0f];
    
    [request setHTTPMethod:@"DELETE"];
      [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!connectionError) {
            NSLog(@"response--%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            
            NSDictionary *dictResp = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers error: nil];
            NSString *status =[dictResp valueForKey:@"status"];
            if([status isEqualToString:@"SUCCESS"]){
                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

                [self startServiceTogetUserProfileData];
            }
            
            
        } else{
            NSLog(@"error--%@",connectionError);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];
    
    
    

    
}

@end
