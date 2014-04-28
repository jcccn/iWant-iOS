//
//  FilterView.h
//  iWant
//
//  Created by Jiang Chuncheng on 4/28/14.
//  Copyright (c) 2014 SenseForce. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterView : UIView

+ (instancetype)loadInstance;

@property (nonatomic, weak) IBOutlet UISegmentedControl *genderSegmentedControl;    //性别
@property (nonatomic, weak) IBOutlet UISegmentedControl *timeSegmentedControl;      //时间
@property (nonatomic, weak) IBOutlet UIButton *cancelButton;    //取消按钮
@property (nonatomic, weak) IBOutlet UIButton *confirmButton;   //确定按钮

@end
