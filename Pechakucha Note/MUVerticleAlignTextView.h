//
//  MUVerticleAlignTextView.h
//  Pechakucha Note
//
//  Created by Jean on 5/10/13.
//  Copyright (c) 2013 Pechakucha Note. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MUInternalVerticleAlignTextView.h"

@class MUVerticleAlignTextView;
@class MUInternalVerticleAlignTextView;

@protocol MUVerticleAlignTextView

@optional
- (BOOL)textViewShouldBeginEditing:(MUVerticleAlignTextView *)textView;
- (BOOL)textViewShouldEndEditing:(MUVerticleAlignTextView *)textView;

- (void)textViewDidBeginEditing:(MUVerticleAlignTextView *)textView;
- (void)textViewDidEndEditing:(MUVerticleAlignTextView *)textView;

- (BOOL)textView:(MUVerticleAlignTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
- (void)textViewDidChange:(MUVerticleAlignTextView *)textView;

- (void)textView:(MUVerticleAlignTextView *)textView willChangeHeight:(float)height;
- (void)textView:(MUVerticleAlignTextView *)textView didChangeHeight:(float)height;

- (void)textViewDidChangeSelection:(MUVerticleAlignTextView *)textView;
- (BOOL)textViewShouldReturn:(MUVerticleAlignTextView *)textView;
@end

@interface MUVerticleAlignTextView : UIView <UITextViewDelegate>
{
    MUInternalVerticleAlignTextView *internalTextView;
    MUInternalVerticleAlignTextView *ghostInternalTextView;
    
    UIEdgeInsets contentInset;
}
//redirect to MUInternalTextView
@property(unsafe_unretained) NSObject<MUVerticleAlignTextView> *delegate;

@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderTextColor;
//
@property (nonatomic, getter = isFixed) BOOL fixed;
@property (nonatomic, assign) BOOL animateHeightChange;
@property (nonatomic, assign) MUVerticleAlign verticleAlign;

@property (nonatomic, retain) MUInternalVerticleAlignTextView *internalTextView;

@property (nonatomic, assign) UIEdgeInsets contentInset;

@end
