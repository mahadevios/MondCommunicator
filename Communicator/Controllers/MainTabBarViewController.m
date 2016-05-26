//
//  MainTabBarViewController.m
//  Communicator
//
//  Created by mac on 16/05/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import "MainTabBarViewController.h"
#import "HomeViewController.h"
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
