//
//  Asset.m
//
//  Created by ELC on 2/15/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import "ELCAsset.h"
#import "ELCAssetTablePicker.h"

@implementation ELCAsset

@synthesize asset = _asset;
@synthesize parent = _parent;
@synthesize selected = _selected;
@synthesize selectedIndex = _selectedIndex;

- (id)initWithAsset:(ALAsset*)asset
{
	self = [super init];
	if (self) {
		self.asset = asset;
        _selected = NO;
    }
    
	return self;	
}

- (void)toggleSelection
{
    self.selected = !self.selected;
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    if (selected) {
        if (_parent != nil && [_parent respondsToSelector:@selector(selectedAsset:)]) {
            [_parent selectedAsset:self];
        }
    }else{
        if (_parent != nil && [_parent respondsToSelector:@selector(deselectedAsset:)]) {
            [_parent deselectedAsset:self];
        }
    }
    self.selectedIndex = [_parent selectedIndexOfAsset:self];
}

- (void)setSelectedIndex:(int)selectedIndex
{
    _selectedIndex = selectedIndex;
}


@end

