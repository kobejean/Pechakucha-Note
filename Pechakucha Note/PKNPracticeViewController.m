//
//  PKNPracticeViewController.m
//  Pechakucha Note
//
//  Created by Jean on 5/9/13.
//  Copyright (c) 2013 Pechakucha Note. All rights reserved.
//

#import "PKNPracticeViewController.h"

static NSString *placeholder = @"Tap here to edit";

@interface PKNPracticeViewController ()

@end

const int initialCounterLength = 20;

@implementation PKNPracticeViewController

#pragma mark - Accessors

@synthesize currentSlideIndex = _currentSlideIndex;
@synthesize currentSlide;
@synthesize sessionManager = _sessionManager;

- (void)setSessionManager:(PKNSessionManager *)sessionManager
{
    _sessionManager = sessionManager;
    self.sessionManager.delegate = self;
    if (self.isViewLoaded) {
        [self layoutSlideImagesInBackground];
    }
}

- (void)setPlaying:(BOOL)playing
{
    [UIApplication sharedApplication].idleTimerDisabled = playing;
    pagedScrollView.userInteractionEnabled = !playing;
    textView.internalTextView.editable = !playing;
    [self.navigationController setNavigationBarHidden:playing animated:YES];
    [countLabel setHidden:!playing];
    if (playing && !_playing) {
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerTicked) userInfo:nil repeats:YES];
        [togglePlayButton setBackgroundImage:[UIImage imageNamed:@"pauseButton.png"] forState:UIControlStateNormal];
        [textView setPlaceholder:@""];
    }else{
        [timer invalidate];
        [togglePlayButton setBackgroundImage:[UIImage imageNamed:@"playButton.png"] forState:UIControlStateNormal];
        secondsLeft = initialCounterLength;
        [self updateCountLabel];
        [textView setPlaceholder:placeholder];
    }
    _playing = playing;
}

- (void)timerTicked
{
    if (secondsLeft==0) {
        secondsLeft = initialCounterLength;
    }
    if (secondsLeft==1) {
        secondsLeft = initialCounterLength;
        if (self.currentSlideIndex==self.sessionManager.slides.count-1) {
            [self setPlaying:NO];
            [self showSlide:0 animated:NO];
        }else{
            [self showSlide:self.currentSlideIndex + 1 animated:YES];
        }
    }else{
        secondsLeft--;
    }
    [self updateCountLabel];
}

- (void)updateCountLabel
{
    if (secondsLeft==0) {
        secondsLeft = initialCounterLength;
    }
    countLabel.text = [NSString stringWithFormat:@"%i / %i", secondsLeft, 20 - self.currentSlideIndex];
    self.title = [NSString stringWithFormat:@"Slide #%i", self.currentSlideIndex+1];
}

- (IBAction)togglePlay:(id)sender {
    [self setPlaying:!self.playing];
}

#pragma mark - init

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self commonInitializer];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
        [self commonInitializer];
    }
    return self;
}

- (id)initWithSessionManager:(PKNSessionManager*)sessionManager
{
    self = [self initWithNibName:@"PKNPracticeView" bundle:nil];
    if (self) {
        self.sessionManager = sessionManager;
        [self commonInitializer];
    }
    return self;
}


- (void)refreshSlideImages
{
    if (self.isViewLoaded) {
        for (UIView *subview in pagedScrollView.subviews) {
            [subview removeFromSuperview];
        }
        [imageViewsArray removeAllObjects];
        [self layoutSlideImagesInBackground];
        //[self layoutSlideImages];
    }
}

- (void)layoutSlideImagesInBackground
{
    /*@autoreleasepool {
        [self performSelectorInBackground:@selector(layoutSlideImages) withObject:nil];
    }*/
    [self layoutSlideImages];
}

