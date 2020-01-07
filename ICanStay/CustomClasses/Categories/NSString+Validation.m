//
//  NSString+Validation.m
//  ICanStay
//
//  Created by Vertical Logics on 01/03/16.
//  Copyright (c) 2016 Harry Patel (Hitaishin). All rights reserved.
//

#import "NSString+Validation.h"

@implementation NSString (Validation)

-(BOOL)isValidEmail
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}


- (BOOL)isValidatePhone
{
    if (self.length == 10)
        return YES;
    
    else
        return NO;
//    NSString *phoneRegex = @"^[789]\{9}$";
//    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
//    
//    return [phoneTest evaluateWithObject:self];
}

-(NSString *)removeEmptyString{
    
    if (self.length) {
        return self;
    }
    else
        return @"";
}

//-(NSString *)replacingNullStringsWithEmptyStrings
//{
//    if ([self isEqual:[NSNull null]]) {
//        return @"";
//    }
//    else
//        return self;
//    
//}

@end
