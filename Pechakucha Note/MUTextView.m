//
//  MUTextView.m
//  Pechakucha Note
//
//  Created by Jean on 5/10/13.
//  Copyright (c) 2013 Pechakucha Note. All rights reserved.
//

#import "MUTextView.h"

#define noDisableVerticalScrollTag 836913
#define noDisableHorizontalScrollTag 836914

@implementation UIImageView (ForScrollView)

- (void) setAlpha:(float)alpha {
    
    if (self.superview.tag == noDisableVerticalScrollTag) {
        if (alpha == 0 && self.autoresizingMask == UIViewAutoresizingFlexibleLeftMargin) {
            if (self.frame.size.width < 10 && self.frame.size.height > self.frame.size.width) {
                UIScrollView *sc = (UIScrollView*)self.superview;
                if (sc.frame.size.height < sc.contentSize.height) {
                    return;
                }
            }
        }
    }
    
    if (self.superview.tag == noDisableHorizontalScrollTag) {
        if (alpha == 0 && self.autoresizingMask == UIViewAutoresizingFlexibleTopMargin) {
            if (self.frame.size.height < 10 && self.frame.size.height < self.frame.size.width) {
                UIScrollView *sc = (UIScrollView*)self.superview;
                if (sc.frame.size.width < sc.contentSize.width) {
                    return;
                }
            }
        }
    }
    
    [super setAlpha:alpha];
}
@end

@implementation MUTextView

@synthesize scrollView, internalTextView, minHeight = _minHeight, delegate, text = _text;

-(void)setMinHeight:(float)minHeight
{
    float difference = _minHeight - minHeight;
    _minHeight = minHeight;
    if (minHeight == self.frame.size.height) {
        self.scrollView.scrollEnabled = NO;
        self.internalTextView.scrollEnabled = YES;
    }else{
        self.scrollView.scrollEnabled = YES;
        self.internalTextView.scrollEnabled = NO;
    }
    [self.scrollView setContentOffset:CGPointMake(0, self.scrollView.contentOffset.y + difference) animated:NO];
    [self _layoutVerticleAlignTextViewIfNeededAnimated:NO];
}

- (void)setText:(NSString *)text
{
    self.internalTextView.text = text;
    [self.scrollView setContentOffset:CGPointMake(0, self.frame.size.height - self.minHeight) animated:NO];
    [self layoutSubviews];
    //[self _layoutVerticleAlignTextViewIfNeededAnimated:NO];
    _text = text;
}

- (NSString *)text
{
    return self.internalTextView.text;
}

- (void)setPlaceholder:(NSString *)placeholder
{
    self.internalTextView.placeholder = placeholder;
    [self setText:self.text];
}

- (NSString *)placeholder
{
    return self.internalTextView.placeholder;
}

- (void)setPlaceholderTextColor:(UIColor *)placeholderTextColor
{
    self.internalTextView.placeholderTextColor = placeholderTextColor;
}

- (UIColor *)placeholderTextColor
{
    return self.internalTextView.placeholderTextColor;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self _initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self _initialize];
    }
    return self;
}

- (void)_initialize
{
    CGRect frame = self.frame;
    frame.origin = CGPointZero;
    self.scrollView = [[UIScrollView alloc] initWithFrame:frame];
    self.scrollView.delegate = self;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.scrollView];
    verticleAlignTextView = [[MUVerticleAlignTextView alloc] initWithFrame:[self _frameForVerticleAlignTextView]];
    verticleAlignTextView.delegate = self;
    self.internalTextView = verticleAlignTextView.internalTextView;
    self.minHeight = 80.0f;
    [self.scrollView addSubview:verticleAlignTextView];
    self.backgroundColor = [UIColor clearColor];
    self.internalTextView.scrollEnabled = NO;
    verticleAlignTextView.animateHeightChange = NO;
    self.scrollView.scrollEnabled = YES;
    self.internalTextView.tag = noDisableVerticalScrollTag;
    [self setIndicatorStyle:UIScrollViewIndicatorStyleWhite];
    //self.backgroundColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.4];
    //self.internalTextView.backgroundColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:0.4];
    //verticleAlignTextView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:0.4];
}

#pragma mark - UIView

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect frame = self.frame;
    frame.origin = CGPointZero;
    if (!CGRectEqualToRect(self.scrollView.frame, frame)) {
        self.scrollView.frame = frame;
    }
    [self _layoutVerticleAlignTextViewIfNeededAnimated:NO];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect insideFrame = self.internalTextView.frame;
    //insideFrame.origin.y = insideFrame.origin.y - scrollView.contentOffset.y;
    //NSLog(@"%@, %@", NSStringFromCGRect(insideFrame), NSStringFromCGPoint(point));
    insideFrame = [verticleAlignTextView convertRect:insideFrame toView:self];
    if (CGRectContainsPoint(insideFrame, point)) {
        return YES;
    }else{
        [self layoutSubviews];
        //check again after layout
        if (CGRectContainsPoint(insideFrame, point)) {
            return YES;
        }
        return NO;
    }
    //return [super pointInside:point withEvent:event];
}

#pragma mark - UITextView



#pragma mark - UIScrollView

