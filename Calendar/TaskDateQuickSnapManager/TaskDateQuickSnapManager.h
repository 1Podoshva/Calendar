//
// Created by Alexander on 23.12.15.
// Copyright (c) 2015 Alexander. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TaskDateComponentsContext.h"

#define DATE_COMPONENTS_UNIT NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitDay | NSCalendarUnitYear | NSCalendarUnitMonth

@interface TaskDateQuickSnapManager : NSObject


+ (TaskDateQuickSnapManager *)instance;

- (NSArray <TaskDateComponentsContext *> *)quickDaysWithCalendar:(NSCalendar *)calendar fromDate:(NSDate *)date;

- (NSArray <TaskDateComponentsContext *> *)quickDaysWithCalendar:(NSCalendar *)calendar fromDate:(NSDate *)date afterDay:(NSRange)range;

- (NSString *)dayNameWithCalendar:(NSCalendar *)calendar withComponents:(NSDateComponents *)components;

- (NSDate *)findFirstWeekendWithCalendar:(NSCalendar *)calendar fromDate:(NSDate *)date;

- (NSDate *)lastDayInMonthWithCalendar:(NSCalendar *)calendar currentDate:(NSDate *)date;

- (NSDateComponents *)endMonthWithCalendar:(NSCalendar *)calendar currentDate:(NSDate *)date;

- (NSDateComponents *)nextMonthWithCalendar:(NSCalendar *)calendar currentDate:(NSDate *)date;

- (NSDateComponents *)nextWeekWithCalendar:(NSCalendar *)calendar currentDate:(NSDate *)date;

- (NSDateComponents *)thisWeekWithCalendar:(NSCalendar *)calendar currentDate:(NSDate *)date; //return last week work day

- (TaskDateComponentsContext *)taskDateComponentsContextFrom:(NSDateComponents *)dateComponents;
@end