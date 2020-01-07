//
//  RefundCouponScreen.m
//  
//
//  Created by Vertical Logics on 12/05/16.
//
//

#import "RefundCouponScreen.h"
#import "MBProgressHUD.h"
#import <AFNetworking.h>
#import "LoginManager.h"
#import "RefundCouponList.h"
#import "RefundListData.h"
#import "RefundReasonData.h"
#import "RefundCouponCell.h"
#import <QuartzCore/QuartzCore.h>
#import "MyCouponCollectionViewCell.h"
#import "ICSingletonManager.h"
#import "NotificationScreen.h"
#import "SideMenuController.h"
@interface RefundCouponScreen ()<RefundCouponCellDelegate, UIAlertViewDelegate,UITextViewDelegate>

@property NSArray *arrayCouponList, *arrayRejectOption;

@property NSMutableArray *arrSelectedCoupons;

@property NSNumber *numReasonId;

// Lable Refund Voucher Count
@property (strong, nonatomic) IBOutlet UILabel *lbl_RefundVoucher;

@property (nonatomic,strong)RefundCouponList *refundListData;


@property (strong, nonatomic) IBOutlet UICollectionView *clcView;

- (IBAction)btnBackTapped:(id)sender;

// Comments and reason View and Picker View
@property (strong, nonatomic) IBOutlet UIView *viewComment;
@property (strong, nonatomic) IBOutlet UIButton *txt_SelectReason;
@property (strong, nonatomic) IBOutlet UITextView *txtv_Comments;
@property (strong, nonatomic) IBOutlet UIView *viewPicker;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;


@end

@implementation RefundCouponScreen

- (void)viewDidLoad {
//    self.reqRefundBtn.layer.cornerRadius = 10;
//    self.reqRefundBtn.clipsToBounds = YES;
    [super viewDidLoad];
     DLog(@"DEBUG-VC");
    _viewComment.hidden = YES;
    
    _txtv_Comments.layer.borderWidth = 1;
    _txtv_Comments.layer.borderColor = [ICSingletonManager colorFromHexString:@"#bd9854"].CGColor;
    
    // Do any additional setup after loading the view.
        [self startServiceToGetCouponDetails];
    
}

-(void)viewDidLayoutSubviews
{
    [self.view layoutIfNeeded];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)startServiceToGetCouponDetails{
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    LoginManager *loginManage = [[LoginManager alloc]init];
    NSDictionary *dict = [loginManage isUserLoggedIn];
    NSLog(@"%@",dict);

    NSNumber *userId = [dict valueForKey:@"UserId"];

    //NSDictionary *dictParams = @{@"userID":[NSNumber numberWithInt:13]};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8"
                     forHTTPHeaderField:@"Content-Type"];
    
    
    [manager GET:[NSString stringWithFormat:@"%@/api/CouponApi/GetRefundCouponDetailMobile?userID=%@",kServerUrl,userId] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        self.refundListData = nil;
        NSDictionary *dict = (NSDictionary *)responseObject;
        NSLog(@"sucess");
        self.refundListData = [RefundCouponList instanceFromDictionary:dict];
        NSLog(@"%@",self.refundListData);
        
        self.arrayCouponList = [dict valueForKey:@"CouponDetails"];
        self.arrayRejectOption = [dict valueForKey:@"RefundReasonList"];
        
               
       
       _lbl_RefundVoucher.text = [NSString stringWithFormat:@"%lu", (unsigned long)[self.arrayCouponList count]];
       
        
        [self.clcView reloadData];
        [self.pickerView reloadAllComponents];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [[ICSingletonManager sharedManager] showAlertViewWithMsg:error.localizedDescription onController:self];
        
        
    }];

}

