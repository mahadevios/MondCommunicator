//
//  Query.h
//  Communicator
//
//  Created by mac on 20/03/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Query : NSObject

@property(nonatomic)int queryId;
@property(nonatomic,strong)NSString* queryText;
@property(nonatomic,strong)NSString* soNumber;
@property(nonatomic)int queryCounter;
@property(nonatomic)int feedbackType;
@property(nonatomic)int statusId;
@property(nonatomic)int userFrom;
@property(nonatomic)int userTo;
@property(nonatomic)int userQuery;
@property(nonatomic)NSDate* dateOfQuery;
@property(nonatomic,strong)NSString* emailSubject;

@end
