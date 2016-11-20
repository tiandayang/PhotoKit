
    //
//  ImageCollectionViewController.m
//  PhotoKit
//
//  Created by 田向阳 on 16/11/14.
//  Copyright © 2016年 田向阳. All rights reserved.
//

#import "ImageCollectionViewController.h"
#import "ImageCollectionViewCell.h"

static NSString * const kCellIdentifier = @"ImageCollectionViewCellIdentifier";
static NSInteger const kItemsOfRow = 3;
static CGFloat const kItemsSpace = 5.0;

@interface ImageCollectionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic,strong)UICollectionView *collectionView;

@property (nonatomic,strong)NSMutableArray *selectArray;
@end

@implementation ImageCollectionViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _maximumNumberOfSelection = 9;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    [self setUpFirstData];
    [self loadData];
}


- (void)setUpFirstData
{
    self.selectArray = [NSMutableArray array];
    self.title = @"相机胶卷";
        if (self.rightItemTitle) {
            [self setRightButtonItemWithTitle:self.rightItemTitle];
    }
}
- (void)didClickNavigationBarViewRightButton
{

    self.okClickComplete ? self.okClickComplete(self.selectArray) : nil;
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)loadData
{
    [self changeRightItemState];
}

- (void)setAssetResult:(PHFetchResult *)assetResult
{
    _assetResult = assetResult;
    [_collectionView reloadData];
}
#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.assetResult.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.imageView.image  = [UIImage imageNamed:@"ch_camera_photo"];
        cell.selectImageView.hidden = YES;
        cell.indexLabel.hidden = YES;
    }else{
        PHAsset *asset = self.assetResult[indexPath.row - 1];
        cell.selectArray = self.selectArray;
        cell.asset = asset;
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = (WINDOW_WIDTH - (kItemsOfRow -1) * kItemsSpace) / kItemsOfRow;
    return CGSizeMake(width, width);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        if (self.selectArray.count >= self.maximumNumberOfSelection) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"最多只能选择%lu张图片",(unsigned long)self.maximumNumberOfSelection] message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = NO;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    else{
        
        ImageCollectionViewCell *cell = (ImageCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
        if ([cell.asset.selected boolValue]) {
            for (ImageModel *subItem in self.selectArray.mutableCopy) {
                if ([subItem.identifier isEqualToString:cell.asset.localIdentifier]) {
                    [self.selectArray removeObject:subItem];
                    break;
                }
            }
        }
        else{
            
            if (self.selectArray.count >= self.maximumNumberOfSelection) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"最多只能选择%lu张图片",(unsigned long)self.maximumNumberOfSelection] message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
            ImageModel *item = [ImageModel new];
            item.identifier = cell.asset.localIdentifier;
            item.asset = cell.asset;
            [self.selectArray addObject:item];
        }
        [self.selectArray enumerateObjectsUsingBlock:^(ImageModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.index = ++idx;
        }];
        [self changeCurrentSelectedItemIndexWithCell:cell];
    }
    
}

- (void)changeCurrentSelectedItemIndexWithCell:(ImageCollectionViewCell*)cell
{
    self.collectionView.userInteractionEnabled = NO;
    cell.selectImageView.hidden = !cell.selectImageView.hidden;
    cell.indexLabel.hidden = !cell.indexLabel.hidden;
    cell.asset.selected = @(![cell.asset.selected boolValue]);
    cell.indexLabel.text = [NSString stringWithFormat:@"%ld",self.selectArray.count];
    [self changeRightItemState];
    [cell updteImageIsSelected:!cell.selectImageView.hidden complete:^(BOOL isFinish) {
        self.collectionView.userInteractionEnabled = YES;
        [self.collectionView reloadData];
    }];
    
}
#pragma mark -   imagepicker delegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    
    UIImage *theImage;
    if (picker.allowsEditing) {
        theImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    }else{
        theImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        
    }
      UIImageWriteToSavedPhotosAlbum(theImage, nil, nil, nil);
        ImageModel *item = [ImageModel new];
        item.thumbImage = theImage;
        [self.selectArray addObject:item];
    [picker dismissViewControllerAnimated:NO completion:nil];
    [self didClickNavigationBarViewRightButton];
}

- (NSMutableArray*)selectArray
{
    if (!_selectArray) {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}

- (UICollectionView*)collectionView
{
    if (!_collectionView) {
     
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = kItemsSpace;
        layout.minimumInteritemSpacing = kItemsSpace;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        [_collectionView registerClass:[ImageCollectionViewCell class] forCellWithReuseIdentifier:kCellIdentifier];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = self.view.backgroundColor;
    }
    
    return _collectionView;
}


#pragma mark - helper
- (void)changeRightItemState
{
    NSUInteger imageCount = self.selectArray.count;
    if (imageCount > 0) {
        if (self.rightItemTitle) {
            [self setRightButtonItemWithTitle:[self.rightItemTitle stringByAppendingString:[NSString stringWithFormat:@"(%@)", [@(imageCount) stringValue]]]];
        }
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }else{
        [self setRightButtonItemWithTitle:self.rightItemTitle];
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}
- (void)setRightButtonItemWithTitle:(NSString *)titleString
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:titleString style:UIBarButtonItemStylePlain target:self action:@selector(didClickNavigationBarViewRightButton)];
}

@end
