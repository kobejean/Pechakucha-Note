//
//  MUVerticleAlignTextView.m
//  Pechakucha Note
//
//  Created by Jean on 5/10/13.
//  Copyright (c) 2013 Pechakucha Note. All rights reserved.
//

#import "MUVerticleAlignTextView.h"

@interface MUVerticleAlignTextView ()
- (void)_initialize;
- (CGRect)_frameForInternalTextView;
- (float)_textHeightForNumberOfLines:(int)numberOfLines;
- (void)_layoutInternalTextViewIfNeeded;
@end

@implementation MUVerticleAlignTextView

#pragma mark - Accessors

@synthesize delegate;

@synthesize placeholder = _placeholder;
@synthesize placeholderTextColor = _placeholderTextColor;

@synthesize animateHeightChange;
@synthesize verticleAlign = _verticleAlign;

@synthesize internalTextView;

@synthesize contentInset;

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    self.internalTextView.placeholder = placeholder;
}

- (void)setPlaceholderTextColor:(UIColor *)placeholderTextColor
{
    _placeholderTextColor = placeholderTextColor;
    self.internalTextView.placeholderTextColor = placeholderTextColor;
}

- (void)setVerticleAlign:(MUVerticleAlign)verticleAlign
{
    _verticleAlign = verticleAlign;
    self.internalTextView.verticleAlign = verticleAlign;
    [self _layoutInternalTextViewIfNeeded];
}

- (void)setContentInset:(UIEdgeInsets)inset
{
    contentInset = inset;
    self.internalTextView.contentInset = inset;
}

#pragma mark - UIView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self _initialize];
    }
    return self;
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

