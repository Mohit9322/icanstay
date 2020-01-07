//
//  CreateWishlistTableViewCell.h
//  ICanStay
//
//  Created by Namit on 05/04/16.
//  Copyright © 2016 verticallogics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateWishlistTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *couponCode;
@property (weak, nonatomic) IBOutlet UILabel *validFrom;
@property (weak, nonatomic) IBOutlet UILabel *validTill;
@property (weak, nonatomic) IBOutlet UIButton *cellButton;
@end
