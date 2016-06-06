//
//  Database.m
//  DbExample
//
//  Created by mac on 08/02/16.
//  Copyright © 2016 mac. All rights reserved.
//

#import "Database.h"
#import "FeedQueryCounter.h"
#import "Feedback.h"
#import "Company.h"
#import "userRoll.h"
#import "Operator.h"
#import "Status.h"
#import "FeedbackType.h"
#import "Query.h"
#import "FeedOrQueryMessageHeader.h"
#import "FeedbackChatingCounter.h"
#import "QueryChatingCounter.h"
#import "AppPreferences.h"
#import "CompanyFeedbackTypeAssociation.h"
#import "CompanyRelatedFeedQueryCounter.h"
static Database *db;
@implementation Database
@synthesize getFeedbackAndQueryMessages;
@synthesize feedbackAndQueryTypeArray;
@synthesize SONoArray;
@synthesize DuplicateSONoArray;
@synthesize getFeedbackAndQueryCounter;
+(Database *)shareddatabase
{
    if(!db)
    {
        db=[[Database alloc]init];
        return db;
    }
    else
    {
        return db;
    }
}

-(id)init
{
    if (!db)
    {
        db=[super init];
        
    }
    else
    {
        @throw [NSException exceptionWithName:@"invalid method called" reason:@"use shareddatabase method" userInfo:NULL];
    }
    return db;
}

-(NSString *)getDatabasePath
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Communicator_DB.sqlite"];
}


- (NSMutableArray *)getFeedbackAndQueryTypes
{
    NSMutableArray* feedbackAndQueryTypesArray=[[NSMutableArray alloc]init];
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement;
    sqlite3* feedbackAndQueryTypesDB;
    NSString *query=@"SELECT * FROM feedbacktype";
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
    {
        if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query UTF8String], -1, &statement, NULL)==SQLITE_OK)
        {
            while (sqlite3_step(statement)==SQLITE_ROW)
            {
                FeedbackType *fb=[[FeedbackType alloc]init];
                fb.Id =sqlite3_column_int(statement, 0);
                fb.feedbacktype= [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                //fb.salary=sqlite3_column_int(statement, 2);
                [feedbackAndQueryTypesArray addObject:fb];
            }
        }
        else
        {
            
        }
    }
    else
    {
        NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    return feedbackAndQueryTypesArray;
}

int i=3;

