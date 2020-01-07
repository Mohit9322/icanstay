//
//  BuyCouponViewController.h
//  ICanStay
//
//  Created by Christina Masih on 22/03/16.
//  Copyright © 2016 verticallogics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Google/SignIn.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <Google/Analytics.h>
@interface BuyCouponViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,UIWebViewDelegate,GIDSignInUIDelegate>
{
    NSDictionary *facebookDict;
    int selectPicker;
    int direction;
    int shakes;
}
/// Piker View
@property (strong, nonatomic) IBOutlet UIView *viewPicker;
@property (strong, nonatomic) IBOutlet UIView *loginBuyVoucherBtnBaseView;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;
@property (strong, nonatomic) IBOutlet UIView *tcAndGenderSbiBaseView;
@property (strong, nonatomic) IBOutlet UIView *RegistrationBuyBaseview;
@property (strong, nonatomic) IBOutlet UIImageView *sbiChkBoxImgView;
@property (strong, nonatomic) IBOutlet UIButton *sbiChkBoxBtn;
@property (strong, nonatomic) IBOutlet UILabel *sbiPayOffLbl;

/// Piker Action
- (IBAction)cancelPicker:(id)sender;
- (IBAction)donePicker:(id)sender;

//outlets
@property (weak, nonatomic) IBOutlet UITextField *selectCouponCount;
@property (weak, nonatomic) IBOutlet UITextField *fname;
@property (weak, nonatomic) IBOutlet UITextField *lname;
@property (weak, nonatomic) IBOutlet UITextField *mobileNumber;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UIView *viewBottom;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (strong,nonatomic) NSArray *arrayCouponCount;

- (IBAction)buyCouponTap:(id)sender;
- (IBAction)backButtonTap:(id)sender;

- (IBAction)doClickonDecreasRoom:(id)sender;
- (IBAction)doClickonIncreaseRoom:(id)sender;

-(void)shake:(UITextField *)textfieldShakingAnimation :(NSString*)errorText;

@property (nonatomic)BOOL ifFromGiftedCoupon;

// Google Sign In Button
@property(weak, nonatomic) IBOutlet GIDSignInButton *signInGoogle;
// Facebook Sign In Button
@property (strong, nonatomic) IBOutlet UIButton *facebookButton;

@property (nonatomic, strong) NSNumber *numberOfVoucherRequired;

@end
