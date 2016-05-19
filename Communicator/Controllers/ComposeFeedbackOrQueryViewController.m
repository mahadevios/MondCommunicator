//
//  ComposeFeedbackOrQueryViewController.m
//  Communicator
//
//  Created by mac on 02/04/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import "ComposeFeedbackOrQueryViewController.h"
#import "MBProgressHUD.h"
#import "UIColor+CommunicatorColor.h"
@interface ComposeFeedbackOrQueryViewController ()

@end

@implementation ComposeFeedbackOrQueryViewController
MBProgressHUD *hud;
@synthesize bodyTextView;
@synthesize subjectTextfield;
@synthesize attachementButton;
@synthesize sendButton;
int movement;
long l;
long g;
int flag;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createBarButtonItem];
//    SWRevealViewController *revealViewController = self.revealViewController;
//    if ( revealViewController )
//    {
//        [menuBarButton setTarget: self.revealViewController];
//        [menuBarButton setAction: @selector( revealToggle: )];
//        // [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
//    }     // Do any additional setup after loading the view.
//    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    subjectTextfield.delegate=self;
    bodyTextView.delegate=self;
    bodyTextView.layer.borderWidth=0.7;
    bodyTextView.layer.borderColor=[[UIColor grayColor]CGColor];
    bodyTextView.layer.cornerRadius=7;
    attachementButton.layer.cornerRadius=7;
    sendButton.layer.cornerRadius=7;
    [subjectTextfield becomeFirstResponder];
}

-(void)viewWillAppear:(BOOL)animated
{
    sendButton.backgroundColor=[UIColor communicatorColor];
    
    attachementButton.backgroundColor=[UIColor communicatorColor];

}

-(void)createBarButtonItem
{
//    menuBarButton=    [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"SliderMenu"] style:NULL target:NULL action:NULL];
    
    // menuBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:NULL
    //                                                             action:NULL];
//    self.navigationItem.leftBarButtonItem = menuBarButton;
}


#pragma mark- SKPSMTPMessage delegate

-(void)messageSent:(SKPSMTPMessage *)message
{
    NSLog(@"delegate - message sent");

    UIImage *image = [[UIImage imageNamed:@"CompletedSign"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    hud.customView = imageView;
    hud.mode = MBProgressHUDModeCustomView;
    hud.label.text = NSLocalizedString(@"Message sent successfully!", @"HUD completed title");
        [hud hideAnimated:YES afterDelay:2.f];
    [self performSelector:@selector(dismissComposeViewController) withObject:nil afterDelay:3.0f];
}

- (IBAction) dismissComposeViewController
{
    [self dismissViewControllerAnimated:self completion:nil];
}

-(void)messageFailed:(SKPSMTPMessage *)message error:(NSError *)error
{
    UIImage *image = [[UIImage imageNamed:@"CrossSign"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    hud.customView = imageView;
    hud.mode = MBProgressHUDModeCustomView;
    hud.label.text = NSLocalizedString(@"Error, Please try after some time.", @"HUD completed title");
    [hud hideAnimated:YES afterDelay:3.f];
    NSLog(@"%@",error);
}



#pragma mark-texField delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
        [bodyTextView becomeFirstResponder];
        return YES;
}

#pragma mark-texView delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"])
    {
        
        [textView resignFirstResponder];
        // Return FALSE so that the final '\n' character doesn't get added
        return NO;
    }
    // For any other character return TRUE so that the text gets added to the view
    return YES;
}


-(void)textViewDidBeginEditing:(UITextView *)textView
{
            [self moveViewUp:YES];

}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    [self moveViewUp:NO];
    NSLog(@"%ld",(long)[[UIDevice currentDevice] orientation]);

}


- (void) moveViewUp: (BOOL) isUp
{
    const int movementDistance = 80; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    movement = (isUp ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}


#pragma mark - UIViewControllerRotation

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if ([bodyTextView isFirstResponder])
    {
        
    
      if (self.view.frame.origin.y==self.view.frame.origin.y)
      {
        self.view.frame = CGRectOffset(self.view.frame, 0, -80);
      }
        
    }
}



- (IBAction)sendEmail:(id)sender
{
    NSString *messageBody = bodyTextView.text;
   
   hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Set some text to show the initial status.
    hud.label.text = NSLocalizedString(@"Sending...", @"HUD Loading title");
    // Will look best, if we set a minimum size.
    hud.minSize = CGSizeMake(150.f, 100.f);
    
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        // Do something useful in the background and update the HUD periodically.
        
        NSLog(@"Start Sending");
        SKPSMTPMessage *emailMessage = [[SKPSMTPMessage alloc] init];
        emailMessage.fromEmail = @"mandale.mahadev7@gmail.com"; //sender email address
        emailMessage.toEmail = @"mandalemahadev@yahoo.com";  //receiver email address
        // emailMessage.relayHost = @"smtp.gmail.com";
        emailMessage.relayHost = @"smtp.gmail.com";
        // emailMessage.validateSSLChain=YES;
        //emailMessage.ccEmail =@"your cc address";
        //emailMessage.bccEmail =@"your bcc address";
        emailMessage.requiresAuth = YES;
        emailMessage.login = @"mandale.mahadev7@gmail.com"; //sender email address
        emailMessage.pass = @"foc2pune"; //sender email password
        emailMessage.subject =subjectTextfield.text;
        emailMessage.wantsSecure = YES;
        emailMessage.delegate = self; // you must include <SKPSMTPMessageDelegate> to your class
        
        NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/sample.txt"];
        
        
        NSData *attachmentData = [NSData dataWithContentsOfFile:jpgPath];
        
        //NSString *directory = @"text/jpeg;\r\n\tx-unix-mode=0644;\r\n\tname=\"file.jpeg\"";
        NSString *directory = @"text/directory;\r\n\tx-unix-mode=0644;\r\n\tname=\"sample.txt\"";

        NSString *attachment = @"attachment;\r\n\tfilename=\"sample.txt\"";

        NSDictionary *image_part = [NSDictionary dictionaryWithObjectsAndKeys:
                                    directory,kSKPSMTPPartContentTypeKey,
                                    attachment,kSKPSMTPPartContentDispositionKey,
                                    [attachmentData encodeBase64ForData],kSKPSMTPPartMessageKey,
                                    messageBody,kSKPSMTPPartMessageKey,
                                    @"base64",kSKPSMTPPartContentTransferEncodingKey,nil];
        
        NSMutableArray* parts = [[NSMutableArray alloc] init];
        
        [parts addObject: image_part];
        
              emailMessage.parts = parts;
        
        [emailMessage send];
        dispatch_async(dispatch_get_main_queue(), ^{
        });
    });

    //in addition : Logic for attaching file with email message.
    // email image if it exists
    
    
    
    }


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






@end
