//
//  RelationData.m
//  ICanStay
//
//  Created by Vertical Logics on 15/03/16.
//  Copyright (c) 2016 Harry Patel (Hitaishin). All rights reserved.
//

#import "RelationData.h"

@implementation RelationData
+(RelationData *)instanceFromDictionary:(NSDictionary *)dict{
    
    RelationData *instance = [[RelationData alloc]init];
    [instance setAttributesFromDictionary:dict];
    return instance;
}

- (void)setAttributesFromDictionary:(NSDictionary *)dict{
    self.strRelationName = [dict valueForKey:@"Relation_Name"];
    self.numRelationId = [dict valueForKey:@"Relation_id"];
    self.numStatus = [dict valueForKey:@"Status"];
    self.strGender =[dict valueForKey:@"Gender"];

    
    
}
@end
