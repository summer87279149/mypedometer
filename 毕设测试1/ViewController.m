//
//  ViewController.m
//  毕设测试1
//
//  Created by sq-ios85 on 16/4/5.
//  Copyright © 2016年 shangqian. All rights reserved.
//

#import "ViewController.h"
#import <HealthKit/HealthKit.h>
#import "zujicontroller.h"
@interface ViewController ()
@property (nonatomic, strong) HKHealthStore *healthStore;
@end

@implementation ViewController
- (void)viewDidLoad{
    self.healthStore=[[HKHealthStore alloc]init];
    if(![HKHealthStore isHealthDataAvailable])
    {
        NSLog(@"设备不支持healthKit");
    }
    
    
}

/*
 - (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //查看healthKit在设备上是否可用，ipad不支持HealthKit
    if(![HKHealthStore isHealthDataAvailable])
    {
        NSLog(@"设备不支持healthKit");
    }
    
    //创建healthStore实例对象
    self.healthStore = [[HKHealthStore alloc] init];
    
    //设置需要获取的权限这里仅设置了步数
    HKObjectType *stepCount = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    
    NSSet *healthSet = [NSSet setWithObjects:stepCount, nil];
    
    //从健康应用中获取权限
    [self.healthStore requestAuthorizationToShareTypes:nil readTypes:healthSet completion:^(BOOL success, NSError * _Nullable error) {
        if (success)
        {
            NSLog(@"获取步数权限成功");
            //获取步数后我们调用获取步数的方法
            [self readStepCount];
        }
        else
        {
            NSLog(@"获取步数权限失败");
        }
    }];
    
}
//查询数据
- (void)readStepCount
{
    //查询采样信息
    HKSampleType *sampleType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    
    //NSSortDescriptors用来告诉healthStore怎么样将结果排序。
    NSSortDescriptor *start = [NSSortDescriptor sortDescriptorWithKey:HKSampleSortIdentifierStartDate ascending:NO];
    NSSortDescriptor *end = [NSSortDescriptor sortDescriptorWithKey:HKSampleSortIdentifierEndDate ascending:NO];
    
 
 
   HKSampleQuery *sampleQuery = [[HKSampleQuery alloc] initWithSampleType:sampleType predicate:nil limit:1 sortDescriptors:@[start,end] resultsHandler:^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error) {
        //打印查询结果
        NSLog(@"resultCount = %ld result = %@",results.count,results);
        //把结果装换成字符串类型
        HKQuantitySample *result = results[0];
        HKQuantity *quantity = result.quantity;
        NSString *stepStr = (NSString *)quantity;
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            //查询是在多线程中进行的，如果要对UI进行刷新，要回到主线程中
            NSLog(@"最新步数：%@",stepStr);
            self.label.text=[NSString stringWithFormat:@"%@",stepStr];
           
        }];
        
    }];
    //执行查询
    [self.healthStore executeQuery:sampleQuery];
}*/
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
