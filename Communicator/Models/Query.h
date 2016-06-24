//
//  Query.h
//  Communicator
//
//  Created by mac on 20/03/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Query : NSObject

@property(nonatomic)long queryId;
@property(nonatomic,strong)NSString* queryText;
@property(nonatomic,strong)NSString* soNumber;
@property(nonatomic)long queryCounter;
@property(nonatomic)int feedbackType;
@property(nonatomic)int statusId;
@property(nonatomic)int operatorId;
@property(nonatomic)int userFeedback;

@property(nonatomic)int userFrom;
@property(nonatomic)int userTo;
@property(nonatomic)int userQuery;
@property(nonatomic)NSString* dateOfQuery;
@property(nonatomic,strong)NSString* emailSubject;
@property(nonatomic,strong)NSString* attachment;

@end
