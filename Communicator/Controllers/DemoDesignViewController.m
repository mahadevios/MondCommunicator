//
//  DemoDesignViewController.m
//  Communicator
//
//  Created by mac on 20/05/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import "DemoDesignViewController.h"
#import "UIColor+CommunicatorColor.h"
@interface DemoDesignViewController ()

@end

@implementation DemoDesignViewController

@synthesize demoCountArray;
@synthesize POLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    demoCountArray=[[NSMutableArray alloc]init];
    for (int i=0; i<3; i++)
    {
        NSString* str=[NSString stringWithFormat:@"%d",i+2];
        [demoCountArray addObject:str];
    }
    
//    POLabel.text=[demoCountArray objectAtIndex:0];
    
    

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    float count=[[demoCountArray objectAtIndex:indexPath.row]floatValue];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(cell.frame.origin.x+(cell.bounds.size.width/2),0,20*(count),30)];
    [label setText:[NSString stringWithFormat:@"%@",[demoCountArray objectAtIndex:indexPath.row]]];
    [label setTextAlignment:UITextAlignmentRight];
    [label setFont: [UIFont fontWithName:@"Arial" size:13.0f]];
    [label setBackgroundColor:[UIColor communicatorColor]];
    [label setTextColor:[UIColor whiteColor]];
    [cell addSubview:label];
       return cell;
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
