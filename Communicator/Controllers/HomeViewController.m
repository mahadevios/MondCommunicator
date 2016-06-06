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
#import "FeedcomQuerycomViewController.h"
#import "CounterGraph.h"

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
@synthesize referenceViewForCounterGraph;
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

    AppPreferences* app=[AppPreferences sharedAppPreferences];
self.tabBarController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"SignOut"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewController1)] ;
    self.tabBarController.navigationItem.title = @"Dashboard";
    [self.navigationItem setHidesBackButton:NO];
    self.navigationController.navigationBar.barTintColor = [UIColor communicatorColor];
    self.tabBarController.navigationItem.leftBarButtonItem.tintColor=[UIColor whiteColor];


  }

-(void)setSelectedSegment
{
   NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];
    [defaults setValue:@"0" forKey:@"flag"];
    
}

-(void)popViewController1
{
    UINavigationController *navController = self.navigationController;
    UIViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginNaviagationController"];
    [navController presentViewController:vc animated:YES completion:nil];
    NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:NULL forKey:@"userObject"];
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
    AppPreferences* app=[AppPreferences sharedAppPreferences];
    feedTypeArray=[[NSMutableArray alloc]init];
    feedTypeCopyForPredicate=[[NSMutableArray alloc]init];
    
    FeedQueryCounter *ft2=[[FeedQueryCounter alloc]init];
  //  Database *database=[Database shareddatabase];
   // app.getFeedbackAndQueryTypesArray = [database getFeedbackAndQueryTypes];
    
    NSLog(@"%ld",app.feedQueryCounterDictsWithTypeArray.count);
    for (int i=0; i<app.feedQueryCounterDictsWithTypeArray.count; i++)
    {
        
        ft2= [app.feedQueryCounterDictsWithTypeArray objectAtIndex:i];
        NSLog(@"%@",ft2.feedbackType);
        
        [feedTypeArray insertObject:ft2.feedbackType atIndex:i];
        
        [feedTypeCopyForPredicate insertObject:ft2.feedbackType atIndex:i];
        //        FeedbackType *ft2=[getFeedbackAndQueryTypesArray objectAtIndex:i];
        //
        //        [feedTypeArray insertObject:ft2.feedbacktype atIndex:ft2.Id];
        //       [feedTypeCopyForPredicate insertObject:ft1.feedbacktype atIndex:ft2.Id];
        
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
    AppPreferences* app=[AppPreferences sharedAppPreferences];

    
    if ([self.searchController.searchBar.text isEqual:@""])
    {
        FeedQueryCounter *ft2=[[FeedQueryCounter alloc]init];
        int i;
        feedTypeArray=[[NSMutableArray alloc]init];
        for (i=0; i<app.feedQueryCounterDictsWithTypeArray.count; i++)
        {
            ft2= [app.feedQueryCounterDictsWithTypeArray objectAtIndex:i];
            NSLog(@"%@",ft2.feedbackType);
            [feedTypeArray insertObject:ft2.feedbackType atIndex:i];

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
    //AppPreferences* app=[AppPreferences sharedAppPreferences];
   return feedTypeArray.count;
}
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Remove the row from data model
//    [labelArray removeObjectAtIndex:indexPath.row];
//    
//    // Request table view to reload
//    [tableView reloadData];
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppPreferences *apppreferences=[AppPreferences sharedAppPreferences];
   
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
   counterGraphLabel=[cell viewWithTag:111];
    referenceViewForCounterGraph=[cell viewWithTag:112];

    UILabel* feedbackAndQueryTypeLabel=(UILabel*)[cell viewWithTag:12];
    feedbackAndQueryTypeLabel.text=[feedTypeArray objectAtIndex:indexPath.row];
    
    FeedQueryCounter* feedCounterObj = [apppreferences.feedQueryCounterDictsWithTypeArray objectAtIndex:indexPath.row];

   
    NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];
    //NSLog(@"%@",[defaults valueForKey:@"flag"]);
    int f=[[defaults valueForKey:@"flag"]intValue];
    if (f == 0)
    {
        counter = feedCounterObj.feedCounter;
    }
    else
    {
        counter = feedCounterObj.queryCounter;
        
    }
    
    
    
    
    UILabel* countLabel=(UILabel*)[cell viewWithTag:13];
    //FeedbackType* ff=[feedTypeArray objectAtIndex:indexPath.row];
    

   // NSLog(@"%d",feedCounterObj.queryCounter);
   // NSLog(@"%d",feedCounterObj.feedCounter);

        NSLog(@"%ld",indexPath.row);
   counterGraphLabel.text=[NSString stringWithFormat:@"%ld",counter];
  float cellHeight=  [self tableView:tableView heightForRowAtIndexPath:indexPath];

   // [self createGraph:counter];
   
//     counterGraphLabel = [[UILabel alloc] initWithFrame:CGRectMake(tableView.frame.origin.x+([UIScreen mainScreen].bounds.size.width/2)+1,5,20*(counter),cellHeight-10)];
//    NSLog(@"%ld",counter);
//    [counterGraphLabel setText:[NSString stringWithFormat:@"%ld",counter]];
//  //  [counterGraphLabel setTextAlignment:UITextAlignmentRight];
//    [counterGraphLabel setFont: [UIFont fontWithName:@"Arial" size:13.0f]];
//    [counterGraphLabel setBackgroundColor:[UIColor communicatorColor]];
//    [counterGraphLabel setTextColor:[UIColor whiteColor]];
//    
//    [labelArray addObject:counterGraphLabel];
//    [cell addSubview:counterGraphLabel];
     //counterGraphLabel=nil;

    CounterGraph* counterGraphObj=[[CounterGraph alloc]init];
    counterGraphObj.counterGraphlabel=counterGraphLabel;
    counterGraphObj.referenceForCounterGraphView=referenceViewForCounterGraph;
    counterGraphObj.count=counter;
    counterGraphLabel.backgroundColor = [UIColor communicatorColor];
    [counterGraphLabel setFrame:CGRectMake(counterGraphLabel.frame.origin.x, counterGraphLabel.frame.origin.y, 0.0f, counterGraphLabel.frame.size.height)];

    [self performSelector:@selector(setCounterGraphLabel:) withObject:counterGraphObj afterDelay:0.000001];
    return cell;
    
}