#pragma mark - CollectionView
#pragma mark DataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrayCouponList.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    NSDictionary *couponDictionary = [self.arrayCouponList objectAtIndex:indexPath.row];
    
    MyCouponCollectionViewCell *cell = (MyCouponCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    //    cell.couponStartDate.text = [NSString stringWithFormat:@"Valid From %@",[couponDictionary objectForKey:@"CreatedDate"]];
    cell.couponExpiryDate.text = [NSString stringWithFormat:@"VALID FROM %@ TO %@",[couponDictionary objectForKey:@"CreatedDate"],[couponDictionary objectForKey:@"ExpiryDate"]];
    cell.couponMessage.text = @"LUXURY STAY VOUCHER";
    cell.couponTitle.text = [couponDictionary objectForKey:@"CouponCode"];
    [cell.lblRefundRequested setText:[couponDictionary valueForKey:@"Refund_Status_Desc"]];
    [cell.lblUserName setText:[couponDictionary objectForKey:@"Name"]];
    
    cell.btn_Checkmark.tag = indexPath.row;
    [cell.btn_Checkmark addTarget:self action:@selector(doClickonCheckMark:) forControlEvents:UIControlEventTouchUpInside];
    
    [[cell.contentView viewWithTag:100] removeFromSuperview];
    if ([[couponDictionary valueForKey:@"Refund_Status"] isEqualToString:@"R"])
    {
        cell.alpha = 0.56f;
        //rgb(119,117,131)
        //        UIImageView *img_Front = [[UIImageView alloc]initWithFrame:cell.contentView.frame];
        //        img_Front.tag = 100;
        //        img_Front.backgroundColor = [UIColor colorWithRed:(119.0f/255.0f) green:(117.0f/255.0f) blue:(131.0f/255.0f) alpha:0.56f];
        //        [cell.contentView addSubview:img_Front];
        //        [cell.contentView bringSubviewToFront:img_Front];
        //cell.backgroundColor = [UIColor colorWithRed:0.501f green:0.501f blue:0.501f alpha:1];
        //[[ICSingletonManager sharedManager] addingBorderToUIView:cell withColor:[UIColor yellowColor]];
        [cell.lblRefundRequested setHidden:NO];
        
    }
    else
    {
        //cell.backgroundColor = [ICSingletonManager colorFromHexString:@"#BD9854"];
        //        cell.backgroundColor = [UIColor colorWithRed:0.93725f green:0.54901f blue:0.24705f alpha:1];
        //[[ICSingletonManager sharedManager] addingBorderToUIView:cell withColor:[UIColor lightGrayColor]];
        [cell.lblRefundRequested setHidden:YES];
    }
//    cell.couponTitle.font = [UIFont boldSystemFontOfSize:24.0];
//    cell.couponMessage.font = [UIFont systemFontOfSize:13.0];
//    cell.couponStartDate.font = [UIFont systemFontOfSize:11.0];
//    cell.couponExpiryDate.font = [UIFont systemFontOfSize:11.0];
    
//    if (IS_IPHONE_5) {
//        cell.couponTitle.font = [UIFont boldSystemFontOfSize:22.0];
//        cell.couponMessage.font = [UIFont systemFontOfSize:10.0];
//        cell.couponStartDate.font = [UIFont systemFontOfSize:10.0];
//        cell.couponExpiryDate.font = [UIFont systemFontOfSize:10.0];
//        
//    } else {
//        
//    }
    
    if ([self.arrSelectedCoupons containsObject:cell.couponTitle.text]) {
        [cell.btn_Checkmark setImage:[UIImage imageNamed:@"checkbox_selected"] forState:UIControlStateNormal];
    }
    else
        [cell.btn_Checkmark setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
    
    return cell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    //    if (IS_IPHONE_5) {
    //        return CGSizeMake(115, 130);
    //
    //    } else {
    return CGSizeMake(collectionView.frame.size.width-50, 140);
    //}
}
-(void)doClickonCheckMark:(UIButton *)sender
{
    NSDictionary *couponDictionary = [self.arrayCouponList objectAtIndex:sender.tag];
    NSString * strCouponCode = [couponDictionary objectForKey:@"CouponCode"];
    
    if (!self.arrSelectedCoupons.count) {
        self.arrSelectedCoupons = [[NSMutableArray alloc]init];
        UIAlertView *alrtView =  [[UIAlertView alloc] initWithTitle:@"" message:@"Rs.150 will be deducted as refund charges for each Voucher. Please confirm?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"NO", nil];
        alrtView.tag = sender.tag;
        [alrtView show];
    }
    else if ([self.arrSelectedCoupons containsObject:strCouponCode]) {
        [self.arrSelectedCoupons removeObject:strCouponCode];
    }
    else
        [self.arrSelectedCoupons addObject:strCouponCode];
    
    NSLog(@"%@",self.arrSelectedCoupons);
    [_clcView reloadData];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSDictionary *couponDictionary = [self.arrayCouponList objectAtIndex:alertView.tag];
        NSString * strCouponCode = [couponDictionary objectForKey:@"CouponCode"];
        [self.arrSelectedCoupons addObject:strCouponCode];
        NSLog(@"%@",self.arrSelectedCoupons);
        [_clcView reloadData];
    }
    
}
- (IBAction)btnRefundVouchersTapped:(id)sender {
    if (self.arrSelectedCoupons.count != 0)
        _viewComment.hidden = NO;
    else{
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Please choose voucher for refund request" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (IBAction)btnRequestForRefundTapped:(id)sender {
    if ( self.numReasonId == nil){
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Please select reason" onController:self];
        return;
    }
    if ( self.txtv_Comments.text.length == 0){
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"Please select enter comment" onController:self];
        return;
    }

    LoginManager *loginManage = [[LoginManager alloc]init];
    NSDictionary *dict = [loginManage isUserLoggedIn];
    NSLog(@"%@",dict);
    NSString *strPassword =[dict valueForKey:@"Password"];
    NSString *strUsername = [dict valueForKey:@"UserName"];
    
    NSLog(@"%@%@",strPassword,strUsername);
    
    NSString *strCoupons = [self.arrSelectedCoupons componentsJoinedByString: @","];
    strCoupons = [strCoupons stringByAppendingString:@","];
    NSLog(@"%@",strCoupons);
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *strComments = @"";
    if (self.txtv_Comments.text.length)
        strComments= self.txtv_Comments.text ;
    if (!self.numReasonId) {
        self.numReasonId = [NSNumber numberWithInt:0];
    }
    
    NSString *authType = @"Basic ";
    NSString *authHeader = [NSString stringWithFormat:@"%@:%@",strUsername,strPassword];
    authHeader = [self toBase64String:authHeader];
    authHeader = [authType stringByAppendingString:authHeader];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8"
                     forHTTPHeaderField:@"Content-Type"];
    
    [manager.requestSerializer setValue:authHeader
                     forHTTPHeaderField:@"Authorization"];
    
    NSString *str = [NSString stringWithFormat:@"%@/api/CouponApi/RefundRequest?CouponCode=%@&RefundReasonId=%@&RefundComments=%@",kServerUrl,strCoupons,self.numReasonId,strComments];
    
    [manager GET:str parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        
        NSDictionary *dict = (NSDictionary *)responseObject;
        NSLog(@"%@",dict);
        
        [[ICSingletonManager sharedManager] showAlertViewWithMsg:[dict valueForKey:@"errorMessage"] onController:self];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            LoginManager *login = [[LoginManager alloc]init];
            if ([[login isUserLoggedIn] count]>0)
            {
                SideMenuController *vcSideMenu = [[SideMenuController alloc]init];
                [vcSideMenu startServiceToGetCouponsDetails];
            }
        });
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [[ICSingletonManager sharedManager] showAlertViewWithMsg:error.localizedDescription onController:self];
        
    }];
}
#pragma mark - TextField Delegate
- (IBAction)didTappedonSelectReason:(id)sender {
    self.pickerView.backgroundColor = [UIColor whiteColor];
    [self.viewPicker setHidden:NO];
}