- (void)layoutSlideImages
{
    if (self.isViewLoaded) {
        BOOL initiallyEmpty = (pagedScrollView.subviews.count == 0);
        int numberOfPrecedingLoadedSlides = (self.currentSlideIndex >= 0+1)? 1 : 0 ;
        int numberOfSucceedingLoadedSlides = (self.currentSlideIndex < self.sessionManager.slides.count-1)? 1 : 0 ;
        int startIndex = self.currentSlideIndex - numberOfPrecedingLoadedSlides;
        int endIndex = self.currentSlideIndex + numberOfSucceedingLoadedSlides;
        
        
        //NSLog(@"startIndex: %i currentSlideIndex: %i endIndex: %i _firstLoadedPageNumber: %i _lastLoadedPageNumber: %i", startIndex, self.currentSlideIndex, endIndex, _firstLoadedPageNumber, _lastLoadedPageNumber);
        
        
        //imagesToRemove
        for (int i = 0; i <= _lastLoadedPageNumber - _firstLoadedPageNumber; i++) {
            int index = _firstLoadedPageNumber + i;
            if ((index < startIndex || index > endIndex) && i < pagedScrollView.subviews.count) {
                /*for (UIView *subview in pagedScrollView.subviews) {
                 if ([self indexForImageViewFrame:subview.frame] == index) {
                 [subview removeFromSuperview];
                 }
                 }*/
                int nilIndex = [imageViewsArray indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                    PKNSlideImageView *slideImageView = obj;
                    NSLog(@"nilIndex %i == %i?", slideImageView.index, index);
                    if (slideImageView.index == index) {
                        return YES;
                    }
                    return NO;
                }];
                
                if (nilIndex != NSNotFound) {
                    PKNSlideImageView *slideImageView = [imageViewsArray objectAtIndex:nilIndex] ;
                    //[slideImageView removeFromSuperview];
                    [slideImageView setIndex:-1];
                    [slideImageView setImage:nil];
                }
                //[currentlyLoadedImages removeObject:subview];
                //NSLog(@"lastTime: %i -", index);
            }else{
                // NSLog(@"lastTime: %i", index);
            }
        }
        
        //imagesToAdd
        for (int i = 0; i < endIndex - startIndex + 1; i++) {
            int index = startIndex + i;
            if (index < _firstLoadedPageNumber || index > _lastLoadedPageNumber || initiallyEmpty) {
                
                int blankSlideIndex = [imageViewsArray indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                    int nilIndex = -1;
                    PKNSlideImageView *slideImageView = obj;
                    NSLog(@"blankSlideIndex %i == %i?", slideImageView.index, nilIndex);
                    if (slideImageView.index == nilIndex) {
                        return YES;
                    }
                    return NO;
                }];
                
                int arrayIndex = (imageViewsArray.count == 0)? 0 : [imageViewsArray indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                    PKNSlideImageView *slideImageView = obj;
                    NSLog(@"arrayIndex %i == %i?", slideImageView.index, index);
                    if (slideImageView.index == index) {
                        return YES;
                    }
                    return NO;
                }];
                
                if (blankSlideIndex == NSNotFound || arrayIndex!= NSNotFound) {
                    if (imageViewsArray.count < endIndex - startIndex + 1) {
                        //NSMutableDictionary *slide = [self.sessionManager.slides objectAtIndex:index];
                        PKNSlideImageView *imageView = [[PKNSlideImageView alloc] initWithImage:[self.sessionManager imageForIndex:index]];
                        [imageView setIndex:index];
                        [imageView setFrame:[self imageViewFrameForIndex:index]];
                        imageView.contentMode = UIViewContentModeScaleAspectFit;
                        imageView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.0];
                        [pagedScrollView addSubview:imageView];
                        
                        [imageViewsArray addObject:imageView];
                        NSLog(@"add:%i", imageView.index);
                    }
                }else{
                    int changeIndex = (arrayIndex == NSNotFound)? blankSlideIndex : arrayIndex;
                    //NSMutableDictionary *slide = [self.sessionManager.slides objectAtIndex:index];
                    PKNSlideImageView *imageView = [imageViewsArray objectAtIndex:changeIndex];
                    NSLog(@"set:%i to:%i", imageView.index, index);
                    
                    [imageView setImage:[self.sessionManager imageForIndex:index]];
                    [imageView setIndex:index];
                    [imageView setFrame:[self imageViewFrameForIndex:index]];
                    
                }
                //[currentlyLoadedImages addObject:imageView];
                //NSLog(@"now: %i +", index);
            }else{
                //NSLog(@"now: %i", index);
            }
        }
        NSLog(@"loadedImageViews: %@", imageViewsArray);
        NSLog(@"loadedSubViews: %@", pagedScrollView.subviews);
        
        _firstLoadedPageNumber = startIndex;
        _lastLoadedPageNumber = endIndex;
        
        pagedScrollView.contentSize = CGSizeMake(self.sessionManager.slides.count*pagedScrollView.frame.size.width, pagedScrollView.frame.size.height);
    }
}


