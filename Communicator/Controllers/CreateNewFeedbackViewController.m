//
//  CreateNewFeedbackViewController.m
//  Communicator
//
//  Created by mac on 19/05/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import "CreateNewFeedbackViewController.h"
#import "UIColor+CommunicatorColor.h"
#import "Feedback.h"
#import "Database.h"
#import "HomeViewController.h"
#import "FeedQueryCounter.h"
@interface CreateNewFeedbackViewController ()

@end

@implementation CreateNewFeedbackViewController

@synthesize SONumberTextField;
@synthesize AvayaIdTextField;
@synthesize DocumentIdTextField;
@synthesize SubjectTextView;
@synthesize OperatorTextField;
@synthesize DescriptionTextView;
@synthesize scrollview;
@synthesize insideView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    Database* db=[Database shareddatabase];
    allOperatorUsernamesDict= [db getAllOperaotorUsernames];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    OperatorTextField.delegate=self;
    DescriptionTextView.delegate=self;
    SONumberTextField.delegate=self;
    AvayaIdTextField.delegate=self;
    DocumentIdTextField.delegate=self;
    SubjectTextView.delegate=self;
    self.navigationController.navigationBar.barTintColor = [UIColor communicatorColor];
    [self.navigationController.navigationBar setBarStyle:UIStatusBarStyleLightContent];// to set carrier,time and battery color in white color

 
       [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(validateUserResponse:) name:NOTIFICATION_SEND_NEWFEEDBACK
                                               object:nil];
//   
//    AvayaIdTextField.tag=0;
//    DocumentIdTextField.tag=0;
//    OperatorTextField.tag=0;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)validateUserResponse:(NSNotification *)notification
{
    if ([[notification.object objectForKey:@"code"] isEqualToString:SUCCESS])
    {
        gotResponse=TRUE;
        NSString* companyFeedbackTypeAsscociationString=[notification.object objectForKey:@"feedbackCounterId"];
        
        
        NSLog(@"%@",companyFeedbackTypeAsscociationString);
        [self sendNewFeedbackOrSaveResponse:notification.object];
    }
}

#pragma mark:UIPickerViewDataSource,UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
   
    return allOperatorUsernamesDict.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
  NSArray* arr=  [allOperatorUsernamesDict allKeys];
    NSString * title = [arr objectAtIndex:row];
        return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSArray* arr=  [allOperatorUsernamesDict allKeys];

    OperatorTextField.text=  [arr objectAtIndex:row];
}

-(void)doneBtnPressToGetValue:(id)sender
{
    [OperatorTextField resignFirstResponder];
    [self removePickerToolBar];
}
#pragma mark-texField delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==SONumberTextField)
    {
        [AvayaIdTextField becomeFirstResponder];
    }
    if (textField==AvayaIdTextField)
    {
        [DocumentIdTextField becomeFirstResponder];
       // [self moveViewUp:YES];

    }
    if (textField==DocumentIdTextField)
    {
        [SubjectTextView becomeFirstResponder];
       // [self moveViewUp:YES];

    }
    if (textField==OperatorTextField)
    {
        [DescriptionTextView becomeFirstResponder];
        
    }

    return YES;
}


- (void) addPickerToolBar
{
    picker=[[UIPickerView alloc]init];
    picker.frame = CGRectMake(0.0f, self.view.frame.size.height - 216.0f, self.view.frame.size.width, 216.0f);
    picker.delegate = self;
    picker.dataSource = self;
    picker.showsSelectionIndicator = YES;
    [self.view addSubview:picker];
    picker.userInteractionEnabled = true;
    picker.backgroundColor = [UIColor lightGrayColor];
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneBtnPressToGetValue:)];
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, picker.frame.origin.y - 40.0f, self.view.frame.size.width, 40.0f)];
    toolBar.tag = 10000;
    [toolBar setItems:[NSArray arrayWithObject:btn]];
    [self.view addSubview:toolBar];

}

- (void) removePickerToolBar
{
    [picker removeFromSuperview];
    UIView *toolBar = (UIView *)[self.view viewWithTag:10000];
    if (toolBar != NULL)
    {
        [toolBar removeFromSuperview];
    }
}

