//
//  MUVerticleAlignTextView.h
//  Pechakucha Note
//
//  Created by Jean on 5/10/13.
//  Copyright (c) 2013 Pechakucha Note. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    MUVerticleAlignTop,
    MUVerticleAlignMiddle,
    MUVerticleAlignBottom
} MUVerticleAlign;

@interface MUInternalVerticleAlignTextView : UITextView

@property (nonatomic, assign) MUVerticleAlign verticleAlign;
@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) UIColor *placeholderTextColor;

@end
