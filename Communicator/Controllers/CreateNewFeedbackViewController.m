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
- (void)viewDidLoad {
    [super viewDidLoad];
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
    
//    NSDate* sourceDate = [NSDate date];
//    
//    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
//    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
//    
//    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
//    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
//    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
//    
//    NSDate* destinationDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate];
//
//    
//    
//    NSTimeInterval seconds = [destinationDate timeIntervalSince1970];
//    double milliseconds = seconds*1000;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(validateUserResponse:) name:NOTIFICATION_SEND_NEWFEEDBACK
                                               object:nil];
   NSDate* date= [[APIManager sharedManager] getDate];
    NSTimeInterval seconds = [date timeIntervalSince1970];
    double milliseconds = seconds*1000;
    

    NSLog(@"%ld",(long)milliseconds);
    NSLog(@"%@",self.feedbackType);
   // FeedQueryCounter* nn=[[FeedQueryCounter alloc]init];
   // NSLog(@"%@",nn.feedbackType);
    NSLog(@"hello github");

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)validateUserResponse:(NSNotification *)notification
{
    if ([[notification.object objectForKey:@"code"] isEqualToString:SUCCESS])
    {
        NSError* error;
        gotResponse=TRUE;
        NSString* str=[NSString stringWithFormat:@"%@",notification];
        NSString* companyFeedbackTypeAsscociationString=[notification.object objectForKey:@"feedbackCounterId"];
        NSData *companyFeedbackTypeAsscociationData = [companyFeedbackTypeAsscociationString dataUsingEncoding:NSUTF8StringEncoding];
        
        NSString *companyFeedbackTypeAsscociationValue = [NSJSONSerialization JSONObjectWithData:companyFeedbackTypeAsscociationData
                                                                                        options:NSJSONReadingAllowFragments
                                                                                          error:&error];

        NSLog(@"%@",companyFeedbackTypeAsscociationString);
        [self sendNewFeedbackOrSaveResponse:notification.object];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
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

//    else
//    [DescriptionTextView becomeFirstResponder];
    return YES;
}

#pragma mark-texView delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"])
    {
        if(textView==SubjectTextView)
        {
            [OperatorTextField becomeFirstResponder];
            //[self moveViewUp:YES];
        }
        else
            [textView resignFirstResponder];
        // Return FALSE so that the final '\n' character doesn't get added
        return NO;
    }
    // For any other character return TRUE so that the text gets added to the view
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField==AvayaIdTextField)
    {
        [self moveViewUp:YES];
    }
    if (textField==DocumentIdTextField)
    {
        [self moveViewUp:YES];
    }
    if (textField==OperatorTextField)
    {
        [self moveViewUp:YES];
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
//    if (textField==AvayaIdTextField)
//    {
//        [self moveViewUp:NO];
//    }
//    if (textField==DocumentIdTextField)
//    {
//        [self moveViewUp:NO];
//    }
//    if (textField==OperatorTextField)
//    {
//        [self moveViewUp:NO];
//    }
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
   
    [self moveViewUp:YES];
    
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
//    if (textView!=DescriptionTextView)
//    {
//[OperatorTextField becomeFirstResponder];
//    }
    if (textView==DescriptionTextView)
    {
        [DescriptionTextView resignFirstResponder];
        [self moveViewUp:NO];

    }
    NSLog(@"%ld",(long)[[UIDevice currentDevice] orientation]);
    
}


