//
//  FamilyProfileData.m
//  ICanStay
//
//  Created by Vertical Logics on 14/03/16.
//  Copyright (c) 2016 Harry Patel (Hitaishin). All rights reserved.
//

#import "FamilyProfileData.h"

@implementation FamilyProfileData


+(FamilyProfileData *)instanceFromDictionary:(NSDictionary *)dict{
    
    FamilyProfileData *familyData = [[FamilyProfileData alloc]init];
    [familyData setAttributesFromDictionary:dict];
    return familyData;
}

- (void)setAttributesFromDictionary:(NSDictionary *)dict{
    self.numFamilyInfoId = [dict valueForKey:@"Faminfo_ID"];
    self.numRelationId = [dict valueForKey:@"Relation_id"];
    self.strRelationName = [dict valueForKey:@"Relation_Name"];
    self.strName = [dict valueForKey:@"Name"];
    self.strEmpStatus = [dict valueForKey:@"Emp_Status"];
    self.strEmailId = [dict valueForKey:@"EmailId"];
    self.strMobile = [dict valueForKey:@"Mobile"];
    self.strGender = [dict valueForKey:@"Gender"];
    self.strDOB = [dict valueForKey:@"DOB"];
    self.strExtraInfo = [dict valueForKey:@"ExtraInfo"];
    
    self.strRelationName = [[ICSingletonManager sharedManager] removeNullObjectFromString:self.strRelationName];
    self.strName = [[ICSingletonManager sharedManager] removeNullObjectFromString:self.strName];
    self.strEmpStatus = [[ICSingletonManager sharedManager] removeNullObjectFromString:self.strEmpStatus];
    self.strEmailId = [[ICSingletonManager sharedManager] removeNullObjectFromString:self.strEmailId];
    self.strMobile = [[ICSingletonManager sharedManager] removeNullObjectFromString:self.strMobile];
    self.strGender = [[ICSingletonManager sharedManager] removeNullObjectFromString:self.strGender];
    self.strDOB = [[ICSingletonManager sharedManager] removeNullObjectFromString:self.strDOB];
    self.strExtraInfo = [[ICSingletonManager sharedManager] removeNullObjectFromString:self.strExtraInfo];
    
   // self.strGender = [dict valueForKey:@"Gender"];
    
}
@end
