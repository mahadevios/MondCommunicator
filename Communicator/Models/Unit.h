//
//  Unit.h
//  Communicator
//
//  Created by mac on 01/05/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Unit : NSObject

@property(nonatomic)int unitId;
@property(nonatomic,strong)NSString* subUnitName;
@property(nonatomic,strong)NSString* unitName;

@end
