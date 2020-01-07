//
//  CitiesViewController.h
//  ICanStay
//
//  Created by Harish on 12/11/16.
//  Copyright © 2016 verticallogics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CitiesViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{
    NSString *searchTextString;
     BOOL isFilter;
}

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong,nonatomic) NSMutableArray *arrayCityList,*filteredCityList;
@property (weak, nonatomic) IBOutlet UITableView *cityTableView;

@end
