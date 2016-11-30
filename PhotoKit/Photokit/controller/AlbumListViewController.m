//
//  AlbumListViewController.m
//  PhotoKit
//
//  Created by 田向阳 on 16/11/16.
//  Copyright © 2016年 田向阳. All rights reserved.
//

#import "AlbumListViewController.h"
#import "AlbumListTableViewCell.h"
#import "ImageCollectionViewController.h"

@interface AlbumListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation AlbumListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"相册";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    
       [self loadAlbums];
    
    if (self.dataArray.count>0) {
        PHFetchResult *result = (PHFetchResult*)self.dataArray[0];
        if (result) {
            [self jumpToImageDetailWithGroup:result isAnimate:NO];
            
        }
        
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadAlbums];
}

#pragma mark - LoadData
- (void)loadAlbums
{
    if (![ImageHelper isOpenAuthority]) {
        
       UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"您未打开照片权限" message:nil preferredStyle:UIAlertControllerStyleAlert];
               [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dismiss];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [ImageHelper jumpToSetting];
        }]];

        [self presentViewController:alertController animated:YES completion:nil];

        return;
    }
    
    [ImageHelper getAlbumList:^(NSArray<PHFetchResult *> *albumList) {
        self.dataArray = albumList.mutableCopy;
    }];
}

#pragma mark - Action

- (void)dismiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Private

#pragma mark - tableView  dataSource & delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else{
            //每种集合下的分组数量
        PHFetchResult * fetchResult = (PHFetchResult*)self.dataArray[section];
        if (fetchResult) {
            return fetchResult.count;
        }
    }
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AlbumListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[AlbumListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    AlbumListTableViewCell *albumListCell = (AlbumListTableViewCell *)cell;
    PHFetchResult *fetchResult = (PHFetchResult*)self.dataArray[indexPath.section];
    if (indexPath.section == 0) {
        albumListCell.albumNameLabel.text   = @"相机胶卷";
        albumListCell.albumDetailLabel.text = [NSString stringWithFormat:@"%ld", (long)fetchResult.count];
    }
    else{
        PHCollection *collection = fetchResult[indexPath.row];
        albumListCell.albumNameLabel.text = collection.localizedTitle;
        if ([collection isKindOfClass:[PHAssetCollection class]]) {
            PHAssetCollection * assetCollection = (PHAssetCollection *)collection;
            PHFetchResult * assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
            albumListCell.albumDetailLabel.text = [NSString stringWithFormat:@"%ld", (long)assetsFetchResult.count];
            fetchResult = assetsFetchResult;
        }
        
    }
    PHAsset *asset = fetchResult[0];
    [ImageHelper getImageWithAsset:asset targetSize:CGSizeMake(120,120) complete:^(UIImage *image) {
        albumListCell.coverImageView.image = image;
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PHFetchResult *result = nil;
    if (indexPath.section == 0) {
        result = (PHFetchResult*)self.dataArray[0];
    }
    else{
        PHFetchResult *fetchResult = (PHFetchResult*)self.dataArray[indexPath.section];
        PHCollection *collection = fetchResult[indexPath.row];
        if (![collection isKindOfClass:[PHAssetCollection class]]) {
            return;
        }
        PHAssetCollection * assetCollection = (PHAssetCollection *)collection;
        result = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    }
    
    [self jumpToImageDetailWithGroup:result isAnimate:YES];
}

- (void)jumpToImageDetailWithGroup:(PHFetchResult *)fetchResult isAnimate:(BOOL)isAnimate
{
    ImageCollectionViewController *imagePickerController = [[ImageCollectionViewController alloc] init];
    imagePickerController.assetResult = fetchResult;
    imagePickerController.rightItemTitle = self.rightTitle ?: @"发送";
    imagePickerController.okClickComplete = self.okClickComplete;
    imagePickerController.maximumNumberOfSelection = self.maxSelectCount;
    [self.navigationController pushViewController:imagePickerController animated:isAnimate];
}

@end
