//
//  DetailChatingViewController.h
//  Communicator
//
//  Created by mac on 26/05/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <CFNetwork/CFNetwork.h>

@interface DetailChatingViewController : UIViewController<UITextFieldDelegate,NSStreamDelegate,NSURLSessionDelegate,NSURLSessionDownloadDelegate,NSURLSessionDataDelegate,UIDocumentInteractionControllerDelegate>
{
    AppPreferences* app;
    int movement;
    NSString* downloadableAttachmentName;

}
- (IBAction)sendFeedbackButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *sendFeedbackTextfield;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) MBProgressHUD *hud;


//for FTP use only


@property (nonatomic, assign, readonly ) BOOL              isReceiving;
@property (nonatomic, strong, readwrite) NSInputStream *   networkStream;
@property (nonatomic, copy,   readwrite) NSString *        filePath;
@property (nonatomic, strong, readwrite) NSOutputStream *  fileStream;


- (IBAction)sendAttachment:(id)sender;
@end
