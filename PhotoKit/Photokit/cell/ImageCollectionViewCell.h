//
//  ImageCollectionViewCell.h
//  PhotoKit
//
//  Created by 田向阳 on 16/11/14.
//  Copyright © 2016年 田向阳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageHelper.h"
@interface ImageCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *selectImageView;
@property (nonatomic, strong) UILabel *indexLabel;
@property (nonatomic, strong) PHAsset *asset;
@property (nonatomic, strong) NSMutableArray *selectArray;

- (void)updteImageIsSelected:(BOOL)imageIsSelected complete:(void(^)(BOOL isFinish))complete;

@end
