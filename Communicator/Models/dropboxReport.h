//
//  dropboxReport.h
//  Communicator
//
//  Created by mac on 01/05/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface dropboxReport : NSObject

@property(nonatomic)int Id;
@property(nonatomic,strong)NSDate* fileDate;
@property(nonatomic,strong)NSString* name;

@end
