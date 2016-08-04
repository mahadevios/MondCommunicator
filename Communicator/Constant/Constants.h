//
//  Constants.h
//  Communicator
//
//  Created by mac on 23/04/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

//#define  BASE_URL_PATH                  @"http://localhost:9090/coreflex/feedcom"

//#define  BASE_URL_PATH                  @"http://115.249.195.23:8080/Communicator/feedcom/"

#define  BASE_URL_PATH                  @"http://192.168.3.170:8080/coreflex/feedcom"
#define FTPHostName    @"@pantudantukids.com"
#define FTPFilesFolderName  @"/TEST/"
#define FTPUsername  @"demoFtp%40pantudantukids.com"
#define FTPPassword  @"asdf123"

#define  POST                           @"POST"
#define  GET                            @"GET"
#define  PUT                            @"PUT"
#define  REQUEST_PARAMETER              @"requestParameter"
#define  SUCCESS                        @"1000"
#define  FAILURE                        @"1001"

// API List
//#define  USER_LOGIN_API                @"getListOfFeedcomAndQueryComForCommunication"
#define  NEW_USER_LOGIN_API            @"login"
#define  FIND_COUNT_API                @"getcommunicationCounterForFeedComQueryCom"
#define GET_LATEST_RECORDS             @"getListOfFeedcomAndQueryComForCommunication"
#define SEND_UPDATED_RECORDS           @"updatedMobileFeedcomCommunication"
#define SEND_NEW_FEEDBACK              @"newMobileFeedcomCommunication"
#define SEND_NEW_MOM                   @"newMobileMOM"
#define UPLOAD_FILE                    @"uploadFileFromMobile"
#define GET_LATEST_MOM                 @"getListOf50MOM"
#define GET_50_REPORTS                 @"getListOf50Reports"
#define GET_50_DOCUMENTS               @"getListOf50Documents"
#define FILEPATH                       @"146617501944601 Soch Na Sake - Version 1 Airlift (Arijit Singh) 190Kbps.mp3"
//getListOfFeedcomForCommunication

//NSNOTIFICATION

#define NOTIFICATION_VALIDATE_USER      @"notificationForValidationOfUser"
#define NOTIFICATION_VALIDATE_COUNTER   @"notificationForValidationOfCounter"
#define NOTIFICATION_GETLATEST_FEEDCOM  @"notificationForLatestFeedcom"
#define NOTIFICATION_GETLATEST_MOM      @"notificationForLatestMOM"
#define NOTIFICATION_GET_50REPORTS      @"notificationFor50Reports"
#define NOTIFICATION_GET_50DOCUMENTS    @"notificationFor50Documents"
#define NOTIFICATION_SEND_NEWFEEDBACK   @"notificationForNewFeedback"
#define NOTIFICATION_SEND_MOM           @"notificationForNewMOM"
#define NOTIFICATION_SEND_UPDATED_RECORDS           @"notificationForUpdatedRecords"

#define FILEPATHNOTI    @"filepath"



#endif /* Constants_h */
