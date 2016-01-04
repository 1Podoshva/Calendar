//
// Created by Alexander on 23.12.15.
// Copyright (c) 2015 Alexander. All rights reserved.
//

#import "TaskDateQuickSnapManager.h"

#define NOT_HOUR_TIME 1
#define TOMORROW 1
#define DAY_AFTER_TOMORROW 2

@implementation TaskDateQuickSnapManager {

}
+ (TaskDateQuickSnapManager *)instance {
    static TaskDateQuickSnapManager *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }

    return _instance;
}


- (NSArray <TaskDateComponentsContext *> *)quickDaysWithCalendar:(NSCalendar *)calendar fromDate:(NSDate *)date {
    if (calendar && date) {
        NSMutableArray *array;
        TaskDateComponentsContext *today;
        TaskDateComponentsContext *tomorrow;
        TaskDateComponentsContext *dayAfterTomorrow;
        NSDateComponents *currentComponents;
        currentComponents = [calendar components:DATE_COMPONENTS_UNIT fromDate:date];
        NSInteger minutes = currentComponents.hour * 60 + currentComponents.minute;
        if (minutes < (24 * 60) - (60 * NOT_HOUR_TIME)) {
            NSDateComponents *todayComp = [calendar components:DATE_COMPONENTS_UNIT fromDate:date];
            today = [self taskDateComponentsContextFrom:todayComp];
            today.nameValue = @"today";
        }
        tomorrow = [self taskDateComponentsContextFrom:[self dateComponentsWithCalendar:calendar fromCurrentComponents:currentComponents afterDay:TOMORROW]];
        tomorrow.nameValue = @"tomorrow";
        dayAfterTomorrow = [self taskDateComponentsContextFrom:[self dateComponentsWithCalendar:calendar fromCurrentComponents:currentComponents afterDay:DAY_AFTER_TOMORROW]];
        dayAfterTomorrow.nameValue = @"dayAfterTomorrow";
        array = [NSMutableArray array];
        if (today) {
            [array addObject:today];
        }
        [array addObject:tomorrow];
        [array addObject:dayAfterTomorrow];
        return array;

    }
    NSLog(@"PARAMS IS NULL");
    return nil;
}


- (NSArray <TaskDateComponentsContext *> *)quickDaysWithCalendar:(NSCalendar *)calendar fromDate:(NSDate *)date afterDay:(NSRange)range {
    if (calendar && date) {
        NSMutableArray *array = [NSMutableArray array];
        NSInteger count = range.location + range.length;
        NSDateComponents *components = [calendar components:DATE_COMPONENTS_UNIT fromDate:date];
        for (int i = range.location; i <= count; ++i) {
            NSDateComponents *dateComponents = [self dateComponentsWithCalendar:calendar fromCurrentComponents:components afterDay:i];
            NSString *nameValue = [self dayNameWithCalendar:calendar withComponents:dateComponents];
            TaskDateComponentsContext *taskDateComponentsContext = [self taskDateComponentsContextFrom:dateComponents];
            taskDateComponentsContext.nameValue = nameValue;
            [array addObject:taskDateComponentsContext];
        }
        return array;
    }
    NSLog(@"PARAMS IS NULL");
    return nil;
}


- (NSDateComponents *)dateComponentsWithCalendar:(NSCalendar *)calendar fromCurrentComponents:(NSDateComponents *)components afterDay:(NSInteger)afterDay {
    if (calendar && components) {
        NSDate *dateValue;
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        dateComponents.day = components.day + afterDay;
        dateComponents.year = components.year;
        dateComponents.month = components.month;
        dateComponents.hour = components.hour;
        dateComponents.minute = components.minute;
        dateValue = [calendar dateFromComponents:dateComponents];
        dateComponents = [calendar components:DATE_COMPONENTS_UNIT fromDate:dateValue];
        return dateComponents;
    }
    NSLog(@"PARAMS IS NULL");
    return nil;
}


- (NSString *)dayNameWithCalendar:(NSCalendar *)calendar withComponents:(NSDateComponents *)components {
    if (calendar && components) {
        NSDate *date = [calendar dateFromComponents:components];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"EEEE"];
        return [dateFormatter stringFromDate:date];
    }

    NSLog(@"PARAMS IS NULL");
    return nil;
}


- (NSDate *)findFirstWeekendWithCalendar:(NSCalendar *)calendar fromDate:(NSDate *)date {
    if (calendar && date) {
        NSDate *weekendDate = [date copy];
        NSInteger afterDay = 0;
        NSDateComponents *components;
        NSDateComponents *weekendComponents;
        NSDateComponents *currentComponents = [calendar components:DATE_COMPONENTS_UNIT fromDate:date];
        do {
            components = [calendar components:DATE_COMPONENTS_UNIT fromDate:weekendDate];
            components = [self dateComponentsWithCalendar:calendar fromCurrentComponents:currentComponents afterDay:afterDay];
            weekendDate = [calendar dateFromComponents:components];
            afterDay++;
        } while (![calendar isDateInWeekend:weekendDate]);
        weekendComponents = [[NSDateComponents alloc] init];
        weekendComponents.day = components.day;
        weekendComponents.month = components.month;
        weekendComponents.year = components.year;
        weekendComponents.hour = components.hour;
        weekendComponents.minute = components.minute;
        return [calendar dateFromComponents:weekendComponents];
    }
    NSLog(@"PARAMS IS NULL");
    return nil;
}

