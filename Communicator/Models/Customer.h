//
//  Customer.h
//  Communicator
//
//  Created by mac on 01/05/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Customer : NSObject

@property(nonatomic)int Id;
@property(nonatomic,strong)NSString* addressLine1;
@property(nonatomic,strong)NSString* AddressLine2;
@property(nonatomic,strong)NSString* city;
@property(nonatomic,strong)NSString* emailId;
@property(nonatomic,strong)NSString* firstName;
@property(nonatomic,strong)NSString* lastName;
@property(nonatomic,strong)NSString* middleName;
@property(nonatomic,strong)NSString* phoneNo1;
@property(nonatomic,strong)NSString* PhoneNo2;
@property(nonatomic,strong)NSString* pinNo;
@property(nonatomic,strong)NSString* state;
@property(nonatomic,strong)NSString* telephoneNo;
@property(nonatomic,strong)NSString* tinNo;
@property(nonatomic)double creditBalance;
@property(nonatomic)double creditLimit;
@property(nonatomic)double debitBalance;


@end
