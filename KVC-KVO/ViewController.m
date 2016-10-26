//
//  ViewController.m
//  KVC-KVO
//
//  Created by EnzoF on 12.10.16.
//  Copyright © 2016 EnzoF. All rights reserved.
//

#import "ViewController.h"
#import "DatePickerPopoverController.h"
#import "GradePickerViewController.h"
#import "Student.h"

typedef enum{
    ViewControllerTypeFirstName         = 10,
    ViewControllerTypeLastName          = 20,
    ViewControllerTypeDayOfBirthField   = 100,
    ViewControllerTypeEducationField    = 200
}ViewControllerTypeSender;

@interface ViewController ()<UITextFieldDelegate,PopoverCDelegate>

@property (nonatomic,strong) Student *student;
@property (nonatomic,strong) Student *studentWithFriend;
@property(nonatomic, strong) NSMutableArray<Student*>*mArrayOfStudents;
@property (nonatomic,strong) DatePickerPopoverController *datePickerPC;
@property (nonatomic,strong) GradePickerViewController *gradePickerPC;

@end

@implementation ViewController

-(void)loadView{
    [super loadView];
    self.student = [Student randomStudent];
    [self  addObserver:@"firstName"];
    [self  addObserver:@"lastName"];
    [self  addObserver:@"dateOfBirth"];
    [self  addObserver:@"gender"];
    [self  addObserver:@"grade"];
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dateOfBirth.delegate = self;
    self.gradeTextField.delegate = self;
    
    self.firstName.text = self.student.firstName;
    self.lastName.text = self.student.lastName;
    self.genderControl.selectedSegmentIndex = self.student.gender == StudentFemale ? StudentFemale : StudentMale;
    self.dateOfBirth.text = [self stringFromDate:self.student.dateOfBirth];
    self.gradeTextField.text = self.student.grade;
    [self createArrayStudents:100000];
    
    NSLog(@"allnames: %@",[self allNames]);
    NSLog(@"min Date From Students %@",[self stringFromDate:[self minDate]]);
    NSLog(@"max Date From Students %@",[self stringFromDate:[self maxDate]]);
    
    NSLog(@"sum Grade %f",[self sumGrade]);
    
    NSLog(@"average Grade %ff",[self avrGrade]);

    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self createfriendForStudent];
    [self changeNameStudent];
}

-(void)dealloc{
    [self.student removeObserver:self forKeyPath:@"firstName"];
    [self.student removeObserver:self forKeyPath:@"lastName"];
    [self.student removeObserver:self forKeyPath:@"dateOfBirth"];
    [self.student removeObserver:self forKeyPath:@"gender"];
    [self.student removeObserver:self forKeyPath:@"grade"];
    [self.studentWithFriend removeObserver:self forKeyPath:@"firstName"];
    [self.studentWithFriend removeObserver:self forKeyPath:@"lastName"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - KVO
-(void)addObserver:(NSString*)propertyName {
    [self.student addObserver:self
              forKeyPath:propertyName
                 options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                 context:NULL];
}

-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary<NSString *,id> *)change
                      context:(void *)context{
    NSLog(@"changeProperty %@ object %@ change %@",keyPath,object,change);
}
-(NSMutableArray<Student*>*)mArrayOfStudents{
    if(!_mArrayOfStudents)
    {
        _mArrayOfStudents = [[NSMutableArray alloc]init];
    }
    return _mArrayOfStudents;
}


#pragma mark - actionChangeValue


- (IBAction)actionFirstNameChange:(UITextField *)sender forEvent:(UIEvent *)event {
    
    self.student.firstName = sender.text;
}

- (IBAction)actionLastNameChange:(UITextField *)sender forEvent:(UIEvent *)event {
    
    self.student.lastName = sender.text;
}

- (IBAction)actionGenderChange:(UISegmentedControl *)sender forEvent:(UIEvent *)event {
    
    self.student.gender = sender.selectedSegmentIndex ? StudentMale : StudentFemale;
}

#pragma mark - action

-(IBAction)actionClearAll:(UIButton *)sender{
    [self.student clearAll];
}


#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50.f;
}


#pragma mark - PopoverCDelegate

