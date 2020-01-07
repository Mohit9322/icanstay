//
//  BaseView.h
//  ICanStay
//
//  Created by Planet on 9/25/17.
//  Copyright © 2017 verticallogics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseView : UIView
@property (nonatomic, strong) NSString     *hotelIdStr;
- (id)initBaseViewWithFrame:(CGRect)frame;
@end
