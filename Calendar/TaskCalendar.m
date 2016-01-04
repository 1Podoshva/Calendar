//
//  TaskCalendar.m
//  Calendar
//
//  Created by Alexander on 16.12.15.
//  Copyright © 2015 Alexander. All rights reserved.
//

#import "TaskCalendar.h"
#import "TaskDateButton.h"
#import "TaskCollectionViewCell.h"
#import "TaskDateQuickSnapManager.h"

#define ADD_WIGHT_SIZE 20
#define HEIGHT_CELL_SIZE 20
#define COUNT_DAYS 30

@implementation TaskCalendar {
    NSMutableArray *quickDaysArray;
    NSDateComponents *currentDateComponents;
    TaskDateButton *selectDay;
    TaskDateButton *selectMonth;
    TaskDateButton *selectYear;
    TaskQuickDateButton *selectQuickDay;
    UILabel *view;

    CGRect monthButtonSize;
    CGRect dayButtonSize;
    CGRect yearButtonSize;
}


- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self createCalendar];

    }

    return self;
}

- (void)createCalendar {
    self.calendar = [NSCalendar autoupdatingCurrentCalendar];
    _currentDate = [NSDate date];
    _selectDateComponents = [[NSDateComponents alloc] init];
    NSCalendarUnit units = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    currentDateComponents = [self.calendar components:units fromDate:_currentDate];
    [_selectDateComponents setDay:currentDateComponents.day];
    [_selectDateComponents setMonth:currentDateComponents.month];
    [_selectDateComponents setYear:currentDateComponents.year];

}

- (void)createButtons {
    NSRange range = [self.calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self.currentDate];
    NSUInteger numberOfDaysInMonth = range.length;
    for (int i = currentDateComponents.day; i <= numberOfDaysInMonth; i++) {
        TaskDateButton *dayButton = [[TaskDateButton alloc] initWithFrame:dayButtonSize withType:TaskButtonType_Day withSelectColor:self.selectColor withTextColor:self.textColor];
        [dayButton setTitle:[NSString stringWithFormat:@"%i", i] forState:UIControlStateNormal];
        dayButton.tag = i;
        dayButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        dayButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [dayButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]];
        dayButton.type = TaskButtonType_Day;
        [dayButton addTarget:self action:@selector(daySelect:) forControlEvents:UIControlEventTouchUpInside];
        if (currentDateComponents.day == i) {
            selectDay = dayButton;
            selectDay.select = YES;
        }
        [self.dayScrollView addSubview:dayButton];
    }

    for (int i = 0; i < self.calendar.shortMonthSymbols.count; i++) {
        TaskDateButton *monthButton = [[TaskDateButton alloc] initWithFrame:monthButtonSize withType:TaskButtonType_Month withSelectColor:self.selectColor withTextColor:self.textColor];;
        [monthButton setTitle:[NSString stringWithFormat:@"%@", self.calendar.shortMonthSymbols[i]] forState:UIControlStateNormal];
        [monthButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]];
        monthButton.type = TaskButtonType_Month;
        monthButton.tag = i + 1;
        monthButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        monthButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [monthButton addTarget:self action:@selector(monthSelect:) forControlEvents:UIControlEventTouchUpInside];
        if (currentDateComponents.month - 1 == i) {
            selectMonth = monthButton;
            selectMonth.select = YES;
        }
        [self.monthScrollView addSubview:monthButton];

    }
    for (int i = [currentDateComponents year]; i < [currentDateComponents year] + 50; i++) {
        TaskDateButton *yearButton = [[TaskDateButton alloc] initWithFrame:yearButtonSize withType:TaskButtonType_Day withSelectColor:self.selectColor withTextColor:self.textYearColor];;
        [yearButton setTitle:[NSString stringWithFormat:@"%i", i] forState:UIControlStateNormal];
        [yearButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]];
        yearButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        yearButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        yearButton.tag = i;
        yearButton.type = TaskButtonType_Year;
        [yearButton addTarget:self action:@selector(yearSelect:) forControlEvents:UIControlEventTouchUpInside];
        if (currentDateComponents.year == i) {
            selectYear = yearButton;
            selectYear.select = YES;
        }
        [self.yearScrollView addSubview:yearButton];
    }


    NSDate *dateValue;
    TaskDateComponentsContext *weekendDateComponentsContext;
    TaskDateComponentsContext *endMonthDateComponentsContext;
    TaskDateComponentsContext *nextMonthDateComponentsContext;
    TaskDateComponentsContext *nextWeekDateComponentsContext;
    TaskDateComponentsContext *thisWeekDateComponentsContext;

    [quickDaysArray addObjectsFromArray:[[TaskDateQuickSnapManager instance] quickDaysWithCalendar:self.calendar fromDate:self.currentDate]];
    [quickDaysArray addObjectsFromArray:[[TaskDateQuickSnapManager instance] quickDaysWithCalendar:self.calendar fromDate:self.currentDate afterDay:NSMakeRange(1, 3)]];
    dateValue = [[TaskDateQuickSnapManager instance] findFirstWeekendWithCalendar:self.calendar fromDate:self.currentDate];
    weekendDateComponentsContext = [[TaskDateQuickSnapManager instance] taskDateComponentsContextFrom:[self.calendar components:DATE_COMPONENTS_UNIT fromDate:dateValue]];
    weekendDateComponentsContext.nameValue = @"on weekend";
    [quickDaysArray addObject:weekendDateComponentsContext];

    endMonthDateComponentsContext = [[TaskDateQuickSnapManager instance] taskDateComponentsContextFrom:[[TaskDateQuickSnapManager instance] endMonthWithCalendar:self.calendar currentDate:self.currentDate]];
    if (endMonthDateComponentsContext) {
        endMonthDateComponentsContext.nameValue = @"end month";
        [quickDaysArray addObject:endMonthDateComponentsContext];
    }

    nextMonthDateComponentsContext = [[TaskDateQuickSnapManager instance] taskDateComponentsContextFrom:[[TaskDateQuickSnapManager instance] nextMonthWithCalendar:self.calendar currentDate:self.currentDate]];
    nextMonthDateComponentsContext.nameValue = @"next month";
    [quickDaysArray addObject:nextMonthDateComponentsContext];

    nextWeekDateComponentsContext = [[TaskDateQuickSnapManager instance] taskDateComponentsContextFrom:[[TaskDateQuickSnapManager instance] nextWeekWithCalendar:self.calendar currentDate:self.currentDate]];
    nextWeekDateComponentsContext.nameValue = @"next week";
    [quickDaysArray addObject:nextWeekDateComponentsContext];

    thisWeekDateComponentsContext = [[TaskDateQuickSnapManager instance] taskDateComponentsContextFrom:[[TaskDateQuickSnapManager instance] thisWeekWithCalendar:self.calendar currentDate:self.currentDate]];
    if (thisWeekDateComponentsContext) {
        thisWeekDateComponentsContext.nameValue = @"this week";
        [quickDaysArray addObject:thisWeekDateComponentsContext];
    }


}

