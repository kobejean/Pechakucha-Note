//
//  PKNSessionManager.h
//  Pechakucha Note
//
//  Created by Jean on 4/21/13.
//  Copyright (c) 2013 Pechakucha Note. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "PKNSlide.h"
#import "UIImage+MUImage.h"

@protocol PKNSessionManagerDelegate

@optional
- (void)slidesDidChange;
@end

@interface PKNSessionManager : NSObject
{
    NSMutableArray *_slides;
    NSString *_path;
    NSMutableArray *_queuedUnsavedImageIndexes;
}

@property(unsafe_unretained) NSObject<PKNSessionManagerDelegate> *delegate;

@property (nonatomic, retain) NSMutableArray *slides;
@property (nonatomic, retain) NSString *path;

- (id)initWithImages:(NSArray*)images;
- (id)initWithPath:(NSString*)path;
- (void)save;
- (UIImage*)imageForIndex:(int)index;
- (void)deleteSession;
+ (NSArray*)sessionsInfo;
+ (void)deleteSavedSessionAtPath:(NSString*)path;
@end
