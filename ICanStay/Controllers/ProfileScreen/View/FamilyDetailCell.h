//
//  FamilyDetailCell.h
//  ICanStay
//
//  Created by Vertical Logics on 16/03/16.
//  Copyright (c) 2016 Harry Patel (Hitaishin). All rights reserved.
//

#import <UIKit/UIKit.h>
@class FamilyProfileData;

@protocol FamilyDetailCellDelegate <NSObject>

- (void)editButtonTappedWithfamilyData:(FamilyProfileData *)familyData;
- (void)deleteButtonTappedWithFamilyData:(FamilyProfileData *)familyData;

@end

@interface FamilyDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblNameText;
@property (weak, nonatomic) IBOutlet UILabel *lblRelationText;
@property (weak, nonatomic) IBOutlet UILabel *lblGenderText;
@property (weak, nonatomic) IBOutlet UILabel *lblDOB;
@property (weak, nonatomic) IBOutlet UILabel *lblMobileNum;
@property (weak, nonatomic) IBOutlet UILabel *lblFamilyDetail;

@property (nonatomic)FamilyProfileData *familyData;

- (IBAction)btnDeleteTapped:(id)sender;
- (IBAction)btnEditTapped:(id)sender;


@property (nonatomic,weak)id<FamilyDetailCellDelegate>m_delegate;


- (void)settingfamilyDetailFromFamilyDetaildata:(FamilyProfileData *)data;
@end
