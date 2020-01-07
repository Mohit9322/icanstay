//
//  FamilyDetailScreen.m
//  ICanStay
//
//  Created by Vertical Logics on 15/03/16.
//  Copyright (c) 2016 Harry Patel (Hitaishin). All rights reserved.
//

#import "FamilyDetailScreen.h"
#import <MBProgressHUD.h>
#import <AFNetworking.h>
#import "LoginManager.h"
#import "RelationList.h"
#import "RelationData.h"
#import "NSDictionary+JsonString.h"
#import "FamilyProfileData.h"
#import <QuartzCore/QuartzCore.h>
@interface FamilyDetailScreen ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtRelation;

@property (weak, nonatomic) IBOutlet UITextField *txtGender;
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtDOB;
@property (weak, nonatomic) IBOutlet UITextField *txtMobileNumber;

@property (weak, nonatomic) IBOutlet UITableView *tblRelation;
@property (nonatomic)RelationList *relationList;
@property (nonatomic)RelationData *relationData;

@property (nonatomic,copy)NSString *strRelationGender;
@property (weak, nonatomic) IBOutlet UIButton *btnBackTapped;
- (IBAction)btnBackTapped:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *viewDatePicker;

- (IBAction)pickerValueChanged:(id)sender;

- (IBAction)btnDoneTapped:(id)sender;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
- (IBAction)btnSubmitTapped:(id)sender;
- (IBAction)btnUpdateTapped:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *addBtn;
@property (strong, nonatomic) IBOutlet UIButton *updateBtn;

@end

@implementation FamilyDetailScreen

- (void)viewDidLoad {
//    self.addBtn.layer.cornerRadius = 10;
//    self.addBtn.clipsToBounds = YES;
//    self.updateBtn.layer.cornerRadius = 10;
//    self.updateBtn.clipsToBounds = YES;
    [super viewDidLoad];
     DLog(@"DEBUG-VC");
    // Do any additional setup after loading the view.
//    self.btnADD.layer.cornerRadius = 10;
//    self.btnUpdate.clipsToBounds = YES;
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    [tracker set:kGAIScreenName value:@"Add Family Detail"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    if (!self.profileData) {
        [self startServiceToGetReation];
        [self.btnUpdate setHidden:YES];
        [self.btnADD setHidden:NO];


    }
    else{
        [self settingRelationDatafromFamilyDetail];
        [self.btnUpdate setHidden:NO];
        [self.btnADD setHidden:YES];

    }
    
    [self enterPlaceholderText];
    
    [self.datePicker setMaximumDate:[NSDate date]];

}


- (void)settingRelationDatafromFamilyDetail
{
    NSLog(@"%@",self.profileData);
   
    [self.txtRelation setText:self.profileData.strRelationName];
    [self.txtName setText:self.profileData.strName];
    [self.txtMobileNumber setText:self.profileData.strMobile];
    [self.txtGender setText:[[ICSingletonManager sharedManager] gettingGenderFromString:self.profileData.strGender]];
    [self.txtDOB setText:[[ICSingletonManager sharedManager]returnFormatedStringDateFromString:self.profileData.strDOB]];
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WEBSERVICE METHODS
- (void)startServiceToGetReation{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if (!self.strMaritalStatus.length) {
        self.strMaritalStatus =@"";
        NSLog(@"%lu",(unsigned long)self.strMaritalStatus.length);
                NSLog(@"%@",self.strMaritalStatus);
    }
    
    NSDictionary *dictParams = @{@"maritalStatus":@"Married"};
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8"
                     forHTTPHeaderField:@"Content-Type"];
    
    
    [manager GET:[NSString stringWithFormat:@"%@/api/UserProfileApi/GetUserRelationListApi?",kServerUrl] parameters:dictParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        
        self.relationList = [RelationList instanceFromArray:(NSArray *)responseObject];
        NSLog(@"sucess");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [[ICSingletonManager sharedManager] showAlertViewWithMsg:error.localizedDescription onController:self];

    }];

}


#pragma mark - UITextFieldDelegate Methods
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField       // return NO to disallow editing.
{    
    
    if (textField == self.txtRelation) {
        [self.tblRelation reloadData];
        [self.tblRelation setHidden:NO];
        [textField resignFirstResponder];
        [self.view endEditing:YES];
        return NO;
    }
    else if  (textField == self.txtDOB) {
        [self.viewDatePicker setHidden:NO];
        [textField resignFirstResponder];
        [self.view endEditing:YES];
        
        return NO;
    }
    else
        [self.tblRelation setHidden:YES];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField           // called when 'return' key pressed. return NO to ignore.
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UITableViewDelegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.relationList.arrRelationList count];
    //[catagorry count];    //count number of row from counting array hear cataGorry is An Array
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RelationCell"];
    RelationData *relation = [self.relationList.arrRelationList objectAtIndex:indexPath.row];
    [cell.textLabel setText:relation.strRelationName];
   
//    cell.lblDashboardItems.text = [self.arrDasboardItems objectAtIndex:indexPath.row];
//    [cell.imgVDashboardItems setImage:[UIImage imageNamed:[self.arrDasboardItems objectAtIndex:indexPath.row]]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSLog(@"%li",(long)indexPath.row);
    self.relationData =nil;
    self.relationData = [self.relationList.arrRelationList objectAtIndex:indexPath.row];
    [self.txtGender setText:[[ICSingletonManager sharedManager] gettingGenderFromString:self.relationData.strGender] ];
    [self.txtRelation setText:self.relationData.strRelationName];
    [self.tblRelation setHidden:YES];
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
- (IBAction)pickerValueChanged:(id)sender {
    
    UIDatePicker *datePicker = (UIDatePicker *)sender;
    NSString *str = [self gettingFormattedDateFromDate:datePicker.date];
    [self.txtDOB setText:str];
}


