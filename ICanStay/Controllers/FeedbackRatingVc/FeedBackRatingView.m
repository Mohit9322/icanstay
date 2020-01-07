//
//  FeedBackRatingView.m
//  ICanStay
//
//  Created by Planet on 9/25/17.
//  Copyright © 2017 verticallogics. All rights reserved.
//

#import "FeedBackRatingView.h"
#import "EDStarRating.h"
#import "seeMoreBtn.h"
@interface FeedBackRatingView ()<EDStarRatingProtocol, UITextViewDelegate>
{
    EDStarRating *starRating;
    UITextView *commentTxtView;
}
@property (nonatomic, strong) UIView         *topBlueBaseView;
@property (nonatomic, strong) UIButton       *backButton;
@property (nonatomic, strong) UILabel        *headerRatingLbl;
@property (nonatomic, strong) seeMoreBtn       *firstRatingBtn;
@property (nonatomic, strong) seeMoreBtn       *secondRatingBtn;
@property (nonatomic, strong) seeMoreBtn       *thirdRatingBtn;
@property (nonatomic, strong) seeMoreBtn       *fourthRatingBtn;
@property (nonatomic, strong) NSArray          *optionArr;
@property (nonatomic, strong) NSString         *otionId;

@end

@implementation FeedBackRatingView

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    _optionArr = [[NSArray alloc]init];
    
    self.topBlueBaseView = [[UIView alloc]init];
    self.topBlueBaseView.backgroundColor =  [ICSingletonManager colorFromHexString:@"#001d3d"];
    [self.view addSubview:self.topBlueBaseView];
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.backButton setBackgroundImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.topBlueBaseView addSubview:self.backButton];
    
    self.headerRatingLbl = [[UILabel alloc]init];
    self.headerRatingLbl.text = @"Rating";
    self.headerRatingLbl.textColor = [UIColor whiteColor];
    self.headerRatingLbl.textAlignment = NSTextAlignmentCenter;
    [self.topBlueBaseView addSubview:self.headerRatingLbl];
    
    if (IS_IPAD) {
        self.topBlueBaseView.frame = CGRectMake(0, 0,screenRect.size.width , 64);
        self.backButton.frame = CGRectMake(20, 22, 30, 20);
        self.headerRatingLbl.frame = CGRectMake((self.topBlueBaseView.frame.size.width - 150)/2,(self.topBlueBaseView.frame.size.height - 40)/2 , 150, 40);
        
        
    }else{
        self.topBlueBaseView.frame = CGRectMake(0, 0,screenRect.size.width , 50);
        self.backButton.frame = CGRectMake(20, 15, 30, 20);
        self.headerRatingLbl.frame = CGRectMake((self.topBlueBaseView.frame.size.width - 150)/2,(self.topBlueBaseView.frame.size.height - 40)/2 , 150, 40);
    }

    [self optionIDFetchDetail];
    
    
       // Do any additional setup after loading the view.
}

