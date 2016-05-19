//
//  ComposeFeedbackOrQueryViewController.h
//  Communicator
//
//  Created by mac on 02/04/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <CFNetwork/CFNetwork.h>
#import "SKPSMTPMessage.h"
#import "NSData+Base64Additions.h" // for Base64 encoding@implementation ViewController
@interface ComposeFeedbackOrQueryViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate>
{
    UIBarButtonItem* menuBarButton;

}
@property (weak, nonatomic) IBOutlet UITextView *bodyTextView;
@property (weak, nonatomic) IBOutlet UITextField *subjectTextfield;
@property (weak, nonatomic) IBOutlet UIButton *attachementButton;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
- (IBAction)sendEmail:(id)sender;

- (IBAction) dismissComposeViewController;

@end