- (CGRect)imageViewFrameForIndex:(int)index
{
    CGRect frame = pagedScrollView.frame;
    frame.origin.x = index*pagedScrollView.frame.size.width;
    //NSLog(@"%i, %f", index, frame.origin.x);
    frame.origin.y = 0.0f;
    frame.size.width = pagedScrollView.frame.size.width;
    frame.size.height = pagedScrollView.frame.size.height;
    //NSLog(@"frame: %@", NSStringFromCGRect(frame));
    return frame;
}

- (int)indexForImageViewFrame:(CGRect)frame
{
    return (int)(frame.origin.x/pagedScrollView.frame.size.width);
}

- (void)viewDidLayoutSubviews
{
        [self refreshSlideImages];
    if (orientation != [UIDevice currentDevice].orientation) {
        [self orientationWillChange];
        orientation = [UIDevice currentDevice].orientation;
    }
}

- (void)orientationWillChange
{
    [self showSlide:_currentSlideIndex animated:NO];
    //NSLog(@"ori");
    if (UIDeviceOrientationIsLandscape(orientation)) {
        
    }
}

- (void)commonInitializer
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification 
                                               object:nil];
    imageViewsArray = [[NSMutableArray alloc] initWithCapacity:3];
    self.currentSlide = [[NSMutableDictionary alloc] initWithCapacity:2];
    [textView setPlaceholder:placeholder];
}

- (void)updateCurrentSlideIndexIfNeeded
{
    if (self.currentSlideIndex != (roundf(pagedScrollView.contentOffset.x / pagedScrollView.frame.size.width)) && (roundf(pagedScrollView.contentOffset.x / pagedScrollView.frame.size.width)) >= 0 && (roundf(pagedScrollView.contentOffset.x / pagedScrollView.frame.size.width)) < self.sessionManager.slides.count) {
        self.currentSlideIndex = (roundf(pagedScrollView.contentOffset.x / pagedScrollView.frame.size.width));
        NSLog(@"%i", self.currentSlideIndex);
    }
}

- (void)setCurrentSlideIndex:(int)currentSlideIndex
{
    [self currentSlideWillChange];
    _currentSlideIndex = currentSlideIndex;
    [self currentSlideDidChange];
}

- (NSMutableDictionary *)currentSlide
{
    return [self.sessionManager.slides objectAtIndex:self.currentSlideIndex];
}

- (void)currentSlideWillChange
{
    //[self saveCurrentSlide];
}

- (void)currentSlideDidChange
{
    [textView setText:[self.currentSlide objectForKey:@"script"]];
    //[self layoutSlideImages];
    [self updateCountLabel];
    [self layoutSlideImagesInBackground];
}

- (void)showSlide:(int)index animated:(BOOL)animated
{
    if (animated) {
        /*[UIView transitionWithView:self.view duration:1.0f options:(UIViewAnimationOptionTransitionCrossDissolve |  UIViewAnimationOptionLayoutSubviews) animations:^(void){
            [pagedScrollView setContentOffset:CGPointMake([self imageViewFrameForIndex:index].origin.x, 0)];
            [self setCurrentSlideIndex:index];
            //[pagedScrollView scrollRectToVisible:[self imageViewFrameForIndex:index] animated:NO];
        } completion:nil];*/
        [pagedScrollView scrollRectToVisible:[self imageViewFrameForIndex:index] animated:YES];
    }else{
        [pagedScrollView scrollRectToVisible:[self imageViewFrameForIndex:index] animated:NO];
    }
    NSLog(@"showSlide:%i animated:%d", index, animated);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self updateCurrentSlideIndexIfNeeded];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self updateCurrentSlideIndexIfNeeded];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self updateCurrentSlideIndexIfNeeded];
    }
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(MUTextView *)atextView
{
    [self.currentSlide setObject:atextView.text forKey:@"script"];
    //[self.currentSlide setValue:atextView.text forKey:@"script"];
    [self saveCurrentSlide];
}

