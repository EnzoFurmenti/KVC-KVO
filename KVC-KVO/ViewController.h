//
//  ViewController.h
//  KVC-KVO
//
//  Created by EnzoF on 12.10.16.
//  Copyright © 2016 EnzoF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UITextField *firstName;
@property (weak, nonatomic) IBOutlet UITextField *lastName;

@property (weak, nonatomic) IBOutlet UISegmentedControl *genderControl;

@property (weak, nonatomic) IBOutlet UITextField *dateOfBirth;

@property (weak, nonatomic) IBOutlet UITextField *gradeTextField;



- (IBAction)actionClearAll:(UIButton *)sender;

- (IBAction)actionFirstNameChange:(UITextField *)sender forEvent:(UIEvent *)event;

- (IBAction)actionLastNameChange:(UITextField *)sender forEvent:(UIEvent *)event;

- (IBAction)actionGenderChange:(UISegmentedControl *)sender forEvent:(UIEvent *)event;

@end

