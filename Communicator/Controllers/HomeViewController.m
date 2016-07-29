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

@synthesize feedTypeArray;
@synthesize feedTypeCopyForPredicate;
@synthesize searchController;
@synthesize demoCountArray;
@synthesize counterGraphLabel,counterGraphLabel1;
@synthesize referenceViewForCounterGraph;
@synthesize tableView;
- (void)viewDidLoad
{
    [super viewDidLoad];
   // [self setSelectedButton:feedComButton];

   // [self createSWRevealView];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [self feedbackAndQuerySearch];
    
        labelArray=[[NSMutableArray alloc]init];

   }
-(void)viewWillAppear:(BOOL)animated
{
   self.tabBarController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"SignOut"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewController1)] ;
    self.tabBarController.navigationItem.title = @"Dashboard";
    [self.navigationItem setHidesBackButton:NO];
    self.navigationController.navigationBar.barTintColor = [UIColor communicatorColor];
    self.tabBarController.navigationItem.leftBarButtonItem.tintColor=[UIColor whiteColor];
    self.tabBarController.navigationItem.rightBarButtonItem=nil;
   

    [tableView reloadData];
    
   
}

-(void)popViewController1
{
    UINavigationController *navController = self.navigationController;
    UIViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginNaviagationController"];
    [navController presentViewController:vc animated:YES completion:nil];
    NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:NULL forKey:@"userObject"];
    [defaults setObject:NULL forKey:@"selectedCompany"];

}



-(void)flipview:id
{
    NSLog(@"tapped");
    UIViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ComposeFeedbackOrQueryViewController"];
    
    //[self.navigationController pushViewController:vc animated:YES];
    [self.navigationController presentViewController:vc animated:YES completion:nil];

    }

//-(void)createSWRevealView
//{
//    SWRevealViewController *revealViewController = self.revealViewController;
//    if ( revealViewController )
//    {
//        [menuBarButton setTarget: self.revealViewController];
//        [menuBarButton setAction: @selector( revealToggle: )];
//        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
//    }     // Do any additional setup after loading the view.
//}

#pragma marks-feedbackOrQuerySearch


-(void)feedbackAndQuerySearch
{
    AppPreferences* app=[AppPreferences sharedAppPreferences];
    feedTypeArray=[[NSMutableArray alloc]init];
    app.sampleFeedtypeArray=[[NSMutableArray alloc]init];

    app.samplefeedTypeCopyForPredicate=[[NSMutableArray alloc]init];
    
    FeedQueryCounter *ft2=[[FeedQueryCounter alloc]init];
     NSLog(@"%ld",app.feedQueryCounterDictsWithTypeArray.count);
    
    for (int i=0; i<app.feedQueryCounterDictsWithTypeArray.count; i++)
    {
        
        ft2= [app.feedQueryCounterDictsWithTypeArray objectAtIndex:i];
        NSLog(@"%@",ft2.feedbackType);
        
        [app.sampleFeedtypeArray insertObject:ft2 atIndex:i];
        //[app.sampleFeedtypeArray insertObject:ft2.feedbackType atIndex:i];
        
        [app.samplefeedTypeCopyForPredicate insertObject:ft2 atIndex:i];
      
    }
    
    searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    searchController.searchResultsUpdater = self;
    searchController.searchBar.delegate = self;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.definesPresentationContext = YES;
    self.searchController.obscuresBackgroundDuringPresentation = NO;
    self.searchController.hidesNavigationBarDuringPresentation=NO;     // default is YES
    
}


- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"feedbackType CONTAINS [cd] %@", self.searchController.searchBar.text];
    NSArray *predicateResultArray;
    AppPreferences* app=[AppPreferences sharedAppPreferences];

    
    if ([self.searchController.searchBar.text isEqual:@""])
    {
        FeedQueryCounter *ft2=[[FeedQueryCounter alloc]init];
        int i;
        app.sampleFeedtypeArray=[[NSMutableArray alloc]init];
        for (i=0; i<app.feedQueryCounterDictsWithTypeArray.count; i++)
        {
            ft2= [app.feedQueryCounterDictsWithTypeArray objectAtIndex:i];
            NSLog(@"%@",ft2.feedbackType);
            [app.sampleFeedtypeArray insertObject:ft2 atIndex:i];

            [self.tableView reloadData];
        }
    }
    else
    {
        app.sampleFeedtypeArray=[[NSMutableArray alloc]init];
        predicateResultArray=[[NSMutableArray alloc]init];
        predicateResultArray =[app.samplefeedTypeCopyForPredicate filteredArrayUsingPredicate:predicate];
        app.sampleFeedtypeArray=[predicateResultArray mutableCopy];
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
    AppPreferences *app=[AppPreferences sharedAppPreferences];
      return app.sampleFeedtypeArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableview cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppPreferences *app=[AppPreferences sharedAppPreferences];
   
    UITableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    referenceViewForCounterGraph=[cell viewWithTag:112];
    NSLog(@"%d",indexPath.row);

    NSLog(@"%@",cell);

    UILabel* feedbackAndQueryTypeLabel=(UILabel*)[cell viewWithTag:12];
    FeedQueryCounter* feedCounterObj = [app.sampleFeedtypeArray objectAtIndex:indexPath.row];
    feedbackAndQueryTypeLabel.text=feedCounterObj.feedbackType;
    
    counter = feedCounterObj.openCounter;
    totalCounter = feedCounterObj.totalCounter;
    closedCounter=feedCounterObj.closedCounter;

    UILabel* countLabel=(UILabel*)[cell viewWithTag:113];
    if (counter>12)
    {
        countLabel.text=@"12+";
    }
    else
    countLabel.text=[NSString stringWithFormat:@"%ld", counter];
   
    counterGraphLabel=[cell viewWithTag:111];

       
    if (counter>6)
    {
        counterGraphLabel.text=@"6+";
    }
    else
    counterGraphLabel.text=[NSString stringWithFormat:@"%ld",totalCounter];
    counterGraphLabel.backgroundColor = [UIColor communicatorColor];
    counterGraphLabel.textColor = [UIColor communicatorColor];
    
    counterGraphLabel1=[cell viewWithTag:120];
    if (closedCounter>6)
    {
        counterGraphLabel.text=@"6+";
    }
    else
    counterGraphLabel1.text=[NSString stringWithFormat:@"%ld",totalCounter];
    counterGraphLabel1.backgroundColor = [UIColor redColor];
    counterGraphLabel1.textColor = [UIColor redColor];
    
    CounterGraph* counterGraphObj=[[CounterGraph alloc]init];
    counterGraphObj.counterGraphlabel=counterGraphLabel;
    counterGraphObj.counterGraphlabel1=counterGraphLabel1;

    //counterGraphObj.referenceForCounterGraphView=referenceViewForCounterGraph;
    counterGraphObj.count=counter;
    counterGraphObj.count1=closedCounter;
    
    [counterGraphLabel setFrame:CGRectMake(counterGraphLabel.frame.origin.x, counterGraphLabel.frame.origin.y, 0.0f, counterGraphLabel.frame.size.height)];
    [counterGraphLabel1 setFrame:CGRectMake(counterGraphLabel1.frame.origin.x, counterGraphLabel1.frame.origin.y, 0.0f, counterGraphLabel1.frame.size.height)];

    [self performSelector:@selector(setCounterGraphLabel:) withObject:counterGraphObj afterDelay:0.000001];
    
    
    
    return cell;
    
}



-(void)setCounterGraphLabel:(CounterGraph*)counterGraphObj
{
    counterGraphObj.counterGraphlabel.adjustsFontSizeToFitWidth = false;

    
    [UIView animateWithDuration:0.5
                          delay:0.001
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         //counterGraphLabel.text=[NSString stringWithFormat:@"%ld",counter];
                         //counterGraphObj.count=7;
                         //counterGraphObj.count1=10;
                         long activeCountermaxWidth=counterGraphObj.count*10;
                         long closedCountermaxWidth=counterGraphObj.count1*10;

                         if ((counterGraphObj.count * 10+counterGraphObj.count * 10)>120)
                         {
                            activeCountermaxWidth= ((counterGraphObj.count * 10.0)/ (counterGraphObj.count * 10+counterGraphObj.count1 * 10))*120;
                            closedCountermaxWidth= ((counterGraphObj.count1 * 10.0)/ (counterGraphObj.count * 10+counterGraphObj.count1 * 10))*120;
                             NSLog(@"a=%ld c=%ld",activeCountermaxWidth,closedCountermaxWidth);

                         }
    [counterGraphObj.counterGraphlabel setFrame:CGRectMake(counterGraphObj.counterGraphlabel.frame.origin.x, counterGraphObj.counterGraphlabel.frame.origin.y, activeCountermaxWidth, counterGraphObj.counterGraphlabel.frame.size.height)];
                         
                         [counterGraphObj.counterGraphlabel1 setFrame:CGRectMake(counterGraphObj.counterGraphlabel.frame.origin.x+activeCountermaxWidth, counterGraphObj.counterGraphlabel1.frame.origin.y, closedCountermaxWidth, counterGraphObj.counterGraphlabel1.frame.size.height)];
                         
                        
                     }
                     completion:^(BOOL finished){
                     }];
    
}




//-(void)createGraph:(long)count
//{
//   counterGraphLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.tableView.frame.origin.x+([UIScreen mainScreen].bounds.size.width/2)+1,5,20*(count),25)];
//
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 38;

}
- (void)tableView:(UITableView *)tableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppPreferences *app=[AppPreferences sharedAppPreferences];
    
    UITableViewCell *selectedCell = [tableview cellForRowAtIndexPath:indexPath];
    UILabel* feedbackTypeLabel=(UILabel*)[selectedCell viewWithTag:12];

    Database *db=[Database shareddatabase];
    [db setDatabaseToCompressAndShowTotalQueryOrFeedback:feedbackTypeLabel.text];
    
    FeedcomQuerycomViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FeedcomQuerycomViewController"];
    FeedQueryCounter* obj=[app.sampleFeedtypeArray objectAtIndex:indexPath.row];
    vc.feedbackType=obj.feedbackType;

  [self.navigationController pushViewController:vc animated:YES];
}



- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


-(void)viewDidDisappear:(BOOL)animated
{
      [self.tableView reloadData];
}


//-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
//{
//    for (int i=0; i<labelArray.count; i++)
//    {
//        UILabel* lab=  (UILabel*)[labelArray objectAtIndex:i];
//        [lab removeFromSuperview];
//        [self.tableView reloadData];
//    }
//}


@end