-(void)insertCompanyRelatedFeedbackTypeAndUsers:(NSDictionary*)companyRelatedFeedbackAndUsersDict
{
    NSError* error;
    NSString* companyFeedbackTypeAsscociationString=[companyRelatedFeedbackAndUsersDict valueForKey:@"companyFeedBackTypeAssociation"];
    NSData *companyFeedbackTypeAsscociationData = [companyFeedbackTypeAsscociationString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSArray *companyFeedbackTypeAsscociationValue = [NSJSONSerialization JSONObjectWithData:companyFeedbackTypeAsscociationData
                                                             options:NSJSONReadingAllowFragments
                                                               error:&error];
    
    NSString* userListString=[companyRelatedFeedbackAndUsersDict valueForKey:@"userList"];
    NSData *userListData = [userListString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSArray *userListValue = [NSJSONSerialization JSONObjectWithData:userListData
                                                                                    options:NSJSONReadingAllowFragments
                                                                                      error:&error];

    
    for(NSDictionary* companyFeedbackTypeAsscociationDict in companyFeedbackTypeAsscociationValue)
    {
        CompanyFeedbackTypeAssociation* assoObj=[[CompanyFeedbackTypeAssociation alloc]init];
        FeedbackType* feedTypeObj=[[FeedbackType alloc]init];
        Company* companyObj=[[Company alloc]init];
        
        //--------Company and related feedback types---------//
        
        assoObj.Id=[[companyFeedbackTypeAsscociationDict valueForKey:@"id"]intValue];//for CompanyFeedbackTypeAssociation dependancy
        NSDictionary* feedbacktypeDict=[companyFeedbackTypeAsscociationDict valueForKey:@"feedBackType"];
        assoObj.feedbackTypeId= [[feedbacktypeDict valueForKey:@"id"]intValue];//for CompanyFeedbackTypeAssociation dependancy
        
        feedTypeObj.Id=[[feedbacktypeDict valueForKey:@"id"]intValue];
        feedTypeObj.feedbacktype=[feedbacktypeDict valueForKey:@"feedbackType"];
        
        NSLog(@"%d%@",feedTypeObj.Id,feedTypeObj.feedbacktype);
    
        NSDictionary* companyDict=[companyFeedbackTypeAsscociationDict valueForKey:@"company"];
        assoObj.companyId=[[companyDict valueForKey:@"companyId"]intValue];//for CompanyFeedbackTypeAssociation dependancy

        companyObj.ComanyId=[[companyDict valueForKey:@"companyId"]intValue];
        companyObj.Company_Name=[companyDict valueForKey:@"companyName"];
        companyObj.Company_Address=[companyDict valueForKey:@"companyAddress"];
        companyObj.Company_Contact=[companyDict valueForKey:@"companyContact"];
        companyObj.Company_Email=[companyDict valueForKey:@"companyEmail"];
        NSLog(@"%@",companyObj.Company_Email);
        
        //-------Company and related users with coreflex users-------//
        
       [[companyFeedbackTypeAsscociationDict valueForKey:@"userList"]intValue];
        
        
        Database *db=[Database shareddatabase];
        NSString *dbPath=[db getDatabasePath];
        sqlite3_stmt *statement;
        sqlite3* feedbackAndQueryTypesDB;
        /// NSString* q2=[NSString stringWithFormat:@"Drop table userpermission"];
        //  NSString* q3=[NSString stringWithFormat:@"INSERT INTO operator values(\"%d\",\"%@\",\"%@\",\"%@\",\"%@\")",NULL,fdate,feedbackText,soNumber,attachment];
        NSString* q4=[NSString stringWithFormat:@"Delete from user where ID<26"];
        //  NSString* q5=[NSString stringWithFormat:@"ALTER TABLE query1 RENAME TO query"];
        //  NSString* q7=[NSString stringWithFormat:@"CREATE TABLE userpermission (ID INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL , CompanyId INTEGER, USER_ID INTEGER,FOREIGN KEY (CompanyId) REFERENCES company(CompanyId) ,FOREIGN KEY (USER_ID) REFERENCES user(ID))"];
        
        /* Data insertion: feedback table */
        
        NSMutableArray* uniqueCompanyIdArray=[self checkCompanyAvailableOrNot];
        NSMutableArray* UniqueFeedbackTypeIdArray=[self checkFeedbackTypeIDAvailableOrNot];
        NSMutableArray* UniqueFeedCompanyAssoArray=[self checkCompanyFeedIdAssoAvailableOrNot];

        if (!([uniqueCompanyIdArray containsObject:[NSString stringWithFormat:@"%d",companyObj.ComanyId]]))
        {
            
            NSString *query3=[NSString stringWithFormat:@"INSERT INTO company values(\"%d\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",companyObj.ComanyId,companyObj.Company_Name,companyObj.Company_Address,companyObj.Company_Contact,companyObj.Company_Email,@""];
            
            const char * queryi3=[query3 UTF8String];
            if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
            {
                sqlite3_prepare_v2(feedbackAndQueryTypesDB, queryi3, -1, &statement, NULL);
                if(sqlite3_step(statement)==SQLITE_DONE)
                {
                    NSLog(@"company table data inserted");
                    NSLog(@"%@",NSHomeDirectory());
                    sqlite3_reset(statement);
                }
                else
                {
                    NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                }
            }
            else
            {
                NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
            }
        }
        
        if (!([UniqueFeedbackTypeIdArray containsObject:[NSString stringWithFormat:@"%d",feedTypeObj.Id]]))
        {
            
            NSString *query3=[NSString stringWithFormat:@"INSERT INTO feedbacktype values(\"%d\",\"%@\")",feedTypeObj.Id,feedTypeObj.feedbacktype];
            
            const char * queryi3=[query3 UTF8String];
            if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
            {
                sqlite3_prepare_v2(feedbackAndQueryTypesDB, queryi3, -1, &statement, NULL);
                if(sqlite3_step(statement)==SQLITE_DONE)
                {
                    NSLog(@"feedbackType table data inserted");
                    NSLog(@"%@",NSHomeDirectory());
                    sqlite3_reset(statement);
                }
                else
                {
                    NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                }
            }
            else
            {
                NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
            }
        }
        

        if (!([UniqueFeedCompanyAssoArray containsObject:[NSString stringWithFormat:@"%d",assoObj.Id]]))
        {
            
            NSString *query3=[NSString stringWithFormat:@"INSERT INTO CompanyFeedbackTypeAssociation values(\"%d\",\"%d\",\"%d\")",assoObj.Id,assoObj.feedbackTypeId,assoObj.companyId];
            
            const char * queryi3=[query3 UTF8String];
            if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
            {
                sqlite3_prepare_v2(feedbackAndQueryTypesDB, queryi3, -1, &statement, NULL);
                if(sqlite3_step(statement)==SQLITE_DONE)
                {
                    NSLog(@"CompanyFeedbackTypeAssociation table data inserted");
                    NSLog(@"%@",NSHomeDirectory());
                    sqlite3_reset(statement);
                }
                else
                {
                    NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                }
            }
            else
            {
                NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
            }
        }

        
//        const char * queryi1=[q4 UTF8String];
//        if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
//        {
//            sqlite3_prepare_v2(feedbackAndQueryTypesDB, queryi1, -1, &statement, NULL);
//            if(sqlite3_step(statement)==SQLITE_DONE)
//            {
//                NSLog(@"feedback table data inserted");
//                NSLog(@"%@",NSHomeDirectory());
//                sqlite3_reset(statement);
//            }
//            else
//            {
//                NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//            }
//        }
//        else
//        {
//            NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//        }
//        


    }
    
    
    for (NSDictionary* userListDict in userListValue)
    {
       User *userobj=[[User alloc]init];
        userRoll *userRollObj=[[userRoll alloc]init];
        Company *companyObj=[[Company alloc]init];
       userobj.Id= [[userListDict valueForKey:@"userId"]intValue];
       userobj.username= [userListDict valueForKey:@"userName"];
       userobj.password= [userListDict valueForKey:@"password"];
       NSDictionary* userRollDict= [userListDict valueForKey:@"userRoll"];
          userRollObj.Id=[[userRollDict valueForKey:@"id"]intValue];//user depedancy on userRollObj.Id
          userRollObj.role=[userRollDict valueForKey:@"role"];
       NSDictionary* companyDict=[userListDict valueForKey:@"company"];
          companyObj.ComanyId=[[companyDict valueForKey:@"companyId"]intValue];
          companyObj.Company_Name=[companyDict valueForKey:@"companyName"];
          companyObj.Company_Address=[companyDict valueForKey:@"companyAddress"];
          companyObj.Company_Contact=[companyDict valueForKey:@"companyContact"];
          companyObj.Company_Email=[companyDict valueForKey:@"companyEmail"];
       userobj.email= [userListDict valueForKey:@"email"];
       userobj.mobileNo= [userListDict valueForKey:@"mobileNo"];
       userobj.firstName=[userListDict valueForKey:@"firstName"];
       userobj.lastName=[userListDict valueForKey:@"lastName"];
       userobj.deviceToken=[userListDict valueForKey:@"deviceToken"];
       NSDictionary* userPermissionDict= [userListDict valueForKey:@"userPermission"];


        Database *db=[Database shareddatabase];
        NSString *dbPath=[db getDatabasePath];
        sqlite3_stmt *statement;
        sqlite3* feedbackAndQueryTypesDB;
        
        NSMutableArray* uniqueCompanyIdArray=[self checkCompanyAvailableOrNot];
        NSMutableArray* uniqueUserIdArray=[self checkUserAvailableOrNot];
        
        if (!([uniqueCompanyIdArray containsObject:[NSString stringWithFormat:@"%d",companyObj.ComanyId]]))
        {
            
            NSString *query3=[NSString stringWithFormat:@"INSERT INTO company values(\"%d\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",companyObj.ComanyId,companyObj.Company_Name,companyObj.Company_Address,companyObj.Company_Contact,companyObj.Company_Email,@""];
            
            const char * queryi3=[query3 UTF8String];
            if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
            {
                sqlite3_prepare_v2(feedbackAndQueryTypesDB, queryi3, -1, &statement, NULL);
                if(sqlite3_step(statement)==SQLITE_DONE)
                {
                    NSLog(@"company table data inserted");
                    NSLog(@"%@",NSHomeDirectory());
                    sqlite3_reset(statement);
                }
                else
                {
                    NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                }
            }
            else
            {
                NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
            }
        }
        
        
        if (!([uniqueUserIdArray containsObject:[NSString stringWithFormat:@"%d",userobj.Id]]))
        {
            
            NSString *query2=[NSString stringWithFormat:@"INSERT INTO user values(\"%d\",\"%@\",\"%@\",\"%d\",\"%d\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",userobj.Id,userobj.password,userobj.username,userRollObj.Id,companyObj.ComanyId,userobj.email,userobj.mobileNo,userobj.firstName,userobj.lastName,userobj.deviceToken];
            
            const char * queryi2=[query2 UTF8String];
            if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
            {
                sqlite3_prepare_v2(feedbackAndQueryTypesDB, queryi2, -1, &statement, NULL);
                if(sqlite3_step(statement)==SQLITE_DONE)
                {
                    NSLog(@"user table data inserted");
                    NSLog(@"%@",NSHomeDirectory());
                    sqlite3_reset(statement);
                }
                else
                {
                    NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                }
            }
            else
            {
                NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
            }
        }
    }
}



-(void)insertFeedQueryCounter:(NSDictionary*)companyWithFeedQueryCounters
{
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement = NULL,*statement1=NULL;
    sqlite3* feedbackAndQueryTypesDB;
    NSError* error;
    NSString* feedcomCommunicationCounterString=[companyWithFeedQueryCounters valueForKey:@"feedcomCommunicationCounter"];
    NSData *feedcomCommunicationCounterData = [feedcomCommunicationCounterString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *feedcomCommunicationCounterValue = [NSJSONSerialization JSONObjectWithData:feedcomCommunicationCounterData
                                                                                     options:NSJSONReadingAllowFragments
                                                                                       error:&error];
    
    
    NSString* querycomCommunicationCounterString=[companyWithFeedQueryCounters valueForKey:@"querycomCommunicationCounter"];
    NSData *querycomCommunicationCounterData = [querycomCommunicationCounterString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *querycomCommunicationCounterValue = [NSJSONSerialization JSONObjectWithData:querycomCommunicationCounterData
                                                                                      options:NSJSONReadingAllowFragments
                                                                                        error:&error];
    //NSArray* arr1=[[NSArray alloc]init];
    int j=1;
    NSMutableDictionary* queryTypeCounterBufferDict=[[NSMutableDictionary alloc]init];
    
    //---------for loop for getting query counters from web service insert-> company id as a key with their respective feedtype and counters into dictionary queryTypeCounterBufferDict for future inertion for counters into db-------
    
    
    
    for(NSString* companyObjectString in [querycomCommunicationCounterValue allKeys])
    {
        NSMutableArray* queryCounterBufferArray=[[NSMutableArray alloc]init];
        
        NSData *companyObjectdata = [companyObjectString dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *companyDict = [NSJSONSerialization JSONObjectWithData:companyObjectdata
                                                                    options:NSJSONReadingAllowFragments
                                                                      error:&error];
        
        NSLog(@"%@",companyDict);
        int companyID=[[companyDict valueForKey:@"companyId"]intValue];
        NSLog(@"%d",companyID);

        
        NSArray*  feedbackTypesAndCountersArray=  [querycomCommunicationCounterValue valueForKey:companyObjectString];//get array of feedtypes with respective counts for company=#companyObjectString from main dict @"querycomCommunicationCounter"
        for (int i=0; i<feedbackTypesAndCountersArray.count; i++)
        {
            //[feedbackTypesAndCountersArray objectAtIndex:i];
            NSDictionary* feedTypeAndCountDic=  [feedbackTypesAndCountersArray objectAtIndex:i];
            int count = [[feedTypeAndCountDic valueForKey:@"count"]intValue];
            [queryCounterBufferArray addObject:[NSString stringWithFormat:@"%d",count]];
        }
        //queryTypeCounterBufferDict=[NSMutableDictionary dictionaryWithObject:queryCounterBufferArray forKey:[NSString stringWithFormat:@"%d",j]];
        [queryTypeCounterBufferDict setObject:queryCounterBufferArray forKey:[NSString stringWithFormat:@"%d",companyID]];
    }
    //  NSLog(@"%ld",queryCounterBufferArray.count);
    
    //--------------------------------
    
    
    
    //----------------for loop for insertion or updation of feed or query counters------------
    BOOL CompanyFeedTypeAndCounterTableEmpty=YES;

    //--------******fetch all keys of feedcomCommunicationCounterValue in companyObjectString******--------//
    
    for(NSString* companyObjectString in [feedcomCommunicationCounterValue allKeys])
    {
        
        NSData *companyObjectdata = [companyObjectString dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *companyDict = [NSJSONSerialization JSONObjectWithData:companyObjectdata
                                                                    options:NSJSONReadingAllowFragments
                                                                      error:&error];
        
        NSLog(@"%@",companyDict);
        int companyID=[[companyDict valueForKey:@"companyId"]intValue];
        NSLog(@"%d",companyID);
        
        NSArray*  feedbackTypesAndCountersArray=  [feedcomCommunicationCounterValue valueForKey:companyObjectString];  //will get array of feedtype with counters for one company
        NSArray* queryCounterForCompanyArray=[queryTypeCounterBufferDict valueForKey:[NSString stringWithFormat:@"%d",companyID]];//will get querycounter from queryTypeCounterBufferDict from particuler company(companyID)

        for (int i=0; i<feedbackTypesAndCountersArray.count; i++)
        {
            CompanyRelatedFeedQueryCounter* obj=[[CompanyRelatedFeedQueryCounter alloc]init];
            obj.companyId=[[companyDict valueForKey:@"companyId"]intValue];

            NSDictionary* feedTypeAndCountDic=  [feedbackTypesAndCountersArray objectAtIndex:i];
            obj.feedCounter = [[feedTypeAndCountDic valueForKey:@"count"]intValue];
            NSDictionary* feedbackTypeDict=[feedTypeAndCountDic valueForKey:@"feedBackTypeTable"];
            obj.feedTypeId= [[feedbackTypeDict valueForKey:@"id"]intValue];
            NSLog(@"%@",[queryCounterForCompanyArray objectAtIndex:i]);
            obj.queryCounter=[[NSString stringWithFormat:@"%@",[queryCounterForCompanyArray objectAtIndex:i]]intValue];
            
            NSLog(@"j=%d company id=%d,id=%d,feedCount=%d,queryCount=%d ",j,obj.companyId,obj.feedTypeId,obj.feedCounter,obj.queryCounter);

            
            //----------update CompanyFeedTypeAndCounter table if updated feed counter comes--------//
            
//            NSString * query = [NSString stringWithFormat:@"SELECT feedCounter,queryCounter FROM CompanyFeedTypeAndCounter Where companyId=%d and feedbackTypeId=%d",obj.companyId,obj.feedTypeId];
//            
//            if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB) == SQLITE_OK)// 1. Open The DataBase.
//            {
//                if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query UTF8String], -1, &statement, NULL) == SQLITE_OK)// 2. Prepare the query
//                {
//                    while (sqlite3_step(statement) == SQLITE_ROW)
//                    {
//                      int feedCounterRoValue=  [[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement,0)]intValue];
//                      int queryCounterRoValue=  [[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 1)]intValue];
//                        CompanyFeedTypeAndCounterTableEmpty=NO;
//                       // NSString* str=[NSString stringWithFormat:@"%d",obj.feedCounter];
//                       
//                        //------fetch feedCounterRoValue and queryCounterRoValue, and check it is equal to web service counters,if not equal then update
//                        
//                        if (feedCounterRoValue!=obj.feedCounter || queryCounterRoValue!=obj.queryCounter)
//                        {
//                            NSLog(@"feedcounter=%d queryCounter=%d",feedCounterRoValue,queryCounterRoValue);
//                            NSString* updateQueryForCounters=[NSString stringWithFormat:@"Update CompanyFeedTypeAndCounter set feedCounter=%d,queryCounter=%d Where companyId=%d and feedbackTypeId=%d",obj.feedCounter,obj.queryCounter,obj.companyId,obj.feedTypeId];
//                            const char * updateQueryForCountersUTFString=[updateQueryForCounters UTF8String];
//
//                            sqlite3_prepare_v2(feedbackAndQueryTypesDB,updateQueryForCountersUTFString, -1, &statement1, NULL);
//                            if(sqlite3_step(statement1)==SQLITE_DONE)
//                            {
//                                NSLog(@"Table updated");
//                                NSLog(@"%@",NSHomeDirectory());
//                                sqlite3_reset(statement1);
//                            }
//                            else
//                            {
//                                NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//                            }
//
//                            NSLog(@"suce");
//                        }
//
//                    }
//                }
//                else
//                {
//                    NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//                }
//            }
//            else
//            {
//                NSLog(@"can't open db due error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//            }
//            
//            if (sqlite3_finalize(statement) == SQLITE_OK)
//            {
//                NSLog(@"statement is finalized");
//            }
//            else
//                NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//            
//            
//            
            
            
            
     //-------if table data is empty CompanyFeedTypeAndCounterTableEmpty flag will remain true and data will be inserted--------//
            
            if (CompanyFeedTypeAndCounterTableEmpty)
            {
                
            NSString *query1=[NSString stringWithFormat:@"INSERT INTO CompanyFeedTypeAndCounter values(\"%d\",\"%d\",\"%d\",\"%d\",\"%d\")",j,obj.companyId,obj.feedTypeId,obj.feedCounter,obj.queryCounter];
            
            const char * queryi1=[query1 UTF8String];
            if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
            {
                sqlite3_prepare_v2(feedbackAndQueryTypesDB, queryi1, -1, &statement, NULL);
                if(sqlite3_step(statement)==SQLITE_DONE)
                {
                    NSLog(@"CompanyFeedTypeAndCounter table data inserted");
                    NSLog(@"%@",NSHomeDirectory());
                    sqlite3_reset(statement);
                }
                else
                {
                    NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                }
            }
            else
            {
                NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
            }
                
            }

            j++;

        }
        
        NSLog(@"%@",feedbackTypesAndCountersArray);
        
    }
}



-(NSMutableArray*)findPermittedCompaniesForUsername:(NSString*)usernameString Password:(NSString*)passwordString;
{
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement = NULL,*statement1=NULL,*statement2=NULL;
    sqlite3* feedbackAndQueryTypesDB;
    NSError* error;
    NSMutableArray* companyNameOrIdArray=[[NSMutableArray alloc]init];

    
NSString * query = [NSString stringWithFormat:@"SELECT CompanyId FROM user Where USER_NAME='%@' and PASSWORD='%@'",usernameString,passwordString];
    
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB) == SQLITE_OK)// 1. Open The DataBase.
    {
        NSLog(@"%@",[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Communicator_DB.sqlite"]);
        if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query UTF8String], -1, &statement, NULL) == SQLITE_OK)// 2. Prepare the query
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                 const char * userId = (const char*)sqlite3_column_text(statement, 0);
                 NSString* companyId=[NSString stringWithUTF8String:userId];
                
                 if ([companyId isEqual:@"1"])
                 {
                    NSLog(@"%@",companyId);
                    
                    NSString * query1 = @"SELECT Company_Name FROM company Where CompanyId!=1";

                    
                    if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query1 UTF8String], -1, &statement1, NULL) == SQLITE_OK)// 2. Prepare the query
                    {
                        while (sqlite3_step(statement1) == SQLITE_ROW)
                        {
                            const char * companyNameUTF = (const char*)sqlite3_column_text(statement1, 0);
                            NSString* companyName=[NSString stringWithUTF8String:companyNameUTF];
                            [companyNameOrIdArray addObject:companyName];
                            
                        }
                    }
                    else
                    {
                        NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                    }

                 }
                
                
                else
                {
                    NSString * query2 = [NSString stringWithFormat:@"SELECT Company_Name FROM company Where CompanyId==%@",companyId];
                    
                    
                    if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query2 UTF8String], -1, &statement2, NULL) == SQLITE_OK)// 2. Prepare the query
                    {
                        while (sqlite3_step(statement2) == SQLITE_ROW)
                        {
                            const char * companyNameUTF = (const char*)sqlite3_column_text(statement2, 0);
                            NSString* companyName=[NSString stringWithUTF8String:companyNameUTF];
                            [companyNameOrIdArray addObject:companyName];
                            
                        }
                    }
                    else
                    {
                        NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                    }
                    


                
                }
                
            }
        }
        else
        {
            NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
    }
    else
    {
        NSLog(@"can't open db due error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    if (sqlite3_finalize(statement) == SQLITE_OK)
    {
        NSLog(@"statement is finalized");
    }
    else
        NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    


    return companyNameOrIdArray;


}



-(void)getFeedbackAndQueryCounterForCompany:(NSString*)companyName;
{

    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement = NULL,*statement1=NULL,*statement2=NULL;
    sqlite3* feedbackAndQueryTypesDB;
    NSError* error;
    AppPreferences* app=[AppPreferences sharedAppPreferences];
    app.feedTypeWithFeedCounterDict=[[NSMutableDictionary alloc]init];
    app.feedTypeWithQueryCounterDict=[[NSMutableDictionary alloc]init];
    app.feedQueryCounterDictsWithTypeArray=[[NSMutableArray alloc]init];
    
    NSString * query = [NSString stringWithFormat:@"SELECT feedbackTypeId,feedCounter,queryCounter FROM CompanyFeedTypeAndCounter Where companyId=(Select CompanyId from company Where Company_Name='%@')",companyName];
    NSLog(@"%@",companyName);
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB) == SQLITE_OK)// 1. Open The DataBase.
    {
        if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query UTF8String], -1, &statement, NULL) == SQLITE_OK)// 2. Prepare the query
        {
            BOOL row=NO;
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                row=YES;
                const char * feedbackTypeIdUTF = (const char*)sqlite3_column_text(statement, 0);
                NSString* feedbackTypeId=[NSString stringWithUTF8String:feedbackTypeIdUTF];
                
                const char * feedCounterUTF = (const char*)sqlite3_column_text(statement, 1);
                int feedCounter=[[NSString stringWithUTF8String:feedCounterUTF]intValue];
                
                const char * queryCounterUTF = (const char*)sqlite3_column_text(statement, 2);
                int queryCounter=[[NSString stringWithUTF8String:queryCounterUTF]intValue];

                NSLog(@"%@,%@,%d,%d",companyName,feedbackTypeId,feedCounter,queryCounter);
                
                int feedbackTypeIdInt=[[NSString stringWithUTF8String:feedbackTypeIdUTF]intValue];
                NSString * query1 = [NSString stringWithFormat:@"SELECT Feedback_Type FROM feedbacktype Where ID=%d",feedbackTypeIdInt];

                
                if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query1 UTF8String], -1, &statement1, NULL) == SQLITE_OK)// 2. Prepare the query
                {
                    while (sqlite3_step(statement1) == SQLITE_ROW)
                    {
                        FeedQueryCounter* obj=[[FeedQueryCounter alloc]init];
                        const char * feedbackTypeUTF = (const char*)sqlite3_column_text(statement1, 0);
                        NSString* feedbackType=[NSString stringWithUTF8String:feedbackTypeUTF];
                        NSLog(@"%@",feedbackType);
                        obj.feedbackType=feedbackType;
                        obj.feedCounter=feedCounter;
                        obj.queryCounter=queryCounter;
                        [app.feedQueryCounterDictsWithTypeArray addObject:obj];
                       // [app.feedTypeWithFeedCounterDict setObject:feedCounter forKey:feedbackTypeIdstr];
                        //[app.feedTypeWithQueryCounterDict setObject:queryCounter forKey:feedbackTypeIdstr];

                        //[uniqueUserIdArray addObject:[NSString stringWithUTF8String:userId]];
                    }
                }
                else
                {
                    NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                }

                
                
                
