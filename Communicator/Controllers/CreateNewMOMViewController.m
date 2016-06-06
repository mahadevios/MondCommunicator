//
//  CreateNewMOMViewController.m
//  Communicator
//
//  Created by mac on 19/05/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import "CreateNewMOMViewController.h"

@interface CreateNewMOMViewController ()

@end

@implementation CreateNewMOMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
//    self.navigationItem.title = @"New MOM";
    self.tabBarController.navigationItem.title = @"New MOM";
    self.tabBarController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"SignOut"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewController1)] ;
    self.tabBarController.navigationItem.title = @"Dashboard";
    [self.navigationItem setHidesBackButton:NO];
   // self.navigationController.navigationBar.barTintColor = [UIColor communicatorColor];
    self.tabBarController.navigationItem.leftBarButtonItem.tintColor=[UIColor whiteColor];

}
-(void)popViewController1
{
    UINavigationController *navController = self.navigationController;
    UIViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginNaviagationController"];
    [navController presentViewController:vc animated:YES completion:nil];
    NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:NULL forKey:@"userObject"];
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