- (void)awakeFromNib {
    [super awakeFromNib];
    quickDaysArray = [[NSMutableArray alloc] init];
    monthButtonSize = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width / 4, self.monthScrollView.frame.size.height);
    dayButtonSize = CGRectMake(0, 0, 30, 30);
    yearButtonSize = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width / 5, 30);


    CGFloat daySpacing = ([UIScreen mainScreen].bounds.size.width / COUNT_DAYS) / 2;
    [self.dayScrollView setSpacing:daySpacing];

    [self createButtons];
    [self updateMonthScrollViewPosition];
    view = [[UILabel alloc] initWithFrame:CGRectMake(0, -300, 300, 300)];
    [self addSubview:view];

    NSDate *date = [[TaskDateQuickSnapManager instance] findFirstWeekendWithCalendar:self.calendar fromDate:self.currentDate];
    NSLog(@"www%@", date);
}


# pragma mark TaskButtonAction

- (void)yearSelect:(TaskDateButton *)yearSelect {
    if (selectQuickDay) {
        selectQuickDay.select = NO;
        selectQuickDay = nil;
    }
    if (selectYear.tag == yearSelect.tag) {
        selectYear.select = YES;
    } else {
        selectYear.select = NO;
        selectYear = yearSelect;
        [_selectDateComponents setYear:yearSelect.tag];
    }
    [self updateNumberDays];
    [self updateDayScrollViewPosition];
    [view setText:[NSString stringWithFormat:@"day: %i, month: %i, year: %i", _selectDateComponents.day, _selectDateComponents.month, _selectDateComponents.year]];
    [self selectDate];
}

- (void)monthSelect:(TaskDateButton *)monthSelect {
    if (selectQuickDay) {
        selectQuickDay.select = NO;
        selectQuickDay = nil;
    }
    if (selectMonth.tag == monthSelect.tag) {
        selectMonth.select = YES;
    } else {
        selectMonth.select = NO;
        selectMonth = monthSelect;
        [_selectDateComponents setMonth:monthSelect.tag];
    }
    [self updateNumberDays];
    [self updateDayScrollViewPosition];
    [view setText:[NSString stringWithFormat:@"day: %i, month: %i, year: %i", _selectDateComponents.day, _selectDateComponents.month, _selectDateComponents.year]];
    [self selectDate];
}