//                [uniqueUserIdArray addObject:[NSString stringWithUTF8String:userId]];
            }
            
            
            
        }
        else
        {
            NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
    }
    else
    {
        NSLog(@"can't open db due error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    if (sqlite3_finalize(statement) == SQLITE_OK)
    {
        NSLog(@"statement is finalized");
    }
    else
        NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    

   // [app.feedQueryCounterDictsWithTypeArray addObject:app.feedTypeWithFeedCounterDict];
    //[app.feedQueryCounterDictsWithTypeArray addObject:app.feedTypeWithQueryCounterDict];
    NSLog(@"%ld",app.feedQueryCounterDictsWithTypeArray.count);
    //NSLog(@"%ld,%ld,%ld",[app.feedTypeWithFeedCounterDict count],[app.feedTypeWithQueryCounterDict count],app.feedQueryCounterDictsWithTypeArray.count);


}














-(void)insertFeedbackData:(NSDictionary*)dic
{
    //NSLog(@"%@",dic);
    NSLog(@"in insertttttttttt data");
    NSError* error;
    NSString* feedbackString=[dic valueForKey:@"ListOfFeedBack"];
    NSData *feedbackData = [feedbackString dataUsingEncoding:NSUTF8StringEncoding];

    NSArray *feedbackValue = [NSJSONSerialization JSONObjectWithData:feedbackData
                                                             options:NSJSONReadingAllowFragments
                                                               error:&error];
  // NSLog(@"%@",[feedbackValue objectAtIndex:4]);
    //NSDictionary* d1;
    
   for(NSDictionary* d1 in feedbackValue)
   {
    NSLog(@"%@",NSHomeDirectory());
       
    //-------------------------feedback table data insertion------------------------------------------
   
    Feedback *feedback=[[Feedback alloc]init];

    feedback.feedbackId=[[d1 valueForKey:@"feedbackId"]intValue];
    feedback.feedbackText=[d1 valueForKey:@"feedbackText"];
        
    feedback.dateOfFeed=[d1 valueForKey:@"fdate"];
    
    NSDictionary* feedBackType=[d1 valueForKey:@"feedBackType"];
    feedback.feedbackType=[[feedBackType valueForKey:@"id"]intValue];
    
    feedback.soNumber=[d1 valueForKey:@"soNumber"];

    NSDictionary* counter=[d1 valueForKey:@"counter"];
    feedback.feedbackCounter=[[counter valueForKey:@"feedbackCounter"]longValue];;
    
    NSDictionary* operator=[d1 valueForKey:@"operator"];
    feedback.operatorId=[[operator valueForKey:@"operatorId"]intValue];
    
    NSDictionary* status=[d1 valueForKey:@"status"];
    feedback.statusId=[[status valueForKey:@"statusId"]intValue];
    
    NSDictionary* userModelFrom=[d1 valueForKey:@"userModelFrom"];
    feedback.userFrom=[[userModelFrom valueForKey:@"userId"]intValue];

    NSDictionary* userModelTo=[d1 valueForKey:@"userModelTo"];
    feedback.userTo=[[userModelTo valueForKey:@"userId"]intValue];
       
       NSLog(@"%d%d",feedback.userFrom,feedback.userTo);
   
    NSDictionary* userfeedback=[d1 valueForKey:@"userfeedback"];
    feedback.userFeedback=[[userfeedback valueForKey:@"userId"]intValue];

    feedback.attachment=[d1 valueForKey:@"attachment"];
    
    feedback.emailSubject=[d1 valueForKey:@"emailSubject"];
       
       NSLog(@"%@",feedback.emailSubject);
       
 //-------------------------user table data insertion values------------------------------------------
     
    User *user=[[User alloc]init];
    Company *company=[[Company alloc]init];
    user.username=[userModelFrom valueForKey:@"userName"];
    user.password=[userModelFrom valueForKey:@"password"];
       NSLog(@"%@",user.username);
       
    NSDictionary* userRole=[userModelFrom valueForKey:@"userRoll"];
    user.userRole=[[userRole valueForKey:@"id"]intValue];
       
    NSDictionary* companyOb=[userModelFrom valueForKey:@"company"];
    user.comanyId=[[companyOb valueForKey:@"companyId"]intValue];
    
    user.email=[userModelFrom valueForKey:@"email"];
    user.mobileNo=[userModelFrom valueForKey:@"mobileNo"];
    user.firstName=[userModelFrom valueForKey:@"firstName"];
    user.lastName=[userModelFrom valueForKey:@"lastName"];
       
    //--------------------------userRole table data values-----------------------------------------------
       
    userRoll *userroll=[[userRoll alloc]init];
    userroll.role=[userRole valueForKey:@"id"];
       
    //--------------------------company table data values------------------------------------------------
       
    company.Company_Name=[companyOb valueForKey:@"companyName"];
    company.Company_Contact=[companyOb valueForKey:@"companyContact"];
    company.Company_Address=[companyOb valueForKey:@"companyAddress"];
    company.Company_Email=[companyOb valueForKey:@"companyEmail"];
    //company.userId=[[companyOb valueForKey:@"userID"]intValue];
       
       
       
    //-------------------------user table data insertion values from userTo------------------------------------------
       
    User *user1=[[User alloc]init];
    Company *company1=[[Company alloc]init];
    user1.username=[userModelTo valueForKey:@"userName"];
    user1.password=[userModelTo valueForKey:@"password"];
       
    NSDictionary* userRole1=[userModelTo valueForKey:@"userRoll"];
    user1.userRole=[[userRole1 valueForKey:@"id"]intValue];
       
    NSDictionary* companyOb1=[userModelTo valueForKey:@"company"];
    user1.comanyId=[[companyOb1 valueForKey:@"companyId"]intValue];
       
    user1.email=[userModelTo valueForKey:@"email"];
    user1.mobileNo=[userModelTo valueForKey:@"mobileNo"];
    user1.firstName=[userModelTo valueForKey:@"firstName"];
    user1.lastName=[userModelTo valueForKey:@"lastName"];
       
       //--------------------------userRole table data values-----------------------------------------------
       
       userRoll *userroll1=[[userRoll alloc]init];
       userroll1.role=[userRole1 valueForKey:@"id"];
       
       //--------------------------company table data values------------------------------------------------
       
       company1.Company_Name=[companyOb1 valueForKey:@"companyName"];
       company1.Company_Contact=[companyOb1 valueForKey:@"companyContact"];
       company1.Company_Address=[companyOb1 valueForKey:@"companyAddress"];
       company1.Company_Email=[companyOb1 valueForKey:@"companyEmail"];
       //company1.userId=[[companyOb1 valueForKey:@"userID"]intValue];
       
       //-------------------------userRole table data values-----------------------------------------------
       
       //user.username=[userRole valueForKey:@"role"];
       //user1.username=[userRole1 valueForKey:@"role"];
       NSLog(@"%@",user.username);
       
       //-------------------------operator table data values--------------------------------------------------
       
       Operator *operatorobj =[[Operator alloc]init];
       operatorobj.firstName=[operator valueForKey:@"firstName"];
       operatorobj.lastName=[operator valueForKey:@"lastName"];
       operatorobj.userName=[operator valueForKey:@"userName"];
       operatorobj.status=[operator valueForKey:@"status"];
       
       //------------------------status table data values-------------------------------------------
       
       Status *statusobj=[[Status alloc]init];
       statusobj.status=[status valueForKey:@"status"];
       
       //------------------------feedback_type table data values--------------------------------------------
       
       FeedbackType *feedbackTypeObj=[[FeedbackType alloc]init];
       feedbackTypeObj.feedbacktype=[feedBackType valueForKey:@"feedbackType"];
       NSLog(@"%@",feedbackTypeObj.feedbacktype);
       
       
   
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement;
    sqlite3* feedbackAndQueryTypesDB;
    /// NSString* q2=[NSString stringWithFormat:@"Drop table userpermission"];
    //  NSString* q3=[NSString stringWithFormat:@"INSERT INTO operator values(\"%d\",\"%@\",\"%@\",\"%@\",\"%@\")",NULL,fdate,feedbackText,soNumber,attachment];
     NSString* q4=[NSString stringWithFormat:@"Delete from feedback where Feedback_id<61"];
    //  NSString* q5=[NSString stringWithFormat:@"ALTER TABLE query1 RENAME TO query"];
    //  NSString* q7=[NSString stringWithFormat:@"CREATE TABLE userpermission (ID INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL , CompanyId INTEGER, USER_ID INTEGER,FOREIGN KEY (CompanyId) REFERENCES company(CompanyId) ,FOREIGN KEY (USER_ID) REFERENCES user(ID))"];

   /* Data insertion: feedback table */
       
      
    NSString *query1=[NSString stringWithFormat:@"INSERT INTO feedback(Feedback_id,dateoffeed,Feedback_text,SO_Number,feedbackCounter,feedBackType,operatorId,statusId,userFrom,userTo,userFeedBack,Attachments,EmailSubject) values(\"%ld\",\"%@\",\"%@\",\"%@\",\"%ld\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%@\",\"%@\")",feedback.feedbackId,feedback.dateOfFeed,feedback.feedbackText,feedback.soNumber,feedback.feedbackCounter,feedback.feedbackType,feedback.operatorId,feedback.statusId,feedback.userFrom,feedback.userTo,feedback.userFeedback,feedback.attachment,feedback.emailSubject];
       
       const char * queryi1=[query1 UTF8String];
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
    {
        sqlite3_prepare_v2(feedbackAndQueryTypesDB, queryi1, -1, &statement, NULL);
        if(sqlite3_step(statement)==SQLITE_DONE)
        {
            NSLog(@"feedback table data inserted");
            NSLog(@"%@",NSHomeDirectory());
            sqlite3_reset(statement);
        }
        else
        {
            NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
    }
    else
    {
        NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
   
    
    /* Data insertion: user table */
       NSMutableArray* uniqueUserIdArray=[self checkUserAvailableOrNot];
       NSMutableArray* uniqueCompanyIdArray=[self checkCompanyAvailableOrNot];
       NSMutableArray* uniqueUserRoleArray=[self checkUserRoleAvailableOrNot];
       NSMutableArray* uniqueOperatorArray=[self checkOperatorAvailableOrNot];
       NSMutableArray* uniqueStatusIdArray=[self checkStatusIdAvailableOrNot];
       NSMutableArray* UniqueFeedbackTypeIdArray=[self checkFeedbackTypeIDAvailableOrNot];
       
       NSString* userid=[NSString stringWithFormat:@"%d",feedback.userFrom];
       NSString* userid1=[NSString stringWithFormat:@"%d",feedback.userTo];
       NSString* companyid=[NSString stringWithFormat:@"%d",user.comanyId];
       NSString* companyid1=[NSString stringWithFormat:@"%d",user1.comanyId];
       NSString* usersRoll=[NSString stringWithFormat:@"%d",user.userRole];
       NSString* usersRoll1=[NSString stringWithFormat:@"%d",user1.userRole];
       NSString* operatorID=[NSString stringWithFormat:@"%d",feedback.operatorId];
       NSString* statusID=[NSString stringWithFormat:@"%d",feedback.statusId];
       NSString* feedbacktypeID=[NSString stringWithFormat:@"%d",feedback.feedbackType];




       NSLog(@"%@",userid);
       NSLog(@"%lu",(unsigned long)[uniqueUserIdArray count]);
       
       if (!([uniqueUserIdArray containsObject:userid]))
       {

       NSString *query2=[NSString stringWithFormat:@"INSERT INTO user values(\"%d\",\"%@\",\"%@\",\"%d\",\"%d\",\"%@\",\"%@\",\"%@\",\"%@\")",feedback.userFrom,user.password,user.username,user.userRole,user.comanyId,user.email,user.mobileNo,user.firstName,user.lastName];
       
       const char * queryi2=[query2 UTF8String];
       if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
       {
           sqlite3_prepare_v2(feedbackAndQueryTypesDB, queryi2, -1, &statement, NULL);
           if(sqlite3_step(statement)==SQLITE_DONE)
           {
               NSLog(@"user table data inserted");
               NSLog(@"%@",NSHomeDirectory());
               sqlite3_reset(statement);
           }
           else
           {
               NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
           }
       }
       else
       {
           NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
       }
       }
       
       
       
       if (!([uniqueUserIdArray containsObject:userid1]))
       {
           
           NSString *query3=[NSString stringWithFormat:@"INSERT INTO user values(\"%d\",\"%@\",\"%@\",\"%d\",\"%d\",\"%@\",\"%@\",\"%@\",\"%@\")",feedback.userTo,user1.password,user1.username,user1.userRole,user1.comanyId,user1.email,user1.mobileNo,user1.firstName,user1.lastName];
           
           const char * queryi3=[query3 UTF8String];
           if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
           {
               sqlite3_prepare_v2(feedbackAndQueryTypesDB, queryi3, -1, &statement, NULL);
               if(sqlite3_step(statement)==SQLITE_DONE)
               {
                   NSLog(@"user table data inserted");
                   NSLog(@"%@",NSHomeDirectory());
                   sqlite3_reset(statement);
               }
               else
               {
                   NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
               }
           }
           else
           {
               NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
           }
       }
       
       
       if (!([uniqueCompanyIdArray containsObject:companyid]))
       {
           
            NSString *query3=[NSString stringWithFormat:@"INSERT INTO company values(\"%d\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",user.comanyId,company.Company_Name,company.Company_Address,company.Company_Contact,company.Company_Email,@""];
           
           const char * queryi3=[query3 UTF8String];
           if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
           {
               sqlite3_prepare_v2(feedbackAndQueryTypesDB, queryi3, -1, &statement, NULL);
               if(sqlite3_step(statement)==SQLITE_DONE)
               {
                   NSLog(@"user table data inserted");
                   NSLog(@"%@",NSHomeDirectory());
                   sqlite3_reset(statement);
               }
               else
               {
                   NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
               }
           }
           else
           {
               NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
           }
       }


       
       if (!([uniqueCompanyIdArray containsObject:companyid1]))
       {
           
           NSString *query3=[NSString stringWithFormat:@"INSERT INTO company values(\"%d\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",user1.comanyId,company1.Company_Name,company1.Company_Address,company1.Company_Contact,company1.Company_Email,@""];
           
           const char * queryi3=[query3 UTF8String];
           if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
           {
               sqlite3_prepare_v2(feedbackAndQueryTypesDB, queryi3, -1, &statement, NULL);
               if(sqlite3_step(statement)==SQLITE_DONE)
               {
                   NSLog(@"user table data inserted");
                   NSLog(@"%@",NSHomeDirectory());
                   sqlite3_reset(statement);
               }
               else
               {
                   NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
               }
           }
           else
           {
               NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
           }
       }
       
       
       
       
       if (!([uniqueUserRoleArray containsObject:usersRoll]))
       {
           
           NSString *query3=[NSString stringWithFormat:@"INSERT INTO roles values(\"%d\",\"%@\")",user.userRole,[userRole valueForKey:@"role"]];
           
           const char * queryi3=[query3 UTF8String];
           if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
           {
               sqlite3_prepare_v2(feedbackAndQueryTypesDB, queryi3, -1, &statement, NULL);
               if(sqlite3_step(statement)==SQLITE_DONE)
               {
                   NSLog(@"user table data inserted");
                   NSLog(@"%@",NSHomeDirectory());
                   sqlite3_reset(statement);
               }
               else
               {
                   NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
               }
           }
           else
           {
               NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
           }
       }

       
       
       if (!([uniqueUserRoleArray containsObject:usersRoll1]))
       {
           
           NSString *query3=[NSString stringWithFormat:@"INSERT INTO roles values(\"%d\",\"%@\")",user1.userRole,[userRole1 valueForKey:@"role"]];
           
           const char * queryi3=[query3 UTF8String];
           if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
           {
               sqlite3_prepare_v2(feedbackAndQueryTypesDB, queryi3, -1, &statement, NULL);
               if(sqlite3_step(statement)==SQLITE_DONE)
               {
                   NSLog(@"user table data inserted");
                   NSLog(@"%@",NSHomeDirectory());
                   sqlite3_reset(statement);
               }
               else
               {
                   NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
               }
           }
           else
           {
               NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
           }
       }


       
       if (!([uniqueOperatorArray containsObject:operatorID]))
       {
           
           NSString *query3=[NSString stringWithFormat:@"INSERT INTO operator values(\"%d\",\"%@\",\"%@\",\"%@\",\"%@\")",feedback.operatorId,operatorobj.firstName,operatorobj.lastName,operatorobj.status,operatorobj.userName];
           
           const char * queryi3=[query3 UTF8String];
           if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
           {
               sqlite3_prepare_v2(feedbackAndQueryTypesDB, queryi3, -1, &statement, NULL);
               if(sqlite3_step(statement)==SQLITE_DONE)
               {
                   NSLog(@"user table data inserted");
                   NSLog(@"%@",NSHomeDirectory());
                   sqlite3_reset(statement);
               }
               else
               {
                   NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
               }
           }
           else
           {
               NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
           }
       }

       
       if (!([uniqueStatusIdArray containsObject:statusID]))
       {
           
           NSString *query3=[NSString stringWithFormat:@"INSERT INTO status values(\"%d\",\"%@\")",feedback.statusId,statusobj.status];
           
           const char * queryi3=[query3 UTF8String];
           if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
           {
               sqlite3_prepare_v2(feedbackAndQueryTypesDB, queryi3, -1, &statement, NULL);
               if(sqlite3_step(statement)==SQLITE_DONE)
               {
                   NSLog(@"user table data inserted");
                   NSLog(@"%@",NSHomeDirectory());
                   sqlite3_reset(statement);
               }
               else
               {
                   NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
               }
           }
           else
           {
               NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
           }
       }
       
       
       if (!([UniqueFeedbackTypeIdArray containsObject:feedbacktypeID]))
       {
           
           NSString *query3=[NSString stringWithFormat:@"INSERT INTO feedbacktype values(\"%d\",\"%@\")",feedback.feedbackType,feedbackTypeObj.feedbacktype];
           
           const char * queryi3=[query3 UTF8String];
           if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
           {
               sqlite3_prepare_v2(feedbackAndQueryTypesDB, queryi3, -1, &statement, NULL);
               if(sqlite3_step(statement)==SQLITE_DONE)
               {
                   NSLog(@"user table data inserted");
                   NSLog(@"%@",NSHomeDirectory());
                   sqlite3_reset(statement);
               }
               else
               {
                   NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
               }
           }
           else
           {
               NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
           }
       }


       
       
    
   }
}










-(NSMutableArray*)checkUserAvailableOrNot
{
    
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement;
    sqlite3* feedbackAndQueryTypesDB;
    NSMutableArray* uniqueUserIdArray=[[NSMutableArray alloc]init];
    
    NSString * query = @"SELECT ID FROM user";
    
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB) == SQLITE_OK)// 1. Open The DataBase.
    {
        if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query UTF8String], -1, &statement, NULL) == SQLITE_OK)// 2. Prepare the query
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                const char * userId = (const char*)sqlite3_column_text(statement, 0);
                [uniqueUserIdArray addObject:[NSString stringWithUTF8String:userId]];
            }
        }
        else
        {
            NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
    }
    else
    {
        NSLog(@"can't open db due error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    if (sqlite3_finalize(statement) == SQLITE_OK)
    {
        NSLog(@"statement is finalized");
    }
    else
        NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    
    return uniqueUserIdArray;
    
    
}

-(NSMutableArray*)checkCompanyAvailableOrNot
{
  
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement;
    sqlite3* feedbackAndQueryTypesDB;
    NSMutableArray* uniqueUserIdArray=[[NSMutableArray alloc]init];
    
    NSString * query = @"SELECT CompanyId FROM company";
    
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB) == SQLITE_OK)// 1. Open The DataBase.
    {
        if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query UTF8String], -1, &statement, NULL) == SQLITE_OK)// 2. Prepare the query
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                const char * userId = (const char*)sqlite3_column_text(statement, 0);
                [uniqueUserIdArray addObject:[NSString stringWithUTF8String:userId]];
            }
        }
        else
        {
            NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
    }
    else
    {
        NSLog(@"can't open db due error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    if (sqlite3_finalize(statement) == SQLITE_OK)
    {
        NSLog(@"statement is finalized");
    }
    else
        NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    
    return uniqueUserIdArray;



}

-(NSMutableArray*)checkUserRoleAvailableOrNot
{
    
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement;
    sqlite3* feedbackAndQueryTypesDB;
    NSMutableArray* uniqueUserIdArray=[[NSMutableArray alloc]init];
    
    NSString * query = @"SELECT id FROM roles";
    
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB) == SQLITE_OK)// 1. Open The DataBase.
    {
        if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query UTF8String], -1, &statement, NULL) == SQLITE_OK)// 2. Prepare the query
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                const char * userId = (const char*)sqlite3_column_text(statement, 0);
                [uniqueUserIdArray addObject:[NSString stringWithUTF8String:userId]];
            }
        }
        else
        {
            NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
    }
    else
    {
        NSLog(@"can't open db due error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    if (sqlite3_finalize(statement) == SQLITE_OK)
    {
        NSLog(@"statement is finalized");
    }
    else
        NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    
    return uniqueUserIdArray;
    
    
    
}


-(NSMutableArray*)checkOperatorAvailableOrNot
{
    
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement;
    sqlite3* feedbackAndQueryTypesDB;
    NSMutableArray* uniqueUserIdArray=[[NSMutableArray alloc]init];
    
    NSString * query = @"SELECT operator_id FROM operator";
    
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB) == SQLITE_OK)// 1. Open The DataBase.
    {
        if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query UTF8String], -1, &statement, NULL) == SQLITE_OK)// 2. Prepare the query
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                const char * userId = (const char*)sqlite3_column_text(statement, 0);
                [uniqueUserIdArray addObject:[NSString stringWithUTF8String:userId]];
            }
        }
        else
        {
            NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
    }
    else
    {
        NSLog(@"can't open db due error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    if (sqlite3_finalize(statement) == SQLITE_OK)
    {
        NSLog(@"statement is finalized");
    }
    else
        NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    
    return uniqueUserIdArray;
    
    
    
}





-(NSMutableArray*)checkStatusIdAvailableOrNot
{
    
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement;
    sqlite3* feedbackAndQueryTypesDB;
    NSMutableArray* uniqueUserIdArray=[[NSMutableArray alloc]init];
    
    NSString * query = @"SELECT Status_Id FROM status";
    
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB) == SQLITE_OK)// 1. Open The DataBase.
    {
        if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query UTF8String], -1, &statement, NULL) == SQLITE_OK)// 2. Prepare the query
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                const char * userId = (const char*)sqlite3_column_text(statement, 0);
                [uniqueUserIdArray addObject:[NSString stringWithUTF8String:userId]];
            }
        }
        else
        {
            NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
    }
    else
    {
        NSLog(@"can't open db due error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    if (sqlite3_finalize(statement) == SQLITE_OK)
    {
        NSLog(@"statement is finalized");
    }
    else
        NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    
    return uniqueUserIdArray;

}


-(NSMutableArray*)checkFeedbackTypeIDAvailableOrNot
{
    
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement;
    sqlite3* feedbackAndQueryTypesDB;
    NSMutableArray* uniqueUserIdArray=[[NSMutableArray alloc]init];
    
    NSString * query = @"SELECT ID FROM feedbacktype";
    
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB) == SQLITE_OK)// 1. Open The DataBase.
    {
        if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query UTF8String], -1, &statement, NULL) == SQLITE_OK)// 2. Prepare the query
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                const char * userId = (const char*)sqlite3_column_text(statement, 0);
                [uniqueUserIdArray addObject:[NSString stringWithUTF8String:userId]];
                NSLog(@"%s",userId);
            }
        }
        else
        {
            NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
    }
    else
    {
        NSLog(@"can't open db due error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    if (sqlite3_finalize(statement) == SQLITE_OK)
    {
        NSLog(@"statement is finalized");
    }
    else
        NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    
    return uniqueUserIdArray;
    
    
    
}


-(NSMutableArray*)checkCompanyFeedIdAssoAvailableOrNot
{
    
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement;
    sqlite3* feedbackAndQueryTypesDB;
    NSMutableArray* uniqueCompanyFeedIdAssoArray=[[NSMutableArray alloc]init];
    
    NSString * query = @"SELECT ID FROM CompanyFeedbackTypeAssociation";
    
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB) == SQLITE_OK)// 1. Open The DataBase.
    {
        if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query UTF8String], -1, &statement, NULL) == SQLITE_OK)// 2. Prepare the query
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                const char * userId = (const char*)sqlite3_column_text(statement, 0);
                [uniqueCompanyFeedIdAssoArray addObject:[NSString stringWithUTF8String:userId]];
                NSLog(@"%s",userId);
            }
        }
        else
        {
            NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
    }
    else
    {
        NSLog(@"can't open db due error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    if (sqlite3_finalize(statement) == SQLITE_OK)
    {
        NSLog(@"statement is finalized");
    }
    else
        NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    
    return uniqueCompanyFeedIdAssoArray;
    
    
    
}









-(void)setDatabaseToCompressAndShowTotalQueryOrFeedback:(long)indexPath
{

    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement;
    sqlite3_stmt *statement1 = NULL;
    sqlite3_stmt *statement2=NULL;
    FeedOrQueryMessageHeader* headerObj;
    sqlite3* feedbackAndQueryTypesDB;
    NSMutableArray* getFeedbackAndQueryMessages=[[NSMutableArray alloc]init];
    
    AppPreferences* app=[AppPreferences sharedAppPreferences];
    app.feedQueryMessageHeaderArray=[[NSMutableArray alloc]init];
    
    NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];
    NSString* flag=[defaults valueForKey:@"flag"];
    NSLog(@"%@",flag);
    
    
    NSString* que=[NSString stringWithFormat:@"Select distinct SO_Number,feedBackType from feedback where feedBackType=%ld",indexPath+1];
    NSString* que1=[NSString stringWithFormat:@"Select distinct SO_Number,feedBackType from query where feedBackType=%ld",indexPath+1];
    NSString *que2;
    if ([flag isEqual:@"0"])
    {
        que2=[NSString stringWithFormat:@"%@",que];
    }
    else
        que2=[NSString stringWithFormat:@"%@",que1];
    
    
    
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB) == SQLITE_OK)// 1. Open The DataBase.
    {
        
        if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [que2 UTF8String], -1, &statement, NULL) == SQLITE_OK)// 2. Prepare the query
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
               // const char * empId = (const char*)sqlite3_column_text(statement, 0);
                const char * SO_Number = (const char*)sqlite3_column_text(statement, 0);
                NSString *SO_NumberString=[NSString stringWithFormat:@"%s",SO_Number];
                
                const char * feedBackType = (const char*)sqlite3_column_text(statement, 1);
                NSString *feedBackTypeString=[NSString stringWithFormat:@"%s",feedBackType];
                NSLog(@"%s",SO_Number);
                NSLog(@"%s",feedBackType);
                
                getFeedbackAndQueryMessages=[NSMutableArray arrayWithObject:SO_NumberString];
                
                NSString* query2=[NSString stringWithFormat:@"Select Feedback_text from feedback where SO_Number='%s' AND feedbackCounter=(Select MIN(feedbackCounter) from feedback where SO_Number='%s' AND feedBackType=(Select feedBackType from feedback where SO_Number='%s'))",SO_Number,SO_Number,SO_Number];
                NSString* query3=[NSString stringWithFormat:@"Select Query_text from query where SO_Number='%s' AND QueryCounter=(Select MIN(QueryCounter) from query where SO_Number='%s' AND feedBackType=(Select feedBackType from query where SO_Number='%s'))",SO_Number,SO_Number,SO_Number];
                NSString* query4;
                if ([flag isEqual:@"0"])
                {
                    query4=[NSString stringWithFormat:@"%@",query2];
                }
                else
                    query4=[NSString stringWithFormat:@"%@",query3];
                
                
                if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB) == SQLITE_OK)// 1. Open The DataBase.
                {
                    
                    if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query4 UTF8String], -1, &statement1, NULL) == SQLITE_OK)// 2. Prepare the query
                    {
                        while (sqlite3_step(statement1) == SQLITE_ROW)
                        {
                           headerObj=[[FeedOrQueryMessageHeader alloc]init];
                            const char * feedTextMsg = (const char*)sqlite3_column_text(statement1, 0);
                            NSString *str2=[NSString stringWithFormat:@"%s",feedTextMsg];
                            headerObj.soNumber=SO_NumberString;
                            headerObj.feedText=str2;
                            headerObj.feedbackType=[feedBackTypeString intValue];
                            //[app.feedQueryMessageHeaderArray addObject:headerObj];
                            NSLog(@"%@",SO_NumberString);
                            
                        }
                    }
                    else
                    {
                        NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                    }
                }
                else
                {
                    NSLog(@"can't open db due error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                }
                
                
                if (sqlite3_finalize(statement1) == SQLITE_OK)
                {
                    NSLog(@"statement is finalized");
                }
                else
                    NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                        NSString* getDateAndTimeQueryOfFeedcom=[NSString stringWithFormat:@"Select dateoffeed from feedback where SO_Number='%s' AND feedbackCounter=(Select MAX(feedbackCounter) from feedback where SO_Number='%s' AND feedBackType=(Select feedBackType from feedback where SO_Number='%s'))",SO_Number,SO_Number,SO_Number];
                NSString* getDateAndTimeQueryOfQuerycom=[NSString stringWithFormat:@"Select dateofquery from query where SO_Number='%s' AND QueryCounter=(Select MAX(QueryCounter) from query where SO_Number='%s' AND feedBackType=(Select feedBackType from query where SO_Number='%s'))",SO_Number,SO_Number,SO_Number];
                NSString* getDateAndTimeOfFeedcomOrQuerycom;
                if ([flag isEqual:@"0"])
                {
                    getDateAndTimeOfFeedcomOrQuerycom=[NSString stringWithFormat:@"%@",getDateAndTimeQueryOfFeedcom];
                }
                else
                    getDateAndTimeOfFeedcomOrQuerycom=[NSString stringWithFormat:@"%@",getDateAndTimeQueryOfQuerycom];
                
                
                if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB) == SQLITE_OK)// 1. Open The DataBase.
                {
                    
                    if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [getDateAndTimeOfFeedcomOrQuerycom UTF8String], -1, &statement2, NULL) == SQLITE_OK)// 2. Prepare the query
                    {
                        while (sqlite3_step(statement2) == SQLITE_ROW)
                        {
                            const char * feedDate = (const char*)sqlite3_column_text(statement2, 0);
                            NSString *FeedDateString=[NSString stringWithFormat:@"%s",feedDate];
                            headerObj.feedDate=FeedDateString;
                            [app.feedQueryMessageHeaderArray addObject:headerObj];
                            NSLog(@"%@",headerObj.feedDate);
                            
                        }
                    }
                    else
                    {
                        NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                    }
                }
                else
                {
                    NSLog(@"can't open db due error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                }
                
                
                if (sqlite3_finalize(statement2) == SQLITE_OK)
                {
                    NSLog(@"statement is finalized");
                }
                else
                    NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                
                

                
            }
        }
        else
        {
            NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
    }
    else
    {
        NSLog(@"can't open db due error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    
    if (sqlite3_finalize(statement) == SQLITE_OK)
    {
        NSLog(@"statement is finalized");
    }
    else
        NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    
    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
    {
        NSLog(@"db is closed");
    }
    else
    {
        NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    


}


-(void)getDetailMessagesofFeedbackOrQuery:(int)feedType :(NSString *)SONumber
{
    AppPreferences *app=[AppPreferences sharedAppPreferences];
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement,*statement2;
    sqlite3* feedbackAndQueryTypesDB;
    NSMutableArray* uniqueUserIdArray=[[NSMutableArray alloc]init];
    NSString* query1=[NSString stringWithFormat:@"SELECT Feedback_text,userFrom,userTo,EmailSubject,dateoffeed FROM feedback where feedBackType=%d AND SO_Number='%@'",feedType,SONumber];
    NSString* query2=[NSString stringWithFormat:@"SELECT Query_text,userFrom,userTo,subject,dateofquery FROM query where feedBackType=%d AND SO_Number='%@'",feedType,SONumber];
    NSString* query3;
    NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];

    NSString* str=[defaults valueForKey:@"flag"] ;
    NSLog(@"%@",str);
    FeedbackChatingCounter *allMessageObj;
    if ([str isEqualToString:@"0"])
    {
        query3=[NSString stringWithFormat:@"%@",query1];
    }
    else
        query3=[NSString stringWithFormat:@"%@",query2];
    
        app.FeedbackOrQueryDetailChatingObjectsArray=[[NSMutableArray alloc]init];
    
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB) == SQLITE_OK)// 1. Open The DataBase.
    {
        if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query3 UTF8String], -1, &statement, NULL) == SQLITE_OK)// 2. Prepare the query
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSMutableArray* userFromUserToArray=[[NSMutableArray alloc]init];
                
                    allMessageObj=[[FeedbackChatingCounter alloc]init];
                
                NSString* messageString = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 0)];
                NSString* userFromString = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 1)];
                NSString* userToString = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 2)];
                NSString* emailSubject = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 3)];
                NSString* dateOfFeed = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 4)];


                
                [userFromUserToArray addObject:userFromString];
                [userFromUserToArray addObject:userToString];
                NSString* userFrom,*userTo;

                for (int i=0; i<userFromUserToArray.count; i++)
                {
                    NSString* str=[NSString stringWithFormat:@"%@",[userFromUserToArray objectAtIndex:i]];
               
                    NSString* UserfromToQuery=[NSString stringWithFormat:@"SELECT USER_NAME FROM user where ID='%@'",str];
                

                    if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [UserfromToQuery UTF8String], -1, &statement2, NULL) == SQLITE_OK)// 2. Prepare the query
                    {
                      while (sqlite3_step(statement2) == SQLITE_ROW)
                      {
                        
                           if(i==0)
                           {
                             userFrom = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement2, 0)];
                           }
                          
                           else
                           {
                            userTo = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement2, 0)];
                           }
                          
                      }
                        
                    
                    }
                    else
                    {
                      NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                    }
                   
                 }
                
               
                    allMessageObj.soNumber=SONumber;
                    allMessageObj.userFrom=userFrom;
                    allMessageObj.userTo=userTo;
                    allMessageObj.emailSubject=emailSubject;
                    allMessageObj.dateOfFeed=dateOfFeed;
                allMessageObj.detailMessage=messageString;
                    [app.FeedbackOrQueryDetailChatingObjectsArray addObject:allMessageObj];
                
                NSLog(@"%@",messageString);
                NSLog(@"%@",userFrom);
                NSLog(@"%@",userTo);
                NSLog(@"%@",emailSubject);
                NSLog(@"%ld",app.FeedbackOrQueryDetailChatingObjectsArray.count);

                
            }
            

        }
        else
        {
            NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
        
        
    }
    else
    {
        NSLog(@"can't open db due error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    if (sqlite3_finalize(statement) == SQLITE_OK)
    {
        NSLog(@"statement is finalized");
    }
    else
        NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    
    //return uniqueUserIdArray;

}


-(void)validateUserFromLocalDatabase:(NSString *)usernameString :(NSString *)passwordString
{
    AppPreferences *app=[AppPreferences sharedAppPreferences];
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement;
    sqlite3* feedbackAndQueryTypesDB;
    BOOL flag=false;
    NSMutableArray* uniqueUserIdArray=[[NSMutableArray alloc]init];
    NSString* query1=[NSString stringWithFormat:@"SELECT USER_NAME,PASSWORD FROM user"];
    
    
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB) == SQLITE_OK)// 1. Open The DataBase.
    {
        if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query1 UTF8String], -1, &statement, NULL) == SQLITE_OK)// 2. Prepare the query
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {

               // [app.feedOrQueryDetailMessageArray addObject:[NSString stringWithUTF8String:message]];
                NSString* username=[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 0)];
                NSString* password=[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 1)];
                NSLog(@"%@",username);
                if ([username isEqualToString:usernameString] && [password isEqualToString:passwordString])
                {
                    flag=true;
                }
                
            }
        }
        else
        {
            NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
    }
    else
    {
        NSLog(@"can't open db due error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    if (sqlite3_finalize(statement) == SQLITE_OK)
    {
        NSLog(@"statement is finalized");
    }
    else
        NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    
}



-(User*)getUserUsername:(NSString*)username andPassword:(NSString*)password
{

    AppPreferences *app=[AppPreferences sharedAppPreferences];
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement;
    sqlite3* feedbackAndQueryTypesDB;
    NSMutableArray* uniqueUserIdArray=[[NSMutableArray alloc]init];
    NSString* query1=[NSString stringWithFormat:@"SELECT * FROM user Where USER_NAME='%@' and PASSWORD='%@'",username,password];
    User *userObj=[[User alloc]init];

    
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB) == SQLITE_OK)// 1. Open The DataBase.
    {
        if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query1 UTF8String], -1, &statement, NULL) == SQLITE_OK)// 2. Prepare the query
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                // [app.feedOrQueryDetailMessageArray addObject:[NSString stringWithUTF8String:message]];
                userObj.Id=[[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 0)]intValue];
                
                userObj.password=[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 1)];
                
                 userObj.username=[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 2)];
                
                 userObj.userRole=[[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 3)]intValue];
                
                 userObj.comanyId=[[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 4)]intValue];
                
                 userObj.email=[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 5)];
                
                 userObj.mobileNo=[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 6)];
                
                 userObj.firstName=[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 7)];
                
                 userObj.firstName=[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 8)];
                
                 userObj.lastName=[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 9)];
                
               
            }
        }
        else
        {
            NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
    }
    else
    {
        NSLog(@"can't open db due error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    if (sqlite3_finalize(statement) == SQLITE_OK)
    {
        NSLog(@"statement is finalized");
    }
    else
        NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    

    return userObj;


}



-(NSString*)getCompanyIdFromCompanyName:(NSString*)CompanyId
{

    //AppPreferences *app=[AppPreferences sharedAppPreferences];
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement;
    sqlite3* feedbackAndQueryTypesDB;
    NSString* companyNAME;
    NSMutableArray* uniqueUserIdArray=[[NSMutableArray alloc]init];
    NSString* query1=[NSString stringWithFormat:@"SELECT Company_Name from company Where CompanyId='%@'",CompanyId];
    
    
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB) == SQLITE_OK)// 1. Open The DataBase.
    {
        if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query1 UTF8String], -1, &statement, NULL) == SQLITE_OK)// 2. Prepare the query
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                // [app.feedOrQueryDetailMessageArray addObject:[NSString stringWithUTF8String:message]];
                companyNAME=[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 0)];
               
                
            }
        }
        else
        {
            NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
    }
    else
    {
        NSLog(@"can't open db due error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    if (sqlite3_finalize(statement) == SQLITE_OK)
    {
        NSLog(@"statement is finalized");
    }
    else
        NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    


    return companyNAME;

}


@end
