//
//  EducationPickerViewController.m
//  KVC-KVO
//
//  Created by EnzoF on 12.10.16.
//  Copyright © 2016 EnzoF. All rights reserved.
//

#import "GradePickerViewController.h"

@interface GradePickerViewController ()<PopoverCDelegate,UIPickerViewDelegate,UIPickerViewDataSource>


@end

@implementation GradePickerViewController
-(void)loadView{
    [super loadView];
    [self.gradePicker setDelegate:self];
    [self.gradePicker setDataSource:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.arrayGradeTypes = @[@"Other-wordly",@"Supreme",@"Artful",@"Beautiful",@"Creditable",@"Diversly",@"Enough",@"Fail",@"Unhonest"];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSString *strGrade = [self.arrayGradeTypes objectAtIndex:[self.gradePicker selectedRowInComponent:0]];
    [self popoverController:self valueStr:strGrade];
}

#pragma mark - UIPickerViewDataSource


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [self.arrayGradeTypes count];
}


#pragma mark - UIPickerViewDelegate


- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component __TVOS_PROHIBITED{
    
    return [self.arrayGradeTypes objectAtIndex:row];
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component __TVOS_PROHIBITED{
    NSString *valueStr = [self.arrayGradeTypes objectAtIndex:row];
    [self popoverController:self valueStr:valueStr];
}
@end