- (void)daySelect:(TaskDateButton *)daySelect {
    if (selectQuickDay) {
        selectQuickDay.select = NO;
        selectQuickDay = nil;
    }
    if (selectDay.tag == daySelect.tag) {
        selectDay.select = YES;
    } else {
        selectDay.select = NO;
        selectDay = daySelect;
        [_selectDateComponents setDay:daySelect.tag];
    }
    [view setText:[NSString stringWithFormat:@"day: %i, month: %i, year: %i", _selectDateComponents.day, _selectDateComponents.month, _selectDateComponents.year]];
    [self selectDate];
}

- (void)quickDaySelect:(TaskQuickDateButton *)quickDaySelect {
    if (selectQuickDay && selectQuickDay.tag == quickDaySelect.tag) {
        selectQuickDay = nil;
        //selectQuickDay.select = YES;
    } else {
        selectQuickDay.select = NO;
        selectQuickDay = quickDaySelect;
        _selectDateComponents = [self.calendar components:DATE_COMPONENTS_UNIT fromDate:selectQuickDay.quickDate];
        [self setSelectButtons];
        [self selectDate];
    }
    [view setText:[NSString stringWithFormat:@"DATE %@", selectQuickDay.quickDate]];
}

- (void)selectDate {
    if (self.delegate) {
        [self.delegate selectDate:[self.calendar dateFromComponents:self.selectDateComponents]];
    }
}


# pragma mark UpdateDaysButton

- (void)updateNumberDays {
    NSInteger selectTag = selectDay.tag;
    selectDay.select = NO;
    selectDay = nil;
    NSDate *selectDate = [self.calendar dateFromComponents:_selectDateComponents];
    NSDateComponents *dateComponents;
    NSDateComponents *currentComponents;
    dateComponents = [self.calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:selectDate];
    currentComponents = [self.calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self.currentDate];
    if (!selectQuickDay) {
        if (dateComponents.day < selectTag) {
            _selectDateComponents.day = selectTag - dateComponents.day;
            selectTag = _selectDateComponents.day;
            selectDate = [self.calendar dateFromComponents:_selectDateComponents];
        }
    }

    NSRange range = [self.calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:selectDate];
    NSUInteger numberOfDaysInMonth = range.length;
    NSInteger currentNumberDays = self.dayScrollView.subviews.count;

    if (currentNumberDays < numberOfDaysInMonth && (_selectDateComponents.month != currentComponents.month | _selectDateComponents.year != currentComponents.year)) {
        for (int i = 0; i < numberOfDaysInMonth; ++i) {
            if (i < currentNumberDays) {
                TaskDateButton *taskButton = self.dayScrollView.subviews[i];
                [taskButton setTitle:[NSString stringWithFormat:@"%i", i + 1] forState:UIControlStateNormal];
                taskButton.tag = i + 1;
                if (selectTag == taskButton.tag) {
                    if (!selectQuickDay) {
                        [taskButton sendActionsForControlEvents:UIControlEventTouchUpInside];
                    }

                }
            } else {
                TaskDateButton *dayButton = [[TaskDateButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30) withType:TaskButtonType_Day withSelectColor:self.selectColor withTextColor:self.textColor];
                [dayButton setTitle:[NSString stringWithFormat:@"%i", i + 1] forState:UIControlStateNormal];
                dayButton.tag = i + 1;
                [dayButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]];
                dayButton.type = TaskButtonType_Day;
                [dayButton addTarget:self action:@selector(daySelect:) forControlEvents:UIControlEventTouchUpInside];
                if (selectTag == dayButton.tag) {
                    if (!selectQuickDay) {
                        [dayButton sendActionsForControlEvents:UIControlEventTouchUpInside];
                    }
                }
                [self.dayScrollView addSubview:dayButton];

            }

        }
    } else if (_selectDateComponents.month == currentComponents.month && _selectDateComponents.year == currentComponents.year) {
        for (TaskDateButton *taskButton in [[self.dayScrollView.subviews reverseObjectEnumerator] allObjects]) {
            if (self.dayScrollView.subviews.count - 1 != numberOfDaysInMonth - currentComponents.day) {
                [taskButton removeFromSuperview];
            } else {
                break;
            }
        }
        for (int i = 0; i < self.dayScrollView.subviews.count; i++) {
            TaskDateButton *taskButton = self.dayScrollView.subviews[i];
            [taskButton setTag:currentComponents.day + i];
            [taskButton setTitle:[NSString stringWithFormat:@"%i", currentComponents.day + i] forState:UIControlStateNormal];
            if (taskButton.tag == selectTag) {
                if (!selectQuickDay) {
                    [taskButton sendActionsForControlEvents:UIControlEventTouchUpInside];
                }
            }
        }
        if (selectTag < currentComponents.day) {
            TaskDateButton *taskButton = self.dayScrollView.subviews[0];
            if (!selectQuickDay) {
                [taskButton sendActionsForControlEvents:UIControlEventTouchUpInside];
            }
        }

    } else {
        for (int i = self.dayScrollView.subviews.count - 1; i >= 0; i--) {
            TaskDateButton *taskButton = self.dayScrollView.subviews[i];
            if (i >= numberOfDaysInMonth) {
                [taskButton removeFromSuperview];
                taskButton = nil;
                NSLog(@"dd%@", taskButton.titleLabel.text);
            } else if (taskButton) {
                taskButton.tag = i + 1;
                if (taskButton.tag == selectTag) {
                    [taskButton setTitle:[NSString stringWithFormat:@"%i", i + 1] forState:UIControlStateNormal];
                    if (!selectQuickDay) {
                        [taskButton sendActionsForControlEvents:UIControlEventTouchUpInside];
                    }

                }
            }
        }

    }
    [self.dayScrollView layoutIfNeeded];

    NSLog(@"TaskScrollViewFrame: %f", self.dayScrollView.contentSize.width);

}

