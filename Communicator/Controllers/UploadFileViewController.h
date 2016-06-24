//
//  UploadFileViewController.h
//  Communicator
//
//  Created by mac on 21/06/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UploadFileViewController : UIViewController
{
    NSDictionary* result;


}
- (IBAction)selectFileFromGallery:(id)sender;
- (IBAction)selectFileFromStorage:(id)sender;


@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
- (IBAction)barbuttonClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightBarButton;
@end
