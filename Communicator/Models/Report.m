//
//  Report.m
//  Communicator
//
//  Created by mac on 16/06/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import "Report.h"

@implementation Report

@synthesize Id;
@synthesize date;
@synthesize datetime;
@synthesize userfeedback;
@synthesize userFrom;
@synthesize userto;
@synthesize description;
@synthesize name;

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:[ NSString stringWithFormat:@"%d",self.Id] forKey:@"Id"];
    [aCoder encodeObject:self.date forKey:@"date"];
    [aCoder encodeObject:self.datetime forKey:@"datetime"];
    [aCoder encodeObject:[ NSString stringWithFormat:@"%d",self.userFrom] forKey:@"userFrom"];
    [aCoder encodeObject:[ NSString stringWithFormat:@"%d",self.userfeedback] forKey:@"userfeedback"];
    [aCoder encodeObject:self.name forKey:@"name"];
    
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super init]){
        //self=[aDecoder decodeObjectForKey:@"userObject"];
        self.Id = [[aDecoder decodeObjectForKey:@"Id"]intValue];
        self.date=[aDecoder decodeObjectForKey:@"date"];
        self.datetime=[aDecoder decodeObjectForKey:@"datetime"];
        self.userFrom=[[aDecoder decodeObjectForKey:@"userFrom"]intValue];
        self.userfeedback=[[aDecoder decodeObjectForKey:@"userfeedback"]intValue];
        self.name=[aDecoder decodeObjectForKey:@"name"];
       
        
        
    }
    return self;
}

@end
