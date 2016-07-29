//
//  CompanyRelatedFeedQueryCounter.h
//  Communicator
//
//  Created by mac on 01/06/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CompanyRelatedFeedQueryCounter : NSObject
@property(nonatomic)int ID;
@property(nonatomic)int feedTypeId;
@property(nonatomic)int companyId;
@property(nonatomic)long feedCounter;
@property(nonatomic)long closedCounter;
@property(nonatomic)long totalCounter;

@end
