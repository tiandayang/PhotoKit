//
//  ImageHelper.m
//  PhotoKit
//
//  Created by 田向阳 on 16/11/14.
//  Copyright © 2016年 田向阳. All rights reserved.
//

#import "ImageHelper.h"

@implementation ImageHelper

+ (void)getAlbumList:(void(^)(NSArray<PHFetchResult *> *albumList))complete
{
    PHFetchOptions * allPhotosOptions = [[PHFetchOptions alloc]init];
    
    allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    
        //所有图片的集合
   PHFetchResult * allPhotos = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:allPhotosOptions];
        //自定义的
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    option.predicate = [NSPredicate predicateWithFormat:@"estimatedAssetCount > 0"];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:YES];
    option.sortDescriptors = @[sortDescriptor];
    
    PHFetchResult *result = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:option];
    
    
    NSArray *list = @[allPhotos,result];
    complete?complete(list):nil;
}

+ (void)getImageWithAsset:(PHAsset *)asset complete:(void (^)(UIImage *))complete
{
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.synchronous = YES;
    [[PHImageManager defaultManager] requestImageDataForAsset:asset options:option resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        UIImage *image = [UIImage imageWithData:imageData];
        
        complete?complete(image):nil;
    }];
    

}

+ (BOOL)isOpenAuthority
{
    return  PHAuthorizationStatusAuthorized == [PHPhotoLibrary authorizationStatus];
}

+ (void)jumpToSetting
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

@end

@implementation ImageModel



@end


