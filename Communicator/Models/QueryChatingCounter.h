//
//  QueryChatingCounter.h
//  Communicator
//
//  Created by mac on 20/03/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QueryChatingCounter : NSObject

@property(nonatomic)int queryCounter;
@property(nonatomic)int count;
@property(nonatomic)NSString* soNumber;
@property(nonatomic)int feedbacktype;
@property(nonatomic)int userFrom;
@property(nonatomic)int userTo;

@end
