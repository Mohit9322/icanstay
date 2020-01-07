//
//  MakeAWishlistViewController.h
//  ICanStay
//
//  Created by Hitaishin on 29/12/16.
//  Copyright © 2016 verticallogics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MakeAWishlistViewController : UIViewController

@property (nonatomic) BOOL isFromEdit;
@property (strong, nonatomic) IBOutlet UILabel *lbl_MakeAWishList;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *opt_Constraint;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;
@property (strong, nonatomic) IBOutlet UITextField *txt_Voucher;
@property (strong, nonatomic) IBOutlet UITextField *txt_Destitation;
@property (strong, nonatomic) IBOutlet UIImageView *destitation_DD;
@property (strong, nonatomic) IBOutlet UIImageView *iml_Line1;
@property (strong, nonatomic) IBOutlet UILabel *lbl_Rooms;
@property (strong, nonatomic) IBOutlet UILabel *lbl_Title_Room;

@property (strong, nonatomic) IBOutlet UILabel *lbl_PreferredDates;

@property (strong, nonatomic) IBOutlet UIButton *btn_Increament;
@property (strong, nonatomic) IBOutlet UIButton *btn_Decreament;

@property (strong, nonatomic) IBOutlet UIButton *btn_Date;
@property (strong, nonatomic) IBOutlet UIButton *btn_Week;
@property (strong, nonatomic) IBOutlet UIButton *btn_Month;
@property (strong, nonatomic) IBOutlet UIButton *btn_SpclDay;

@property (strong, nonatomic) IBOutlet UITextField *txt_Year;
@property (strong, nonatomic) IBOutlet UIImageView *imgLine1;
@property (strong, nonatomic) IBOutlet UIImageView *dropDown1;
@property (strong, nonatomic) IBOutlet UIImageView *imgLine2;
@property (strong, nonatomic) IBOutlet UITextField *txt_Month;
@property (strong, nonatomic) IBOutlet UIImageView *dropDown2;
@property (strong, nonatomic) IBOutlet UITextField *txt_Date;
@property (strong, nonatomic) IBOutlet UIImageView *imgLine3;
@property (strong, nonatomic) IBOutlet UIImageView *dropDown3;

@property (strong, nonatomic) IBOutlet UIView *view_CheckBox;
@property (strong, nonatomic) IBOutlet UIButton *btn_CheckBox;
@property (strong, nonatomic) IBOutlet UILabel *lbl_MSG_Box1;
@property (strong, nonatomic) IBOutlet UIButton *btn_Check_Box2;
@property (strong, nonatomic) IBOutlet UILabel *lbl_MSG_CheckBox2;

@property (strong, nonatomic) IBOutlet UIButton *btnAddToWishList;
@property (weak, nonatomic) IBOutlet UITableView *tbl_List;
/// Piker View
@property (strong, nonatomic) IBOutlet UIView *viewPicker;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;

@property (nonatomic, strong) NSString *couponCodeFromMyWishlist;

/// Piker Action
- (IBAction)cancelPicker:(id)sender;
- (IBAction)donePicker:(id)sender;



- (IBAction)doClickonCheck_Box2:(id)sender;
- (IBAction)doClickonCheckBox:(id)sender;
- (IBAction)doClickonDate:(id)sender;
- (IBAction)doClickonWeek:(id)sender;
- (IBAction)doClickonMonth:(id)sender;
- (IBAction)doClickonSpclDay:(id)sender;

- (IBAction)doClickonDecreasRoom:(id)sender;
- (IBAction)doClickonIncreaseRoom:(id)sender;
- (IBAction)doClickonBack:(id)sender;
- (IBAction)doClickonNotification:(id)sender;
- (IBAction)doClickonAddToWishList:(id)sender;

@property (strong, nonatomic) NSArray *arrayWishList, *arrayMonthList, *arraySpecialDayList;

@property (strong, nonatomic) NSMutableArray *mArrayDestinationList, *arrayCouponList, *arrayValidCoupen;

@property (strong, nonatomic) NSDictionary *dictionaryCouponList, *selectedCouponList,*menageGSPData;


//Constraint Layout
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *HeaderViewHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *voucherLayout;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *destinationConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *yearConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *monthContraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *dateContraint;

@end
