//
//  first_ViewController.m
//  毕设测试1
//
//  Created by sq-ios85 on 16/4/9.
//  Copyright © 2016年 shangqian. All rights reserved.
//

#import "first_ViewController.h"
#import <HealthKit/HealthKit.h>
#import "displayDataModal.h"
#import "zujicontroller.h"
#import "personModal.h"
@interface first_ViewController ()
@property(nonatomic,strong)HKHealthStore *health;
@property(nonatomic,strong)displayDataModal *modal;
@property (weak, nonatomic) IBOutlet UIButton *setGoal;
@end

@implementation first_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    self.health=[[HKHealthStore alloc]init];
    //设置授权步数
    HKQuantityType *type=[HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    //设置授权里程数
    HKQuantityType *distanceType=[HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
    
    
    NSSet *set=[NSSet setWithObject:type];
    NSSet *set2=[NSSet setWithObject:distanceType];
    
    //获取授权步数
    [self.health requestAuthorizationToShareTypes:nil readTypes:set completion:^(BOOL success, NSError * _Nullable error) {
        if(success)
        {
            [self  readStepData];
        }
        
    }];
    //获取授权里程数
    [self.health requestAuthorizationToShareTypes:nil readTypes:set2 completion:^(BOOL success, NSError * _Nullable error) {
        [self readDistanceData];
    }];
    
}
-(void)viewWillAppear:(BOOL)animated{
    
}




-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqual:@"segue"]){
        zujicontroller *a=[[zujicontroller alloc]init];
        a=segue.destinationViewController;
        a.qqqqqq=self.count;
        
    }
    
}

