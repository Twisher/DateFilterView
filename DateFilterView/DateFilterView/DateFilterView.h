//
//  DateFilterView.h
//  Maticsoft
//
//  Created by jake on 16/3/23.
//  Copyright © 2016年 Maticsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DateFilterView;

@protocol DateFilterViewDelegate <NSObject>
-(void)transferDate:(DateFilterView *)dateFilter
      withStartTime:(NSString *)startTime andEndTime:(NSString *)endTime;
@end

@interface DateFilterView : UIView

@property (nonatomic , weak) id<DateFilterViewDelegate> delegate;
/**
 *  开始时间
 */
@property (nonatomic , readonly) NSString *startTime;
/**
 *  结束时间
 */
@property (nonatomic , readonly) NSString *endTime;
/**
 *  主题颜色
 */
@property (nonatomic , strong) UIColor *themeColor;
/**
 *  默认开始时间
 */
@property (nonatomic , strong) NSString *defaultStartTime;
/**
 *  默认结束时间
 */
@property (nonatomic , strong) NSString *defaultEndTime;


/**
 *  初始化方法
 *
 *  @param view 待添加的父视图
 *
 *  @return
 */
- (instancetype)initWithSuperView:(UIView *)view;
/**
 *  在父视图上展示
 */
- (void)showDateView;
@end
