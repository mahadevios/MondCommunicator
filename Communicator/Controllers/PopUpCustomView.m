//
//  PopUpCustomView.m
//  Cube
//
//  Created by mac on 06/08/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import "PopUpCustomView.h"

@implementation PopUpCustomView
@synthesize tap;
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
- (UIView*)initWithFrame:(CGRect)frame andSubViews:(NSArray*)subViewNamesArray :(id)sender
{
    self = [super initWithFrame:frame];
    self.tag=561;
    self.backgroundColor=[UIColor whiteColor];
    overlay= [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    tap=[[UITapGestureRecognizer alloc]initWithTarget:sender action:@selector(dismissPopView:)];
    tap.delegate=sender;
    
    overlay=[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [overlay addGestureRecognizer:tap];
    overlay.tag=111;
    
    overlay.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.2];
   float buttonHeight= frame.size.height/subViewNamesArray.count;
    if (self)
    {
        // Initialization code
        // initilize all your UIView components
        UIButton* userSettingsButton=[[UIButton alloc]initWithFrame:CGRectMake(5, 0, 0, 0)];
        UIView* seperatorLineView;
        for (int i=0,j=0; i<subViewNamesArray.count; i++,j++)
        {
            //userSettingsButton.titleLabel.textAlignment=NSTextAlignmentCenter;
            
//            userSettingsButton=[[UIButton alloc]initWithFrame:CGRectMake(0, userSettingsButton.frame.origin.x+userSettingsButton.frame.size.height, 150, 30)];
//            if (subViewNamesArray.count>1)
//            {
//                if (i==0)
//                {
//                    seperatorLineView=[[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height/2, frame.size.width, 1)];
//                    seperatorLineView.backgroundColor=[UIColor lightGrayColor];
//                }
//                
//            }
//            if (i==1)
//            {
//                userSettingsButton=[[UIButton alloc]initWithFrame:CGRectMake(0, userSettingsButton.frame.origin.x+userSettingsButton.frame.size.height+14, 160, 30)];
//                
//            }
//            if (i==2)
//            {
//                userSettingsButton=[[UIButton alloc]initWithFrame:CGRectMake(0, userSettingsButton.frame.origin.x+2*userSettingsButton.frame.size.height+28, 160, 30)];
//                
//            }
            
            userSettingsButton=[[UIButton alloc]initWithFrame:CGRectMake(0, buttonHeight*j, frame.size.width, buttonHeight)];

            if (i==1)
            {
                seperatorLineView=[[UIView alloc]initWithFrame:CGRectMake(0, buttonHeight*j, frame.size.width, 1)];
                seperatorLineView.backgroundColor=[UIColor lightGrayColor];
                if (subViewNamesArray.count>1)
                    [self addSubview:seperatorLineView];
            }
            //userSettingsButton.frame=CGRectMake(0, buttonHeight*j, frame.size.width, buttonHeight);
            
            [userSettingsButton setTitle:[subViewNamesArray objectAtIndex:i] forState:UIControlStateNormal];
            [userSettingsButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            userSettingsButton.titleLabel.font=[UIFont systemFontOfSize:14];
            [userSettingsButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
            
            NSString* selector=[NSString stringWithFormat:@"%@",[subViewNamesArray objectAtIndex:i]];
            selector = [selector stringByReplacingOccurrencesOfString:@" " withString:@""];
            [userSettingsButton addTarget:sender action:NSSelectorFromString(selector) forControlEvents:UIControlEventTouchUpInside];
            
            //    [userSettingsButton setBackgroundColor:[UIColor colorWithRed:(i*155)/255.0 green:(i*155)/255.0 blue:(i*155)/255.0 alpha:1]];
            
            [self addSubview:userSettingsButton];
            self.layer.cornerRadius=2.0f;
            //            selectSetting
        }

        [overlay addSubview:self];
    }
    return overlay;
}

-(UIView*)initWithFrame:(CGRect)frame  sender:(id)sender
{
    self = [super initWithFrame:frame];
    self.backgroundColor=[UIColor whiteColor];
    overlay= [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //tap=[[UITapGestureRecognizer alloc]initWithTarget:sender action:@selector(disMissPopView:)];
    
    overlay=[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
   // [overlay addGestureRecognizer:tap];
    overlay.tag=121;
    
    overlay.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.2];
    UIView* borderView=[[UIView alloc]initWithFrame:CGRectMake(frame.origin.x+10, frame.origin.y+10, frame.size.width-20, frame.size.height-60)];
    borderView.layer.borderWidth=1.0f;
    borderView.layer.cornerRadius=7.0f;
    borderView.tag=221;
    borderView.layer.borderColor=[UIColor grayColor].CGColor;
    
    if (self)
    {
        UILabel* label1=[[UILabel alloc]initWithFrame:CGRectMake(15, 10, borderView.frame.size.width-20, 20)];
        label1.text=@"Search";
        label1.font=[UIFont systemFontOfSize:14];
        
        UILabel* label2=[[UILabel alloc]initWithFrame:CGRectMake(5, label1.frame.origin.y+label1.frame.size.height+10,40, 40)];
        label2.numberOfLines=2;
        label2.text=@"From date";
        label2.font=[UIFont systemFontOfSize:14];
        
        UITextField* abbreviationTextField=[[UITextField alloc]initWithFrame:CGRectMake(label2.frame.origin.x+label2.frame.size.width+10, label2.frame.origin.y+5, borderView.frame.size.width-70, 30)];
        abbreviationTextField.layer.borderWidth=1.0f;
        abbreviationTextField.layer.cornerRadius=7.0f;
        abbreviationTextField.layer.borderColor=[UIColor grayColor].CGColor;
        abbreviationTextField.delegate=sender;
        abbreviationTextField.tag=551;
        //abbreviationTextField.placeholder=@"Enter your abbreviation";
        UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
        abbreviationTextField.leftView = paddingView;
        abbreviationTextField.leftViewMode = UITextFieldViewModeAlways;
        
        
        UILabel* label3=[[UILabel alloc]initWithFrame:CGRectMake(5, abbreviationTextField.frame.origin.y+abbreviationTextField.frame.size.height+10,40, 40)];
        label3.numberOfLines=2;
        label3.text=@"To date";
        label3.font=[UIFont systemFontOfSize:14];
        
        UITextField* toDateTextField=[[UITextField alloc]initWithFrame:CGRectMake(label3.frame.origin.x+label3.frame.size.width+10, label3.frame.origin.y+5, borderView.frame.size.width-70, 30)];
        toDateTextField.layer.borderWidth=1.0f;
        toDateTextField.layer.cornerRadius=7.0f;
        toDateTextField.layer.borderColor=[UIColor grayColor].CGColor;
        toDateTextField.delegate=sender;
        toDateTextField.tag=552;
        toDateTextField.leftView=paddingView;
        abbreviationTextField.leftViewMode = UITextFieldViewModeAlways;

        UIButton* cancelButton=[[UIButton alloc]initWithFrame:CGRectMake(frame.size.width-200, frame.size.height-36, 80, 20)];
        [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        //[cancelButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [cancelButton addTarget:sender action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton* saveButton=[[UIButton alloc]initWithFrame:CGRectMake(cancelButton.frame.origin.x+cancelButton.frame.size.width+16, frame.size.height-36, 80, 20)];
        [saveButton setTitle:@"Search" forState:UIControlStateNormal];
        [saveButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        //[saveButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        
        [saveButton addTarget:sender action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [self addSubview:cancelButton];
        [self addSubview:saveButton];
        [borderView addSubview:label1];
        [borderView addSubview:label2];
        [borderView addSubview:label3];

        [borderView addSubview:abbreviationTextField];
        [borderView addSubview:toDateTextField];

    }
    self.layer.cornerRadius=2.0f;
    
    [overlay addSubview:self];
    [overlay addSubview:borderView];
    return overlay;
    
}

-(UITableView*)tableView:(id)sender frame:(CGRect)frame
{
    UITableView *tableView=[[UITableView alloc]initWithFrame:frame];
    UIView* sectionHeaderView=[[UIView alloc]initWithFrame:CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y, tableView.frame.size.width, 50)];
    
    UILabel* sectionTitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(16, 20, tableView.frame.size.width, 17)];
    [sectionTitleLabel setFont:[UIFont systemFontOfSize:16.0]];
    UIFont *currentFont = sectionTitleLabel.font;
    UIFont *newFont = [UIFont fontWithName:[NSString stringWithFormat:@"%@-Bold",currentFont.fontName] size:currentFont.pointSize];
    sectionTitleLabel.font = newFont;
    sectionTitleLabel.text=@"Select Department";
    [sectionHeaderView addSubview:sectionTitleLabel];
    
    //tableView.tableHeaderView=sectionHeaderView;
    tableView.dataSource=sender;
    tableView.delegate=sender;
    UITableViewCell * cell=[[UITableViewCell alloc]init];
    [tableView addSubview:cell];
    tableView.layer.cornerRadius=2.0f;
    return tableView;
    
}

//-(UIView*)viewForTableView:(id)sender frame:(CGRect)frame
//{
//    UIView* self1 = [[UIView alloc] initWithFrame:frame];
//    self1.tag=561;
//    self1.backgroundColor=[UIColor whiteColor];
//    overlay= [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//   // tap=[[UITapGestureRecognizer alloc]initWithTarget:sender action:@selector(dismissPopView:)];
//   // tap.delegate=sender;
//
//    overlay=[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//
//    [overlay addGestureRecognizer:tap];
//    overlay.tag=111;
//
//    overlay.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.2];
//
//
//   // return overlay;
//
//    UIView* doneCancelButtonView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 80)];
//
//    UIButton* doneButton=[[UIButton alloc]initWithFrame:CGRectMake(doneCancelButtonView.frame.size.width-80, 10, 70,30)];
//    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
//    doneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//    [doneButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    [doneCancelButtonView addSubview:doneButton];
//    [doneButton addTarget:self action:@selector(setAttendeeList:) forControlEvents:UIControlEventTouchUpInside];
//
//
//    UIButton* cancelButton=[[UIButton alloc]initWithFrame:CGRectMake(10, 10, 70,30)];
//    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
//    cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//
//    [cancelButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    [doneCancelButtonView addSubview:cancelButton];
//    [cancelButton addTarget:self action:@selector(cancelAttendeeList:) forControlEvents:UIControlEventTouchUpInside];
//
//
//    //////////////
//
//    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(frame.origin.x, frame.origin.y+80, frame.size.width, frame.size.height-80)];
//    UIView* sectionHeaderView=[[UIView alloc]initWithFrame:CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y, tableView.frame.size.width, 50)];
//
//    UISwitch* historySwitch=[[UISwitch alloc]initWithFrame:CGRectMake(10, 20, tableView.frame.size.width/3, 20)];
//   // [sectionTitleLabel setFont:[UIFont systemFontOfSize:16.0]];
//   // UIFont *currentFont = sectionTitleLabel.font;
//   // UIFont *newFont = [UIFont fontWithName:[NSString stringWithFormat:@"%@-Bold",currentFont.fontName] size:currentFont.pointSize];
//   // sectionTitleLabel.font = newFont;
//   // sectionTitleLabel.text=@"Select Department";
//    [sectionHeaderView addSubview:historySwitch];
//
//    tableView.tableHeaderView=sectionHeaderView;
//    tableView.dataSource=sender;
//    tableView.delegate=sender;
//    UITableViewCell * cell=[[UITableViewCell alloc]init];
//    [tableView addSubview:cell];
//    tableView.layer.cornerRadius=2.0f;
//
//    [self1 addSubview:doneCancelButtonView];
//    [self1 addSubview:tableView];
//
//    if (self1)
//    {
//        // Initialization code
//        // initilize all your UIView components
//        [overlay addSubview:self1];
//    }
//    return overlay;
//
//}

- (UIView*)initWithFrame:(CGRect)frame senderNameForSlider :(id)sender player:(AVAudioPlayer*)player
{
    self = [super initWithFrame:frame];
    self.backgroundColor=[UIColor darkGrayColor];
    overlay= [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    tap=[[UITapGestureRecognizer alloc]initWithTarget:sender action:@selector(dismissPlayerView:)];
    tap.delegate=sender;
    overlay=[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [overlay addGestureRecognizer:tap];
    overlay.tag=222;
    
    overlay.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.4];
    
    if (self)
    {
        // Initialization code
        // initilize all your UIView components
        self.tag=223;
        UISlider* audioRecordSlider=[[UISlider alloc]initWithFrame:CGRectMake(self.frame.size.width*0.05,self.frame.size.height*0.1 , self.frame.size.width*0.9, 30)];
        [audioRecordSlider addTarget:sender action:@selector(sliderValueChanged) forControlEvents:UIControlEventValueChanged];
        //audioRecordSlider.minimumValue = 0.0;
        audioRecordSlider.continuous = YES;
        audioRecordSlider.tag=224;
        
        UILabel* dateAndTimeLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width*0.04, self.frame.size.height*0.5, self.frame.size.width*0.5, 20)];
        //audioRecordSlider.maximumValue=player.duration;
        [dateAndTimeLabel setFont:[UIFont systemFontOfSize:12]];
        dateAndTimeLabel.textColor=[UIColor whiteColor];
        dateAndTimeLabel.tag=225;
        
        UILabel* recordingLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width*0.04, self.frame.size.height*0.7, self.frame.size.width*0.5, 20)];
        recordingLabel.text=@"Your recording";
        [recordingLabel setFont:[UIFont systemFontOfSize:12]];
        recordingLabel.textColor=[UIColor whiteColor];
        
        UIImageView* playAndPauseImageView=[[UIImageView alloc]initWithFrame:CGRectMake(audioRecordSlider.frame.size.width-8, self.frame.size.height*0.6, 15, 15)];
        playAndPauseImageView.image=[UIImage imageNamed:@"Pause"];
        playAndPauseImageView.tag=226;
        
        UIButton* playAndPauseButton=[[UIButton alloc]initWithFrame:CGRectMake(audioRecordSlider.frame.size.width-10, self.frame.size.height*0.6, 40, 40)];
        
        [playAndPauseButton addTarget:sender action:@selector(playOrPauseButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:dateAndTimeLabel];
        [self addSubview:recordingLabel];
        [self addSubview:playAndPauseButton];
        [self addSubview:playAndPauseImageView];
        
        [self addSubview:audioRecordSlider];
    }
    [overlay addSubview:self];
    
    return overlay;
}


- (UIView*)initWithFrame:(CGRect)frame senderForInternetMessage :(id)sender
{
    self = [super initWithFrame:frame];
    self.backgroundColor=[UIColor darkGrayColor];
    overlay= [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    overlay=[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    overlay.tag=222;
    
    overlay.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.4];
    
    if (self)
    {
        // Initialization code
        // initilize all your UIView components
        self.tag=223;
        
        
        UILabel* dateAndTimeLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width*0.05, self.frame.size.height*0.3, self.frame.size.width*0.9, 20)];
        //audioRecordSlider.maximumValue=player.duration;
        dateAndTimeLabel.text=@"No internet connection,please try again";
        [dateAndTimeLabel setFont:[UIFont systemFontOfSize:12]];
        dateAndTimeLabel.textColor=[UIColor whiteColor];
        dateAndTimeLabel.tag=224;
        
        
        
        
        UIButton* playAndPauseButton=[[UIButton alloc]initWithFrame:CGRectMake((self.frame.size.width/2) - 30, self.frame.size.height*0.5, 60, 40)];
        playAndPauseButton.tag=225;
        [playAndPauseButton setTitle:@"Retry" forState:UIControlStateNormal];
        [playAndPauseButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [playAndPauseButton addTarget:sender action:@selector(refresh:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:dateAndTimeLabel];
        [self addSubview:playAndPauseButton];
        
    }
    [overlay addSubview:self];
    return overlay;
}

//- (UIView*)initWithFrame:(CGRect)frame sender:(id)sender
//{
//    self = [super initWithFrame:frame];
//    self.backgroundColor=[UIColor whiteColor];
//    overlay= [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    tap=[[UITapGestureRecognizer alloc]initWithTarget:sender action:@selector(dismissPopView:)];
//
//    overlay=[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//
//    [overlay addGestureRecognizer:tap];
//    overlay.tag=111;
//
//    overlay.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.2];
//
//    if (self)
//    {
//        // Initialization code
//        // initilize all your UIView components
//        UIButton* userSettingsButton=[[UIButton alloc]initWithFrame:CGRectMake(5, 0, 0, 0)];
//
//            //userSettingsButton.titleLabel.textAlignment=NSTextAlignmentCenter;
//
//            userSettingsButton=[[UIButton alloc]initWithFrame:CGRectMake(0, userSettingsButton.frame.origin.x+userSettingsButton.frame.size.height, 160, 30)];
//            if (i==1)
//            {
//                userSettingsButton=[[UIButton alloc]initWithFrame:CGRectMake(0, userSettingsButton.frame.origin.x+userSettingsButton.frame.size.height+8, 160, 30)];
//
//            }
//            [userSettingsButton setTitle:[subViewNamesArray objectAtIndex:i] forState:UIControlStateNormal];
//            [userSettingsButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            userSettingsButton.titleLabel.font=[UIFont systemFontOfSize:14];
//            [userSettingsButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
//
//            NSString* selector=[NSString stringWithFormat:@"%@",[subViewNamesArray objectAtIndex:i]];
//            selector = [selector stringByReplacingOccurrencesOfString:@" " withString:@""];
//            [userSettingsButton addTarget:sender action:NSSelectorFromString(selector) forControlEvents:UIControlEventTouchUpInside];
//
//            //    [userSettingsButton setBackgroundColor:[UIColor colorWithRed:(i*155)/255.0 green:(i*155)/255.0 blue:(i*155)/255.0 alpha:1]];
//            [self addSubview:userSettingsButton];
//            self.layer.cornerRadius=2.0f;
//            //            selectSetting
//
//        [overlay addSubview:self];
//    }
//    return overlay;
//
//
//
//
//}

@end
