//
//  FeedbackChatingCounter.h
//  Communicator
//
//  Created by mac on 20/03/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeedbackChatingCounter : NSObject

@property(nonatomic)long feedbackCounter;
@property(nonatomic)long count;
@property(nonatomic,strong)NSString* soNumber;
@property(nonatomic)int feedbackType;
@property(nonatomic)int userFrom;
@property(nonatomic)int userTo;

@end
