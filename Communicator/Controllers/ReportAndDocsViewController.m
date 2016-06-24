//http://localhost:9090/coreflex/resources/CfsFiles/1466172700295Download-3X.png
//146617501944601 Soch Na Sake - Version 1 Airlift (Arijit Singh) 190Kbps.mp3
//  ReportAndDocsViewController.m
//  Communicator
//
//  Created by mac on 24/05/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import "ReportAndDocsViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "Database.h"
#import "Report.h"
@interface ReportAndDocsViewController ()

@end

@implementation ReportAndDocsViewController
@synthesize reportButton;
@synthesize reportButtonUnderlineView;
@synthesize documentButton;
@synthesize documentButtonUnderlineView;
- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self setSelectedButton:reportButton];
    documentButtonUnderlineView.hidden=YES;
    // Do any additional setup after loading the view.
    arrayForBool=[[NSMutableArray alloc]init];

//    sectionTitleArray=[[NSArray alloc]initWithObjects:
//                       @"Date 1",
//                       @"Date 2",
//                       @"Date 3",
//                       @"Date 4",
//                       @"Date 5",
//                       @"Date 5",
//                       @"Date 6",
//                       @"Date 7",
//                       nil];
   
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

//-(void)uploadFileToServer
//{
//
//
//
//
//}
-(void)viewWillAppear:(BOOL)animated
{
//    NSError* error;
//    NSURL *url = [NSURL URLWithString:
//    @"http://localhost:9090/coreflex/resources/CfsFiles/1466172700295Download-3X.png"];
//    UIImage *image = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]];
//    NSString *folderpath=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Images"];
//    NSString *destpath=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Images/1466172700295Download-3X.png"];
//
//       if (![[NSFileManager defaultManager] fileExistsAtPath:folderpath])
//        [[NSFileManager defaultManager] createDirectoryAtPath:folderpath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
//    [UIImagePNGRepresentation(image) writeToFile:destpath atomically:YES];
//
    

    
    self.tabBarController.navigationItem.title = @"Reports & Docs";
     //self.tabBarController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(popViewController1)] ;
    self.tabBarController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"SignOut"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewController1)] ;
     self.tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Upload"] style:UIBarButtonItemStylePlain target:self action:@selector(selectFileToUpload:)] ;
    [self.navigationItem setHidesBackButton:NO];
    //self.navigationController.navigationBar.barTintColor = [UIColor communicatorColor];
    self.tabBarController.navigationItem.leftBarButtonItem.tintColor=[UIColor whiteColor];
    self.tabBarController.navigationItem.rightBarButtonItem.tintColor=[UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(get50Reports:) name:NOTIFICATION_GET_50REPORTS
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(get50Documents:) name:NOTIFICATION_GET_50DOCUMENTS
                                               object:nil];

    
    Database *db=[Database shareddatabase];
    [db setReportView];
    [self setFilesDateWise];
[self setSelectedButton:reportButton];
    
       
}

-(void)selectFileToUpload:(NSString*)para
{
 UIViewController* vc= [self.storyboard instantiateViewControllerWithIdentifier:@"SelectFileNavigationController"];
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}

-(void)setFilesDateWise
{
    AppPreferences *app=[AppPreferences sharedAppPreferences];
    sectionTitleArray=[[NSMutableArray alloc]init];
    sectionTitleArray= [app.reportFileNamesDict allKeys];
    

    for (int i=0; i<sectionTitleArray.count; i++)
    {
        
        NSString *encodedObjec= [sectionTitleArray objectAtIndex:i];
        NSData *encodedObject=[app.reportFileNamesDict valueForKey:encodedObjec];
        fileNameUserArray = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
        
    }
    
    for (int i=0; i<[sectionTitleArray count]; i++)
    {
        [arrayForBool addObject:[NSNumber numberWithBool:NO]];
    }
    [self.tableView reloadData];


}


