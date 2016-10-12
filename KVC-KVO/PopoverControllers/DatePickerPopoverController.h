//
//  DatePickerPopoverController.h
//  KVC-KVO
//
//  Created by EnzoF on 12.10.16.
//  Copyright © 2016 EnzoF. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PopoverController.h"

@interface DatePickerPopoverController : PopoverController<PopoverCDelegate>

@property(weak,nonatomic) IBOutlet UIDatePicker *datePicker;

-(IBAction)actionValueChanged:(UIDatePicker*)sender;

@end