- (NSString *)gettingFormattedDateFromDate:(NSDate *)date{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc] init];
    dateFormat.dateStyle=NSDateFormatterMediumStyle;
    [dateFormat setDateFormat:@"dd MMM yyyy"];
    NSString *str=[NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:date]];
    return str;
}
- (IBAction)btnDoneTapped:(id)sender {
    [self.viewDatePicker setHidden:YES];
}
- (IBAction)btnSubmitTapped:(id)sender {
    
    [self startServiceToAddNewFamilyDetailWithFamilyId:nil withRelationId:self.relationData.numRelationId];
    
}

- (IBAction)btnUpdateTapped:(id)sender {
    
    [self startServiceToAddNewFamilyDetailWithFamilyId:self.profileData.numFamilyInfoId withRelationId:self.profileData.numRelationId];

}

#pragma mark - ADD FAMILY DETAIL API
-(void)startServiceToAddNewFamilyDetailWithFamilyId:(NSNumber *)famId withRelationId:(NSNumber *)relationId{
    
    BOOL ifValidated = [self validatingTextfieldData];
    if (!ifValidated) {
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Enter all fields" onController:self];
        return;
    }
    
    //tempbyNamit
   // self.relationData.strGender = @"M";
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    LoginManager *loginManage = [[LoginManager alloc]init];
    NSDictionary *dict = [loginManage isUserLoggedIn];
    NSNumber *numUserId = [dict valueForKey:@"UserId"];

    NSString *strDOB = [[ICSingletonManager sharedManager] gettingDateStringToBeSendInPastStayApiFromStrDate:self.txtDOB.text];
    NSNumber *numFamilyId = [NSNumber numberWithInt:0];
    if (famId != nil)
        numFamilyId = famId;
        
        
    
    NSDictionary *dictParams = @{@"Faminfo_ID":numFamilyId,
                                 @"USER_ID":numUserId,
                                 @"Relation_id":relationId,
                                 @"Relation_Name":self.txtRelation.text,
                                 @"Name":self.txtName.text,
                                 @"Emp_Status":@"",
                                 @"EmailId":@"",
                                 @"Mobile":self.txtMobileNumber.text,
                                 @"Gender":[[ICSingletonManager sharedManager] gettingGenderFromString:self.txtGender.text],
                                 @"DOB":strDOB,
                                 @"ExtraInfo":@"",
                                 @"Status":[NSNumber numberWithBool:YES]
                                 };
    
    NSString *strParams = [dictParams jsonStringWithPrettyPrint:YES];
    
    
    NSString *strUrl =[NSString stringWithFormat:@"%@/api/UserProfileApi/AddEditUserFamilyDetailApi",kServerUrl];
    NSLog(@"%@",strUrl);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[NSURL URLWithString:strUrl]
                                    cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                    timeoutInterval:120.0f];
    
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    NSString *postString = strParams;
    NSData * data = [postString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[data length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:data];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!connectionError) {
            NSLog(@"response--%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            
            NSDictionary *dictResp = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers error: nil];
            NSString *status =[dictResp valueForKey:@"status"];
            if([status isEqualToString:@"SUCCESS"]){
                [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateFamilyDetail object:nil];
            }
            [[ICSingletonManager sharedManager]showAlertViewWithMsg:[dictResp valueForKey:@"errorMessage"] onController:self ];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self enterPlaceholderText];
            
            
        } else{
            NSLog(@"error--%@",connectionError);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];
    
    
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
//    [manager.requestSerializer setValue:@"application/json; charset=utf-8"
//                     forHTTPHeaderField:@"Content-Type"];
//    
//    
//    [manager POST:[NSString stringWithFormat:@"%@/api/UserProfileApi/AddEditUserFamilyDetailApi",kServerUrl] parameters:strParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"responseObject=%@",responseObject);
//        
//        NSLog(@"sucess");
//        NSString *msg= [responseObject valueForKey:@"errorMessage"];
//        // NSString *status = [responseObject valueForKey:@"status"];
//        [[ICSingletonManager sharedManager]showAlertViewWithMsg:msg onController:self];
//        
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"failure");
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//    }];
//    
    
}


- (void)enterPlaceholderText{
    [self.txtDOB setPlaceholder:@"Enter D.O.B"];
    [self.txtGender setPlaceholder:@"Enter Gender"];
    [self.txtMobileNumber setPlaceholder:@"Enter Mobile Number"];
    [self.txtName setPlaceholder:@"Enter Name"];
    [self.txtRelation setPlaceholder:@"Enter Relation"];
    
//        [self.txtDOB setTextAlignment:NSTextAlignmentRight];
//        [self.txtGender setTextAlignment:NSTextAlignmentJustified];
//        [self.txtMobileNumber setTextAlignment:NSTextAlignmentJustified];
//        [self.txtName setTextAlignment:NSTextAlignmentJustified];
//        [self.txtRelation setTextAlignment:NSTextAlignmentJustified];
}

-(BOOL)validatingTextfieldData{
    
    if ( !self.txtGender.text.length || !self.txtName.text.length || !self.txtRelation.text.length) {
        return NO;
    }
    else
        return YES;
}

@end
