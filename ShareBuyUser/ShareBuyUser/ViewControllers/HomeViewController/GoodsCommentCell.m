//
//  GoodsCommentCell.m
//  ShareBuyUser
//
//  Created by soldier on 16/9/7.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "GoodsCommentCell.h"

@implementation GoodsCommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _headImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 27, 27)];
    _headImg.backgroundColor = [UIColor greenColor];
    _headImg.layer.masksToBounds = YES;
    _headImg.layer.cornerRadius = 13.5;
    [self addSubview:_headImg];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headImg.frame)+5, CGRectGetMinY(_headImg.frame), 200, CGRectGetHeight(_headImg.frame))];
    _nameLabel.text = @"林允儿";
    _nameLabel.font = UIFontPingFangMedium(14);
    [self addSubview:_nameLabel];
    
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.textColor = UIColorFromHex(0x676767, 1);
    _contentLabel.font = UIFontPingFangMedium(14);
    _contentLabel.numberOfLines = 0;
    [self addSubview:_contentLabel];
    
    return self;
}

- (void)setModel:(NSDictionary *)model {
    _model = model;
    
    [_headImg setImageWithURL:[NSURL URLWithString:_model[@"headurl"]] placeholderImage:[UIImage imageNamed:@"product_placeholder"]];
    [_headImg setUserInteractionEnabled:YES];
    [_nameLabel setText:_model[@"nickname"]];
    
    _contentLabel.text = _model[@"content"];
    CGRect rect = [_model[@"content"] boundingRectWithSize:CGSizeMake(kScreenWidth - 20, 1000) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:UIFontPingFangMedium(14)} context:nil];
    _contentLabel.frame = CGRectMake(10, CGRectGetMaxY(_headImg.frame)+5, kScreenWidth - 20, rect.size.height);
    [self setFrame:CGRectMake(0, 0, kScreenWidth, CGRectGetMaxY(_contentLabel.frame)+10)];
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
