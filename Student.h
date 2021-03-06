//
//  Student.h
//  KVC-KVO
//
//  Created by EnzoF on 12.10.16.
//  Copyright © 2016 EnzoF. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum{
  StudentFemale = 1,
  StudentMale = 0
}StudentGenderType;

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


@interface Student : NSObject

@property (nonatomic,strong) NSString *firstName;
@property (nonatomic,strong) NSString *lastName;
@property (nonatomic,strong) NSDate *dateOfBirth;
@property (nonatomic,assign) StudentGenderType gender;
@property (nonatomic,assign) NSString *grade;


@property(nonatomic,assign) NSInteger identifier;

@property(nonatomic,strong) Student *currentFriend;

+(instancetype)randomStudent;

-(void)clearAll;
@end
