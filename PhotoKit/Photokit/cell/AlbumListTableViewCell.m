//
//  AlbumListTableViewCell.m
//  PhotoKit
//
//  Created by 田向阳 on 16/11/16.
//  Copyright © 2016年 田向阳. All rights reserved.
//

#import "AlbumListTableViewCell.h"
#import "Masonry.h"
const NSInteger kLeftEdge               = 14;

@implementation AlbumListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    _coverImageView = ({
        
        UIImageView *view = [UIImageView new];
        [self.contentView addSubview:view];
        view.contentMode = UIViewContentModeScaleAspectFill;
        view.clipsToBounds = YES;
        view;
        
    });
    
    _albumNameLabel = ({
        
        UILabel *view = [UILabel new];
        view.textColor = [UIColor blackColor];
        view.numberOfLines = 1;
        view.font = [UIFont boldSystemFontOfSize:18];
        [self.contentView addSubview:view];
        
        view;
        
    });
    
    _albumDetailLabel = ({
        
        UILabel *view = [UILabel new];
        view.textColor = [UIColor blackColor];
        view.numberOfLines = 1;
        view.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:view];
        
        view;
        
    });
    
    [_coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kLeftEdge);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(60);
        make.centerY.mas_equalTo(0);
    }];
    
    [_albumNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_coverImageView.mas_right).offset(kLeftEdge);
        make.right.mas_equalTo(-kLeftEdge);
        make.top.mas_equalTo(_coverImageView.mas_top);
    }];
    
    [_albumDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_albumNameLabel.mas_left);
        make.right.mas_equalTo(_albumNameLabel.mas_right);
        make.bottom.mas_equalTo(_coverImageView.mas_bottom);
    }];
}

@end
