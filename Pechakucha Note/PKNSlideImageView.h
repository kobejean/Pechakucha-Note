//
//  PKNSlideImageView.h
//  Pechakucha Note
//
//  Created by Jean on 5/20/13.
//  Copyright (c) 2013 Pechakucha Note. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PKNSlideImageView : UIImageView
{
    int index;
}

@property (nonatomic, readwrite) int index;

@end
