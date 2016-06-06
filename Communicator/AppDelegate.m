//
//  AppDelegate.m
//  Communicator
//
//  Created by mac on 19/03/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "MainTabBarViewController.h"
#import "Database.h"
#import "UIColor+CommunicatorColor.h"
#import "CompanyNamesViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize navController;
UIStoryboard *mainStoryboard;
UINavigationController *navigationController;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    AppPreferences* app=[AppPreferences sharedAppPreferences];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
  
    [ defaults setObject:@"0" forKey:@"flag"];
    //[[UINavigationBar appearance] setTranslucent:NO];

    //NSLog(@"%d",[[NSUserDefaults standardUserDefaults]boolForKey:@"rememberMe"]);

//    NSLog([NSUserDefaults boolForKey:@"rememberMe"]?@"YES":@"NO");
   // NSLog(@"%d",[[NSUserDefaults standardUserDefaults]boolForKey:@"logout"]);
    if (!([defaults valueForKey:@"userObject"] ==NULL))
    {
        

        
        Database* db=[Database shareddatabase];
       // [db getUserUsername:username andPassword:pass];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *data = [defaults objectForKey:@"userObject"];
        User* userObj = [NSKeyedUnarchiver unarchiveObjectWithData:data];

        NSString* companyName= [NSString stringWithFormat:@"%d",userObj.comanyId];
        NSLog(@"%d",userObj.comanyId);
        NSLog(@"%@",userObj.username);
        NSString* company= [db getCompanyIdFromCompanyName:companyName];//for local use to find companyname from company id
        app.companynameOrIdArray= [db findPermittedCompaniesForUsername:userObj.username Password:userObj.password];
       
        [db getFeedbackAndQueryCounterForCompany:company];
        
        if (app.companynameOrIdArray.count==1)
        {
            
        mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
              MainTabBarViewController *controller = (MainTabBarViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"MainTabBarViewController"];
       
                navigationController = (UINavigationController *)self.window.rootViewController;
        navigationController.navigationBar.barTintColor = [UIColor communicatorColor];

        [navigationController.navigationBar setBarStyle:UIStatusBarStyleLightContent];// to set carrier,time and battery color in white color
        
        NSDictionary *size = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Source Sans Pro" size:20.0],NSFontAttributeName, nil];
        
        navigationController.navigationBar.titleTextAttributes = size;
              [navigationController pushViewController:controller animated:NO];
            
            
        }
        else
        {
          
            mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            CompanyNamesViewController *controller = (CompanyNamesViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"CompanyNamesViewController"];
            
            navigationController = (UINavigationController *)self.window.rootViewController;
            navigationController.navigationBar.barTintColor = [UIColor communicatorColor];
            
            [navigationController.navigationBar setBarStyle:UIStatusBarStyleLightContent];// to set carrier,time and battery color in white color
            
            NSDictionary *size = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Source Sans Pro" size:20.0],NSFontAttributeName, nil];
            
            navigationController.navigationBar.titleTextAttributes = size;
            [navigationController pushViewController:controller animated:NO];
            

        
        }
        
    }
    [self checkAndCopyDatabase];
    
    return YES;
}


- (void) checkAndCopyDatabase
{
    NSString *destpath=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Communicator_DB.sqlite"];
    NSString *sourcepath=[[NSBundle mainBundle]pathForResource:@"Communicator_DB" ofType:@"sqlite"];
    if(![[NSFileManager defaultManager] fileExistsAtPath:destpath])
    {
        //   NSLog(@"inside");
        [[NSFileManager defaultManager] copyItemAtPath:sourcepath toPath:destpath error:nil];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
       // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    

    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
   // NSLog(@"%@",[[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"]);
   navigationController = (UINavigationController *)self.window.rootViewController;
  mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    NSLog(@"%d",[[NSUserDefaults standardUserDefaults]boolForKey:@"rememberMe"]);
    if (![[NSUserDefaults standardUserDefaults]boolForKey:@"rememberMe"])
    {
        NSLog(@"inside");
        LoginViewController *controller = (LoginViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"LoginViewController"];
        [navigationController pushViewController:controller animated:NO];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
