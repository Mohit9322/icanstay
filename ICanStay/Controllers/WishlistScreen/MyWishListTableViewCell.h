//
//  MyWishListTableViewCell.h
//  ICanStay
//
//  Created by Namit on 30/03/16.
//  Copyright © 2016 verticallogics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyWishListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *cellHeaderTitle;
@property (weak, nonatomic) IBOutlet UIButton *wishlistDeleteButton;
@property (weak, nonatomic) IBOutlet UIButton *wishlistEditButton;
@property (weak, nonatomic) IBOutlet UILabel *destinationName;
@property (weak, nonatomic) IBOutlet UILabel *whenToStay;
@property (weak, nonatomic) IBOutlet UILabel *roomsNumber;
@property (weak, nonatomic) IBOutlet UILabel *areaName;
@property (weak, nonatomic) IBOutlet UILabel *stayType;
@property (weak, nonatomic) IBOutlet UILabel *lblStayTypeValue;

@end
