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
#import "MZTimerLabel.h"
#import <CoreLocation/CoreLocation.h>

typedef NS_ENUM(NSInteger, CMDRealTimeStartFrom) {
    CMDRealTimeStartFromNow = 0,
    CMDRealTimeStartFromSixHoursAgo,
    CMDRealTimeStartFromTwelveHoursAgo
};


@interface RealTimePedometerViewController ()<AVAudioPlayerDelegate,CLLocationManagerDelegate>

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
@property (strong,nonatomic) MZTimerLabel *timer;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UILabel *dengdaishuju;
//音频
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
//定位
@property(nonatomic,strong)CLLocationManager *locationManager;

@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;
@property (weak, nonatomic) IBOutlet UILabel *AddressLabel;


@end


@implementation RealTimePedometerViewController

- (AVAudioPlayer *)audioPlayer {
    if (_audioPlayer == nil) {
        // 构造待播放音乐文件URL
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"faded.mp3" ofType:nil];
        NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
        
        // 1.初始化播放器
        // 注意这里的Url参数只能时文件路径，不支持HTTP Url
        NSError *error;
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileUrl error:&error];
        if (error) {
            NSLog(@"初始化播放器过程发生错误,错误信息:%@",error.localizedDescription);
            return nil;
        }
        
        // 2.设置播放器属性
        _audioPlayer.numberOfLoops = -1;     // 设置0不循环
        _audioPlayer.delegate = self;
        
        // 设置后台播放模式
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        [audioSession setActive:YES error:nil];
        
        // 3.加载音频文件到缓存
        [_audioPlayer prepareToPlay];
        
        
        
    }
    
    return _audioPlayer;
}
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
    self.timer=[[MZTimerLabel alloc]initWithLabel:self.timerLabel];
    //设置时间格式、日期格式、时区

    self.timestampFormatter = [[NSDateFormatter alloc] init];
    self.timestampFormatter.locale = [NSLocale autoupdatingCurrentLocale];
    self.timestampFormatter.timeZone = [NSTimeZone localTimeZone];
    self.timestampFormatter.dateStyle = NSDateFormatterNoStyle;
    self.timestampFormatter.timeStyle = NSDateFormatterMediumStyle;
    
    self.stopBtn.hidden=YES;
    
    //初始化定位信息
    self.locationManager = [[CLLocationManager alloc] init];
    // 判断是是否已打开定位服务
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"定位服务未打开，请打开定位服务");
        return;
    }
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        // 未授权，则申请
        NSLog(@"33333");
        [self.locationManager requestWhenInUseAuthorization];
    } else {
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
            // 配置CLLocationManager
            NSLog(@"1111");
            // 配置精度
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            // 配置位置更新的距离
            self.locationManager.distanceFilter = 0.1;
            // 配置代理
            self.locationManager.delegate = self;
            
            // 开始定位
            [self.locationManager startUpdatingLocation];
            //            [self.locationManager startUpdatingHeading];
        }
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)ClickRunBtn:(UIButton *)sender {
    
    [self.audioPlayer play];
    self.runBtn.hidden = YES;
    self.stopBtn.hidden = NO;
    self.resultsLabel.text = @"loading...";
    self.distanceLabel.text = @"loading...";
    self.floorCountLabel.text = @"loading...";
    self.dengdaishuju.text = @"获取数据中,请保持走动";
    [self.timer reset];
    [self.timer start];
    [self startQueryingPedometer];
    
    
    
    
}
- (IBAction)ClickStopBtn:(UIButton *)sender {
    [self.audioPlayer stop];
    self.dengdaishuju.text=@"";
    self.stopBtn.hidden=YES;
    self.runBtn.hidden=NO;
    [self.timer pause];
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
        floorString = [NSString stringWithFormat:@"%@ , %@ ",
                       pmData.floorsAscended, pmData.floorsDescended];
    } else {
        floorString = @"error";
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
    if(numer%10==0){
    NSString *countString =[NSString stringWithFormat:@"%@步", pmData.numberOfSteps];
    AVSpeechUtterance *countUtterance = [[AVSpeechUtterance alloc] initWithString:countString];
    countUtterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
    countUtterance.rate = 0.5;
    
    [self.announcer speakUtterance:countUtterance];
    }
}

#pragma mark 定位代理方法
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *array, NSError *error){
        if (array.count > 0){
            CLPlacemark *placemark = [array objectAtIndex:0];
            //将获得的所有信息显示到label上
            NSLog(@"地标:%@",placemark.name);
            //self.location.text = placemark.name;
            //获取城市
            NSString *city = placemark.locality;
            if (!city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
            }
            NSLog(@"city = %@", city);
            [self QueryWeatherBy:city];
            // _cityLable.text = city;
            //[_cityButton setTitle:city forState:UIControlStateNormal];
        }
        else if (error == nil && [array count] == 0)
        {
            NSLog(@"No results were returned.");
        }
        else if (error != nil)
        {
            NSLog(@"An error occurred = %@", error);
        }
    }];
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [manager stopUpdatingLocation];
}
-(void)QueryWeatherBy:(NSString *)city{
    NSLog(@"进入 queryWeather");
    NSString *str = [NSString stringWithFormat:@"http://v.juhe.cn/weather/index?format=2&cityname=%@&key=ad5d4ea2a99be7b3b2a7297a917ab9ad",city];
    NSString *stringURL = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:stringURL];
    NSLog(@"url:%@",url);
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSLog(@"request:%@",request);
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //NSLog(@"天气字典里面:%@",data);
        if(data){
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"天气字典里面:%@",dict);
            NSDictionary *result = dict[@"result"];
            NSDictionary *d = result[@"today"];
            NSString *weather = [d objectForKey:@"weather"];
            NSString *tem = [d objectForKey:@"temperature"];
            NSString *wind = [d objectForKey:@"wind"];
            NSLog(@"weather :%@",weather);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.AddressLabel.text=city;
                self.weatherLabel.text=[NSString stringWithFormat:@"实时天气:%@,温度:%@,%@",weather,tem,wind];
            });
            
        }
    }];
    [task resume];
}


@end
