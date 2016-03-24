//
//  ViewController.m
//  DateFilterView
//
//  Created by jake on 16/3/24.
//  Copyright © 2016年 wzeiri. All rights reserved.
//

#import "ViewController.h"
#import "DateFilterView.h"
@interface ViewController ()<DateFilterViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (nonatomic , strong) DateFilterView *dateView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    DateFilterView *dateView = [[DateFilterView alloc]initWithSuperView:self.view];
    dateView.delegate = self;
//    dateView.themeColor = [UIColor redColor];
//    dateView.defaultStartTime = @"这是我的开始时间";
//    dateView.defaultEndTime = @"这里写的是结束时间";
    self.dateView = dateView;
}

- (IBAction)showDateView:(UIButton *)sender {
    [self.dateView showDateView];
}

-(void)transferDate:(DateFilterView *)dateFilter
      withStartTime:(NSString *)startTime andEndTime:(NSString *)endTime{
    self.startTimeLabel.text = startTime;
    self.endTimeLabel.text = endTime;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
