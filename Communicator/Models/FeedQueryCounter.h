//
//  FeedQueryCounter.h
//  Communicator
//
//  Created by mac on 01/05/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeedQueryCounter : NSObject

@property(nonatomic,strong)NSString* feedbackType;
@property(nonatomic)int feedCounter;
@property(nonatomic)int queryCounter;

@end
