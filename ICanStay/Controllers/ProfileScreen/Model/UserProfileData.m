//
//  UserProfileDate.m
//  ICanStay
//
//  Created by Vertical Logics on 14/03/16.
//  Copyright (c) 2016 Harry Patel (Hitaishin). All rights reserved.
//

#import "UserProfileData.h"
#import "FamilyProfileData.h"
#import "NSString+Validation.h"

@implementation UserProfileData

+(UserProfileData *)instanceFromDictionary:(NSDictionary *)dict{
    UserProfileData *userData = [[UserProfileData alloc]init];
    [userData setAttributesFromDictionary:dict];
    return userData;

}

- (void)setAttributesFromDictionary:(NSDictionary *)dict{
    NSDictionary *dictUserDetail = [dict valueForKey:@"userDetail"];
    self.strAniversaryDate = [dictUserDetail valueForKey:@"Anniversary_Date"];
    self.strCityLiving = [dictUserDetail valueForKey:@"City_Living"];
    self.strCityWorking = [dictUserDetail valueForKey:@"City_Working"];
    self.strDOB = [dictUserDetail valueForKey:@"Date_of_Birth"];
    self.strGender = [dictUserDetail valueForKey:@"Gender"];
    self.strMaritalStatus = [dictUserDetail valueForKey:@"Marital_Status"];
    self.numOfKids = [dictUserDetail valueForKey:@"NO_OF_KIDS"];
    self.strProfilePic = [dictUserDetail valueForKey:@"ProfilePic"];
    
    self.strUserFirstName = [dict valueForKey:@"FIRST_NAME"];
    self.strUserLastName =[dict valueForKey:@"LAST_NAME"];
    self.strUserGender = [dict valueForKey:@"Gender"];
    self.strUserName = [dict valueForKey:@"USER_NAME"];
    self.strUserEmail = [dict valueForKey:@"EMAIL"];
    self.strUserAddress = [dict valueForKey:@"ADDRESS"];
    self.strUserState =[dict valueForKey:@"STATE"];
    if ([self.strUserGender isEqualToString:@"F"]) {
        self.strUserTitle =@"Mrs.";
    }
    else
        self.strUserTitle = @"Mr.";
    
    
    
    
    
    [self setAttributesFromArray:[dictUserDetail valueForKey:@"userFamilyInfoList"]];

    
    //self.strUserDetailId = [dict valueForKey:@"USER_Details_ID"];
   // [self removingNullStrings];
    
}

//- (void)removingNullStrings{
//    
//    [self.strAniversaryDate replacingNullStringsWithEmptyStrings];
//        [self.strAniversaryDate replacingNullStringsWithEmptyStrings];
//        [self.strCityLiving replacingNullStringsWithEmptyStrings];
//        [self.strCityWorking replacingNullStringsWithEmptyStrings];
//        [self.strDOB replacingNullStringsWithEmptyStrings];
//        [self.strGender replacingNullStringsWithEmptyStrings];
//        [self.strMaritalStatus replacingNullStringsWithEmptyStrings];
//        [self.strNumOfKids replacingNullStringsWithEmptyStrings];
//        [self.strProfilePic replacingNullStringsWithEmptyStrings];
//        [self.strGender replacingNullStringsWithEmptyStrings];
//        [self.strUserDetailId replacingNullStringsWithEmptyStrings];
//}


- (void)setAttributesFromArray:(NSArray *)arr
{
    self.arrUserFamilyInfoList = [NSMutableArray array];
    for (id valueMember in arr) {
        FamilyProfileData *hotelData = [FamilyProfileData instanceFromDictionary:valueMember];
        [self.arrUserFamilyInfoList addObject:hotelData];
    }
}


@end
