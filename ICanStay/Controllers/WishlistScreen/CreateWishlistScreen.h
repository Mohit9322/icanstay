//
//  CreateWishlistScreen.h
//  ICanStay
//
//  Created by Namit Aggarwal on 26/02/16.
//  Copyright (c) 2016 Harry Patel (Hitaishin). All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateWishlistScreen : UIViewController <UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    int selectPicker;
}
@property (nonatomic) BOOL isFromEdit;

/// Piker View
@property (strong, nonatomic) IBOutlet UIView *viewPicker;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;
@property (nonatomic, strong) NSString  *vouchercodeFromCreateWishlist;
/// Piker Action
- (IBAction)cancelPicker:(id)sender;
- (IBAction)donePicker:(id)sender;
- (IBAction)cancelButtonTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *blackTransparentView;

@property (strong,nonatomic) NSArray *arrayCouponList,*arrayFamilyStayList,*arrayWishTypeList,*arrayRoomsList,*arrayMonthList,*arrayDateList,*arrayDateTypeList,*arraySpecialDayList,*arrayPreferredDestinationList;
@property (strong,nonatomic) NSMutableArray *mArrayAreaNameList,*mArrayDestinationList;
@property (strong,nonatomic) NSDictionary *dictionaryCouponList,*selectedCouponList,*selectedCity;

@property (strong,nonatomic) NSArray *arrayWishList;

@end
