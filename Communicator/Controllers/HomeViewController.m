//
//  ViewController.m
//  Communicator
//
//  Created by mac on 26/03/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import "HomeViewController.h"
//#import "SWRevealViewController.h"
#import "SWMenuViewController.h"
#import "Database.h"
#import "feedQueryCounter.h"
#import "FeedOrQueryMessageHeader.h"
#import "UIColor+CommunicatorColor.h"


@interface HomeViewController ()
@property (strong, nonatomic) UISearchController *searchController;
@property (nonatomic, strong) NSArray *search;
@property(nonatomic, weak) id< UISearchControllerDelegate > delegate;
@property (strong, nonatomic) NSString *indexPath;

@end

@implementation HomeViewController

@synthesize chatTypeLabel;
@synthesize feedTypeArray;
@synthesize feedTypeCopyForPredicate;
@synthesize searchController;
@synthesize feedAndQueryComSegment;
@synthesize feedComButton;
@synthesize queryComButton;
@synthesize demoCountArray;
@synthesize counterGraphLabel;
@synthesize feedcomButtonUndelineView;
@synthesize querycomButtonUnderlineView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setSelectedButton:feedComButton];

    [self createBarButtonItems];
   // [self createSWRevealView];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [self feedbackAndQuerySearch];
    
    Database *db=[Database shareddatabase];
        labelArray=[[NSMutableArray alloc]init];
//
//    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"logout"])
//    {
//        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"logout"];
//    }    // Override point for customization after application launch.
//    
   }
-(void)viewWillAppear:(BOOL)animated
{
   //labelArray=[[NSMutableArray alloc]init];

    //[self setTitle:@"A"];
    self.tabBarController.navigationItem.title = @"Dashboard";
    [self.navigationItem setHidesBackButton:NO];
//self.navigationController.navigationController.navigationItem.title = @"Dashboard";
}

-(void)setSelectedSegment
{
   NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];
    [defaults setValue:@"0" forKey:@"flag"];
    
}

-(void)createBarButtonItems
{
    
//    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(flipview:)];
//    self.navigationItem.rightBarButtonItem = btn;
}

-(void)flipview:id
{
    NSLog(@"tapped");
    UIViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ComposeFeedbackOrQueryViewController"];
    
    //[self.navigationController pushViewController:vc animated:YES];
    [self.navigationController presentViewController:vc animated:YES completion:nil];

    }

-(void)createSWRevealView
{
//    SWRevealViewController *revealViewController = self.revealViewController;
//    if ( revealViewController )
//    {
//        [menuBarButton setTarget: self.revealViewController];
//        [menuBarButton setAction: @selector( revealToggle: )];
//        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
//    }     // Do any additional setup after loading the view.
}


#pragma marks-feedbackOrQuerySearch

-(void)feedbackAndQuerySearch
{
    feedTypeArray=[[NSMutableArray alloc]init];
    feedTypeCopyForPredicate=[[NSMutableArray alloc]init];
    
    FeedbackType *ft1=[[FeedbackType alloc]init];
    
    Database *database=[Database shareddatabase];
    getFeedbackAndQueryTypesArray = [database getFeedbackAndQueryTypes];
    
    for (int i=0; i<getFeedbackAndQueryTypesArray.count; i++)
    {
        ft1= [getFeedbackAndQueryTypesArray objectAtIndex:i];
        NSLog(@"%@",ft1.feedbacktype);
        [feedTypeArray insertObject:ft1.feedbacktype atIndex:i];
        [feedTypeCopyForPredicate insertObject:ft1.feedbacktype atIndex:i];
    }
    
    //    searchResults = (HomeViewController *)self.searchController;
    searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    searchController.searchResultsUpdater = self;
    searchController.searchBar.delegate = self;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.definesPresentationContext = YES;
    self.searchController.obscuresBackgroundDuringPresentation = NO;
    self.searchController.hidesNavigationBarDuringPresentation=NO;     // default is YES
    
    //[self addObserver:searchResults forKeyPath:@"feedTypeArray" options:NSKeyValueObservingOptionNew context:nil];
    //[self addObserver:self forKeyPath:@"selectedIndexPath" options:NSKeyValueObservingOptionNew context:NULL];

}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"SELF contains [cd] %@", self.searchController.searchBar.text];
    NSArray *predicateResultArray;
    
    
    if ([self.searchController.searchBar.text isEqual:@""])
    {
        FeedbackType *ft1=[[FeedbackType alloc]init];
        int i;
        feedTypeArray=[[NSMutableArray alloc]init];
        for (i=0; i<getFeedbackAndQueryTypesArray.count; i++)
        {
            ft1= [getFeedbackAndQueryTypesArray objectAtIndex:i];
            NSLog(@"%@",ft1.feedbacktype);
            [feedTypeArray insertObject:ft1.feedbacktype atIndex:i];
            [self.tableView reloadData];
        }
    }
    else
    {
        feedTypeArray=[[NSMutableArray alloc]init];
        predicateResultArray=[[NSMutableArray alloc]init];
        predicateResultArray =[feedTypeCopyForPredicate filteredArrayUsingPredicate:predicate];
        feedTypeArray=[predicateResultArray mutableCopy];
        [self.tableView reloadData];
    }
}

