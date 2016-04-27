//
//  second_ViewController.m
//  毕设测试1
//
//  Created by sq-ios85 on 16/4/10.
//  Copyright © 2016年 shangqian. All rights reserved.
//

#import "second_ViewController.h"
#import <HealthKit/HealthKit.h>
@interface second_ViewController ()
//@property(strong,nonatomic)NSDate *date;
@property(nonatomic,strong)NSMutableArray *arr1;
@property(nonatomic,strong)NSMutableArray *arr2;
-(void)getStepData:(NSPredicate *)predicate;

@end

@implementation second_ViewController
int i=0;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.health=[[HKHealthStore alloc]init];
    
    
    self.stopbtn.enabled=NO;
    
}
- (IBAction)RunOrStop:(id)sender {
    
 
//    self.calender=[NSCalendar currentCalendar];
//    self.now=[NSDate date];
       self.distanceLabel.text=@"";
//    NSDateComponents *components=[self.calender components:NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:self.now];
//    
//    //开始日期
//    self.startTime=[self.calender dateFromComponents:components];
//  
//    NSLog(@"%@",self.startTime);
    NSCalendar *calender=[NSCalendar currentCalendar];
    NSDate *now=[NSDate date];
    //NSLog(@"%@",now);
    NSDateComponents *components=[calender components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    //开始日期
    NSDate* startDate=[calender dateFromComponents:components];
    //结束日期
    NSDate *enDate=[calender dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
    HKQuantityType *type=[HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    NSPredicate *predicate=[HKQuery predicateForSamplesWithStartDate:startDate endDate:enDate options:HKQueryOptionStrictStartDate];
    //请求步数
    HKObserverQuery *query=[[HKObserverQuery alloc]initWithSampleType:type predicate:predicate updateHandler:^(HKObserverQuery * _Nonnull query, HKObserverQueryCompletionHandler  _Nonnull completionHandler, NSError * _Nullable error) {
        //解析
        HKStatisticsQuery *sQuery=[[HKStatisticsQuery alloc]initWithQuantityType:type quantitySamplePredicate:predicate options:HKStatisticsOptionCumulativeSum completionHandler:^(HKStatisticsQuery * _Nonnull query, HKStatistics * _Nullable result, NSError * _Nullable error) {
            HKQuantity *quantity=result.sumQuantity;
            //获取步数
            self.startStepCount=[quantity doubleValueForUnit:[HKUnit countUnit]];
            NSLog(@"%lu",self.startStepCount);
            
            i=(int)self.startStepCount;
        }];
        [self.health executeQuery:sQuery];
        
    }];
    
    [self.health executeQuery:query];
    
    self.btn.enabled=NO;
    self.stopbtn.enabled=YES;
}

- (IBAction)getStopDate:(id)sender {
    
//    NSCalendar *calender=[NSCalendar currentCalendar];
//    NSDate *now=[NSDate date];
    //NSLog(@"%@",now);
//    self.calender=[NSCalendar currentCalendar];
//    self.now=[NSDate date];
//    NSDateComponents *components=[self.calender components:NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:self.now];
//    
//    //开始日期
//    //self.startTime=[self.calender dateFromComponents:components];
//    //NSDate *enDate=[calender dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
//    self.stopTime=[self.calender dateFromComponents:components];
//    NSLog(@"%@",self.stopTime);
//    NSPredicate *predicate=[HKQuery predicateForSamplesWithStartDate:self.startTime endDate:self.stopTime options:HKQueryOptionStrictStartDate];
//    [self getStepData:predicate];
    NSCalendar *calender=[NSCalendar currentCalendar];
    NSDate *now=[NSDate date];
    //NSLog(@"%@",now);
    NSDateComponents *components=[calender components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    //开始日期
    NSDate* startDate=[calender dateFromComponents:components];
    //结束日期
    NSDate *enDate=[calender dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
    HKQuantityType *type=[HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    NSPredicate *predicate=[HKQuery predicateForSamplesWithStartDate:startDate endDate:enDate options:HKQueryOptionStrictStartDate];
    //请求步数
    HKObserverQuery *query=[[HKObserverQuery alloc]initWithSampleType:type predicate:predicate updateHandler:^(HKObserverQuery * _Nonnull query, HKObserverQueryCompletionHandler  _Nonnull completionHandler, NSError * _Nullable error) {
        //解析
        HKStatisticsQuery *sQuery=[[HKStatisticsQuery alloc]initWithQuantityType:type quantitySamplePredicate:predicate options:HKStatisticsOptionCumulativeSum completionHandler:^(HKStatisticsQuery * _Nonnull query, HKStatistics * _Nullable result, NSError * _Nullable error) {
            HKQuantity *quantity=result.sumQuantity;
            //获取步数
            self.stopStepCount=[quantity doubleValueForUnit:[HKUnit countUnit]];
            NSLog(@"%lu",self.stopStepCount);
            
            
            int b=(int)self.stopStepCount-i;
            //转换成字符串格式显示
            //步数
            NSString *str=[NSString  stringWithFormat:@"%d",b];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.distanceLabel.text=str;
               
            });
            
        }];
        [self.health executeQuery:sQuery];
        
    }];
    
    [self.health executeQuery:query];
   
    self.stopbtn.enabled=NO;
    self.btn.enabled=YES;
    
}

-(void)getStepData:(NSPredicate *)predicate{
    /*
    HKQuantityType *type=[HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
    
    HKObserverQuery *query=[[HKObserverQuery alloc]initWithSampleType:type predicate:predicate updateHandler:^(HKObserverQuery * query, HKObserverQueryCompletionHandler completionHandler, NSError *error) {
        NSLog(@"%@",query);
        //解析
        HKStatisticsQuery *sQuery=[[HKStatisticsQuery alloc]initWithQuantityType:type quantitySamplePredicate:predicate options:HKStatisticsOptionCumulativeSum completionHandler:^(HKStatisticsQuery * query, HKStatistics * result, NSError *error) {
            HKQuantity *quantity=result.sumQuantity;
            HKUnit *unit=[HKUnit meterUnit];
            double distance=[quantity doubleValueForUnit:unit];
            NSString *str=[NSString stringWithFormat:@"%.1f",distance/1000];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.distanceLabel.text=str;
                //self.modal.totalKm=str;
                //self.modal.calorie=str;
            });
        }];
        [self.health executeQuery:sQuery];
    }];
    [self.health executeQuery:query];

    */
    
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
