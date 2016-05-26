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
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createBarButtonItem];
//    SWRevealViewController *revealViewController = self.revealViewController;
//    if ( revealViewController )
//    {
//        [menuBarButton setTarget: self.revealViewController];
//        [menuBarButton setAction: @selector( revealToggle: )];
//       // [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
//    }     // Do any additional setup after loading the view.
//    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];

    results=[NSArray arrayWithObjects:@"11",@"12",@"13",@"14",@"15",nil];
    searchResults = (FeedcomQuerycomViewController *)self.searchController;

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

    [self addObserver:searchResults forKeyPath:@"results" options:NSKeyValueObservingOptionNew context:nil];

}

-(void)viewWillAppear:(BOOL)animated
{
//    self.tabBarController.navigationItem.hidesBackButton=NO;
    //[self.navigationItem setHidesBackButton:NO];
    self.navigationItem.title = @"FeedCom";

    arrayOfSeperatedSOArray=[[NSMutableArray alloc]init];
    AppPreferences* app=[AppPreferences sharedAppPreferences];
    feedTypeSONoArray=[[NSMutableArray alloc]init];
    feedTypeSONoCopyForPredicate=[[NSMutableArray alloc]init];
    for (int i=0; i<app.feedQueryMessageHeaderArray.count; i++)
    {
        NSLog(@"%lu",(unsigned long)app.feedQueryMessageHeaderArray.count);
        FeedOrQueryMessageHeader *headerObj=[app.feedQueryMessageHeaderArray objectAtIndex:i];
        NSString* soNumber= headerObj.soNumber;
        NSString* feedText=headerObj.feedText;
        NSString* feeddate=headerObj.feedDate;
        NSLog(@"%@,,,,%@,,,,,,%@",soNumber,feedText,feeddate);
         NSArray* separatedSO=[soNumber componentsSeparatedByString:@"#@"];
        
        [feedTypeSONoArray addObject:headerObj];
        [feedTypeSONoCopyForPredicate addObject:headerObj];
        
        NSLog(@"%lu",(unsigned long)arrayOfSeperatedSOArray.count);
        
    }

}

-(void)createBarButtonItem
{
    //menuBarButton=    [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"SliderMenu"] style:NULL target:NULL action:NULL];
   // self.navigationItem.leftBarButtonItem = menuBarButton;
}


- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
   // NSPredicate *predicate =[NSPredicate predicateWithFormat:@"SELF contains [cd] %@", self.searchController.searchBar.text];
    
    
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
    AppPreferences* app=[AppPreferences sharedAppPreferences];

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
        NSString* feedText=headerObj1.feedText;
        NSLog(@"%@,,,,%@",soNumber,feedText);
        NSArray* separatedSO=[soNumber componentsSeparatedByString:@"#@"];
   
    

    UILabel* soNoLabel=(UILabel*)[cell viewWithTag:12];
//    soNoLabel.text=[NSString stringWithFormat:@"SO No.%@ \nAvaya Id:%@ \nDocument Id:%@",[separatedSO objectAtIndex:0],@"",@""];
//    //soNoLabel.text=[separatedSO objectAtIndex:0];
//    if (separatedSO.count>1) {
//        soNoLabel.text=[NSString stringWithFormat:@"SO No.%@ \nAvaya Id:%@ \nDocument ID:%@ ",[separatedSO objectAtIndex:0],[separatedSO objectAtIndex:1],@""];
//
//        //avayaIdLabel.text=[separatedSO objectAtIndex:1];
//    }

   // if (separatedSO.count>2) {
        soNoLabel.text=[NSString stringWithFormat:@"SO No.%@ \nAvaya Id:%@ \nDocument Id:%@",[separatedSO objectAtIndex:0],[separatedSO objectAtIndex:1],[separatedSO objectAtIndex:2]];

       // documentIdLabel.text=[separatedSO objectAtIndex:2];
   // }

    
    UILabel* feedbackLabel=(UILabel*)[cell viewWithTag:15];
    feedbackLabel.text=headerObj1.feedText;
    NSString* dateString= headerObj1.feedDate;
    double da=[dateString doubleValue];
    NSLog(@"%f",da);
    NSString *dd = [NSString stringWithFormat:@"%@",[NSDate dateWithTimeIntervalSince1970:da/1000.0]];
    NSArray *components = [dd componentsSeparatedByString:@" "];
    NSString *date = components[0];
    NSString *time = components[1];
    NSLog(@"%@,,,,%@",date,time);
    
    UILabel* dateAndTimeLabel=(UILabel*)[cell viewWithTag:13];
    NSString* dateAndTimeLabelString=[NSString stringWithFormat:@"%@\n%@",date,time];
    dateAndTimeLabel.text=dateAndTimeLabelString;
    
    

    //soNoLabel.text=[NSString stringWithFormat:@"SO No.%@ \n Avaya Id:%@ \n Document Id:%@ ",[separatedSO objectAtIndex:0]];
        return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Database *db=[Database shareddatabase];
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];

    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
//    UILabel* soNoLabel=(UILabel*)[cell viewWithTag:12];
//    NSString* str1=[soNoLabel text];
//    
//    UILabel* avayaIdLabel=(UILabel*)[cell viewWithTag:13];
//    NSString* str2=[avayaIdLabel text];
//    
//    UILabel* documentIdLabel=(UILabel*)[cell viewWithTag:14];
//    NSString* str3=[documentIdLabel text];
//    
//    NSString* combineSONumber=[[[[str1 stringByAppendingString:@"#@"] stringByAppendingString:str2] stringByAppendingString:@"#@"]stringByAppendingString:str3];
//    NSLog(@"%@",combineSONumber);
    
    FeedOrQueryMessageHeader *headerObj1=[feedTypeSONoArray objectAtIndex:indexPath.row];
    int feedType=headerObj1.feedbackType;
    NSString* SONumber=headerObj1.soNumber;
    
    [db getDetailMessagesofFeedbackOrQuery:feedType :SONumber];
    UIViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailChatingViewController"];
    
    [self.navigationController pushViewController:vc animated:YES];

}


- (void)dealloc
{
    [self removeObserver:searchResults forKeyPath:@"results"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    
    self.results = [(NSArray *)object valueForKey:@"results"];
    [self.tableView reloadData];
}
- (IBAction)buttonClicked:(id)sender
{
    UIViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateNewFeedbackNavigationController"];
    
    //[self.navigationController pushViewController:vc animated:YES];
    [self.navigationController presentViewController:vc animated:YES completion:nil];
    
}
@end
