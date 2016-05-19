//
//  Products.h
//  Communicator
//
//  Created by mac on 01/05/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Products : NSObject

@property(nonatomic)int productId;
@property(nonatomic,strong)NSString* productCode;
@property(nonatomic)int isActive;
@property(nonatomic,strong)NSString* productDis;
@property(nonatomic,strong)NSString* productName;
@property(nonatomic)double productQuntity;
@property(nonatomic)double purchaseRate;
@property(nonatomic)double vatPercent;
@property(nonatomic,strong)NSString* unit;




@end
