//
//  UIAboutView.m
//  PPCloak
//
//  Created by Costin Andronache on 6/30/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "UIAboutView.h"
#import "UIAboutCollectionViewCell.h"
#import "NSBundle+RSFrameworkHooks.h"

@implementation UIAboutViewPageInfo
@end

@interface UIAboutView() <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray<UIAboutViewPageInfo*> *pageInfos;

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end

@implementation UIAboutView

-(void)setupWithPageInfos:(NSArray<UIAboutViewPageInfo *> *)pageInfos {
    self.pageInfos = pageInfos;
    [self.collectionView reloadData];
    self.pageControl.numberOfPages = pageInfos.count;
    self.pageControl.currentPage = 0;
}


-(void)commonInit{
    [super commonInit];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    UINib *nib = [UINib nibWithNibName:[UIAboutCollectionViewCell identifierNibName] bundle:[NSBundle PPCloakBundle]];
    
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:[UIAboutCollectionViewCell identifierNibName]];
    
    self.pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    self.pageControl.userInteractionEnabled = NO;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return  1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.pageInfos.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UIAboutCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[UIAboutCollectionViewCell identifierNibName] forIndexPath:indexPath];
    
    UIAboutViewPageInfo *info =  self.pageInfos[indexPath.item];
    [cell setupWithText:info.text imageName:info.imageName];
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return collectionView.bounds.size;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageIndex =  scrollView.contentSize.width / scrollView.contentOffset.x;
    self.pageControl.currentPage = pageIndex;
}

@end
