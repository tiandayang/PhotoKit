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
#import "UIImage+Common.h"

#define WINDOW_WIDTH   [UIScreen mainScreen].bounds.size.width

@interface ImageModel : NSObject

@property (nonatomic, copy)   NSString *identifier; // 图片的标识

@property (nonatomic, strong) UIImage *thumbImage; // 图片

@property (nonatomic, strong) PHAsset * asset;   
@end



@interface ImageHelper : NSObject

/**
 获取相册列表

 @param complete callback
 */
+ (void)getAlbumList:(void(^)(NSArray<PHFetchResult *> *albumList))complete;

/**
 通过 asset  获取 imageData

 @param asset asset
 @param complete callback
 */
+ (void)getImageDataWithAsset:(PHAsset*)asset complete:(void(^)(UIImage*image))complete;

/**
 获取指定大小的图片

 @param asset asset
 @param size size
 @param complete callback
 */
+ (void)getImageWithAsset:(PHAsset*)asset targetSize:(CGSize)size complete:(void (^)(UIImage *))complete;

/**
 是否开启相册权限

 @return yes or no
 */
+ (BOOL)isOpenAuthority;

/**
 跳转到设置界面 
 */
+ (void)jumpToSetting;
@end
