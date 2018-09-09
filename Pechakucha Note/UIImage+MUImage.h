//
//  UIImage+MUImage.h
//  Pechakucha Note
//
//  Created by Jean on 4/22/13.
//  Copyright (c) 2013 Pechakucha Note. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface UIImage (MUImage)

+ (UIImage*)imageFromView:(UIView*)view;
+ (UIImage*)imageFromView:(UIView*)view scaledToSize:(CGSize)newSize contentMode:(UIViewContentMode)contentMode;
+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize contentMode:(UIViewContentMode)contentMode;
+ (UIImage*)imageWithAtPath:(NSString*)path scaledToSize:(CGSize)newSize autosave:(BOOL)autosave contentMode:(UIViewContentMode)contentMode;
- (id)initWithContentsOfResolutionIndependentFile:(NSString *)path;
+ (UIImage*)imageWithContentsOfResolutionIndependentFile:(NSString *)path;
- (id)initWithImage:(id)image retinaImage:(id)retinaImage;
+ (id)imageWithImage:(id)image retinaImage:(id)retinaImage;

@end
