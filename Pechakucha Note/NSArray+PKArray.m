//
//  NSArray+PKArray.m
//  Pechakucha Note
//
//  Created by Jean on 4/21/13.
//  Copyright (c) 2013 Pechakucha Note. All rights reserved.
//

#import "NSArray+PKArray.h"

@implementation NSArray (PKArray)

- (NSArray*)arrayByRemovingObjectsFromArray:(NSArray*)removingArray
{
    if (self) {
        NSMutableArray *outputArray = [NSMutableArray arrayWithArray:self];
        for (id removingObject in removingArray) {
            for (id object in self) {
                if ([removingObject isEqual:object]) {
                    [outputArray removeObject:removingObject];
                }
            }
        }
        return outputArray;
    }
    return [NSArray array];
}

- (NSArray*)arrayByRemovingObject:(id)removingObject
{
    if (self) {
        NSMutableArray *outputArray = [NSMutableArray arrayWithArray:self];
        [outputArray removeObject:removingObject];
        return outputArray;
    }
    return nil;
}

- (NSArray*)arrayByRemovingObjectAtIndex:(int)index
{
    if (self) {
        NSMutableArray *outputArray = [NSMutableArray arrayWithArray:self];
        [outputArray removeObjectAtIndex:index];
        return outputArray;
    }
    return nil;
}

- (NSArray*)arrayBySettingObject:(id)object atIndexedSubscript:(NSUInteger)index
{
    if (self) {
        NSMutableArray *outputArray = [NSMutableArray arrayWithArray:self];
        [outputArray setObject:object atIndexedSubscript:index];
        return outputArray;
    }
    return nil;
}


@end
