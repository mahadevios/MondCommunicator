//
//  ViewController.m
//  Communicator
//
//  Created by mac on 19/03/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import "LoginViewController.h"
#import "MBProgressHUD.h"
//#import "SWRevealViewController.h"
#import "HomeViewController.h"
#import "UIColor+CommunicatorColor.h"
#import "FeedQueryCounter.h"
#import "Database.h"
#import "MainTabBarViewController.h"
#import "CompanyNamesViewController.h"
#import "User.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize rememberMeButton;
@synthesize remeberMeLabel;
@synthesize usenameTextField;
@synthesize passwordTextField;
@synthesize buttonColor;
@synthesize hud;
@synthesize navigationBar;

BOOL check;
UIAlertController *alertController1;
NSMutableArray* webFeedCountArray;
NSMutableArray* webFeedTypeArray;
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString* demo=@"hello";
    NSLog(@"This is hello text :: %@   This is second text :: %@",demo, @"second hello");
    [rememberMeButton setSelected:NO];
    //[[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"rememberMe"];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rememberMeButtonClicked)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [remeberMeLabel addGestureRecognizer:tapGestureRecognizer];
    Database *db=[Database shareddatabase];
    NSLog(@"%@",NSHomeDirectory());
   // [db insertData];
   // [db updateData:@"myname"];
    usenameTextField.delegate=self;
    passwordTextField.delegate=self;
    
    // Do any additional setup after loading the view, typically from a nib.

  
}

- (void)viewWillAppear:(BOOL)animated
{
  //  [[self navigationController] setNavigationBarHidden:YES animated:NO];
    //buttonColor.backgroundColor=[UIColor communicatorColor];

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"LoginViewBackgroundImage"]];
    self.navigationController.navigationBar.barTintColor = [UIColor communicatorColor];
    [self.navigationController.navigationBar setBarStyle:UIStatusBarStyleLightContent];// to set carrier,time and battery color in white color
//    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    NSDictionary *size = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Source Sans Pro" size:20.0],NSFontAttributeName, nil];
    
    self.navigationController.navigationBar.titleTextAttributes = size;
    
    usenameTextField.layer.cornerRadius=0.0f;
    usenameTextField.layer.masksToBounds=YES;
    usenameTextField.layer.borderColor=[[UIColor grayColor]CGColor];
    usenameTextField.layer.borderWidth= 1.0f;
    passwordTextField.layer.cornerRadius=0.0f;
    passwordTextField.layer.masksToBounds=YES;
    passwordTextField.layer.borderColor=[[UIColor grayColor]CGColor];
    passwordTextField.layer.borderWidth= 1.0f;

      
    [rememberMeButton setSelected:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(validateUserResponse:) name:NOTIFICATION_VALIDATE_USER
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(validateCounter:) name:NOTIFICATION_VALIDATE_COUNTER
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getLatestRecords:) name:NOTIFICATION_GETLATEST_FEEDCOM
                                               object:nil];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_VALIDATE_USER object:nil];
}

//--------Selector for NOTIFICATION_VALIDATE_USER-----//

- (void)validateUserResponse:(NSNotification *)notification
{
    if ([[notification.object objectForKey:@"code"] isEqualToString:SUCCESS])
    {
        Database *db=[Database shareddatabase];
        [db insertCompanyRelatedFeedbackTypeAndUsers:notification.object];
        
        [[APIManager sharedManager] findCountForUsername:self.usenameTextField.text andPassword:self.passwordTextField.text];
        AppPreferences *app=[AppPreferences sharedAppPreferences];
        
        NSLog(@"%@",self.usenameTextField.text);
        
        app.getFeedbackAndQueryTypesArray = [db getFeedbackAndQueryTypes];

        NSLog(@"%lu",(unsigned long)app.feedQueryCounterArray.count);
        
        
        hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        [hud hideAnimated:YES];
    }
}

//--------Selector for NOTIFICATION_VALIDATE_COUNTER -----//

- (void)validateCounter:(NSNotification *)notification
{
    
    if ([[notification.object objectForKey:@"code"] isEqualToString:SUCCESS])
    {
        Database *db=[Database shareddatabase];
        [db insertFeedQueryCounter:notification.object];
        NSError* error;
        AppPreferences* app=[AppPreferences sharedAppPreferences];
       
       app.companynameOrIdArray= [db findPermittedCompaniesForUsername:self.usenameTextField.text Password:self.passwordTextField.text];
        NSLog(@"%ld",app.companynameOrIdArray.count);
        
        [[APIManager sharedManager]getLatestRecordsForUsername:self.usenameTextField.text andPassword:self.passwordTextField.text];

        
        
        if (app.companynameOrIdArray.count==1)
        {
            NSLog(@"%@",[app.companynameOrIdArray objectAtIndex:0]);
            Database* db=[Database shareddatabase];
            NSString* companyName= [NSString stringWithFormat:@"%@",[app.companynameOrIdArray objectAtIndex:0]];
        
            [db getFeedbackAndQueryCounterForCompany:companyName];

            [self pushToHomeView];
        }
        
        else
        {
            [self pushToCompanyView];
        
        }
       
       }
    
}

