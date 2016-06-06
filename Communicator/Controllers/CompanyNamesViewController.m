//
//  CompanyNamesViewController.m
//  Communicator
//
//  Created by mac on 12/05/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import "CompanyNamesViewController.h"
#import "MainTabBarViewController.h"
#import "Database.h"
@interface CompanyNamesViewController ()

@end

@implementation CompanyNamesViewController

- (void)viewDidLoad

{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
   self.navigationItem.hidesBackButton=YES;
    self.tabBarController.navigationItem.title = @"Company";
    self.navigationItem.title = @"Company";
    self.tabBarController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"SignOut"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewController1)] ;
    self.tabBarController.navigationItem.title = @"Dashboard";
    //self.navigationController.navigationBar.barTintColor = [UIColor communicatorColor];
    self.tabBarController.navigationItem.leftBarButtonItem.tintColor=[UIColor whiteColor];

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
//    
//    NSLog(@"%lu",(unsigned long)app.permittedCompaniesForUserArray.count);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    UILabel* companyNameLabel=(UILabel*)[cell viewWithTag:101];
    NSLog(@"%ld",app.companynameOrIdArray.count);

    //cell.textLabel.text=[app.companynameOrIdArray objectAtIndex:indexPath.row];
    //cell.textLabel.backgroundColor=[UIColor blackColor];
   companyNameLabel.text=[app.companynameOrIdArray objectAtIndex:indexPath.row];
   // companyNameLabel.text=[UIColor blackColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Database* db=[Database shareddatabase];
    AppPreferences *app=[AppPreferences sharedAppPreferences];

    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel* companyNameLabel=(UILabel*)[selectedCell viewWithTag:101];
    NSLog(@"%@",companyNameLabel.text);
    NSString* companyNameString=[NSString stringWithFormat:@"%@",companyNameLabel.text];
    NSLog(@"%@",companyNameString);

    
    [db getFeedbackAndQueryCounterForCompany:companyNameString];

    NSLog(@"%ld",app.feedQueryCounterDictsWithTypeArray.count);
    MainTabBarViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MainTabBarViewController"];
    
    [self.navigationController pushViewController:vc animated:YES];



}

@end