#pragma mark-texView delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"])
    {
        if(textView==SubjectTextView)
        {
            [self.OperatorTextField resignFirstResponder];
            [self.view endEditing:true];
            [self moveViewUp:YES];
            
            [self performSelector:@selector(addPickerToolBar) withObject:nil afterDelay:0.5];

        }
        else
            [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField==AvayaIdTextField)
    {
//        if ( !(AvayaIdTextField.tag==1))
//        {
            [self moveViewUp:YES];
            AvayaIdTextField.tag=1;
       // }
        
    }
    if (textField==DocumentIdTextField)
    {
//        if ( !(DocumentIdTextField.tag==1))
//        {
         [self moveViewUp:YES];
         DocumentIdTextField.tag=1;
       // }
    }
    if (textField==OperatorTextField)
    {
        [self.OperatorTextField resignFirstResponder];
        [self.view endEditing:true];
        [self moveViewUp:YES];
        
        [self performSelector:@selector(addPickerToolBar) withObject:nil afterDelay:0.5];

    }
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
   
    [self moveViewUp:YES];
    
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView==DescriptionTextView)
    {
        [DescriptionTextView resignFirstResponder];
        [self moveViewUp:NO];

    }
    NSLog(@"%ld",(long)[[UIDevice currentDevice] orientation]);
    
}


