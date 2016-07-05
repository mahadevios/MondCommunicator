//
//  CreateNewMOMViewController.m
//  Communicator
//
//  Created by mac on 19/05/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import "CreateNewMOMViewController.h"
#import "UIColor+CommunicatorColor.h"
#import "Mom.h"
#import "Database.h"

@interface CreateNewMOMViewController ()

@end

@implementation CreateNewMOMViewController

@synthesize subjectTextField;
@synthesize dateTextField;
@synthesize attendiesTextview;
@synthesize keyPointstextView;


- (void) viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void) viewWillAppear:(BOOL)animated
{
    NSLog(@"%@",[NSString stringWithFormat:@"%@",[[APIManager sharedManager] getDate]]);
    self.navigationController.navigationBar.barTintColor = [UIColor communicatorColor];
    [self.navigationController.navigationBar setBarStyle:UIStatusBarStyleLightContent];// to set carrier,time and battery color in white color
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(validateUserResponseForNewMOM:) name:NOTIFICATION_SEND_MOM
                                               object:nil];
    dateTextField.delegate=self;
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    [datePicker setDate:[NSDate date]];
    [datePicker addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
    [dateTextField setInputView:datePicker];
}


-(void)updateTextField:(id)sender
{
    UIDatePicker *picker = (UIDatePicker*)dateTextField.inputView;
    dateTextField.text = [NSString stringWithFormat:@"%@",picker.date];
}


- (void)validateUserResponseForNewMOM:(NSNotification *)notification
{
    
    NSLog(@"got notification from server");
    if ([[notification.object objectForKey:@"code"] isEqualToString:SUCCESS])
    {
        NSError* error;
        gotResponse=TRUE;
        [self saveNewMOM:notification.object];
        //NSString* str=[NSString stringWithFormat:@"%@",notification];
//        NSString* companyFeedbackTypeAsscociationString=[notification.object objectForKey:@"newMomId"];
//        NSData *companyFeedbackTypeAsscociationData = [companyFeedbackTypeAsscociationString dataUsingEncoding:NSUTF8StringEncoding];
//        
//        NSString *companyFeedbackTypeAsscociationValue = [NSJSONSerialization JSONObjectWithData:companyFeedbackTypeAsscociationData
//                                                                                         options:NSJSONReadingAllowFragments
//                                                                                           error:&error];
        
       // NSLog(@"%@",companyFeedbackTypeAsscociationString);
    }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)dismissViewController:(id)sender
{
    [self dismissViewControllerAnimated:self completion:nil];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)sendNewMom:(id)sender
{
    [self saveNewMOM:nil];
}

