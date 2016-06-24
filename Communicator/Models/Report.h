//
//  Report.h
//  Communicator
//
//  Created by mac on 16/06/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Report : NSObject

@property(nonatomic)int Id;
@property(nonatomic,strong)NSString* date;
@property(nonatomic)int userFrom;
@property(nonatomic)int userto;
@property(nonatomic)int userfeedback;
@property(nonatomic,strong)NSString* description;
@property(nonatomic,strong)NSString* datetime;
@property(nonatomic,strong)NSString* name;


@end
