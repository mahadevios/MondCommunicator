//
//  APIManager.h
//  Communicator
//
//  Created by mac on 05/04/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownloadMetaDataJob.h"

@interface APIManager : NSObject
{
    
}

+(APIManager *) sharedManager;

-(void) validateUser:(NSString *) usernameString andPassword:(NSString *) passwordString;

@end
