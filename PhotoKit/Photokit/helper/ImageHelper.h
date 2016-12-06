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
#import "UIImage+Clip.h"

typedef NS_ENUM(NSInteger, AlbumType) {
    AlbumTypeDefault   = 0, // 默认
    AlbumTypeCumstom   = 1  // 自定义
};

#define WINDOW_WIDTH   [UIScreen mainScreen].bounds.size.width

@interface ImageModel : NSObject

@property (nonatomic, strong) UIImage *thumbImage; // 图片

@property (nonatomic, strong) PHAsset * asset;

@end



@interface ImageHelper : NSObject

/**
 获取相册列表

 @param complete callback
 */
+ (void)getAlbumListWithAscend:(BOOL)isAscend complete:(void(^)(NSArray<PHFetchResult *> *albumList))complete;

/**
 通过 asset  获取 imageData

 @param asset asset
 @param complete callback
 */

/**
 通过 asset  获取 imageData

 @param asset asset
 @param complete image 压缩后的图片 / HDImage 高清图 原图
 */
+ (void)getImageDataWithAsset:(PHAsset*)asset complete:(void(^)(UIImage*image,UIImage *HDImage))complete;

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

/**
 弹框

 @param title 标题
 @param message 消息
 @param controller 控制器
 @param isSingle 是否是单个选择
 */
+ (void)showAlertWithTittle:(NSString*)title message:(NSString*)message showController:(UIViewController*)controller isSingleAction:(BOOL)isSingle complete:(void (^)(NSInteger))complete;

@end
