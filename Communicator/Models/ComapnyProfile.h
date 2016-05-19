//
//  ComapnyProfile.h
//  Communicator
//
//  Created by mac on 01/05/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ComapnyProfile : NSObject

@property(nonatomic)int companyId;
@property(nonatomic,strong)NSString* addressLine1;
@property(nonatomic,strong)NSString* city;
@property(nonatomic,strong)NSString* companyName;
@property(nonatomic,strong)NSString* CSTNO;
@property(nonatomic,strong)NSString* email;
@property(nonatomic,strong)NSString* contact;
@property(nonatomic,strong)NSString* PANNO;
@property(nonatomic,strong)NSString* state;
@property(nonatomic,strong)NSString* vatNo;

@end
