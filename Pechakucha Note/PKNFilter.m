//
//  PKNFilter.m
//  Pechakucha Note
//
//  Created by Jean on 5/17/13.
//  Copyright (c) 2013 Pechakucha Note. All rights reserved.
//

#import "PKNFilter.h"

@implementation PKNFilter

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

- (void)_initialize
{
    self.image = [UIImage imageNamed:@"photoFilter.png"];
    self.contentMode = UIViewContentModeScaleToFill;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    return NO;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
