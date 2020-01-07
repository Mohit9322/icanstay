//
//  UICallButton.m
//  @lacarte
//
//  Created by IMAC5 on 12/26/14.
//  Copyright (c) 2014 classic. All rights reserved.
//

#import "UIActionButton.h"

@implementation UIActionButton
@synthesize indexPath;
@synthesize isSelected;

- (id)initWithFrame:(CGRect)frame type:(UIButtonType)buttonType   {
    self = [super initWithFrame: frame];
    isSelected = NO;
    return self;
}

-(void)setIsSelected:(BOOL)lisSelected   {
    isSelected = lisSelected;
}

-(void)setIndexPath:(NSIndexPath *)lindexPath    {
    indexPath = lindexPath;
}

- (void)dealloc{
    indexPath = nil;
}
@end
