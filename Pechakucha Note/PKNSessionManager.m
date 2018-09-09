//
//  PKNSessionManager.m
//  Pechakucha Note
//
//  Created by Jean on 4/21/13.
//  Copyright (c) 2013 Pechakucha Note. All rights reserved.
//

#import "PKNSessionManager.h"

@implementation PKNSessionManager

@synthesize slides = _slides;
@synthesize path = _path;
@synthesize delegate;

- (void)setSlides:(NSMutableArray *)slides
{
    _slides = slides;
    //NSLog(@"setSlides:%@", _slides);
    /*if ([delegate respondsToSelector:@selector(slidesDidChange)]) {
        [delegate slidesDidChange];
    }*/
}

- (id)initWithImages:(NSArray*)images
{
    self = [self init];
    if (self) {
        NSMutableArray *slides = [[NSMutableArray alloc] initWithCapacity:20];
        for (UIImage *image in images) {
            [_queuedUnsavedImageIndexes addObject:[NSNumber numberWithInt:slides.count]];
            [slides addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:image , @"image", @"", @"imagePath", @"", @"script", nil]];
        }
        
        self.slides = slides;
    }
    return self;
}

- (id)initWithPath:(NSString*)path
{
    self = [self init];
    if (self) {
        self.path = path;
        self.slides = [[NSMutableArray alloc] initWithCapacity:20];
        NSString *infoPath = [path stringByAppendingPathComponent:@"info.plist"];
        NSMutableDictionary *infoDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:infoPath];
        [self.slides addObjectsFromArray:[infoDictionary objectForKey:@"slides"]];
        NSLog(@"%@", self.slides);
    }
    return self;
}

+ (NSString*)savedSessionsPath
{
    NSString *directoryName = @"Saved_Sessions";
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    NSString *savedSessionsPath = [documentsPath stringByAppendingPathComponent:directoryName];
    BOOL isDir;
    if (![[NSFileManager defaultManager] fileExistsAtPath:savedSessionsPath isDirectory:&isDir]) {
        [self createDirectory:directoryName atFilePath:documentsPath];
    }
    
    if (!isDir) {
        [self createDirectory:directoryName atFilePath:documentsPath];
    }
    return savedSessionsPath;
}

+ (NSString*)newDirectoryAtPath:(NSString*)path
{
    NSString *newDirectoryName = [PKNSessionManager createUUID];
    NSString *newDirectoryPath = [path stringByAppendingPathComponent:newDirectoryName];
    [PKNSessionManager createDirectory:newDirectoryName atFilePath:path];
    return newDirectoryPath;
}

+ (void)createDirectory:(NSString *)directoryName atFilePath:(NSString *)filePath
{
    NSString *filePathAndDirectory = [filePath stringByAppendingPathComponent:directoryName];
    NSError *error;
    
    if (![[NSFileManager defaultManager] createDirectoryAtPath:filePathAndDirectory
                                   withIntermediateDirectories:NO
                                                    attributes:nil
                                                         error:&error])
    {
        NSLog(@"Create directory error: %@", error);
    }
}

+ (void)savePlist:(NSDictionary*)dictionary toPath:(NSString*)path
{
    /* Generate plist. */
    NSError *error = nil;
    NSData *data = [NSPropertyListSerialization
                    dataWithPropertyList:dictionary
                    format:NSPropertyListXMLFormat_v1_0
                    options:0
                    error:&error];
    
    if (!data) {
        NSLog(@"%s: Failed to serialize data: %@", __func__, error);
        return;
    }
    
    /* Write data. */
    
    BOOL ok = [data writeToFile:path options:NSDataWritingAtomic error:&error];
    if (!ok) {
        NSLog(@"%s: Failed to write atomically to path %@: %@", __func__, path, error);
    }
}

+ (NSString *)createUUID
{
    // Create universally unique identifier (object)
    CFUUIDRef uuidObject = CFUUIDCreate(kCFAllocatorDefault);
    
    // Get the string representation of CFUUID object.
    NSString *uuidStr = (__bridge NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuidObject);
    
    // If needed, here is how to get a representation in bytes, returned as a structure
    // typedef struct {
    //   UInt8 byte0;
    //   UInt8 byte1;
    //   ...
    //   UInt8 byte15;
    // } CFUUIDBytes;
    //CFUUIDBytes bytes = CFUUIDGetUUIDBytes(uuidObject);
    
    CFRelease(uuidObject);
    
    return uuidStr;
}

- (void)addToSessionsInfo
{
    NSMutableDictionary *sessionsInfoDictionary = [NSMutableDictionary dictionary];
    NSMutableArray *sessions = [NSMutableArray arrayWithArray:[PKNSessionManager sessionsInfo]];
    
    NSMutableDictionary *session = [NSMutableDictionary dictionaryWithObject:self.path forKey:@"path"];
    [session setObject:[NSDate date] forKey:@"dateCreated"];
    [sessions addObject:session];
    
    [sessionsInfoDictionary setObject:sessions forKey:@"sessions"];
    [PKNSessionManager saveSessionsInfoDictionary:sessionsInfoDictionary];
}

- (void)updateSessionsInfo
{
    [PKNSessionManager saveSessionsInfoDictionary:[NSDictionary dictionaryWithObject:[PKNSessionManager sessionsInfo] forKey:@"sessions"]];
}

