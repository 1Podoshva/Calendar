//
//  TaskCalendar.h
//  Calendar
//
//  Created by Alexander on 16.12.15.
//  Copyright © 2015 Alexander. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskCalendarCollectionView.h"
#import "TaskDatePickerScrollView.h"
#import "TaskCalendarColorTheme.h"


@protocol TaskCalendarDelegate <NSObject>
- (void)TaskCalendarSelectDate:(NSDate *)date;
@end

@interface TaskCalendar : UIView <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property(weak, nonatomic, readonly) IBOutlet TaskDatePickerScrollView *dayScrollView;
@property(weak, nonatomic, readonly) IBOutlet TaskDatePickerScrollView *monthScrollView;
@property(weak, nonatomic, readonly) IBOutlet TaskDatePickerScrollView *yearScrollView;
@property(weak, nonatomic, readonly) IBOutlet TaskCalendarCollectionView *quickDaysCollectionView;

@property(nonatomic, readonly, strong) NSMutableArray *quickDaysArray;
@property(nonatomic, strong) NSCalendar *calendar;
@property(nonatomic, readonly) NSDate *currentDate;
@property(nonatomic, readonly) NSDateComponents *selectDateComponents;
@property(nonatomic, weak) id <TaskCalendarDelegate> delegate;
@property(nonatomic, strong) TaskCalendarColorTheme *taskCalendarColorTheme;

@end
