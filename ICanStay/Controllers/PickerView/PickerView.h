//
//  PickerView.h
//  ICanStay
//
//  Created by Vertical Logics on 04/03/16.
//  Copyright (c) 2016 Harry Patel (Hitaishin). All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PickerViewDelegate <NSObject>

- (void)gettingUserSelectedEvents:(id )obj;

@end

@interface PickerView : UIView

@property (nonatomic,weak) id<PickerViewDelegate> m_delegate;
@property (nonatomic)NSMutableArray *arrPickerData;
- (void)addingDataInArrForPickerViewFromArray:(NSArray *)arr;
- (void)createPickerView;
@property BOOL isCityData;
@end
