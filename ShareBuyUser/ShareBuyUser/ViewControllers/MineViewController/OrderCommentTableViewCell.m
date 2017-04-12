//
//  OrderCommentTableViewCell.m
//  ShareBuyUser
//
//  Created by Marx on 16/8/16.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "OrderCommentTableViewCell.h"

@implementation OrderCommentTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self customView];
    }
    return self;
}

#pragma mark Custom View
- (void)customView
{
    [self setBackgroundColor:[UIColor clearColor]];
    UIView *bgView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 5, kScreenWidth, 215)];
        [view setBackgroundColor:[UIColor whiteColor]];
        [view addSubview:self.goodImageView];
        [view addSubview:self.goodNameLabel];
        
        _starButtonArray = [[NSMutableArray alloc] init];
        for (int i = 0; i<5; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTag:100+i];
            [button setFrame:CGRectMake(100 + 30*i, 40, 30, 30)];
            [button setBackgroundColor:[UIColor clearColor]];
            [button setImage:[UIImage imageNamed:@"comment_star_button_normal"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"comment_star_button_selected"] forState:UIControlStateSelected];
            [button addTarget:self action:@selector(selectStarButton:) forControlEvents:UIControlEventTouchUpInside];
            
            [view addSubview:button];
            [_starButtonArray addObject:button];
        }
        
        [view addSubview:self.contentTextView];
        
        view;
    });
    [self addSubview:bgView];
}

- (UIImageView *)goodImageView
{
    if (!_goodImageView) {
        _goodImageView = ({
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 75, 75)];
            
            imageView;
        });
    }
    return _goodImageView;
}

- (UILabel *)goodNameLabel
{
    if (!_goodNameLabel) {
        _goodNameLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 5, kScreenWidth -110, 30)];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setTextColor:UIColorFromHex(0x696969, 1)];
            [label setFont:UIFontPingFangRegular(15)];
            label;
        });
    }
    return _goodNameLabel;
}

- (UITextView *)contentTextView
{
    if (!_contentTextView) {
        _contentTextView = ({
            UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 100, kScreenWidth-20, 100)];
            [textView setDelegate:self];
            [textView.layer setMasksToBounds:YES];
            [textView.layer setCornerRadius:10];
            [textView setBackgroundColor:UIColorFromHex(0xf6f6f6, 1)];
            [textView setReturnKeyType:UIReturnKeyDone];
            [textView setFont:UIFontPingFangRegular(15)];
            [textView setAutocorrectionType:UITextAutocorrectionTypeNo];
            [textView setAutocapitalizationType:UITextAutocapitalizationTypeNone];
            textView;
        });
    }
    return _contentTextView;
}

- (void)setStarValue:(NSInteger)value
{
    for (int i =0; i<5; i++) {
        UIButton *button = _starButtonArray[i];
        [button setSelected:i<value];
    }
}

#pragma mark Button Action
- (IBAction)selectStarButton:(UIButton *)sender
{
    NSInteger value = sender.tag - 99;
    [self setStarValue:value];
    if ([self.delegate respondsToSelector:@selector(orderCommentTableViewCell:changeStar:)]) {
        [self.delegate orderCommentTableViewCell:self changeStar:value];
    }
}

#pragma mark UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"请输入"]) {
        [textView setText:@""];
        [textView setTextColor:UIColorFromHex(0x696969, 1)];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length ==0) {
        [textView setText:@"请输入"];
        [textView setTextColor:UIColorFromHex(0x999999, 1)];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
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
