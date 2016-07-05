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
@interface DetailChatingViewController ()

@end

@implementation
DetailChatingViewController
@synthesize tableview;
@synthesize sendFeedbackTextfield;
- (void)viewDidLoad
{
    [super viewDidLoad];
   
    // Do any additional setup after loading the view.

}

-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.navigationItem.title = @"Feedback Communication";
    self.tabBarController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BackArrow"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewController)] ;
    self.tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Attachment"] style:UIBarButtonItemStylePlain target:self action:@selector(selectFileToUpload:)] ;
    self.tabBarController.navigationItem.rightBarButtonItem.tintColor=[UIColor whiteColor];
    self.tabBarController.navigationItem.leftBarButtonItem.tintColor=[UIColor whiteColor];

    UILabel* subjectLabel=(UILabel*)[self.view viewWithTag:100];
    UILabel* SONumberLabel=(UILabel*)[self.view viewWithTag:101];
    UILabel* dateOfFeedLabel=(UILabel*)[self.view viewWithTag:102];

    app=[AppPreferences sharedAppPreferences];
    NSArray* separatedSO=[[NSMutableArray alloc]init];
    FeedbackChatingCounter *allMessageObj=[app.FeedbackOrQueryDetailChatingObjectsArray objectAtIndex:0];
    NSString* soNumber= allMessageObj.soNumber;
    separatedSO=[soNumber componentsSeparatedByString:@"#@"];
    NSString* soNumr=[separatedSO objectAtIndex:0];
    NSString* avaya=[separatedSO objectAtIndex:1];
    NSString* Doc=[separatedSO objectAtIndex:2];

    SONumberLabel.text=[NSString stringWithFormat:@"SO Number:%@\nAvaya Id:%@\nDocument Id:%@",soNumr,avaya,Doc];
    subjectLabel.text=allMessageObj.emailSubject;
    
    FeedbackChatingCounter *allMessageObj1=[app.FeedbackOrQueryDetailChatingObjectsArray lastObject];

    NSString* dd=allMessageObj1.dateOfFeed;
    //NSString *dd = [NSString stringWithFormat:@"%@",[NSDate dateWithTimeIntervalSince1970:da/1000.0]];
    NSArray *components = [dd componentsSeparatedByString:@" "];
    NSString *date = components[0];
    NSString *time = components[1];
    NSLog(@"%@,,,,%@",date,time);

    dateOfFeedLabel.text=[NSString stringWithFormat:@"%@\n%@",date,time];
   
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getLatestRecords:) name:NOTIFICATION_SEND_UPDATED_RECORDS
                                               object:nil];

    
   // [self uploadFileToServer:@""];

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
            [db insertUpdatedRecordsForFeedcom:notificationData.object];
            [db getDetailMessagesofFeedbackOrQuery:feedObject.feedbackType :feedObject.soNumber];
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
-(void)popViewController
{
    UINavigationController *navController = self.navigationController;
    
    [navController popViewControllerAnimated:YES];
}
-(void)selectFileToUpload:(NSString*)para
{
    //UIViewController* vc1= [self.storyboard instantiateViewControllerWithIdentifier:@"SelectFileNavigationController"];

   /// UINavigationController* navi=[[UINavigationController alloc]initWithRootViewController:vc1];
    UIViewController* vc= [self.storyboard instantiateViewControllerWithIdentifier:@"UploadFileViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    return app.FeedbackOrQueryDetailChatingObjectsArray.count;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
   FeedbackChatingCounter* feedObject= [app.FeedbackOrQueryDetailChatingObjectsArray objectAtIndex:indexPath.row];
    NSLog(@"%@",feedObject.userFrom);
    
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
    //feedText.text= @"gfhghj gg gh kljh klh lkjhkl lkh klh lkhlk klj klh kljh klh kljh lkhjkl kljh kljh kljh kljh klh kljh k fghdf hdf hdfh dh h h dfhdfh dfh dfh h h dfh h dfhdf hdfh dfh dfh dfhdfhdfh dfhd hdfh dhdh lhj lkjh kljh l;khj lkh lkhj klj kljh klj hhj";
    feedText.text=detailMessage;
    UILabel* feedTime= (UILabel*)[cell viewWithTag:52];
   // UILabel* referenceLabel= (UILabel*)[cell viewWithTag:101];

    UILabel* attachmentLabel= (UILabel*)[cell viewWithTag:53];
    //attachmentLabel.text=[self stringByStrippingHTML:feedObject.attachments];

    NSString* allAttachmentsNamesString=[self stringByStrippingHTML:feedObject.attachments];
    
       NSArray* attachmentsNamesArray=[allAttachmentsNamesString componentsSeparatedByString:@"#@$"];
   
    
    //[[cell viewWithTag:10000] removeFromSuperview];
    NSString *attachmentString = @"";
    if (attachmentsNamesArray.count > 0)
    {
        attachmentString = attachmentsNamesArray[0];
    }
    
    NSLog(@" Row = %ld",(long)indexPath.row);
    NSLog(@"attachmentString = %@",attachmentString);
    
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
            //counterGraphObj.referenceForCounterGraphView=referenceViewForCounterGraph;
            //counterGraphObj.count=counter;
            //counterGraphLabel.backgroundColor = [UIColor communicatorColor];
            // [counterGraphLabel setFrame:CGRectMake(counterGraphLabel.frame.origin.x, counterGraphLabel.frame.origin.y, 0.0f, counterGraphLabel.frame.size.height)];
            
            [self performSelector:@selector(setCounterGraphLabel:) withObject:counterGraphObj afterDelay:0.0005];
        }
    }
    
    CGSize maximumLabelSize = CGSizeMake(96, FLT_MAX);
    
    CGSize expectedLabelSize = [feedObject.detailMessage sizeWithFont:feedText.font constrainedToSize:maximumLabelSize lineBreakMode:feedText.lineBreakMode];
    
    //adjust the label the the new height.
    CGRect newFrame = feedText.frame;
    newFrame.size.height = expectedLabelSize.height;
    feedText.frame = newFrame;
    
    
    
    
    
    NSString* dd=feedObject.dateOfFeed;
   // NSDate* sd=[[NSDate alloc]init];
    NSArray *components = [dd componentsSeparatedByString:@" "];
        NSString *date = components[0];
    NSString *time = components[1];