- (void)saveCurrentSlide
{
    if (self.currentSlide != nil) {
        [self.sessionManager.slides setObject:self.currentSlide atIndexedSubscript:self.currentSlideIndex];
    }
}

#pragma mark - UIView

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    pagedScrollView.delegate = self;
    textView.delegate = self;
    textView.internalTextView.placeholder = @"Tap here to edit";
    self.currentSlide = [self.sessionManager.slides objectAtIndex:0];
    self.currentSlideIndex = 0;
    //[self updateCurrentSlideIndexIfNeeded];
    [self layoutSlideImagesInBackground];
    //[self layoutSlideImages];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (animated) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.2f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        
        [self.navigationController.navigationBar setTintColor:[UIColor colorWithWhite:0.2f alpha:1.0f]];
        
        [UIView commitAnimations];
    }else{
        [self.navigationController.navigationBar setTintColor:[UIColor colorWithWhite:0.2f alpha:1.0f]];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (animated) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.2f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        
        [self.navigationController.navigationBar setTintColor:[UIColor redColor]];
        
        [UIView commitAnimations];
    }else{
        [self.navigationController.navigationBar setTintColor:[UIColor redColor]];
    }
    [self.sessionManager performSelectorInBackground:@selector(save) withObject:nil];
}

- (void)viewWillLayoutSubviews
{
    [self layoutSlideImagesInBackground];
}

//Code from Brett Schumann
- (void) keyboardWillShow:(NSNotification *)note{
    //isEditingScript = YES;
    // get keyboard size and loctaion
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
	// get a rect for the textView frame
	CGRect containerFrame = textView.frame;
    containerFrame.size.height = self.view.bounds.size.height - keyboardBounds.size.height;
    containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
	
	// set views with new info
	
    //textView.frame = containerFrame;
    //textView.minHeight = containerFrame.size.height;
    [self layoutTextView:textView forState:TextViewPositionStateEditing];

	// commit animations
	[UIView commitAnimations];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
}

- (void) keyboardWillHide:(NSNotification *)note{
    //isEditingScript = NO;
    
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
	
	// get a rect for the textView frame
	/*CGRect containerFrame = textView.frame;
    containerFrame.origin.y = (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))? self.view.bounds.size.height : self.view.bounds.size.height - containerFrame.size.height;*/
	
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
	// set views with new info
	//textView.frame = containerFrame;
    //textView.minHeight = 80.0f;
    [self layoutTextView:textView forState:TextViewPositionStateDefault];
	
	// commit animations
	[UIView commitAnimations];
    self.navigationItem.rightBarButtonItem = nil;

}

- (void)layoutTextView:(UIView*)atextView forState:(TextViewPositionState)state
{
    if ([atextView isEqual:textView]) {
        //CGRect frame = textView.frame;
        switch (state) {
            case TextViewPositionStateDefault:
            {
                CGRect containerFrame = textView.frame;
                
                //hide in landscape
                //containerFrame.origin.y = (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))? self.view.bounds.size.height : self.view.bounds.size.height - containerFrame.size.height;
                containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;
                
                textView.frame = containerFrame;
                textView.minHeight = 80.0f;
                filter.frame = self.view.frame;
                //[portraitTextView layoutIfNeeded];
            }
                break;
            case TextViewPositionStateEditing:
            {
                CGRect containerFrame = textView.frame;
                containerFrame.size.height = self.view.bounds.size.height - keyboardBounds.size.height;
                containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
                
                textView.frame = containerFrame;
                textView.minHeight = containerFrame.size.height;
                filter.frame = containerFrame;
                //[portraitTextView layoutIfNeeded];
            }
                break;
            case TextViewPositionStateHidden:
            {
                CGRect containerFrame = textView.frame;
                containerFrame.origin.y = self.view.frame.size.height;
                textView.frame = containerFrame;
                filter.frame = self.view.frame;
            }
                break;
                
            default:
                break;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    //NSLog(@"%@", self);
}

- (void)done:(id)sender
{
    [textView.internalTextView resignFirstResponder];
}

- (void)viewDidUnload {
    filter = nil;
    [super viewDidUnload];
}
@end
