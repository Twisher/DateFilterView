//
//  DateFilterView.m
//  Maticsoft
//
//  Created by jake on 16/3/23.
//  Copyright © 2016年 Maticsoft. All rights reserved.
//

#import "DateFilterView.h"
#import "UIView+YYAdd.h"

#define BtnWidth (kScreenSize.width-100)/2  //按钮的宽度
#define BtnHeight 28    //按钮的宽度
#define kScreenSize [[UIScreen mainScreen] bounds].size
#define kRGBAColor(R,G,B,A)  [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]
#define kRGBColor(R,G,B)     [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1.0]

@interface DateFilterView()
//The view witch this DateFilterView added to
@property (nonatomic , strong) UIView *fatherView;

@property (nonatomic , strong) UIView *dateBgView;
@property (nonatomic , strong) UIView *dateView;

@property (nonatomic , strong) UIButton *startTimeBtn;
@property (nonatomic , strong) UIButton *endTimeBtn;
@property (nonatomic , strong) UIDatePicker *datePicker;
@property (nonatomic , strong) UILabel *startTimeLabel;
@property (nonatomic , strong) UILabel *endTimeLabel;
@property (nonatomic , strong) UIButton *comformBtn;

@property (nonatomic , assign) CGRect dateBgViewFrame;
@property (nonatomic , assign) CGRect dateViewFrame;
@property (nonatomic , strong) UIView *lineBgView;
@property (nonatomic , strong) UILabel *descriptLabel;

@property (nonatomic , assign) BOOL status;//NO表示选择开始，YES表示选择结束
@end


@implementation DateFilterView
/**
 *  initialization init from IB
 *
 *  @param aDecoder
 *
 *  @return 
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        self.fatherView = self.superview;
    }
    return self;
}
/**
 *  initialization with the superView
 *
 *  @param view The view witch this DateFilterView added to
 *
 *  @return self
 */
- (instancetype)initWithSuperView:(UIView *)view{
    self = [super init];
    if(self){
        self.fatherView = view;
    }
    return self;
}
/**
 *  Show this view , add this view to the superView
 */
- (void)showDateView{
    
    [self.fatherView addSubview:self.dateBgView];
    
    [UIView animateWithDuration:0.3
                     animations:^(void) {
                         
                         self.dateBgView.alpha = 1;
                         self.dateView.alpha = 1;
                         self.dateBgView.frame = self.dateBgViewFrame;
                         self.dateView.frame = self.dateViewFrame;
                     } completion:^(BOOL finished) {
                         
                         
                     }];
    
}

/**
 *  GestureRecognizer witch attend to close this view
 *
 *  @param sender UITapGestureRecognizer
 */
- (void)tapClose:(UITapGestureRecognizer *)sender{
    [UIView animateWithDuration:0.3
                     animations:^(void) {
                         
                         self.dateBgView.alpha = 0;
                         self.dateBgView.width = 0;
                         self.dateBgView.height = 0;
                         self.dateView.width = 0;
                         self.dateView.height = 0;
                         self.dateView.alpha = 0;
                         
                     } completion:^(BOOL finished) {
                         
                         [self.dateBgView removeFromSuperview];
                         
                     }];
}

/**
 *  Change the style and status
 *
 *  @param sender Response Button
 */
- (void)changeBtnView:(UIButton *)sender{
    UIColor *color;
    if(self.themeColor){
        color = self.themeColor;
    }else{
        color = kRGBColor(221, 166, 50);
    }
    sender.layer.cornerRadius = 10;
    sender.layer.masksToBounds = YES;
    sender.layer.borderWidth = 1;
    sender.layer.borderColor = [color CGColor];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [sender setTitleColor:color forState:UIControlStateNormal];
    sender.titleLabel.font = [UIFont systemFontOfSize:15];
    
    sender.selected = ![sender isSelected];
    if([sender isSelected]){
        sender.backgroundColor = color;
        
    }else{
        sender.backgroundColor = [UIColor whiteColor];
        
    }
    
    
}

/**
 *  不同的按钮响应，让另外一个按钮的状态改变
 *
 *  @param sender 点击的按钮
 */
- (void)tapBtn:(UIButton *)sender{
    if([sender isSelected]){
        return;
    }
    
    
    if(sender.tag == 100){
        [self changeBtnView:self.endTimeBtn];
        self.descriptLabel.text = @"选择开始时间";
        self.status = NO;
        
        
    }else if(sender.tag == 200){
        if(!self.startTime){
            UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"开始时间未知" message:@"请先选择开始时间" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            [alertview show];
            return;
        }
        [self changeBtnView:self.startTimeBtn];
        self.descriptLabel.text = @"选择结束时间";
        self.status = YES;
    }
    [self changeBtnView:sender];
}

