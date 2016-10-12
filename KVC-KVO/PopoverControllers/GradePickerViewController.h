//
//  EducationPickerViewController.h
//  KVC-KVO
//
//  Created by EnzoF on 12.10.16.
//  Copyright © 2016 EnzoF. All rights reserved.
//

#import "PopoverController.h"

@interface GradePickerViewController : PopoverController

@property (strong,nonatomic) NSArray *arrayGradeTypes;

@property (weak, nonatomic) IBOutlet UIPickerView *gradePicker;



@end