- (void)layoutSubviews
{
    [super layoutSubviews];
    ghostInternalTextView.frame = self.frame;
    [self _layoutInternalTextViewIfNeeded];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - Private

- (void)_initialize
{
    ghostInternalTextView = [[MUInternalVerticleAlignTextView alloc] initWithFrame:self.frame];
    ghostInternalTextView.hidden = YES;
    [self addSubview:ghostInternalTextView];
    
    CGRect frame = self.frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    self.internalTextView = [[MUInternalVerticleAlignTextView alloc] initWithFrame:frame];
    self.internalTextView.delegate = self;
    self.internalTextView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    self.internalTextView.textColor = [UIColor whiteColor];
    self.internalTextView.font = [UIFont fontWithName:@"Helvetica" size:14.0f];
    [self addSubview:self.internalTextView];
    self.verticleAlign = MUVerticleAlignBottom;
    self.internalTextView.textAlignment = NSTextAlignmentCenter;
    self.fixed = NO;
    self.animateHeightChange = YES;
    //self.internalTextView.scrollEnabled = YES;
    self.autoresizesSubviews = NO;
    
    UIEdgeInsets insets = self.contentInset;
    insets.bottom = 8.0f;
    insets.top = 8.0f;
    self.contentInset = insets;
    self.placeholder = @"Placeholder";
}

- (CGRect)_frameForInternalTextView
{
    CGRect frame = CGRectZero;
    
    switch (self.verticleAlign) {
        case MUVerticleAlignTop:
        {
            float height = 0.0f;
            if (self.isFixed) {
                height = self.frame.size.height;
            }else{
                float internalMaxHeight = self.frame.size.height;
                float internalMinHeight = [self _textHeightForNumberOfLines:1];
                
                height = self.internalTextView.contentSize.height + (contentInset.top + contentInset.bottom);
                
                //height cant be > maxHeight nor < minHeight
                if (height < internalMinHeight) {
                    height = internalMinHeight;
                }else if (height > internalMaxHeight) {
                    height = internalMaxHeight;
                }
            }
            frame.origin.y = 0;
            frame.origin.x = 0;
            frame.size.width = self.frame.size.width;
            frame.size.height = height;
        }
            break;
        case MUVerticleAlignMiddle:
        {
            float height = 0.0f;
            float y = 0.0f;
            
            //fixed not supported
            /*if (self.isFixed) {
                height = self.frame.size.height;
            }else*/{
                
                float internalMaxHeight = self.frame.size.height;
                float internalMinHeight = [self _textHeightForNumberOfLines:1];
                float internalMaxY = (self.frame.size.height - internalMinHeight)/2;
                float internalMinY = 0;
                
                height = self.internalTextView.contentSize.height + (contentInset.top + contentInset.bottom);
                
                //height cant be > maxHeight nor < minHeight
                if (height < internalMinHeight) {
                    height = internalMinHeight;
                }else if (height > internalMaxHeight) {
                    height = internalMaxHeight;
                }
                
                y = (self.frame.size.height - height)/2;
                
                //y cant be > maxY nor < minY
                if (y < internalMinY) {
                    y = internalMinY;
                }else if (y > internalMaxY) {
                    y = internalMaxY;
                }
            }
            frame.origin.y = y;
            frame.origin.x = 0;
            frame.size.width = self.frame.size.width;
            frame.size.height = height;
        }
            break;
        case MUVerticleAlignBottom:
        {
            float height = 0.0f;
            float y = 0.0f;
            //fixed not supported
            /*if (self.isFixed) {
                height = self.frame.size.height;
            }else*/{
                
                float internalMaxHeight = self.frame.size.height;
                float internalMinHeight = [self _textHeightForNumberOfLines:1];
                float internalMaxY = self.frame.size.height - internalMinHeight;
                float internalMinY = 0;
                
                height = self.internalTextView.contentSize.height + (contentInset.top + contentInset.bottom);
                
                //height cant be > maxHeight nor < minHeight
                if (height < internalMinHeight) {
                    height = internalMinHeight;
                }else if (height > internalMaxHeight) {
                    height = internalMaxHeight;
                }
                
                y = self.frame.size.height - height;
                
                //y cant be > maxY nor < minY
                if (y < internalMinY) {
                    y = internalMinY;
                }else if (y > internalMaxY) {
                    y = internalMaxY;
                }
            }
            frame.origin.y = y;
            frame.origin.x = 0;
            frame.size.width = self.frame.size.width;
            frame.size.height = height;
        }
            break;
            
        default:
            break;
    }
    
    //NSLog(@"frameForInternalTextView: %@", NSStringFromCGRect(frame));
    
    return frame;
}

- (float)_textHeightForNumberOfLines:(int)numberOfLines
{
    float textHeight;
    NSString *newText = @"-";
    
    if (![self.internalTextView.font isEqual:ghostInternalTextView.font]) {
        ghostInternalTextView.font = self.internalTextView.font ;
    }
    if (!UIEdgeInsetsEqualToEdgeInsets(self.internalTextView.contentInset, ghostInternalTextView.contentInset)) {
        ghostInternalTextView.contentInset =  self.internalTextView.contentInset;
    }
    
    for (int i = 1; i < numberOfLines; ++i)
        newText = [newText stringByAppendingString:@"\n|W|"];
    
    ghostInternalTextView.text = newText;
    
    textHeight = ghostInternalTextView.contentSize.height;
    
    return textHeight;
}

- (void)_layoutInternalTextViewIfNeeded
{
    CGRect calculatedInternalTextViewFrame = [self _frameForInternalTextView];
    if (!CGRectEqualToRect(self.internalTextView.frame, calculatedInternalTextViewFrame)) {
        
        //animate if animateHeightChange = YES
        if(animateHeightChange) {
            
            if ([UIView resolveClassMethod:@selector(animateWithDuration:animations:)]) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
                if ([delegate respondsToSelector:@selector(textView:willChangeHeight:)]) {
                    [delegate textView:self willChangeHeight:calculatedInternalTextViewFrame.size.height];
                }
                [UIView animateWithDuration:0.1f
                                      delay:0
                                    options:(UIViewAnimationOptionAllowUserInteraction|
                                             UIViewAnimationOptionBeginFromCurrentState)
                                 animations:^(void) {
                                     self.internalTextView.frame = calculatedInternalTextViewFrame;
                                 }
                                 completion:^(BOOL finished) {
                                     if ([delegate respondsToSelector:@selector(textView:didChangeHeight:)]) {
                                      [delegate textView:self didChangeHeight:calculatedInternalTextViewFrame.size.height];
                                      }
                                 }];
#endif
            } else {
                [UIView beginAnimations:@"" context:nil];
                [UIView setAnimationDuration:0.1f];
                [UIView setAnimationDelegate:self];
                [UIView setAnimationDidStopSelector:@selector(growDidStop)];
                [UIView setAnimationBeginsFromCurrentState:YES];
                self.internalTextView.frame = calculatedInternalTextViewFrame;
                [UIView commitAnimations];
                
            }
        }else{
            if ([delegate respondsToSelector:@selector(textView:willChangeHeight:)]) {
                [delegate textView:self willChangeHeight:calculatedInternalTextViewFrame.size.height];
            }
            self.internalTextView.frame = calculatedInternalTextViewFrame;
            if ([delegate respondsToSelector:@selector(textView:didChangeHeight:)]) {
                [delegate textView:self didChangeHeight:calculatedInternalTextViewFrame.size.height];
            }
        }
        
        //NSLog(@"internalTextViewFrame: %@", NSStringFromCGRect(self.internalTextView.frame));
    }
}

#pragma mark - UITextView

- (BOOL)hasText
{
    return [self.internalTextView hasText];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    [self _layoutInternalTextViewIfNeeded];
    if ([delegate respondsToSelector:@selector(textViewDidChange:)]) {
		[delegate textViewDidChange:self];
        //NSLog(@"change:%@", textView.text);
	}
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //weird 1 pixel bug when clicking backspace when textView is empty
	if(![textView hasText] && [text isEqualToString:@""]) return NO;
	
    
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

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([delegate respondsToSelector:@selector(textViewDidBeginEditing:)]) {
		[delegate textViewDidBeginEditing:self];
	}
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
    if ([delegate respondsToSelector:@selector(textViewDidChangeSelection:)]) {
		[delegate textViewDidChangeSelection:self];
	}
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([delegate respondsToSelector:@selector(textViewDidEndEditing:)]) {
		[delegate textViewDidEndEditing:self];
	}
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([delegate respondsToSelector:@selector(textViewShouldBeginEditing:)]) {
		return [delegate textViewShouldBeginEditing:self];
		
	} else {
		return YES;
	}
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if ([delegate respondsToSelector:@selector(textViewShouldEndEditing:)]) {
		return [delegate textViewShouldEndEditing:self];
		
	} else {
		return YES;
	}
}

@end
