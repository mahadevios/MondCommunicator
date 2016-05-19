//
//  CALayer+BorderColor.m
//  Communicator
//
//  Created by mac on 22/03/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import "CALayer+BorderColor.h"

@implementation CALayer (BorderColor)

-(void)setBorderUIColor:(UIColor*)color
{
    self.borderColor = color.CGColor;
}

-(UIColor*)borderUIColor
{
    return [UIColor colorWithCGColor:self.borderColor];
}

@end