/**
 *  点击确定保存时间
 */
- (void)saveTime:(UIButton *)sender{
    if(!self.startTime
       ){
        UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"开始时间未知" message:@"请选择开始时间" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alertview show];
        return;
    }
    if(!self.endTime){
        UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"结束时间未知" message:@"请选择结束时间" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alertview show];
        return;
    }
    _startTime = self.startTimeLabel.text;
    _endTime = self.endTimeLabel.text;
    
    [self.delegate transferDate:self withStartTime:self.startTime andEndTime:self.endTime];
    [self tapClose:nil];
}
#pragma mark - setter 方法
- (void)setDefaultStartTime:(NSString *)defaultStartTime{
    _defaultStartTime = defaultStartTime;
    _startTimeLabel.text = defaultStartTime;
}


- (void)setDefaultEndTime:(NSString *)defaultEndTime{
    _defaultEndTime = defaultEndTime;
    _endTimeLabel.text = defaultEndTime;
}

- (void)setthemeColor:(UIColor *)themeColor{
    _themeColor = themeColor;
    _startTimeLabel.textColor = themeColor;
    _endTimeLabel.textColor = themeColor;
    
}

#pragma mark - 懒加载  (订单删选的视图初始化)
//此处激发全部
- (UIView *)dateBgView {
    if(_dateBgView == nil) {
        _dateBgView = [[UIView alloc] init];
        _dateBgView.frame = CGRectMake(0, 0, kScreenSize.width, kScreenSize.height);
        _dateBgView.backgroundColor = kRGBAColor(80, 80, 80, 0.6);
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClose:)];
        
        //step2:设置手势的属性
        //设置手势的点击次数
        tapGR.numberOfTapsRequired = 1;
        //需要几个触点
        tapGR.numberOfTouchesRequired =1;
        
        //step3:将手势与视图关联
        [_dateBgView addGestureRecognizer:tapGR];
        [_dateBgView addSubview:self.dateView];
        self.dateBgViewFrame = _dateBgView.frame;
        _dateBgView.alpha = 0;
        _dateBgView.width = 0;
        _dateBgView.height = 0;
    }
    
    return _dateBgView;
}


- (UIView *)dateView {
    if(_dateView == nil) {
        _dateView = [[UIView alloc] init];
        _dateView.frame = CGRectMake(0, kScreenSize.height/2*0.9, kScreenSize.width, kScreenSize.height/2);
        _dateView.backgroundColor = [UIColor whiteColor];
        [_dateView addSubview:self.startTimeBtn];
        [_dateView addSubview:self.endTimeBtn];
        self.dateViewFrame = _dateView.frame;
//配置颜色
        UIColor *color;
        if(self.themeColor){
            color = self.themeColor;
        }else{
            color = kRGBColor(221, 166, 50);
        }
//配置默认的时间
        NSString *startText;
        if(self.defaultStartTime){
            startText = self.defaultStartTime;
        }else{
            startText = @"点击按钮设置";
        }
        NSString *endText;
        if(self.defaultStartTime){
            endText = self.defaultEndTime;
        }else{
            endText = @"点击按钮设置";
        }
        self.startTimeLabel = [[UILabel alloc]init];
        self.startTimeLabel.width = BtnWidth;
        self.startTimeLabel.height = BtnHeight;
        self.startTimeLabel.centerX = self.startTimeBtn.centerX;
        self.startTimeLabel.top = self.startTimeBtn.bottom + 2;
        self.startTimeLabel.textColor = color;
        self.startTimeLabel.font = [UIFont systemFontOfSize:13];
        self.startTimeLabel.text = startText;
        self.startTimeLabel.textAlignment = NSTextAlignmentCenter;
        [_dateView addSubview:self.startTimeLabel];
        
        self.endTimeLabel = [[UILabel alloc]init];
        self.endTimeLabel.width = BtnWidth;
        self.endTimeLabel.height = BtnHeight;
        self.endTimeLabel.centerX = self.endTimeBtn.centerX;
        self.endTimeLabel.top = self.endTimeBtn.bottom + 2;
        self.endTimeLabel.textColor = color;
        self.endTimeLabel.font = [UIFont systemFontOfSize:13];
        self.endTimeLabel.text = endText;
        self.endTimeLabel.textAlignment = NSTextAlignmentCenter;
        [_dateView addSubview:self.endTimeLabel];
        
        UIView *lineBgView = [[UIView alloc]init];
        lineBgView.width = kScreenSize.width;
        lineBgView.height = BtnHeight;
        lineBgView.top = self.startTimeLabel.bottom + 5;
        lineBgView.left = 0;
        lineBgView.backgroundColor = kRGBColor(241, 241, 241);
        [_dateView addSubview:lineBgView];
        self.lineBgView = lineBgView;
        
        UILabel *label = [[UILabel alloc]init];
        label.text = @"选择开始时间";
        label.font = [UIFont systemFontOfSize:12];
        label.width = BtnWidth;
        label.height = BtnHeight - 5;
        label.left = 10;
        label.top = 3;
        [lineBgView addSubview:label];
        self.descriptLabel = label;
        
        self.comformBtn = [[UIButton alloc]initWithFrame:self.endTimeBtn.frame];
        self.comformBtn.backgroundColor = [UIColor clearColor];
        self.comformBtn.centerY = label.centerY;
        self.comformBtn.width = 50;
        self.comformBtn.right = lineBgView.right - 10;
        self.comformBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        self.comformBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.comformBtn setTitle:@"确定" forState:UIControlStateNormal];
        [self.comformBtn setTitleColor:color forState:UIControlStateNormal];
        [self.comformBtn addTarget:self action:@selector(saveTime:) forControlEvents:UIControlEventTouchUpInside];
        [lineBgView addSubview:self.comformBtn];
        self.comformBtn.hidden = YES;
        
        [_dateView addSubview:self.datePicker];
        _dateView.width = 0;
        _dateView.height = 0;
        _dateView.alpha = 0;
        
    }
    
    return _dateView;
}