-(void)designRatingView
{
    UIView *midBaseView = [[UIView alloc]init];
    [self.view addSubview:midBaseView];
    
    UILabel *stayLbl = [[UILabel alloc]init];
    stayLbl.textAlignment = NSTextAlignmentCenter;
    stayLbl.text = @"Stay Rating";
    stayLbl.textColor = [UIColor blackColor];
    [midBaseView addSubview:stayLbl];
    
    
    starRating = [[EDStarRating alloc]init];
    starRating.starImage = [UIImage imageNamed:@"stargray"];
    starRating.starHighlightedImage = [UIImage imageNamed:@"star"];
    starRating.maxRating = 5.0;
    starRating.delegate = self;
    starRating.horizontalMargin = 12;
    starRating.editable=YES;
    starRating.displayMode=EDStarRatingDisplayFull;
    starRating.tintColor =  [UIColor greenColor];
    starRating.rating= 5;
    [midBaseView addSubview:starRating];
    
    
    UILabel *feedBackLbl = [[UILabel alloc]init];
    feedBackLbl.text = @"Please write your feedback";
    feedBackLbl.textAlignment = NSTextAlignmentCenter;
    feedBackLbl.textColor = [UIColor blackColor];
    [midBaseView addSubview:feedBackLbl];
    
    
    UIView *fourBtnBaseView = [[UIView alloc]init];
    [midBaseView addSubview:fourBtnBaseView];
    
    
    
    self.firstRatingBtn = [[seeMoreBtn alloc]initWithFrame:CGRectZero type:UIButtonTypeRoundedRect];
    [self.firstRatingBtn addTarget:self action:@selector(firstRatingBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.firstRatingBtn setBackgroundColor:[ICSingletonManager colorFromHexString:@"#bd9854"]];
    [self.firstRatingBtn setTitle:@"Very Bad" forState:UIControlStateNormal];
    [self.firstRatingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.firstRatingBtn.layer.cornerRadius = 4.0;
    [fourBtnBaseView addSubview:self.firstRatingBtn];
    
    self.secondRatingBtn = [[seeMoreBtn alloc]initWithFrame:CGRectZero type:UIButtonTypeRoundedRect];
    [self.secondRatingBtn addTarget:self action:@selector(secondRatingBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.secondRatingBtn setBackgroundColor:[ICSingletonManager colorFromHexString:@"#bd9854"]];
    [self.secondRatingBtn setTitle:@"Ok" forState:UIControlStateNormal];
    [self.secondRatingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.secondRatingBtn.layer.cornerRadius = 4.0;
    [fourBtnBaseView addSubview:self.secondRatingBtn];
    
    
    self.thirdRatingBtn = [[seeMoreBtn alloc]initWithFrame:CGRectZero type:UIButtonTypeRoundedRect];
    [self.thirdRatingBtn addTarget:self action:@selector(thirdRatingBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.thirdRatingBtn setBackgroundColor:[ICSingletonManager colorFromHexString:@"#bd9854"]];
    [self.thirdRatingBtn setTitle:@"Very Good" forState:UIControlStateNormal];
    [self.thirdRatingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.thirdRatingBtn.layer.cornerRadius = 4.0;
    [fourBtnBaseView addSubview:self.thirdRatingBtn];
    
    
    self.fourthRatingBtn = [[seeMoreBtn alloc]initWithFrame:CGRectZero type:UIButtonTypeRoundedRect];
    [self.fourthRatingBtn addTarget:self action:@selector(fourthRatingBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.fourthRatingBtn setBackgroundColor:[ICSingletonManager colorFromHexString:@"#bd9854"]];
    [self.fourthRatingBtn setTitle:@"Excellent !!!" forState:UIControlStateNormal];
    [self.fourthRatingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.fourthRatingBtn.layer.cornerRadius = 4.0;
    [fourBtnBaseView addSubview:self.fourthRatingBtn];
    
    commentTxtView = [[UITextView alloc]init];
    commentTxtView.layer.borderWidth = 2.0;
    commentTxtView.layer.borderColor = [ICSingletonManager colorFromHexString:@"#bd9854"].CGColor;
    commentTxtView.font = [UIFont systemFontOfSize:17];
    commentTxtView.layer.cornerRadius = 5.0;
    commentTxtView.text = @"Comment";
    commentTxtView.textColor = [UIColor lightGrayColor];
    commentTxtView.delegate = self;
    [midBaseView addSubview:commentTxtView];
    
    
    UILabel *feedBackAnnLbl =  [[UILabel alloc]init];
    feedBackAnnLbl.text = @"FeedBack is anonymously shared";
    feedBackAnnLbl.textColor = [UIColor blackColor];
    feedBackAnnLbl.textAlignment = NSTextAlignmentCenter;
    [midBaseView addSubview:feedBackAnnLbl];
    
    
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn setBackgroundColor:[ICSingletonManager colorFromHexString:@"#bd9854"]];
    [submitBtn setTitle:@"Submit" forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
    
    
    
    
    
    
    if (IS_IPAD) {
        midBaseView.frame = CGRectMake((self.view.frame.size.width - 500)/2,(self.view.frame.size.height - self.topBlueBaseView.frame.size.height - 60 - 500 )/2 , 500, 500);
        stayLbl.frame = CGRectMake(100, 5, midBaseView.frame.size.width - 200, 30);
        starRating.frame = CGRectMake(10, stayLbl.frame.origin.y + stayLbl.frame.size.height + 10, midBaseView.frame.size.width - 20, 70);
        feedBackLbl.frame = CGRectMake(10, starRating.frame.origin.y + starRating.frame.size.height + 10, starRating.frame.size.width, 30);
        fourBtnBaseView.frame = CGRectMake(0, feedBackLbl.frame.origin.y + feedBackLbl.frame.size.height + 10, midBaseView.frame.size.width, 100);
        _firstRatingBtn.frame = CGRectMake(0, 0, (fourBtnBaseView.frame.size.width -1)/2, 49.5);
        _secondRatingBtn.frame = CGRectMake(_firstRatingBtn.frame.origin.x + _firstRatingBtn.frame.size.width+1, 0, (fourBtnBaseView.frame.size.width -1)/2, 49.5);
        _thirdRatingBtn.frame = CGRectMake(0, 50,(fourBtnBaseView.frame.size.width -1)/2 , 49.5);
        _fourthRatingBtn.frame = CGRectMake(_firstRatingBtn.frame.origin.x + _firstRatingBtn.frame.size.width+1, 50,(fourBtnBaseView.frame.size.width -1)/2 , 49.5);
        commentTxtView.frame = CGRectMake(0, fourBtnBaseView.frame.origin.y + fourBtnBaseView.frame.size.height + 10, midBaseView.frame.size.width, 100);
        feedBackAnnLbl.frame = CGRectMake(20, commentTxtView.frame.origin.y +commentTxtView.frame.size.height + 10, midBaseView.frame.size.width - 40, 30);
        
        submitBtn.frame = CGRectMake(0, self.view.frame.size.height - 60, self.view.frame.size.width, 60);
        
        
    }else{
        midBaseView.frame = CGRectMake((self.view.frame.size.width - 300 )/2,(self.view.frame.size.height - self.topBlueBaseView.frame.size.height - 50 -420)/2 , 300, 420);
        stayLbl.frame = CGRectMake(100, 5, midBaseView.frame.size.width - 200, 30);
        starRating.frame = CGRectMake(10, stayLbl.frame.origin.y + stayLbl.frame.size.height + 10, midBaseView.frame.size.width - 20, 70);
        feedBackLbl.frame = CGRectMake(10, starRating.frame.origin.y + starRating.frame.size.height + 10, starRating.frame.size.width, 30);
        fourBtnBaseView.frame = CGRectMake(0, feedBackLbl.frame.origin.y + feedBackLbl.frame.size.height + 10, midBaseView.frame.size.width, 100);
        _firstRatingBtn.frame = CGRectMake(0, 0, (fourBtnBaseView.frame.size.width -1)/2, 49.5);
        _secondRatingBtn.frame = CGRectMake(_firstRatingBtn.frame.origin.x + _firstRatingBtn.frame.size.width+1, 0, (fourBtnBaseView.frame.size.width -1)/2, 49.5);
        _thirdRatingBtn.frame = CGRectMake(0, 50,(fourBtnBaseView.frame.size.width -1)/2 , 49.5);
        _fourthRatingBtn.frame = CGRectMake(_firstRatingBtn.frame.origin.x + _firstRatingBtn.frame.size.width+1, 50,(fourBtnBaseView.frame.size.width -1)/2 , 49.5);
        commentTxtView.frame = CGRectMake(0, fourBtnBaseView.frame.origin.y + fourBtnBaseView.frame.size.height + 10, midBaseView.frame.size.width, 100);
        feedBackAnnLbl.frame = CGRectMake(20, commentTxtView.frame.origin.y +commentTxtView.frame.size.height + 10, midBaseView.frame.size.width - 40, 30);
        
        submitBtn.frame = CGRectMake(0, self.view.frame.size.height - 60, self.view.frame.size.width, 60);
    }
    
    for (id dict in self.optionArr) {
        if ([[dict valueForKey:@"Type"] isEqualToString:@"5"]) {
            NSArray *optionOneArr = [dict valueForKey:@"Olist"];
            
            for (int i = 0; i < [optionOneArr count]; i++) {
                if (i == 0) {
                    [_firstRatingBtn setTitle:[[optionOneArr objectAtIndex:0]valueForKey:@"Option"] forState:UIControlStateNormal];
                    _firstRatingBtn.hotelIdStr = [NSString stringWithFormat:@"%@",[[optionOneArr objectAtIndex:0]valueForKey:@"Id_option"] ];
                }
                
                if (i == 1) {
                    [_secondRatingBtn setTitle:[[optionOneArr objectAtIndex:1]valueForKey:@"Option"] forState:UIControlStateNormal];
                    _secondRatingBtn.hotelIdStr = [NSString stringWithFormat:@"%@",[[optionOneArr objectAtIndex:1]valueForKey:@"Id_option"] ];
                }
                
                if (i == 2) {
                    [_thirdRatingBtn setTitle:[[optionOneArr objectAtIndex:2]valueForKey:@"Option"] forState:UIControlStateNormal];
                    _thirdRatingBtn.hotelIdStr = [NSString stringWithFormat:@"%@",[[optionOneArr objectAtIndex:2]valueForKey:@"Id_option"] ];
                }
                if (i == 3) {
                    [_fourthRatingBtn setTitle:[[optionOneArr objectAtIndex:3]valueForKey:@"Option"] forState:UIControlStateNormal];
                    _fourthRatingBtn.hotelIdStr = [NSString stringWithFormat:@"%@",[[optionOneArr objectAtIndex:3]valueForKey:@"Id_option"] ];
                }
                
                
            }
        }
        
    }


}
-(void)optionIDFetchDetail
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8"
                     forHTTPHeaderField:@"Content-Type"];
   
    [manager GET:[NSString stringWithFormat:@"%@/api/rating/getoption",kServerUrl] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        
        _optionArr = responseObject;
        [self designRatingView];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:error.localizedDescription onController:self];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}
- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    commentTxtView.text = @"";
    commentTxtView.textColor = [UIColor blackColor];
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
    
    if(commentTxtView.text.length == 0){
        commentTxtView.textColor = [UIColor lightGrayColor];
        commentTxtView.text = @"Comment";
        [commentTxtView resignFirstResponder];
    }
}
-(void)starsSelectionChanged:(EDStarRating *)control rating:(float)rating
{
    int ratingValue =  (int)rating;
    NSString *ratingStr = [NSString stringWithFormat:@"%d", ratingValue];
    NSLog(@"%@", ratingStr);
    
    for (id dict in self.optionArr) {
        if ([[dict valueForKey:@"Type"] isEqualToString:ratingStr]) {
            NSArray *optionOneArr = [dict valueForKey:@"Olist"];
            
            for (int i = 0; i < [optionOneArr count]; i++) {
                if (i == 0) {
                    [_firstRatingBtn setTitle:[[optionOneArr objectAtIndex:0]valueForKey:@"Option"] forState:UIControlStateNormal];
                    _firstRatingBtn.hotelIdStr = [NSString stringWithFormat:@"%@",[[optionOneArr objectAtIndex:0]valueForKey:@"Id_option"] ];
                }
                
                if (i == 1) {
                    [_secondRatingBtn setTitle:[[optionOneArr objectAtIndex:1]valueForKey:@"Option"] forState:UIControlStateNormal];
                    _secondRatingBtn.hotelIdStr = [NSString stringWithFormat:@"%@",[[optionOneArr objectAtIndex:0]valueForKey:@"Id_option"] ];
                }
                
                if (i == 2) {
                    [_thirdRatingBtn setTitle:[[optionOneArr objectAtIndex:2]valueForKey:@"Option"] forState:UIControlStateNormal];
                    _thirdRatingBtn.hotelIdStr = [NSString stringWithFormat:@"%@",[[optionOneArr objectAtIndex:0]valueForKey:@"Id_option"] ];
                }
                if (i == 3) {
                    [_fourthRatingBtn setTitle:[[optionOneArr objectAtIndex:3]valueForKey:@"Option"] forState:UIControlStateNormal];
                    _fourthRatingBtn.hotelIdStr = [NSString stringWithFormat:@"%@",[[optionOneArr objectAtIndex:0]valueForKey:@"Id_option"] ];
                }


            }
        }
        
           }
    
    
}

-(void)submitBtnPressed:(id)sender
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8"
                     forHTTPHeaderField:@"Content-Type"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/Rating/InsertRating?BookingId=%@&RatingTest=%@f&OptionId=%@",kServerUrl,self.bookingId, commentTxtView.text, self.otionId];
      NSString* webStringURL = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager GET:webStringURL   parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        
        
        if ([[responseObject valueForKey:@"Status"]isEqualToString:@"1"]) {
            [self.navigationController popViewControllerAnimated:YES];

        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        [[ICSingletonManager sharedManager]showAlertViewWithMsg:error.localizedDescription onController:self];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];

}
-(void)backButtonTapped:(id)sender
{
           [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)firstRatingBtnPressed:(id)sender
{
    __weak seeMoreBtn *firstBtn = sender;
    self.otionId = firstBtn.hotelIdStr;
    
}
-(void)secondRatingBtnPressed:(id)sender
{
    __weak seeMoreBtn *secondBtn = sender;
    self.otionId = secondBtn.hotelIdStr;
}
-(void)thirdRatingBtnPressed:(id)sender
{
    __weak seeMoreBtn *thirdBtn = sender;
    self.otionId = thirdBtn.hotelIdStr;
}
-(void)fourthRatingBtnPressed:(id)sender
{
    __weak seeMoreBtn *fourthBtn = sender;
    self.otionId = fourthBtn.hotelIdStr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
