//
//  second_ViewController.h
//  毕设测试1
//
//  Created by sq-ios85 on 16/4/10.
//  Copyright © 2016年 shangqian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HealthKit/HealthKit.h>
@interface second_ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UIButton *stopbtn;
@property(strong,nonatomic)NSDate* startTime;
@property(strong,nonatomic)NSDate* stopTime;
@property(strong,nonatomic)NSCalendar *calender;
@property(strong,nonatomic)NSDate *now;
@property(nonatomic,strong)HKHealthStore *health;
@property(assign,nonatomic)NSInteger startStepCount;
@property(assign,nonatomic)NSInteger stopStepCount;
//@property(nonatomic)NSDateComponents *components;

@end
