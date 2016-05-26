//
//  AppPreferences.h
//  Communicator
//
//  Created by mac on 05/04/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Reachability.h"

@protocol AppPreferencesDelegate;

@interface AppPreferences : NSObject 
{
    id<AppPreferencesDelegate> alertDelegate;
}

@property (nonatomic,strong)    id<AppPreferencesDelegate> alertDelegate;

@property (nonatomic)           int     currentSelectedItem;

@property (nonatomic,assign)    BOOL                        isReachable;

@property (nonatomic,strong)NSMutableArray* feedQueryCounterArray;
@property (nonatomic,strong)NSMutableArray* feedQueryMessageHeaderArray;
@property (nonatomic,strong)NSMutableArray* feedOrQueryDetailMessageArray;
@property (nonatomic,strong)NSMutableArray* permittedCompaniesForUserArray;
@property (nonatomic,strong)NSMutableArray* FeedbackOrQueryDetailChatingObjectsArray;

+(AppPreferences *) sharedAppPreferences;

-(void) showAlertViewWithTitle:(NSString *) title withMessage:(NSString *) message withCancelText:(NSString *) cancelText withOkText:(NSString *) okText withAlertTag:(int) tag;
-(void) showNoInternetMessage;

-(void) startReachabilityNotifier;

@end


@protocol AppPreferencesDelegate

@optional
-(void) appPreferencesAlertButtonWithIndex:(int) buttonIndex withAlertTag:(int) alertTag;
@end