- (void)setSelectButtons {
    for (TaskDateButton *yearButton in self.yearScrollView.subviews) {
        if (yearButton.tag == _selectDateComponents.year) {
            selectYear.select = NO;
            selectYear = nil;
            selectYear = yearButton;
            selectYear.select = YES;
        }
    }

    for (TaskDateButton *monthButton in self.monthScrollView.subviews) {
        if (monthButton.tag == _selectDateComponents.month) {
            selectMonth.select = NO;
            selectMonth = nil;
            selectMonth = monthButton;
            selectMonth.select = YES;
        }
    }
    [self updateMonthScrollViewPosition];
    [self updateNumberDays];
    for (TaskDateButton *dayButton in self.dayScrollView.subviews) {
        if (dayButton.tag == _selectDateComponents.day) {
            selectDay.select = NO;
            selectDay = nil;
            selectDay = dayButton;
            selectDay.select = YES;
        } else {

        }
    }

    [self updateDayScrollViewPosition];
}

- (void)updateDayScrollViewPosition {
    /*
    CGPoint dayButtonPosition = selectDay.frame.origin;
    CGPoint contentOffset = _dayScrollView.contentOffset;
    CGFloat countOffset = (self.dayScrollView.contentSize.width / self.dayScrollView.frame.size.width);
    CGFloat oneWidth = self.dayScrollView.contentSize.width  / countOffset;
    NSInteger part = 0;
    CGFloat positionX = oneWidth;
    do {
        positionX = positionX + oneWidth;
        part++;
    } while (positionX < dayButtonPosition.x);
    CGFloat x = 0;
    if (part == 1) {
        x = 0;
    } else {
        x = oneWidth * part -  self.dayScrollView.frame.size.width / 2;
    }
    contentOffset = CGPointMake(x, contentOffset.y);
    [self.dayScrollView setContentOffset:contentOffset animated:YES];
    */

    CGPoint dayButtonPosition = selectDay.frame.origin;
    CGPoint contentOffset = _dayScrollView.contentOffset;
    NSInteger iterations = (NSInteger) (self.dayScrollView.contentSize.width / self.dayScrollView.frame.size.width);
    CGFloat widthContSize = 0;
    CGFloat width = self.monthScrollView.frame.size.width;
    for (NSInteger i = 0; i < iterations; i++) {
        if (dayButtonPosition.x >= widthContSize && dayButtonPosition.x <= widthContSize + width) {
            contentOffset = CGPointMake(widthContSize, _dayScrollView.contentOffset.y);
            break;
        } else {
            widthContSize += width;
        }
    }
    [self.dayScrollView setContentOffset:contentOffset animated:YES];
}

