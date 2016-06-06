//
//  User.m
//  Communicator
//
//  Created by mac on 20/03/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import "User.h"

@implementation User

@synthesize Id;
@synthesize username;
@synthesize password;
@synthesize userRole;
@synthesize comanyId;
@synthesize email;
@synthesize mobileNo;
@synthesize firstName;
@synthesize lastName;
@synthesize deviceToken;




- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:[ NSString stringWithFormat:@"%d",self.Id] forKey:@"Id"];
    [aCoder encodeObject:self.username forKey:@"username"];
    [aCoder encodeObject:self.password forKey:@"password"];
    [aCoder encodeObject:[ NSString stringWithFormat:@"%d",self.userRole] forKey:@"userRole"];
    [aCoder encodeObject:[ NSString stringWithFormat:@"%d",self.comanyId] forKey:@"comanyId"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:self.mobileNo forKey:@"mobileNo"];
    [aCoder encodeObject:self.firstName forKey:@"firstName"];
    [aCoder encodeObject:self.lastName forKey:@"lastName"];
    [aCoder encodeObject:self.deviceToken forKey:@"deviceToken"];

}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super init]){
        //self=[aDecoder decodeObjectForKey:@"userObject"];
        self.Id = [[aDecoder decodeObjectForKey:@"Id"]intValue];
        self.username=[aDecoder decodeObjectForKey:@"username"];
        self.password=[aDecoder decodeObjectForKey:@"password"];
        self.userRole=[[aDecoder decodeObjectForKey:@"userRole"]intValue];
        self.comanyId=[[aDecoder decodeObjectForKey:@"comanyId"]intValue];
        self.email=[aDecoder decodeObjectForKey:@"email"];
        self.mobileNo=[aDecoder decodeObjectForKey:@"mobileNo"];
        self.firstName=[aDecoder decodeObjectForKey:@"firstName"];
        self.lastName=[aDecoder decodeObjectForKey:@"lastName"];
        self.deviceToken=[aDecoder decodeObjectForKey:@"deviceToken"];


    }
    return self;
}
@end
