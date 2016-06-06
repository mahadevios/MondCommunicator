//
//  ReportAndDocsViewController.h
//  Communicator
//
//  Created by mac on 24/05/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportAndDocsViewController : UIViewController
{
    NSMutableArray* arrayForBool;
    NSArray* sectionTitleArray;
    UIView *sectionView;

}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