- (void)setIndicatorStyle:(UIScrollViewIndicatorStyle)style
{
    self.internalTextView.indicatorStyle = style;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self _layoutVerticleAlignTextViewIfNeededAnimated:NO];
    [self.scrollView.layer removeAllAnimations];
    [self.internalTextView flashScrollIndicators];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.internalTextView.scrollEnabled = YES;
    //self.internalTextView.userInteractionEnabled = NO;
    [self setVerticleScrollIndicatorHidden:NO];
    //NSLog(@"scrollViewWillBeginDragging");
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.internalTextView.scrollEnabled = NO;
    //self.internalTextView.userInteractionEnabled = YES;
    [self setVerticleScrollIndicatorHidden:YES];

    //NSLog(@"scrollViewDidEndDecelerating");
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        self.internalTextView.scrollEnabled = NO;
        //self.internalTextView.userInteractionEnabled = YES;
        [self setVerticleScrollIndicatorHidden:YES];
    }
}

#pragma mark - MUVerticleAlignTextView

- (void)textView:(MUVerticleAlignTextView *)textView didChangeHeight:(float)height
{
    [self _layoutVerticleAlignTextViewIfNeededAnimated:NO];
}

#pragma mark - Private

- (void)_layoutVerticleAlignTextViewIfNeededAnimated:(BOOL)animated
{
    BOOL originalAnimateHeightChange = verticleAlignTextView.animateHeightChange;
    verticleAlignTextView.animateHeightChange = NO;
    verticleAlignTextView.frame = [self _frameForVerticleAlignTextView];
    
    
    float offsetY = self.scrollView.frame.size.height - self.minHeight;
    
    if (self.scrollView.contentSize.height - offsetY != self.internalTextView.contentSize.height) {
        CGSize size = self.scrollView.contentSize;
        size.height = self.internalTextView.contentSize.height + offsetY;
        
        self.scrollView.contentSize = size;
    }
    if (self.scrollView.contentOffset.y) {
        CGPoint offset = CGPointZero;
        offset.y = (self.scrollView.contentOffset.y > offsetY)? self.scrollView.contentOffset.y - offsetY : 0;
        self.internalTextView.contentOffset = offset;
        //[self.internalTextView flashScrollIndicators];
    }
    verticleAlignTextView.animateHeightChange = originalAnimateHeightChange;
}

- (CGRect)_frameForVerticleAlignTextView
{
    float additionalOffsetY = self.scrollView.frame.size.height - self.minHeight;
    
    CGRect frame = verticleAlignTextView.frame;
    frame.origin.y = (self.scrollView.contentOffset.y > additionalOffsetY)? self.scrollView.contentOffset.y : additionalOffsetY;
    //frame.origin.y -= self.internalTextView.frame.origin.y;
    frame.origin.x = 0.0f;
    frame.size.width = self.frame.size.width;
    frame.size.height = (self.scrollView.contentOffset.y > additionalOffsetY)? self.frame.size.height : self.frame.size.height - (additionalOffsetY - self.scrollView.contentOffset.y);
    //NSLog(@"frame: %@", NSStringFromCGRect(frame));
    return frame;
}

- (void)setVerticleScrollIndicatorHidden:(BOOL)hidden
{
    if (hidden) {
        [self.internalTextView flashScrollIndicators];
        [UIView transitionWithView:self.scrollView duration:0.2f options:(UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionAllowUserInteraction) animations:^(void){
            self.internalTextView.showsVerticalScrollIndicator = NO;
        } completion:nil];
    }else{
        self.internalTextView.showsVerticalScrollIndicator = YES;
    }
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(MUVerticleAlignTextView *)textView
{
    [self layoutIfNeeded];
    if ([delegate respondsToSelector:@selector(textViewDidChange:)]) {
		[delegate textViewDidChange:self];
        //NSLog(@"change:%@", textView.internalTextView);
	}
}

- (BOOL)textView:(MUVerticleAlignTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //weird 1 pixel bug when clicking backspace when textView is empty
	if(![textView.internalTextView hasText] && [text isEqualToString:@""]) return NO;
	
    
    if ([delegate respondsToSelector:@selector(shouldChangeTextInRange:replacementText:)]) {
		return [delegate textView:self shouldChangeTextInRange:range replacementText:text];
	}
    
	if ([text isEqualToString:@"\n"]) {
		if ([delegate respondsToSelector:@selector(textViewShouldReturn:)]) {
			if (![delegate performSelector:@selector(textViewShouldReturn:) withObject:self]) {
				return YES;
			} else {
				[textView resignFirstResponder];
				return NO;
			}
		}
	}
	
	return YES;
}

- (void)textViewDidBeginEditing:(MUVerticleAlignTextView *)textView
{
    if ([delegate respondsToSelector:@selector(textViewDidBeginEditing:)]) {
		[delegate textViewDidBeginEditing:self];
	}
}

- (void)textViewDidChangeSelection:(MUVerticleAlignTextView *)textView
{
    if ([delegate respondsToSelector:@selector(textViewDidChangeSelection:)]) {
		[delegate textViewDidChangeSelection:self];
	}
}

- (void)textViewDidEndEditing:(MUVerticleAlignTextView *)textView
{
    if ([delegate respondsToSelector:@selector(textViewDidEndEditing:)]) {
		[delegate textViewDidEndEditing:self];
	}
}

- (BOOL)textViewShouldBeginEditing:(MUVerticleAlignTextView *)textView
{
    if ([delegate respondsToSelector:@selector(textViewShouldBeginEditing:)]) {
		return [delegate textViewShouldBeginEditing:self];
		
	} else {
		return YES;
	}
}

- (BOOL)textViewShouldEndEditing:(MUVerticleAlignTextView *)textView
{
    if ([delegate respondsToSelector:@selector(textViewShouldEndEditing:)]) {
		return [delegate textViewShouldEndEditing:self];
		
	} else {
		return YES;
	}
}

@end
