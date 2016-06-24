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
    // userName.text=@"details";
    AppPreferences* app=[AppPreferences sharedAppPreferences];

    Mom* momObj= [app.allMomArray objectAtIndex:self.selectedRow];

    UILabel* feedTextLbl= [[UILabel alloc]initWithFrame:CGRectMake(5.0f, 0.0f, self.view.frame.size.width - 10.0f, 30.0f)];
    [feedTextLbl setFont:[UIFont systemFontOfSize:12.0f]];
    feedTextLbl.lineBreakMode = UILineBreakModeWordWrap;
    feedTextLbl.numberOfLines = 10000000;
    // feedTextLbl.text= @"gfhghj gg gh kljh klh lkjhkl lkh klh lkhlk klj klh kljh klh kljh lkhjkl kljh kljh kljh kljh klh kljh k fghdf hdf hdfh dh h h dfhdfh dfh dfh h h dfh h dfhdf hdfh dfh dfh dfhdfhdfh dfhd hdfh dhdh lhj lkjh kljh l;khj lkh lkhj klj kljh klj hhj";
    
    //CGRect newFrame= [self getFrameSize:momObj label:cell.textLabel];
    
   
    
    //return 40 + newFrame.size.height;
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

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