-(void)popoverController:(id<PopoverCDelegate>)popoverController valueFromPopover:(NSString *)valueStr sender:(id _Nullable)senderControl{
    if([(NSObject*)senderControl isKindOfClass:[UITextField class]])
    {
        UITextField *textFieldObj = (UITextField*)senderControl;
        switch (textFieldObj.tag) {
            case ViewControllerTypeDayOfBirthField:
                self.dateOfBirth.text = valueStr;
                self.student.dateOfBirth = [self dateFromString:valueStr];
                break;
            case ViewControllerTypeEducationField:
                self.gradeTextField.text = valueStr;
                self.student.grade = valueStr;
                break;
        }
        
    }
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    UIPopoverPresentationController *popoverPresentationC;
    BOOL totalShouldBeginEdititng = YES;
    if(textField.tag == ViewControllerTypeDayOfBirthField)
    {
        self.datePickerPC = [self.storyboard instantiateViewControllerWithIdentifier:@"DatePickerPopoverController"];
        self.datePickerPC.delegate = self;
        self.datePickerPC.senderControl = textField;
        self.datePickerPC.modalPresentationStyle = UIModalPresentationPopover;
        [self presentViewController:self.datePickerPC animated:YES completion:nil];
        if([textField.text length] > 0)
        {
            [self.datePickerPC.datePicker setDate:[self dateFromString:textField.text] animated:YES];
        }
        popoverPresentationC = [self.datePickerPC popoverPresentationController];
        popoverPresentationC.permittedArrowDirections = UIPopoverArrowDirectionDown;
        popoverPresentationC.sourceView = textField;
        totalShouldBeginEdititng = NO;
    }
    else if(textField.tag == ViewControllerTypeEducationField)
    {
        self.gradePickerPC = [self.storyboard instantiateViewControllerWithIdentifier:@"EducationPickerViewController"];
        self.gradePickerPC.delegate = self;
        self.gradePickerPC.senderControl = textField;
        self.gradePickerPC.modalPresentationStyle = UIModalPresentationPopover;
        [self presentViewController:self.gradePickerPC animated:YES completion:nil];
        if([textField.text length] > 0)
        {
            NSInteger indexRow = [self.gradePickerPC.arrayGradeTypes indexOfObject:textField.text];
            [self.gradePickerPC.gradePicker selectRow:indexRow inComponent:0 animated:YES];
        }
        popoverPresentationC = [self.gradePickerPC popoverPresentationController];
        popoverPresentationC.permittedArrowDirections = UIPopoverArrowDirectionDown;
        popoverPresentationC.sourceView = textField;
        totalShouldBeginEdititng = NO;
    }
    return totalShouldBeginEdititng;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    BOOL totalShouldChange = NO;
    if(textField.tag == ViewControllerTypeFirstName)
    {
        totalShouldChange = [self shouldChangeTextField:textField.text inputStr:string];
    }
    else if(textField.tag == ViewControllerTypeLastName)
    {
        totalShouldChange = [self shouldChangeTextField:textField.text inputStr:string];
    }
    return totalShouldChange;
}

#pragma mark - Date metods

-(NSDate*)dateFromString:(NSString*)dateStr{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    NSLocale *locale = [NSLocale localeWithLocaleIdentifier:@"ru_RU"];
    [dateFormatter setDateFormat:@"dd MMMM yyyy"];
    [dateFormatter setLocale:locale];
    NSDate *date = [dateFormatter dateFromString:dateStr];
    return date;
}

-(NSString*)stringFromDate:(NSDate*)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    NSLocale *locale = [NSLocale localeWithLocaleIdentifier:@"ru_RU"];
    [dateFormatter setLocale:locale];
    [dateFormatter setDateFormat:@"dd MMMM yyyy"];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    return dateStr;
}

-(BOOL)shouldChangeTextField:(NSString*)text inputStr:(NSString*)inputStr{
    BOOL totalShouldChange  = YES;
    NSCharacterSet *validSet = [[NSCharacterSet letterCharacterSet] invertedSet];
    NSArray *component  = [text componentsSeparatedByCharactersInSet:validSet];
    if([component count] >1)
    {
        totalShouldChange = NO;
    }
    component  = [inputStr componentsSeparatedByCharactersInSet:validSet];
    if([component count] >1)
    {
        totalShouldChange = NO;
    }
    return totalShouldChange;
}


