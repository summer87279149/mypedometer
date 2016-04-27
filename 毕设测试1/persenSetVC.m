//
//  persenSetVC.m
//  毕设测试1
//
//  Created by sq-ios85 on 16/4/22.
//  Copyright © 2016年 shangqian. All rights reserved.
//

#import "persenSetVC.h"
#import "personModal.h"
#import "first_ViewController.h"
@interface persenSetVC ()
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *save;
@property (weak, nonatomic) IBOutlet UISegmentedControl *manOrFemal;
@property (weak, nonatomic) IBOutlet UITextField *age;
@property (weak, nonatomic) IBOutlet UITextField *high;
@property (weak, nonatomic) IBOutlet UITextField *weight;
@property (weak, nonatomic) IBOutlet UITextField *dailyGoal;

@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *highLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;
@property (weak, nonatomic) IBOutlet UILabel *goalLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancel;

@end


@implementation persenSetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.modal=[personModal getInstance];
    NSString *str1=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    
    NSString *filePath=[str1 stringByAppendingPathComponent:@"dict.plist"];
    NSDictionary *dict=[NSDictionary dictionaryWithContentsOfFile:filePath];
    NSString *sex=dict[@"number0"];
    NSNumber *age=dict[@"number1"];
    NSNumber *high=dict[@"number2"];
    NSNumber *weight=dict[@"number3"];
    NSNumber *daygoal=dict[@"number4"];
    int intAge=[age intValue];
    int intHigh=[high intValue];
    int intWeight=[weight intValue];
    int intDaygoal=[daygoal intValue];
    NSString *strAge=[NSString stringWithFormat:@"%d",intAge];
    NSString *strHigh=[NSString stringWithFormat:@"%d",intHigh];
    NSString *strWeight=[NSString stringWithFormat:@"%d",intWeight];
    NSString *strDaygoal=[NSString stringWithFormat:@"%d",intDaygoal];
    self.sexLabel.text=sex;
    self.ageLabel.text=strAge;
    self.highLabel.text=strHigh;
    self.weightLabel.text=strWeight;
    self.goalLabel.text=strDaygoal;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//使用单例模型 获取姓名、年龄、身高、体重
- (IBAction)savebtn:(id)sender {
//    self.modal.age=[self.age.text intValue];
//    self.modal.shengao=[self.high.text intValue];
//    self.modal.weight=[self.weight.text intValue];
//    self.modal.dailyGoal=[self.dailyGoal.text intValue];
//    self.modal.set=YES;
//    //NSLog(@"weight===%d",self.modal.weight);
//    int a=[self.weight.text intValue];
//    NSString *data=[NSString stringWithFormat:@"%d",a];
//    NSString *str=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
//    NSString *filePath=[str stringByAppendingPathComponent:@"dict.plist"];
//    
//    [data writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    NSString *sex=[[NSString alloc]init];
    if(self.manOrFemal.selectedSegmentIndex==0){
        sex=@"男";
    }
    else{
        sex=@"女";
    }
    
    self.modal.age=[self.age.text intValue];
    self.modal.shengao=[self.high.text intValue];
    self.modal.weight=[self.weight.text intValue];
    self.modal.dailyGoal=[self.dailyGoal.text intValue];
    
    
    NSNumber *number1=[NSNumber numberWithInt:self.modal.age];
    NSNumber *number2=[NSNumber numberWithInt:self.modal.shengao];
    NSNumber *number3=[NSNumber numberWithInt:self.modal.weight];
    NSNumber *number4=[NSNumber numberWithInt:self.modal.dailyGoal];
    
    
    NSDictionary *dict=[NSDictionary dictionaryWithObjects:@[sex,number1,number2,number3,number4] forKeys:@[@"number0",@"number1",@"number2",@"number3",@"number4"]];
    NSString *str=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *filePath=[str stringByAppendingPathComponent:@"dict.plist"];
    
    [dict writeToFile:filePath atomically:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancel:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)save:(UIBarButtonItem *)sender {
   

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)send
 er {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
