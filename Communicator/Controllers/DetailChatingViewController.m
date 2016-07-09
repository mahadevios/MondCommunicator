//
//  DetailChatingViewController.m
//  Communicator
//
//  Created by mac on 26/05/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import "DetailChatingViewController.h"
#import "AppPreferences.h"
#import "FeedbackChatingCounter.h"
#import "QueryChatingCounter.h"
#import "Database.h"
#import "Feedback.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "CounterGraph.h"
#import "MBProgressHUD.h"
@interface DetailChatingViewController ()

@end

@implementation
DetailChatingViewController
@synthesize tableview;
@synthesize sendFeedbackTextfield;
@synthesize hud;
- (void)viewDidLoad
{
    [super viewDidLoad];
   
    // Do any additional setup after loading the view.

}

-(void)viewWillAppear:(BOOL)animated
{
   
    [self setNavigationItems];
    [self setHeaderForTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getLatestRecords:) name:NOTIFICATION_SEND_UPDATED_RECORDS
                                               object:nil];

}

-(void)setNavigationItems
{
    self.tabBarController.navigationItem.title = @"Feedback Communication";
    self.tabBarController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BackArrow"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewController)] ;
    self.tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Attachment"] style:UIBarButtonItemStylePlain target:self action:@selector(selectFileToUpload:)] ;
    self.tabBarController.navigationItem.rightBarButtonItem.tintColor=[UIColor whiteColor];
    self.tabBarController.navigationItem.leftBarButtonItem.tintColor=[UIColor whiteColor];

}
-(void)popViewController
{
    UINavigationController *navController = self.navigationController;
    
    [navController popViewControllerAnimated:YES];
}
-(void)selectFileToUpload:(NSString*)para
{
    UIViewController* vc= [self.storyboard instantiateViewControllerWithIdentifier:@"UploadFileViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)setHeaderForTableView
{
    sendFeedbackTextfield.delegate=self;
    UILabel* subjectLabel=(UILabel*)[self.view viewWithTag:100];
    UILabel* SONumberLabel=(UILabel*)[self.view viewWithTag:101];
    UILabel* dateOfFeedLabel=(UILabel*)[self.view viewWithTag:102];
    
    app=[AppPreferences sharedAppPreferences];
    NSArray* separatedSO=[[NSMutableArray alloc]init];
    FeedbackChatingCounter *allMessageObj=[app.FeedbackOrQueryDetailChatingObjectsArray lastObject];
    //-----------setSubject---------//
    subjectLabel.text=allMessageObj.emailSubject;

    //------setSONumber----------------//
    NSString* soNumber= allMessageObj.soNumber;
    separatedSO=[soNumber componentsSeparatedByString:@"#@"];
    NSString* soNumr=[separatedSO objectAtIndex:0];
    NSString* avaya=[separatedSO objectAtIndex:1];
    NSString* Doc=[separatedSO objectAtIndex:2];

    SONumberLabel.text=[NSString stringWithFormat:@"SO Number:%@\nAvaya Id:%@\nDocument Id:%@",soNumr,avaya,Doc];
    
    //------setDate----------------//

    NSString* dd=allMessageObj.dateOfFeed;
    NSArray *components = [dd componentsSeparatedByString:@" "];
    NSString *date = components[0];
    NSString *time = components[1];
    
    dateOfFeedLabel.text=[NSString stringWithFormat:@"%@\n%@",date,time];

}

- (void)getLatestRecords:(NSNotification *)notificationData
{
    if ([[notificationData.object objectForKey:@"code"] isEqualToString:SUCCESS])
    {
        Database *db=[Database shareddatabase];
        //AppPreferences *app=[AppPreferences sharedAppPreferences];
        NSLog(@"%@",notificationData.object);
        FeedbackChatingCounter* feedObject= [app.FeedbackOrQueryDetailChatingObjectsArray objectAtIndex:0];

        
        NSString* str=[[NSUserDefaults standardUserDefaults] valueForKey:@"flag"] ;
        if ([str isEqualToString:@"0"])
        {
            [db insertUpdatedRecordsForFeedcom:notificationData.object];                          //insert response date
            [db getDetailMessagesofFeedbackOrQuery:feedObject.feedbackType :feedObject.soNumber]; //fetch updated data after inserting response data
            sendFeedbackTextfield.text=@"";
            [tableview reloadData];
        }
        else
        {
            [db insertUpdatedRecordsForQueryCom:notificationData.object];
            [db getDetailMessagesofFeedbackOrQuery:feedObject.feedbackType :feedObject.soNumber];
            sendFeedbackTextfield.text=@"";

            [tableview reloadData];
         }
    
        
    }
}


#pragma mark:tableView delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    return app.FeedbackOrQueryDetailChatingObjectsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    FeedbackChatingCounter* feedObject= [app.FeedbackOrQueryDetailChatingObjectsArray objectAtIndex:indexPath.row];
    Database* db=[Database shareddatabase];
    NSString* userRole=[db getUserIdFromUserNameWithRoll1:feedObject.userFrom];
    if (cell!=nil)
    {
        cell.contentView.backgroundColor=[UIColor grayColor];
        if ([userRole isEqualToString:@"1"])
        {
            cell.contentView.backgroundColor=[UIColor colorWithRed:202.0/255 green:229.0/255 blue:159.0/255 alpha:1];
            
        }
    }
    
    UILabel* userName= (UILabel*)[cell viewWithTag:50];
    userName.text=feedObject.userFrom;
    
    UILabel* feedText= (UILabel*)[cell viewWithTag:51];
    NSString* detailMessage=[self stringByStrippingHTML:feedObject.detailMessage];
    feedText.text=detailMessage;
    
    UILabel* feedTime= (UILabel*)[cell viewWithTag:52];
    NSString* dd=feedObject.dateOfFeed;
    NSArray *components = [dd componentsSeparatedByString:@" "];
    NSString *date = components[0];
    NSString *time = components[1];
    feedTime.text=[NSString stringWithFormat:@"%@   %@",date,time];
    
    UILabel* attachmentLabel= (UILabel*)[cell viewWithTag:53];
    NSString* allAttachmentsNamesString=[self stringByStrippingHTML:feedObject.attachments];
    NSArray* attachmentsNamesArray=[allAttachmentsNamesString componentsSeparatedByString:@"#@$"];
   
    
    
    NSString *attachmentString = @"";
    if (attachmentsNamesArray.count > 0)
    {
        attachmentString = attachmentsNamesArray[0];
    }
    
    UIView *subView = [cell.contentView viewWithTag:10000];
    if (subView != nil)
    {
        [subView removeFromSuperview];
    }
    cell.tag = indexPath.row;
    if (attachmentString.length > 0)
    {
        if (attachmentsNamesArray.count>0)
        {
            CounterGraph* counterGraphObj=[[CounterGraph alloc]init];
            counterGraphObj.counterGraphlabel=attachmentLabel;
            counterGraphObj.attachmentArray=[NSArray arrayWithArray:attachmentsNamesArray];
            counterGraphObj.cell=cell;
            counterGraphObj.selectedIndex = (int)indexPath.row;
            [self performSelector:@selector(setCounterGraphLabel:) withObject:counterGraphObj afterDelay:0.0005];
        }
    }
    
    CGSize maximumLabelSize = CGSizeMake(96, FLT_MAX);
    
    CGSize expectedLabelSize = [feedObject.detailMessage sizeWithFont:feedText.font constrainedToSize:maximumLabelSize lineBreakMode:feedText.lineBreakMode];
    
    CGRect newFrame = feedText.frame;
    newFrame.size.height = expectedLabelSize.height;
    feedText.frame = newFrame;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FeedbackChatingCounter* feedObject= [app.FeedbackOrQueryDetailChatingObjectsArray objectAtIndex:indexPath.row];
    
    UILabel* feedTextLbl= [[UILabel alloc]initWithFrame:CGRectMake(5.0f, 0.0f, self.view.frame.size.width - 10.0f, 30.0f)];
    feedTextLbl.text=feedObject.detailMessage;
    [feedTextLbl setFont:[UIFont systemFontOfSize:12.0f]];
    feedTextLbl.lineBreakMode = UILineBreakModeWordWrap;
    feedTextLbl.numberOfLines = 10000000;
    CGRect newFrame= [self getFrameSize:feedObject label:feedTextLbl];
    CGRect newFrame1= [self getFrame:feedObject label:feedTextLbl];
    
    
    NSLog(@"%f",40 + newFrame.size.height+newFrame1.size.height);
    return 30 + newFrame.size.height+newFrame1.size.height;
}

#pragma mark:height for cell;supporting methods

-(void)setCounterGraphLabel:(CounterGraph*)counterGraphObj
{
    UIView *subView = [counterGraphObj.cell.contentView viewWithTag:10000];
    
    if (subView != nil)
    {
        [subView removeFromSuperview];
    }
    
    if (counterGraphObj.selectedIndex != counterGraphObj.cell.tag)
    {
        return;
    }
    
                         UIView* attachmentSubView=[[UIView alloc]init];
                         attachmentSubView.tag=10000;
                         float yPosOfLbl = 10.0f;
                         NSLog(@"%f",counterGraphObj.counterGraphlabel.frame.origin.y);
                         for (int i=0; i<counterGraphObj.attachmentArray.count; i++)
                         {
                             [attachmentSubView setFrame:CGRectMake(counterGraphObj.counterGraphlabel.frame.origin.x, counterGraphObj.counterGraphlabel.frame.origin.y+(2*i), 320, 34*(counterGraphObj.attachmentArray.count))];
                           

                             UILabel* label=[[UILabel alloc]init];
                             //label.tag=10000;
                             label.font=[UIFont systemFontOfSize:12];
                             [label setFrame:CGRectMake(counterGraphObj.counterGraphlabel.frame.origin.x, (yPosOfLbl*i*4), 200, counterGraphObj.counterGraphlabel.frame.size.height)];
                             label.text=[counterGraphObj.attachmentArray objectAtIndex:i];
                             
                             NSLog(@"%f,%f",counterGraphObj.counterGraphlabel.frame.origin.x,counterGraphObj.counterGraphlabel.frame.origin.y);
                             

                             
                             NSString* filePath=[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/Attachments/%@",[counterGraphObj.attachmentArray objectAtIndex:i]]];
                             
                             UIImageView* attachmentDownloadImageView=[[UIImageView alloc]init];

                             if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
                             {
                                 attachmentDownloadImageView.image=[UIImage imageNamed:@"FileDownload"];
                                 [attachmentDownloadImageView setFrame:CGRectMake(205, (yPosOfLbl*i*4),20, 20)];
                             }
                             else
                             {
                                 attachmentDownloadImageView.image=nil;
                                 [attachmentDownloadImageView setFrame:CGRectMake(205, (yPosOfLbl*i*4),20, 20)];
                             }

                             
                            
                             
                             UIButton* attachmentDownloadButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
                             [attachmentDownloadButton setFrame:CGRectMake(counterGraphObj.counterGraphlabel.frame.origin.x, (yPosOfLbl*i*4), 300, counterGraphObj.counterGraphlabel.frame.size.height)];
                             //attachmentDownloadButton.backgroundColor=[UIColor redColor];
                             attachmentDownloadButton.titleLabel.text=[counterGraphObj.attachmentArray objectAtIndex:i];
                             hud.label.text = NSLocalizedString(@"Please wait...", @"HUD Loading title");
                             hud.minSize = CGSizeMake(150.f, 100.f);
                             [attachmentDownloadButton addTarget:self action:@selector(showFilePreviewOrDownload:) forControlEvents:UIControlEventTouchUpInside];

                             
                             
                             [attachmentSubView addSubview:label];
                             [attachmentSubView addSubview:attachmentDownloadImageView];
                             [attachmentSubView addSubview:attachmentDownloadButton];
                             
                              attachmentSubView.userInteractionEnabled=YES;

                             NSLog(@"dfds");
                             

                             [counterGraphObj.cell.contentView addSubview:attachmentSubView];
                             
                            
                         }

    

    
}

-(void)showFilePreviewOrDownload:(UIButton*)sender
{
    
    NSLog(@"%@",sender.titleLabel.text);
    NSError* error;
    NSString *folderpath,*destpath;
    NSString* stringURL = [NSString stringWithFormat:@"http://localhost:9090/coreflex/resources/CfsFiles/%@",sender.titleLabel.text];
    NSString* webStringURL = [stringURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL* url = [NSURL URLWithString:webStringURL];
    
    
    destpath=[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/Attachments/%@",sender.titleLabel.text]];
    
    NSString* filePath=[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/Attachments"]];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:destpath])
    {
        if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
            [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
        
            hud.label.text = NSLocalizedString(@"Please wait...", @"HUD Loading title");
            // Will look best, if we set a minimum size.
            hud.minSize = CGSizeMake(150.f, 100.f);
            NSData * data = [NSData dataWithContentsOfURL:url];
            [data writeToFile:destpath atomically:YES];
       
        
        
    }
    
    else
    {
        NSString* fileURL=[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/Attachments/%@",sender.titleLabel.text]];
        NSURL* file = [NSURL fileURLWithPath:fileURL];
        
        UIDocumentInteractionController* documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:file];
        
        
        [documentInteractionController setDelegate:self];
        [documentInteractionController presentOpenInMenuFromRect:self.view.frame inView:self.view animated:YES];

        [documentInteractionController presentPreviewAnimated:YES];
        
    }
    
    
    
}

- (UIViewController *) documentInteractionControllerViewControllerForPreview: (UIDocumentInteractionController *) controller
{
    return self;
}
-(CGRect)getFrame:(FeedbackChatingCounter*)feedObject label:(UILabel*)feedTextLbl
{
    NSString* attachmentString= feedObject.attachments;
   NSArray* allAttachmentArray= [attachmentString componentsSeparatedByString:@"|"];
    NSString* attachmentName;
    for (int i=0; i<allAttachmentArray.count; i++)
    {
      attachmentName=  [allAttachmentArray objectAtIndex:i];
    }
    CGSize maximumLabelSize = CGSizeMake(96, 100);
    
       CGSize expectedLabelSize = [attachmentName sizeWithFont:feedTextLbl.font constrainedToSize:maximumLabelSize lineBreakMode:feedTextLbl.lineBreakMode];
    
    //adjust the label the the new height.
    CGRect newFrame = feedTextLbl.frame;
    newFrame.size.height = expectedLabelSize.height*allAttachmentArray.count;
    if (newFrame.size.height < 20)
    {
        newFrame.size.height = 20.0f; 
    }
    NSLog(@"%f",newFrame.size.height);
    
    return newFrame;
    
}
-(CGRect)getFrameSize:(FeedbackChatingCounter*)feedObject label:(UILabel*)feedTextLbl
{
    CGSize maximumLabelSize = CGSizeMake(feedTextLbl.frame.size.width, MAXFLOAT);
    
    CGSize expectedLabelSize = [feedObject.detailMessage sizeWithFont:feedTextLbl.font constrainedToSize:maximumLabelSize lineBreakMode:feedTextLbl.lineBreakMode];
    
    //adjust the label the the new height.
    CGRect newFrame = feedTextLbl.frame;
    newFrame.size.height = expectedLabelSize.height;
    if (newFrame.size.height < 20)
    {
        newFrame.size.height = 20.0f;
    }
    return newFrame;

}

#pragma mark:remove html tags

-(NSString *) stringByStrippingHTML:(NSString *) stringWithHtmlTags {
    NSRange r;
    while ((r = [stringWithHtmlTags rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        stringWithHtmlTags = [stringWithHtmlTags stringByReplacingCharactersInRange:r withString:@""];
    return stringWithHtmlTags;
}


#pragma mark:image picker delegates
- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo
{
    
       [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark:self view action methods

- (IBAction)sendFeedbackButtonClicked:(id)sender
{
    NSString* userFrom,* userTo;
    if ([sendFeedbackTextfield.text length] <= 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Empty message!" message:@"Please enter some messag and try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
        [alertView show];
    }
    
    else
    {
       
        Database* db=[Database shareddatabase];
        FeedbackChatingCounter* feedObject= [app.FeedbackOrQueryDetailChatingObjectsArray objectAtIndex:0];

        NSString* username = [[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"];
        NSString* companyId=[db getCompanyId:username];
        NSString* userFeedback=[db getUserIdFromUserName:username];
        NSMutableArray* maxFeedIdAndCounterArray=[db getMaxFeedIdAndCounter:feedObject.soNumber :feedObject.feedbackType];
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
        
        Feedback* feedObj=[[Feedback alloc]init];
       feedObj.soNumber = feedObject.soNumber;
        feedObj.emailSubject = feedObject.emailSubject;
        feedObj.feedbackType = feedObject.feedbackType;
        feedObj.userFrom=[userFrom intValue];
        feedObj.userTo=[userTo intValue];
        feedObj.userFeedback=[userFeedback intValue];
        feedObj.feedbackText = sendFeedbackTextfield.text;
        feedObj.dateOfFeed=[NSString stringWithFormat:@"%@",[NSDate date]];
        feedObj.feedbackText=sendFeedbackTextfield.text;
       feedObj.feedbackCounter=[[NSString stringWithFormat:@"%@",[maxFeedIdAndCounterArray objectAtIndex:1]]longLongValue];
        feedObj.feedbackId=[[NSString stringWithFormat:@"%@",[maxFeedIdAndCounterArray objectAtIndex:0]]longLongValue];
        
        
        NSString *uploadedFileNamesString = @"";
        for (int i = 0; i<app.uploadedFileNamesArray.count; i++)
        {
            if (uploadedFileNamesString.length > 0)
            {
                uploadedFileNamesString = [NSString stringWithFormat:@"%@#@$%@", uploadedFileNamesString, [app.uploadedFileNamesArray objectAtIndex:i]];
            }
            else
            {
                uploadedFileNamesString = [NSString stringWithFormat:@"%@", [app.uploadedFileNamesArray objectAtIndex:i]];
            }

        }
        uploadedFileNamesString = [uploadedFileNamesString stringByReplacingOccurrencesOfString:@"/" withString:@""];
        uploadedFileNamesString = [uploadedFileNamesString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        feedObj.attachment = uploadedFileNamesString;
        if (app.uploadedFileNamesArray != nil)
        {
            [app.uploadedFileNamesArray removeAllObjects];
        }
        
        NSLog(@"%d,%d",feedObj.userFrom,feedObj.userTo);
      feedObj.statusId=[[NSString stringWithFormat:@"%@",[maxFeedIdAndCounterArray objectAtIndex:2]]intValue];
        feedObj.operatorId=[[NSString stringWithFormat:@"%@",[maxFeedIdAndCounterArray objectAtIndex:3]]intValue];
        //feedObj.attachment;
        NSLog(@"%@,%@,%d,%@,%@,%ld,%ld,%d,%d",feedObj.soNumber,feedObj.emailSubject, feedObj.feedbackType,feedObj.feedbackText,feedObj.dateOfFeed,feedObj.feedbackCounter,feedObj.feedbackId,feedObj.operatorId,feedObj.statusId);
        
        NSArray* keys=[NSArray arrayWithObjects:@"soNumber",@"userFrom",@"userTo",@"userFeedback",@"feedText",@"feedbackType",@"statusId",@"operatorId",@"emailSubject",@"attachment", nil];

        
        NSArray* values=@[feedObj.soNumber,[NSString stringWithFormat:@"%d",feedObj.userFrom],[NSString stringWithFormat:@"%d",feedObj.userTo],[NSString stringWithFormat:@"%d",feedObj.userFeedback],feedObj.feedbackText,[NSString stringWithFormat:@"%d",feedObj.feedbackType],[NSString stringWithFormat:@"%d",feedObj.statusId],[NSString stringWithFormat:@"%d",feedObj.operatorId],feedObj.emailSubject,feedObj.attachment];
        
        NSDictionary* dic=[NSDictionary dictionaryWithObjects:values forKeys:keys];
        
        NSLog(@"%@",[dic valueForKey:@"userFeedback"]);
        
        

        
        NSLog(@"%@",dic);
        
        [[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"];
        [[NSUserDefaults standardUserDefaults] valueForKey:@"currentPassword"];



        [[APIManager sharedManager] sendUpdatedRecords:[[NSUserDefaults standardUserDefaults] valueForKey:@"flag"] Dict:dic username:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"] password:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentPassword"]];
      // [db insertUserReply:feedObj];
        
        
        
    
    }

}

#pragma mark:texfield delegates

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self moveViewUp:YES];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self moveViewUp:NO];
}

- (void) moveViewUp: (BOOL) isUp
{
    const int movementDistance = 200; // tweak as needed
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
    self.tableview.frame = CGRectOffset(self.tableview.frame, 0, movement);
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);

    [UIView commitAnimations];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
