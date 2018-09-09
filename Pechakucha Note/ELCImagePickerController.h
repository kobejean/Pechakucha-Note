//
//  ELCImagePickerController.h
//  ELCImagePickerDemo
//
//  Created by ELC on 9/9/10.
//  Copyright 2010 ELC Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELCAssetSelectionDelegate.h"

@class ELCImagePickerController;

@protocol ELCImagePickerControllerDelegate <UINavigationControllerDelegate>

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info;
- (void)elcImagePickerController:(ELCImagePickerController *)picker didChangeSelectedMediaWithInfo:(NSArray *)info;
- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker;

- (void)elcImagePickerControllerDidSelectAsset:(id)asset atIndex:(int)index;
- (void)elcImagePickerControllerDidDeselectAsset:(id)asset atIndex:(int)index;

@end

@interface ELCImagePickerController : UINavigationController <ELCAssetSelectionDelegate>

@property (nonatomic, weak) id<ELCImagePickerControllerDelegate> delegate;

- (void)cancelImagePicker;
- (void)doneActionWithAssets:(NSArray *)assets;

@end

