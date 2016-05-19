//
//  ViewController.h
//  Communicator
//
//  Created by mac on 26/03/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "Database.h"
#import "FeedbackType.h"
#import "LoginViewController.h"

@interface HomeViewController : UIViewController<UISearchBarDelegate, UISearchResultsUpdating>

{
    NSMutableArray* getFeedbackAndQueryTypesArray;
    UIBarButtonItem* menuBarButton;
    
    int selectedFeedbackType;
}

- (IBAction)changeType:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *chatTypeLabel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic)NSMutableArray *feedTypeArray;

@property (strong, nonatomic)NSMutableArray *feedTypeCopyForPredicate;

@property (weak, nonatomic) IBOutlet UISegmentedControl *feedAndQueryComSegment;

@property (strong, nonatomic) NSIndexPath *data;

@property (weak, nonatomic) IBOutlet UIButton *feedComButton;

@property (weak, nonatomic) IBOutlet UIButton *queryComButton;

- (IBAction)buttonClicked:(id)sender;
-(void)setSelectedButton:(id)sender;


@end
