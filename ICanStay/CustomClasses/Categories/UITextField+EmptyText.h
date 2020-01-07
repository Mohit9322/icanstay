//
//  UITextField+EmptyText.h
//  ICanStay
//
//  Created by Namit Aggarwal on 01/03/16.
//  Copyright (c) 2016 Harry Patel (Hitaishin). All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (EmptyText)


-(BOOL)detectIfTextfieldIsEmpty:(NSString *)str;
- (void)addPaddingToTextField;

@end