+ (void)saveSessionsInfoDictionary:(NSDictionary*)sessionsInfoDictionary
{
    NSString *sessionsInfoPath = [[PKNSessionManager savedSessionsPath] stringByAppendingPathComponent:@"info.plist"];
    NSMutableDictionary *sessionsInfoMutableDictionary = [NSMutableDictionary dictionaryWithDictionary:sessionsInfoDictionary];
    [sessionsInfoMutableDictionary setObject:[NSDate date] forKey:@"dateModified"];
    
    [PKNSessionManager savePlist:sessionsInfoMutableDictionary toPath:sessionsInfoPath];
}

- (void)save
{
    NSLog(@"save");
    
    //NSMutableDictionary *sessionsInfoDictionary;
    //NSMutableArray *sessions;
    //NSString *sessionsInfoPath = [[PKNSessionManager savedSessionsPath] stringByAppendingPathComponent:@"info.plist"];
    
    if (!self.path) {
        self.path = [PKNSessionManager newDirectoryAtPath:[PKNSessionManager savedSessionsPath]];
        
        //add new session to sessions info
        [self addToSessionsInfo];
        
        //save thumbnail
        if([[self.slides objectAtIndex:0] objectForKey:@"image"]){
            UIImage *image = [UIImage imageWithImage:[[self.slides objectAtIndex:0] objectForKey:@"image"] scaledToSize:CGSizeMake(80.0, 120.0) contentMode:UIViewContentModeScaleAspectFill];
            NSString *imagePath = [self.path stringByAppendingPathComponent:@"thumbnail"];
            NSData *jpegData = UIImageJPEGRepresentation(image, 1.0);
            [jpegData writeToFile:imagePath atomically:YES];
        }
        
        //saveImages
        for (int i = 0; i < self.slides.count; i++) {
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate date]];
            if([[self.slides objectAtIndex:i] objectForKey:@"image"]){
                NSString *imageName = [PKNSessionManager createUUID];
                NSString *imagePath = [self.path stringByAppendingPathComponent:imageName];
                NSMutableDictionary *slide = [self.slides objectAtIndex:i];
                UIImage *image;
                if ([slide objectForKey:@"image"]) {
                    image = [slide objectForKey:@"image"];
                }else{
                    NSLog(@"no image for index:%i", i);
                    return;
                }
                
                NSData *jpegData = UIImageJPEGRepresentation(image, 0.5);
                [jpegData writeToFile:imagePath atomically:YES];
                
                [slide setObject:imagePath forKey:@"imagePath"];
                [slide removeObjectForKey:@"image"];
            }
        }
    }else{
        [self updateSessionsInfo];
    }
    
    NSMutableDictionary *infoDictionary = [NSMutableDictionary dictionaryWithObject:self.slides forKey:@"slides"];
    [PKNSessionManager savePlist:infoDictionary toPath:[self.path stringByAppendingPathComponent:@"info.plist"]];
}

- (UIImage*)imageForIndex:(int)index
{
    if (index < self.slides.count) {
        if ([[self.slides objectAtIndex:index] objectForKey:@"imagePath"]) {
            NSString *imagePath = [[self.slides objectAtIndex:index] objectForKey:@"imagePath"];
            return [UIImage imageWithContentsOfFile:imagePath];
        }
        if ([[self.slides objectAtIndex:index] objectForKey:@"image"]) {
            return [[self.slides objectAtIndex:index] objectForKey:@"image"];
        }
    }
    NSLog(@"failed to find image for index:%i", index);
    return nil;
}

- (void)deleteSession
{
    [PKNSessionManager deleteSavedSessionAtPath:self.path];
}

+ (void)deleteSavedSessionAtPath:(NSString*)path
{
    NSMutableDictionary *sessionsInfoDictionary = [NSMutableDictionary dictionary];
    NSMutableArray *sessions = [NSMutableArray arrayWithArray:[PKNSessionManager sessionsInfo]];
    
    int removeIndex = [sessions indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *dictionary = obj;
        //NSLog(@"%@ isEqualToString: %@", [dictionary objectForKey:@"path"], path);
        if ([[dictionary objectForKey:@"path"] isEqualToString:path]) {
            return YES;
        }
        return NO;
    }];
    if (removeIndex != NSNotFound) {
        [sessions removeObjectAtIndex:removeIndex];
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }else{
        NSLog(@"NSNotFound");
    }
    
    [sessionsInfoDictionary setObject:sessions forKey:@"sessions"];
    [PKNSessionManager saveSessionsInfoDictionary:sessionsInfoDictionary];
}

+ (NSArray*)sessionsInfo
{
    
    NSString *sessionsInfoPath = [[PKNSessionManager savedSessionsPath] stringByAppendingPathComponent:@"info.plist"];
    NSMutableArray *sessions;
    NSMutableDictionary *sessionsInfoDictionary = [NSMutableDictionary dictionary];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:sessionsInfoPath]) {
        sessionsInfoDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:sessionsInfoPath];
        sessions = [NSMutableArray arrayWithArray:[sessionsInfoDictionary objectForKey:@"sessions"]];
    }else{
        sessionsInfoDictionary = [NSMutableDictionary dictionary];
        sessions = [NSMutableArray array];
        [sessionsInfoDictionary setObject:[NSDate date] forKey:@"dateCreated"];
        [sessionsInfoDictionary setObject:[NSDate date] forKey:@"dateModified"];
        [PKNSessionManager savePlist:sessionsInfoDictionary toPath:sessionsInfoPath];
    }
    
    return sessions;
}

@end
