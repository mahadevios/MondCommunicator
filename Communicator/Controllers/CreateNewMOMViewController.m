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
@synthesize insideView;

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
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    [datePicker setDate:[[APIManager sharedManager] getDate]];
    [datePicker addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
    [dateTextField setInputView:datePicker];
    subjectTextField.delegate=self;
    attendiesTextview.delegate=self;
    keyPointstextView.delegate=self;
}

-(void)updateTextField:(id)sender
{
    UIDatePicker *picker = (UIDatePicker*)dateTextField.inputView;
    NSDateFormatter *formatter=[NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString* date= [formatter stringFromDate:picker.date];
    dateTextField.text = [NSString stringWithFormat:@"%@",date];
}


- (void)validateUserResponseForNewMOM:(NSNotification *)notification
{
    
    NSLog(@"got notification from server");
    if ([[notification.object objectForKey:@"code"] isEqualToString:SUCCESS])
    {
        gotResponse=TRUE;
        [self saveNewMOM:notification.object];

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
                    
                    Mom* momObj=[[Mom alloc]init];
                    
                    momObj.subject=subjectTextField.text;
                    momObj.momDate=dateTextField.text;
                    momObj.attendee=attendiesTextview.text;
                    momObj.keyPoints=keyPointstextView.text;
                    momObj.userfeedback=[userFeedback intValue];
                    momObj.userFrom=[userFrom intValue];
                    momObj.userTo=[userTo intValue];
                    momObj.dateTime=[NSString stringWithFormat:@"%@",[[APIManager sharedManager] getDate]];
                    
                    NSLog(@"%@,%@,%@,%@,%d,%d,%d,%@",momObj.subject,momObj.momDate, momObj.attendee,momObj.keyPoints,momObj.userfeedback,momObj.userFrom,momObj.userTo,momObj.dateTime);
                    
                    
                    NSArray* keys=[NSArray arrayWithObjects:@"subject",@"createdDate",@"attendee",@"keyPoints",@"userFrom",@"userTo",@"userFeedback",@"submittedDateTime",@"momId",nil];
                   
                    NSArray* values=@[momObj.subject,momObj.momDate, momObj.attendee,momObj.keyPoints,[NSString stringWithFormat:@"%d",momObj.userFrom],[NSString stringWithFormat:@"%d",momObj.userTo],[NSString stringWithFormat:@"%d",momObj.userfeedback],momObj.dateTime,[NSString stringWithFormat:@"%ld",momObj.Id]];
                    
                    NSDictionary* dic=[NSDictionary dictionaryWithObjects:values forKeys:keys];
                    NSLog(@"%@",[dic valueForKey:@"userFeedback"]);
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
                        gotResponse=FALSE;
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert"
                                                                                                 message:@"MOM generated sucessfully"
                                                                                          preferredStyle:UIAlertControllerStyleAlert];
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
                    
                    
                    
                }
            }
            
        }
    }


}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if (textField==dateTextField)
    {
        [self moveViewUp:YES];
    }
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==subjectTextField)
    {
        //[self moveViewUp:YES];

        [dateTextField becomeFirstResponder];
    }
    if (textField==dateTextField)
    {
        [attendiesTextview becomeFirstResponder];
        // [self moveViewUp:YES];
        
    }
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"])
    {
        if(textView==attendiesTextview)
        {
            [attendiesTextview resignFirstResponder];
            //[self moveViewUp:YES];
        }
        else
        {
            [textView resignFirstResponder];
            [self moveViewUp:NO];
        }
        // Return FALSE so that the final '\n' character doesn't get added
        return NO;
    }
    // For any other character return TRUE so that the text gets added to the view
    return YES;
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
   
    if (textView==attendiesTextview)
    {
        [keyPointstextView becomeFirstResponder];
        //[self moveViewUp:YES];
        
    }
    else
    {
        [textView resignFirstResponder];
        [self moveViewUp:NO];

    }
    NSLog(@"%ld",(long)[[UIDevice currentDevice] orientation]);
    
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [self moveViewUp:YES];
}



- (void) moveViewUp: (BOOL) isUp
{
    const int movementDistance = 70; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
   
    //    if (!isUp)
    //    {
    //        movementDistance=totalMovement;
    //        totalMovement=0;
    //    }
    
    movement = (isUp ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    insideView.frame = CGRectOffset(insideView.frame, 0, movement);
    [UIView commitAnimations];
}

@end
