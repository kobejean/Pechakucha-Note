//
//  ELCAssetSelectionDelegate.h
//  ELCImagePickerDemo
//
//  Created by JN on 9/6/12.
//  Copyright (c) 2012 ELC Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ELCAssetSelectionDelegate <NSObject>

- (void)selectedAsset:(id)asset atIndex:(int)index;
- (void)deselectedAsset:(id)asset atIndex:(int)index;
- (void)doneActionWithAssets:(NSArray *)assets;

@end
