//
//  PHAsset+Select.m
//  ShopnFriends
//
//  Created by 田向阳 on 16/11/15.
//  Copyright © 2016年 WangSuyan. All rights reserved.
//

#import "PHAsset+Select.h"
#import <objc/runtime.h>
@implementation PHAsset (Select)
static void * PHAssetSelectedKey    = (void *)@"PHAssetSelectedKey";
static void * PHAssetThumbImageKey  = (void *)@"PHAssetThumbImageKey";
static void * PHAssetImagePathKey   = (void *)@"PHAssetImagePathKey";
static void * PHAssetIndexKey       = (void *)@"PHAssetIndexKey";

- (void)setSelected:(id)selected
{
    objc_setAssociatedObject(self, PHAssetSelectedKey, selected, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)selected
{
    return objc_getAssociatedObject(self, PHAssetSelectedKey);
}




- (void)setThumbImage:(id)thumbImage
{
    objc_setAssociatedObject(self, PHAssetThumbImageKey, thumbImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)thumbImage
{
    return objc_getAssociatedObject(self, PHAssetThumbImageKey);
}




- (void)setImagePath:(id)imagePath
{
    objc_setAssociatedObject(self, PHAssetImagePathKey, imagePath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)imagePath
{
    return objc_getAssociatedObject(self, PHAssetImagePathKey);
}


- (void)setIndex:(id)index
{
    objc_setAssociatedObject(self, PHAssetIndexKey, index, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

}

- (id)index
{
    return objc_getAssociatedObject(self, PHAssetIndexKey);
}

@end
