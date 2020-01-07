//
//  RelationList.h
//  ICanStay
//
//  Created by Vertical Logics on 15/03/16.
//  Copyright (c) 2016 Harry Patel (Hitaishin). All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RelationList : NSObject
@property (nonatomic)NSMutableArray *arrRelationList;
+(RelationList*)instanceFromArray:(NSArray *)array;
@end
