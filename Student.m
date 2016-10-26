//
//  Student.m
//  KVC-KVO
//
//  Created by EnzoF on 12.10.16.
//  Copyright © 2016 EnzoF. All rights reserved.
//

#import "Student.h"

typedef enum{
    StudentGradeOtland      = 100,
    StudentGradeSupreme     = 93,
    StudentGradeArtful      = 85,
    StudentGradeBeautiful   = 77,
    StudentGradeCreditable  = 70,
    StudentGradeDiversly    = 63,
    StudentGradeEnough      = 50,
    StudentGradeFail        = 1,
    StudentGradeUnhonest    = 0
}StudentGradeType;

static NSString *firstFemaleNames[] = {
                                @"Милена",
                                @"Инна",
                                @"Альбина",
                                @"Алла",
                                @"Василиса",
                                @"Анжелика",
                                @"Маргарита",
                                @"Юлия",
                                @"Екатерина",
                                @"Альбина",
                                @"Дарья",
                                @"Адель",
                                @"Агапия",
                                @"Альсун"
};
static int firstFemaleNameCount = 14;


static NSString *firstMaleNames[] = {
                                @"Богдан",
                                @"Анатолий",
                                @"Тимофей",
                                @"Родион",
                                @"Семён",
                                @"Глеб",
                                @"Вячеслав",
                                @"Марат",
                                @"Владислав",
                                @"Ярослав",
                                @"Матвей",
                                @"Тимур",
                                @"Виталий",
                                @"Степан"
};
static int firstMaleNameCount = 14;


static NSString *lastNames[] = {
                                @"Шуткевич",
                                @"Робинович",
                                @"Тореро",
                                @"Айбу",
                                @"Хосе",
                                @"Каншау",
                                @"Франсуа",
                                @"Тойбухаа",
                                @"Качаа",
                                @"Зиа",
                                @"Хожулаа",
                                @"Дурново",
                                @"Дубяго",
                                @"Черных",
                                @"Сухих",
                                @"Чутких",
                                @"Белаго",
                                @"Хитрово",
                                @"Бегун",
                                @"Мельник",
                                @"Шевченко"
};
static int lastNameCount = 21;


@implementation Student

+(instancetype)randomStudent{
    Student *randomStudent = [[Student alloc]init];
    randomStudent = [randomStudent createRandomStudent];
    return randomStudent;
}




#pragma mark - metods
-(Student*)createRandomStudent{
    
    Student *randomStudent = [[Student alloc]init];
    
    BOOL isFemaleName = (arc4random() % 1001) /500;
    if(isFemaleName)
    {
        randomStudent.gender = StudentFemale;
        randomStudent.firstName = firstFemaleNames[arc4random() % firstFemaleNameCount];
    }
    else
    {
        randomStudent.gender = StudentMale;
        randomStudent.firstName = firstMaleNames[arc4random() % firstMaleNameCount];
    }

    randomStudent.lastName = lastNames[arc4random() % lastNameCount];
    randomStudent.dateOfBirth = [randomStudent dateOfBirthFromAge:16 toAge:21];
    randomStudent.grade = [self randomMark];
    return randomStudent;
}



-(void)addObserver:(Student*)student withProperty:(NSString*)propertyName {
    [student addObserver:student
                    forKeyPath:propertyName
                       options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                       context:NULL];
}



-(NSString*)randomMark{
    NSInteger grade = (arc4random() % 1001) / 10;
    NSString *gradeName;
    if(grade == StudentGradeOtland)
    {
        gradeName = @"Outland";
    }else if(grade >= StudentGradeSupreme){
        gradeName = @"Supreme";
        
    }else if(grade >= StudentGradeArtful){
        gradeName = @"Artful";
        
    }else if(grade >= StudentGradeBeautiful){
        gradeName = @"Beautiful";
        
    }else if(grade >= StudentGradeCreditable){
        gradeName = @"Creditable";
        
    }else if(grade >= StudentGradeDiversly){
        gradeName = @"Diversly";
        
    }else if(grade >= StudentGradeEnough){
        gradeName = @"Enough";
        
    }else if(grade >= StudentGradeFail){
        gradeName = @"Fail";
    }
    else
    {
        gradeName = @"Unhonest";
    }
    return gradeName;
}

-(void)clearAll{
    [self willChangeValueForKey:@"firstName"];
    _firstName = nil;
    [self didChangeValueForKey:@"firstName"];
    
    [self willChangeValueForKey:@"lastName"];
    _lastName = nil;
    [self didChangeValueForKey:@"lastName"];
    
    [self willChangeValueForKey:@"grade"];
    _grade = nil;
    [self didChangeValueForKey:@"grade"];
    
    [self willChangeValueForKey:@"dateOfBirth"];
    _dateOfBirth = nil;
    [self didChangeValueForKey:@"dateOfBirth"];
}

-(NSString*)description{
    return [NSString stringWithFormat:@"Student: %@ %@",self.lastName, self.firstName];
}

#pragma mark - metods Date

- (NSDate*)dateOfBirthFromAge:(NSInteger)fromAge toAge:(NSInteger)toAge{
    NSDate *currentdDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *allCurrentDateComponents = [calendar components:  NSCalendarUnitEra   |
                                                  NSCalendarUnitYear  |
                                                  NSCalendarUnitMonth |
                                                  NSCalendarUnitDay   |
                                                  NSCalendarUnitHour  |
                                                  NSCalendarUnitMinute|
                                                  NSCalendarUnitSecond|
                                                  NSCalendarUnitNanosecond
                                                             fromDate:currentdDate];
    NSInteger era = [allCurrentDateComponents era];
    
    NSInteger fromYear = [allCurrentDateComponents year] - toAge;
    NSInteger toYear = [allCurrentDateComponents year] - fromAge;
    
    NSInteger month = [allCurrentDateComponents month];
    NSInteger day = [allCurrentDateComponents day];
    NSInteger hour = [allCurrentDateComponents hour];
    NSInteger minute = [allCurrentDateComponents minute];
    NSInteger second = [allCurrentDateComponents second];
    NSInteger nanosecond = [allCurrentDateComponents nanosecond];
    
    
    NSDate *fromDate = [calendar dateWithEra:era year:fromYear month:month day:day hour:hour minute:minute second:second nanosecond:nanosecond];
    
    NSDate *toDate = [calendar dateWithEra:era year:toYear month:month day:day hour:hour minute:minute second:second nanosecond:nanosecond];
    
    NSTimeInterval rangeTimeInterval = [toDate timeIntervalSinceDate:fromDate];
    NSInteger intRangeTimeInterval = (NSInteger)rangeTimeInterval;
    NSTimeInterval randomTimeInterval = (NSTimeInterval)(arc4random() % intRangeTimeInterval);
    NSDate *dateOfBirth = [NSDate dateWithTimeInterval:randomTimeInterval sinceDate:fromDate];
    return dateOfBirth;
}



@end
