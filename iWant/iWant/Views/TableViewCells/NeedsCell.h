//
//  NeedsCell.h
//  iWant
//
//  Created by Jiang Chuncheng on 4/22/14.
//  Copyright (c) 2014 SenseForce. All rights reserved.
//

/**
 *  需求列表项
 */

#import <UIKit/UIKit.h>

@interface NeedsCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *iconImageView;
@property (nonatomic, weak) IBOutlet UILabel *ageLabel;
@property (nonatomic, weak) IBOutlet UILabel *distanceLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *subtitleLabel;

@end
