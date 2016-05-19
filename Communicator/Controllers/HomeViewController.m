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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setSelectedButton:feedComButton];

    [self createBarButtonItems];
   // [self createSWRevealView];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [self feedbackAndQuerySearch];
    
    Database *db=[Database shareddatabase];
        
//    
//    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"logout"])
//    {
//        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"logout"];
//    }    // Override point for customization after application launch.
//    
   }
-(void)viewWillAppear:(BOOL)animated
{
    
}

-(void)setSelectedSegment
{
   NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];
    [defaults setValue:@"0" forKey:@"flag"];
    
}

-(void)createBarButtonItems
{

//    menuBarButton=    [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"SliderMenu"] style:NULL target:NULL action:NULL];
//    
//    self.navigationItem.leftBarButtonItem = menuBarButton;
    
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(flipview:)];
    self.navigationItem.rightBarButtonItem = btn;
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    AppPreferences *apppreferences=[AppPreferences sharedAppPreferences];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    UILabel* serialNoLabel=(UILabel*)[cell viewWithTag:11];
    serialNoLabel.text=[NSString stringWithFormat:@"%ld", (long)indexPath.row+1];
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
    
   // long feedbackOrQueryType=feedCounterObj.feedbackTypeId;
    
    NSString *counts=[NSString stringWithFormat:@"%ld",counter];
    
    countLabel.text=[NSString stringWithFormat:@"%@",counts];
    
    NSLog(@"%@",countLabel.text);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)indexPath.row);
    
    
    
    Database *db=[Database shareddatabase];
    [db setDatabaseToCompressAndShowTotalQueryOrFeedback:indexPath.row];
    
    UIViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FeedcomQuerycomViewController"];
    
    //NSLog(@"%lu",(unsigned long)app.feedQueryMessageHeaderArray.count);
    
    [self.navigationController pushViewController:vc animated:YES];
    //self.selectedIndexPath=indexPath;
}


- (IBAction)changeType:(id)sender
{
    
//    long i=[sender selectedSegmentIndex];     
//    if(i==0)
//    {
//        NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];
//        [defaults setValue:@"0" forKey:@"flag"];
//        
//        chatTypeLabel.text = @"Feedback Type";
//        selectedFeedbackType = 0;
//        [self.tableView reloadData];
//    }
//    if (i==1)
//    {
//        
//        NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];
//        [defaults setValue:@"1" forKey:@"flag"];
//
//        selectedFeedbackType = 1;
//        chatTypeLabel.text = @"Query Type";
//        [self.tableView reloadData];
//    }
}


//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
//{
//    feedTypeArray = [(NSArray *)object valueForKey:@"feedTypeArray"];
//    
//    [self.tableView reloadData];
//    //
//    //    id a=[object valueForKey:@"selectedIndexPath"];
//    //    NSLog(@"%@",a);
//}

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
    NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];
   [defaults setObject:@"0" forKey:@"flag"];
   [defaults synchronize];
    selectedFeedbackType = 0;
}



- (IBAction)buttonClicked:(id)sender
{
    [self setSelectedButton:sender];
}
-(void)setSelectedButton:(id)sender
{
    if (sender==feedComButton)
    {
        [queryComButton setSelected:NO];
        [sender setSelected: YES];
        [sender setTitleColor:[UIColor colorWithRed:10/255.0 green:32/255.0 blue:47/255.0 alpha:1] forState:UIControlStateSelected];
        
        NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];
        [defaults setValue:@"0" forKey:@"flag"];
        [self.tableView reloadData];
        
    }
    
    if (sender==queryComButton)
    {
        [feedComButton setSelected:NO];
        [sender setSelected: YES];
        [sender setTitleColor:[UIColor colorWithRed:10/255.0 green:32/255.0 blue:47/255.0 alpha:1] forState:UIControlStateSelected];
        
        NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];
        [defaults setValue:@"1" forKey:@"flag"];
        [self.tableView reloadData];
        
        
    }

}
@end
