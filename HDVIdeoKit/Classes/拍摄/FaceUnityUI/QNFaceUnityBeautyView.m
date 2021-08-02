//
//  QNFaceUnityBeautyView.m
//  ShortVideo
//
//  Created by hxiongan on 2019/4/30.
//  Copyright © 2019年 ahx. All rights reserved.
//

#import "QNFaceUnityBeautyView.h"
#import "Macro.h"
#import "HDFaceCollectionViewCell.h"
#import "HDFaceModel.h"

@interface QNFaceUnityBeautyView ()
<
UICollectionViewDelegate,
UICollectionViewDataSource
>

@property (nonatomic, strong) NSArray *itemArray;
@property (nonatomic, strong) NSArray *imagesArray;
/**
 记录上一次操作
 */
@property (nonatomic, strong) NSIndexPath *lastIndexPath;
@end

@implementation QNFaceUnityBeautyView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.dataArr = [NSMutableArray array];
        self.itemArray = @[@"恢复",@"美颜", @"磨皮", @"美白"];
        
        self.imagesArray = @[HDBundleImage(@"mine/icon_no"),
                             HDBundleImage(@"mine/icon_face"),
                             HDBundleImage(@"mine/icon_system_mopi"),
                             HDBundleImage(@"mine/icon_write")];
        
        for (int i=0; i<self.itemArray.count; i++) {
            HDFaceModel *model = [[HDFaceModel alloc]init];
            model.title = self.itemArray[i];
            model.imageName = self.imagesArray[i];
            [self.dataArr addObject:model];
        }
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(kScreenWidth / 5, 100);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        CGRect rc = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 60);
        self.collectionView = [[UICollectionView alloc] initWithFrame:rc collectionViewLayout:layout];
        self.collectionView.delegate = self;
        self.collectionView.backgroundColor = [UIColor clearColor];
        self.collectionView.dataSource = self;
        self.collectionView.showsHorizontalScrollIndicator = NO;
        [self.collectionView registerClass:HDFaceCollectionViewCell.class forCellWithReuseIdentifier:@"Cell"];
        [self addSubview:self.collectionView];

        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.equalTo(self);
            make.top.equalTo(self);
            make.height.mas_equalTo(100);
        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ( self.itemArray.count  > 1 ) {
                [self collectionView:self.collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];

            }
        });
    }
    return self;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    HDFaceCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.model = self.dataArr[indexPath.item];
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    for (int i=0; i<self.dataArr.count; i++) {
        HDFaceModel *model = self.dataArr[i];
        model.isselection = i==indexPath.item?YES:NO;
    }
    
    [self.collectionView reloadData];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(beautyView:didSelectedIndex:)]) {
        [self.delegate beautyView:self didSelectedIndex:indexPath.row];
    }
    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:(UICollectionViewScrollPositionCenteredHorizontally) animated:YES];
    self.lastIndexPath = indexPath;
}

- (void)reset {
    NSArray *paths = [self.collectionView indexPathsForVisibleItems];
    if (paths.count) {
        NSIndexPath *indexPath = paths[1];
        [self collectionView:self.collectionView didSelectItemAtIndexPath:indexPath];
    }
}
- (void)restoredstate {
    if (self.lastIndexPath) {
        if (self.lastIndexPath.item == 0) {
            [self collectionView:self.collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
        }else{
            [self collectionView:self.collectionView didSelectItemAtIndexPath:self.lastIndexPath];
        }

    }
}

@end
