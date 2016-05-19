//
//  UIButton+buttonDesign.m
//  Communicator
//
//  Created by mac on 15/04/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import "UIButton+buttonDesign.h"

@implementation UIButton (buttonDesign)
UIColor* buttonColor;
UIButton* button;

-(UIColor *)getButtonColor
{
  buttonColor= [UIColor colorWithRed:41/255.0 green:97/255.0 blue:142/255.0 alpha:1];
   return buttonColor;
}

-(UIButton *)getButtonBorderWidthAndColor
{
    button.layer.borderWidth = 0.8;
    button.layer.borderColor = [UIColor colorWithRed:41/255.0 green:97/255.0 blue:142/255.0 alpha:1].CGColor;
    return button;
}

@end
