//
//  FeedbackDetailViewController.m
//  Communicator
//
//  Created by mac on 29/03/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import "FeedcomQuerycomViewController.h"
#import "FeedOrQueryMessageHeader.h"
//#import "CreateNewFeedbackViewController.h"
#import "NSString+HTML.h"
#import "GTMNSString+HTML.h"
#import "UIColor+CommunicatorColor.h"


@interface FeedcomQuerycomViewController ()




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
    

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadData) name:NOTIFICATION_NEW_DATA_UPDATE
                                               object:nil];
    //for web service response of load more data
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(insertNewData:) name:NOTIFICATION_50_NEW_FEEDBACK_RECORDS
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addFeedbackButton) name:NOTIFICATION_ADD_FEEDBACK_BUTTON
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateStaus:) name:NOTIFICATION_UPDATE_STATUS
                                               object:nil];
    
   
    [self setSearchController];

    refreshControl = [[UIRefreshControl alloc]init];
    
    refreshControl.tag=1000;
    
    [self.tableView addSubview:refreshControl];
    
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];

}

-(void)refreshTable
{
    NSString* username = [[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"];
    
    NSString* password = [[NSUserDefaults standardUserDefaults] valueForKey:@"currentPassword"];

    NSString* companyId=[[Database shareddatabase] getCompanyId:username];
//    NSString* userFeedback=[[Database shareddatabase] getUserIdFromUserName:username];
    NSString* userFrom,*userTo;
    
    if ([companyId isEqual:@"1"])
    {
        userFrom= [[Database shareddatabase] getAdminUserId];
        
        username=[[Database shareddatabase] getUserNameFromCompanyname:[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedCompany"]];
        
        userTo=[[Database shareddatabase] getUserIdFromUserNameWithRoll1:username];
        
    }
    
    else
    {
        userTo=[[Database shareddatabase] getAdminUserId];
        
        userFrom= [[Database shareddatabase] getUserIdFromUserNameWithRoll1:username];
    }
    
   NSMutableArray* feedbackIDsArray= [[Database shareddatabase] getFeedbackIDs:self.feedbackType userFrom:userFrom userTo:userTo];
    
   NSMutableString* feedIdsString;

    if (feedbackIDsArray.count==0)
    {
        feedIdsString=[@"1" mutableCopy];
    }
    
    for (int i=0; i<feedbackIDsArray.count; i++)
    {
        if (i==0)
        {
            feedIdsString=[feedbackIDsArray objectAtIndex:i];
        }
        else
        {
            feedIdsString=[NSMutableString stringWithFormat:@"%@,%@",feedIdsString,[feedbackIDsArray objectAtIndex:i]];
        }
    }
    
    NSString* username1 = [[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"];

    int feedbackType=  [[Database shareddatabase] getFeedbackIdFromFeedbackType:self.feedbackType];
    
    [[APIManager sharedManager] getNew50Records:username1 password:password userFrom:userFrom userTo:userTo feedbackType:feedbackType feedbackIdsArray:feedIdsString];
  // self.loading=false;

    [self.tableView reloadData];
}

-(void)insertNewData:(NSNotification*)dict
{
    [[Database shareddatabase] getLoadMoreData:dict.object];

    [refreshControl endRefreshing];
   // [[self.view viewWithTag:1000] removeFromSuperview];
}

-(void)updateStaus:(NSNotification*)dict
{
    [[Database shareddatabase] updateCounter:dict.object selectedSONoArray:selectedSONoArray selectedStatus:self.selectedStatus];
    [checkBoxSelectedArray removeAllObjects];
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
    [super viewWillAppear:YES];

   // NSLog(@"%d", [AppPreferences sharedAppPreferences].dateWiseSearch);
    [self setNavigationBar];
    
    [self prepareForSearchBar];
    
    [self addFeedbackButton];
    
    self.overlay.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.2];
    
    [self.overlay setHidden:YES];
    
    [self setUserInterActionEnable:YES];

    
    if ([[AppPreferences sharedAppPreferences].selectedStatus isEqual:@"Closed"])
    {
        [[[UIApplication sharedApplication].keyWindow viewWithTag:902] setHidden:YES];
    }

    checkBoxSelectedArray=nil;
    
    checkBoxSelectedArray=[[NSMutableArray alloc] init];

}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [[[UIApplication sharedApplication].keyWindow viewWithTag:901] removeFromSuperview];
    [[[UIApplication sharedApplication].keyWindow viewWithTag:902] removeFromSuperview];
   // [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

-(void)addFeedbackButton
{
    if (([[UIApplication sharedApplication].keyWindow viewWithTag:901] == NULL))
    {
        UIButton* addFeedbackButton=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.origin.x+self.view.frame.size.width-50, self.view.frame.origin.y+self.view.frame.size.height-110, 40, 40)];
        [addFeedbackButton setBackgroundImage:[UIImage imageNamed:@"NewFeedbackOrQuery"] forState:UIControlStateNormal];
        addFeedbackButton.tag=901;
        
        checkBoxSelectedArray=nil;
        checkBoxSelectedArray=[NSMutableArray new];
        [addFeedbackButton addTarget:self action:@selector(addNewFeedbackView) forControlEvents:UIControlEventTouchUpInside];
        [[UIApplication sharedApplication].keyWindow addSubview:addFeedbackButton];
    }
    else
    {
        [[[UIApplication sharedApplication].keyWindow viewWithTag:901] setHidden:NO];
    }
   
    
    if (([[UIApplication sharedApplication].keyWindow viewWithTag:902] == NULL))
    {
        UIButton* changeStatusButton=[[UIButton alloc]initWithFrame:CGRectMake(10, self.view.frame.origin.y+self.view.frame.size.height-110, 42, 42)];
        [changeStatusButton setBackgroundImage:[UIImage imageNamed:@"StatusChange"] forState:UIControlStateNormal];
        changeStatusButton.tag=902;
        [changeStatusButton addTarget:self action:@selector(changeStatus) forControlEvents:UIControlEventTouchUpInside];
        [[UIApplication sharedApplication].keyWindow addSubview:changeStatusButton];
    }
    else
    {
        [[[UIApplication sharedApplication].keyWindow viewWithTag:902] setHidden:NO];
    }
    
    
   

}
-(void)addNewFeedbackView
{
    UIViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateNewFeedbackViewController"];
    // NSArray* arr=   vc.childViewControllers;
    //CreateNewFeedbackViewController* vcc=   [arr objectAtIndex:0];
    //vc.feedbackType=self.feedbackType;
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}

-(void)changeStatus
{
    if (checkBoxSelectedArray.count>0)
    {
        [self.overlay setHidden:NO];
        [self setUserInterActionEnable:NO];
    }
    else
    {
        [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"" withMessage:@"Please select the issue to change the status" withCancelText:@"Cancel" withOkText:@"Ok" withAlertTag:1000];
    }
    
    NSLog(@"%ld",checkBoxSelectedArray.count);
}
-(void)reloadData
{
    [[Database shareddatabase] setDatabaseToCompressAndShowTotalQueryOrFeedback:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentFeedbackType"] fromDate:[AppPreferences sharedAppPreferences].fromDate toDate:[AppPreferences sharedAppPreferences].toDate];

     [self prepareForSearchBar];
    [self.tableView reloadData];
}
//-(void)reloadDataFor
-(void)setNavigationBar
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BackArrow"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewController)] ;
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem.tintColor=[UIColor whiteColor];
   // Database *db=[Database shareddatabase];
    //NSString* username = [[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"];
   // NSString* companyId=[db getCompanyId:username];
//    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"flag"] isEqual:@"0"])
//    {
        self.navigationItem.title = self.feedbackType;
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
    arrayOfSeperatedSOArray=nil;
    feedTypeSONoArray=nil;
    feedTypeSONoCopyForPredicate=nil;
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
    feedTypeSONoArray = nil;
    feedTypeSONoCopyForPredicate= nil;
    arrayOfSeperatedSOArray= nil;
    checkBoxSelectedArray = nil;
    self.tableView = nil;
    
    [AppPreferences sharedAppPreferences].feedQueryMessageHeaderArray = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dealloc
{
//    self.tableView = nil;
//    self.selectStatusPopUpView = nil;
//    self.feedTypeSONoArray = nil;
//    self.searchController= nil;
//    self.feedbackType= nil;
//    self.overlay= nil;
//    refreshControl = nil;
//    self.feedTypeSONoCopyForPredicate= nil;
    [AppPreferences sharedAppPreferences].feedQueryMessageHeaderArray = nil;
   
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
    if (tableView==self.tableView)
    {
        return feedTypeSONoArray.count;
    }
    else
    {
        if ([[AppPreferences sharedAppPreferences].selectedStatus isEqual:@"Total"])
        {
            return 3;
        }
        else
            if ([[AppPreferences sharedAppPreferences].selectedStatus isEqual:@"Closed"])
            {
                return 0;
            }
            else
                if ([[AppPreferences sharedAppPreferences].selectedStatus isEqual:@"Inprogress"])
                {
                    return 1;
                }
                else
                    if ([[AppPreferences sharedAppPreferences].selectedStatus isEqual:@"Open"])
                    {
                        return 2;
                    }
                    else return 3;
        
    }
    
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return NULL;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        
    
    if (tableView==self.tableView)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

        FeedOrQueryMessageHeader *headerObj1=[feedTypeSONoArray objectAtIndex:indexPath.row];
        //    if ([[cell viewWithTag:53] isKindOfClass:[UIButton class]] )
        //    {
        //        [[cell viewWithTag:53] removeFromSuperview];
        //    }
        UIButton* checkBoxButton=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        checkBoxButton.tag=indexPath.row;
        [checkBoxButton addTarget:self action:@selector(checkUnchecked:) forControlEvents:UIControlEventTouchUpInside];
        UIImageView* checkBoxImageView=[[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 20, 20)];
        
        for (id say in [cell subviews])
        {
            if ([say isKindOfClass:[UIButton class]])
            {
                [say removeFromSuperview];
            }
        }
        if ([checkBoxSelectedArray containsObject:[NSString stringWithFormat:@"%ld",indexPath.row]])
        {
            checkBoxImageView.image=[UIImage imageNamed:@"CheckBoxSelected"];
        }
        else
        {
            checkBoxImageView.image=[UIImage imageNamed:@"CheckBoxEmpty"];
        }
        
        checkBoxImageView.tag=54;
        [checkBoxButton addSubview:checkBoxImageView];
        [cell addSubview:checkBoxButton];
        NSString* soNumber= headerObj1.soNumber;
        NSArray* separatedSO=[soNumber componentsSeparatedByString:@"#@"];
        
        UILabel* soNoLabel=(UILabel*)[cell viewWithTag:12];
        
        UILabel* dateAndTimeLabel=(UILabel*)[cell viewWithTag:13];

        UIWebView* feedTextWebView=(UIWebView*)[cell viewWithTag:15];
        
        UILabel* createdByLabel=(UILabel*)[cell viewWithTag:16];

        UILabel* closedByLabel=(UILabel*)[cell viewWithTag:17];
        
        UILabel* avayaIdLabel=(UILabel*)[cell viewWithTag:551];

        UILabel* docIdLabel=(UILabel*)[cell viewWithTag:552];

        UILabel* assigneeLabel=(UILabel*)[cell viewWithTag:553];
        
        UILabel* statusLabel=(UILabel*)[cell viewWithTag:554];



//        soNoLabel.text=[NSString stringWithFormat:@"SO No.%@ \nAvaya Id:%@ \nDocument Id:%@",[separatedSO objectAtIndex:0],[separatedSO objectAtIndex:1],[separatedSO objectAtIndex:2]];
        
        soNoLabel.text=[NSString stringWithFormat:@"SO No: %@ ",[separatedSO objectAtIndex:0]];

        avayaIdLabel.text=[NSString stringWithFormat:@"Avaya Id: %@ ",[separatedSO objectAtIndex:1]];
        
        docIdLabel.text=[NSString stringWithFormat:@"Doc. Id: %@ ",[separatedSO objectAtIndex:2]];
       
        assigneeLabel.text=@"";
        closedByLabel.text=@"";
        if (!(headerObj1.assigneeFirstname==NULL))
        {
             assigneeLabel.text=[NSString stringWithFormat:@"Assignee: %@ %@", headerObj1.assigneeFirstname,headerObj1.assigneeLastname];
        }
       
        if (!(headerObj1.closeByFirstname==NULL))
        {
            closedByLabel.text=[NSString stringWithFormat:@"Closed By: %@ %@", headerObj1.closeByFirstname,headerObj1.lcloseByLastname];
        }
        
        if (headerObj1.statusId==1)
        {
            statusLabel.text=@"Open";
            statusLabel.textColor=[UIColor redColor];

        }
        else
            if (headerObj1.statusId==2)
            {
                statusLabel.text=@"Closed";
                statusLabel.textColor=[UIColor colorWithRed:70/255.0 green:102/255.0 blue:0/255.0 alpha:1];
            }
            else
                if (headerObj1.statusId==3)
                {
                    statusLabel.text=@"Inprogress";
                    statusLabel.textColor=[UIColor communicatorColor];

                }
        feedTextWebView.backgroundColor=[UIColor clearColor];
        [feedTextWebView setOpaque:NO];
        feedTextWebView.scrollView.scrollEnabled = NO;
        feedTextWebView.scrollView.bounces = NO;
        
        
        NSString *feedBackString =  [headerObj1.feedText stringByDecodingHTMLEntities];
        [feedTextWebView loadHTMLString:feedBackString baseURL:nil];
        
        NSArray *components1 = [headerObj1.feedDate componentsSeparatedByString:@"+"];
        NSArray* dateAndTimeArray= [components1[0] componentsSeparatedByString:@" "];
        
        if (dateAndTimeArray.count>1)
        {
            dateAndTimeLabel.text=[NSString stringWithFormat:@"%@ %@",dateAndTimeArray[0],dateAndTimeArray[1]];
            
        }
        
        createdByLabel.text=[NSString stringWithFormat:@"Init. by: %@ %@",headerObj1.firstname,headerObj1.lastname];
        
        //to show is message came today?
        NSString* todaysDateAndTime=  [[APIManager sharedManager] getDate];
        
        NSArray* todaysDateAndTimeArray=[todaysDateAndTime componentsSeparatedByString:@" "];
        
        NSString* todaysDate =[todaysDateAndTimeArray objectAtIndex:0];
        
        NSString* messageDate=dateAndTimeArray[0];
        
        //to show message came yesterday
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        NSDate *dateFromString = [[NSDate alloc] init];
        dateFromString = [dateFormatter dateFromString:todaysDate];
        NSDate *dateFromString1 = [[NSDate alloc] init];
        dateFromString1 = [dateFormatter dateFromString:messageDate];
        
        CGFloat minuteDifference = [dateFromString timeIntervalSinceDate:dateFromString1] / 60.0;
        
        if (minuteDifference>1439 && minuteDifference<2880)
        {
            dateAndTimeLabel.text=[NSString stringWithFormat:@"Yesterday %@",dateAndTimeArray[1]];
            
        }
        
        if (minuteDifference==0)
        {
            dateAndTimeLabel.text=[NSString stringWithFormat:@"Today %@",dateAndTimeArray[1]];
        }
        

        
//        UIImageView* imageView= [cell viewWithTag:212];
//        if (imageView.image!=NULL)
//        {
//            imageView.image=NULL;
//        }
//        UIImageView* readStatusImageView= [cell viewWithTag:211];
//        if (headerObj1.readStatus>1 || headerObj1.readStatus==1)
//        {
//           readStatusImageView.image=[UIImage imageNamed:@"Star"];
//        }
//        else
//        {
//            readStatusImageView.image=NULL;
//        }
        
        //
        
        UIView* circleReferenceview=[cell viewWithTag:500];
        
        UILabel* messageCountLabel=[circleReferenceview viewWithTag:501];
        if (!circleReferenceview.isHidden)
        {
            [circleReferenceview setHidden:YES];
        }
        
        if (headerObj1.readStatus>1 ||headerObj1.readStatus==1)
        {
            circleReferenceview.layer.cornerRadius = 18 / 2.0;
            messageCountLabel.text=[NSString stringWithFormat:@"%d",headerObj1.readStatus];
            
                       dateAndTimeLabel.textColor=[UIColor colorWithRed:52/255.0 green:175/255.0 blue:35/255.0 alpha:1];
            circleReferenceview.backgroundColor=[UIColor colorWithRed:52/255.0 green:175/255.0 blue:35/255.0 alpha:1];

            [circleReferenceview setHidden:NO];
        }
        else
        {
         dateAndTimeLabel.textColor=[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        }

        
        
        
        //
//        if (headerObj1.statusId==2)
//        {
//            closedByLabel.text=[NSString stringWithFormat:@"Closed by: %@ %@",headerObj1.firstname,headerObj1.lastname];
//            //Database* db=[Database shareddatabase];
//            // NSString* firstNameLastName =[db getClosedByUserName:headerObj1.feedbackType andsoNumber:headerObj1.soNumber];
//        }
//        else
//            closedByLabel.text=@"";
        
        
        return cell;

    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

        UILabel* statusNameLabel=[cell viewWithTag:1];
        
        if ([[AppPreferences sharedAppPreferences].selectedStatus isEqual:@"Open"])
        {
            if (indexPath.row==0)
            {
                statusNameLabel.text=@"Close";
            }
            else
                if (indexPath.row==1)
                {
                    statusNameLabel.text=@"Inprogress";
                }
        }
        else
            if ([[AppPreferences sharedAppPreferences].selectedStatus isEqual:@"Closed"])
            {
//                if (indexPath.row==0)
//                {
//                    statusNameLabel.text=@"Open";
//                }
//                else
//                    if (indexPath.row==1)
//                    {
//                        statusNameLabel.text=@"Inprogress";
//                    }
            }
        else
            if ([[AppPreferences sharedAppPreferences].selectedStatus isEqual:@"Inprogress"])
            {
//                if (indexPath.row==0)
//                {
//                    statusNameLabel.text=@"Open";
//                }
//                else
//                    if (indexPath.row==1)
//                    {
//                        statusNameLabel.text=@"Close";
//                    }
                
                if (indexPath.row==0)
                {
                    statusNameLabel.text=@"Close";
                }
            }

else
{
        if (indexPath.row==0)
        {
        statusNameLabel.text=@"Open";
        }
        else
            if (indexPath.row==1)
            {
                statusNameLabel.text=@"Close";
            }
        else
            if (indexPath.row==2)
            {
                statusNameLabel.text=@"Inprogress";
            }
    
}
        return cell;
    
    }
    
}

-(void)checkUnchecked:(UIButton*)sender
{
    UIImageView* imageView=[sender viewWithTag:54];
    UIImageView* imageView1=[[UIImageView alloc]init];
    imageView1.image=[UIImage imageNamed:@"CheckBoxEmpty"];
    NSData *data1 = UIImagePNGRepresentation(imageView.image);
    
    NSData *data2 = UIImagePNGRepresentation(imageView1.image);
    
    if ([data1 isEqual:data2])
    {
        imageView.image=[UIImage imageNamed:@"CheckBoxSelected"];
        [checkBoxSelectedArray addObject:[NSString stringWithFormat:@"%ld",(long)sender.tag]];
        //[self.tableView reloadData];

    }
    else
    {
        imageView.image=[UIImage imageNamed:@"CheckBoxEmpty"];
        [checkBoxSelectedArray removeObject:[NSString stringWithFormat:@"%ld",(long)sender.tag]];

    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==self.tableView)
    {
         return 130;
    }
    else
    {
        return 40;
    }
   
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==self.tableView)
    {
        Database *db=[Database shareddatabase];
        
        FeedOrQueryMessageHeader *headerObj1=[feedTypeSONoArray objectAtIndex:indexPath.row];
        int feedType=headerObj1.feedbackType;
        NSString* SONumber=headerObj1.soNumber;
        
        [db getDetailMessagesofFeedbackOrQuery:feedType :SONumber];
        
        UIViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailChatingViewController"];
        
        [self presentViewController:vc animated:YES completion:nil];
    }
    
    else
    {
        UITableViewCell* cell=[tableView cellForRowAtIndexPath:indexPath];
        UILabel* statusLabel=[cell viewWithTag:1];
        self.selectedStatus=statusLabel.text;
    }
    

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
//    CreateNewFeedbackViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateNewFeedbackViewController"];
//   // NSArray* arr=   vc.childViewControllers;
//    //CreateNewFeedbackViewController* vcc=   [arr objectAtIndex:0];
//    vc.feedbackType=self.feedbackType;
//    [self.navigationController presentViewController:vc animated:YES completion:nil];
    [self addNewFeedbackView];
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
//- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
//{
//    CGPoint offset = aScrollView.contentOffset;
//    CGRect bounds = aScrollView.bounds;
//    CGSize size = aScrollView.contentSize;
//    UIEdgeInsets inset = aScrollView.contentInset;
//    float y = offset.y + bounds.size.height - inset.bottom;
//    float h = size.height;
//    // NSLog(@"offset: %f", offset.y);
//    // NSLog(@"content.height: %f", size.height);
//    // NSLog(@"bounds.height: %f", bounds.size.height);
//    // NSLog(@"inset.top: %f", inset.top);
//    // NSLog(@"inset.bottom: %f", inset.bottom);
//    // NSLog(@"pos: %f of %f", y, h);
//    
//    float reload_distance = 10;
//    if(y > h + reload_distance)
//    {
//        if (!self.loading)
//        {
//           self.loading=true;
//            [self refreshTable];
//            NSLog(@"load more rows");
//
//        }
//    }
//}

-(void)setUserInterActionEnable:(BOOL)enable
{
    if (!enable)
    {
        [self.navigationItem.leftBarButtonItem setEnabled:NO];
        [[UIApplication sharedApplication].keyWindow  viewWithTag:901].userInteractionEnabled=NO;
        [[UIApplication sharedApplication].keyWindow  viewWithTag:902].userInteractionEnabled=NO;
        [self.tabBarController.tabBar setUserInteractionEnabled:NO];
    }
    else
    {
        [self.navigationItem.leftBarButtonItem setEnabled:YES];
        [[UIApplication sharedApplication].keyWindow  viewWithTag:901].userInteractionEnabled=YES;
        [[UIApplication sharedApplication].keyWindow  viewWithTag:902].userInteractionEnabled=YES;
        [self.tabBarController.tabBar setUserInteractionEnabled:YES];

    }

}
- (IBAction)cancelStatusButtonClicked:(id)sender
{
    [self setUserInterActionEnable:YES];

    [self.overlay setHidden:YES];

}

- (IBAction)okStatusButtonClicked:(id)sender
{
    
    FeedOrQueryMessageHeader *headerObj=[FeedOrQueryMessageHeader new];
    
    headerObj= [feedTypeSONoArray objectAtIndex:0];
    NSString* feedbackType=[NSString stringWithFormat:@"%d",headerObj.feedbackType];
    NSString* userFrom=[[NSUserDefaults standardUserDefaults] valueForKey:@"userFrom"];
    NSString* userTo=[[NSUserDefaults standardUserDefaults] valueForKey:@"userTo"];
    NSString* currentUser=[[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"];
    NSString* currentPassword=[[NSUserDefaults standardUserDefaults] valueForKey:@"currentPassword"];
    NSString* statusID;
    if ([self.selectedStatus isEqual:@"Open"])
    {
        statusID=@"1";
    }
    else
        if ([self.selectedStatus isEqual:@"Close"])
        {
            statusID=@"2";
        }
    else
        if ([self.selectedStatus isEqual:@"Inprogress"])
        {
            statusID=@"3";
        }
    
    selectedSONoArray=nil;
    selectedSONoArray=[NSMutableArray new];
    
    for (int i=0; i<checkBoxSelectedArray.count; i++)
    {
        FeedOrQueryMessageHeader *headerObj=[FeedOrQueryMessageHeader new];

        int index=[[checkBoxSelectedArray objectAtIndex:i] intValue];
        headerObj=[feedTypeSONoArray objectAtIndex:index];
        
        [selectedSONoArray addObject:headerObj.soNumber];
        //headerObj.feedbackType;
        
    }
    NSMutableString* SONumberString;
    for (int i=0; i<selectedSONoArray.count; i++)
    {
        if (i==0)
        {
            SONumberString=[selectedSONoArray objectAtIndex:i];

        }
        else
        {
            SONumberString=[NSString stringWithFormat:@"%@%@",SONumberString,[selectedSONoArray objectAtIndex:i]];

        }
        
        if (!(i==selectedSONoArray.count-1))
        {
            SONumberString=[NSMutableString stringWithFormat:@"%@,",SONumberString];
        }
    }
    
    [[APIManager sharedManager] updateStaus:currentUser password:currentPassword userFrom:userFrom userTo:userTo feedbackTypeId:feedbackType SONoArrayString:SONumberString status:statusID];
    [self setUserInterActionEnable:YES];

    [self.overlay setHidden:YES];

}
@end
