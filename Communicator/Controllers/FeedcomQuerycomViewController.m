//
//  FeedbackDetailViewController.m
//  Communicator
//
//  Created by mac on 29/03/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import "FeedcomQuerycomViewController.h"
#import "FeedOrQueryMessageHeader.h"
#import "HomeViewController.h"
#import "CreateNewFeedbackViewController.h"
@interface FeedcomQuerycomViewController ()

@property (strong, nonatomic) UISearchController *searchController;
@property (nonatomic, strong) NSArray *search;
@property(nonatomic, weak) id< UISearchControllerDelegate > delegate;


@end

@implementation FeedcomQuerycomViewController
@synthesize results;
@synthesize searchController;
@synthesize feedTypeSONoArray;
@synthesize feedTypeSONoCopyForPredicate;
@synthesize cerateNewFeedbackOrQueryButton;
@synthesize window;
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [self setSearchController];
}
-(void)setSearchController
{
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    searchController.searchResultsUpdater = self;
    searchController.searchBar.delegate = self;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.definesPresentationContext = YES;
    self.searchController.obscuresBackgroundDuringPresentation = NO;
    self.searchController.hidesNavigationBarDuringPresentation=NO;
    self.definesPresentationContext = YES;
}
-(void)viewWillAppear:(BOOL)animated
{
    [self setNavigationBar];
    [self prepareForSearchBar];
    
//    
//    UIWindow *window2 = [[UIWindow alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-60, self.view.bounds.size.height-100, 50, 50)];
//    window2.backgroundColor = [UIColor redColor];
//    window2.windowLevel = UIWindowLevelAlert;
//    self.window = window2;
//    [window2 makeKeyAndVisible];
}

-(void)setNavigationBar
{
    self.tabBarController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BackArrow"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewController)] ;
    self.tabBarController.navigationItem.rightBarButtonItem = nil;
    self.tabBarController.navigationItem.leftBarButtonItem.tintColor=[UIColor whiteColor];
   // Database *db=[Database shareddatabase];
    //NSString* username = [[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"];
   // NSString* companyId=[db getCompanyId:username];
//    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"flag"] isEqual:@"0"])
//    {
        self.tabBarController.navigationItem.title = @"FeedCom";
   // }
//    
//    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"flag"] isEqual:@"1"])
//    {
//        self.tabBarController.navigationItem.title = @"QueryCom";
//    }
//    
//    if ([companyId isEqual:@"1"] && [[[NSUserDefaults standardUserDefaults] valueForKey:@"flag"] isEqual:@"0"])
//    {
//        [cerateNewFeedbackOrQueryButton setHidden:YES];
//    }
//    else
//    {
//        if (!([companyId isEqual:@"1"]) && [[[NSUserDefaults standardUserDefaults] valueForKey:@"flag"] isEqual:@"1"])
//        {
//            [cerateNewFeedbackOrQueryButton setHidden:YES];
//        }
//        else
//        [cerateNewFeedbackOrQueryButton setHidden:NO];
//    }

}

-(void)prepareForSearchBar
{
    arrayOfSeperatedSOArray=[[NSMutableArray alloc]init];
    AppPreferences* app=[AppPreferences sharedAppPreferences];
    feedTypeSONoArray=[[NSMutableArray alloc]init];
    feedTypeSONoCopyForPredicate=[[NSMutableArray alloc]init];
    for (int i=0; i<app.feedQueryMessageHeaderArray.count; i++)
    {
        FeedOrQueryMessageHeader *headerObj=[app.feedQueryMessageHeaderArray objectAtIndex:i];
        [feedTypeSONoArray addObject:headerObj];
        [feedTypeSONoCopyForPredicate addObject:headerObj];
    }
    
}
-(void)popViewController
{
    UINavigationController *navController = self.navigationController;

    [navController popViewControllerAnimated:YES];
}


- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    if ([self.searchController.searchBar.text isEqual:@""])
    {
        FeedOrQueryMessageHeader *Obj1=[[FeedOrQueryMessageHeader alloc]init];
        int i,j;
        feedTypeSONoArray=[[NSMutableArray alloc]init];
        for (i=0,j=0; i<feedTypeSONoCopyForPredicate.count; i++,j=j+2)
        {
            Obj1= [feedTypeSONoCopyForPredicate objectAtIndex:i];
            NSLog(@"%@",Obj1.soNumber);
            [feedTypeSONoArray insertObject:Obj1 atIndex:i];
            [self.tableView reloadData];
        }
    }
    else
    {
        feedTypeSONoArray=[[NSMutableArray alloc]init];
        NSArray *predicateResultArray =[[NSMutableArray alloc]init];
        
        NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"soNumber CONTAINS [cd] %@", self.searchController.searchBar.text];
        NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"feedText CONTAINS [cd] %@", self.searchController.searchBar.text];

        NSPredicate *mainPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[predicate1, predicate2]];

        predicateResultArray =[feedTypeSONoCopyForPredicate filteredArrayUsingPredicate:mainPredicate];
        
        feedTypeSONoArray= [NSMutableArray arrayWithArray:predicateResultArray];
        [self.tableView reloadData];
    }
}