//-------- Selector for NOTIFICATION_GETLATEST_RECORDS -----//

- (void)getLatestRecords:(NSNotification *)notificationData
{
    if ([[notificationData.object objectForKey:@"code"] isEqualToString:SUCCESS])
    {
        Database *db=[Database shareddatabase];
        [db insertLatestRecordsForFeedcom:notificationData.object];
        AppPreferences *app=[AppPreferences sharedAppPreferences];
        
        NSLog(@"%@",self.usenameTextField.text);
        
        app.getFeedbackAndQueryTypesArray = [db getFeedbackAndQueryTypes];
        
        NSLog(@"%lu",(unsigned long)app.feedQueryCounterArray.count);
        
        
        hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        [hud hideAnimated:YES];
    }
}



#pragma mark-texField delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==usenameTextField)
    {
        [passwordTextField becomeFirstResponder];
    }
    else
    {
        [textField resignFirstResponder];
    }
    return YES;
}


#pragma mark-UIButton actions

- (IBAction)rememberMeButtonTapped:(id)sender
{
    [self rememberMeButtonClicked];
}

- (void)rememberMeButtonClicked
{
    if ([rememberMeButton isSelected])
    {
        [rememberMeButton setSelected:NO];
        
        
        
        
    }
    
    else
    {
        [rememberMeButton setSelected:YES];
    }
}


- (IBAction)loginButtonTapped:(id)sender
{
    if ([self.usenameTextField.text length] <= 0 || [self.passwordTextField.text length] <= 0)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Empty field"
                                                                                 message:@"Please enter valid username and password"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        //We add buttons to the alert controller by creating UIAlertActions:
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil]; //You can use a block here to handle a press on this button
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        
                // Set some text to show the initial status.
                hud.label.text = NSLocalizedString(@"Please wait...", @"HUD Loading title");
                // Will look best, if we set a minimum size.
                hud.minSize = CGSizeMake(150.f, 100.f);
        
        NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];
        [defaults setValue:self.usenameTextField.text forKey:@"currentUser"];
        [defaults setValue:self.passwordTextField.text forKey:@"currentPassword"];

        //Database* db=[Database shareddatabase];
       // [db validateUserFromLocalDatabase:self.usenameTextField.text :self.passwordTextField.text];
        
        [[APIManager sharedManager] validateUser:self.usenameTextField.text Password:self.passwordTextField.text andDeviceId:@"21"];


    }

}


-(void)pushToHomeView
{
    AppPreferences* app=[AppPreferences sharedAppPreferences];
    if ([rememberMeButton isSelected])
    {
        //[[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"rememberMe"];
        Database* db=[Database shareddatabase];
        User* userObjForDefault=[[User alloc]init];
        User *userObj= [db getUserUsername:self.usenameTextField.text andPassword:self.passwordTextField.text];
        
        userObjForDefault.Id=userObj.Id;
        userObjForDefault.username=userObj.username;
        userObjForDefault.password=userObj.password;
        userObjForDefault.userRole=userObj.userRole;
        userObjForDefault.comanyId=userObj.comanyId;
        userObjForDefault.email=userObj.email;
        userObjForDefault.deviceToken=userObj.deviceToken;
        userObjForDefault.mobileNo=userObj.mobileNo;
        userObjForDefault.firstName=userObj.firstName;
        userObjForDefault.lastName=userObj.lastName;
        
        NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];
        [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:userObjForDefault] forKey:@"userObject"];

    NSLog(@"%@",userObj.password);
    
  

        
    }
    else
   {
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"rememberMe"];
   }

   MainTabBarViewController* vc= [self.storyboard instantiateViewControllerWithIdentifier:@"MainTabBarViewController"];

    [self.navigationController pushViewController:vc animated:YES];
    
}


-(void)pushToCompanyView
{
    if ([rememberMeButton isSelected])
    {
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"rememberMe"];
        
        Database* db=[Database shareddatabase];
        User* userObjForDefault=[[User alloc]init];
        User *userObj= [db getUserUsername:self.usenameTextField.text andPassword:self.passwordTextField.text];
        
        userObjForDefault.Id=userObj.Id;
        userObjForDefault.username=userObj.username;
        userObjForDefault.password=userObj.password;
        userObjForDefault.userRole=userObj.userRole;
        userObjForDefault.comanyId=userObj.comanyId;
        userObjForDefault.email=userObj.email;
        userObjForDefault.deviceToken=userObj.deviceToken;
        userObjForDefault.mobileNo=userObj.mobileNo;
        userObjForDefault.firstName=userObj.firstName;
        userObjForDefault.lastName=userObj.lastName;
        
        NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];
        [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:userObjForDefault] forKey:@"userObject"];
        
        NSLog(@"%@",userObj.password);

        
    }
    else
    {
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"rememberMe"];
    }
    CompanyNamesViewController * vc= [self.storyboard instantiateViewControllerWithIdentifier:@"CompanyNamesViewController"];
    
    [self.navigationController pushViewController:vc animated:YES];



}






- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end


