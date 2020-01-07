//
//  RelationData.h
//  ICanStay
//
//  Created by Vertical Logics on 15/03/16.
//  Copyright (c) 2016 Harry Patel (Hitaishin). All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RelationData : NSObject
@property (nonatomic,copy)NSString *strRelationName;
@property (nonatomic,copy)NSString *strGender;
@property (nonatomic)NSNumber *numRelationId;
@property (nonatomic)NSNumber *numStatus;
+(RelationData *)instanceFromDictionary:(NSDictionary *)dict;

@end
