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
    self.tabBarController.navigationItem.title = @"Detail Chating";
    
    self.tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Attachment"] style:UIBarButtonItemStylePlain target:self action:@selector(selectFileToUpload:)] ;
    self.tabBarController.navigationItem.rightBarButtonItem.tintColor=[UIColor whiteColor];
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
            
            [tableview reloadData];
        }
        else
        {
            [db insertUpdatedRecordsForQueryCom:notificationData.object];
            [db getDetailMessagesofFeedbackOrQuery:feedObject.feedbackType :feedObject.soNumber];
            
            [tableview reloadData];
         }
    
        
    }
}

-(void)selectFileToUpload:(NSString*)para
{
    //UIViewController* vc1= [self.storyboard instantiateViewControllerWithIdentifier:@"SelectFileNavigationController"];

   /// UINavigationController* navi=[[UINavigationController alloc]initWithRootViewController:vc1];
    UIViewController* vc= [self.storyboard instantiateViewControllerWithIdentifier:@"SelectFileNavigationController"];
    [self presentViewController:vc animated:YES completion:nil];
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
        if ([userRole isEqualToString:@"1"])
        {
            // 202,229,159
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
    
    //NSString* dateString= feedObject.dateOfFeed;
   // double da=[dateString doubleValue];
   // NSString *dd = [NSString stringWithFormat:@"%@",[NSDate dateWithTimeIntervalSince1970:da/1000.0]];
    
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
    NSLog(@"%@",date);
    NSLog(@"%@",time);

    feedTime.text=[NSString stringWithFormat:@"%@   %@",date,time];

    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // userName.text=@"details";
    UILabel* feedTextLbl= [[UILabel alloc]initWithFrame:CGRectMake(5.0f, 0.0f, self.view.frame.size.width - 10.0f, 30.0f)];
    [feedTextLbl setFont:[UIFont systemFontOfSize:12.0f]];
    feedTextLbl.lineBreakMode = UILineBreakModeWordWrap;
    feedTextLbl.numberOfLines = 10000000;
   // feedTextLbl.text= @"gfhghj gg gh kljh klh lkjhkl lkh klh lkhlk klj klh kljh klh kljh lkhjkl kljh kljh kljh kljh klh kljh k fghdf hdf hdfh dh h h dfhdfh dfh dfh h h dfh h dfhdf hdfh dfh dfh dfhdfhdfh dfhd hdfh dhdh lhj lkjh kljh l;khj lkh lkhj klj kljh klj hhj";

    FeedbackChatingCounter* feedObject= [app.FeedbackOrQueryDetailChatingObjectsArray objectAtIndex:indexPath.row];
   CGRect newFrame= [self getFrameSize:feedObject label:feedTextLbl];

//    CGSize maximumLabelSize = CGSizeMake(96, FLT_MAX);
//    
//    CGSize expectedLabelSize = [feedObject.detailMessage sizeWithFont:feedTextLbl.font constrainedToSize:maximumLabelSize lineBreakMode:feedTextLbl.lineBreakMode];
//    
//    //adjust the label the the new height.
//    CGRect newFrame = feedTextLbl.frame;
//    newFrame.size.height = expectedLabelSize.height;
    
    return 40 + newFrame.size.height;
}

-(CGRect)getFrameSize:(FeedbackChatingCounter*)feedObject label:(UILabel*)feedTextLbl
{
    CGSize maximumLabelSize = CGSizeMake(96, FLT_MAX);
    
    CGSize expectedLabelSize = [feedObject.detailMessage sizeWithFont:feedTextLbl.font constrainedToSize:maximumLabelSize lineBreakMode:feedTextLbl.lineBreakMode];
    
    //adjust the label the the new height.
    CGRect newFrame = feedTextLbl.frame;
    newFrame.size.height = expectedLabelSize.height;

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
        UIImagePickerController *imagePickerController=[[UIImagePickerController alloc]init];
        //UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
        imagePickerController.delegate = self;
        imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;

        [self presentViewController:imagePickerController animated:YES completion:nil];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Empty field"
                                                                                 message:@"Please enter valid username and password"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        //We add buttons to the alert controller by creating UIAlertActions:
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil]; //You can use a block here to handle a press on this button
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];

    }
    
    else
    {
        //UIImagePickerController *imagePickerController = [self.storyboard instantiateViewControllerWithIdentifier:@"UIImagePicker"];
       // imagePickerController mo
               //[self presentViewController:imagePickerController animated:YES completion:nil];

        //[self.navigationController presentViewController:imagePickerController animated:YES completion:^(void) {
        //    [self performSegueWithIdentifier:@"picker" sender:self];}];

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
        
        NSLog(@"%d,%d",feedObj.userFrom,feedObj.userTo);
      feedObj.statusId=[[NSString stringWithFormat:@"%@",[maxFeedIdAndCounterArray objectAtIndex:2]]intValue];
        feedObj.operatorId=[[NSString stringWithFormat:@"%@",[maxFeedIdAndCounterArray objectAtIndex:3]]intValue];
        //feedObj.attachment;
        NSLog(@"%@,%@,%d,%@,%@,%ld,%ld,%d,%d",feedObj.soNumber,feedObj.emailSubject, feedObj.feedbackType,feedObj.feedbackText,feedObj.dateOfFeed,feedObj.feedbackCounter,feedObj.feedbackId,feedObj.operatorId,feedObj.statusId);
        
        NSArray* keys=[NSArray arrayWithObjects:@"soNumber",@"userFrom",@"userTo",@"userFeedback",@"feedText",@"feedbackType",@"statusId",@"operatorId",@"emailSubject",@"attachment", nil];

        
        NSArray* values=@[feedObj.soNumber,[NSString stringWithFormat:@"%d",feedObj.userFrom],[NSString stringWithFormat:@"%d",feedObj.userTo],[NSString stringWithFormat:@"%d",feedObj.userFeedback],feedObj.feedbackText,[NSString stringWithFormat:@"%d",feedObj.feedbackType],[NSString stringWithFormat:@"%d",feedObj.statusId],[NSString stringWithFormat:@"%d",feedObj.operatorId],feedObj.emailSubject,@""];
        
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
