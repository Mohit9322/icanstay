//
//  NSString+Validation.h
//  ICanStay
//
//  Created by Vertical Logics on 01/03/16.
//  Copyright (c) 2016 Harry Patel (Hitaishin). All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Validation)
- (BOOL)isValidEmail;
- (BOOL)isValidatePhone;
-(NSString *)removeEmptyString;
//-(NSString *)replacingNullStringsWithEmptyStrings;
@end
