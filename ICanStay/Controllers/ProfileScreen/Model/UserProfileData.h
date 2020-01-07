//
//  UserProfileDate.h
//  ICanStay
//
//  Created by Vertical Logics on 14/03/16.
//  Copyright (c) 2016 Harry Patel (Hitaishin). All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserProfileData : NSObject
@property (nonatomic,copy)NSString *strAniversaryDate;
@property (nonatomic,copy)NSString *strCityLiving;
@property (nonatomic,copy)NSString *strCityWorking;
@property (nonatomic,copy)NSString *strDOB;
@property (nonatomic,copy)NSString *strGender;
@property (nonatomic,copy)NSString *strMaritalStatus;
@property (nonatomic)NSNumber *numOfKids;
@property (nonatomic,copy)NSString *strProfilePic;

//These properties are added when api changed

@property (nonatomic,copy)NSString *strUserFirstName;
@property (nonatomic,copy)NSString *strUserLastName;
@property (nonatomic,copy)NSString *strUserGender;
@property (nonatomic,copy)NSString *strUserName;
@property (nonatomic,copy)NSString *strUserEmail;
@property (nonatomic,copy)NSString *strUserTitle;
@property (nonatomic,copy)NSString *strUserAddress;
@property (nonatomic,copy)NSString *strUserState;
//@property (nonatomic,copy)NSString *strUserDetailId;
@property (nonatomic)NSMutableArray *arrUserFamilyInfoList;

+(UserProfileData *)instanceFromDictionary:(NSDictionary *)dict;

@end
