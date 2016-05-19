//
//  User.h
//  Communicator
//
//  Created by mac on 20/03/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property(nonatomic)int Id;
@property(nonatomic,strong)NSString* username;
@property(nonatomic,strong)NSString* password;
@property(nonatomic)int userRole;
@property(nonatomic)int comanyId;
@property(nonatomic,strong)NSString* email;
@property(nonatomic,strong)NSString* mobileNo;
@property(nonatomic,strong)NSString* firstName;
@property(nonatomic,strong)NSString* lastName;

@end
