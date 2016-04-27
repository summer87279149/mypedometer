//
//  zujicontroller.m
//  毕设测试1
//
//  Created by sq-ios85 on 16/4/19.
//  Copyright © 2016年 shangqian. All rights reserved.
//

#import "zujicontroller.h"

@interface zujicontroller ()
@property (weak, nonatomic) IBOutlet UILabel *text;

@end

@implementation zujicontroller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    UIImageView*view=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"足迹"]];
//    [self.view addSubview:view];
    self.countlabel.text=[NSString stringWithFormat:@"%d",self.qqqqqq];
    if(self.qqqqqq<3000){
        self.text.text=@"今日活动强度较小，建议增加运动量";
    }
    else if (self.qqqqqq<7000)
    {
        self.text.text=@"今日活动强度一般，可以再适当增加运动达到强身健体的效果";
    }
    else if (self.qqqqqq<10000){
        self.text.text=@"今日活动强度一般基本达标，可以适当休息";
    }
    else if (self.qqqqqq>10000){
        self.text.text=@"今天走了一万多步，有点累了吧，休息一下吧～";
    }
}
   

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissViewControllerAnimated:YES completion:nil];
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
