//
//  MOMDetailTableViewController.m
//  Communicator
//
//  Created by mac on 15/06/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import "MOMDetailTableViewController.h"
#import "Mom.h"
#import "UIColor+CommunicatorColor.h"
#import "Database.h"
@interface MOMDetailTableViewController ()

@end

@implementation MOMDetailTableViewController
@synthesize selectedRow;
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%d",selectedRow);

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.barTintColor = [UIColor communicatorColor];
    [self.navigationController.navigationBar setBarStyle:UIStatusBarStyleLightContent];//

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BackArrow"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewController)] ;
    
    self.navigationItem.title = @"MOM Preview";

    self.navigationItem.leftBarButtonItem.tintColor=[UIColor whiteColor];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    AppPreferences* app=[AppPreferences sharedAppPreferences];
    Database* db=[Database shareddatabase];
    Mom* momObj= [app.allMomArray objectAtIndex:self.selectedRow];
    UIView* sectionView=[self.view viewWithTag:100];
    
    UILabel* redUnderlineView=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 2)];
    redUnderlineView.backgroundColor=[UIColor colorWithRed:204/255.0 green:0/255.0 blue:1/255.0 alpha:1];
    			
    //[redUnderlineView setFont:[UIFont systemFontOfSize:14 weight:UIFontWeightSemibold]];
   // redUnderlineView.textColor=[UIColor communicatorColor];
    [sectionView addSubview:redUnderlineView];
    
    UILabel* subjectlabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 260, 10)];
    [subjectlabel setFont:[UIFont systemFontOfSize:14 weight:UIFontWeightSemibold]];
    subjectlabel.textColor=[UIColor communicatorColor];
     subjectlabel.text= [NSString stringWithFormat:@"%@",momObj.subject];
     [sectionView addSubview:subjectlabel];
    
    UILabel* datelabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 28, 260, 10)];
    [datelabel setFont:[UIFont systemFontOfSize:12]];
    datelabel.textColor=[UIColor grayColor];
    datelabel.text= [NSString stringWithFormat:@"Date: %@",momObj.momDate];
    [sectionView addSubview:datelabel];

    UILabel* attendeeslabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 46, 260, 10)];
    [attendeeslabel setFont:[UIFont systemFontOfSize:12]];
    attendeeslabel.textColor=[UIColor grayColor];
    attendeeslabel.text= [NSString stringWithFormat:@"Attendees: %@",momObj.attendee];
    [sectionView addSubview:attendeeslabel];
    
    UILabel* createdBylabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 64, 260, 10)];
    [createdBylabel setFont:[UIFont systemFontOfSize:12]];
    createdBylabel.textColor=[UIColor grayColor];
    NSString* createdByString= [db getUserNameFromUserId:momObj.userfeedback];
    createdBylabel.text= [NSString stringWithFormat:@"Created by: %@",createdByString];
    [sectionView addSubview:createdBylabel];

    //subjectlabel.text

    return sectionView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        AppPreferences* app=[AppPreferences sharedAppPreferences];
        Mom* momObj= [app.allMomArray objectAtIndex:self.selectedRow];
    cell.textLabel.text=[NSString stringWithFormat:@"Keypoints: %@",momObj.keyPoints];
    cell.textLabel.font=[UIFont systemFontOfSize:12];
        cell.textLabel.textColor=[UIColor grayColor];

        return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{


    UILabel* feedTextLbl= [[UILabel alloc]initWithFrame:CGRectMake(5.0f, 0.0f, self.view.frame.size.width - 10.0f, 30.0f)];
    [feedTextLbl setFont:[UIFont systemFontOfSize:12.0f]];
    feedTextLbl.lineBreakMode = UILineBreakModeWordWrap;
    feedTextLbl.numberOfLines = 10000000;
    return 30;
}

-(CGRect)getFrameSize:(Mom*)momObject label:(UILabel*)feedTextLbl
{
    CGSize maximumLabelSize = CGSizeMake(96, FLT_MAX);
    
    CGSize expectedLabelSize = [momObject.keyPoints sizeWithFont:feedTextLbl.font constrainedToSize:maximumLabelSize lineBreakMode:feedTextLbl.lineBreakMode];
    
    //adjust the label the the new height.
    CGRect newFrame = feedTextLbl.frame;
    newFrame.size.height = expectedLabelSize.height;
    
    return newFrame;
    
}


- (IBAction)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
    
}


@end
