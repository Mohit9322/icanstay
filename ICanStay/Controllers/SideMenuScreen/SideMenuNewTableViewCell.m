//
//  SideMenuNewTableViewCell.m
//  ICanStay
//
//  Created by Planet on 11/7/17.
//  Copyright © 2017 verticallogics. All rights reserved.
//

#import "SideMenuNewTableViewCell.h"

@implementation SideMenuNewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.baseView = [[UIView alloc]init];
        self.baseView.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:self.baseView];
        
        self.cellNameLbl = [[UILabel alloc]init];
        self.cellNameLbl.backgroundColor = [UIColor whiteColor];
        [self.baseView addSubview:self.cellNameLbl];
        
        self.newLbl = [[UILabel alloc]init];
        self.NewLbl.text = @"New!";
        self.NewLbl.backgroundColor = [UIColor redColor];
        self.NewLbl.textColor = [UIColor whiteColor];
        [self.baseView addSubview:self.cellNameLbl];
        
      
    }
    
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
