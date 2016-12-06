//
//  ImageHelper.m
//  PhotoKit
//
//  Created by 田向阳 on 16/11/14.
//  Copyright © 2016年 田向阳. All rights reserved.
//

#import "ImageHelper.h"

@implementation ImageHelper

+ (void)getAlbumListWithAscend:(BOOL)isAscend complete:(void(^)(NSArray<PHFetchResult *> *albumList))complete
{
    PHFetchOptions * allPhotosOptions = [[PHFetchOptions alloc]init];
    
    allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:isAscend]];
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

+ (void)getImageDataWithAsset:(PHAsset *)asset complete:(void (^)(UIImage *,UIImage*))complete
{
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.synchronous = YES;
    [[PHImageManager defaultManager] requestImageDataForAsset:asset options:option resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        UIImage *HDImage = [UIImage imageWithData:imageData];
        UIImage *image = [UIImage clipImage:HDImage];
        complete?complete(image,HDImage):nil;
    }];
    

}

+ (void)getImageWithAsset:(PHAsset*)asset targetSize:(CGSize)size complete:(void (^)(UIImage *))complete{
    PHImageManager *imageManager = [PHImageManager defaultManager];
    [imageManager requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                complete?complete(result):nil;
            });
        });
    }];
}

+ (BOOL)isOpenAuthority
{
    return [PHPhotoLibrary authorizationStatus] != PHAuthorizationStatusDenied;
}

+ (void)jumpToSetting
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

+ (void)showAlertWithTittle:(NSString *)title message:(NSString *)message showController:(UIViewController *)controller isSingleAction:(BOOL)isSingle complete:(void (^)(NSInteger))complete{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        complete?complete(0):nil;
    }];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        complete?complete(1):nil;
    }];
    if (!isSingle) {
        [alertController addAction:cancleAction];
    }
    [alertController addAction:confirmAction];
    [controller presentViewController:alertController animated:YES completion:nil];
}
@end

@implementation ImageModel



@end