#pragma mark - metods for master level

-(void)createArrayStudents:(NSInteger)numberOfStudents{
    for(NSInteger i = 0 ; i < numberOfStudents;i++)
    {
        Student *student = [Student randomStudent];
        student.identifier = i;
        [self.mArrayOfStudents addObject:student];
        if(i == 20)
        {
            self.studentWithFriend = student;
            [self.studentWithFriend addObserver:self forKeyPath:@"firstName" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
            [self.studentWithFriend addObserver:self forKeyPath:@"lastName" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
            
        }
    }
}


-(void)createfriendForStudent{
    for(NSInteger i = 0 ; i < [self.mArrayOfStudents count];i++)
    {
        Student *student = [self.mArrayOfStudents objectAtIndex:i];
        if([self.mArrayOfStudents count] - 1 == i)
        {
            [student setValue:[self.mArrayOfStudents objectAtIndex:0] forKey:@"currentFriend"];
        }else{
             [student setValue:[self.mArrayOfStudents objectAtIndex:i] forKey:@"currentFriend"];
        }
        student.identifier = i;
    }
}


-(void)changeNameStudent{
    for(NSInteger i = 0 ; i < [self.mArrayOfStudents count];i++)
    {
        Student *student = [self.mArrayOfStudents objectAtIndex:i];
        student.firstName = [NSString stringWithFormat:@"%@ - %d",student.firstName,i];
        student.lastName = [NSString stringWithFormat:@"%@ - %d",student.lastName,i];
    }
}
-(NSArray*)allNames{
    NSMutableArray *mArrayNames = [[NSMutableArray alloc]init];
    for (Student *currentStudent in self.mArrayOfStudents)
    {
        [mArrayNames addObject:[currentStudent valueForKey:@"firstName"]];
    }
    return[[NSArray alloc]initWithArray:mArrayNames];
}

-(CGFloat)sumGrade{
    CGFloat totalSumGrade = 0.f;
    for (Student *currentStudent in self.mArrayOfStudents)
    {
        CGFloat currentGrade = [self gradeFromString:[currentStudent valueForKey:@"grade"]];
        totalSumGrade += currentGrade;
    }
    return totalSumGrade;
}

-(CGFloat)avrGrade{
    CGFloat avrGrade = 0.f;
    if([self.mArrayOfStudents count] > 0)
    {
        avrGrade =  [self sumGrade] / (CGFloat)[self.mArrayOfStudents count];
    }
    return avrGrade;
}


-(NSDate*)maxDate{
    NSDate *maxDate = [NSDate dateWithTimeIntervalSince1970:0];
    for (Student *currentStudent in self.mArrayOfStudents)
    {
        NSDate* currentDate = [currentStudent valueForKey:@"dateOfBirth"];

        maxDate = [maxDate laterDate:currentDate];
    }
    return maxDate;

}

-(NSDate*)minDate{
    NSDate *minDate = [NSDate dateWithTimeIntervalSinceNow:0];
    for (Student *currentStudent in self.mArrayOfStudents)
    {
        NSDate* currentDate = [currentStudent valueForKey:@"dateOfBirth"];
        minDate = [minDate earlierDate:currentDate];
    }
    return minDate;
    
}


-(CGFloat)gradeFromString:(NSString*)gradeName{
    CGFloat totalGrade;
    if([gradeName isEqualToString: @"Outland"])
    {
        totalGrade = 100.f;
    }else if([gradeName isEqualToString: @"Supreme"]){
        totalGrade = 93.f;
        
    }else if([gradeName isEqualToString: @"Artful"]){
        totalGrade = 85.f;
        
    }else if([gradeName isEqualToString: @"Beautiful"]){
        totalGrade = 77.f;
        
    }else if([gradeName isEqualToString: @"Creditable"]){
        totalGrade = 70.f;
        
    }else if([gradeName isEqualToString: @"Diversly"]){
        totalGrade = 63.f;
        
    }else if([gradeName isEqualToString: @"Enough"]){
         totalGrade = 50.f;
        
    }else if([gradeName isEqualToString: @"Fail"]){
        totalGrade = 1.f;
    }
    else
    {
        totalGrade = 0.f;
    }
    return totalGrade;
}


@end
