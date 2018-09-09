//
//  MUVerticleAlignTextView.m
//  Pechakucha Note
//
//  Created by Jean on 5/10/13.
//  Copyright (c) 2013 Pechakucha Note. All rights reserved.
//

#import "MUInternalVerticleAlignTextView.h"

@interface MUInternalVerticleAlignTextView ()
- (void)_initialize;
- (void)_updateShouldDrawPlaceholder;
- (void)_textChanged:(NSNotification *)notification;
@end

@implementation MUInternalVerticleAlignTextView{
    BOOL _shouldDrawPlaceholder;
}
#pragma mark - Accessors

@synthesize verticleAlign = _verticleAlign;
@synthesize placeholder = _placeholder;
@synthesize placeholderTextColor = _placeholderTextColor;

- (void)setVerticleAlign:(MUVerticleAlign)verticleAlign
{
    if (verticleAlign == _verticleAlign) {
		return;
	}
    
	_verticleAlign = verticleAlign;
	[self _updateShouldDrawPlaceholder];
}

- (void)setText:(NSString *)string {
    
    BOOL originalValue = self.scrollEnabled;
    //If one of GrowingTextView's superviews is a scrollView, and self.scrollEnabled == NO,
    //setting the text programatically will cause UIKit to search upwards until it finds a scrollView with scrollEnabled==yes
    //then scroll it erratically. Setting scrollEnabled temporarily to YES prevents this.
    [self setScrollEnabled:YES];
	[super setText:string];
	[self _updateShouldDrawPlaceholder];
    [self setScrollEnabled:originalValue];
}


- (void)setPlaceholder:(NSString *)string {
	if ([string isEqual:_placeholder]) {
		return;
	}
    
	_placeholder = string;
	[self _updateShouldDrawPlaceholder];
}


#pragma mark - NSObject

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self];
}


#pragma mark - UIView

- (id)initWithCoder:(NSCoder *)aDecoder {
	if ((self = [super initWithCoder:aDecoder])) {
		[self _initialize];
	}
	return self;
}


- (id)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		[self _initialize];
	}
	return self;
}


- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
    
	if (_shouldDrawPlaceholder) {
		[_placeholderTextColor set];
        CGRect placeholderRect = CGRectMake(self.contentInset.left + 8.0f, self.contentInset.top + 0.0f, self.frame.size.width - (self.contentInset.left + self.contentInset.right + 16.0f), self.frame.size.height - (self.contentInset.top + self.contentInset.bottom + 0.0f));
        /*CGSize placeholderSize = [_placeholder sizeWithFont:self.font constrainedToSize:self.frame.size lineBreakMode:UILineBreakModeWordWrap];
        
        switch (self.verticleAlign) {
            case MUVerticleAlignTop:
                placeholderRect.origin.y = placeholderRect.origin.y;
                break;
            case MUVerticleAlignMiddle:
                placeholderRect.origin.y = (placeholderRect.size.height - placeholderSize.height)/2;
                break;
            case MUVerticleAlignBottom:
                placeholderRect.origin.y = placeholderRect.size.height - placeholderSize.height;
                break;
                
            default:
                placeholderRect.origin.y = placeholderRect.origin.y;
                break;
        }*/
        
        //NSLog(@"drawText: %@", NSStringFromCGRect(placeholderRect));
        
        [_placeholder drawInRect:placeholderRect withFont:self.font lineBreakMode:UILineBreakModeWordWrap alignment:self.textAlignment];
		//[_placeholder drawInRect:placeholderRect withFont:self.font];
	}
}

#pragma mark - UITextView

-(void)setContentOffset:(CGPoint)s
{
	if(self.tracking || self.decelerating){
		//initiated by user...
        
        UIEdgeInsets insets = self.contentInset;
        insets.bottom = 0;
        insets.top = 0;
        self.contentInset = insets;
        
	} else {
        
		float bottomOffset = (self.contentSize.height - self.frame.size.height + self.contentInset.bottom);
		if(s.y < bottomOffset && self.scrollEnabled){
            UIEdgeInsets insets = self.contentInset;
            insets.bottom = 8;
            insets.top = 0;
            self.contentInset = insets;
        }
	}
    
	[super setContentOffset:s];
}

- (BOOL)becomeFirstResponder
{
    BOOL output = [super becomeFirstResponder];
    [self _updateShouldDrawPlaceholder];
    return output;
}

- (BOOL)resignFirstResponder
{
    BOOL output = [super resignFirstResponder];
    [self _updateShouldDrawPlaceholder];
    return output;
}

#pragma mark - Private

- (void)_initialize {
	//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_textChanged:) name:UITextViewTextDidChangeNotification object:self];
    self.autoresizesSubviews = NO;
	self.placeholderTextColor = [UIColor colorWithWhite:0.702f alpha:1.0f];
	_shouldDrawPlaceholder = NO;
}


- (void)_updateShouldDrawPlaceholder {
	BOOL prev = _shouldDrawPlaceholder;
	_shouldDrawPlaceholder = self.placeholder && self.placeholderTextColor && ![self isFirstResponder] && self.text.length == 0;
	if (prev != _shouldDrawPlaceholder) {
		[self setNeedsDisplay];
	}
}


- (void)_textChanged:(NSNotification *)notification {
	[self _updateShouldDrawPlaceholder];
}

@end
