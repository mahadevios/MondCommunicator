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
#import "User.h"
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








-(void)insertQueryData:(NSDictionary*)dic
{
    //NSLog(@"%@",dic);
    NSLog(@"in insertttttttttt data");
    NSError* error;
    NSString* QueryString=[dic valueForKey:@"ListOfQuery"];
    NSData *QueryData = [QueryString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSArray *queryValue = [NSJSONSerialization JSONObjectWithData:QueryData
                                                             options:NSJSONReadingAllowFragments
                                                               error:&error];
    // NSLog(@"%@",[feedbackValue objectAtIndex:4]);
    //NSDictionary* d1;
    
    for(NSDictionary* queryDetailDictionary in queryValue)
    {
        NSLog(@"%@",NSHomeDirectory());
        
        //-------------------------feedback table data insertion------------------------------------------
        
      Query *query=[[Query alloc]init];
        
        query.queryId=[[queryDetailDictionary valueForKey:@"queryId"]intValue];
        query.queryText=[queryDetailDictionary valueForKey:@"queryText"];
        
        query.dateOfQuery=[queryDetailDictionary valueForKey:@"dateofquery"];
        
        NSDictionary* feedBackType=[queryDetailDictionary valueForKey:@"feedBackType"];
        query.feedbackType=[[feedBackType valueForKey:@"id"]intValue];
        
        query.soNumber=[queryDetailDictionary valueForKey:@"soNumber"];
        
        NSDictionary* counter=[queryDetailDictionary valueForKey:@"counter"];
        query.queryCounter=[[counter valueForKey:@"queryCounter"]longValue];;
        
       // NSDictionary* operator=[queryDetailDictionary valueForKey:@"operator"];
       // feedback.operatorId=[[operator valueForKey:@"operatorId"]intValue];
        
        NSDictionary* status=[queryDetailDictionary valueForKey:@"status"];
        query.statusId=[[status valueForKey:@"statusId"]intValue];
        
        NSDictionary* userModelFrom=[queryDetailDictionary valueForKey:@"userModelFrom"];
        query.userFrom=[[userModelFrom valueForKey:@"userId"]intValue];
        
        NSDictionary* userModelTo=[queryDetailDictionary valueForKey:@"userModelTo"];
        query.userTo=[[userModelTo valueForKey:@"userId"]intValue];
        
        NSDictionary* userfeedback=[queryDetailDictionary valueForKey:@"userquery"];
        query.userQuery=[[userfeedback valueForKey:@"userId"]intValue];
        
       //query.attachment=[queryDetailDictionary valueForKey:@"attachment"];
        
      query.emailSubject=[queryDetailDictionary valueForKey:@"subject"];
        
        //-------------------------user table data insertion values------------------------------------------
        
        User *user=[[User alloc]init];
        Company *company=[[Company alloc]init];
        user.username=[userModelFrom valueForKey:@"userName"];
        user.password=[userModelFrom valueForKey:@"password"];
        
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
        userroll.role=[userRole valueForKey:@"role"];
        
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
        userroll1.role=[userRole1 valueForKey:@"role"];
        
        //--------------------------company table data values------------------------------------------------
        
        company1.Company_Name=[companyOb1 valueForKey:@"companyName"];
        company1.Company_Contact=[companyOb1 valueForKey:@"companyContact"];
        company1.Company_Address=[companyOb1 valueForKey:@"companyAddress"];
        company1.Company_Email=[companyOb1 valueForKey:@"companyEmail"];
        //company1.userId=[[companyOb1 valueForKey:@"userID"]intValue];
        
        //-------------------------userRole table data values-----------------------------------------------
        
        user.username=[userRole valueForKey:@"role"];
        user1.username=[userRole1 valueForKey:@"role"];
        
        //-------------------------operator table data values--------------------------------------------------
        
//        Operator *operatorobj =[[Operator alloc]init];
//        operatorobj.firstName=[operator valueForKey:@"firstName"];
//        operatorobj.lastName=[operator valueForKey:@"lastName"];
//        operatorobj.userName=[operator valueForKey:@"userName"];
//        operatorobj.status=[operator valueForKey:@"status"];
        
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
        NSString* q4=[NSString stringWithFormat:@"Delete from query where Query_id<23"];
        //  NSString* q5=[NSString stringWithFormat:@"ALTER TABLE query1 RENAME TO query"];
        //  NSString* q7=[NSString stringWithFormat:@"CREATE TABLE userpermission (ID INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL , CompanyId INTEGER, USER_ID INTEGER,FOREIGN KEY (CompanyId) REFERENCES company(CompanyId) ,FOREIGN KEY (USER_ID) REFERENCES user(ID))"];
        
        /* Data insertion: feedback table */
        
        
        NSString *query1=[NSString stringWithFormat:@"INSERT INTO query values(\"%d\",\"%@\",\"%@\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%@\",\"%@\")",query.queryId,query.queryText,query.soNumber,query.queryCounter,query.feedbackType,query.statusId,query.userFrom,query.userTo,query.userQuery,query.dateOfQuery,query.emailSubject];
        
        const char * queryi1=[query1 UTF8String];
        if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
        {
            sqlite3_prepare_v2(feedbackAndQueryTypesDB, queryi1, -1, &statement, NULL);
            if(sqlite3_step(statement)==SQLITE_DONE)
            {
                NSLog(@"query table data inserted");
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
        
        NSString* userid=[NSString stringWithFormat:@"%d",query.userFrom];
        NSString* userid1=[NSString stringWithFormat:@"%d",query.userTo];

        NSString* useriqueryDetailDictionary=[NSString stringWithFormat:@"%d",query.userTo];
        NSString* companyid=[NSString stringWithFormat:@"%d",user.comanyId];
        NSString* companyid1=[NSString stringWithFormat:@"%d",user1.comanyId];
        NSString* usersRoll=[NSString stringWithFormat:@"%d",user.userRole];
        NSString* usersRoll1=[NSString stringWithFormat:@"%d",user1.userRole];
       // NSString* operatorID=[NSString stringWithFormat:@"%d",query.operatorId];
        NSString* statusID=[NSString stringWithFormat:@"%d",query.statusId];
        NSString* feedbacktypeID=[NSString stringWithFormat:@"%d",query.feedbackType];
        
        
        
        
        NSLog(@"%@",userid);
        NSLog(@"%lu",(unsigned long)[uniqueUserIdArray count]);
        
        if (!([uniqueUserIdArray containsObject:userid]))
        {
            
            NSString *query2=[NSString stringWithFormat:@"INSERT INTO user values(\"%d\",\"%@\",\"%@\",\"%d\",\"%d\",\"%@\",\"%@\",\"%@\",\"%@\")",query.userFrom,user.password,user.username,user.userRole,user.comanyId,user.email,user.mobileNo,user.firstName,user.lastName];
            
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
            
            NSString *query3=[NSString stringWithFormat:@"INSERT INTO user values(\"%d\",\"%@\",\"%@\",\"%d\",\"%d\",\"%@\",\"%@\",\"%@\",\"%@\")",query.userTo,user1.password,user1.username,user1.userRole,user1.comanyId,user1.email,user1.mobileNo,user1.firstName,user1.lastName];
            
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
            
            NSString *query3=[NSString stringWithFormat:@"INSERT INTO roles values(\"%d\",\"%@\")",user.userRole,user.username];
            
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
            
            NSString *query3=[NSString stringWithFormat:@"INSERT INTO roles values(\"%d\",\"%@\")",user1.userRole,user1.username];
            
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
        
        
        
//        if (!([uniqueOperatorArray containsObject:operatorID]))
//        {
//            
//            NSString *query3=[NSString stringWithFormat:@"INSERT INTO operator values(\"%d\",\"%@\",\"%@\",\"%@\",\"%@\")",feedback.operatorId,operatorobj.firstName,operatorobj.lastName,operatorobj.status,operatorobj.userName];
//            
//            const char * queryi3=[query3 UTF8String];
//            if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
//            {
//                sqlite3_prepare_v2(feedbackAndQueryTypesDB, queryi3, -1, &statement, NULL);
//                if(sqlite3_step(statement)==SQLITE_DONE)
//                {
//                    NSLog(@"user table data inserted");
//                    NSLog(@"%@",NSHomeDirectory());
//                    sqlite3_reset(statement);
//                }
//                else
//                {
//                    NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//                }
//            }
//            else
//            {
//                NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
//            }
//        }
//        
        
        if (!([uniqueStatusIdArray containsObject:statusID]))
        {
            
            NSString *query3=[NSString stringWithFormat:@"INSERT INTO status values(\"%d\",\"%@\")",query.statusId,statusobj.status];
            
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
            
            NSString *query3=[NSString stringWithFormat:@"INSERT INTO feedbacktype values(\"%d\",\"%@\")",query.feedbackType,feedbackTypeObj.feedbacktype];
            
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



-(void)updateData:(NSString*)data;
{
    
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement;
    sqlite3_stmt *statement1;

    sqlite3* feedbackAndQueryTypesDB;
    getFeedbackAndQueryMessages=[[NSDictionary alloc]init];
    SONoArray=[[NSMutableArray alloc]init];
    feedbackAndQueryTypeArray=[[NSMutableArray alloc]init];

   // NSString *query3=[NSString stringWithFormat:@"ALTER TABLE feedback ADD COLUMN EmailSubject TEXT DEFAULT null"];

    
  //  NSString *query2=[NSString stringWithFormat:@"update user set password=\"%@\" where id=9",data];
    
    
    NSString* query=[NSString stringWithFormat:@"Select distinct feedbackType from feedback"];
    
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB) == SQLITE_OK)// 1. Open The DataBase.
    {
        
        if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query UTF8String], -1, &statement, NULL) == SQLITE_OK)// 2. Prepare the query
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                const char * empId = (const char*)sqlite3_column_text(statement, 0);
                NSString* tc = [NSString stringWithUTF8String:empId];
                NSString *q1=[NSString stringWithFormat:@" Select feedBackType,SO_Number from feedback where feedbackType=%@",tc];
                if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB) == SQLITE_OK)// 1. Open The DataBase.
                {
                    
                    //        sqlite3_prepare_v2(<#sqlite3 *db#>, <#const char *zSql#>, <#int nByte#>, <#sqlite3_stmt **ppStmt#>, <#const char **pzTail#>)
                    
                    if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [q1 UTF8String], -1, &statement1, NULL) == SQLITE_OK)// 2. Prepare the query
                    {
                        while (sqlite3_step(statement1) == SQLITE_ROW)
                        {
                            
                            const char * empId1 = (const char*)sqlite3_column_text(statement1, 0);
                            
                            
                            NSString* tc = [NSString stringWithUTF8String:empId1];
                            
                            NSString* So = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement1, 1)];
                            [feedbackAndQueryTypeArray addObject:tc];
                            [SONoArray addObject:So];
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
                NSLog(@"%@",tc);
                
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
    if (sqlite3_finalize(statement1) == SQLITE_OK)
    {
        NSLog(@"statement1 is finalized");
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

    getFeedbackAndQueryMessages=[NSDictionary dictionaryWithObjects:SONoArray forKeys:feedbackAndQueryTypeArray];
    for(NSString *ar in feedbackAndQueryTypeArray)
    {
    
        NSLog(@"%@",ar);
    }
    for(NSString *ar1 in SONoArray)
    {
        
        NSLog(@"%@",ar1);
    }

    
    
    
    int j=0;
    
    NSMutableArray* aar1=[NSMutableArray arrayWithArray:db.SONoArray];
    NSMutableArray* aar2=[NSMutableArray arrayWithArray:db.feedbackAndQueryTypeArray];

    for(int i=0;i<aar1.count;i++)
    {
        NSNumber *l=[NSNumber numberWithInt:0];

        for (j=i+1; j<aar1.count; j++)
        {
            
            if ([[aar1 objectAtIndex:i]isEqualToString:[aar1 objectAtIndex:j]])
            {
                
                                NSLog(@"%@",[aar1 objectAtIndex:i]);
                
                
            }
            
        }
        
      //  getFeedbackAndQueryCounter=[NSDictionary dictionaryWithObject:l forKey:[aar2 objectAtIndex:i] ];


    }

    
}




-(void)findCount:(NSDictionary*)dic :(NSString*)username :(NSString*)password
{
    
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
   // sqlite3_stmt *statement;
    sqlite3_stmt *statement1;
    
    sqlite3* feedbackAndQueryTypesDB;
    getFeedbackAndQueryMessages=[[NSDictionary alloc]init];
    SONoArray=[[NSMutableArray alloc]init];
    feedbackAndQueryTypeArray=[[NSMutableArray alloc]init];
    getFeedbackAndQueryCounter=[[NSMutableDictionary alloc]init];
    AppPreferences* app=[AppPreferences sharedAppPreferences];
    app.feedQueryCounterArray=[[NSMutableArray alloc]init];
    app.permittedCompaniesForUserArray=[[NSMutableArray alloc]init];
       NSLog(@"%@",dic);

//        NSString *query3=[NSString stringWithFormat:@"INSERT INTO company values(\"3\",\"Dscribe\",\"pune\",\"322356789\",\"dsc@gmail.com\",\"\")"];
//        sqlite3_stmt* statement;
//        const char * queryi3=[query3 UTF8String];
//        if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
//        {
//            sqlite3_prepare_v2(feedbackAndQueryTypesDB, queryi3, -1, &statement, NULL);
//            if(sqlite3_step(statement)==SQLITE_DONE)
//            {
//                NSLog(@"user table data inserted");
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
   
    NSString* query=[NSString stringWithFormat:@"Select CompanyId from userpermission where USER_ID=(Select ID from user where USER_NAME='%@' AND PASSWORD='%@')",username,password];
   // NSString* query1=[NSString stringWithFormat:@"Select ID from user where USER_NAME='%@' AND PASSWORD='%@'",username,password];
NSString* q2=@"Select CompanyId from userpermission where USER_ID=2";
//    NSString *q1=[NSString stringWithFormat:@"Select distinct SO_Number,feedbacktype from feedback where feedbacktype=%d",i];

    sqlite3_stmt* statement2;
    sqlite3* feedAndQueryDB;
    if (sqlite3_open([dbPath UTF8String], &feedAndQueryDB)==SQLITE_OK)
    {
        if(sqlite3_prepare_v2(feedAndQueryDB, [q2 UTF8String], -1, &statement2, NULL)==SQLITE_OK)
        {
            while (sqlite3_step(statement2)==SQLITE_ROW)
            {
                NSString* cmpnyId=[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement2, 0)];
                NSLog(@"%@",cmpnyId);
                
                
                NSString* query1=[NSString stringWithFormat:@"Select Company_Name from company where CompanyId=%d",[cmpnyId intValue]];
                sqlite3_stmt* statement3;
                if (sqlite3_open([dbPath UTF8String], &feedAndQueryDB)==SQLITE_OK)
                {
                    if(sqlite3_prepare_v2(feedAndQueryDB, [query1 UTF8String], -1, &statement3, NULL)==SQLITE_OK)
                    {
                        while (sqlite3_step(statement3)==SQLITE_ROW)
                        {
                            NSString* cmpnyname=[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement3, 0)];
                            NSLog(@"%@",cmpnyname);
                            [app.permittedCompaniesForUserArray addObject:cmpnyname];
                        }
                    }
                    else
                    {
                        NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedAndQueryDB));
                    }
                    
                    
                }
                else
                {
                    NSLog(@"can't open db due error = %s",sqlite3_errmsg(feedAndQueryDB));
                }

                
                
                
                
            }
        }
        else
        {
            NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedAndQueryDB));
        }

        
    }
    else
    {
        NSLog(@"can't open db due error = %s",sqlite3_errmsg(feedAndQueryDB));
    }
    
    for (int i=1; i<23; i++)
    {
      //  NSNumber *num1=[NSNumber numberWithInt:i];

       NSString *q1=[NSString stringWithFormat:@"Select distinct SO_Number,feedbacktype from feedback where feedbacktype=%d",i];
        NSString *q2=[NSString stringWithFormat:@"Select distinct SO_Number,feedbacktype from query where feedbacktype=%d",i];
        FeedQueryCounter *feedback=[[FeedQueryCounter alloc]init];


    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB) == SQLITE_OK)// 1. Open The DataBase.
    {
        
        //        sqlite3_prepare_v2(<#sqlite3 *db#>, <#const char *zSql#>, <#int nByte#>, <#sqlite3_stmt **ppStmt#>, <#const char **pzTail#>)
        
        if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [q1 UTF8String], -1, &statement1, NULL) == SQLITE_OK)
        {
            int j=0;
            while (sqlite3_step(statement1) == SQLITE_ROW)
            {
                j++;
                NSNumber *num=[NSNumber numberWithInt:j];
                NSString* ft = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement1, 1)];
                feedback.feedbackTypeId=[ft integerValue];
                feedback.feedCounter=[num integerValue];
                [getFeedbackAndQueryCounter setObject:num  forKey:ft];

                
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
        
        
        
        
        
        if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB) == SQLITE_OK)// 1. Open The DataBase.
        {
            
            //        sqlite3_prepare_v2(<#sqlite3 *db#>, <#const char *zSql#>, <#int nByte#>, <#sqlite3_stmt **ppStmt#>, <#const char **pzTail#>)
            
            if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [q2 UTF8String], -1, &statement1, NULL) == SQLITE_OK)
            {
                int j=0;
                while (sqlite3_step(statement1) == SQLITE_ROW)
                {
                    j++;
                    NSNumber *num=[NSNumber numberWithInt:j];
                    NSString* ft = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement1, 1)];
                    feedback.feedbackTypeId=[ft integerValue];
                    feedback.queryCounter=[num integerValue];
                    [getFeedbackAndQueryCounter setObject:num  forKey:ft];
                    
                    
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
  
        
    
     [app.feedQueryCounterArray addObject:feedback];
    
    
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
                
                
                //------------------------------
                
                
                
//                const char * SO_Number = (const char*)sqlite3_column_text(statement, 0);
//                NSString *SO_NumberString=[NSString stringWithFormat:@"%s",SO_Number];
//                
//                const char * feedBackType = (const char*)sqlite3_column_text(statement, 1);
//                NSString *feedBackTypeString=[NSString stringWithFormat:@"%s",feedBackType];
//                NSLog(@"%s",SO_Number);
//                NSLog(@"%s",feedBackType);
//                
//                getFeedbackAndQueryMessages=[NSMutableArray arrayWithObject:SO_NumberString];
//                
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
                
                

                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                //-----------------------------
                
                
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
@end
