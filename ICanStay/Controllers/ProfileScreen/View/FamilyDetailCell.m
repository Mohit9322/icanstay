//
//  FamilyDetailCell.m
//  ICanStay
//
//  Created by Vertical Logics on 16/03/16.
//  Copyright (c) 2016 Harry Patel (Hitaishin). All rights reserved.
//

#import "FamilyDetailCell.h"
#import "FamilyProfileData.h"
@implementation FamilyDetailCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)btnDeleteTapped:(id)sender {
    if ([self.m_delegate respondsToSelector:@selector(deleteButtonTappedWithFamilyData:)]) {
        [self.m_delegate deleteButtonTappedWithFamilyData:self.familyData];
    }

    
}

- (IBAction)btnEditTapped:(id)sender {
    
    if ([self.m_delegate respondsToSelector:@selector(editButtonTappedWithfamilyData:)]) {
        [self.m_delegate editButtonTappedWithfamilyData:self.familyData];
    }
    
    
}

- (void)settingfamilyDetailFromFamilyDetaildata:(FamilyProfileData *)data{
    
    if (data.strDOB.length)
        [self.lblDOB setText:[[ICSingletonManager sharedManager]returnFormatedStringDateFromString:data.strDOB]];

    [self.lblGenderText setText:[[ICSingletonManager sharedManager] gettingGenderFromString:data.strGender]];
    [self.lblMobileNum setText:data.strMobile];
    [self.lblNameText setText:data.strName];
    [self.lblRelationText setText:data.strRelationName];
    self.familyData = data;
}
@end
