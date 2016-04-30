//
//  RealTimePedometerViewController.m
//  CoreMotionDemos
//
//  Created by Matt Blair on 2/24/15.
//  Copyright (c) 2015 Elsewise LLC. All rights reserved.
//


@import CoreMotion;
@import AVFoundation;

#import "RealTimePedometerViewController.h"

typedef NS_ENUM(NSInteger, CMDRealTimeStartFrom) {
    CMDRealTimeStartFromNow = 0,
    CMDRealTimeStartFromSixHoursAgo,
    CMDRealTimeStartFromTwelveHoursAgo
};


@interface RealTimePedometerViewController ()

//CMPedometer 对象
@property (strong, nonatomic) CMPedometer *pedometer;

//开始时间（没用）
@property (nonatomic) CMDRealTimeStartFrom startTimeFrom;

//存放纪录次数的数组
@property (strong, nonatomic) NSMutableArray *stepCountLog;

//时间格式
@property (strong, nonatomic) NSDateFormatter *timestampFormatter;

//语音播报器
@property (strong, nonatomic) AVSpeechSynthesizer *announcer;

@end


@implementation RealTimePedometerViewController


#pragma mark - View Controller Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.startTimeFrom = CMDRealTimeStartFromNow;
    
    
    //创建CMPedometer
    self.pedometer = [[CMPedometer alloc] init];
    //[self startQueryingPedometer];
    //创建AVSpeechSynthesizer
    self.announcer = [[AVSpeechSynthesizer alloc] init];
    //一个数组，存放步数数据
    // capacity could be bigger for long-running tests
    self.stepCountLog = [[NSMutableArray alloc] initWithCapacity:40];
    
    //设置时间格式、日期格式、时区
   
    self.timestampFormatter = [[NSDateFormatter alloc] init];
    self.timestampFormatter.locale = [NSLocale autoupdatingCurrentLocale];
    self.timestampFormatter.timeZone = [NSTimeZone localTimeZone];
    self.timestampFormatter.dateStyle = NSDateFormatterNoStyle;
    self.timestampFormatter.timeStyle = NSDateFormatterMediumStyle;
    
    self.stopBtn.hidden=YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)ClickRunBtn:(UIButton *)sender {
    self.runBtn.hidden = YES;
    self.stopBtn.hidden = NO;
    self.resultsLabel.text = @"loading...";
    self.distanceLabel.text = @"loading...";
    self.floorCountLabel.text = @"loading...";
    [self startQueryingPedometer];
    
    
    
    
}
- (IBAction)ClickStopBtn:(UIButton *)sender {
    self.stopBtn.hidden=YES;
    self.runBtn.hidden=NO;
    [self stopQueryingPedometer];
}


#pragma mark - Pedometer Management
//返回当前时间
- (NSDate *)dateForStartSelection:(CMDRealTimeStartFrom)startSelection {
    
    NSDate *returnDate = nil;
    
            returnDate = [NSDate date];
    
    return returnDate;
}

//开始请求数据
- (void)startQueryingPedometer {
    
    __weak __typeof(self)weakSelf = self;
    
    //代码块
    CMPedometerHandler handler = ^(CMPedometerData *pedometerData, NSError *error){
        
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        //请求失败
        if (error) {
            
            NSLog(@"Real-time pedometer updates failed with error: %@", [error localizedDescription]);
            
            // switch to main queue if we're going to do anything with UIKit
            dispatch_async(dispatch_get_main_queue(), ^{
                if (strongSelf) {
                    self.resultsLabel.text = @"error!!!";
                }
            });
        } else {
        //请求成功
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (strongSelf) {
                    //请求成功则处理PedometerData
                    [strongSelf handlePedometerData:pedometerData];
                }
            });
        }
    };
    //开始向app提供最近的步行数据,参数是当前时间
    [self.pedometer startPedometerUpdatesFromDate:[self dateForStartSelection:self.startTimeFrom]
                                      withHandler:handler];
    //self.showLogsButton.enabled = YES;
}
//停止请求数据
- (void)stopQueryingPedometer {
    
    [self.pedometer stopPedometerUpdates];
    
    // clear out the timestamped log
    [self.stepCountLog removeAllObjects];
    //self.showLogsButton.enabled = NO;
    
    self.resultsLabel.text = @"- - - -";
    self.distanceLabel.text = @"- - - -";
    self.floorCountLabel.text = @"- - - -";
}


#pragma mark - Data Presentation

//处理数据显示
- (void)handlePedometerData:(CMPedometerData *)pmData {
    
    // Log it
   // NSLog(@"Data Received: %@", pmData);
    //timestampString：CMPedometerData的结束时间
   // NSString *timestampString = [self.timestampFormatter stringFromDate:pmData.endDate];
    
//    NSString *logString = [NSString stringWithFormat:@"%@ - %@ steps",
//                           timestampString, pmData.numberOfSteps];
//    [self.stepCountLog addObject:logString];
//    
    
    // Display it
    NSString *floorString;
    //如果floor counts能够获取，就保存在floorString中
    if ([CMPedometer isFloorCountingAvailable]) {
        floorString = [NSString stringWithFormat:@"Floors: %@ up, %@ down",
                       pmData.floorsAscended, pmData.floorsDescended];
    } else {
        floorString = @"楼层数不能获取";
    }
    //prepare for voice
    int numer=[pmData.numberOfSteps intValue];
    //最终的显示格式 ： 步数 ／距离（米）／楼层／记录次数
//    self.resultsLabel.text = [NSString stringWithFormat:@"%@ steps\n%1.2f meters\n%@\n\n(Update #%ld)",
//                              pmData.numberOfSteps, [pmData.distance doubleValue],
//                              floorString, self.stepCountLog.count];
    self.resultsLabel.text=[NSString stringWithFormat:@"%@",pmData.numberOfSteps];
    self.distanceLabel.text=[NSString stringWithFormat:@"%.2f",[pmData.distance doubleValue]];
    self.floorCountLabel.text=[NSString stringWithFormat:@"%@",floorString];
    
    
    
    // 语音播放
    if(numer%20==0){
    NSString *countString =[NSString stringWithFormat:@"%@ steps", pmData.numberOfSteps];
    AVSpeechUtterance *countUtterance = [[AVSpeechUtterance alloc] initWithString:countString];
    countUtterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
    countUtterance.rate = 0.3;
    
    [self.announcer speakUtterance:countUtterance];
    }
}





@end
