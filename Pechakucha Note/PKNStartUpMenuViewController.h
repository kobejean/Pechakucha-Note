//
//  PKNStartUpMenuViewController.h
//  Pechakucha Note
//
//  Created by Jean on 4/30/13.
//  Copyright (c) 2013 Pechakucha Note. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELCImagePickerController.h"
#import "PKNPracticeViewController.h"
#import "NSArray+PKArray.h"

@interface PKNStartUpMenuViewController : UIViewController <ELCImagePickerControllerDelegate>
{
    PKNPracticeViewController *practiceViewController;
}

- (IBAction)launchPhotoLibraryPickerController;

@end
