//
//  DemoDesignViewController.h
//  Communicator
//
//  Created by mac on 20/05/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DemoDesignViewController : UIViewController

@property (strong, nonatomic)NSMutableArray *demoCountArray;

@property (weak, nonatomic) IBOutlet UILabel *POLabel;
@property (weak, nonatomic) IBOutlet UILabel *shipToAddressLabel;

@end
