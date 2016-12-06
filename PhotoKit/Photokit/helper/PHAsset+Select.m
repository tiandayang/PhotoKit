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

- (void)setSelected:(BOOL)selected
{
    objc_setAssociatedObject(self, PHAssetSelectedKey, @(selected), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)selected
{
    return [objc_getAssociatedObject(self, PHAssetSelectedKey) boolValue];
}


- (void)setThumbImage:(UIImage*)thumbImage
{
    objc_setAssociatedObject(self, PHAssetThumbImageKey, thumbImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)thumbImage
{
    return objc_getAssociatedObject(self, PHAssetThumbImageKey);
}

@end
