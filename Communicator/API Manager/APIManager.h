//
//  APIManager.h
//  Communicator
//
//  Created by mac on 05/04/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownloadMetaDataJob.h"

@interface APIManager : NSObject
{
    
}

+(APIManager *) sharedManager;

//-(void) validateUser:(NSString *) usernameString andPassword:(NSString *) passwordString;
-(void) validateUser:(NSString *) usernameString Password:(NSString *) passwordString andDeviceId:(NSString*)DeviceId;
-(void) findCountForUsername:(NSString*)username andPassword:(NSString*)password;
-(void) getLatestRecordsForUsername:(NSString*)username andPassword:(NSString*)password;
-(void) sendUpdatedRecords:(NSString*)flag Dict:(NSDictionary*)feedcomDict username:(NSString*)username password:(NSString*)password;
-(void) sendNewFeedback:(NSString*)flag Dict:(NSDictionary*)feedcomDict username:(NSString*)username password:(NSString*)password;
-(void) sendNewMOM:(NSDictionary*)feedcomDict username:(NSString*)username password:(NSString*)password;

-(void) uploadFile:(NSString*)fileName andFileString:(NSString*)fileString;
-(void) getLatestMOMForUsername:(NSString*)usernameString andPassword:(NSString*)passwordString;
-(void) get50ReoprtForUsername:(NSString*)usernameString andPassword:(NSString*)passwordString;
-(void) get50DocumentsForUsername:(NSString*)usernameString andPassword:(NSString*)passwordString;

-(void)getFile;

-(NSDate*) getDate;

@end
