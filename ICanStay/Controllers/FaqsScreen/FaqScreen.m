//
//  FaqScreen.m
//  ICanStay
//
//  Created by Vertical Logics on 17/03/16.
//  Copyright (c) 2016 Harry Patel (Hitaishin). All rights reserved.
//

#import "FaqScreen.h"
#import "MBProgressHUD.h"
#import <AFNetworking.h>
#import "FaqTableViewCell.h"
#import "FaqHeaderTableViewCell.h"
#import "NotificationScreen.h"
#import "HomeScreenController.h"
#import "SideMenuController.h"

@interface FaqScreen ()

@property (weak, nonatomic) IBOutlet UILabel *lblFaq;
@property (strong, nonatomic) IBOutlet UIImageView *icsLogoImgVieqw;
- (IBAction)btnMenuTapped:(id)sender;
@property (strong, nonatomic) NSArray *arrayFaqList;
@end


@implementation FaqScreen

- (void)viewDidLoad {
    [super viewDidLoad];
     DLog(@"DEBUG-VC");
    // Do any additional setup after loading the view.
    openedHeaderIndex = 1000;
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    [tracker set:kGAIScreenName value:@"FAQ"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
   
    self.icsLogoImgVieqw.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [self.icsLogoImgVieqw addGestureRecognizer:singleFingerTap];
 [self startServiceToGetAboutUsData];
}
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    HomeScreenController *vcHomeScreen = [storyboard instantiateViewControllerWithIdentifier:@"HomeScreenController"];
    SideMenuController *vcSideMenu =     [storyboard instantiateViewControllerWithIdentifier:@"SideMenuController"];
    
    MMDrawerController *drawerController = [[MMDrawerController alloc]initWithCenterViewController:vcHomeScreen
                                                                          leftDrawerViewController:vcSideMenu];
    [drawerController setRestorationIdentifier:@"MMDrawer"];
    
    
    [drawerController setMaximumLeftDrawerWidth:SCREEN_WIDTH*2/3];
    
    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    drawerController.shouldStretchDrawer = NO;
    
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:drawerController];
    [navController setNavigationBarHidden:YES];
    [self.view.window setRootViewController:navController];
    [self.view.window makeKeyAndVisible];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startServiceToGetAboutUsData{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    //NSDictionary *dictParams = @{@"contentID":[NSNumber numberWithInt:16]};
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8"
                     forHTTPHeaderField:@"Content-Type"];
    
  //  http://www.icanstay.com/Api/FAQICSAPI
//      http://www.icanstay.com/api/DynamicContentapi/GetContentDetails?contentID=1
//        To: http://www.icanstay.com/api/DynamicContentapi/GetContentDetailsios?contentID=1
    [manager GET:[NSString stringWithFormat:@"http://www.icanstay.com/Api/FAQICSAPI/GetFAQData"] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        NSArray *dict = (NSArray *)responseObject;
       
        self.arrayFaqList = dict;
        arrayForBool=[[NSMutableArray alloc]init];
        for (int i=0; i<[self.arrayFaqList count]; i++) {
            [arrayForBool addObject:[NSNumber numberWithBool:NO]];
        }

        [self.tableView reloadData];
        
        /*
        NSString *strAboutUs =[dict valueForKey:@"ContentDescription"];
        strAboutUs= [[ICSingletonManager sharedManager]removeNullObjectFromString:strAboutUs];
        strAboutUs = [[ICSingletonManager sharedManager] stringByStrippingHTMLFromString:strAboutUs];
        if (strAboutUs.length == 0) {
            strAboutUs = @"Please reload after sometime.";
        }

        [self.lblFaq setText:strAboutUs];
        
        */
        NSLog(@"sucess");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [[ICSingletonManager sharedManager] showAlertViewWithMsg:error.localizedDescription onController:self];

    }];
}


