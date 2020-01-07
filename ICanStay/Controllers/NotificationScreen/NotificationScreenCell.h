//
//  NotificationScreenCell.h
//  ICanStay
//
//  Created by Namit Aggarwal on 26/02/16.
//  Copyright (c) 2016 Harry Patel (Hitaishin). All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationScreenCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbldate;
//@property (weak, nonatomic) IBOutlet UITextView *txtNotification;
@property (weak, nonatomic) IBOutlet UILabel *lblNotification;

@end