- (NSDate *)lastDayInMonthWithCalendar:(NSCalendar *)calendar currentDate:(NSDate *)date {
    if (date) {
        NSDateComponents *dateComponents = [calendar components:DATE_COMPONENTS_UNIT fromDate:date];
        NSRange range = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:date];
        NSUInteger numberOfDaysInMonth = range.length;
        dateComponents.day = numberOfDaysInMonth;
        return [calendar dateFromComponents:dateComponents];
    }
    NSLog(@"PARAMS IS NULL");
    return nil;
}

- (NSDateComponents *)endMonthWithCalendar:(NSCalendar *)calendar currentDate:(NSDate *)date {
    if (calendar && date) {
        NSDateComponents *currentComponents;
        NSDateComponents *dateComponents;
        currentComponents = [calendar components:DATE_COMPONENTS_UNIT fromDate:date];
        NSRange range = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:date];
        NSUInteger numberOfDaysInMonth = range.length;
        if (numberOfDaysInMonth == currentComponents.day) {
            NSInteger minutes = currentComponents.hour * 60 + currentComponents.minute;
            if (minutes > (24 * 60) - (60 * NOT_HOUR_TIME)) {
                return nil;
            }
        }
        NSDate *dateValue = [self lastDayInMonthWithCalendar:calendar currentDate:date];
        dateComponents = [calendar components:DATE_COMPONENTS_UNIT fromDate:dateValue];
        return dateComponents;
    }
    return nil;
}

- (NSDateComponents *)nextMonthWithCalendar:(NSCalendar *)calendar currentDate:(NSDate *)date {
    if (date && calendar) {
        NSDate *dateValue;
        NSDateComponents *dateComponents;
        dateValue = [self lastDayInMonthWithCalendar:calendar currentDate:date];
        dateComponents = [calendar components:DATE_COMPONENTS_UNIT fromDate:dateValue];
        dateComponents.day = dateComponents.day + 1;
        dateValue = [calendar dateFromComponents:dateComponents];
        dateComponents = [calendar components:DATE_COMPONENTS_UNIT fromDate:dateValue];
        return dateComponents;
    }
    NSLog(@"PARAMS IS NULL");
    return nil;
}

- (NSDateComponents *)nextWeekWithCalendar:(NSCalendar *)calendar currentDate:(NSDate *)date {
    if (calendar && date) {
        NSDate *dateValue;
        NSDate *firstWeekend = [self findFirstWeekendWithCalendar:calendar fromDate:date];
        NSDateComponents *nextWeek = [calendar components:DATE_COMPONENTS_UNIT fromDate:firstWeekend];
        nextWeek.day = nextWeek.day + 1;
        dateValue = [calendar dateFromComponents:nextWeek];
        nextWeek = [calendar components:DATE_COMPONENTS_UNIT fromDate:dateValue];
        return nextWeek;
    }
    NSLog(@"PARAMS IS NULL");
    return nil;
}

- (NSDateComponents *)thisWeekWithCalendar:(NSCalendar *)calendar currentDate:(NSDate *)date {
    if (calendar && date) {
        NSDateComponents *currentComponents;
        NSDateComponents *weekendComponents;
        currentComponents = [calendar components:DATE_COMPONENTS_UNIT fromDate:date];

        NSDate *weekendDate = [self findFirstWeekendWithCalendar:calendar fromDate:date];
        weekendComponents = [calendar components:DATE_COMPONENTS_UNIT fromDate:weekendDate];
        if (weekendComponents.day == currentComponents.day) {
            NSInteger minutes = currentComponents.hour * 60 + currentComponents.minute;
            if (minutes > (24 * 60) - (60 * NOT_HOUR_TIME)) {
                return nil;
            }
        }
        weekendComponents.day = weekendComponents.day;
        NSDate *thisWeekDate = [calendar dateFromComponents:weekendComponents];
        return [calendar components:DATE_COMPONENTS_UNIT fromDate:thisWeekDate];
    }
    return nil;
}

- (TaskDateComponentsContext *)taskDateComponentsContextFrom:(NSDateComponents *)dateComponents {
    if (dateComponents) {
        TaskDateComponentsContext *taskDateComponentsContext = [[TaskDateComponentsContext alloc] init];
        taskDateComponentsContext.day = dateComponents.day;
        taskDateComponentsContext.month = dateComponents.month;
        taskDateComponentsContext.year = dateComponents.year;
        taskDateComponentsContext.hour = dateComponents.hour;
        taskDateComponentsContext.minute = dateComponents.minute;
        return taskDateComponentsContext;
    }
    NSLog(@"PARAMS IS NULL");
    return nil;

}


@end