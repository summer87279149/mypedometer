//
//  displayDataModal.h
//  毕设测试1
//
//  Created by sq-ios85 on 16/4/10.
//  Copyright © 2016年 shangqian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface displayDataModal : NSObject
//步数
@property(nonatomic,strong)NSString *stepCounts;
//每日目标
@property(nonatomic,strong)NSString *dailyGoal;
//进度条
@property(nonatomic,strong)NSString *dailyGoalProgress;
//每日进度百分比
@property (assign, nonatomic)float progress;
@property (nonatomic,strong)NSString *calorie;
@property (nonatomic,strong)NSString *totalKm;
//-(instancetype)initWithStepCounts:(NSString *)stepCounts andDailyGoal:(NSString *)dailyGoal andDailyGoalProgress:(NSString*)dailyGoalProgress andProgress:(float )progress andCalorie:(NSString*)calorie andTotalKm:(NSString *)totalKm;

@end
