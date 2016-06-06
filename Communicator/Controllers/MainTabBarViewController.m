//
//  MainTabBarViewController.m
//  Communicator
//
//  Created by mac on 16/05/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import "MainTabBarViewController.h"
#import "HomeViewController.h"
#import "CompanyNamesViewController.h"
#import "ReportAndDocsViewController.h"
#import "CreateNewMOMViewController.h"
@interface MainTabBarViewController ()

@end

@implementation MainTabBarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
     [self setDelegate:self];

    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{

    [self.navigationItem setHidesBackButton:YES];
    HomeViewController* vc= [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
    CompanyNamesViewController* vc1= [self.storyboard instantiateViewControllerWithIdentifier:@"CompanyNamesViewController"];
    CreateNewMOMViewController* vc2= [self.storyboard instantiateViewControllerWithIdentifier:@"CreateNewMOMViewController"];
     ReportAndDocsViewController* vc3= [self.storyboard instantiateViewControllerWithIdentifier:@"ReportAndDocsViewController"];
    AppPreferences* app=[AppPreferences sharedAppPreferences];
  // UINavigationController* navVC= [self.tabBarController.navigationController initWithRootViewController:vc];
   UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:vc];

    NSString* companyname;
   
    if (app.companynameOrIdArray.count>1)
    {
       
        NSMutableArray *tabViewControllers = [[NSMutableArray alloc] init];
        
        [tabViewControllers addObject:navVC];
        [tabViewControllers addObject:vc1];

        [tabViewControllers addObject:vc2];
        [tabViewControllers addObject:vc3];
        [self setViewControllers:tabViewControllers];

    }
    else
    {
        NSMutableArray *tabViewControllers = [[NSMutableArray alloc] init];
        
        [tabViewControllers addObject:navVC];
        
        [tabViewControllers addObject:vc2];
        [tabViewControllers addObject:vc3];
        [self setViewControllers:tabViewControllers];


    }
    
    

        //can't set this until after its added to the tab bar
    vc.tabBarItem =
    [[UITabBarItem alloc] initWithTitle:@"Dashboard"
                                  image:[UIImage imageNamed:@"DashboardBlue"]
                                    tag:1];
    vc1.tabBarItem =
    [[UITabBarItem alloc] initWithTitle:@"Select Company"
                                  image:[UIImage imageNamed:@"SwitchCompanyBlue"]
                                    tag:2];
    vc2.tabBarItem =
    [[UITabBarItem alloc] initWithTitle:@"Meeting Minutes"
                                  image:[UIImage imageNamed:@"MOMBlue"]
                                    tag:3];
    
    vc3.tabBarItem =
    [[UITabBarItem alloc] initWithTitle:@"Report and Docs"
                                  image:[UIImage imageNamed:@"ReportsAndDocumentsBlue"]
                                    tag:3];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    NSLog(@"%@",viewController);
    if (tabBarController.selectedIndex==0) {
        HomeViewController* vc=[[HomeViewController alloc]init];
//        [vc setSelectedButton:0];
    }
   // NSLog(@"%i",tabBarController.selectedIndex);
    NSLog(@"hello");
    
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
