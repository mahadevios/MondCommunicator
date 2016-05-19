//
//  UserdepartmentRole.h
//  Communicator
//
//  Created by mac on 01/05/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserdepartmentRole : NSObject

@property(nonatomic)int Id;
@property(nonatomic)int departmentId;
@property(nonatomic)int userId;
@property(nonatomic,strong)NSString* userDepartmentRole;


@end
