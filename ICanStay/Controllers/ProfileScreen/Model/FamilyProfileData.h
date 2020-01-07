//
//  FamilyProfileData.h
//  ICanStay
//
//  Created by Vertical Logics on 14/03/16.
//  Copyright (c) 2016 Harry Patel (Hitaishin). All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FamilyProfileData : NSObject

@property (nonatomic)NSNumber *numFamilyInfoId;
@property (nonatomic)NSNumber *numRelationId;
@property (nonatomic,copy)NSString *strRelationName;
@property (nonatomic,copy)NSString *strName;
@property (nonatomic,copy)NSString *strEmpStatus;
@property (nonatomic,copy)NSString *strEmailId;
@property (nonatomic,copy)NSString *strMobile;
@property (nonatomic,copy)NSString *strGender;
@property (nonatomic,copy)NSString *strDOB;
@property (nonatomic,copy)NSString *strExtraInfo;
//@property (nonatomic,copy)NSString *strStatus;
+(FamilyProfileData *)instanceFromDictionary:(NSDictionary *)dict;

@end
