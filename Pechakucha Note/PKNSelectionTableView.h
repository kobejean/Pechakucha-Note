//
//  PKNSelectionTableView.h
//  Pechakucha Note
//
//  Created by Jean on 4/19/13.
//  Copyright (c) 2013 Pechakucha Note. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PKNSelectionTableViewDelegate <NSObject>

@optional

- (void)touchUpInsideCell:(id)cell;

- (void)didBeginEditMode;
- (void)didFinnishEditMode;
- (void)willDeleteCell:(id)cell;
- (void)didDeleteCell:(id)cell;
- (void)willCreateCell:(id)cell;
- (void)didCreateCell:(id)cell;


@end

@interface PKNSelectionTableView : UIView
{
    id <PKNSelectionTableViewDelegate> __weak _delegate;
    
    BOOL _multipleSelection;
    BOOL _editing;
    BOOL _textDisabled;
    
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
    NSArray *_selectedCells;
    
    UIImage *_loadingIcon;
    UIScrollView *_scrollView;
}

@property (weak, readwrite) id <PKNSelectionTableViewDelegate> delegate;

@property (readwrite) BOOL multipleSelection;
@property (readwrite, nonatomic) BOOL editing;
@property (readwrite, nonatomic) BOOL textDisabled;

@property (readwrite) float iconXMargin;
@property (readwrite) float iconYMargin;
@property (readwrite) float labelWidth;
@property (readwrite) float cellHeight;

@property (readwrite) NSInteger selectionCap;
@property (nonatomic, readwrite) NSInteger cellsPerRowPortrait;
@property (nonatomic, readwrite) NSInteger cellsPerRowLandscape;
@property (nonatomic, readwrite) NSInteger cellsPerRow;

@property (nonatomic, strong) NSArray *cells;
@property (nonatomic, strong) NSArray *semiExistentCells;
@property (nonatomic, strong) NSArray *selectedCells;

@property (nonatomic, strong) UIImage *loadingIcon;
@property (nonatomic, strong) UIScrollView *scrollView;

- (void)layoutCells;
- (void)addCell:(id)cell animated:(BOOL)animated;
- (void)removeCell:(id)cell animated:(BOOL)animated;

@end
