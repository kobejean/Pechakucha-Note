//
//  NSArray+PKArray.h
//  Pechakucha Note
//
//  Created by Jean on 4/21/13.
//  Copyright (c) 2013 Pechakucha Note. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (PKArray)

- (NSArray*)arrayByRemovingObjectsFromArray:(NSArray*)subtractingArray;
- (NSArray*)arrayByRemovingObject:(id)subtractingObject;
- (NSArray*)arrayByRemovingObjectAtIndex:(int)index;
- (NSArray*)arrayBySettingObject:(id)object atIndexedSubscript:(NSUInteger)index;
@end
