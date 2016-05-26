//
//  DetailChatingViewController.m
//  Communicator
//
//  Created by mac on 26/05/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import "DetailChatingViewController.h"
#import "AppPreferences.h"
#import "FeedbackChatingCounter.h"
#import "QueryChatingCounter.h"
@interface DetailChatingViewController ()

@end

@implementation DetailChatingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    UILabel* subjectLabel=(UILabel*)[self.view viewWithTag:100];
    UILabel* SONumberLabel=(UILabel*)[self.view viewWithTag:101];
    UILabel* dateOfFeedLabel=(UILabel*)[self.view viewWithTag:102];

    app=[AppPreferences sharedAppPreferences];
    NSArray* separatedSO=[[NSMutableArray alloc]init];
    FeedbackChatingCounter *allMessageObj=[app.FeedbackOrQueryDetailChatingObjectsArray objectAtIndex:0];
    NSString* soNumber= allMessageObj.soNumber;
    separatedSO=[soNumber componentsSeparatedByString:@"#@"];
    NSString* soNumr=[separatedSO objectAtIndex:0];
    NSString* avaya=[separatedSO objectAtIndex:1];
    NSString* Doc=[separatedSO objectAtIndex:2];

    SONumberLabel.text=[NSString stringWithFormat:@"SO Number:%@\nAvaya Id:%@\nDocument Id:%@",soNumr,avaya,Doc];
    subjectLabel.text=allMessageObj.emailSubject;
    
    FeedbackChatingCounter *allMessageObj1=[app.FeedbackOrQueryDetailChatingObjectsArray lastObject];

    NSString* dateString= allMessageObj1.dateOfFeed;
    double da=[dateString doubleValue];
    NSString *dd = [NSString stringWithFormat:@"%@",[NSDate dateWithTimeIntervalSince1970:da/1000.0]];
    NSDate* sd=[[NSDate alloc]init];
    NSArray *components = [dd componentsSeparatedByString:@" "];
    NSString *date = components[0];
    NSString *time = components[1];
    NSLog(@"%@,,,,%@",date,time);

//    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
//    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
//    [formatter setTimeZone:timeZone];
//    [formatter setDateFormat:@"YYYY//MM/dd"];
//    NSDate *currentDateInUTC = [formatter dateFromString:dd];
//    NSLog(@"%@",currentDateInUTC);
    
        dateOfFeedLabel.text=[NSString stringWithFormat:@"%@\n%@",date,time];

    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return app.FeedbackOrQueryDetailChatingObjectsArray.count;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
   FeedbackChatingCounter* feedObject= [app.FeedbackOrQueryDetailChatingObjectsArray objectAtIndex:indexPath.row];
   UILabel* userName= (UILabel*)[cell viewWithTag:50];
    userName.text=feedObject.userFrom;
    UILabel* feedText= (UILabel*)[cell viewWithTag:51];
    feedText.text=feedObject.detailMessage;
    UILabel* feedTime= (UILabel*)[cell viewWithTag:52];
    
    NSString* dateString= feedObject.dateOfFeed;
    double da=[dateString doubleValue];
    NSString *dd = [NSString stringWithFormat:@"%@",[NSDate dateWithTimeIntervalSince1970:da/1000.0]];
    NSDate* sd=[[NSDate alloc]init];
    NSArray *components = [dd componentsSeparatedByString:@" "];
    NSString *date = components[0];
    NSString *time = components[1];
    
    feedTime.text=[NSString stringWithFormat:@"%@\n%@",date,time];

    return cell;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