- (void) moveViewUp: (BOOL) isUp
{
   const int movementDistance = 88; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    if (isUp)
    {
        totalMovement=totalMovement+70;
    }
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
    if(!(SONumberTextField.text==nil) || !(AvayaIdTextField.text==nil) || !(DocumentIdTextField.text==nil))
    {
        if (SubjectTextView.text!=nil)
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
                feedObj.operatorId=[OperatorTextField.text intValue];
                feedObj.feedbackText=DescriptionTextView.text;
                feedObj.userFrom=[userFrom intValue];
                feedObj.userTo=[userTo intValue];
                feedObj.userFeedback=[userFeedback intValue];
                feedObj.dateOfFeed=[NSString stringWithFormat:@"%@",[[APIManager sharedManager] getDate]];
                feedObj.feedbackType=[[feedidCounterAndFeedbackTypeArray objectAtIndex:2]intValue];
                feedObj.feedbackId=[[feedidCounterAndFeedbackTypeArray objectAtIndex:0]intValue];
                feedObj.feedbackCounter=[[feedidCounterAndFeedbackTypeArray objectAtIndex:1]intValue];
                feedObj.attachment=@"";
                feedObj.statusId=1;
                // feedObj.feedbackCounter=[[NSString stringWithFormat:@"%@",[maxFeedIdAndCounterArray objectAtIndex:1]]longLongValue];
                //feedObj.feedbackId=[[NSString stringWithFormat:@"%@",[maxFeedIdAndCounterArray objectAtIndex:0]]longLongValue];
                
                NSLog(@"%d,%d",feedObj.userFrom,feedObj.userTo);
                //feedObj.statusId=[[NSString stringWithFormat:@"%@",[maxFeedIdAndCounterArray objectAtIndex:2]]intValue];
                //feedObj.operatorId=[[NSString stringWithFormat:@"%@",[maxFeedIdAndCounterArray objectAtIndex:3]]intValue];
                //feedObj.attachment;
                NSLog(@"%@,%@,%d,%@,%@,%ld,%ld,%d,%d",feedObj.soNumber,feedObj.emailSubject, feedObj.feedbackType,feedObj.feedbackText,feedObj.dateOfFeed,feedObj.feedbackCounter,feedObj.feedbackId,feedObj.operatorId,feedObj.statusId);
                
                
                NSArray* keys=[NSArray arrayWithObjects:@"feedbackId",@"soNumber",@"subject",@"userFrom",@"userTo",@"userFeedback",@"feedText",@"feedbackType",@"feedbackCounter",@"operatorId",@"dateOfFeed",@"statusId",@"attachment",nil];
               
                NSArray* values=@[[NSString stringWithFormat:@"%ld",feedObj.feedbackId+1],feedObj.soNumber,feedObj.emailSubject,[NSString stringWithFormat:@"%d",feedObj.userFrom],[NSString stringWithFormat:@"%d",feedObj.userTo],[NSString stringWithFormat:@"%d",feedObj.userFeedback],feedObj.feedbackText,[NSString stringWithFormat:@"%d",feedObj.feedbackType],[NSString stringWithFormat:@"%ld",feedObj.feedbackCounter+1],[NSString stringWithFormat:@"%d",feedObj.operatorId],feedObj.dateOfFeed,[NSString stringWithFormat:@"%d",feedObj.statusId],feedObj.attachment];
                NSDictionary* dic=[NSDictionary dictionaryWithObjects:values forKeys:keys];
                NSLog(@"%@",[dic valueForKey:@"userFeedback"]);
                
                //NSMutableDictionary* MainDict=[NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] valueForKey:@"flag"],@"flag",dic,@"feedcomOrQuerycom", nil];
                //NSDictionary* dict=[MainDict valueForKey:@"feedcomOrQuerycom"];
                NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"flag"]);
                [[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"];
                [[NSUserDefaults standardUserDefaults] valueForKey:@"currentPassword"];
                
                if (gotResponse)
                {
                    Database *db=[Database shareddatabase];
                    
                    keys=[NSArray arrayWithObjects:@"feedbackId",@"soNumber",@"subject",@"userFrom",@"userTo",@"userFeedback",@"feedText",@"feedbackType",@"feedbackCounter",@"operatorId",@"dateOfFeed",@"statusId",@"attachment",nil];
                    NSString* a=[reponseDict objectForKey:@"feedbackCounterId"];
                    [a longLongValue];
                    //long a=[NSString stringWithFormat:@"%ld",[[reponseDict valueForKey:@"feedbackCounterId"]longValue]];
                    values=@[[reponseDict objectForKey:@"feedbackCounterId"],feedObj.soNumber,feedObj.emailSubject,[NSString stringWithFormat:@"%d",feedObj.userFrom],[NSString stringWithFormat:@"%d",feedObj.userTo],[NSString stringWithFormat:@"%d",feedObj.userFeedback],feedObj.feedbackText,[NSString stringWithFormat:@"%d",feedObj.feedbackType],[reponseDict objectForKey:@"feedbackCount"],[NSString stringWithFormat:@"%d",feedObj.operatorId],feedObj.dateOfFeed,[NSString stringWithFormat:@"%d",feedObj.statusId],feedObj.attachment];

                    dic=[NSDictionary dictionaryWithObjects:values forKeys:keys];
                    
                    NSString* str=[[NSUserDefaults standardUserDefaults] valueForKey:@"flag"] ;
                    if ([str isEqualToString:@"0"])
                    {
                    [db insertNewFeedback:dic];
                    }
                    else
                    {
                        [db insertNewQuery:dic];
                    }
                    
                        gotResponse=FALSE;
                    HomeViewController * vc1 = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
                    NSString* alertMessage;
                    if ([companyId isEqual:@"1"])
                    {
                      NSString* companyNameString=[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedCompany"];
                        [db getFeedbackAndQueryCounterForCompany:companyNameString];
                       [vc1 feedbackAndQuerySearch];
                        alertMessage=@"Query generated successfully";

                    }
                    
                    else
                    {
                        NSString* companyNameString= [db getCompanyIdFromCompanyName:companyId];
                        [db getFeedbackAndQueryCounterForCompany:companyNameString];
                        [vc1 feedbackAndQuerySearch];
                        alertMessage=@"Feedback generated successfully";


                    }
                    
                    
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
        }
        
    }
    
}
@end
