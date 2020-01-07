//
//  CanCashDetailTableViewCell.h
//  ICanStay
//
//  Created by Planet on 11/16/17.
//  Copyright © 2017 verticallogics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CanCashDetailTableViewCell : UITableViewCell
@property (nonatomic, strong) UITextView *cmmntLbl;
@property (nonatomic, strong)  UILabel *createdLbl;
@property (nonatomic, strong)  UILabel *priceLbl;
@property (nonatomic, strong)  UILabel *validItyDateLbl;
@property (nonatomic, strong)  UIImageView *epireImgView;
@property (nonatomic, strong)  UILabel     *expiresOnLbl;
@end