- (IBAction)setgoal:(UIButton *)sender {
    
    
    
}
//获得步数
-(void)readStepData{
    
    //创建日期
    NSCalendar *calender=[NSCalendar currentCalendar];
    NSDate *now=[NSDate date];
    //NSLog(@"%@",now);
    NSDateComponents *components=[calender components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    //开始日期
    NSDate* startDate=[calender dateFromComponents:components];
    //结束日期
    NSDate *enDate=[calender dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
    [self totalStepCountWithStartTime:startDate endTime:enDate];
    
    
}
-(void)totalStepCountWithStartTime:(NSDate*)startTime endTime:(NSDate*)endTime{
    HKQuantityType *type=[HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    NSPredicate *predicate=[HKQuery predicateForSamplesWithStartDate:startTime endDate:endTime options:HKQueryOptionStrictStartDate];
    //请求步数
    HKObserverQuery *query=[[HKObserverQuery alloc]initWithSampleType:type predicate:predicate updateHandler:^(HKObserverQuery * _Nonnull query, HKObserverQueryCompletionHandler  _Nonnull completionHandler, NSError * _Nullable error) {
        //解析
        HKStatisticsQuery *sQuery=[[HKStatisticsQuery alloc]initWithQuantityType:type quantitySamplePredicate:predicate options:HKStatisticsOptionCumulativeSum completionHandler:^(HKStatisticsQuery * _Nonnull query, HKStatistics * _Nullable result, NSError * _Nullable error) {
            HKQuantity *quantity=result.sumQuantity;
            //获取步数
            NSInteger stepCount=[quantity doubleValueForUnit:[HKUnit countUnit]];
            self.count=(int)stepCount;
            //转换成字符串格式显示
            //步数
            NSString *str5=[NSString  stringWithFormat:@"%ld",stepCount];
            
            NSString *str1=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
            
            NSString *filePath=[str1 stringByAppendingPathComponent:@"dict.plist"];
            
            
            NSDictionary *dict=[NSDictionary dictionaryWithContentsOfFile:filePath];
            NSNumber *dailygoal=dict[@"number4"];
            int goal=[dailygoal intValue];
            NSString *str=[NSString  stringWithFormat:@"每日目标：%d步",goal];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.dailyGoalStepCount.text=str;
                self.stepCountLabel.text=str5;
                //进度条
                CGFloat count = (CGFloat)stepCount/goal;
                [self.progress setProgress:count animated:YES];
                //目标百分数
                if(count<1){
                    NSString*str2=[NSString stringWithFormat:@"%2.1f%%",count*100];
                    self.dailyGoalProgress.text=str2;
                }
                else{
                    self.dailyGoalProgress.text=@"已完成";
                }
                //
                //               self.modal.stepCounts=str;
                //
                //               self.modal.progress=count;
                //               self.modal.dailyGoalProgress=str2;
                //NSLog(@"%@,%f,%@",self.modal.stepCounts,self.modal.progress,self.modal.dailyGoalProgress);
            });
            
        }];
        [self.health executeQuery:sQuery];
        
    }];
    
    [self.health executeQuery:query];
    
}
//获取距离方法
-(void)readDistanceData{
    //[self totalDistanceWithStartTime:startDate endTime:enDate];
    HKQuantityType *type=[HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
    
    NSCalendar *calender=[NSCalendar currentCalendar];
    NSDate *now=[NSDate date];
    //NSLog(@"%@",now);
    NSDateComponents *components=[calender components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    //开始日期
    NSDate* startDate=[calender dateFromComponents:components];
    //结束日期
    NSDate *enDate=[calender dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
    NSPredicate *predicate=[HKQuery predicateForSamplesWithStartDate:startDate endDate:enDate options:HKQueryOptionStrictStartDate];
    
    
    HKObserverQuery *query=[[HKObserverQuery alloc]initWithSampleType:type predicate:predicate updateHandler:^(HKObserverQuery * query, HKObserverQueryCompletionHandler completionHandler, NSError *error) {
        //NSLog(@"%@",query);
        //解析
        HKStatisticsQuery *sQuery=[[HKStatisticsQuery alloc]initWithQuantityType:type quantitySamplePredicate:predicate options:HKStatisticsOptionCumulativeSum completionHandler:^(HKStatisticsQuery * query, HKStatistics * result, NSError *error) {
            HKQuantity *quantity=result.sumQuantity;
            HKUnit *unit=[HKUnit meterUnit];
            double distance=[quantity doubleValueForUnit:unit];
            NSString *str=[NSString stringWithFormat:@"%.1f",distance/1000];
            self.juli=distance/1000;

            NSString *str1=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
            
            NSString *filePath=[str1 stringByAppendingPathComponent:@"dict.plist"];
            
            
            NSDictionary *dict=[NSDictionary dictionaryWithContentsOfFile:filePath];
            NSNumber *weight=dict[@"number3"];
            int wei=[weight intValue];
//            NSLog(@"wei=%d",wei);
//            NSString *data=[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
//           int a = [data intValue];
            float b= wei*self.juli*1.036;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.distanceLabel.text=str;
                self.calorieLabel.text=[NSString stringWithFormat:@"%.2f",b];
            });
        }];
        [self.health executeQuery:sQuery];
    }];
    [self.health executeQuery:query];
}
/*
 -(void)totalDistanceWithStartTime:(NSDate*)startTime endTime:(NSDate*)endTime{
 NSPredicate *predicate=[HKQuery predicateForSamplesWithStartDate:startTime endDate:endTime options:HKQueryOptionStrictStartDate];
 HKQuantityType *type=[HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
 HKObserverQuery *query=[[HKObserverQuery alloc]initWithSampleType:type predicate:predicate updateHandler:^(HKObserverQuery * query, HKObserverQueryCompletionHandler completionHandler, NSError *error) {
 
 //解析
 HKStatisticsQuery *sQuery=[[HKStatisticsQuery alloc]initWithQuantityType:type quantitySamplePredicate:predicate options:HKStatisticsOptionCumulativeSum completionHandler:^(HKStatisticsQuery * query, HKStatistics * result, NSError *error) {
 HKQuantity *quantity=result.sumQuantity;
 HKUnit *unit=[HKUnit meterUnit];
 double distance=[quantity doubleValueForUnit:unit];
 // NSLog(@"%f",distance);
 }];
 [self.health executeQuery:sQuery];
 }];
 [self.health executeQuery:query];
 }
 
 */
//读取文件数据
-(NSDictionary *)readData{
    NSString *str=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *filePath=[str stringByAppendingPathComponent:@"dict.plist"];
    NSDictionary *dict=[NSDictionary dictionaryWithContentsOfFile:filePath];
   
    return dict;
    
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