- (UIButton *)startTimeBtn {
    if(_startTimeBtn == nil) {
        _startTimeBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        _startTimeBtn.width = BtnWidth;
        _startTimeBtn.height = BtnHeight;
        _startTimeBtn.left = 20;
        _startTimeBtn.top = 10;
        [_startTimeBtn setTitle:@"开始时间" forState:UIControlStateNormal];
        [self changeBtnView:_startTimeBtn];
        _startTimeBtn.tag = 100;
        [_startTimeBtn addTarget:self action:@selector(tapBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startTimeBtn;
}

- (UIButton *)endTimeBtn {
    if(_endTimeBtn == nil) {
        _endTimeBtn = [[UIButton alloc] init];
        _endTimeBtn.width = BtnWidth;
        _endTimeBtn.height = BtnHeight;
        _endTimeBtn.right = kScreenSize.width-20;
        _endTimeBtn.top = 10;
        [_endTimeBtn setTitle:@"结束时间" forState:UIControlStateNormal];
        _endTimeBtn.selected = YES;
        [self changeBtnView:_endTimeBtn];
        _endTimeBtn.tag = 200;
        [_endTimeBtn addTarget:self action:@selector(tapBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _endTimeBtn;
}

- (UIDatePicker *)datePicker {
    if(_datePicker == nil) {
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.width = kScreenSize.width - 40;
        _datePicker.height = self.dateView.height - BtnHeight * 5 ;
        _datePicker.top = self.lineBgView.bottom + 5;
        _datePicker.left = 20;
        _datePicker.datePickerMode = UIDatePickerModeDate;
        [_datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged ];
    }
    return _datePicker;
}

/**
 *  时间选择器的值发生改变时触发的方法
 *
 *  @param sender DatePicker
 */
- (void)dateChanged:(id)sender{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat=@"yyyy-MM-dd";
    
    if(!self.status){//NO为选择开始时间
        NSDate *nowDate = [NSDate date];
        if([[self.datePicker.date laterDate:nowDate] isEqualToDate:nowDate]){
            self.startTimeLabel.text = [formatter stringFromDate:self.datePicker.date ];
            _startTime = self.startTimeLabel.text;
        }else{
            UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"开始时间不合法" message:@"开始时间应早于今天" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertview show];
        }
        
    }else{          //YES为选择结束时间
        NSDate *startDate = [formatter dateFromString:self.startTime];
        if([[startDate earlierDate:self.datePicker.date] isEqualToDate:startDate]){
            self.endTimeLabel.text = [formatter stringFromDate:self.datePicker.date ];
            _endTime = self.endTimeLabel.text;
            self.comformBtn.hidden = NO;
        }else{
            UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"结束时间不合法" message:@"结束时间应晚于开始时间" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertview show];
        }
        
    }
}



@end
