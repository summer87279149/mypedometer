//
//  first_ViewController.h
//  毕设测试1
//
//  Created by sq-ios85 on 16/4/9.
//  Copyright © 2016年 shangqian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HealthKit/HealthKit.h>
#import "displayDataModal.h"

@interface first_ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *stepCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *dailyGoalStepCount;
@property (weak, nonatomic) IBOutlet UILabel *dailyGoalProgress;
@property (weak, nonatomic) IBOutlet UIProgressView *progress;
@property (weak, nonatomic) IBOutlet UILabel *totalKm;
@property (weak, nonatomic) IBOutlet UILabel *calorie;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *calorieLabel;
@property (nonatomic,assign) int count;
@property(nonatomic,assign) float juli;
-(void)totalStepCountWithStartTime:(NSDate*)startTime endTime:(NSDate*)endTime;
//-(void)totalDistanceWithStartTime:(NSDate*)startTime endTime:(NSDate*)endTime;

@end
