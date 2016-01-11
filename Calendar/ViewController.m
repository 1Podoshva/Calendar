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

@interface ViewController () <TaskCalendarDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    TaskCalendar *calendar = [[[NSBundle mainBundle] loadNibNamed:@"TaskCalendar" owner:self options:nil] objectAtIndex:0];
    [calendar setFrame:CGRectMake(0, self.view.frame.size.height / 2.3, self.view.frame.size.width, self.view.frame.size.height / 1.7)];
    calendar.delegate = self;


    UILabel *view = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, 300, 300)];
    [self.view addSubview:view];
    [self.view addSubview:calendar];

}


- (void)TaskCalendarSelectDate:(NSDate *)date {
    NSLog(@"date SELECT %@", date);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
