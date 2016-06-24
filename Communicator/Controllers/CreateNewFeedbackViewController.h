//
//  CreateNewFeedbackViewController.h
//  Communicator
//
//  Created by mac on 19/05/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateNewFeedbackViewController : UIViewController

{
    int movement;
    int totalMovement;
    BOOL gotResponse;
}
@property (weak, nonatomic) IBOutlet UITextField *SONumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *AvayaIdTextField;
@property (weak, nonatomic) IBOutlet UITextField *DocumentIdTextField;
@property (weak, nonatomic) IBOutlet UITextView *SubjectTextView;
@property (weak, nonatomic) IBOutlet UITextField *OperatorTextField;
@property (weak, nonatomic) IBOutlet UITextView *DescriptionTextView;
@property (nonatomic,strong)NSString* feedbackType;

- (IBAction)dismissViewController:(id)sender;
- (IBAction)sendNewFeedback:(id)sender;

@end
