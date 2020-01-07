//
//  UICallButton.h
//  @lacarte
//
//  Created by IMAC5 on 12/26/14.
//  Copyright (c) 2014 classic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIActionButton : UIButton  {
}

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) BOOL         isSelected;

-(void)setIsSelected:(BOOL)isSelected;
-(void)setIndexPath:(NSIndexPath *)indexPath;

- (id)initWithFrame:(CGRect)frame type:(UIButtonType)buttonType;
@end