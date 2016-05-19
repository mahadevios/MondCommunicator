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
#import "UIColor+CommunicatorColor.h"
#import "FeedQueryCounter.h"
#import "Database.h"

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
    NSDictionary *size = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Arial" size:23.0],NSFontAttributeName, nil];
    
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
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_VALIDATE_USER object:nil];
}


- (void)validateUserResponse:(NSNotification *)notification
{
//    NSLog(@"%@", notification.object);
//    NSLog(@"%@", [notification.object objectForKey:@"code"]);
    if ([[notification.object objectForKey:@"code"] isEqualToString:SUCCESS])
    {
        Database *db=[Database shareddatabase];
    [db insertFeedbackData:notification.object];
        [db insertQueryData:notification.object];

       // [db updateData:@"vv"];
        AppPreferences *app=[AppPreferences sharedAppPreferences];
        
        NSLog(@"%@",self.usenameTextField.text);
        //app.feedQueryCounterArray = [db findCount:notification.object :self.usenameTextField.text :self.passwordTextField.text];
      [db findCount:notification.object :self.usenameTextField.text :self.passwordTextField.text];

        NSLog(@"%lu",(unsigned long)app.feedQueryCounterArray.count);
        
        NSLog(@"%lu",(unsigned long)app.permittedCompaniesForUserArray.count);
//        for (int i=0; i<app.feedQueryCounterArray.count; i++)
//        {
//           FeedQueryCounter* fq =  [app.feedQueryCounterArray objectAtIndex:i];
//            NSLog(@"%ld",fq.feedbackTypeId);
//            NSLog(@"%ld",fq.feedCounter);
//        }
        if (app.permittedCompaniesForUserArray.count>1)
        {
            [self pushToCompanyNamesView];
            
        }
        else
        {
        hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        [hud hideAnimated:YES];
        [self pushToHomeView];
        }
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

        Database* db=[Database shareddatabase];
        [db validateUserFromLocalDatabase:self.usenameTextField.text :self.passwordTextField.text];
        
        [[APIManager sharedManager] validateUser:self.usenameTextField.text andPassword:self.passwordTextField.text];
        
/*
        
        NSString *urlString = [NSString stringWithFormat: @"http://localhost:8080/coreflex/feedcom/login"];
        
        NSURL *url=[NSURL URLWithString:urlString];
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session1 = [NSURLSession sessionWithConfiguration:config];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];

        [request setHTTPMethod:@"POST"];
        NSString *jsonString =@"username=ssi&password=ssi";
        [request setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSURLSessionDataTask *datatask=[session1 dataTaskWithRequest:request completionHandler:^(NSData *  data, NSURLResponse *  response, NSError *  error)
                                        {
                                             if (error)
                                                {
                                                    
                                                    NSLog(@"%@",error.localizedDescription);
                                                
                                                }
                                                
                                                
                                                else
                                                {
                                                
                                                    NSDictionary* dic=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                    NSLog(@"in success");
                                                    // NSDictionary *dic= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                    NSLog(@"%@",dic);
                                                    
                                                    if ([[dic valueForKey:@"code"] isEqualToString:@"1000"])
                                                    {
                                                        NSLog(@"code=1000");
                                                        
                                                        NSString* userString=[dic valueForKey:@"user"];
                                                         NSData *userData = [userString dataUsingEncoding:NSUTF8StringEncoding];
                                                        NSDictionary* userDict=[NSJSONSerialization JSONObjectWithData:userData options:0 error:&error];
                                                        
                                                        NSLog(@"%@",[userDict valueForKey:@"userId"]);
                                                        
                                                        NSString* username=[userDict valueForKey:@"username"];
                                                        NSString* password=[userDict valueForKey:@"password"];
                                                        
                                                        NSURL *feedAndQueryCountUrlString=[NSURL URLWithString:@"http://localhost:8080/coreflex/feedcom/getcommunicationCounterForFeedComQueryCom?username=ssi&&password=ssi"];
                                                        
                                                        
                                                      //  NSURL *feedAndQueryCountUrl=[NSURL URLWithString:feedAndQueryCountUrlString];
                                                        
                                                       
                                                       
                                                        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:feedAndQueryCountUrlString];

                                                       
                                                        NSString *usernameString =[NSString stringWithFormat:@"username=%@&password=%@",username,password];
                                                        [request setHTTPBody:[usernameString dataUsingEncoding:NSUTF8StringEncoding]];
                                                        
                                                        NSURLSessionDataTask *datatask=[session1 dataTaskWithRequest:request completionHandler:^(NSData *  data, NSURLResponse *  response, NSError *  error)

                                                                                        {
                                                                                            if (error)
                                                                                            {
                                                                                                
                                                                                                NSLog(@"%@",error.localizedDescription);
                                                                                                
                                                                                            }
                                                                                            
                                                                                            else
                                                                                            {
                                                                                                NSDictionary* dic1=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                                                NSLog(@"in success");
                                                                                                // NSDictionary *dic= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                                                NSLog(@"%@",dic1);
                                                                                              
                                                                                            }
                                                                                        
                                                                                        }];
                                                        
                                                        [datatask resume];

                                                        
                                                    }

                                                
                                                 }
                                          }];
                       [datatask resume];
        
        
        
      //  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        NSURLSession *session=[NSURLSession sharedSession];
        [request setHTTPMethod: @"POST"];
        
        
        
        NSURLSessionDataTask *datatask1=[session dataTaskWithRequest:request completionHandler:^(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error)
                                        {
                                            
                                            if (error)
                                            {
                                                
                                               
                                                NSLog(@"%@",error.localizedDescription);
                                                
                                                
                                                
                                            }
                                            else
                                            {
                                                NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                NSLog(@"in success");
                                               // NSDictionary *dic= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                               NSLog(@"%@",dic);
                                                
                                                    // code here
                                               
//                                                if ([[dic valueForKey:@"name"] isEqual:@"Not Available"])
//                                                {
//                                                    dispatch_async(dispatch_get_main_queue(), ^{
//
//                                                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Authentication failed"
//                                                                                                                             message:@"Please enter valid username and password"
//                                                                                                                      preferredStyle:UIAlertControllerStyleAlert];
//                                                    //We add buttons to the alert controller by creating UIAlertActions:
//                                                    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
//                                                                                                       style:UIAlertActionStyleDefault
//                                                                                                     handler:nil]; //You can use a block here to handle a press on this button
//                                                    [alertController addAction:actionOk];
//                                                    [self presentViewController:alertController animated:YES completion:nil];
//                                                     });
//
//                                                }
//                                                else
//                                                {
                                                
                                                NSURL *url=[NSURL URLWithString:@"http://localhost:8080/coreflex/feedcom/getcommunicationCounterForFeedComQueryCom?username=ssi&&password=ssi"];
                                                
                                                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
                                                NSURLSession *session=[NSURLSession sharedSession];
                                                [request setHTTPMethod: @"GET"];
                                                
                                                
                                               // MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                                                
                                                NSURLSessionDataTask *datatask=[session dataTaskWithRequest:request completionHandler:^(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error)
                                                                                {
                                                                                    
                                                                                    if (error)
                                                                                    {
                                                                                        
                                                                                        NSLog(@"%@",error.localizedDescription);
                                                                                      
                                                                                    }
                                                                                    else
                                                                                    {
                                                                                        NSLog(@"in success");
                                                                                        
                                                                                        NSDictionary *feedcomQuerycomCounterDictionary= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

                                                                                        NSString* ar=[feedcomQuerycomCounterDictionary valueForKey:@"feedcomCommunicationCounter"];
                                                                                        
                                                                                        //NSLog(@"%@",ar);

                                                                                        NSData *jsonData = [ar dataUsingEncoding:NSUTF8StringEncoding];
                                                                                        

                                                                                        NSArray* feedcomCounterArray = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
                                                                                        //NSLog(@"%@",feedcomCounterArray);

                                                                                        //NSLog(@"%@",[feedcomCounterArray objectAtIndex:0]);
                                                                                        
                                                                                        
                                                                                        
                                                                                        int i=0;
                                                                                        NSDictionary* dd;
                                                                                        webFeedCountArray=[[NSMutableArray alloc]init];
                                                                                        webFeedTypeArray=[[NSMutableArray alloc]init];

                                                                                        for (NSDictionary *dic in feedcomCounterArray)

                                                                                        {
                                                                                           // NSMutableArray *arr=[NSMutableArray arrayWithObjects:dic, nil];
                                                                                            //NSLog(@"%@",[dic valueForKey:@"count"]);
                                                                                           // NSLog(@"%@",[dic valueForKey:@"feedBackTypeTable"]);
                                                                                           // NSLog(@"%@",dic);
                                                                                              if([dic isKindOfClass:[NSDictionary class]])//because dictionary has another dixtionary inside it
                                                                                            {
                                                                                                    //NSLog(@"%@",[dic valueForKey:@"feedBackTypeTable"]);
                                                                                                dd=[dic valueForKey:@"feedBackTypeTable"];
                                                                                              [webFeedTypeArray addObject:[dd valueForKey:@"feedbackType"]] ;
                                                                                                
                                                                                            }
                                                                                            [webFeedCountArray addObject:[dic valueForKey:@"count"]];
                                                                                            i++;
                                                                                        }
                                                                                       

                                                                                        NSLog(@"%lu",(unsigned long)webFeedCountArray.count);
                                                                                        NSLog(@"%lu",(unsigned long)webFeedTypeArray.count);

                                                                                    }
                                                                                    
                                                                                }];
                                                [datatask resume];

                                                    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{

                                                    //MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                                                      //  MBProgressHUD *hud = [[MBProgressHUD alloc]init];
                                                        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];

                                                    hud.label.text = NSLocalizedString(@"Please wait...", @"HUD Loading title");
                                                  // Will look best, if we set a minimum size.
                                                   hud.minSize = CGSizeMake(150.f, 100.f);
                                                   
                                                   // dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
                                                        // Do something useful in the background and update the HUD periodically.
                                                        [self pushToHomeView];
                                                       dispatch_async(dispatch_get_main_queue(), ^{
                                                           [hud hideAnimated:YES];
                                                       });
                                                    });
                                                
                                                // Set some text to show the initial status.
                                               
                                            }
                                           // }
                                        }];
        [datatask resume];
        
        
//
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
//        
//        // Set some text to show the initial status.
//        hud.label.text = NSLocalizedString(@"Please wait...", @"HUD Loading title");
//        // Will look best, if we set a minimum size.
//        hud.minSize = CGSizeMake(150.f, 100.f);
//        
//        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
//            // Do something useful in the background and update the HUD periodically.
//            [self pushToHomeView];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [hud hideAnimated:YES];
//            });
//        });
    
  */
    }

}


-(void)pushToHomeView
{
    if ([rememberMeButton isSelected])
    {
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"rememberMe"];
        
    }
    else
    {
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"rememberMe"];
    }
    
//    SWRevealViewController * vc = (SWRevealViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
//
//    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)pushToCompanyNamesView
{
    if ([rememberMeButton isSelected])
    {
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"rememberMe"];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"rememberMe"];
    }
    
    UIViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CompanyNamesViewController"];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end


