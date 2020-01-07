//
//  GiftVouchersViewController.h
//  ICanStay
//
//  Created by Hitaishin on 02/02/17.
//  Copyright © 2017 verticallogics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GiftVouchersViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
// Voucher Selection and PickerView 
@property (strong, nonatomic) IBOutlet UITextField *txt_Voucher;

// Voucher Recipient Details
@property (strong, nonatomic) IBOutlet UITextField *txt_Fname;
@property (strong, nonatomic) IBOutlet UITextField *txt_Lname;
@property (strong, nonatomic) IBOutlet UITextField *txt_Mobileno;
@property (strong, nonatomic) IBOutlet UITextField *txt_Emailid;
@property (strong, nonatomic) IBOutlet UIButton *btn_Male;
@property (strong, nonatomic) IBOutlet UIButton *btn_Female;
@property (strong, nonatomic) IBOutlet UIWebView *webview;

@property (strong, nonatomic) IBOutlet UIView *viewPicker;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;


// Select Date and Time text
@property (strong, nonatomic) IBOutlet UITextField *txt_selectDate;
@property (strong, nonatomic) IBOutlet UITextField *txt_SelectTime;

// Term and Condition Screen
@property (strong, nonatomic) IBOutlet UIView *blackTransparentView;
@property (strong, nonatomic) IBOutlet UIView *viewTermCond;
@property (strong, nonatomic) IBOutlet UITextView *txtv_Term;
@property (strong, nonatomic) IBOutlet UIButton *btnTermcond;
@property (strong, nonatomic) IBOutlet UIWebView *paymentWebview;

@end
