//
//  UIImage+MUImage.m
//  Pechakucha Note
//
//  Created by Jean on 4/22/13.
//  Copyright (c) 2013 Pechakucha Note. All rights reserved.
//

#import "UIImage+MUImage.h"


@implementation UIImage (MUImage)

+ (void)beginImageContextWithSize:(CGSize)size scale:(float)scale
{
    UIGraphicsBeginImageContextWithOptions(size, YES, scale);
}

+ (void)endImageContext
{
    UIGraphicsEndImageContext();
}

+ (UIImage*)imageFromView:(UIView*)view
{
    BOOL hidden = [view isHidden];
    
    //create image
    [self beginImageContextWithSize:[view bounds].size scale:1.0f];
    [view setHidden:NO];
    [[view layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    [self endImageContext];
    [view setHidden:hidden];
    
    //create retinaImage
    [self beginImageContextWithSize:[view bounds].size scale:1.0f];
    [view setHidden:NO];
    [[view layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *retinaImage = UIGraphicsGetImageFromCurrentImageContext();
    [self endImageContext];
    [view setHidden:hidden];
    
    return [UIImage imageWithImage:image retinaImage:retinaImage];
}

+ (UIImage*)imageFromView:(UIView*)view scaledToSize:(CGSize)newSize contentMode:(UIViewContentMode)contentMode
{
    UIImage *image = [self imageFromView:view];
    if ([view bounds].size.width != newSize.width ||
        [view bounds].size.height != newSize.height) {
        image = [self imageWithImage:image scaledToSize:newSize contentMode:contentMode];
    }
    return image;
}

+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize contentMode:(UIViewContentMode)contentMode
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    //UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, newSize.width, newSize.height)];
    [imageView setContentMode:contentMode];
    imageView.frame = CGRectMake(0, 0, newSize.width, newSize.height);
    //[imageView setImage:image];
    UIImage *newImage = [self imageFromView:imageView scaledToSize:newSize contentMode:contentMode];
    return newImage;
}

+ (UIImage*)imageWithAtPath:(NSString*)path scaledToSize:(CGSize)newSize autosave:(BOOL)autosave contentMode:(UIViewContentMode)contentMode
{
    NSString *thumbnailName = [[path lastPathComponent] stringByAppendingFormat:@"_%ix%i", (int)ceil(newSize.width), (int)ceil(newSize.height)];
    NSString *thumbnailRetName = [[path lastPathComponent] stringByAppendingFormat:@"_%ix%i@2x", (int)ceil(newSize.width), (int)ceil(newSize.height)];
    NSString *thumbnailPath = [[path stringByDeletingLastPathComponent] stringByAppendingPathComponent:thumbnailName];
    NSString *thumbnailRetPath = [[path stringByDeletingLastPathComponent] stringByAppendingPathComponent:thumbnailRetName];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:thumbnailPath]) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:thumbnailRetPath]) {
            return [self imageWithImage:[UIImage imageWithContentsOfFile:thumbnailPath] retinaImage:[UIImage imageWithContentsOfFile:thumbnailRetPath]];
        }
        return [UIImage imageWithContentsOfResolutionIndependentFile:thumbnailPath];
    }else{
        UIImage *originalImage = [UIImage imageWithContentsOfResolutionIndependentFile:path];
        UIImage *image = [self imageWithImage:originalImage scaledToSize:newSize contentMode:contentMode];
        UIImage *retImage = [self imageWithImage:originalImage scaledToSize:CGSizeMake(newSize.width*2, newSize.height*2) contentMode:contentMode];
        UIImage *outputImage = [UIImage imageWithImage:image retinaImage:retImage];
        if (autosave) {
            NSData *jpegData = UIImageJPEGRepresentation(image, 0.5);
            NSData *jpegRetData = UIImageJPEGRepresentation(retImage, 0.5);
            
            [jpegData writeToFile:thumbnailPath atomically:YES];
            [jpegRetData writeToFile:thumbnailRetPath atomically:YES];
            /*for(int i=0;i<1;i++) {
             [[NSRunLoop currentRunLoop] runUntilDate:[NSDate date]];
             }*/
            
        }
        
        return outputImage;
    }
    return nil;
}

- (id)initWithContentsOfResolutionIndependentFile:(NSString *)path {
    if ( [[[UIDevice currentDevice] systemVersion] intValue] >= 4 && [[UIScreen mainScreen] scale] == 2.0 ) {
        NSString *path2x = [[path stringByDeletingLastPathComponent]
                            stringByAppendingPathComponent:[NSString stringWithFormat:@"%@@2x.%@",
                                                            [[path lastPathComponent] stringByDeletingPathExtension],
                                                            [path pathExtension]]];
        
        if ( [[NSFileManager defaultManager] fileExistsAtPath:path2x] ) {
            return [self initWithCGImage:[[UIImage imageWithData:[NSData dataWithContentsOfFile:path2x]] CGImage] scale:2.0 orientation:UIImageOrientationUp];
        }
    }
    
    return [self initWithData:[NSData dataWithContentsOfFile:path]];
}

+ (UIImage*)imageWithContentsOfResolutionIndependentFile:(NSString *)path {
    return [[UIImage alloc] initWithContentsOfResolutionIndependentFile:path];
}

- (id)initWithImage:(id)image retinaImage:(id)retinaImage {
    if ( [[[UIDevice currentDevice] systemVersion] intValue] >= 4 && [[UIScreen mainScreen] scale] == 2.0 ) {
        
        if (retinaImage) {
            return [self initWithCGImage:[retinaImage CGImage] scale:2.0 orientation:UIImageOrientationUp];
        }
    }
    
    return image;
}

+ (id)imageWithImage:(id)image retinaImage:(id)retinaImage
{
    return [[UIImage alloc] initWithImage:image retinaImage:retinaImage];
}

@end