- (void)updateMonthScrollViewPosition {
    CGPoint monthButtonPosition = selectMonth.frame.origin;
    CGPoint contentOffset = _monthScrollView.contentOffset;
    if (monthButtonPosition.x >= self.monthScrollView.contentSize.width / 3) {
        if (monthButtonPosition.x >= self.monthScrollView.contentSize.width / 3 + self.monthScrollView.contentSize.width / 3) {
            contentOffset = CGPointMake(self.monthScrollView.contentSize.width / 3 + self.monthScrollView.contentSize.width / 3, _monthScrollView.contentOffset.y);
        } else {
            contentOffset = CGPointMake(self.monthScrollView.contentSize.width / 3, _monthScrollView.contentOffset.y);
        }

    } else {
        contentOffset = CGPointMake(0, _monthScrollView.contentOffset.y);
    }

    [self.monthScrollView setContentOffset:contentOffset animated:YES];

}

# pragma mark Draw

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.5);
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGFloat components[] = {81.0 / 255.0, 80.0 / 255.0, 87.0 / 255.0, 1.0};
    CGColorRef color = CGColorCreate(colorspace, components);
    CGContextSetStrokeColorWithColor(context, color);

    float boundY = self.dayScrollView.bounds.size.height;
    CGContextMoveToPoint(context, 5, boundY);
    CGContextAddLineToPoint(context, self.dayScrollView.bounds.size.width - 5, boundY);
    CGContextStrokePath(context);

    boundY += self.monthScrollView.bounds.size.height;

    CGContextMoveToPoint(context, 5, boundY);
    CGContextAddLineToPoint(context, self.monthScrollView.bounds.size.width - 5, boundY);
    CGContextStrokePath(context);


    boundY = self.bounds.size.height - self.fastDaysCollectionView.bounds.size.height;
    CGContextMoveToPoint(context, 5, boundY);
    CGContextAddLineToPoint(context, self.fastDaysCollectionView.bounds.size.width - 5, boundY);
    CGContextStrokePath(context);

    CGColorSpaceRelease(colorspace);
    CGColorRelease(color);
}

# pragma mark Setters

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    for (TaskDateButton *dayButton in self.dayScrollView.subviews) {
        dayButton.textColor = textColor;
    }
    for (TaskDateButton *monthButton in self.monthScrollView.subviews) {
        monthButton.textColor = textColor;
    }
    /*
    for (TaskDateButton *quickDateButton in quickDaysArray) {
        quickDateButton.textColor = textColor;
    }
     */
}

- (void)setSelectColor:(UIColor *)selectColor {
    _selectColor = selectColor;
    for (TaskDateButton *dayButton in self.dayScrollView.subviews) {
        dayButton.selectColor = selectColor;
    }
    for (TaskDateButton *monthButton in self.monthScrollView.subviews) {
        monthButton.selectColor = selectColor;
    }
    for (TaskDateButton *yearButton in self.yearScrollView.subviews) {
        yearButton.selectColor = selectColor;
    }
}

- (void)setTextYearColor:(UIColor *)textYearColor {
    _textYearColor = textYearColor;
    for (TaskDateButton *yearButton in self.yearScrollView.subviews) {
        yearButton.textColor = textYearColor;
    }
}

- (void)setSelectQuickDaysColor:(UIColor *)selectQuickDaysColor {
    _selectQuickDaysColor = selectQuickDaysColor;
}


#pragma mark UICollectionViewDelegate && UICollectionViewDataSours

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return quickDaysArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TaskCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    TaskDateComponentsContext *dateComponentsContext = quickDaysArray[indexPath.row];

    [cell.quickDateButton setTitle:dateComponentsContext.nameValue forState:UIControlStateNormal];
    cell.quickDateButton.selectColor = _selectQuickDaysColor;
    cell.quickDateButton.textColor = _textColor;
    cell.quickDateButton.type = TaskButtonType_FastDay;
    cell.quickDateButton.tag = indexPath.row;
    cell.quickDateButton.quickDate = [self.calendar dateFromComponents:dateComponentsContext];
    [cell.quickDateButton addTarget:self action:@selector(quickDaySelect:) forControlEvents:UIControlEventTouchUpInside];

    /*
    [cell.quickDateButton setTitle:[quickDaysArray objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    cell.quickDateButton.selectColor = _selectQuickDaysColor;
    cell.quickDateButton.textColor = _textColor;
    cell.quickDateButton.type = TaskButtonType_FastDay;
    cell.quickDateButton.tag = indexPath.row;
    [cell.quickDateButton addTarget:self action:@selector(quickDaySelect:) forControlEvents:UIControlEventTouchUpInside];
     */

    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    TaskDateComponentsContext *dateComponentsContext;
    CGSize stringBoundingBox;
    dateComponentsContext = quickDaysArray[(NSUInteger) indexPath.row];
    stringBoundingBox = [dateComponentsContext.nameValue sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]];
    return CGSizeMake(stringBoundingBox.width + ADD_WIGHT_SIZE, HEIGHT_CELL_SIZE);
}

@end
