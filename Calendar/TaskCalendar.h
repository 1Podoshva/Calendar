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


@protocol TaskCalendarDelegate <NSObject>
- (void)TaskCalendarSelectDate:(NSDate *)date;
@end

@interface TaskCalendar : UIView <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property(weak, nonatomic) IBOutlet TaskDatePickerScrollView *dayScrollView;
@property(weak, nonatomic) IBOutlet TaskDatePickerScrollView *monthScrollView;
@property(weak, nonatomic) IBOutlet TaskDatePickerScrollView *yearScrollView;
@property(weak, nonatomic) IBOutlet TaskCalendarCollectionView *quickDaysCollectionView;

@property(nonatomic, readonly, strong) NSMutableArray *quickDaysArray;
@property(nonatomic, strong) UIColor *selectColor;
@property(nonatomic, strong) UIColor *textColor;
@property(nonatomic, strong) UIColor *textYearColor;
@property(nonatomic, strong) UIColor *selectQuickDaysColor;
@property(nonatomic, strong) NSCalendar *calendar;
@property(nonatomic, readonly) NSDate *currentDate;
@property(nonatomic, readonly) NSDateComponents *selectDateComponents;
@property(nonatomic, weak) id <TaskCalendarDelegate> delegate;

@end
