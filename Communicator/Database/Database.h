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
//-(NSMutableArray*)findCount:(NSDictionary*)dic :(NSString*)username :(NSString*)password;
-(void)findCount:(NSDictionary*)dic :(NSString*)username :(NSString*)password;

-(void)setDatabaseToCompressAndShowTotalQueryOrFeedback:(long)a;
-(void)getDetailMessagesofFeedbackOrQuery:(int)feedType :(NSString*)SONumber;
-(void)validateUserFromLocalDatabase:(NSString*)usernameString :(NSString*)passwordString;
//-(NSMutableArray*)uniqueUserIdArray;

@end
