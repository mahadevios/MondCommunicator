//
//  APIManager.m
//  Communicator
//
//  Created by mac on 05/04/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import "APIManager.h"
#import "AppDelegate.h"

@implementation APIManager

static APIManager *singleton = nil;

// Shared method
+(APIManager *) sharedManager
{
    if (singleton == nil)
    {
        singleton = [[APIManager alloc] init];
        [[AppPreferences sharedAppPreferences] startReachabilityNotifier];
    }
    
    return singleton;
}

// Init method
-(id) init
{
    self = [super init];
    
    if (self)
    {
        
    }
    
    return self;
}

#pragma mark
#pragma mark ValidateUser API
#pragma mark

//-(void) validateUser:(NSString *) usernameString andPassword:(NSString *) passwordString
//{
//    if ([[AppPreferences sharedAppPreferences] isReachable])
//    {
//        NSArray *params = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"username=%@",usernameString], [NSString stringWithFormat:@"password=%@",passwordString] ,nil];
//        
//        NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:params,REQUEST_PARAMETER, nil];
//        
//        DownloadMetaDataJob *downloadmetadatajob=[[DownloadMetaDataJob alloc]initWithdownLoadEntityJobName:USER_LOGIN_API withRequestParameter:dictionary withResourcePath:USER_LOGIN_API withHttpMethd:POST];
//        [downloadmetadatajob startMetaDataDownLoad];
//    }
//    else
//    {
//        [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"No internet connection!" withMessage:@"Please turn on your inernet connection to access this feature" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
//    }
//}



-(void) validateUser:(NSString *) usernameString Password:(NSString *) passwordString andDeviceId:(NSString*)deviceToken

{
    if ([[AppPreferences sharedAppPreferences] isReachable])
    {
        NSArray *params = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"username=%@",usernameString], [NSString stringWithFormat:@"password=%@",passwordString] ,[NSString stringWithFormat:@"deviceToken=%@",deviceToken],nil];
        
        NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:params,REQUEST_PARAMETER, nil];
        
        DownloadMetaDataJob *downloadmetadatajob=[[DownloadMetaDataJob alloc]initWithdownLoadEntityJobName:NEW_USER_LOGIN_API withRequestParameter:dictionary withResourcePath:NEW_USER_LOGIN_API withHttpMethd:POST];
        [downloadmetadatajob startMetaDataDownLoad];
    }
    else
    {
        [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"No internet connection!" withMessage:@"Please turn on your inernet connection to access this feature" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
    }
}



-(void) findCountForUsername:(NSString*)usernameString andPassword:(NSString*)passwordString;
{
    if ([[AppPreferences sharedAppPreferences] isReachable])
    {
        NSArray *params = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"username=%@",usernameString], [NSString stringWithFormat:@"password=%@",passwordString] ,nil];
        
        NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:params,REQUEST_PARAMETER, nil];
        
        DownloadMetaDataJob *downloadmetadatajob=[[DownloadMetaDataJob alloc]initWithdownLoadEntityJobName:FIND_COUNT_API withRequestParameter:dictionary withResourcePath:FIND_COUNT_API withHttpMethd:POST];
        [downloadmetadatajob startCounterDownLoad];
    }
    else
    {
        [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"No internet connection!" withMessage:@"Please turn on your inernet connection to access this feature" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
    }




}


@end
