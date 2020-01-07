//
//  UITextField+EmptyText.m
//  ICanStay
//
//  Created by Namit Aggarwal on 01/03/16.
//  Copyright (c) 2016 Harry Patel (Hitaishin). All rights reserved.
//

#import "UITextField+EmptyText.h"

@implementation UITextField (EmptyText)


-(BOOL)detectIfTextfieldIsEmpty:(NSString *)str{
    
    BOOL ifEmpty = NO;
    
    if (str.length)
        ifEmpty = NO;
    else
        ifEmpty = YES;
    
    
    
    return ifEmpty;
    
}
- (void)addPaddingToTextField{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    self.leftView = paddingView;
    self.leftViewMode = UITextFieldViewModeAlways;
}
@end
