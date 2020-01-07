//
//  NSDictionary+JsonString.h
//  ICanStay
//
//  Created by Vertical Logics on 01/03/16.
//  Copyright (c) 2016 Harry Patel (Hitaishin). All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (JsonString)

-(NSString*)jsonStringWithPrettyPrint:(BOOL) prettyPrint;
//-(NSData*)jsonStringWithPrettyPrint:(BOOL) prettyPrint;
//- (NSDictionary*)cleanDictionary;
@end
