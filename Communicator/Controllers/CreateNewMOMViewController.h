//
//  CreateNewMOMViewController.h
//  Communicator
//
//  Created by mac on 19/05/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateNewMOMViewController : UIViewController
{
    BOOL gotResponse;

}
- (IBAction)sendNewMom:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *subjectTextField;
@property (weak, nonatomic) IBOutlet UITextField *dateTextField;
@property (weak, nonatomic) IBOutlet UITextView *attendiesTextview;
@property (weak, nonatomic) IBOutlet UITextView *keyPointstextView;
@end
