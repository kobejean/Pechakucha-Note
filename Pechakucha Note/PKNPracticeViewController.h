//
//  PKNPracticeViewController.h
//  Pechakucha Note
//
//  Created by Jean on 5/9/13.
//  Copyright (c) 2013 Pechakucha Note. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MUTextView.h"
#import "MUVerticleAlignTextView.h"
#import "PKNSessionManager.h"
#import "NSArray+PKArray.h"
#import "PKNSlideImageView.h"
#import "PKNFilter.h"

typedef enum{
    TextViewPositionStateHidden,
    TextViewPositionStateDefault,
    TextViewPositionStateEditing
} TextViewPositionState;

@interface PKNPracticeViewController : UIViewController <PKNSessionManagerDelegate, UIScrollViewDelegate, MUTextViewDelegate>
{
    CGRect keyboardBounds;
    BOOL _playing;
    int _currentSlideIndex;
    int _firstLoadedPageNumber;
    int _lastLoadedPageNumber;
    int secondsLeft;
    
    NSMutableArray *imageViewsArray;
    
    PKNSessionManager *_sessionManager;
    
    IBOutlet MUTextView *textView;
    IBOutlet UIScrollView *pagedScrollView;
    IBOutlet UILabel *countLabel;
    IBOutlet UIButton *togglePlayButton;
    IBOutlet PKNFilter *filter;
    NSTimer *timer;
    
    UIDeviceOrientation orientation;
}

@property (nonatomic, readwrite, getter = isPlaying) BOOL playing;
@property (nonatomic, assign) int currentSlideIndex;
@property (nonatomic, retain) NSMutableDictionary *currentSlide;
@property (nonatomic, retain) PKNSessionManager *sessionManager;

- (id)initWithSessionManager:(PKNSessionManager*)sessionManager;

- (IBAction)togglePlay:(id)sender;

@end
