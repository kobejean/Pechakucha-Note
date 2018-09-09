//
//  PKNSelectionTableVew.h
//  Pechakucha Note
//
//  Created by Jean on 4/19/13.
//  Copyright (c) 2013 Pechakucha Note. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKNSelectionTableViewCell.h"

@protocol PKNSelectionTableViewDelegate <NSObject>

@optional

- (void)didSelectObject:(id)object;
- (void)didSelectCell:(PKNSelectionTableViewCell*)cell;
- (void)didBeginEditMode;
- (void)didFinnishEditMode;
- (void)willDeleteCell:(PKNSelectionTableViewCell*)cell;
- (void)didDeleteCell:(PKNSelectionTableViewCell*)cell;
- (void)willCreateCell:(PKNSelectionTableViewCell*)cell;
- (void)didCreateCell:(PKNSelectionTableViewCell*)cell;


@end

@interface PKNSelectionTableVew : UIView
{
    id <PKNSelectionTableViewDelegate> _delegate;
    
    BOOL _multipleSelection;
    BOOL _editing;
    BOOL _labelEnabeled;
    
    float _iconXMargin;
    float _iconYMargin;
    float _labelWidth;
    float _cellHeight;
    
    NSInteger _selectionCap;
    NSInteger _cellsPerRowPortrait;
    NSInteger _cellsPerRowLandscape;
    NSInteger _cellsPerRow;
    
    NSArray *_cells;
    NSArray *_semiExistentCells;
    
    UIScrollView *_scrollView;
}

@property (readwrite) id <PKNSelectionTableViewDelegate> delegate;

@property (readwrite) BOOL multipleSelection;
@property (readwrite) BOOL editing;
@property (readwrite) BOOL labelEnabled;

@property (readwrite) float iconXMargin;
@property (readwrite) float iconYMargin;
@property (readwrite) float labelWidth;
@property (readwrite) float cellHeight;

@property (readwrite) NSInteger selectionCap;
@property (nonatomic, readwrite) NSInteger cellsPerRowPortrait;
@property (nonatomic, readwrite) NSInteger cellsPerRowLandscape;
@property (nonatomic, readwrite) NSInteger cellsPerRow;

@property (nonatomic, retain) NSArray *cells;
@property (nonatomic, retain) NSArray *semiExistentCells;

@property (nonatomic, retain) UIScrollView *scrollView;

- (void)layoutCell:(PKNSelectionTableViewCell*)cell;


@end
