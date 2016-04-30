//
//  RealTimePedometerViewController.h
//  CoreMotionDemos
//
//
//  Copyright (c) 2015 Elsewise LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RealTimePedometerViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *resultsLabel;
@property (weak, nonatomic) IBOutlet UIButton *runBtn;

@property (weak, nonatomic) IBOutlet UIButton *stopBtn;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *floorCountLabel;



@end
