//
//  MyWishlistViewController.h
//  ICanStay
//
//  Created by Christina Masih on 22/03/16.
//  Copyright © 2016 verticallogics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyWishlistViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    int selectPicker;
}
/// Piker View
@property (strong, nonatomic) IBOutlet UIView *viewPicker;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;

/// Piker Action
//- (IBAction)cancelPicker:(id)sender;
//- (IBAction)donePicker:(id)sender;

@property (strong,nonatomic) NSArray          *arrayWishList;
@property (strong,nonatomic) NSMutableArray   *arrayCouponList;
@property (strong,nonatomic) NSString         *selectedIndexCouponCodeMyVoucher;
@property (strong, nonatomic) NSString        *isFromPurchasedVooucherScreen;
@property (strong, nonatomic) NSString        *alertMasgFromPurchasedVoucher;
@end