- (void)get50Reports:(NSNotification *)notificationData
{
    if ([[notificationData.object objectForKey:@"code"] isEqualToString:SUCCESS])
    {
        NSLog(@"in noti");
        Database *db=[Database shareddatabase];
        [db insertReportData:notificationData.object];
       // AppPreferences *app=[AppPreferences sharedAppPreferences];
        
    }
}
- (void)get50Documents:(NSNotification *)notificationData
{
    if ([[notificationData.object objectForKey:@"code"] isEqualToString:SUCCESS])
    {
        NSLog(@"in noti");
        Database *db=[Database shareddatabase];
        [db insertDocumentsData:notificationData.object];
       // AppPreferences *app=[AppPreferences sharedAppPreferences];
        
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [sectionTitleArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 70;

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    AppPreferences* app=[AppPreferences sharedAppPreferences];
    if ([[arrayForBool objectAtIndex:section] boolValue])
    {
        NSString *encodedObjec= [sectionTitleArray objectAtIndex:section];
        NSData *encodedObject=[app.reportFileNamesDict valueForKey:encodedObjec];
        NSMutableArray* file = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
        return file.count;
    }
    else
        return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    BOOL isExapnd  = [[arrayForBool objectAtIndex:section] boolValue];

    sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 280,40)];
    UILabel *fileCountLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.tableView.frame.size.width-60, 0, 50, 40)];

    //UIImage* fileClosed=[UIImage imageNamed:@"Fileclosed"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 50, 40)];
    if ([[arrayForBool objectAtIndex:section] boolValue])
    {
        
        imageView.image=[UIImage imageNamed:@"FileOpened"];
        [fileCountLabel removeFromSuperview];

    }
    else
    {
        AppPreferences* app=[AppPreferences sharedAppPreferences];

        NSString *encodedObjec= [sectionTitleArray objectAtIndex:section];
        NSData *encodedObject=[app.reportFileNamesDict valueForKey:encodedObjec];
        NSMutableArray* file = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
        imageView.image=[UIImage imageNamed:@"Fileclosed"];
        fileCountLabel.text=[NSString stringWithFormat:@"%ld Files",file.count];
        [sectionView addSubview:fileCountLabel];
    }
        
    [sectionView addSubview:imageView];
    sectionView.tag=section;
    
   // UILabel* label=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 50, 40)];
    //UILabel* label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];

    UILabel *fileSectionLabel=[[UILabel alloc]initWithFrame:CGRectMake(70, 0, self.tableView.frame.size.width-10, 40)];
    //label.text=@"hello";
    fileSectionLabel.backgroundColor=[UIColor clearColor];
    fileSectionLabel.textColor=[UIColor blackColor];
    fileSectionLabel.font=[UIFont systemFontOfSize:15];
    fileSectionLabel.text=[NSString stringWithFormat:@"List of Files on %@",[sectionTitleArray objectAtIndex:section]];
    [sectionView addSubview:fileSectionLabel];
    
    
    /********** Add UITapGestureRecognizer to SectionView   **************/
    
    UITapGestureRecognizer  *headerTapped   = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionHeaderTapped:)];
    [sectionView addGestureRecognizer:headerTapped];
    
    return  sectionView;
    
    
}

