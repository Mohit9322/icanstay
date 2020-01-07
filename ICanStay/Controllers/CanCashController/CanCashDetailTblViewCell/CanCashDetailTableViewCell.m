//
//  CanCashDetailTableViewCell.m
//  ICanStay
//
//  Created by Planet on 11/16/17.
//  Copyright © 2017 verticallogics. All rights reserved.
//

#import "CanCashDetailTableViewCell.h"

@implementation CanCashDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.cmmntLbl = [[UITextView alloc]init];
        self.cmmntLbl.textAlignment = NSTextAlignmentLeft;
        self.cmmntLbl.userInteractionEnabled = NO;
        self.cmmntLbl.scrollEnabled = NO;
        self.cmmntLbl.font =   [UIFont fontWithName:@"Helvetica" size:16.0];
        [self addSubview:self.cmmntLbl];
  
        self.createdLbl = [[UILabel alloc]init];
        self.createdLbl.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.createdLbl];
        
        self.priceLbl = [[UILabel alloc]init];
        self.priceLbl.textAlignment = NSTextAlignmentRight;
        self.priceLbl.font = [UIFont boldSystemFontOfSize:23];
        [self addSubview:self.priceLbl];
        
        self.validItyDateLbl = [[UILabel alloc]init];
        self.validItyDateLbl.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.validItyDateLbl];
     
        self.expiresOnLbl = [[UILabel alloc]init];
        self.expiresOnLbl.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.expiresOnLbl];
        
        self.epireImgView = [[UIImageView alloc]init];
        self.epireImgView.image = [UIImage imageNamed:@"expiredImg"];
        [self addSubview:self.epireImgView];
    }
    
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
