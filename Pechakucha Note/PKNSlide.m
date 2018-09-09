//
//  PKNSlide.m
//  Pechakucha Note
//
//  Created by Jean on 5/14/13.
//  Copyright (c) 2013 Pechakucha Note. All rights reserved.
//

#import "PKNSlide.h"

@implementation PKNSlide

@synthesize image = _image, script = _script;

- (id)initWithImage:(UIImage*)image script:(NSString*)script
{
    self = [self init];
    if (self) {
        self.image = image;
        self.script = script;
    }
    return self;
}

@end