- (void)sectionHeaderTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:gestureRecognizer.view.tag];
    
    if (indexPath.row == 0)
    {
        BOOL collapsed  = [[arrayForBool objectAtIndex:indexPath.section] boolValue];
        for (int i=0; i<[sectionTitleArray count]; i++)
        {
            if (indexPath.section==i)
            {
                [arrayForBool replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:!collapsed]];
            }
        }
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:gestureRecognizer.view.tag] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    //cell.imageView.image=[UIImage imageNamed:@"Fileclosed"];
    AppPreferences* app=[AppPreferences sharedAppPreferences];
    BOOL manyCells  = [[arrayForBool objectAtIndex:indexPath.section] boolValue];
    
    /********** If the section supposed to be closed *******************/
    if(!manyCells)
    {
        cell.backgroundColor=[UIColor clearColor];
        
        cell.textLabel.text=@"";
    }
    /********** If the section supposed to be Opened *******************/
    else
    {
        UILabel* fileNameLabel=(UILabel*)[cell viewWithTag:101];
        NSString *encodedObjec= [sectionTitleArray objectAtIndex:indexPath.section];
        NSData *encodedObject=[app.reportFileNamesDict valueForKey:encodedObjec];
       NSMutableArray* file = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
        
                   Report *obj= [file objectAtIndex:indexPath.row];
            NSLog(@"%@",obj.name);
       

       // [sectionTitleArray objectAtIndex:indexPath.row];
        //fileNameUserArray
        fileNameLabel.text=[NSString stringWithFormat:@"%@",obj.name];
        fileNameLabel.font=[UIFont systemFontOfSize:15.0f];
        UIImageView* fileDownloadImageView=(UIImageView*)[cell viewWithTag:102];
        fileDownloadImageView.image=[UIImage imageNamed:@"FileDownload"];

       // cell.imageView.image=[UIImage imageNamed:@"point.png"];
       // cell.selectionStyle=UITableViewCellSelectionStyleNone ;
    }
    //cell.textLabel.textColor=[UIColor blackColor];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[arrayForBool objectAtIndex:indexPath.section] boolValue])
    {
        return 40;
    }
    return 0;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    
    UILabel* fileNameLabel=(UILabel*)[selectedCell viewWithTag:101];
    
    NSString* filenameString=fileNameLabel.text;

    NSError* error;
   // [NSString stringWithFormat:@"http://localhost:9090/coreflex/resources/CfsFiles/%@",filenameString];
//    NSURL *url = [NSURL URLWithString:
//                  [NSString stringWithFormat:@"http://localhost:9090/coreflex/resources/CfsFiles/%@",filenameString]];
   NSString* str= [NSString stringWithFormat:@"http://localhost:9090/coreflex/resources/CfsFiles/%@",filenameString];
    
    NSString* stringURL = [NSString stringWithFormat:@"http://localhost:9090/coreflex/resources/CfsFiles/%@",filenameString];
    NSString* webStringURL = [stringURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL* url = [NSURL URLWithString:webStringURL];
    
           NSData * data = [NSData dataWithContentsOfURL:url];
    NSString *folderpath=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Downloads"];
    
    NSString *destpath=[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/Downloads/%@",filenameString]];
    
     if (![[NSFileManager defaultManager] fileExistsAtPath:folderpath])
        [[NSFileManager defaultManager] createDirectoryAtPath:folderpath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
    [data writeToFile:destpath atomically:YES];
       
    
    
}



-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.tableView reloadData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)uploadFileToServer:(NSString *)fileName

{
    fileName = @"AppIcon80x80.png";
    
    
    // NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", @"http://192.168.3.170:8080/coreflex/feedcom", @"uploadFileFromMobile"]];
    
    NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", @"http://localhost:9090/coreflex/feedcom", @"uploadFileFromMobile"]];
    
    
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
        if (connectionError)
        {
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



-(void)setSelectedButton:(id)sender
{
    
    if (sender==reportButton)
    {
        Database *db=[Database shareddatabase];
        [db setReportView];
       [self setFilesDateWise];
                documentButtonUnderlineView.hidden=YES;
        reportButtonUnderlineView.hidden=NO;
        
        [documentButton setSelected:NO];
        [sender setSelected: YES];
        [sender setTitleColor:[UIColor colorWithRed:10/255.0 green:32/255.0 blue:47/255.0 alpha:1] forState:UIControlStateSelected];
        
        NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];
        [defaults setValue:@"0" forKey:@"flag"];
        [self.tableView reloadData];
        
    }
    
    if (sender==documentButton)
    {
        
        Database *db=[Database shareddatabase];
        [db setDocumentView];
       [self setFilesDateWise];

        reportButtonUnderlineView.hidden=YES;
        documentButtonUnderlineView.hidden=NO;
        
        [reportButton setSelected:NO];
        [sender setSelected: YES];
        [sender setTitleColor:[UIColor colorWithRed:9/255.0 green:45/255.0 blue:61/255.0 alpha:1] forState:UIControlStateSelected];
        
        NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];
        [defaults setValue:@"1" forKey:@"flag"];
        [self.tableView reloadData];
        
        
    }
    
}

- (IBAction)buttonClicked:(id)sender
{
    [self setSelectedButton:sender];
}

@end
