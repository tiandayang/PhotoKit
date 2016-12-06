//
//  ImageCollectionViewController.h
//  PhotoKit
//
//  Created by 田向阳 on 16/11/14.
//  Copyright © 2016年 田向阳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageHelper.h"

@interface ImageCollectionViewController : UIViewController
@property (nonatomic, strong)PHFetchResult *assetResult;

@property (nonatomic, copy) void(^okClickComplete)(NSArray<ImageModel *> *images);

/**
 图片的可选数量，默认为9
 */
@property (nonatomic, assign) NSUInteger maximumNumberOfSelection;
@property (nonatomic, copy) NSString *rightItemTitle;
@property (nonatomic,assign) AlbumType albumType;      // 相册的类型，用途

@property (nonatomic, assign) BOOL isAscend;  
@end