- (void) moveViewUp: (BOOL) isUp
{
   const int movementDistance = 80; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    if (isUp)
    {
        totalMovement=totalMovement+70;
    }
    movement = (isUp ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    insideView.frame = CGRectOffset(insideView.frame, 0, movement);
    [UIView commitAnimations];
}



- (IBAction)dismissViewController:(id)sender
{
    [self dismissViewControllerAnimated:self completion:nil];
    
}

- (IBAction)sendNewFeedback:(id)sender
{
    NSLog(@"%@",self.feedbackType);
    [self sendNewFeedbackOrSaveResponse:nil];
}

-(void)sendNewFeedbackOrSaveResponse:(NSDictionary*)reponseDict
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert"
                                                                             message:@"Please select the operator"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    //We add buttons to the alert controller by creating UIAlertActions:
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action)
                               {
                                   
                                   [self.tabBarController.navigationController dismissViewControllerAnimated:YES completion:nil];
                               }]; //You can use a block here to handle a press on this button
    [alertController addAction:actionOk];
    if(!(SONumberTextField.text.length==0) || !(AvayaIdTextField.text.length==0) || !(DocumentIdTextField.text.length==0))
    {
        if (SubjectTextView.text.length!=0)
        {
            if (OperatorTextField.text!=nil)
            {
                
                NSString* userFrom;
                NSString* userTo;
                
                Database *db=[Database shareddatabase];
                NSString* username = [[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"];
                NSString* companyId=[db getCompanyId:username];
                NSString* userFeedback=[db getUserIdFromUserName:username];
                NSLog(@"%@",self.feedbackType);
                NSMutableArray* feedidCounterAndFeedbackTypeArray=[db getFeedTypeIdAndMaxCounter:self.feedbackType];
                
                if ([companyId isEqual:@"1"])
                {
                    userFrom=@"1";
                    username=[db getUserNameFromCompanyname:[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedCompany"]];
                    userTo=[db getUserIdFromUserNameWithRoll1:username];
                    
                }
                
                else
                {
                    
                    userTo=@"1";
                    userFrom= [db getUserIdFromUserNameWithRoll1:username];
                    
                    
                }
                
                
                NSDate* date= [[APIManager sharedManager] getDate];
                NSTimeInterval seconds = [date timeIntervalSince1970];
                double milliseconds = seconds*1000;
                
                Feedback* feedObj=[[Feedback alloc]init];
                if (SONumberTextField.text.length <=0)
                {
                    SONumberTextField.text=@"0";
                }
                if (AvayaIdTextField.text.length <=0)
                {
                    AvayaIdTextField.text=@"0";
                    
                }
                if (DocumentIdTextField.text.length <=0)
                {
                    DocumentIdTextField.text=@"0";
                }
                
                feedObj.soNumber=[NSString stringWithFormat:@"%@#@%@#@%@",SONumberTextField.text,AvayaIdTextField.text,DocumentIdTextField.text];
                feedObj.emailSubject=[NSString stringWithFormat:@"%@ %ld",SubjectTextView.text,(long)milliseconds];
                feedObj.operatorId=[[allOperatorUsernamesDict valueForKey:OperatorTextField.text]intValue];
                feedObj.feedbackText=DescriptionTextView.text;
                feedObj.userFrom=[userFrom intValue];
                feedObj.userTo=[userTo intValue];
                feedObj.userFeedback=[userFeedback intValue];
                
                NSString* dts=[NSString stringWithFormat:@"%@",[[APIManager sharedManager] getDate]];
                NSArray* dt= [dts componentsSeparatedByString:@" "];
                feedObj.dateOfFeed=[NSString stringWithFormat:@"%@"@" "@"%@",[dt objectAtIndex:0],[dt objectAtIndex:1]];
                //feedObj.dateOfFeed=[NSString stringWithFormat:@"%@",[[APIManager sharedManager] getDate]];
                feedObj.feedbackType=[[feedidCounterAndFeedbackTypeArray objectAtIndex:2]intValue];
                feedObj.feedbackId=[[feedidCounterAndFeedbackTypeArray objectAtIndex:0]intValue];
                feedObj.feedbackCounter=[[feedidCounterAndFeedbackTypeArray objectAtIndex:1]intValue];
                feedObj.attachment=@"";
                feedObj.statusId=1;
                
                
                NSLog(@"%d,%d",feedObj.userFrom,feedObj.userTo);
               
                NSLog(@"%@,%@,%d,%@,%@,%ld,%ld,%d,%d",feedObj.soNumber,feedObj.emailSubject, feedObj.feedbackType,feedObj.feedbackText,feedObj.dateOfFeed,feedObj.feedbackCounter,feedObj.feedbackId,feedObj.operatorId,feedObj.statusId);
                
                
                NSArray* keys=[NSArray arrayWithObjects:@"feedbackId",@"soNumber",@"subject",@"userFrom",@"userTo",@"userFeedback",@"feedText",@"feedbackType",@"feedbackCounter",@"operatorId",@"dateOfFeed",@"statusId",@"attachment",nil];
               
                NSArray* values=@[[NSString stringWithFormat:@"%ld",feedObj.feedbackId+1],feedObj.soNumber,feedObj.emailSubject,[NSString stringWithFormat:@"%d",feedObj.userFrom],[NSString stringWithFormat:@"%d",feedObj.userTo],[NSString stringWithFormat:@"%d",feedObj.userFeedback],feedObj.feedbackText,[NSString stringWithFormat:@"%d",feedObj.feedbackType],[NSString stringWithFormat:@"%ld",feedObj.feedbackCounter+1],[NSString stringWithFormat:@"%d",feedObj.operatorId],feedObj.dateOfFeed,[NSString stringWithFormat:@"%d",feedObj.statusId],feedObj.attachment];
                NSDictionary* dic=[NSDictionary dictionaryWithObjects:values forKeys:keys];
                NSLog(@"%@",[dic valueForKey:@"userFeedback"]);
                
                NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"flag"]);
                [[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"];
                [[NSUserDefaults standardUserDefaults] valueForKey:@"currentPassword"];
                
                if (gotResponse)
                {
                    Database *db=[Database shareddatabase];
                    
                    keys=[NSArray arrayWithObjects:@"feedbackId",@"soNumber",@"subject",@"userFrom",@"userTo",@"userFeedback",@"feedText",@"feedbackType",@"feedbackCounter",@"operatorId",@"dateOfFeed",@"statusId",@"attachment",nil];
                    
                    values=@[[reponseDict objectForKey:@"feedbackCounterId"],feedObj.soNumber,feedObj.emailSubject,[NSString stringWithFormat:@"%d",feedObj.userFrom],[NSString stringWithFormat:@"%d",feedObj.userTo],[NSString stringWithFormat:@"%d",feedObj.userFeedback],feedObj.feedbackText,[NSString stringWithFormat:@"%d",feedObj.feedbackType],[reponseDict objectForKey:@"feedbackCount"],[NSString stringWithFormat:@"%d",feedObj.operatorId],feedObj.dateOfFeed,[NSString stringWithFormat:@"%d",feedObj.statusId],feedObj.attachment];

                    dic=[NSDictionary dictionaryWithObjects:values forKeys:keys];
                    
                    //NSString* str=[[NSUserDefaults standardUserDefaults] valueForKey:@"flag"] ;
                    //if ([str isEqualToString:@"0"])
                    //{
                    [db insertNewFeedback:dic];
                    //}
                    //else
                    //{
                    //    [db insertNewQuery:dic];
                    //}
                    
                        gotResponse=FALSE;
                    HomeViewController * vc1 = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
                    NSString* alertMessage=@"Feedback generated successfully";
;
                    if ([companyId isEqual:@"1"])
                    {
                      NSString* companyNameString=[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedCompany"];
                        [db getFeedbackAndQueryCounterForCompany:companyNameString];

                    }
                    
                    else
                    {
                        NSString* companyNameString= [db getCompanyIdFromCompanyName:companyId];
                        [db getFeedbackAndQueryCounterForCompany:companyNameString];
                    }
                    [vc1 feedbackAndQuerySearch];

                    
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert"
                                                                                             message:alertMessage
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
                [[APIManager sharedManager] sendNewFeedback:[[NSUserDefaults standardUserDefaults] valueForKey:@"flag"] Dict:dic username:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"] password:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentPassword"]];
               
                
                
            }
            
            alertController.message=@"Please select the operator";
            [self presentViewController:alertController animated:YES completion:nil];

        }
            alertController.message=@"Please enter the subject";
            [self presentViewController:alertController animated:YES completion:nil];

    }
    alertController.message=@"Please enter one of the field";

    [self presentViewController:alertController animated:YES completion:nil];

    
}
@end
