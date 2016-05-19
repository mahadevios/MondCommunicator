//
//  Feedback.h
//  Communicator
//
//  Created by mac on 20/03/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Feedback : NSObject

@property(nonatomic)long feedbackId;
@property(nonatomic,strong)NSDate* dateOfFeed;
@property(nonatomic,strong)NSString* feedbackText;
@property(nonatomic,strong)NSString* soNumber;
@property(nonatomic)long feedbackCounter;
@property(nonatomic)int feedbackType;
@property(nonatomic)int operatorId;
@property(nonatomic)int statusId;
@property(nonatomic)int userFrom;
@property(nonatomic)int userTo;
@property(nonatomic)int userFeedback;
@property(nonatomic,strong)NSString* attachment;
@property(nonatomic,strong)NSString* emailSubject;


@end
