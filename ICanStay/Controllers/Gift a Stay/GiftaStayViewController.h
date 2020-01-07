//
//  GiftaStayViewController.h
//  ICanStay
//
//  Created by Hitaishin on 30/01/17.
//  Copyright © 2017 verticallogics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GiftaStayViewController : UIViewController

// Coupen Detail Outlet
@property (weak, nonatomic) IBOutlet UILabel *lblPriceCoupon;
@property (weak, nonatomic) IBOutlet UILabel *lblCouponName;
@property (weak, nonatomic) IBOutlet UILabel *lblCouponValidFrom;
@property (weak, nonatomic) IBOutlet UILabel *lblCouponValidTill;

// Coupen Count
@property (weak, nonatomic) IBOutlet UITextField *selectCouponCount;

// Gift Recipient Detail
@property (weak, nonatomic) IBOutlet UITextField *txt_Giftfname;
@property (weak, nonatomic) IBOutlet UITextField *txt_Giftlname;
@property (weak, nonatomic) IBOutlet UITextField *txt_GiftmobileNumber;
@property (weak, nonatomic) IBOutlet UITextField *txt_Giftemail;
@property (weak, nonatomic) IBOutlet UIButton *btnGiftRadioMale;
@property (weak, nonatomic) IBOutlet UIButton *btnGiftRadioFemale;

// Gift Your Detail
@property (weak, nonatomic) IBOutlet UITextField *txt_Yourfname;
@property (weak, nonatomic) IBOutlet UITextField *txt_Yourlname;
@property (weak, nonatomic) IBOutlet UITextField *txt_YourmobileNumber;
@property (weak, nonatomic) IBOutlet UITextField *txt_Youremail;
@property (weak, nonatomic) IBOutlet UIButton *btnYourRadioMale;
@property (weak, nonatomic) IBOutlet UIButton *btnYourRadioFemale;

// For Send Notification
@property (strong, nonatomic) IBOutlet UIButton *btn_SendNotification;
@property (strong, nonatomic) IBOutlet UITextField *txt_SelectDate;
@property (strong, nonatomic) IBOutlet UITextField *txt_SelectTime;
@property (strong, nonatomic) IBOutlet UIWebView *webViewTermCond;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightTermCondWebview;

@property (strong, nonatomic) IBOutlet UIButton *btn_TermCond;

// Date Picker View
@property (strong, nonatomic) IBOutlet UIView *viewDatePicker;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;

// Terms and Condition View and Black Tranparent view
@property (strong, nonatomic) IBOutlet UIView *transparentView;
@property (strong, nonatomic) IBOutlet UIView *viewTermsCond;
@property (strong, nonatomic) IBOutlet UITextView *txtViewTerm;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
