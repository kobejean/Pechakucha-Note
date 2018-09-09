//
//  PKNSlide.h
//  Pechakucha Note
//
//  Created by Jean on 5/14/13.
//  Copyright (c) 2013 Pechakucha Note. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PKNSlide : NSObject
{
    UIImage *_image;
    NSString *_script;
}

@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) NSString *script;

- (id)initWithImage:(UIImage*)image script:(NSString*)script;

@end
