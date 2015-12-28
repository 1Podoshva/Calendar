//
//  TaskCalendar.h
//  Calendar
//
//  Created by Alexander on 16.12.15.
//  Copyright © 2015 Alexander. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskCalendarCollectionView.h"
@interface TaskCalendar : UIView <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UIStackView *dayStackView;
@property (weak, nonatomic) IBOutlet UIScrollView *dayScrollView;
@property (weak, nonatomic) IBOutlet UIStackView *monthStackView;
@property (weak, nonatomic) IBOutlet UIScrollView *monthScrollView;
@property (weak, nonatomic) IBOutlet UIStackView *yearStackView;
@property (weak, nonatomic) IBOutlet UIScrollView *yearScrollView;
@property (weak, nonatomic) IBOutlet TaskCalendarCollectionView *fastDaysCollectionView;


@property (nonatomic, strong) UIColor *selectColor;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *textYearColor;
@property (nonatomic, strong) UIColor *selectFastDaysColor; // преопределить setter
@property (nonatomic, strong) NSCalendar *calendar;
@property (nonatomic, readonly) NSDate *currentDate;
@property (nonatomic, readonly) NSDateComponents *selectDateComponents;



@end
