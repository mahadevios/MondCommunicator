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
@synthesize popupTableView;
@synthesize attendeeButton;

- (void) viewDidLoad
{
    [super viewDidLoad];
self.cellSelected=[NSMutableArray new];
    // Do any additional setup after loading the view.
}


- (void) viewWillAppear:(BOOL)animated
{
    j=0;
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
    attendiesTextview.editable=NO;
    keyPointstextView.delegate=self;
    popupTableView.dataSource=self;
    popupTableView.delegate=self;
    [popupTableView setHidden:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;
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

- (IBAction)selectAttendeeButtonClicked:(id)sender
{
    [self setselctedAttendee];
    
}

-(void)setselctedAttendee
{
    if ([attendeeButton isSelected])
    {
        [attendeeButton setSelected:NO];
    }
    else
        [attendeeButton setSelected:YES];

}
-(void)saveNewMOM:(NSDictionary*)momResponseDict
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
    

    if (subjectTextField.text.length!=0)
    {
        if (dateTextField.text.length!=0)
        {
            if (attendiesTextview.text.length!=0)
            {
                if (keyPointstextView.text.length!=0)
                {
                    
                    NSString* userFrom;
                    NSString* userTo;
                    
                    Database *db=[Database shareddatabase];
                    NSString* username = [[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"];
                    NSString* companyId=[db getCompanyId:username];
                    NSString* userFeedback=[db getUserIdFromUserName:username];
                    
                   // NSMutableArray* userIdsArray=[[NSMutableArray alloc]init];
                    // NSString* selectedCompany = [[NSUserDefaults standardUserDefaults]valueForKey:@"selectedCompany"];
                    if ([companyId isEqual:@"1"])
                    {
                        userFrom=@"1";
                        username=[db getUserNameFromCompanyname:[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedCompany"]];
                        userTo=[db getUserIdFromUserNameWithRoll1:username];
                        
                        NSString* companyId=[db getCompanyId:username];
                      //userIdsArray=  [db getAllUsersOfCompany:@"1" andCompany:companyId];
                        //userTo=[db getCompanyId: [[NSUserDefaults standardUserDefaults]valueForKey:@"selectedCompany"]];
                        
                    }
                    
                    else
                    {
                        
                        userTo=@"1";
                        userFrom= [db getUserIdFromUserNameWithRoll1:username];
                     //userIdsArray=   [db getAllUsersOfCompany:@"1" andCompany:companyId];

                        
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
                    NSArray* dt= [momObj.dateTime componentsSeparatedByString:@" "];
                    momObj.dateTime=[NSString stringWithFormat:@"%@"@" "@"%@",[dt objectAtIndex:0],[dt objectAtIndex:1]];
                   
                    momObj.userIds=[NSMutableArray arrayWithArray:userIdsArray];
                    
//                    NSMutableString* userIdsString=[[NSMutableString alloc]init];
//                    for (int i=0; i<userIdsArray.count; i++)
//                    {
//                        userIdsString =[NSMutableString stringWithFormat:@"%@,%@",userIdsString,[userIdsArray objectAtIndex:i]];
//                    }
//                    NSLog(@"%@",userIdsString);

                    NSLog(@"%@,%@,%@,%@,%d,%d,%d,%@,%@",momObj.subject,momObj.momDate, momObj.attendee,momObj.keyPoints,momObj.userfeedback,momObj.userFrom,momObj.userTo,momObj.dateTime,momObj.userIds);
                    
                    
                    NSArray* keys=[NSArray arrayWithObjects:@"subject",@"createdDate",@"attendee",@"keyPoints",@"userFrom",@"userTo",@"userFeedback",@"submittedDateTime",@"momId",@"userIds",nil];
                   
                    NSArray* values=@[momObj.subject,momObj.momDate, momObj.attendee,momObj.keyPoints,[NSString stringWithFormat:@"%d",momObj.userFrom],[NSString stringWithFormat:@"%d",momObj.userTo],[NSString stringWithFormat:@"%d",momObj.userfeedback],momObj.dateTime,[NSString stringWithFormat:@"%ld",momObj.Id],[NSString stringWithFormat:@"%@",momObj.userIds]];
                    
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
                                                                                                 message:@"MOM generated successfully"
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
                else
                {
                   alertController.message=@"Please enter the keypoints";
                    [alertController addAction:actionOk];
                    [self presentViewController:alertController animated:YES completion:nil];

                
                }
            }
            else
            {
               alertController.message=@"Plesae select the attendies";
                [alertController addAction:actionOk];
                [self presentViewController:alertController animated:YES completion:nil];
                
                
            }

        }
        else
        {
            alertController.message=@"Please select the date";
            [alertController addAction:actionOk];
            [self presentViewController:alertController animated:YES completion:nil];
            
            
        }

    }

    else
    {
        alertController.message=@"Please enter the subject";
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
        
        
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
    if (textView==attendiesTextview)
    {
        
    }
    else
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


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
   UIView* sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,self.tableView.frame.size.width,80)];
    sectionView.backgroundColor=[UIColor grayColor];
    UIButton* doneButton=[[UIButton alloc]initWithFrame:CGRectMake(tableView.frame.size.width-80, 10, 70,30)];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    doneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [doneButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [sectionView addSubview:doneButton];
    [doneButton addTarget:self action:@selector(setAttendeeList:) forControlEvents:UIControlEventTouchUpInside];

    
    UIButton* cancelButton=[[UIButton alloc]initWithFrame:CGRectMake(10, 10, 70,30)];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [cancelButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [sectionView addSubview:cancelButton];
    [cancelButton addTarget:self action:@selector(cancelAttendeeList:) forControlEvents:UIControlEventTouchUpInside];

//    setAttendeeList
    
    //UILabel *fileCountLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.tableView.frame.size.width-60, 5, 50, 40)];
           return  sectionView;
    
    
}

-(void)setAttendeeList:(UIButton*)doneButton
{
    self.scrollView.userInteractionEnabled = YES;
    
    
   
    userIdsArray=[NSMutableArray new];
    userNamesArray=[NSMutableArray new];
    for (int i=0; i<self.cellSelected.count; i++)
    {
        NSString* k=[self.cellSelected objectAtIndex:i];
        User* userobject= [userObjectsArray objectAtIndex:[k intValue]];
        [userNamesArray addObject:[NSString stringWithFormat:@"%@ %@",userobject.firstName,userobject.lastName]];
        [userIdsArray addObject:[NSString stringWithFormat:@"%d",userobject.Id]];
       
    }
    
    [popupTableView setHidden:YES];
    for (j=0; j<userNamesArray.count; j++)
    {
        if (j==0)
        {
            attendiesTextview.text=[userNamesArray objectAtIndex:j];

        }
        else
        attendiesTextview.text=[NSString stringWithFormat:@"%@,%@",attendiesTextview.text,[userNamesArray objectAtIndex:j]];
    }
    if (userNamesArray.count==0)
    {
        attendiesTextview.text=@"";
    }
}

-(void)cancelAttendeeList:(UIButton*)sender
{
   self.cellSelected=nil;
    self.attendiesTextview.text=nil;
    userIdsArray=nil;
    userNamesArray=nil;
    self.cellSelected=[[NSMutableArray alloc]init];
    [self.tableView reloadData];
//    userNamesArray=nil;
//    userIdsArray=nil;
    self.scrollView.userInteractionEnabled = YES;
    [popupTableView setHidden:YES];

}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    Database* db=[Database shareddatabase];
    userObjectsArray= [db getAllUsersFirstnameLastname];
            return userObjectsArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if ([self.cellSelected containsObject:[NSString stringWithFormat:@"%ld",indexPath.row]])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        
    }
    cell.tag=indexPath.row;
    UILabel* attendeeNameLabel= [cell viewWithTag:97];

   
    User* userObject= [userObjectsArray objectAtIndex:indexPath.row];
    attendeeNameLabel.text=[NSString stringWithFormat:@"%@ %@",userObject.firstName,userObject.lastName];
          return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    if ([self.cellSelected containsObject:[NSString stringWithFormat:@"%ld",indexPath.row]])
    {
        
        [self.cellSelected removeObject:[NSString stringWithFormat:@"%ld",indexPath.row]];
    }
    else
    {
        [self.cellSelected addObject:[NSString stringWithFormat:@"%ld",indexPath.row]];
    }
    [self.tableView reloadData];
    
}


-(void)setAttende:(UIButton*)selectAttendeeButton
{
        if([selectAttendeeButton isSelected])
        {
            [selectAttendeeButton setSelected:NO];
            [isSelectedDict setObject:[NSNumber numberWithBool:FALSE] forKey:[NSString stringWithFormat:@"%ld",(long)selectAttendeeButton.tag]];

    
        }
        else
        {
            [isSelectedDict setObject:[NSNumber numberWithBool:TRUE] forKey:[NSString stringWithFormat:@"%ld",(long)selectAttendeeButton.tag]];

            [selectAttendeeButton setSelected:YES];
        }

}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    return 0;
//    
//}



- (IBAction)addAttendees:(id)sender
{
    [dateTextField resignFirstResponder];
    [popupTableView setHidden:NO];
    self.scrollView.userInteractionEnabled = NO;

    
   // self.scrollView.alpha = 0.3f;
    [self.view addSubview:popupTableView];
   // self.scrollView.backgroundColor = [UIColor grayColor];
}
@end
