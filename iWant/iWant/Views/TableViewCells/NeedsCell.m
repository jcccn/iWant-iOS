//
//  NeedsCell.m
//  iWant
//
//  Created by Jiang Chuncheng on 4/22/14.
//  Copyright (c) 2014 SenseForce. All rights reserved.
//

#import "NeedsCell.h"

@interface NeedsCell ()

- (NSString *)expireDateFromTimestamp:(NSTimeInterval)timestamp;

@end

@implementation NeedsCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutWithNeeds:(MONeeds *)needs {
    self.ageLabel.text = [NSString stringWithFormat:@"%@ | %d岁", @"男", 56];
    self.distanceLabel.text = @"服务端算距离";
    self.dateLabel.text = [self expireDateFromTimestamp:needs.expiredate];
    self.titleLabel.text = needs.title;
    self.subtitleLabel.text = needs.content;
    [self.iconImageView setImageWithURL:[NSURL URLWithString:@"http://mimi.wumii.cn/images/download/app_logo_v2.jpg"]];
}

- (NSString *)expireDateFromTimestamp:(NSTimeInterval)timestamp {
    NSString *friendlyString;
    NSTimeInterval timeInterval = timestamp - [[NSDate date] timeIntervalSince1970];
    if (timeInterval < 0) {
        friendlyString = @"已过期";
    }
    else if (timeInterval <= 3600) {     //1小时之内
        friendlyString = [NSString stringWithFormat:@"%.0f分钟", timeInterval / 60.0f];
    }
    else if (timeInterval < 2 * 3600) {
        friendlyString = [NSString stringWithFormat:@"1小时%.0f分钟", (timeInterval - 3600) / 60.0f];
    }
    else if (timeInterval < 24 * 3600) {
        friendlyString = [NSString stringWithFormat:@"%.0f小时", timeInterval / 3600.0f];
    }
    else {
        NSInteger dayCount = (NSInteger)(timeInterval / (24 * 3600));
        friendlyString = [NSString stringWithFormat:@"%d天%0.0f小时", dayCount, (timeInterval / 3600 - dayCount * 24)];
    }
    return friendlyString;
}

@end
