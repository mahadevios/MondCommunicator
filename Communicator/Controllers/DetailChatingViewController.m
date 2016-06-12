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

    NSString* dateString= allMessageObj1.dateOfFeed;
    double da=[dateString doubleValue];
    NSString* dd=allMessageObj1.dateOfFeed;
    //NSString *dd = [NSString stringWithFormat:@"%@",[NSDate dateWithTimeIntervalSince1970:da/1000.0]];
    NSDate* sd=[[NSDate alloc]init];
    NSArray *components = [dd componentsSeparatedByString:@" "];
    NSString *date = components[0];
    NSString *time = components[1];
    NSLog(@"%@,,,,%@",date,time);

        dateOfFeedLabel.text=[NSString stringWithFormat:@"%@\n%@",date,time];

    
    [self uploadFileToServer:@""];

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
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

    //UILabel* userName= (UILabel*)[cell viewWithTag:50];
   // userName.text=@"details";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
   FeedbackChatingCounter* feedObject= [app.FeedbackOrQueryDetailChatingObjectsArray objectAtIndex:indexPath.row];
   UILabel* userName= (UILabel*)[cell viewWithTag:50];
    userName.text=feedObject.userFrom;
    UILabel* feedText= (UILabel*)[cell viewWithTag:51];
    NSString* detailMessage=[self stringByStrippingHTML:feedObject.detailMessage];
    feedText.text= @"gfhghj gg gh kljh klh lkjhkl lkh klh lkhlk klj klh kljh klh kljh lkhjkl kljh kljh kljh kljh klh kljh k fghdf hdf hdfh dh h h dfhdfh dfh dfh h h dfh h dfhdf hdfh dfh dfh dfhdfhdfh dfhd hdfh dhdh lhj lkjh kljh l;khj lkh lkhj klj kljh klj hhj";
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
    NSDate* sd=[[NSDate alloc]init];
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
    feedTextLbl.text= @"gfhghj gg gh kljh klh lkjhkl lkh klh lkhlk klj klh kljh klh kljh lkhjkl kljh kljh kljh kljh klh kljh k fghdf hdf hdfh dh h h dfhdfh dfh dfh h h dfh h dfhdf hdfh dfh dfh dfhdfhdfh dfhd hdfh dhdh lhj lkjh kljh l;khj lkh lkhj klj kljh klj hhj";

    FeedbackChatingCounter* feedObject= [app.FeedbackOrQueryDetailChatingObjectsArray objectAtIndex:indexPath.row];
   CGRect newFrame= [self getFrameSize:feedObject label:feedTextLbl];

//    CGSize maximumLabelSize = CGSizeMake(96, FLT_MAX);
//    
//    CGSize expectedLabelSize = [feedObject.detailMessage sizeWithFont:feedTextLbl.font constrainedToSize:maximumLabelSize lineBreakMode:feedTextLbl.lineBreakMode];
//    
//    //adjust the label the the new height.
//    CGRect newFrame = feedTextLbl.frame;
//    newFrame.size.height = expectedLabelSize.height;
    
    return 100 + newFrame.size.height;
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

-(void)uploadFileToServer:(NSString *)fileName

{
    fileName = @"AppIcon80x80.png";
    NSString *destpath=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/AppIcon80x80.png"];
    NSString *sourcepath=[[NSBundle mainBundle]pathForResource:@"AppIcon80x80" ofType:@"png"];
    if(![[NSFileManager defaultManager] fileExistsAtPath:destpath])
    {
        //   NSLog(@"inside");
        [[NSFileManager defaultManager] copyItemAtPath:sourcepath toPath:destpath error:nil];
    }

    
    /* creating path to document directory and appending filename with extension */
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    NSData *file1Data = [[NSData alloc] initWithContentsOfFile:filePath];
 /*
//    NSString* fileStr = [[NSString alloc] initWithData:file1Data encoding:NSASCIIStringEncoding];
//    NSString* newStr = [NSString stringWithUTF8String:[file1Data bytes]];
//    NSString *encodedString = [file1Data base64Encoding];
    NSError *error;
//    NSString *contents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    NSString *content = [NSString stringWithContentsOfFile:destpath encoding:NSUTF8StringEncoding error:nil];
//    NSString *stringImage = [file1Data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    [[APIManager sharedManager]uploadFile:fileName andFileString:file1Data];
*/
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@", @"http://192.168.3.170:8080/coreflex/feedcom", @"uploadFileFromMobile"];
    
    
      
    
    
    
   // NSString *url = [NSString stringWithFormat:@"%@/%@", @"http://192.168.3.170:8080/coreflex/feedcom", @"uploadFileFromMobile"];
    NSURLResponse *response;
    
    NSError *error;
    NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", @"http://192.168.3.170:8080/coreflex/feedcom", @"uploadFileFromMobile"]];
    NSString *boundary = [self generateBoundaryString];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"AppIcon80x80" ofType:@"png"];

    // configure the request
    NSDictionary *params = @{@"filename"     : @"AppIcon80x80.png",
                             };
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    // set content type
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // create body
    
    NSData *httpBody = [self createBodyWithBoundary:boundary parameters:params paths:@[path] fieldName:fileName];
    
    request.HTTPBody = httpBody;
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            NSLog(@"error = %@", connectionError);
            return;
        }
        
        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"result = %@", result);
    }];
    
    
    
    
    
}



