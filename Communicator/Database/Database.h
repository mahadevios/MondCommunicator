//
//  Database.h
//  DbExample
//
//  Created by mac on 08/02/16.
//  Copyright © 2016 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "FeedbackType.h"
#import "User.h"
#import "Feedback.h"

@interface Database : NSObject

+(Database *)shareddatabase;

-(NSString *)getDatabasePath;

-(NSMutableArray *)getFeedbackAndQueryTypes;

//-(NSMutableArray *)getFeedbackAndQueryMessages;

@property (strong, nonatomic) NSDictionary *getFeedbackAndQueryMessages;
@property (strong, nonatomic) NSMutableArray *feedbackAndQueryTypeArray;
@property (strong, nonatomic) NSMutableArray *SONoArray;
@property (strong, nonatomic) NSMutableArray *DuplicateSONoArray;

@property (strong, nonatomic) NSMutableDictionary *getFeedbackAndQueryCounter;


-(void)insertFeedbackData:(NSDictionary*)dic;
-(void)insertQueryData:(NSDictionary*)dic;
-(void)updateData:(NSString*)data;

-(void)getDetailMessagesofFeedbackOrQuery:(int)feedType :(NSString*)SONumber;
-(void)validateUserFromLocalDatabase:(NSString*)usernameString :(NSString*)passwordString;
-(void)setDatabaseToCompressAndShowTotalQueryOrFeedback:(NSString*)feedbackType;


//-------new methods--------//
-(void)insertCompanyRelatedFeedbackTypeAndUsers:(NSDictionary*)companyRelatedFeedbackAndUsersDict;
-(void)insertFeedQueryCounter:(NSDictionary*)dic;
-(NSMutableArray*)findPermittedCompaniesForUsername:(NSString*)usernameString Password:(NSString*)passwordString;
-(void)getFeedbackAndQueryCounterForCompany:(NSString*)companyName;
-(User*)getUserUsername:(NSString*)username andPassword:(NSString*)pass;
-(NSString*)getCompanyIdFromCompanyName:(NSString*)CompanyId;
-(void)insertLatestRecordsForFeedcom:(NSDictionary*)dic;
-(void)insertLatestRecordsForMOM:(NSDictionary*)dic;
-(NSString*)getUserNameFromCompanyname:(NSString*)username;
-(NSString*)getCompanyId:(NSString*)username;
-(NSString*)getUserIdFromUserNameWithRoll1:(NSString*)username;
-(NSString*)getUserIdFromUserName:(NSString*)username;
-(NSString*)getUserNameFromUserId:(int)userId;
-(NSMutableArray*)getMaxFeedIdAndCounter:(NSString*)soNumber :(int)feedtype;
-(NSMutableArray*)getFeedTypeIdAndMaxCounter:(NSString*)feedbackType;
-(long)getFeedbackCounterFromSONumberAndFeedbackType:(NSString*)sonumber :(int)feedtype;
-(void)insertUpdatedRecordsForFeedcom:(NSDictionary*)recordDict;
-(void)insertUpdatedRecordsForQueryCom:(NSDictionary*)recordDict;
-(void)insertNewFeedback:(NSDictionary*)responseDict;
-(void)insertNewQuery:(NSDictionary*)responseDict;
-(void)insertNewMOM:(NSDictionary*)responseDict;

-(void)insertReportData:(NSDictionary *)notificationData;
-(void)insertDocumentsData:(NSDictionary *)notificationData;

-(void)insertUserReply:(Feedback*)feedObj;
-(void)setMOMView;
-(void)setReportView;
-(void)setDocumentView;
//-(NSMutableArray*)uniqueUserIdArray;

@end
