//
//  RefundCouponCell.h
//  
//
//  Created by Vertical Logics on 16/05/16.
//
//

#import <UIKit/UIKit.h>

@protocol RefundCouponCellDelegate <NSObject>

- (void)addOrRemoveCouponFromArray:(NSString *)strCouponCode;

@end

@class RefundListData;
@interface RefundCouponCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblCouponCode;
@property (weak, nonatomic) IBOutlet UILabel *lblValidFrom;
@property (weak, nonatomic) IBOutlet UILabel *lblValidTill;
@property (weak, nonatomic) IBOutlet UIButton *btnSelect;

@property (nonatomic,weak)id <RefundCouponCellDelegate>m_delegate;

- (IBAction)btnSelectTapped:(id)sender;

- (void)settingRefundValuesFrom:(RefundListData *)refundData;
@property (nonatomic,retain)RefundListData *refundData;
@end
