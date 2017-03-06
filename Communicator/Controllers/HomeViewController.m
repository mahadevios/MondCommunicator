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
#import "CompanyNamesViewController.h"
#import "MainMOMViewController.h"
#import "PopUpCustomView.h"
#import "UIButton+buttonDesign.h"
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
@synthesize tableView,counterGraphLabel2;
- (void)viewDidLoad
{
    [super viewDidLoad];//meand view did load in memory
   // [self setSelectedButton:feedComButton];

   // [self createSWRevealView];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [self feedbackAndQuerySearch];
    
        labelArray=[[NSMutableArray alloc]init];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadData) name:NOTIFICATION_NEW_DATA_UPDATE
                                               object:nil];
    [self reloadData];
     self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"SignOut"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewController1)] ;
    issueStatusArray=[[NSMutableArray alloc]initWithObjects:[NSString stringWithFormat:@"Open"],[NSString stringWithFormat:@"Closed"],[NSString stringWithFormat:@"Inprogress"],[NSString stringWithFormat:@"Total"], nil];
    
    selectedCellArray=[NSMutableArray new];
    
    NSLog(@"%@",NSHomeDirectory());
   
}
-(void)viewWillAppear:(BOOL)animated
{
   //self.tabBarController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"SignOut"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewController1)] ;
//    self.navigationController.navigationItem.title = @"Dashboard";
    self.navigationController.navigationBar.backgroundColor = [UIColor communicatorColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationController.navigationBar.barTintColor = [UIColor communicatorColor];
    [self.navigationController.navigationBar setBarStyle:UIStatusBarStyleLightContent];// to set carrier,time and battery color in white color

    
    [[self.view viewWithTag:612] setHidden:YES];
    [self addFeedbackButton];
//    [self.navigationItem setHidesBackButton:NO];
//    self.navigationController.navigationBar.barTintColor = [UIColor communicatorColor];
//    self.tabBarController.navigationItem.leftBarButtonItem.tintColor=[UIColor whiteColor];
//    self.tabBarController.navigationItem.rightBarButtonItem=nil;
//    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    [AppPreferences sharedAppPreferences].dateWiseSearch=NO;
       [tableView reloadData];
    
   
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[[UIApplication sharedApplication].keyWindow viewWithTag:911] removeFromSuperview];
    [self reloadData];//to get the original counter without datesearch

}

