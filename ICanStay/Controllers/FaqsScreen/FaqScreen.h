//
//  FaqScreen.h
//  ICanStay
//
//  Created by Vertical Logics on 17/03/16.
//  Copyright (c) 2016 Harry Patel (Hitaishin). All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FaqScreen : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray  *arrayForBool;
    NSInteger openedHeaderIndex;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
