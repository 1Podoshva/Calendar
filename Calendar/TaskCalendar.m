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
#import "TaskMonthView.h"

#define ADD_WIGHT_SIZE 20
#define HEIGHT_CELL_SIZE 30
#define COUNT_DAYS 30

@implementation TaskCalendar {

    NSDateComponents *currentDateComponents;
    TaskDateButton *selectDay;
    TaskDateButton *selectMonth;
    TaskDateButton *selectYear;
    TaskQuickDateButton *selectQuickDay;
    NSInteger selectQuickDayTag;
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
    for (int i = 1; i <= numberOfDaysInMonth; i++) {
        TaskDateButton *dayButton = [[TaskDateButton alloc] initWithFrame:dayButtonSize withType:TaskButtonType_Day withSelectColor:self.selectColor withTextColor:self.textColor];
        [dayButton setTitle:[NSString stringWithFormat:@"%i", i] forState:UIControlStateNormal];
        dayButton.tag = i;
        dayButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        dayButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [dayButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]];
        dayButton.type = TaskButtonType_Day;
        [dayButton addTarget:self action:@selector(daySelect:) forControlEvents:UIControlEventTouchUpInside];
        if (currentDateComponents.day != i && i < currentDateComponents.day) {
            dayButton.enabled = NO;
            dayButton.alpha = 0.3;
        } else if (currentDateComponents.day == i) {
            selectDay = dayButton;
            selectDay.select = YES;
        }
        [self.dayScrollView addSubview:dayButton];
    }

    for (int i = 0; i < self.calendar.shortMonthSymbols.count; i++) {
        UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
        TaskMonthView *monthView = [[[NSBundle mainBundle] loadNibNamed:@"TaskMonthView" owner:self options:nil] lastObject];
        monthView.backgroundColor = [UIColor clearColor];
        monthView.frame = monthButtonSize;
        NSString *nameMonth = self.calendar.shortMonthSymbols[i];
        nameMonth = [nameMonth stringByReplacingCharactersInRange:NSMakeRange(0, 1)
                                                       withString:[[nameMonth substringToIndex:1] capitalizedString]];
        [monthView.monthButton setTitle:[NSString stringWithFormat:@"%@", nameMonth] forState:UIControlStateNormal];
        [monthView.monthButton.titleLabel setFont:font];
        monthView.monthButton.type = TaskButtonType_Month;
        monthView.monthButton.tag = i + 1;
        monthView.tag = i + 1;
        monthView.monthButton.textColor = self.textColor;
        monthView.monthButton.selectColor = self.selectColor;
        [monthView.monthButton addTarget:self action:@selector(monthSelect:) forControlEvents:UIControlEventTouchUpInside];
        [monthView.numberMonthLabel setTextColor:self.textColor];
        [monthView.numberMonthLabel setFont:font];
        if (i < 9) {
            [monthView.numberMonthLabel setText:[NSString stringWithFormat:@"0%i", i + 1]];
        } else {
            [monthView.numberMonthLabel setText:[NSString stringWithFormat:@"%i", i + 1]];
        }
        if (currentDateComponents.month - 1 == i) {
            selectMonth = monthView.monthButton;
            selectMonth.select = YES;
            [monthView.numberMonthLabel setTextColor:self.selectColor];
        }
        [self.monthScrollView addSubview:monthView];

    }
    for (int i = [currentDateComponents year]; i < [currentDateComponents year] + 10; i++) {
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

    [_quickDaysArray addObjectsFromArray:[[TaskDateQuickSnapManager instance] quickDaysWithCalendar:self.calendar fromDate:self.currentDate]];
    [_quickDaysArray addObjectsFromArray:[[TaskDateQuickSnapManager instance] quickDaysWithCalendar:self.calendar fromDate:self.currentDate afterDay:NSMakeRange(1, 3)]];
    dateValue = [[TaskDateQuickSnapManager instance] findFirstWeekendWithCalendar:self.calendar fromDate:self.currentDate];
    weekendDateComponentsContext = [[TaskDateQuickSnapManager instance] taskDateComponentsContextFrom:[self.calendar components:DATE_COMPONENTS_UNIT fromDate:dateValue]];
    weekendDateComponentsContext.nameValue = @"on weekend";
    [_quickDaysArray addObject:weekendDateComponentsContext];

    endMonthDateComponentsContext = [[TaskDateQuickSnapManager instance] taskDateComponentsContextFrom:[[TaskDateQuickSnapManager instance] endMonthWithCalendar:self.calendar currentDate:self.currentDate]];
    if (endMonthDateComponentsContext) {
        endMonthDateComponentsContext.nameValue = @"end month";
        [_quickDaysArray addObject:endMonthDateComponentsContext];
    }

    nextMonthDateComponentsContext = [[TaskDateQuickSnapManager instance] taskDateComponentsContextFrom:[[TaskDateQuickSnapManager instance] nextMonthWithCalendar:self.calendar currentDate:self.currentDate]];
    nextMonthDateComponentsContext.nameValue = @"next month";
    [_quickDaysArray addObject:nextMonthDateComponentsContext];

    nextWeekDateComponentsContext = [[TaskDateQuickSnapManager instance] taskDateComponentsContextFrom:[[TaskDateQuickSnapManager instance] nextWeekWithCalendar:self.calendar currentDate:self.currentDate]];
    nextWeekDateComponentsContext.nameValue = @"next week";
    [_quickDaysArray addObject:nextWeekDateComponentsContext];

    thisWeekDateComponentsContext = [[TaskDateQuickSnapManager instance] taskDateComponentsContextFrom:[[TaskDateQuickSnapManager instance] thisWeekWithCalendar:self.calendar currentDate:self.currentDate]];
    if (thisWeekDateComponentsContext) {
        thisWeekDateComponentsContext.nameValue = @"this week";
        [_quickDaysArray addObject:thisWeekDateComponentsContext];
    }


}

