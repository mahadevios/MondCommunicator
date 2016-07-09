//
//  UploadFileViewController.m
//  Communicator
//
//  Created by mac on 21/06/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import "UploadFileViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIColor+CommunicatorColor.h"
#import <MobileCoreServices/MobileCoreServices.h>
@interface UploadFileViewController ()

@end

@implementation UploadFileViewController
@synthesize rightBarButton;
- (void)viewDidLoad
{
    [super viewDidLoad];
    AppPreferences* app=[AppPreferences sharedAppPreferences];
    app.imageFilesArray=[[NSMutableArray alloc]init];
    app.imageFileNamesArray=[[NSMutableArray alloc]init];
    rightBarButton.tintColor=[UIColor whiteColor];
    if (app.imageFilesArray.count==0) {
        rightBarButton.title=@"";
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated; // Called when the view is dismissed, covered or otherwise hidden. Default does nothing
{
    [super viewWillDisappear:YES];
    
    
}

- (void)viewDidDisappear:(BOOL)animated;  // Called after the view was dismissed, covered or otherwise hidden. Default does nothing
{
    [super viewDidDisappear:YES];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    AppPreferences* app=[AppPreferences sharedAppPreferences];
    self.navigationController.navigationBar.barTintColor = [UIColor communicatorColor];
    [self.navigationController.navigationBar setBarStyle:UIStatusBarStyleLightContent];//
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BackArrow"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewController)] ;
    
//    self.tabBarController.navigationItem.title = @"Upload Files";

   // self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@""] style:UIBarButtonItemStylePlain target:self action:nil] ;
    
    //    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@""] style:UIBarButtonItemStylePlain target:self action:@selector(uploadFileToServer:)] ;
//    
   // self.navigationItem.rightBarButtonItem.title=@"Upload";
    
    
   // [self.tabBarController.tabBar setHidden:YES];
    self.navigationItem.title = @"Upload Files";
    
    self.navigationItem.leftBarButtonItem.tintColor=[UIColor whiteColor];
    


}

-(void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
     UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
     AppPreferences* app=[AppPreferences sharedAppPreferences];
    [app.imageFileNamesArray addObject:@"12345.png"];
    [app.imageFilesArray addObject:chosenImage];
    [self.collectionView reloadData];
    [picker.view removeFromSuperview] ;
    [picker removeFromParentViewController] ;
 /*   ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
    {
        ALAssetRepresentation *representation = [myasset defaultRepresentation];
        CGImageRef iref = [representation fullResolutionImage];

        NSString *fileName = [representation filename];
        AppPreferences* app=[AppPreferences sharedAppPreferences];
        
        //UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
        UIImage *myImage = [UIImage imageWithCGImage:iref scale:[representation scale] orientation:(UIImageOrientation)[representation orientation]];

        [app.imageFilesArray addObject:myImage];
        [app.imageFileNamesArray addObject:fileName];
        [self.collectionView reloadData];

        NSLog(@"%ld",app.imageFilesArray.count);
        NSLog(@"fileName : %@",fileName);
    };
    
    [picker.view removeFromSuperview] ;
    [picker removeFromParentViewController] ;
*/
    
//    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
//    [assetslibrary assetForURL:imageURL
//                   resultBlock:resultblock
//                  failureBlock:nil];
//    [picker dismissViewControllerAnimated:YES completion:nil];
    
//    [self.navigationController popViewControllerAnimated:YES];
//    [picker removeFromParentViewController];
//    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (IBAction)selectFileFromGallery:(id)sender
{
    UIImagePickerController *imagePickerController=[[UIImagePickerController alloc]init];
    //UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.delegate = self;
    //imagePickerController.allowsEditing=YES;
    imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    
    //[self.view addSubview:imagePickerController.cameraOverlayView];
    // UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:imagePickerController];
    [self addChildViewController:imagePickerController] ;
    
    [imagePickerController didMoveToParentViewController:self] ;
    
    [self.view addSubview:imagePickerController.view] ;
    //    [self.navigationController presentedViewController:imagePickerController];

}

- (IBAction)selectFileFromStorage:(id)sender
{
    
}



- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    AppPreferences* app=[AppPreferences sharedAppPreferences];
    if (!(app.imageFilesArray.count==0)) {
//        rightBarButton.title=@"Upload";
        if (self.tabBarController == nil)
        {
            self.navigationItem.title = @"Upload Files";
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Upload" style:UIBarButtonItemStylePlain target:self action:@selector(uploadFileToServer:)];
        }
        else
        {
        self.tabBarController.navigationItem.title = @"Upload Files";
        self.tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Upload" style:UIBarButtonItemStylePlain target:self action:@selector(uploadFileToServer:)];
        }
    }
    else
    {
        if (self.tabBarController == nil)
        {
            self.navigationItem.title = @"Upload Files";
            self.navigationItem.rightBarButtonItem = nil;
        }
        else
        {
            self.tabBarController.navigationItem.title = @"Upload Files";
            self.tabBarController.navigationItem.rightBarButtonItem = nil;
        }

    }
    return app.imageFilesArray.count;
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
     AppPreferences* app=[AppPreferences sharedAppPreferences];
    UICollectionViewCell* cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
   
UIImageView* img=(UIImageView*)[cell viewWithTag:100];
    img.image=[app.imageFilesArray objectAtIndex:indexPath.item];
    
  UIButton* cancelImagebutton=  (UIButton*)[cell viewWithTag:101];
    //cancelImagebutton.tag=app.imageFilesArray.count;
    //cell.tag=indexPath.item;
    cancelImagebutton.tag=indexPath.item;
    [cancelImagebutton addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
   // [imageview addSubview:mybutton];
   // cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AppIcon"]];
    //[self.collectionView indexPathForRowAtPoint:]
    NSLog(@"%@",cell.backgroundColor);
         return cell;
    
}

//-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionViewCell* cell=[collectionView cellForItemAtIndexPath:indexPath];
//
//    //UIButton* cancelImagebutton=  (UIButton*)[cell viewWithTag:101];
//    UIButton* cancelImagebutto=  (UIButton*)[cell viewWithTag:101];
//
//    cancelImagebutto.tag=indexPath.item;    //cancelImagebutton.tag=app.imageFilesArray.count+0;
//    [cancelImagebutto addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
//
//
//
//}
-(void)delete:(id)sender
{
    UIButton *button = (UIButton *) sender;
    AppPreferences* app=[AppPreferences sharedAppPreferences];

           [app.imageFilesArray removeObjectAtIndex:button.tag];

    [self.collectionView reloadData];
}



-(void)uploadFileToServer:(NSString*)str

{
    AppPreferences* app=[AppPreferences sharedAppPreferences];
    

   // NSURL* url = [NSURL URLWithString:webStringURL];
    for (int i=0; i<app.imageFilesArray.count; i++)
    {
        NSError* error;
    NSData * data = UIImagePNGRepresentation([app.imageFilesArray objectAtIndex:i]);
    NSString *folderpath=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Downloads"];
    
    NSString *destpath=[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/Downloads/%@",[app.imageFileNamesArray objectAtIndex:i]]];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:folderpath])
        [[NSFileManager defaultManager] createDirectoryAtPath:folderpath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
    [data writeToFile:destpath atomically:YES];
    
    NSString* path = [NSHomeDirectory() stringByAppendingPathComponent:
                      [NSString stringWithFormat:@"Documents/Downloads/%@",[app.imageFileNamesArray objectAtIndex:i]] ];
    //--------------------------------------------------//
   NSString* fileName = [app.imageFileNamesArray objectAtIndex:i];


    // NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", @"http://192.168.3.170:8080/coreflex/feedcom", @"uploadFileFromMobile"]];
    
   // NSString *folderpath=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Downloads/test.png"];


    NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", @"http://localhost:9090/coreflex/feedcom", @"uploadFileFromMobile"]];


    NSString *boundary = [self generateBoundaryString];

    //NSString *path = [[NSBundle mainBundle] pathForResource:@"AppIcon80x80" ofType:@"png"];

    // configure the request
    NSDictionary *params = @{@"filename"     : [app.imageFileNamesArray objectAtIndex:i],
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

      //  NSString* mainData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSError* error;
       result = [NSJSONSerialization JSONObjectWithData:data
                                                              options:NSJSONReadingAllowFragments
                                                                error:&error];
        
        if (app.uploadedFileNamesArray == nil)
        {
            app.uploadedFileNamesArray = [[NSMutableArray alloc] init];
        }
        NSString *uploadedFileNameString = [result valueForKey:@"fileName"];
        uploadedFileNameString = [uploadedFileNameString stringByReplacingOccurrencesOfString:@"/" withString:@""];
        uploadedFileNameString = [uploadedFileNameString stringByReplacingOccurrencesOfString:@"\"" withString:@""];

     [app.uploadedFileNamesArray addObject:[result valueForKey:@"fileName"]];//add the uploaded file names to uploaded file names array to display on detail chating view controller
                     NSLog(@"result = %@", result);
        
        NSString* returnCode= [result valueForKey:@"code"];
       
        if ([returnCode isEqual:@"1000"])
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Upload message"
                                                                                     message:@"File(s) uploaded successfully"
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            //We add buttons to the alert controller by creating UIAlertActions:
            UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction *action)
                                       {
                                           AppPreferences* app=[AppPreferences sharedAppPreferences];
                                           
                                           [app.imageFileNamesArray removeAllObjects];
                                           [app.imageFilesArray removeAllObjects];
                                           //self.navigationItem.rightBarButtonItem.title=nil;
                                           
                                           [self.collectionView reloadData];
                                           [self popViewController];
                                       }]; //You can use a block here to handle a press on this button
            [alertController addAction:actionOk];
            [self presentViewController:alertController animated:YES completion:nil];
           
                rightBarButton.title=nil;
           
            
        }

    }];


    }
    
    

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


- (IBAction)barbuttonClicked:(id)sender
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //Do background work
        
        [self uploadFileToServer:@""];
       
        dispatch_async(dispatch_get_main_queue(), ^{
            //Update UI
                   });
    });
    

    
}
@end
