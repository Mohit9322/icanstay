//
//  FamilyDetailScreen.h
//  ICanStay
//
//  Created by Vertical Logics on 15/03/16.
//  Copyright (c) 2016 Harry Patel (Hitaishin). All rights reserved.
//

#import <UIKit/UIKit.h>
@class FamilyProfileData;
@interface FamilyDetailScreen : UIViewController

@property (nonatomic,copy)NSString *strMaritalStatus;
@property (nonatomic)FamilyProfileData *profileData;
@property (weak, nonatomic) IBOutlet UIButton *btnADD;
@property (weak, nonatomic) IBOutlet UIButton *btnUpdate;

@end
