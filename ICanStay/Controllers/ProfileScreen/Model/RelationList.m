//
//  RelationList.m
//  ICanStay
//
//  Created by Vertical Logics on 15/03/16.
//  Copyright (c) 2016 Harry Patel (Hitaishin). All rights reserved.
//

#import "RelationList.h"
#import "RelationData.h"
@implementation RelationList


+(RelationList*)instanceFromArray:(NSArray *)array{
    
    RelationList *instance = [[RelationList alloc] init];
    
    
    [instance setAttributesFromArray:array];
    return instance;
}



- (void)setAttributesFromArray:(NSArray *)arr
{
    self.arrRelationList = [NSMutableArray array];
    for (id valueMember in arr) {
        RelationData *data = [RelationData instanceFromDictionary:valueMember];
        [self.arrRelationList addObject:data];
    }
}


@end
