//
//  ViewController.m
//  Calendar
//
//  Created by Alexander on 16.12.15.
//  Copyright © 2015 Alexander. All rights reserved.
//

#import "ViewController.h"
#import "TaskCalendar.h"
#import "TaskDateButton.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    TaskCalendar *calendar = [[[NSBundle mainBundle] loadNibNamed:@"TaskCalendar" owner:self options:nil] objectAtIndex:0];
    calendar.backgroundColor = [UIColor colorWithRed:34.0/255.0  green:31.0/255.0  blue:40.0/255.0  alpha:1];
    [calendar setFrame:CGRectMake(0, self.view.frame.size.height / 1.8, self.view.frame.size.width, self.view.frame.size.height / 2.2)];
    calendar.selectColor = [UIColor colorWithRed:72.0/255.0  green:145.0/255.0  blue:170.0/255.0  alpha:1];
    calendar.textColor = [UIColor colorWithRed:70.0/255.0  green:70.0/255.0  blue:79.0/255.0  alpha:1];
    calendar.textYearColor = [UIColor colorWithRed:51.0/255.0  green:48.0/255.0  blue:55.0/255.0  alpha:1];
    calendar.selectFastDaysColor = [UIColor colorWithRed:170.0/255.0  green:188.0/255.0  blue:98.0/255.0  alpha:1];

    UILabel *view = [[UILabel alloc] initWithFrame:CGRectMake(50, 50 , 300, 300)];
    [view setText:@"sdfsdfsdfsdf"];
    [self.view addSubview:view];
    
    [self.view addSubview:calendar];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
