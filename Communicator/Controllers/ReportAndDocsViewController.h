//
//  ReportAndDocsViewController.h
//  Communicator
//
//  Created by mac on 24/05/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportAndDocsViewController : UIViewController<UIDocumentInteractionControllerDelegate>
{
    NSMutableArray* arrayForBool;
    NSArray* sectionTitleArray;
    UIView *sectionView;
    NSMutableArray * fileNameUserArray;
    NSMutableData* responseData;
    int statusCode;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *reportButton;
@property (weak, nonatomic) IBOutlet UIButton *documentButton;
@property (weak, nonatomic) IBOutlet UIView *reportButtonUnderlineView;
@property (weak, nonatomic) IBOutlet UIView *documentButtonUnderlineView;
- (IBAction)buttonClicked:(id)sender;
@end