#pragma mark - table view data source and delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return feedTypeSONoArray.count;
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return NULL;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        FeedOrQueryMessageHeader *headerObj1=[feedTypeSONoArray objectAtIndex:indexPath.row];
        NSString* soNumber= headerObj1.soNumber;
        NSArray* separatedSO=[soNumber componentsSeparatedByString:@"#@"];
        UILabel* soNoLabel=(UILabel*)[cell viewWithTag:12];
        soNoLabel.text=[NSString stringWithFormat:@"SO No.%@ \nAvaya Id:%@ \nDocument Id:%@",[separatedSO objectAtIndex:0],[separatedSO objectAtIndex:1],[separatedSO objectAtIndex:2]];
        UILabel* feedbackLabel=(UILabel*)[cell viewWithTag:15];
        NSString *feedBackString =  [self stringByStrippingHTML:headerObj1.feedText];
        feedbackLabel.text= feedBackString;
        NSArray *components1 = [headerObj1.feedDate componentsSeparatedByString:@"+"];
        NSArray* dateAndTimeArray= [components1[0] componentsSeparatedByString:@" "];
        UILabel* dateAndTimeLabel=(UILabel*)[cell viewWithTag:13];
        dateAndTimeLabel.text=[NSString stringWithFormat:@"%@ %@",dateAndTimeArray[0],dateAndTimeArray[1]];
    
        UILabel* createdByLabel=(UILabel*)[cell viewWithTag:16];
        createdByLabel.text=[NSString stringWithFormat:@"Initiated by: %@ %@",headerObj1.firstname,headerObj1.lastname];

        UILabel* closedByLabel=(UILabel*)[cell viewWithTag:17];

    if (headerObj1.statusId==2)
    {
        closedByLabel.text=[NSString stringWithFormat:@"Closed by: %@ %@",headerObj1.firstname,headerObj1.lastname];
        //Database* db=[Database shareddatabase];
      // NSString* firstNameLastName =[db getClosedByUserName:headerObj1.feedbackType andsoNumber:headerObj1.soNumber];
    }
    else
        closedByLabel.text=@"";
  
    
        return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Database *db=[Database shareddatabase];

    FeedOrQueryMessageHeader *headerObj1=[feedTypeSONoArray objectAtIndex:indexPath.row];
    int feedType=headerObj1.feedbackType;
    NSString* SONumber=headerObj1.soNumber;
    
    [db getDetailMessagesofFeedbackOrQuery:feedType :SONumber];
    
   UIViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailChatingViewController"];
    
   [self.navigationController pushViewController:vc animated:YES];

}

-(NSString *) stringByStrippingHTML:(NSString *) stringWithHtmlTags
{
    NSRange r;
    while ((r = [stringWithHtmlTags rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        stringWithHtmlTags = [stringWithHtmlTags stringByReplacingCharactersInRange:r withString:@""];
    return stringWithHtmlTags;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (IBAction)buttonClicked:(id)sender
{
    UINavigationController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateNewFeedbackNavigationController"];
    NSArray* arr=   vc.childViewControllers;
    CreateNewFeedbackViewController* vcc=   [arr objectAtIndex:0];
    vcc.feedbackType=self.feedbackType;
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    //CGSize size = [UIScreen mainScreen].bounds.size;
   // NSLog(@"width=%f height=%f",size.width,size.height);
    //UIInterfaceOrientationPortrait
// if(fromInterfaceOrientation ==UIInterfaceOrientationPortrait)
//    {
//        UIWindow *window2 = [[UIWindow alloc] initWithFrame:CGRectMake(size.width-60, size.height-100, 50, 50)];
//        window2.backgroundColor = [UIColor redColor];
//        window2.windowLevel = UIWindowLevelAlert;
//        window2.hidden=NO;
//        self.window = window2;
//        [window2 makeKeyAndVisible];
//
//    }
   }
@end