-(void)reloadData
{
    NSString* username = [[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"];
    NSString* companyId=[[Database shareddatabase] getCompanyId:username];
    NSString* selectedCompany;
    if ([companyId isEqual:@"1"])
    {
        selectedCompany= [[NSUserDefaults standardUserDefaults] valueForKey:@"selectedCompany"];
        //companyId= [[Database shareddatabase] getCompanyIdFromCompanyName1:selectedCompany];
    }
    else
    {
       selectedCompany= [[Database shareddatabase] getCompanyIdFromCompanyName:companyId];
    }

    [[Database shareddatabase] getFeedbackAndQueryCounterForCompany:selectedCompany];
    [self feedbackAndQuerySearch];
    [tableView reloadData];

}
-(void)popViewController1
{
    alertController = [UIAlertController alertControllerWithTitle:@"Logout?"
                                                          message:@"Are you sure to logout"
                                                   preferredStyle:UIAlertControllerStyleAlert];
    actionDelete = [UIAlertAction actionWithTitle:@"Yes"
                                            style:UIAlertActionStyleDefault
                                          handler:^(UIAlertAction * action)
                    {
                        [[AppPreferences sharedAppPreferences] logout];
                        
                        NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];
                        [defaults setObject:NULL forKey:@"userObject"];
                        [defaults setObject:NULL forKey:@"selectedCompany"];
                        UINavigationController *navController = self.navigationController;
                        UIViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
                        [navController presentViewController:vc animated:YES completion:nil];
                    }]; //You can use a block here to handle a press on this button
    [alertController addAction:actionDelete];
    
    
    actionCancel = [UIAlertAction actionWithTitle:@"Cancel"
                                            style:UIAlertActionStyleCancel
                                          handler:^(UIAlertAction * action)
                    {
                        [alertController dismissViewControllerAnimated:YES completion:nil];
                        
                    }]; //You can use a block here to handle a press on this button
    [alertController addAction:actionCancel];
    [self presentViewController:alertController animated:YES completion:nil];
    
    

}



-(void)flipview:id
{
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
    
    for (int i=0; i<app.feedQueryCounterDictsWithTypeArray.count; i++)
    {
        
        ft2= [app.feedQueryCounterDictsWithTypeArray objectAtIndex:i];
        
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
//- (UIView *)tableView:(UITableView *)tableview viewForHeaderInSection:(NSInteger)section
//{
//    if (tableview == self.popupTableView)
//    {
//        
//      UIView* sectionHeaderView=[[UIView alloc]initWithFrame:CGRectMake(tableview.frame.origin.x, tableview.frame.origin.y-60, tableview.frame.size.width, 60)];
//    UILabel* sectionTitleBackgroundLabelLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, tableview.frame.size.width, 40)];
//    sectionTitleBackgroundLabelLabel.backgroundColor=[UIColor whiteColor];
//    
//    UILabel* sectionTitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, tableview.frame.size.width, 17)];
//    //sectionTitleLabel.backgroundColor=[UIColor whiteColor];
//    
//    [sectionTitleLabel setFont:[UIFont systemFontOfSize:16.0]];
//    UIFont *currentFont = sectionTitleLabel.font;
//    UIFont *newFont = [UIFont fontWithName:[NSString stringWithFormat:@"%@-Bold",currentFont.fontName] size:currentFont.pointSize];
//    sectionTitleLabel.font = newFont;
//    [sectionHeaderView addSubview:sectionTitleBackgroundLabelLabel];
//    
//    [sectionHeaderView addSubview:sectionTitleLabel];
//    
//        sectionTitleLabel.numberOfLines=2;
//        sectionTitleLabel.text=@"Select staus to view issues";
//       return sectionHeaderView;
//    }
//    
//    else
//        return nil;

//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    AppPreferences *app=[AppPreferences sharedAppPreferences];
    if (tableView==self.tableView)
    {
        return app.sampleFeedtypeArray.count;

    }
    else
    {
     return issueStatusArray.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableview cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableview==self.tableView)
    {
    
    AppPreferences *app=[AppPreferences sharedAppPreferences];
   
    UITableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    referenceViewForCounterGraph=[cell viewWithTag:112];


    UILabel* feedbackAndQueryTypeLabel=(UILabel*)[cell viewWithTag:12];
    FeedQueryCounter* feedCounterObj = [app.sampleFeedtypeArray objectAtIndex:indexPath.row];
    feedbackAndQueryTypeLabel.text=feedCounterObj.feedbackType;
    
    counter = feedCounterObj.openCounter;
    totalCounter = feedCounterObj.totalCounter;
    closedCounter=feedCounterObj.closedCounter;
        inProgressCounter=feedCounterObj.inprogressCounter;
        
        
//   UIImageView* imageView= [cell viewWithTag:211];
//    if (imageView.image!=NULL)
//    {
//        imageView.image=NULL;
//    }
//    UIImageView* readStatusImageView= [cell viewWithTag:211];
//    if (feedCounterObj.readStatus==1)
//    {
//        readStatusImageView.image=[UIImage imageNamed:@"Star"];
//    
//    }
        UIView* circleReferenceview=[cell viewWithTag:500];
        if (!circleReferenceview.isHidden)
        {
            [circleReferenceview setHidden:YES];
        }
        
        if (feedCounterObj.readStatus==1)
        {
            circleReferenceview.layer.cornerRadius = 13 / 2.0;

            circleReferenceview.backgroundColor=[UIColor colorWithRed:52/255.0 green:175/255.0 blue:35/255.0 alpha:1];
            [circleReferenceview setHidden:NO];
        }
        
        
    UILabel* countLabel=(UILabel*)[cell viewWithTag:113];
//    if (counter>12)
//    {
//        countLabel.text=@"12+";
//    }
    //else
    countLabel.text=[NSString stringWithFormat:@"%ld", totalCounter];
   
    counterGraphLabel=[cell viewWithTag:111];
    //counterGraphLabel.textColor=[UIColor clearColor];
       
    if (totalCounter>100)
    {
        counterGraphLabel.text=@"100+";
        countLabel.text=@"100+";
    }
    else
    counterGraphLabel.text=[NSString stringWithFormat:@"%ld",counter];
    counterGraphLabel.backgroundColor = [UIColor redColor];
    counterGraphLabel.textColor = [UIColor redColor];
    
    counterGraphLabel1=[cell viewWithTag:120];
        counterGraphLabel2=[cell viewWithTag:130];

    if (closedCounter>20)
    {
        counterGraphLabel1.text=@"100+";
    }
    else
    counterGraphLabel1.text=[NSString stringWithFormat:@"%ld",closedCounter];
        
        
    counterGraphLabel1.backgroundColor = [UIColor colorWithRed:70/255.0 green:102/255.0 blue:0/255.0 alpha:1];
    counterGraphLabel1.textColor = [UIColor colorWithRed:70/255.0 green:102/255.0 blue:0/255.0 alpha:1];
        
        if (inProgressCounter>20)
        {
            counterGraphLabel2.text=@"100+";
        }
        else
        counterGraphLabel2.text=[NSString stringWithFormat:@"%ld",inProgressCounter];
        counterGraphLabel2.backgroundColor=[UIColor communicatorColor];
        counterGraphLabel2.textColor = [UIColor communicatorColor];
        
    CounterGraph* counterGraphObj=[[CounterGraph alloc]init];
    counterGraphObj.counterGraphlabel=counterGraphLabel;
    counterGraphObj.counterGraphlabel1=counterGraphLabel1;
        counterGraphObj.counterGraphlabel2=counterGraphLabel2;

    //counterGraphObj.referenceForCounterGraphView=referenceViewForCounterGraph;
    counterGraphObj.count=counter;
    counterGraphObj.count1=closedCounter;
        counterGraphObj.count2=inProgressCounter;

    [counterGraphLabel setFrame:CGRectMake(counterGraphLabel.frame.origin.x, counterGraphLabel.frame.origin.y, 0.0f, counterGraphLabel.frame.size.height)];
    [counterGraphLabel1 setFrame:CGRectMake(counterGraphLabel1.frame.origin.x, counterGraphLabel1.frame.origin.y, 0.0f, counterGraphLabel1.frame.size.height)];
 [counterGraphLabel2 setFrame:CGRectMake(counterGraphLabel2.frame.origin.x, counterGraphLabel2.frame.origin.y, 0.0f, counterGraphLabel2.frame.size.height)];
    [self performSelector:@selector(setCounterGraphLabel:) withObject:counterGraphObj afterDelay:0.000001];
    
        UIButton* totalCounterButton=[cell.contentView viewWithTag:8001];
        totalCounterButton.tag=indexPath.row;
        [totalCounterButton addTarget:self action:@selector(showNextView:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
    }
    
    else
    {
        UITableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        
        UILabel* issuNameLabel=[cell viewWithTag:114];
        UILabel* statusCounterLabel=[cell viewWithTag:115];

        NSString* statusName;
        

        for (int i=0; i<selectedCellArray.count;i++)
        {
            statusName= [selectedCellArray objectAtIndex:0];
            

        }
        
        FeedQueryCounter* feedCounterObj = [[AppPreferences sharedAppPreferences].sampleFeedtypeArray objectAtIndex:indexpath.row];
        if (indexPath.row==0)
        {
            statusCounterLabel.text=[NSString stringWithFormat:@"%ld",feedCounterObj.openCounter];

        }
        else
            if (indexPath.row==1)
            {
                statusCounterLabel.text=[NSString stringWithFormat:@"%d",feedCounterObj.closedCounter];

            }
            else
                if (indexPath.row==2)
                {
                    statusCounterLabel.text=[NSString stringWithFormat:@"%ld",feedCounterObj.inprogressCounter];
                    
                }
                else
                    if (indexPath.row==3)
                    {
                        statusCounterLabel.text=[NSString stringWithFormat:@"%ld",feedCounterObj.totalCounter];
                        
                    }

        issuNameLabel.text=[issueStatusArray objectAtIndex:indexPath.row];
        if ([statusName isEqualToString:issuNameLabel.text])
        {
            //[cell setSelected:YES];
            [cell setBackgroundColor:[UIColor lightGrayColor]];

        }
        else
        {
            [cell setBackgroundColor:[UIColor whiteColor]];

        }
        return cell;

    }
}
-(void)showNextView:(id)sender
{
        AppPreferences *app=[AppPreferences sharedAppPreferences];
    app.selectedStatus=NULL;
    CGPoint touchPoint = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPathFoRow = [self.tableView indexPathForRowAtPoint:touchPoint];
    //UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    //self.tableView indexPathForRowAtPoint:<#(CGPoint)#>
        UITableViewCell *selectedCell = [self.tableView cellForRowAtIndexPath:indexPathFoRow];
        UILabel* feedbackTypeLabel=(UILabel*)[selectedCell viewWithTag:12];
    
        Database *db=[Database shareddatabase];
    
    
   
    
        [db setDatabaseToCompressAndShowTotalQueryOrFeedback:feedbackTypeLabel.text fromDate:app.fromDate toDate:app.toDate];
        //CompanyNamesViewController* vc1= [self.storyboard instantiateViewControllerWithIdentifier:@"CompanyNamesViewController"];
    
        FeedcomQuerycomViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FeedcomQuerycomViewController"];
        FeedQueryCounter* obj=[app.sampleFeedtypeArray objectAtIndex:indexPathFoRow.row];
        vc.feedbackType=obj.feedbackType;
        [[NSUserDefaults standardUserDefaults] setValue:feedbackTypeLabel.text forKey:@"currentFeedbackType"];
    
    
      [self.navigationController pushViewController:vc animated:YES];

    
    
}
- (IBAction)cancelStatusButtonClicked:(id)sender
{
    [[self.view viewWithTag:612] setHidden:YES];
    [selectedCellArray removeAllObjects];
}

- (IBAction)submitStatusButtonClicked:(id)sender
{
    if(selectedCellArray.count==1)
    {
        AppPreferences *app=[AppPreferences sharedAppPreferences];
        
        UITableViewCell *selectedCell = [self.tableView cellForRowAtIndexPath:indexpath];
        UILabel* feedbackTypeLabel=(UILabel*)[selectedCell viewWithTag:12];
        
        Database *db=[Database shareddatabase];
        
        
        
        [db setDatabaseToCompressAndShowTotalQueryOrFeedback:feedbackTypeLabel.text fromDate:app.fromDate toDate:app.toDate];
        //CompanyNamesViewController* vc1= [self.storyboard instantiateViewControllerWithIdentifier:@"CompanyNamesViewController"];
        
        FeedcomQuerycomViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FeedcomQuerycomViewController"];
        FeedQueryCounter* obj=[app.sampleFeedtypeArray objectAtIndex:row];
        vc.feedbackType=obj.feedbackType;
        [[NSUserDefaults standardUserDefaults] setValue:feedbackTypeLabel.text forKey:@"currentFeedbackType"];
        
        
        //[[self.view viewWithTag:612] removeFromSuperview];
         [[self.view viewWithTag:612] setHidden:YES];
 
        [selectedCellArray removeAllObjects];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {

        [[self.view viewWithTag:612] setHidden:YES];
        //[selectedCellArray removeAllObjects];
    }
}



-(void)addFeedbackButton
{
    UIButton* addFeedbackButton=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.origin.x+self.view.frame.size.width-50, self.view.frame.origin.y+self.view.frame.size.height-110, 50, 50)];
    [addFeedbackButton setBackgroundImage:[UIImage imageNamed:@"Calendar"] forState:UIControlStateNormal];
    addFeedbackButton.tag=911;
    [addFeedbackButton addTarget:self action:@selector(addNewCalendarView) forControlEvents:UIControlEventTouchUpInside];
    
    [[UIApplication sharedApplication].keyWindow addSubview:addFeedbackButton];
    
}
-(void)addNewCalendarView
{
    CGRect rect= CGRectMake(self.view.center.x-130, self.view.center.y-125, 260, 200);
   //PopUpCustomView* obj= [[PopUpCustomView alloc]init];
    UIView* popupCalendarView=[[PopUpCustomView alloc]initWithFrame:rect sender:self];
   // [[[UIApplication sharedApplication].keyWindow viewWithTag:911] removeFromSuperview];
    [[UIApplication sharedApplication].keyWindow viewWithTag:911].userInteractionEnabled=NO;
    [[[UIApplication sharedApplication] keyWindow] addSubview:popupCalendarView];
   // [self.view addSubview:popupCalendarView];
}
-(void)cancel:(UIButton*)sender
{
   [[[UIApplication sharedApplication].keyWindow viewWithTag:121] removeFromSuperview];
    [[UIApplication sharedApplication].keyWindow viewWithTag:911].userInteractionEnabled=YES ;//date search button enabled
    [AppPreferences sharedAppPreferences].dateWiseSearch=false;

}

-(void)submit:(UIButton*)sender
{
    UIView* overlay=[[UIApplication sharedApplication].keyWindow viewWithTag:121];
    UIView* borderView= [overlay viewWithTag:221];
    UITextField* startDateTextField=[borderView viewWithTag:551];
    UITextField* endTextField=[borderView viewWithTag:552];
    
    AppPreferences* app=[AppPreferences sharedAppPreferences];
   app.fromDate=startDateTextField.text;
   app.toDate=endTextField.text;
    
   app.fromDate=[NSString stringWithFormat:@"%@ 00:00:00",app.fromDate];
  app.toDate=[NSString stringWithFormat:@"%@ 23:59:59",app.toDate];

   app.dateWiseSearch=true;
    //[[NSUserDefaults standardUserDefaults] setValue:companyId forKey:@"clientCompanyId"];

    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"userFrom"] isEqual:@"1"])
    {
        [[Database shareddatabase] getDateWiseFeedbackAndQueryCounterForCompany:[[NSUserDefaults standardUserDefaults] valueForKey:@"selectedCompany"] fromDate:app.fromDate toDate:app.toDate];
    }
    else
    {
        NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"clientCompanyId"]);
        NSString* companyName= [[Database shareddatabase] getCompanyIdFromCompanyName:[[NSUserDefaults standardUserDefaults] valueForKey:@"clientCompanyId"]];
     [[Database shareddatabase] getDateWiseFeedbackAndQueryCounterForCompany:companyName fromDate:app.fromDate toDate:app.toDate];
    }


    [self feedbackAndQuerySearch];
    [self.tableView reloadData];
   
    [[[UIApplication sharedApplication].keyWindow viewWithTag:121] removeFromSuperview];
    [[UIApplication sharedApplication].keyWindow viewWithTag:911].userInteractionEnabled=YES ;//date search button enabled

}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    UIView* overlay=[[UIApplication sharedApplication].keyWindow viewWithTag:121];
    UIView* borderView= [overlay viewWithTag:221];
    UITextField* startDateTextField=[borderView viewWithTag:551];
    UITextField* endTextField=[borderView viewWithTag:552];
    
    
    UIDatePicker *datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, overlay.frame.size.width, overlay.frame.size.height/3)];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    [datePicker setDate:[NSDate new]];
    [startDateTextField setInputView:datePicker];
    [endTextField setInputView:datePicker];
    
    if (textField==startDateTextField)
    {
        [datePicker addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
        
    }
    else
    {
        [datePicker addTarget:self action:@selector(updateTextField1:) forControlEvents:UIControlEventValueChanged];
    }
    datePicker.tag=125;
    NSLog(@"%f",datePicker.frame.size.height);
   UIToolbar* toolbar = [[UIToolbar alloc] initWithFrame: CGRectMake(0, 2*(overlay.frame.size.height/3)-30, overlay.frame.size.width, 30)] ;
    toolbar.barStyle = UIBarStyleBlackOpaque;
    toolbar.tag=124;
    
    toolbar.backgroundColor=[UIColor grayColor];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle: @"Done" style: UIBarButtonItemStylePlain target: self action: @selector(donePressed)];
    doneButton.width = overlay.frame.size.width - 20;
    toolbar.items = [NSArray arrayWithObject: doneButton];
   // [overlay addSubview: toolbar];
   textField.inputAccessoryView = toolbar;

}