//    NSLog(@"%@",date);
//    NSLog(@"%@",time);

    feedTime.text=[NSString stringWithFormat:@"%@   %@",date,time];

    return cell;
}

-(void)setCounterGraphLabel:(CounterGraph*)counterGraphObj
{
   // counterGraphObj.counterGraphlabel.adjustsFontSizeToFitWidth = false;
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
                         //[attachmentSubView setFrame:CGRectMake(12, 12, 300, counterGraphObj.counterGraphlabel.frame.size.height)];
                         attachmentSubView.tag=10000;
                         float yPosOfLbl = 10.0f;
    NSLog(@"%f",counterGraphObj.counterGraphlabel.frame.origin.y);
                         for (int i=0; i<counterGraphObj.attachmentArray.count; i++)
                         {
                             [attachmentSubView setFrame:CGRectMake(counterGraphObj.counterGraphlabel.frame.origin.x, counterGraphObj.counterGraphlabel.frame.origin.y+(10), 300, 10)];
                            
                             

                             UILabel* label=[[UILabel alloc]init];
                             //label.tag=10000;
                             label.font=[UIFont systemFontOfSize:12];
                             [label setFrame:CGRectMake(counterGraphObj.counterGraphlabel.frame.origin.x, (i*yPosOfLbl), 200, counterGraphObj.counterGraphlabel.frame.size.height)];
                             label.text=[counterGraphObj.attachmentArray objectAtIndex:i];
                             
                             UIButton* attachmentDownloadButton=[UIButton new];
                             [attachmentDownloadButton setFrame:CGRectMake(counterGraphObj.counterGraphlabel.frame.origin.x, (i*yPosOfLbl), 300, counterGraphObj.counterGraphlabel.frame.size.height)];
                             attachmentDownloadButton.backgroundColor=[UIColor clearColor];
                             
                             UIImageView* attachmentDownloadImageView=[[UIImageView alloc]init];
                             attachmentDownloadImageView.image=[UIImage imageNamed:@"FileDownload"];
                             [attachmentDownloadImageView setFrame:CGRectMake(205, (i*yPosOfLbl),20, 20)];

                             float heightOfView = attachmentDownloadButton.frame.size.height+yPosOfLbl;
                             //float heightOfView = attachmentDownloadButton.frame.size.height + attachmentSubView.frame.size.height;

                             

                             
                             [attachmentSubView addSubview:label];
                             [attachmentSubView addSubview:attachmentDownloadButton];
                             [attachmentSubView addSubview:attachmentDownloadImageView];
                             [counterGraphObj.cell.contentView addSubview:attachmentSubView];

                         }

    

    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // userName.text=@"details";
    FeedbackChatingCounter* feedObject= [app.FeedbackOrQueryDetailChatingObjectsArray objectAtIndex:indexPath.row];

    UILabel* feedTextLbl= [[UILabel alloc]initWithFrame:CGRectMake(5.0f, 0.0f, self.view.frame.size.width - 10.0f, 30.0f)];
    feedTextLbl.text=feedObject.detailMessage;
    [feedTextLbl setFont:[UIFont systemFontOfSize:12.0f]];
    feedTextLbl.lineBreakMode = UILineBreakModeWordWrap;
    feedTextLbl.numberOfLines = 10000000;
   // feedTextLbl.text= @"gfhghj gg gh kljh klh lkjhkl lkh klh lkhlk klj klh kljh klh kljh lkhjkl kljh kljh kljh kljh klh kljh k fghdf hdf hdfh dh h h dfhdfh dfh dfh h h dfh h dfhdf hdfh dfh dfh dfhdfhdfh dfhd hdfh dhdh lhj lkjh kljh l;khj lkh lkhj klj kljh klj hhj";

   CGRect newFrame= [self getFrameSize:feedObject label:feedTextLbl];
    CGRect newFrame1= [self getFrame:feedObject label:feedTextLbl];

//    CGSize maximumLabelSize = CGSizeMake(96, FLT_MAX);
//    
//    CGSize expectedLabelSize = [feedObject.detailMessage sizeWithFont:feedTextLbl.font constrainedToSize:maximumLabelSize lineBreakMode:feedTextLbl.lineBreakMode];
//    
//    //adjust the label the the new height.
//    CGRect newFrame = feedTextLbl.frame;
//    newFrame.size.height = expectedLabelSize.height;
    NSLog(@"%f",40 + newFrame.size.height+newFrame1.size.height);
    return 30 + newFrame.size.height+newFrame1.size.height;
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
//    if ([attachmentName isEqualToString:@""])
//    {
//        newFrame.size.height=0;
//        
//    }
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
-(NSString *) stringByStrippingHTML:(NSString *) stringWithHtmlTags {
    NSRange r;
    while ((r = [stringWithHtmlTags rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        stringWithHtmlTags = [stringWithHtmlTags stringByReplacingCharactersInRange:r withString:@""];
    return stringWithHtmlTags;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//
//-(void)uploadFileToServer:(NSString *)fileName
//
//{
//    fileName = @"AppIcon80x80.png";
//
//    
//    // NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", @"http://192.168.3.170:8080/coreflex/feedcom", @"uploadFileFromMobile"]];
//    
//    NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", @"http://localhost:9090/coreflex/feedcom", @"uploadFileFromMobile"]];
//    
//
//    NSString *boundary = [self generateBoundaryString];
//    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"AppIcon80x80" ofType:@"png"];
//
//    // configure the request
//    NSDictionary *params = @{@"filename"     : @"AppIcon80x80.png",
//                             };
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
//    [request setHTTPMethod:@"POST"];
//    
//    // set content type
//    
//    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
//    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
//    
//    // create body
//    
//    NSData *httpBody = [self createBodyWithBoundary:boundary parameters:params paths:@[path] fieldName:fileName];
//    
//    request.HTTPBody = httpBody;
//    
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        if (connectionError)
//        {
//            NSLog(@"error = %@", connectionError);
//            return;
//        }
//        
//        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        NSLog(@"result = %@", result);
//    }];
//    
//    
//    
//    
//    
//}
//
//
//
//- (NSData *)createBodyWithBoundary:(NSString *)boundary
//                        parameters:(NSDictionary *)parameters
//                             paths:(NSArray *)paths
//                         fieldName:(NSString *)fieldName
//{
//    NSMutableData *httpBody = [NSMutableData data];
//    
//    // add params (all params are strings)
//    
//    [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *parameterKey, NSString *parameterValue, BOOL *stop) {
//        [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//        [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", parameterKey] dataUsingEncoding:NSUTF8StringEncoding]];
//        [httpBody appendData:[[NSString stringWithFormat:@"%@\r\n", parameterValue] dataUsingEncoding:NSUTF8StringEncoding]];
//    }];
//    
//    // add image data
//    
//    for (NSString *path in paths)
//    {
//        NSString *filename  = [path lastPathComponent];
//        NSData   *data      = [NSData dataWithContentsOfFile:path];
//        NSString *mimetype  = [self mimeTypeForPath:path];
//        
//        [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//        [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", fieldName, filename] dataUsingEncoding:NSUTF8StringEncoding]];
//        [httpBody appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", mimetype] dataUsingEncoding:NSUTF8StringEncoding]];
//        [httpBody appendData:data];
//        [httpBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    }
//    
//    [httpBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    return httpBody;
//}
//
//
//- (NSString *)mimeTypeForPath:(NSString *)path
//{
//    // get a mime type for an extension using MobileCoreServices.framework
//    
//    CFStringRef extension = (__bridge CFStringRef)[path pathExtension];
//    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, extension, NULL);
//    assert(UTI != NULL);
//    
//    NSString *mimetype = CFBridgingRelease(UTTypeCopyPreferredTagWithClass(UTI, kUTTagClassMIMEType));
//    assert(mimetype != NULL);
//    
//    CFRelease(UTI);
//    
//    return mimetype;
//}
//
//
//- (NSString *)generateBoundaryString
//{
//    return [NSString stringWithFormat:@"Boundary-%@", [[NSUUID UUID] UUIDString]];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo
{
    // Dismiss the image selection, hide the picker and
    //UIViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailChatingViewController"];
    

    //show the image view with the picked image
    
       [self dismissViewControllerAnimated:YES completion:NULL];
    //UIImage *newImage = image;
}

//- (void)imagePickerController:(UIImagePickerController *)picker
//        didFinishPickingImage:(UIImage *)image
//                  editingInfo:(NSDictionary *)editingInfo
//{
//    // Dismiss the image selection, hide the picker and
//    
//    //show the image view with the picked image
//    NSLog(@"%@",self.presentingViewController.presentingViewController);
//    UIViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailChatingViewController"];
//    
//    //[self.navigationController pushViewController:vc animated:YES];
//
//    [self.navigationController pushViewController:vc animated:YES];
//    //UIImage *newImage = image;
//}

- (IBAction)sendFeedbackButtonClicked:(id)sender
{
    //NSString* replyMessageString= sendFeedbackTextfield.text;
    NSString* userFrom,* userTo;
    long feedbackCount;
   //NSString* userFeedback;
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
        //feedbackCount=[db getFeedbackCounterFromSONumberAndFeedbackType:feedObject.soNumber :feedObject.feedbackType];

        //NSArray* operatorAndStausidArray=[db getOperatotAndStatusIdArrayFromSoNo:feedObject.soNumber];
        
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
        
        NSMutableDictionary* MainDict=[NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] valueForKey:@"flag"],@"flag",dic,@"feedcomOrQuerycom", nil];

        
        NSLog(@"%@",dic);
        
        [[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"];
        [[NSUserDefaults standardUserDefaults] valueForKey:@"currentPassword"];



        [[APIManager sharedManager] sendUpdatedRecords:[[NSUserDefaults standardUserDefaults] valueForKey:@"flag"] Dict:dic username:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"] password:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentPassword"]];
      // [db insertUserReply:feedObj];
        
        
        
    
    }

}
@end
