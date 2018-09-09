//
//  Asset.h
//
//  Created by ELC on 2/15/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@class ELCAsset;

@protocol ELCAssetDelegate <NSObject>

@optional
- (void)assetSelected:(ELCAsset *)asset;
- (void)selectedAsset:(ELCAsset *)asset;
- (void)deselectedAsset:(ELCAsset *)asset;
- (int)selectedIndexOfAsset:(ELCAsset*)asset;
@end

@interface ELCAsset : NSObject

@property (nonatomic, strong) ALAsset *asset;
@property (nonatomic, weak) id<ELCAssetDelegate> parent;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) int selectedIndex;

- (id)initWithAsset:(ALAsset *)asset;

@end