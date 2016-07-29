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
@property(nonatomic)int statusId;
@property(nonatomic,strong)NSString* userFrom;
@property(nonatomic,strong)NSString* userTo;
@property(nonatomic,strong)NSString* emailSubject;
@property(nonatomic,strong)NSString* dateOfFeed;
@property(nonatomic,strong)NSString* detailMessage;
@property(nonatomic,strong)NSString* attachments;



@end
