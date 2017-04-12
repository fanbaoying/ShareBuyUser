//
//  UserDetailsTableViewCell.m
//  ShareBuyUser
//
//  Created by 刘兵 on 16/8/12.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "UserDetailsTableViewCell.h"

@implementation UserDetailsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.textColor = UIColorFromHex(0x393939, 1);
    _contentLabel.font = UIFontPingFangMedium(14);
    _contentLabel.numberOfLines = 0;
    [self addSubview:_contentLabel];
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = UIColorFromHex(0xb8b8b8, 1);
    [self addSubview:_lineView];
    
    _imgScorllView = [[UIScrollView alloc] init];
    [self addSubview:_imgScorllView];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.font = UIFontPingFangMedium(14);
    _timeLabel.textColor = UIColorFromHex(0x757575, 1);
    [self addSubview:_timeLabel];
    
    return self;
}

- (void)setModel:(NSDictionary *)model {
    _model = model;
    
    CGRect rect = [_model[@"content"] boundingRectWithSize:CGSizeMake(kScreenWidth - 20, 1000) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:UIFontPingFangMedium(14)} context:nil];
    [_contentLabel setFrame:CGRectMake(10, 5, kScreenWidth - 20, rect.size.height+10)];
    _contentLabel.text = _model[@"content"];
    
    _lineView.frame = CGRectMake(10, CGRectGetMaxY(_contentLabel.frame), kScreenWidth - 20, 0.5);
    
    _imgScorllView.frame = CGRectMake(10, CGRectGetMaxY(_lineView.frame)+5, kScreenWidth - 20, (kScreenWidth - 30)/3);
    for (int i = 0; i < [_model[@"imgurl"] count]; i++) {
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(((kScreenWidth - 30)/3+5)*i, 0, (kScreenWidth - 30)/3, (kScreenWidth - 30)/3)];
//        img.backgroundColor = [UIColor redColor];
        [img setImageWithURL:[NSURL URLWithString:_model[@"imgurl"][i]] placeholderImage:[UIImage imageNamed:@"product_placeholder"]];
        [_imgScorllView addSubview:img];
    }
    
    _timeLabel.frame = CGRectMake(10, CGRectGetMaxY(_imgScorllView.frame)+5, kScreenWidth - 20, 40);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[_model[@"ctime"] longLongValue]/1000];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    _timeLabel.text = [NSString stringWithFormat:@"分享于%@",dateStr];
    
    [self setFrame:CGRectMake(0, 0, kScreenWidth, CGRectGetMaxY(_timeLabel.frame))];
}

@end
