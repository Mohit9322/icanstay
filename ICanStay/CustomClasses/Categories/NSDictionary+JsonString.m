//
//  NSDictionary+JsonString.m
//  ICanStay
//
//  Created by Vertical Logics on 01/03/16.
//  Copyright (c) 2016 Harry Patel (Hitaishin). All rights reserved.
//

#import "NSDictionary+JsonString.h"

@implementation NSDictionary (JsonString)

-(NSString *)jsonStringWithPrettyPrint:(BOOL) prettyPrint {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:(NSJSONWritingOptions)(prettyPrint ? NSJSONWritingPrettyPrinted : 0)
                                                         error:&error];
    
    
    if (! jsonData) {
        NSLog(@"bv_jsonStringWithPrettyPrint: error: %@", error.localizedDescription);
        return @"{}";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

//- (NSDictionary*)cleanDictionary {
//    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
//        if (obj == [NSNull null]) {
//            [self setValue:@"" forKey:key];
//        }
////        } else if ([obj isKindOfClass:[NSDictionary class]]) {
////            [self cleanDictionary:obj];
////        }
//    }];
//    return self;
//}
@end
