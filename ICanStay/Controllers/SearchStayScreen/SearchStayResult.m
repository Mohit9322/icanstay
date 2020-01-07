//
//  SearchStayResult.m
//  ICanStay
//
//  Created by Namit Aggarwal on 26/02/16.
//  Copyright (c) 2016 Harry Patel (Hitaishin). All rights reserved.
//

#import "SearchStayResult.h"
#import <QuartzCore/QuartzCore.h>

@interface SearchStayResult ()
@property (weak, nonatomic) IBOutlet UIView *viewBottom;
- (IBAction)btnMenuTapped:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *bookNowBtn;

@end

@implementation SearchStayResult

- (void)viewDidLoad {
//    self.bookNowBtn.layer.cornerRadius = 10;
//    self.bookNowBtn.clipsToBounds = YES;
    [super viewDidLoad];
     DLog(@"DEBUG-VC");
    // Do any additional setup after loading the view.
    [[ICSingletonManager sharedManager]addBottomMenuToViewController:self onView:self.viewBottom];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnMenuTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
