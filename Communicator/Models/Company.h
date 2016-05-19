//
//  Company.h
//  Communicator
//
//  Created by mac on 01/05/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Company : NSObject

@property(nonatomic)int ComanyId;
@property(nonatomic,strong)NSString* Company_Name;
@property(nonatomic,strong)NSString* Company_Address;
@property(nonatomic,strong)NSString* Company_Contact;
@property(nonatomic,strong)NSString* Company_Email;
@property(nonatomic)int userId;

@end
