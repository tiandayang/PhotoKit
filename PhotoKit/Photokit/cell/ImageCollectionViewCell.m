//
//  ImageCollectionViewCell.m
//  PhotoKit
//
//  Created by 田向阳 on 16/11/14.
//  Copyright © 2016年 田向阳. All rights reserved.
//

#import "ImageCollectionViewCell.h"
#import "UIImage+Common.h"
#import "Masonry.h"
#define ITEMWIDTH      2 * (WINDOW_WIDTH - 10)/3.0

@implementation ImageCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
        // 图片
    self.imageView = [[UIImageView alloc] init];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
        // 选中的背景
    self.selectImageView = [[UIImageView alloc] init];
    self.selectImageView.backgroundColor = [UIColor clearColor];
    self.selectImageView.image = [UIImage imageNamed:@"ch_selectbg_photo"];
    [self.imageView addSubview: self.selectImageView];
    [ self.selectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
        // 选中的索引
    self.indexLabel = [[UILabel alloc] init];
    self.indexLabel.textColor = [UIColor blackColor];
    self.indexLabel.font = [UIFont systemFontOfSize:14];
    self.indexLabel.textAlignment = NSTextAlignmentCenter;
    [self.imageView addSubview:self.indexLabel];
    [self.indexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    self.selectImageView.hidden = YES;
    self.indexLabel.hidden = YES;
}


- (void)updteImageIsSelected:(BOOL)imageIsSelected complete:(void(^)(BOOL isFinish))complete;
{
    NSTimeInterval timeIntercal = 0.1;
    
    [UIView animateWithDuration:timeIntercal animations:^{
        self.imageView.transform = CGAffineTransformMakeScale(1.03, 1.03);
        
    } completion:^(BOOL finished) {
        
        if (finished) {
            [UIView animateWithDuration:timeIntercal animations:^{
                
                self.imageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                
            } completion:complete];
        }
        
    }];
}



- (void)setAsset:(PHAsset *)asset
{
    _asset = asset;
    if ([_asset.selected boolValue]) {
        self.selectImageView.hidden = NO;
        self.indexLabel.hidden = NO;
    }
    else{
        self.selectImageView.hidden = YES;
        self.indexLabel.hidden = YES;
    }
        for (ImageModel *item in self.selectArray) {
            if ([item.identifier isEqualToString:_asset.localIdentifier]) {
                self.indexLabel.text = [NSString stringWithFormat:@"%ld",item.index];
                break;
            }
        }
    if (!_asset.thumbImage) {
        PHImageManager * imageManager = [PHImageManager defaultManager];
        [imageManager requestImageForAsset:asset targetSize:CGSizeMake(ITEMWIDTH,ITEMWIDTH) contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                UIImage *image = [result imageCompressForTargetSize:CGSizeMake(ITEMWIDTH,ITEMWIDTH)];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.imageView.image = image;
                    _asset.thumbImage = image;
                });
            });
        }];
    }
    else{
        self.imageView.image = _asset.thumbImage;
    }
    
}

@end