- (void)awakeFromNib {
    [super awakeFromNib];
    selectQuickDayTag = INT_MAX;
    _quickDaysArray = [[NSMutableArray alloc] init];
    monthButtonSize = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width / 4, self.monthScrollView.frame.size.height);
    dayButtonSize = CGRectMake(0, 0, 35, 35);
    yearButtonSize = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width / 5, 30);
    CGFloat daySpacing = ([UIScreen mainScreen].bounds.size.width / COUNT_DAYS) / 2;
    [self.dayScrollView setSpacing:daySpacing];
    [self createButtons];
    [self updateMonthScrollViewPosition];
    view = [[UILabel alloc] initWithFrame:CGRectMake(0, -300, 300, 300)];
    [self addSubview:view];
    NSDate *date = [[TaskDateQuickSnapManager instance] findFirstWeekendWithCalendar:self.calendar fromDate:self.currentDate];
    [self.fastDaysCollectionView registerNib:[UINib nibWithNibName:@"TaskCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"Cell"];
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
    TaskMonthView *monthView = (TaskMonthView *) monthSelect.superview;
    TaskMonthView *oldMonthView = (TaskMonthView *) [selectMonth superview];
    if (selectQuickDay) {
        [oldMonthView.numberMonthLabel setTextColor:self.textColor];
        selectQuickDay.select = NO;
        selectQuickDay = nil;
    }
    if (selectMonth.tag == monthSelect.tag) {
        selectMonth.select = YES;
        [oldMonthView.numberMonthLabel setTextColor:self.textColor];
        [monthView.numberMonthLabel setTextColor:self.selectColor];
    } else {
        selectMonth.select = NO;
        [oldMonthView.numberMonthLabel setTextColor:self.textColor];
        [monthView.numberMonthLabel setTextColor:self.selectColor];
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
        selectQuickDayTag = quickDaySelect.tag;
        _selectDateComponents = [self.calendar components:DATE_COMPONENTS_UNIT fromDate:selectQuickDay.quickDate];
        [self setSelectButtons];
        [self selectDate];
    }
    [view setText:[NSString stringWithFormat:@"DATE %@", selectQuickDay.quickDate]];
}

- (void)selectDate {
    if (self.delegate) {
        [self.delegate TaskCalendarSelectDate:[self.calendar dateFromComponents:self.selectDateComponents]];
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

    if (currentNumberDays <= numberOfDaysInMonth) {
        for (int i = 0; i < numberOfDaysInMonth; ++i) {
            if (i < currentNumberDays) {
                TaskDateButton *taskButton = self.dayScrollView.subviews[i];
                [taskButton setTitle:[NSString stringWithFormat:@"%i", i + 1] forState:UIControlStateNormal];
                taskButton.tag = i + 1;
                taskButton.enabled = YES;
                taskButton.alpha = 1;
                if (selectTag == i + 1) {
                    if (!selectQuickDay) {
                        [taskButton sendActionsForControlEvents:UIControlEventTouchUpInside];
                    }
                }
            } else {
                TaskDateButton *dayButton = [[TaskDateButton alloc] initWithFrame:dayButtonSize withType:TaskButtonType_Day withSelectColor:self.selectColor withTextColor:self.textColor];
                [dayButton setTitle:[NSString stringWithFormat:@"%i", i + 1] forState:UIControlStateNormal];
                dayButton.tag = i + 1;
                [dayButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]];
                dayButton.type = TaskButtonType_Day;
                [dayButton addTarget:self action:@selector(daySelect:) forControlEvents:UIControlEventTouchUpInside];
                dayButton.enabled = YES;
                dayButton.alpha = 1;
                if (selectTag == i + 1) {
                    if (!selectQuickDay) {
                        [dayButton sendActionsForControlEvents:UIControlEventTouchUpInside];
                    }
                }
                [self.dayScrollView addSubview:dayButton];
            }

        }
    } else if (currentNumberDays > numberOfDaysInMonth) {
        for (TaskDateButton *taskButton in [[self.dayScrollView.subviews reverseObjectEnumerator] allObjects]) {
            if (self.dayScrollView.subviews.count != numberOfDaysInMonth) {
                [taskButton removeFromSuperview];
            } else {
                taskButton.enabled = YES;
                taskButton.alpha = 1;
                if (selectTag == taskButton.tag) {
                    if (!selectQuickDay) {
                        [taskButton sendActionsForControlEvents:UIControlEventTouchUpInside];
                    }
                }
            }
        }
    }
    if (_selectDateComponents.month == currentComponents.month && _selectDateComponents.year == currentComponents.year) {
        for (int i = 0; i < numberOfDaysInMonth; i++) {
            if (i < currentNumberDays) {
                TaskDateButton *taskButton = self.dayScrollView.subviews[i];
                [taskButton setTitle:[NSString stringWithFormat:@"%i", i + 1] forState:UIControlStateNormal];
                if (currentDateComponents.day != i + 1 && i + 1 < currentDateComponents.day) {
                    taskButton.enabled = NO;
                    taskButton.alpha = 0.3;
                } else if (selectTag == i + 1) {
                    if (!selectQuickDay) {
                        [taskButton sendActionsForControlEvents:UIControlEventTouchUpInside];
                    }
                }
            }
        }
        if (selectTag < currentComponents.day) {
            TaskDateButton *taskButton = self.dayScrollView.subviews[currentComponents.day - 1];
            if (!selectQuickDay && taskButton) {
                [taskButton sendActionsForControlEvents:UIControlEventTouchUpInside];
            }
        }
    }
    [self.dayScrollView layoutIfNeeded];
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
    for (TaskMonthView *monthView in self.monthScrollView.subviews) {
        [monthView.numberMonthLabel setTextColor:self.textColor];
        if (monthView.monthButton.tag == _selectDateComponents.month) {
            selectMonth.select = NO;
            selectMonth = nil;
            selectMonth = monthView.monthButton;
            selectMonth.select = YES;
            [monthView.numberMonthLabel setTextColor:self.selectColor];
        }
    }
    /*
    for (TaskDateButton *monthButton in self.monthScrollView.subviews) {
        if (monthButton.tag == _selectDateComponents.month) {
            selectMonth.select = NO;
            selectMonth = nil;
            selectMonth = monthButton;
            selectMonth.select = YES;
        }
    }
     */
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

    for (TaskMonthView *monthView in self.monthScrollView.subviews) {
        monthView.monthButton.textColor = textColor;
        [monthView.numberMonthLabel setTextColor:textColor];
    }
    /*
    for (TaskDateButton *quickDateButton in _quickDaysArray) {
        quickDateButton.textColor = textColor;
    }
     */
}

- (void)setSelectColor:(UIColor *)selectColor {
    _selectColor = selectColor;
    for (TaskDateButton *dayButton in self.dayScrollView.subviews) {
        dayButton.selectColor = selectColor;
    }

    for (TaskMonthView *monthView in self.monthScrollView.subviews) {
        monthView.monthButton.selectColor = selectColor;
        if (selectMonth.tag == monthView.monthButton.tag) {
            [monthView.numberMonthLabel setTextColor:self.selectColor];
        }
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
    return _quickDaysArray.count;
}

- (TaskCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TaskCollectionViewCell *cell = (TaskCollectionViewCell *) [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    TaskDateComponentsContext *dateComponentsContext = _quickDaysArray[indexPath.row];
    [cell.quickDateButton setTitle:dateComponentsContext.nameValue forState:UIControlStateNormal];
    cell.quickDateButton.selectColor = _selectQuickDaysColor;
    cell.quickDateButton.textColor = _textColor;
    cell.quickDateButton.type = TaskButtonType_FastDay;
    cell.quickDateButton.tag = indexPath.row;
    NSLog(@"Item %i", indexPath.row);
    cell.quickDateButton.quickDate = [self.calendar dateFromComponents:dateComponentsContext];
    [cell.quickDateButton addTarget:self action:@selector(quickDaySelect:) forControlEvents:UIControlEventTouchUpInside];
    if (selectQuickDayTag == indexPath.row) {
        cell.quickDateButton.select = YES;
    } else {
        cell.quickDateButton.select = NO;
    }
    [cell layoutIfNeeded];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    TaskDateComponentsContext *dateComponentsContext;
    CGSize stringBoundingBox;
    dateComponentsContext = _quickDaysArray[(NSUInteger) indexPath.row];
    stringBoundingBox = [dateComponentsContext.nameValue sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]];
    return CGSizeMake(stringBoundingBox.width + ADD_WIGHT_SIZE, HEIGHT_CELL_SIZE);
}

@end