- (IBAction)notificationButtonTapped:(id)sender
{
    LoginManager *login = [[LoginManager alloc]init];
    if ([[login isUserLoggedIn] count]>0)
    {
        ICSingletonManager *globals = [ICSingletonManager sharedManager];
        globals.isWithoutLoginNoti = false;
        NotificationScreen *notification = [self.storyboard instantiateViewControllerWithIdentifier:@"NotificationScreen"];
        [self.navigationController pushViewController:notification animated:YES];
    }
    else
    {
        ICSingletonManager *globals = [ICSingletonManager sharedManager];
        globals.isFromMenu = false;
        globals.isWithoutLoginNoti = true;
        LoginScreen *vcLogin = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginScreen"];
        [self.navigationController pushViewController:vcLogin animated:YES];
    }
}
#pragma mark -
#pragma mark TableView DataSource and Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *faqDictionary = [self.arrayFaqList objectAtIndex:section];
    NSArray *faqArray = [faqDictionary objectForKey:@"Flist"];

    if ([[arrayForBool objectAtIndex:section] boolValue])
    {
        return faqArray.count;
    }
    else
        return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    //Storing dictionary value from array at index
    NSArray *faqArray = [[self.arrayFaqList objectAtIndex:indexPath.section] valueForKey:@"Flist"];
    NSDictionary *faqDictionary = [faqArray objectAtIndex:indexPath.row];
    
    FaqTableViewCell *cell;
    //Code for setting table view cell
    cell = (FaqTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[FaqTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.lblQuestion.text = [faqDictionary objectForKey:@"QuestionDesc"];
    cell.lblAnswer.text = [ICSingletonManager stringByStrippingHTML:[faqDictionary objectForKey:@"AnswerDesc"]];

//    static NSString *cellid=@"hello";
//    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
//    if (cell==nil) {
//        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
//    }
//    
//    
//    BOOL manyCells  = [[arrayForBool objectAtIndex:indexPath.section] boolValue];
//    
//    /********** If the section supposed to be closed *******************/
//    if(!manyCells)
//    {
//        cell.backgroundColor=[UIColor clearColor];
//        
//        cell.textLabel.text=@"";
//    }
//    /********** If the section supposed to be Opened *******************/
//    else
//    {
//        cell.textLabel.text=[NSString stringWithFormat:@"%@ %d",[sectionTitleArray objectAtIndex:indexPath.section],indexPath.row+1];
//        cell.textLabel.font=[UIFont systemFontOfSize:15.0f];
//        cell.backgroundColor=[UIColor whiteColor];
//        cell.imageView.image=[UIImage imageNamed:@"point.png"];
//        cell.selectionStyle=UITableViewCellSelectionStyleNone ;
//    }
//    cell.textLabel.textColor=[UIColor blackColor];
//    
//    /********** Add a custom Separator with cell *******************/
//    UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(15, 40, self.tableView.frame.size.width-15, 1)];
//    separatorLineView.backgroundColor = [UIColor blackColor];
//    [cell.contentView addSubview:separatorLineView];
    
    return cell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.arrayFaqList count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    /*************** Close the section, once the data is selected ***********************************/
    [arrayForBool replaceObjectAtIndex:indexPath.section withObject:[NSNumber numberWithBool:NO]];
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[arrayForBool objectAtIndex:indexPath.section] boolValue]) {
        NSDictionary *faqDictionary = [self.arrayFaqList objectAtIndex:indexPath.section];
        NSArray *faqArray = [faqDictionary objectForKey:@"Flist"];

        CGSize heightQuestion = [ICSingletonManager findHeightForText:[[faqArray objectAtIndex:indexPath.row] valueForKey:@"QuestionDesc"] havingWidth:SCREEN_WIDTH-40 andFont:[UIFont fontWithName:@"JosefinSans" size:18]];
        
        CGSize heightAnswer = [ICSingletonManager findHeightForText:[[faqArray objectAtIndex:indexPath.row] valueForKey:@"AnswerDesc"] havingWidth:SCREEN_WIDTH-40 andFont:[UIFont fontWithName:@"JosefinSans" size:18]];

        CGSize heightCell;
        heightCell.width =  heightQuestion.width + heightAnswer.width;
        if (IS_IPAD) {
            heightCell.height =  heightQuestion.height + heightAnswer.height + 40;
        }
        else
        {
            heightCell.height =  heightQuestion.height + heightAnswer.height;
        }

        return heightCell.height;
    }
    return 0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

#pragma mark - Creating View for TableView Section

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    static NSString *CellIdentifier1 = @"HeaderCell";
    //Storing dictionary value from array at index
    NSDictionary *faqHeaderDictionary = [self.arrayFaqList objectAtIndex:section];
    FaqHeaderTableViewCell *cell;
    //Code for setting table view cell
    cell = (FaqHeaderTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
    if (cell == nil) {
        cell = [[FaqHeaderTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier1];
    }
    
    cell.lblFaq.text = [faqHeaderDictionary objectForKey:@"CategoryDesc"];
    BOOL collapsed  = [[arrayForBool objectAtIndex:section] boolValue];

    if (collapsed)
    {
        cell.imageFaq.image = [UIImage imageNamed:@"ic_up"];
    }
    else
    {
        cell.imageFaq.image = [UIImage imageNamed:@"ic_down"];
    }
    
    cell.contentView.backgroundColor = [ICSingletonManager colorFromHexString:@"#bd9854"];
    cell.contentView.tag = section;
//    
//    UIView *sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 280,40)];
//    sectionView.tag=section;
//    UILabel *viewLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, _expandableTableView.frame.size.width-10, 40)];
//    viewLabel.backgroundColor=[UIColor clearColor];
//    viewLabel.textColor=[UIColor blackColor];
//    viewLabel.font=[UIFont systemFontOfSize:15];
//    viewLabel.text=[NSString stringWithFormat:@"List of %@",[sectionTitleArray objectAtIndex:section]];
//    [sectionView addSubview:viewLabel];
//    /********** Add a custom Separator with Section view *******************/
//    UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(15, 40, _expandableTableView.frame.size.width-15, 1)];
//    separatorLineView.backgroundColor = [UIColor blackColor];
//    [sectionView addSubview:separatorLineView];
//    
    /********** Add UITapGestureRecognizer to SectionView   **************/
    
    UITapGestureRecognizer  *headerTapped   = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionHeaderTapped:)];
    [cell.contentView addGestureRecognizer:headerTapped];
    
    return  cell.contentView;
    
    
}


#pragma mark - Table header gesture tapped

- (void)sectionHeaderTapped:(UITapGestureRecognizer *)gestureRecognizer{
    
    if (openedHeaderIndex != 1000) {
        /*************** Close the section, once the data is selected ***********************************/
        [arrayForBool replaceObjectAtIndex:openedHeaderIndex withObject:[NSNumber numberWithBool:NO]];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:openedHeaderIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
        

    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:gestureRecognizer.view.tag];
    if (indexPath.section != openedHeaderIndex) {
        if (indexPath.row == 0) {
            BOOL collapsed  = [[arrayForBool objectAtIndex:indexPath.section] boolValue];
            openedHeaderIndex = indexPath.section;
            
            for (int i=0; i<[self.arrayFaqList count]; i++) {
                if (indexPath.section==i) {
                    [arrayForBool replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:!collapsed]];
                }
            }
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:gestureRecognizer.view.tag] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
    else
    {
        openedHeaderIndex = 1000;
    }
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
    
     [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];    
}
@end