#pragma mark - Text View Delegate
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return YES;
}
#pragma mark Picker View Delegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}


-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    int count=0;
    count = (int)[self.arrayRejectOption count];
    return count;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    NSString *title;
    UILabel* tView = (UILabel*)view;
    if (!tView)
    {
        tView = [[UILabel alloc] init];
        [tView setNumberOfLines:1];
        [tView setFont:[UIFont systemFontOfSize:17]];
        [tView setTextAlignment:NSTextAlignmentCenter];
    }
    
    title = [[self.arrayRejectOption valueForKey:@"Refund_Reason"] objectAtIndex:row];
    
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    tView.attributedText=attString;
    
    return tView;
}

- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated
{
    [self.pickerView selectRow:0 inComponent:0 animated:YES];
}

#pragma mark - PickerView Done and Cancel Button Action
- (IBAction)btnCancelTappedonPickerview:(id)sender {
    [self.viewPicker setHidden:YES];
}
- (IBAction)btnDoneTappedonPickerview:(id)sender {
    [self.viewPicker setHidden:YES];
    if ([self.pickerView selectedRowInComponent:0] != 0) {
        NSString *strReason =[[self.arrayRejectOption valueForKey:@"Refund_Reason"] objectAtIndex:[self.pickerView selectedRowInComponent:0]];
        [self.txt_SelectReason setTitle:strReason forState:UIControlStateNormal];
        [self.txt_SelectReason setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _numReasonId = [[self.arrayRejectOption valueForKey:@"Reason_Id"] objectAtIndex:[self.pickerView selectedRowInComponent:0]];
    }
    else{
        [self.txt_SelectReason setTitleColor:[ICSingletonManager colorFromHexString:@"#bd9854"] forState:UIControlStateNormal];
        [self.txt_SelectReason setTitle:@"Select Reason" forState:UIControlStateNormal];
        _numReasonId = nil;
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



//- (IBAction)btnRequestRefundTapped:(id)sender {
//    if (self.arrSelectedCoupons.count==0){
//        [[ICSingletonManager sharedManager]showAlertViewWithMsg:@"select coupon " onController:self];
//        return;
//    }
//    
//    LoginManager *loginManage = [[LoginManager alloc]init];
//    NSDictionary *dict = [loginManage isUserLoggedIn];
//    NSLog(@"%@",dict);
//    NSString *strPassword =[dict valueForKey:@"Password"];
//    NSString *strUsername = [dict valueForKey:@"UserName"];
//    
//    NSLog(@"%@%@",strPassword,strUsername);
//    
//    NSString *strCoupons = [self.arrSelectedCoupons componentsJoinedByString: @","];
//    strCoupons = [strCoupons stringByAppendingString:@","];
//    NSLog(@"%@",strCoupons);
//    
//    
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    NSString *strComments = @"";
//    if (self.txtEnterComments.text.length)
//     strComments= self.txtEnterComments.text ;
//    if (!self.numReasonId ) {
//        self.numReasonId = [NSNumber numberWithInt:0];
//    }
//    
//    NSString *authType = @"Basic ";
//    NSString *authHeader = [NSString stringWithFormat:@"%@:%@",strUsername,strPassword];
//    authHeader = [self toBase64String:authHeader];
//    authHeader = [authType stringByAppendingString:authHeader];
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
//    [manager.requestSerializer setValue:@"application/json; charset=utf-8"
//                     forHTTPHeaderField:@"Content-Type"];
//    
//    [manager.requestSerializer setValue:authHeader
//                     forHTTPHeaderField:@"Authorization"];
//    
//    
//    
//    [manager GET:[NSString stringWithFormat:@"%@/api/CouponApi/RefundRequest?CouponCode=%@&RefundReasonId=%@&RefundComments=%@",kServerUrl,strCoupons,self.numReasonId,strComments] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"responseObject=%@",responseObject);
//        
//        NSDictionary *dict = (NSDictionary *)responseObject;
//        NSLog(@"%@",dict);
//        
//        [[ICSingletonManager sharedManager] showAlertViewWithMsg:[dict valueForKey:@"errorMessage"] onController:self];
//        
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        [self startServiceToGetCouponDetails];
//        
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"failure");
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        [[ICSingletonManager sharedManager] showAlertViewWithMsg:error.localizedDescription onController:self];
//        
//    }];
// 
//    
//}

- (NSString *)toBase64String:(NSString *)string {
    NSData *data = [string dataUsingEncoding: NSUTF8StringEncoding];
    
    NSString *base64Encoded = [data base64EncodedStringWithOptions:0];
    
    return base64Encoded;
}

#pragma mark - RefundCouponCellDelegate Methods

- (void)addOrRemoveCouponFromArray:(NSString *)strCouponCode{
//    if (!self.arrSelectedCoupons)
//        self.arrSelectedCoupons = [[NSMutableArray alloc]init];
//        
//    if ([self.arrSelectedCoupons containsObject:strCouponCode]) {
//        [self.arrSelectedCoupons removeObject:strCouponCode];
//    }
//    else
//        [self.arrSelectedCoupons addObject:strCouponCode];
//    
//    NSLog(@"%@",self.arrSelectedCoupons);
    

}

#pragma Mark - UItextFieldDelegate Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
    
}// called when 'return' key pressed. return NO to ignore.


- (IBAction)btnBackTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnNotificationBellTapped:(id)sender {
    ICSingletonManager *globals = [ICSingletonManager sharedManager];
    globals.isWithoutLoginNoti = false;
    NotificationScreen *notification = [self.storyboard instantiateViewControllerWithIdentifier:@"NotificationScreen"];
    [self.navigationController pushViewController:notification animated:YES];
}
@end
