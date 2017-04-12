//
//  MessageDetailCell.m
//  ShareBuyUser
//
//  Created by soldier on 16/8/26.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "MessageDetailCell.h"

@implementation MessageDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor clearColor]];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 25)];
        [_timeLabel setTextAlignment:NSTextAlignmentCenter];
        [_timeLabel setTextColor:UIColorFromHex(0x696969, 1)];
        [_timeLabel setFont:UIFontPingFangMedium(14.0f)];
        [self addSubview:_timeLabel];
        
        _contentBgView = [[UIView alloc] init];
        [_contentBgView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:_contentBgView];
        
        _contentLabel = [[UILabel alloc] init];
        [_contentLabel setFont:UIFontPingFangMedium(15.0f)];
        [_contentLabel setNumberOfLines:0];
        [_contentLabel setLineBreakMode:NSLineBreakByCharWrapping];
        [_contentBgView addSubview:_contentLabel];
        
    }
    
    return self;
}

- (void)setModel:(NSDictionary *)model {
    _model = model;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy.MM.dd"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[_model[@"ctime"] longLongValue]/1000];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    _timeLabel.text = [NSString stringWithFormat:@"%@",dateStr];

    _contentLabel.text = _model[@"content"];
    CGRect rect = [_model[@"content"] boundingRectWithSize:CGSizeMake(kScreenWidth - 20, 1000) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:UIFontPingFangMedium(14)} context:nil];
    
    if (rect.size.height<60) {
        [_contentBgView setFrame:CGRectMake(0, 25, kScreenWidth, 60)];
        _contentLabel.frame = CGRectMake(10, 0, kScreenWidth - 20, 60);
    }else
    {
        [_contentBgView setFrame:CGRectMake(0, 25, kScreenWidth, rect.size.height)];
        _contentLabel.frame = CGRectMake(10, 0, kScreenWidth - 20, rect.size.height);
    }
    [self setFrame:CGRectMake(0, 0, kScreenWidth, CGRectGetMaxY(_contentLabel.frame)+25)];
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