-(void)saveNewMOM:(NSDictionary*)momResponseDict
{
    
    if (subjectTextField.text!=nil)
    {
        if (dateTextField.text!=nil)
        {
            if (attendiesTextview.text!=nil)
            {
                if (keyPointstextView.text!=nil)
                {
                    
                    NSString* userFrom;
                    NSString* userTo;
                    
                    Database *db=[Database shareddatabase];
                    NSString* username = [[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"];
                    NSString* companyId=[db getCompanyId:username];
                    NSString* userFeedback=[db getUserIdFromUserName:username];
                    
                    // NSString* selectedCompany = [[NSUserDefaults standardUserDefaults]valueForKey:@"selectedCompany"];
                    if ([companyId isEqual:@"1"])
                    {
                        userFrom=@"1";
                        username=[db getUserNameFromCompanyname:[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedCompany"]];
                        userTo=[db getUserIdFromUserNameWithRoll1:username];
                        
                        //userTo=[db getCompanyId: [[NSUserDefaults standardUserDefaults]valueForKey:@"selectedCompany"]];
                        
                    }
                    
                    else
                    {
                        
                        userTo=@"1";
                        userFrom= [db getUserIdFromUserNameWithRoll1:username];
                        
                        
                    }
                    
                    //NSArray* operatorAndStausidArray=[db getOperatotAndStatusIdArrayFromSoNo:feedObject.soNumber];
                    
                    //                Feedback* feedObj=[[Feedback alloc]init];
                    NSDate* date= [[APIManager sharedManager] getDate];
                    NSTimeInterval seconds = [date timeIntervalSince1970];
                    double milliseconds = seconds*1000;
                    
                    
                    Mom* momObj=[[Mom alloc]init];
                    
                    momObj.subject=subjectTextField.text;
                    momObj.momDate=dateTextField.text;
                    momObj.attendee=attendiesTextview.text;
                    momObj.keyPoints=keyPointstextView.text;
                    momObj.userfeedback=[userFeedback intValue];
                    momObj.userFrom=[userFrom intValue];
                    momObj.userTo=[userTo intValue];
                    momObj.dateTime=[NSString stringWithFormat:@"%@",[[APIManager sharedManager] getDate]];
                    // feedObj.feedbackCounter=[[NSString stringWithFormat:@"%@",[maxFeedIdAndCounterArray objectAtIndex:1]]longLongValue];
                    //feedObj.feedbackId=[[NSString stringWithFormat:@"%@",[maxFeedIdAndCounterArray objectAtIndex:0]]longLongValue];
                    
                    //NSLog(@"%d,%d",feedObj.userFrom,feedObj.userTo);
                    //feedObj.statusId=[[NSString stringWithFormat:@"%@",[maxFeedIdAndCounterArray objectAtIndex:2]]intValue];
                    //feedObj.operatorId=[[NSString stringWithFormat:@"%@",[maxFeedIdAndCounterArray objectAtIndex:3]]intValue];
                    //feedObj.attachment;
                    NSLog(@"%@,%@,%@,%@,%d,%d,%d,%@",momObj.subject,momObj.momDate, momObj.attendee,momObj.keyPoints,momObj.userfeedback,momObj.userFrom,momObj.userTo,momObj.dateTime);
                    
                    
                    NSArray* keys=[NSArray arrayWithObjects:@"subject",@"createdDate",@"attendee",@"keyPoints",@"userFrom",@"userTo",@"userFeedback",@"submittedDateTime",@"momId",nil];
                    // NSArray* values=[NSArray arrayWithObjects:feedObj.soNumber,feedObj.userFrom,feedObj.userTo,feedObj.feedbackText,feedObj.feedbackType,feedObj.feedbackCounter+1, nil];
                    
                    NSArray* values=@[momObj.subject,momObj.momDate, momObj.attendee,momObj.keyPoints,[NSString stringWithFormat:@"%d",momObj.userFrom],[NSString stringWithFormat:@"%d",momObj.userTo],[NSString stringWithFormat:@"%d",momObj.userfeedback],momObj.dateTime,[NSString stringWithFormat:@"%ld",momObj.Id]];
                    
                    NSDictionary* dic=[NSDictionary dictionaryWithObjects:values forKeys:keys];
                    NSLog(@"%@",[dic valueForKey:@"userFeedback"]);
                    
                    NSMutableDictionary* MainDict=[NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] valueForKey:@"flag"],@"flag",dic,@"feedcomOrQuerycom", nil];
                    //NSDictionary* dict=[MainDict valueForKey:@"feedcomOrQuerycom"];
                    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"flag"]);
                    [[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"];
                    [[NSUserDefaults standardUserDefaults] valueForKey:@"currentPassword"];
                    
                    
                    if (gotResponse)
                    {
                        
                        momObj.Id=[[momResponseDict valueForKey:@"MomId"]longLongValue];
                        keys=[NSArray arrayWithObjects:@"subject",@"createdDate",@"attendee",@"keyPoints",@"userFrom",@"userTo",@"userFeedback",@"submittedDateTime",@"momId",nil];
                        values=@[momObj.subject,momObj.momDate, momObj.attendee,momObj.keyPoints,[NSString stringWithFormat:@"%d",momObj.userFrom],[NSString stringWithFormat:@"%d",momObj.userTo],[NSString stringWithFormat:@"%d",momObj.userfeedback],momObj.dateTime,[NSString stringWithFormat:@"%ld",momObj.Id]];
                        
                        dic=[NSDictionary dictionaryWithObjects:values forKeys:keys];
                        [db insertNewMOM:dic];
                        //[db setMOMView];
                        gotResponse=FALSE;
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert"
                                                                                                 message:@"MOM generated sucessfully"
                                                                                          preferredStyle:UIAlertControllerStyleAlert];
                        //We add buttons to the alert controller by creating UIAlertActions:
                        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                                           style:UIAlertActionStyleDefault
                                                                         handler:^(UIAlertAction *action)
                                                   {
                                                      
                                                       [self dismissViewControllerAnimated:YES completion:nil];
                                                   }]; //You can use a block here to handle a press on this button
                        [alertController addAction:actionOk];
                        [self presentViewController:alertController animated:YES completion:nil];

                        
                    }
                    else
                    [[APIManager sharedManager] sendNewMOM:dic username:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"] password:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentPassword"]];
                    //[[APIManager sharedManager]sendUpdatedRecords:[[NSUserDefaults standardUserDefaults] valueForKey:@"flag"] andPassword:dic];
                    // [[APIManager sharedManager] sendUpdatedRecords:[[NSUserDefaults standardUserDefaults] valueForKey:@"flag"] Dict:dic username:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"] password:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentPassword"]];
                    
                    
                }
            }
            
        }
    }


}
@end
