//
//  PKNStartUpMenuViewController.m
//  Pechakucha Note
//
//  Created by Jean on 4/30/13.
//  Copyright (c) 2013 Pechakucha Note. All rights reserved.
//

#import "PKNStartUpMenuViewController.h"
#import "ELCAlbumPickerController.h"
#import "ELCAssetTablePicker.h"
#import "ELCImagePickerController.h"

@interface PKNStartUpMenuViewController ()

@end

@implementation PKNStartUpMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"20 Note";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)launchPhotoLibraryPickerController
{
    ELCAlbumPickerController *albumController = [[ELCAlbumPickerController alloc] initWithNibName: nil bundle: nil];
	ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initWithRootViewController:albumController];

    [albumController setParent:elcPicker];
	[elcPicker setDelegate:self];
    
    PKNSessionManager *sessionManager = [[PKNSessionManager alloc] initWithImages:nil];
    
    practiceViewController = [[PKNPracticeViewController alloc] initWithSessionManager:sessionManager];
    //NSLog(@"%@", sessionManager);
    [self presentModalViewController:elcPicker animated:YES];

    
}



- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    
    /*for(NSDictionary *dict in info) {
        
        UIImage *image = [dict objectForKey:UIImagePickerControllerOriginalImage];
        PKNSlide *slide = [[PKNSlide alloc] initWithImage:image script:nil];
        [practiceViewController.sessionManager setSlides:[practiceViewController.sessionManager.slides arrayByAddingObject:slide]];
        NSLog(@"dict: %@", dict);
	}*/
    
    [picker dismissModalViewControllerAnimated:YES];
    [self.navigationController pushViewController:practiceViewController animated:NO];
    
}


- (void)addAssetWithArguments:(NSDictionary*)arguments
{
    
    ALAsset *alasset = (ALAsset*)[arguments objectForKey:@"asset"];
    int index = [[arguments objectForKey:@"index"] intValue];
    
    ALAssetRepresentation *assetRep = [alasset defaultRepresentation];
    
    CGImageRef imgRef = [assetRep fullScreenImage];
    UIImage *img = [UIImage imageWithCGImage:imgRef
                                       scale:[UIScreen mainScreen].scale
                                 orientation:UIImageOrientationUp];
    
    [(NSMutableDictionary*)[practiceViewController.sessionManager.slides objectAtIndex:index] setObject:img forKey:@"image"];
    
    NSMutableDictionary *slide = [NSMutableDictionary dictionaryWithObjectsAndKeys: img, @"image", @"", @"script", nil];
    [practiceViewController.sessionManager.slides setObject:slide atIndexedSubscript:index];
}

//- (void)removeAssetArguments:(NSDictionary*)arguments
/*{
    int index = [[arguments objectForKey:@"index"] intValue];
    practiceViewController.sessionManager.slides = [practiceViewController.sessionManager.slides arrayByRemovingObjectAtIndex:index];
}*/


- (void)elcImagePickerControllerDidSelectAsset:(id)asset atIndex:(int)index
{
    if ([asset isMemberOfClass:[ALAsset class]]) {
        NSMutableDictionary *emptySlide = [[NSMutableDictionary alloc] init];
        //[emptySlide setNilValueForKey:@"image"];
        //[emptySlide setNilValueForKey:@"script"];
        [practiceViewController.sessionManager.slides addObject:emptySlide];
        NSLog(@"select index:%i", index);
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            //load the fullscreenImage async
            ALAsset *alasset = (ALAsset*)asset;
            
            ALAssetRepresentation *assetRep = [alasset defaultRepresentation];
            
            CGImageRef imgRef = [assetRep fullScreenImage];
            UIImage *img = [UIImage imageWithCGImage:imgRef
                                               scale:[UIScreen mainScreen].scale
                                         orientation:UIImageOrientationUp];

            dispatch_async(dispatch_get_main_queue(), ^{
                //assign the loaded image to the view.
                NSMutableDictionary *slide = [NSMutableDictionary dictionaryWithObjectsAndKeys: img, @"image", @"", @"script", nil];
                [practiceViewController.sessionManager.slides setObject:slide atIndexedSubscript:index];
            });
        });
        
        
        //NSDictionary *arguments = [NSDictionary dictionaryWithObjectsAndKeys:asset, @"asset", [NSNumber numberWithInt: index], @"index", nil];
        
        //[self performSelectorInBackground:@selector(addAssetWithArguments:) withObject:arguments];
    }
}

- (void)elcImagePickerControllerDidDeselectAsset:(id)asset atIndex:(int)index
{
    if ([asset isMemberOfClass:[ALAsset class]]) {
        //[self performSelectorInBackground:@selector(removeAssetAtIndex:) withObject:[NSNumber numberWithInt:index]];
        [practiceViewController.sessionManager.slides removeObjectAtIndex:index];
    }
}

- (void)elcImagePickerController:(ELCImagePickerController *)picker didChangeSelectedMediaWithInfo:(NSArray *)info
{
    //NSMutableArray *images = [NSMutableArray arrayWithCapacity:[info count]];
	
    //practiceViewController.sessionManager.slides = nil;
    
	/*for(NSDictionary *dict in info) {
        
        UIImage *image = [dict objectForKey:UIImagePickerControllerOriginalImage];
        [images addObject:image];
        PKNSlide *slide = [[PKNSlide alloc] initWithImage:image script:nil];
        [practiceViewController.sessionManager setSlides:[NSArray arrayWithObject:slide]];
        NSLog(@"dict: %@", dict);
	}*/
}


- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
}

@end
