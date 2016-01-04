//
//  TaskCollectionViewCell.h
//  Calendar
//
//  Created by Alexander on 18.12.15.
//  Copyright © 2015 Alexander. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskQuickDateButton.h"

@interface TaskCollectionViewCell : UICollectionViewCell
@property(weak, nonatomic) IBOutlet TaskQuickDateButton *quickDateButton;


@end
