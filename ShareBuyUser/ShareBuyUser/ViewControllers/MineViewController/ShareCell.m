//
//  ShareCell.m
//  ShareBuyUser
//
//  Created by soldier on 16/8/24.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "ShareCell.h"
@implementation ShareCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setBackgroundColor:[UIColor clearColor]];
    
    _bgView = [[UIView alloc] init];
    [_bgView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:_bgView];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    [line setBackgroundColor:UIColorFromHex(0xcccccc, 1)];
    [_bgView addSubview:line];
    
    _contentLabel = [[UILabel alloc] init];
    [_contentLabel setTextColor:UIColorFromHex(0x393939, 1)];
    [_contentLabel setFont:UIFontPingFangMedium(14)];
    [_contentLabel setNumberOfLines:0];
    [_bgView addSubview:_contentLabel];

    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = UIColorFromHex(0xb8b8b8, 1);
    [_bgView addSubview:_lineView];
    
    _imgScorllView = [[UIScrollView alloc] init];
    [_bgView addSubview:_imgScorllView];
    
    _dateLabel = [[UILabel alloc] init];
    [_dateLabel setFont:UIFontPingFangMedium(14)];
    [_bgView addSubview:_dateLabel];
    
    return self;
}

- (void)setModel:(NSDictionary *)model {
    _model = model;
    
    CGRect rect = [_model[@"content"] boundingRectWithSize:CGSizeMake(kScreenWidth - 20, 1000) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:UIFontPingFangMedium(14)} context:nil];
    [_contentLabel setFrame:CGRectMake(10, 5, kScreenWidth - 20, rect.size.height+10)];
    _contentLabel.text = _model[@"content"];
    
    _lineView.frame = CGRectMake(10, CGRectGetMaxY(_contentLabel.frame)+5, kScreenWidth - 20, 0.5);
    
    _imgScorllView.frame = CGRectMake(10, CGRectGetMaxY(_lineView.frame)+10, kScreenWidth - 20, (kScreenWidth - 30)/3);
    
    for (int i = 0; i < [_model[@"imgurl"] count]; i++) {
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(((kScreenWidth - 30)/3+5)*i, 0, (kScreenWidth - 30)/3, (kScreenWidth - 30)/3)];
        [img setImageWithURL:[NSURL URLWithString:_model[@"imgurl"][i]] placeholderImage:[UIImage imageNamed:@"product_placeholder"]];
        [_imgScorllView addSubview:img];
    }
    
    _dateLabel.frame = CGRectMake(10, CGRectGetMaxY(_imgScorllView.frame)+10, 200, 20);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[_model[@"ctime"] longLongValue]/1000];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    _dateLabel.text = [NSString stringWithFormat:@"分享于%@",dateStr];
    
    [_bgView setFrame:CGRectMake(0, 5, kScreenWidth, CGRectGetMaxY(_dateLabel.frame)+10)];
    [self setFrame:CGRectMake(0, 0, kScreenWidth, CGRectGetMaxY(_dateLabel.frame)+15)];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
