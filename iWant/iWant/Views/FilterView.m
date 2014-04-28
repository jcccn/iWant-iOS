//
//  FilterView.m
//  iWant
//
//  Created by Jiang Chuncheng on 4/28/14.
//  Copyright (c) 2014 SenseForce. All rights reserved.
//

#import "FilterView.h"

@implementation FilterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (instancetype)loadInstance {
    return [[[NSBundle mainBundle] loadNibNamed:@"FilterView" owner:nil options:nil] lastObject];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