- (NSData *)createBodyWithBoundary:(NSString *)boundary
                        parameters:(NSDictionary *)parameters
                             paths:(NSArray *)paths
                         fieldName:(NSString *)fieldName
{
    NSMutableData *httpBody = [NSMutableData data];
    
    // add params (all params are strings)
    
    [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *parameterKey, NSString *parameterValue, BOOL *stop) {
        [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", parameterKey] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"%@\r\n", parameterValue] dataUsingEncoding:NSUTF8StringEncoding]];
    }];
    
    // add image data
    
    for (NSString *path in paths)
    {
        NSString *filename  = [path lastPathComponent];
        NSData   *data      = [NSData dataWithContentsOfFile:path];
        NSString *mimetype  = [self mimeTypeForPath:path];
        
        [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", fieldName, filename] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", mimetype] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:data];
        [httpBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [httpBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    return httpBody;
}


- (NSString *)mimeTypeForPath:(NSString *)path
{
    // get a mime type for an extension using MobileCoreServices.framework
    
    CFStringRef extension = (__bridge CFStringRef)[path pathExtension];
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, extension, NULL);
    assert(UTI != NULL);
    
    NSString *mimetype = CFBridgingRelease(UTTypeCopyPreferredTagWithClass(UTI, kUTTagClassMIMEType));
    assert(mimetype != NULL);
    
    CFRelease(UTI);
    
    return mimetype;
}


- (NSString *)generateBoundaryString
{
    return [NSString stringWithFormat:@"Boundary-%@", [[NSUUID UUID] UUIDString]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)sendFeedbackButtonClicked:(id)sender
{
    NSString* replyMessageString= sendFeedbackTextfield.text;
    NSString* userFrom;
    NSString* userTo;
    NSString* userFeedback;
    if ([sendFeedbackTextfield.text length] <= 0)
    {
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
        Database* db=[Database shareddatabase];
        FeedbackChatingCounter* feedObject= [app.FeedbackOrQueryDetailChatingObjectsArray objectAtIndex:0];

        NSString* username = [[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"];
        NSString* companyId=[db getCompanyId:username];
        NSString* userFeedback=[db getUserIdFromUserName:username];
        NSMutableArray* maxFeedIdAndCounterArray=[db getMaxFeedIdAndCounter:feedObject.soNumber];
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
        
        NSArray* keys=[NSArray arrayWithObjects:@"soNumber",@"userFrom",@"userTo",@"userFeedback",@"feedText",@"feedbackType",@"feedbackCounter", nil];
       // NSArray* values=[NSArray arrayWithObjects:feedObj.soNumber,feedObj.userFrom,feedObj.userTo,feedObj.feedbackText,feedObj.feedbackType,feedObj.feedbackCounter+1, nil];
        NSArray* values=@[feedObj.soNumber,[NSString stringWithFormat:@"%d",feedObj.userFrom],[NSString stringWithFormat:@"%d",feedObj.userTo],[NSString stringWithFormat:@"%d",feedObj.userFeedback],feedObj.feedbackText,[NSString stringWithFormat:@"%d",feedObj.feedbackType],[NSString stringWithFormat:@"%ld",feedObj.feedbackCounter+1]];
        NSDictionary* dic=[NSDictionary dictionaryWithObjects:values forKeys:keys];
        NSLog(@"%@",[dic valueForKey:@"userFeedback"]);
        
        NSMutableDictionary* MainDict=[NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] valueForKey:@"flag"],@"flag",dic,@"feedcomOrQuerycom", nil];
        //NSDictionary* dict=[MainDict valueForKey:@"feedcomOrQuerycom"];
        NSLog(@"%@",dic);
        [[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"];
        [[NSUserDefaults standardUserDefaults] valueForKey:@"currentPassword"];


        //[[APIManager sharedManager]sendUpdatedRecords:[[NSUserDefaults standardUserDefaults] valueForKey:@"flag"] andPassword:dic];
        [[APIManager sharedManager] sendUpdatedRecords:[[NSUserDefaults standardUserDefaults] valueForKey:@"flag"] Dict:dic username:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"] password:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentPassword"]];
       [db insertUserReply:feedObj];
        [db getDetailMessagesofFeedbackOrQuery:feedObj.feedbackType :feedObj.soNumber];

        [tableview reloadData];
        
    
    }

}
@end
