//
//  TaskCalendarColorTheme.m
//  Calendar
//
//  Created by Alexander on 11.01.16.
//  Copyright © 2016 Alexander. All rights reserved.
//

#import "TaskCalendarColorTheme.h"
#import "TaskCalendar.h"
#import "TaskDateButton.h"
#import "TaskMonthView.h"

@implementation TaskCalendarColorTheme {

}


- (instancetype)init {
    self = [super init];
    if (self) {
        [self setDefaultsColorTheme];
    }

    return self;
}

- (void)setDefaultsColorTheme {
    self.backgroundColor = [UIColor colorWithRed:38.0 / 255.0 green:36.0 / 255.0 blue:43.0 / 255.0 alpha:1];
    self.textColor = [UIColor colorWithRed:70.0 / 255.0 green:70.0 / 255.0 blue:79.0 / 255.0 alpha:1];
    self.selectColor = [UIColor colorWithRed:72.0 / 255.0 green:145.0 / 255.0 blue:170.0 / 255.0 alpha:1];
    self.textYearColor = [UIColor colorWithRed:51.0 / 255.0 green:48.0 / 255.0 blue:55.0 / 255.0 alpha:1];
    self.selectQuickDaysColor = [UIColor colorWithRed:170.0 / 255.0 green:188.0 / 255.0 blue:98.0 / 255.0 alpha:1];


    self.fontForDay = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
    self.fontForMonth = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
    self.fontForYear = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
    self.fontForQuickDay = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
}


@end
