//
//  TableViewCell.m
//  Example
//
//  Created by xiaopin on 2018/11/7.
//  Copyright © 2018 xiaopin. All rights reserved.
//

#import "TableViewCell.h"

@interface TableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *colorView;
@property (weak, nonatomic) IBOutlet UILabel *colorLabel;

@end

@implementation TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setColorWithRed:(double)r green:(double)g blue:(double)b {
    self.colorView.backgroundColor = [UIColor colorWithRed:r green:g blue:b alpha:1.0];
    self.colorLabel.text = [NSString stringWithFormat:@"(%.2f, %.2f, %.2f)", r, g, b];
}

@end
