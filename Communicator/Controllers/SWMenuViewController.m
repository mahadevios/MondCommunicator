//
//  SWMenuViewController.m
//  Communicator
//
//  Created by mac on 05/04/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import "SWMenuViewController.h"
//#import "SWRevealViewController.h"
#import "UIColor+CommunicatorColor.h"
@interface SWMenuViewController ()

@end

@implementation SWMenuViewController
NSArray* menuItem;
UIAlertController *alertController;
UIAlertAction *actionOk;
- (void)viewDidLoad
{
    [super viewDidLoad];

}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    // Configure the cell...
    menuItem=[NSArray arrayWithObjects:@"FeedCom",@"QueryCom", @"Dropbox",@"Logout",nil];
    
    if (indexPath.row==0)
    {
        cell.imageView.image=[UIImage imageNamed:@"UserProfileImage"];
        cell.textLabel.text=@"ABC";
        cell.textLabel.textColor=[UIColor whiteColor];
        cell.backgroundColor=[UIColor communicatorColor];
    }
    else
    {
        cell.textLabel.text=[menuItem objectAtIndex:indexPath.row-1];
        cell.imageView.image=[UIImage imageNamed:[menuItem objectAtIndex:indexPath.row-1]];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //SWRevealViewController * vc;
    // HomeViewController* ob=[[HomeViewController alloc]init];
    // HomeViewController* vd = vc.frontViewController.class;
    NSUserDefaults* defaults= [NSUserDefaults standardUserDefaults];
    
//    switch (indexPath.row)
//    {
//        case 1:
//            //vc = (SWRevealViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
//           // [self.navigationController pushViewController:vc animated:YES];
//            
//            [defaults setObject:@"0" forKey:@"flag"];
//            [defaults synchronize];
//            break;
//            
//        case 2:
//            vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
//            [self.navigationController pushViewController:vc animated:YES];
//            
//            [defaults setObject:@"1" forKey:@"flag"];
//            [defaults synchronize];
//            break;
//            
//        case 3:alertController = [UIAlertController alertControllerWithTitle:@"In Progress" message:@"Try later" preferredStyle:UIAlertControllerStyleAlert];
//            [self presentViewController:alertController animated:YES completion:nil];
//            actionOk = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]; //You can use a block here to handle a press on this button
//            [alertController addAction:actionOk];
//            break;
//            
//        case 4:
//            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"rememberMe"];
////            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"logout"];
//            vc = (SWRevealViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
//            [self.navigationController pushViewController:vc animated:YES];
//            break;
//            
//        default:
//            break;
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height=44;
    if (indexPath.row==0)
    {
        height=100;
    }
    return height;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