#pragma mark-table view data Source and Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return feedTypeArray.count;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove the row from data model
    [labelArray removeObjectAtIndex:indexPath.row];
    
    // Request table view to reload
    [tableView reloadData];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    AppPreferences *apppreferences=[AppPreferences sharedAppPreferences];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

   
    UILabel* feedbackAndQueryTypeLabel=(UILabel*)[cell viewWithTag:12];
    feedbackAndQueryTypeLabel.text=[feedTypeArray objectAtIndex:indexPath.row];
    
    
    UILabel* countLabel=(UILabel*)[cell viewWithTag:13];
    
    FeedQueryCounter* feedCounterObj = [[apppreferences feedQueryCounterArray] objectAtIndex:indexPath.row];
    
    long counter;
    NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];
    NSLog(@"%@",[defaults valueForKey:@"flag"]);
    int f=[[defaults valueForKey:@"flag"]intValue];
    if (f == 0)
    {
        counter = feedCounterObj.feedCounter;
    }
    else
    {
        counter = feedCounterObj.queryCounter;
        
    }
  float cellHeight=  [self tableView:tableView heightForRowAtIndexPath:indexPath];

    counterGraphLabel = [[UILabel alloc] initWithFrame:CGRectMake(tableView.frame.origin.x+([UIScreen mainScreen].bounds.size.width/2)+1,5,20*(counter),cellHeight-10)];

    [counterGraphLabel setText:[NSString stringWithFormat:@"%ld",counter]];
    [counterGraphLabel setTextAlignment:UITextAlignmentRight];
    [counterGraphLabel setFont: [UIFont fontWithName:@"Arial" size:13.0f]];
    [counterGraphLabel setBackgroundColor:[UIColor communicatorColor]];
    [counterGraphLabel setTextColor:[UIColor whiteColor]];
    [cell addSubview:counterGraphLabel];
    [labelArray addObject:counterGraphLabel];
    return cell;

    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 38;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)indexPath.row);
    
    
    
    Database *db=[Database shareddatabase];
    [db setDatabaseToCompressAndShowTotalQueryOrFeedback:indexPath.row];
    
    UIViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FeedcomQuerycomViewController"];
    
    //NSLog(@"%lu",(unsigned long)app.feedQueryMessageHeaderArray.count);
    
    [self.navigationController.navigationController pushViewController:vc animated:YES];
    //self.selectedIndexPath=indexPath;
}



- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewDidDisappear:(BOOL)animated
{
   // NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];
  // [defaults setObject:@"0" forKey:@"flag"];
   //[defaults synchronize];
   // selectedFeedbackType = 0;
    [self.tableView reloadData];
}

- (IBAction)buttonClicked:(id)sender
{
       [self setSelectedButton:sender];
}

-(void)setSelectedButton:(id)sender
{

    if (sender==feedComButton)
    {

        for (int i=0; i<labelArray.count; i++)
        {
            UILabel* lab=  (UILabel*)[labelArray objectAtIndex:i];
            [lab removeFromSuperview];
           
        }
        querycomButtonUnderlineView.hidden=YES;
        feedcomButtonUndelineView.hidden=NO;

        [queryComButton setSelected:NO];
        [sender setSelected: YES];
        [sender setTitleColor:[UIColor colorWithRed:10/255.0 green:32/255.0 blue:47/255.0 alpha:1] forState:UIControlStateSelected];
        
        NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];
        [defaults setValue:@"0" forKey:@"flag"];
        [self.tableView reloadData];
        
    }
    
    if (sender==queryComButton)
    {

        for (int i=0; i<labelArray.count; i++)
        {
            UILabel* lab=  (UILabel*)[labelArray objectAtIndex:i];
            [lab removeFromSuperview];
            
        }
        feedcomButtonUndelineView.hidden=YES;
        querycomButtonUnderlineView.hidden=NO;

        [feedComButton setSelected:NO];
        [sender setSelected: YES];
        [sender setTitleColor:[UIColor colorWithRed:9/255.0 green:45/255.0 blue:61/255.0 alpha:1] forState:UIControlStateSelected];
        
        NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];
        [defaults setValue:@"1" forKey:@"flag"];
        [self.tableView reloadData];
        
        
    }

}


-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    for (int i=0; i<labelArray.count; i++)
    {
        UILabel* lab=  (UILabel*)[labelArray objectAtIndex:i];
        [lab removeFromSuperview];
        [self.tableView reloadData];
    }
}


@end