-(void)setCounterGraphLabel:(CounterGraph*)counterGraphObj
{

    
  /*  NSLayoutConstraint *widt =[NSLayoutConstraint
                                   constraintWithItem:counterGraphObj.counterGraphlabel
                                   attribute:NSLayoutAttributeWidth
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:counterGraphObj.referenceForCounterGraphView
                                   attribute:NSLayoutAttributeWidth
                                   multiplier:counterGraphObj.count
                                   constant:0.f];*/
   
    

    [UIView animateWithDuration:0.5
                          delay:0.001
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
[counterGraphObj.counterGraphlabel setFrame:CGRectMake(counterGraphObj.counterGraphlabel.frame.origin.x, counterGraphObj.counterGraphlabel.frame.origin.y, counterGraphObj.count * 10, counterGraphObj.counterGraphlabel.frame.size.height)];                     }
                     completion:^(BOOL finished){
                         NSLog(@"Done!");
                     }];
    
   // [counterGraphObj.counterGraphlabel addConstraint:widt];
}




-(void)createGraph:(long)count
{
counterGraphLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.tableView.frame.origin.x+([UIScreen mainScreen].bounds.size.width/2)+1,5,20*(count),25)];

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
    
    FeedcomQuerycomViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FeedcomQuerycomViewController"];
    vc.feedbackType=[feedTypeArray objectAtIndex:indexPath.row];
    //NSLog(@"%lu",(unsigned long)app.feedQueryMessageHeaderArray.count);
    
  [self.navigationController pushViewController:vc animated:YES];
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
