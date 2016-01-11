//
//  TaskCalendarColorTheme.h
//  Calendar
//
//  Created by Alexander on 11.01.16.
//  Copyright © 2016 Alexander. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIColor.h>
#import <UIKit/UIFont.h>

@class TaskCalendar;

@interface TaskCalendarColorTheme : NSObject
@property(nonatomic, strong) UIColor *selectColor;
@property(nonatomic, strong) UIColor *textColor;
@property(nonatomic, strong) UIColor *textYearColor;
@property(nonatomic, strong) UIColor *selectQuickDaysColor;
@property(nonatomic, strong) UIColor *backgroundColor;


@property(nonatomic, strong) UIFont *fontForDay;
@property(nonatomic, strong) UIFont *fontForMonth;
@property(nonatomic, strong) UIFont *fontForYear;
@property(nonatomic, strong) UIFont *fontForQuickDay;

@end
