//
//  ReportAndDocsViewController.m
//  Communicator
//
//  Created by mac on 24/05/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import "ReportAndDocsViewController.h"

@interface ReportAndDocsViewController ()

@end

@implementation ReportAndDocsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    arrayForBool=[[NSMutableArray alloc]init];
    sectionTitleArray=[[NSArray alloc]initWithObjects:
                       @"Date 1",
                       @"Date 2",
                       @"Date 3",
                       @"Date 4",
                       @"Date 5",
                       @"Date 5",
                       @"Date 6",
                       @"Date 7",
                       nil];
    
    for (int i=0; i<[sectionTitleArray count]; i++) {
        [arrayForBool addObject:[NSNumber numberWithBool:NO]];
    }
}
-(void)popViewController1
{
    UINavigationController *navController = self.navigationController;
    UIViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginNaviagationController"];
    [navController presentViewController:vc animated:YES completion:nil];
    NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:NULL forKey:@"userObject"];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.navigationItem.title = @"Reports & Docs";
    self.tabBarController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"SignOut"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewController1)] ;
    self.tabBarController.navigationItem.title = @"Dashboard";
    [self.navigationItem setHidesBackButton:NO];
    //self.navigationController.navigationBar.barTintColor = [UIColor communicatorColor];
    self.tabBarController.navigationItem.leftBarButtonItem.tintColor=[UIColor whiteColor];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [sectionTitleArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 70;

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[arrayForBool objectAtIndex:section] boolValue])
    {
        return 2;
    }
    else
        return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    BOOL isExapnd  = [[arrayForBool objectAtIndex:section] boolValue];

    sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 280,40)];
    UILabel *fileCountLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.tableView.frame.size.width-60, 0, 50, 40)];

    //UIImage* fileClosed=[UIImage imageNamed:@"Fileclosed"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 50, 40)];
    if ([[arrayForBool objectAtIndex:section] boolValue])
    {
        imageView.image=[UIImage imageNamed:@"FileOpened"];
        [fileCountLabel removeFromSuperview];

    }
    else
    {
        imageView.image=[UIImage imageNamed:@"Fileclosed"];
        fileCountLabel.text=[NSString stringWithFormat:@"%d Files",2];
        [sectionView addSubview:fileCountLabel];
    }
        
    [sectionView addSubview:imageView];
    sectionView.tag=section;
    
   // UILabel* label=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 50, 40)];
    //UILabel* label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];

    UILabel *fileSectionLabel=[[UILabel alloc]initWithFrame:CGRectMake(70, 0, self.tableView.frame.size.width-10, 40)];
    //label.text=@"hello";
    fileSectionLabel.backgroundColor=[UIColor clearColor];
    fileSectionLabel.textColor=[UIColor blackColor];
    fileSectionLabel.font=[UIFont systemFontOfSize:15];
    fileSectionLabel.text=[NSString stringWithFormat:@"List of Files on %@",[sectionTitleArray objectAtIndex:section]];
    [sectionView addSubview:fileSectionLabel];
    
    
    /********** Add UITapGestureRecognizer to SectionView   **************/
    
    UITapGestureRecognizer  *headerTapped   = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionHeaderTapped:)];
    [sectionView addGestureRecognizer:headerTapped];
    
    return  sectionView;
    
    
}

- (void)sectionHeaderTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:gestureRecognizer.view.tag];
    
    if (indexPath.row == 0)
    {
        BOOL collapsed  = [[arrayForBool objectAtIndex:indexPath.section] boolValue];
        for (int i=0; i<[sectionTitleArray count]; i++)
        {
            if (indexPath.section==i)
            {
                [arrayForBool replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:!collapsed]];
            }
        }
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:gestureRecognizer.view.tag] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    //cell.imageView.image=[UIImage imageNamed:@"Fileclosed"];
    
    BOOL manyCells  = [[arrayForBool objectAtIndex:indexPath.section] boolValue];
    
    /********** If the section supposed to be closed *******************/
    if(!manyCells)
    {
        cell.backgroundColor=[UIColor clearColor];
        
        cell.textLabel.text=@"";
    }
    /********** If the section supposed to be Opened *******************/
    else
    {
        UILabel* fileNameLabel=(UILabel*)[cell viewWithTag:101];
        fileNameLabel.text=[NSString stringWithFormat:@"File%ld",(long)indexPath.row];
        fileNameLabel.font=[UIFont systemFontOfSize:15.0f];
        UIImageView* fileDownloadImageView=(UIImageView*)[cell viewWithTag:102];
        fileDownloadImageView.image=[UIImage imageNamed:@"FileDownload"];

       // cell.imageView.image=[UIImage imageNamed:@"point.png"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone ;
    }
    //cell.textLabel.textColor=[UIColor blackColor];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[arrayForBool objectAtIndex:indexPath.section] boolValue])
    {
        return 40;
    }
    return 0;
    
}


-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.tableView reloadData];

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

@end