-(void)updateTextField:(id)sender
{
    UIView* overlay=[[UIApplication sharedApplication].keyWindow viewWithTag:121];
    UIView* borderView= [overlay viewWithTag:221];
    UITextField* date1= [borderView viewWithTag:551];
    
    UIDatePicker *picker = (UIDatePicker*)date1.inputView;
    NSDateFormatter *formatter=[NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString* date= [formatter stringFromDate:picker.date];
   
    date1.text = [NSString stringWithFormat:@"%@",date];
}

-(void)updateTextField1:(id)sender
{
    UIView* overlay=[[UIApplication sharedApplication].keyWindow viewWithTag:121];
    UIView* borderView= [overlay viewWithTag:221];
    UITextField* date2= [borderView viewWithTag:552];
    
    UIDatePicker *picker = (UIDatePicker*)date2.inputView;
    NSDateFormatter *formatter=[NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString* date= [formatter stringFromDate:picker.date];
    
    date2.text = [NSString stringWithFormat:@"%@",date];
}

-(void)donePressed
{
 UIView* overlay=[[UIApplication sharedApplication].keyWindow viewWithTag:121];
  UIToolbar* toolBar=  [overlay viewWithTag:124];
    [toolBar removeFromSuperview];
    
    UIView* borderView= [overlay viewWithTag:221];
    UITextField* startDateTextField=[borderView viewWithTag:551];
    UITextField* endTextField=[borderView viewWithTag:552];
    
    [startDateTextField resignFirstResponder];
    [endTextField resignFirstResponder];
//
//    [startDateTextField setInputView:nil];
//    [endTextField setInputView:nil];


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
                         float activeCountermaxWidth=counterGraphObj.count*5;//openCount
                         float closedCountermaxWidth=counterGraphObj.count1*5;//closeCount
                         float inProgressCountermaxWidth=counterGraphObj.count2*5;//closeCount

                         if ((activeCountermaxWidth+closedCountermaxWidth+inProgressCountermaxWidth)>100)
                         {
                            activeCountermaxWidth= ((counterGraphObj.count * 5.0)/ (counterGraphObj.count * 5+counterGraphObj.count1 * 5+counterGraphObj.count2 * 5))*100;
                            closedCountermaxWidth= ((counterGraphObj.count1 * 5.0)/ (counterGraphObj.count * 5+counterGraphObj.count1 * 5+counterGraphObj.count2 * 5))*100;
                              inProgressCountermaxWidth= ((counterGraphObj.count2 * 5.0)/ (counterGraphObj.count * 5+counterGraphObj.count1 * 5+counterGraphObj.count2 * 5))*100;
                           
                             NSLog(@"a=%f c=%f",activeCountermaxWidth,closedCountermaxWidth);

                         }
//                         if ((counterGraphObj.count * 5)>100)
//                         {
//                             activeCountermaxWidth= 100;
//                             //closedCountermaxWidth= ((counterGraphObj.count1 * 10.0)/ (counterGraphObj.count * 10+counterGraphObj.count1 * 10))*120;
//                             
//                         }
                         
    [counterGraphObj.counterGraphlabel setFrame:CGRectMake(counterGraphObj.counterGraphlabel.frame.origin.x, counterGraphObj.counterGraphlabel.frame.origin.y, activeCountermaxWidth, counterGraphObj.counterGraphlabel.frame.size.height)];
                         
                         [counterGraphObj.counterGraphlabel1 setFrame:CGRectMake(counterGraphObj.counterGraphlabel.frame.origin.x+activeCountermaxWidth, counterGraphObj.counterGraphlabel1.frame.origin.y, closedCountermaxWidth, counterGraphObj.counterGraphlabel1.frame.size.height)];
                         
                         [counterGraphObj.counterGraphlabel2 setFrame:CGRectMake(counterGraphObj.counterGraphlabel.frame.origin.x+activeCountermaxWidth+closedCountermaxWidth, counterGraphObj.counterGraphlabel1.frame.origin.y, inProgressCountermaxWidth, counterGraphObj.counterGraphlabel1.frame.size.height)];
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
    if (tableview==self.tableView)
    {
     
    [[self.view viewWithTag:612] setHidden:NO];
        [[self.view viewWithTag:612] setFrame:[[UIScreen mainScreen] bounds]];
        
        [[self.view viewWithTag:612] setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.2]];
        indexpath=indexPath;
        row=indexPath.row;
//    AppPreferences *app=[AppPreferences sharedAppPreferences];
//    
//    UITableViewCell *selectedCell = [tableview cellForRowAtIndexPath:indexPath];
//    UILabel* feedbackTypeLabel=(UILabel*)[selectedCell viewWithTag:12];
//
//    Database *db=[Database shareddatabase];
//    [db setDatabaseToCompressAndShowTotalQueryOrFeedback:feedbackTypeLabel.text];
//    //CompanyNamesViewController* vc1= [self.storyboard instantiateViewControllerWithIdentifier:@"CompanyNamesViewController"];
//
//    FeedcomQuerycomViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FeedcomQuerycomViewController"];
//    FeedQueryCounter* obj=[app.sampleFeedtypeArray objectAtIndex:indexPath.row];
//    vc.feedbackType=obj.feedbackType;
//    [[NSUserDefaults standardUserDefaults] setValue:feedbackTypeLabel.text forKey:@"currentFeedbackType"];
//    
//    
//  [self.navigationController pushViewController:vc animated:YES];
        
    }
    
    else
    {
        UITableViewCell *selectedCell = [tableview cellForRowAtIndexPath:indexPath];
//        [self.view viewWithTag:112];
       // if (selectedCell.accessoryType == UITableViewCellAccessoryNone)

        if (selectedCell.backgroundColor==[UIColor whiteColor])

        {
            UILabel* issuNameLabel=[selectedCell viewWithTag:114];
            if (selectedCellArray.count==1)
            {
                [selectedCellArray replaceObjectAtIndex:0 withObject:issuNameLabel.text];
                [AppPreferences sharedAppPreferences].selectedStatus=issuNameLabel.text;
            }
            else
            {
                [selectedCellArray addObject:issuNameLabel.text];
                [AppPreferences sharedAppPreferences].selectedStatus=issuNameLabel.text;

            }
            //selectedCell.accessoryType=UITableViewCellAccessoryCheckmark;
        }
    }
    [self.popupTableView reloadData];

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
