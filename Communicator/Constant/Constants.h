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
#define  BASE_URL_PATH                  @"http://192.168.3.170:8080/coreflex/feedcom"


#define  POST                           @"POST"
#define  GET                            @"GET"
#define  PUT                            @"PUT"
#define  REQUEST_PARAMETER              @"requestParameter"
#define  SUCCESS                        @"1000"
#define  FAILURE                        @"1001"

// API List
#define  USER_LOGIN_API                @"getListOfFeedcomAndQueryComForCommunication"

#define  NEW_USER_LOGIN_API            @"login"
#define  FIND_COUNT_API                @"getcommunicationCounterForFeedComQueryCom"
#define GET_LATEST_RECORDS           @"getListOfFeedcomAndQueryComForCommunication"
#define SEND_UPDATED_RECORDS         @"updatedMobileFeedcomCommunication"

#define UPLOAD_FILE         @"uploadFileFromMobile"


//getListOfFeedcomForCommunication

//NSNOTIFICATION

#define NOTIFICATION_VALIDATE_USER    @"notificationForValidationOfUser"
#define NOTIFICATION_VALIDATE_COUNTER    @"notificationForValidationOfCounter"
#define NOTIFICATION_GETLATEST_RECORDS    @"notificationForLatestRecords"



#endif /* Constants_h */
