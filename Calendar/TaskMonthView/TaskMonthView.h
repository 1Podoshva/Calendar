//
//  TaskMonthView.h
//  Calendar
//
//  Created by Alexander on 04.01.16.
//  Copyright © 2016 Alexander. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskDateButton.h"

@interface TaskMonthView : UIView
@property(weak, nonatomic) IBOutlet TaskDateButton *monthButton;
@property(weak, nonatomic) IBOutlet UILabel *numberMonthLabel;
@end
