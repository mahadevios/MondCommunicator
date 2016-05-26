//
//  CreateNewFeedbackViewController.m
//  Communicator
//
//  Created by mac on 19/05/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import "CreateNewFeedbackViewController.h"
#import "UIColor+CommunicatorColor.h"
@interface CreateNewFeedbackViewController ()

@end

@implementation CreateNewFeedbackViewController

@synthesize SONumberTextField;
@synthesize AvayaIdTextField;
@synthesize DocumentIdTextField;
@synthesize SubjectTextView;
@synthesize OperatorTextField;
@synthesize DescriptionTextView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.barTintColor = [UIColor communicatorColor];
    [self.navigationController.navigationBar setBarStyle:UIStatusBarStyleLightContent];// to set carrier,time and battery color in white color
//    SONumberTextField.layer.cornerRadius=0.0f;
//    AvayaIdTextField.layer.cornerRadius=0.0f;
//    //AvayaIdTextField.layer.masksToBounds=YES;
//    AvayaIdTextField.layer.borderColor=[[UIColor colorWithRed:255 green:255 blue:255 alpha:1]CGColor];
//    AvayaIdTextField.layer.borderWidth= 1.0f;
//
//    DocumentIdTextField.layer.cornerRadius=0.0f;
//    SubjectTextView.layer.cornerRadius=0.0f;
//    OperatorTextField.layer.cornerRadius=0.0f;
//    DescriptionTextView.layer.cornerRadius=0.0f;

    NSLog(@"hello github");

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

- (IBAction)dismissViewController:(id)sender
{
    [self dismissViewControllerAnimated:self completion:nil];
    
}
@end
