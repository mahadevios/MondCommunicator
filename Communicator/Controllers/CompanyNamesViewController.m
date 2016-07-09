//
//  CompanyNamesViewController.m
//  Communicator
//
//  Created by mac on 12/05/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import "CompanyNamesViewController.h"
#import "MainTabBarViewController.h"
#import "HomeViewController.h"
#import "Database.h"
#import "ReportAndDocsViewController.h"
#import "MainMOMViewController.h"
#import "UIColor+CommunicatorColor.h"
@interface CompanyNamesViewController ()

@end

@implementation CompanyNamesViewController
@synthesize SelectComapnyHeaderLabel;
- (void)viewDidLoad

{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self setNavigationBar];
}

#pragma mark:setNavigationBar

-(void)setNavigationBar
{
    self.navigationItem.hidesBackButton=YES;
    self.tabBarController.navigationItem.title = @"Select Company";
    self.navigationItem.title = @"Select Company";
    self.tabBarController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"SignOut"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewController1)] ;
    self.tabBarController.navigationItem.rightBarButtonItem=nil;
    SelectComapnyHeaderLabel.textColor=[UIColor communicatorColor];
    self.tabBarController.navigationItem.leftBarButtonItem.tintColor=[UIColor whiteColor];
}
-(void)popViewController1
{
    UINavigationController *navController = self.navigationController;
    UIViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginNaviagationController"];
    [navController presentViewController:vc animated:YES completion:nil];
    NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:NULL forKey:@"userObject"];
    [defaults setObject:NULL forKey:@"selectedCompany"];
    
}

#pragma mark:tableView delegates and dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    AppPreferences *app=[AppPreferences sharedAppPreferences];
    NSLog(@"%ld",app.companynameOrIdArray.count);
    return app.companynameOrIdArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppPreferences *app=[AppPreferences sharedAppPreferences];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    UILabel* companyNameLabel=(UILabel*)[cell viewWithTag:101];
    NSLog(@"%ld",app.companynameOrIdArray.count);
    companyNameLabel.text=[app.companynameOrIdArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Database* db=[Database shareddatabase];
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel* companyNameLabel=(UILabel*)[selectedCell viewWithTag:101];
    NSString* companyNameString=[NSString stringWithFormat:@"%@",companyNameLabel.text];
    [[NSUserDefaults standardUserDefaults] setValue:companyNameString forKey:@"selectedCompany"];
    [db getFeedbackAndQueryCounterForCompany:companyNameString];
    MainTabBarViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MainTabBarViewController"];
    HomeViewController * vc1 = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
    if (self.tabBarController.selectedViewController==self)
    {
        [vc1 feedbackAndQuerySearch];
        self.tabBarController.selectedIndex= 0;

    }
    else
    [self.navigationController pushViewController:vc animated:YES];

}

@end
