//
//  MUTextView.h
//  Pechakucha Note
//
//  Created by Jean on 5/10/13.
//  Copyright (c) 2013 Pechakucha Note. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "MUVerticleAlignTextView.h"

@class MUTextView;

@protocol MUTextViewDelegate

@optional
- (BOOL)textViewShouldBeginEditing:(MUTextView *)textView;
- (BOOL)textViewShouldEndEditing:(MUTextView *)textView;

- (void)textViewDidBeginEditing:(MUTextView *)textView;
- (void)textViewDidEndEditing:(MUTextView *)textView;

- (BOOL)textView:(MUTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
- (void)textViewDidChange:(MUTextView *)textView;

- (void)textView:(MUTextView *)textView willChangeHeight:(float)height;
- (void)textView:(MUTextView *)textView didChangeHeight:(float)height;

- (void)textViewDidChangeSelection:(MUTextView *)textView;
- (BOOL)textViewShouldReturn:(MUTextView *)textView;
@end

@interface MUTextView : UIView <UIScrollViewDelegate, MUVerticleAlignTextView>
{
    UIScrollView *scrollView;
    MUInternalVerticleAlignTextView *internalTextView;
    MUVerticleAlignTextView *verticleAlignTextView;
    float _minHeight;
    NSString *_text;
}

@property(unsafe_unretained) NSObject<MUTextViewDelegate> *delegate;

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) MUInternalVerticleAlignTextView *internalTextView;

@property (nonatomic, assign) float minHeight;

//UIScrollView
- (void)setIndicatorStyle:(UIScrollViewIndicatorStyle)style;

//UITextView
@property (nonatomic, retain) NSString *text;

//UIInternalVerticalAlignTextView
@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) UIColor *placeholderTextColor;

@end
