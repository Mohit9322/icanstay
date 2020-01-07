//
//  SideMenuCell.h
//  ICanStay
//
//  Created by Namit Aggarwal on 25/02/16.
//  Copyright (c) 2016 Harry Patel (Hitaishin). All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SideMenuCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblOptions;
@property (weak, nonatomic) IBOutlet UIImageView *imageOptions;
@property (strong, nonatomic) IBOutlet UILabel *lblLine;

@end
