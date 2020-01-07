//
//  BaseView.m
//  ICanStay
//
//  Created by Planet on 9/25/17.
//  Copyright © 2017 verticallogics. All rights reserved.
//

#import "BaseView.h"

@implementation BaseView

- (id)initBaseViewWithFrame:(CGRect)frame    {
    self = [super initWithFrame: frame];
    return self;
}


-(void)setHotelID:(NSString *)hotelId    {
    _hotelIdStr = hotelId;
}

@end
