//
//  ImageHelper.h
//  PhotoKit
//
//  Created by 田向阳 on 16/11/14.
//  Copyright © 2016年 田向阳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "PHAsset+Select.h"

#define WINDOW_WIDTH   [UIScreen mainScreen].bounds.size.width

@interface ImageModel : NSObject

@property (nonatomic, strong) NSURL *imagePath; // 图片的路径

@property (nonatomic, assign) NSInteger index;  // 选中的索引

@property (nonatomic, strong) UIImage *thumbImage; // 图片

@property (nonatomic, strong) PHAsset * asset;   
@end



@interface ImageHelper : NSObject

+ (void)getAlbumList:(void(^)(NSArray<PHFetchResult *> *albumList))complete;

+ (void)getImageWithAsset:(PHAsset*)asset complete:(void(^)(UIImage*image))complete;
@end
