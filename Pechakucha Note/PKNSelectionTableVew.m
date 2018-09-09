//
//  PKNSelectionTableVew.m
//  Pechakucha Note
//
//  Created by Jean on 4/19/13.
//  Copyright (c) 2013 Pechakucha Note. All rights reserved.
//

#import "PKNSelectionTableVew.h"
#import "NSArray+PKArray.h"

const float _iconWidth = 80.0f;
const float _iconHeight = 120.0f;
const float _labelXMargin = 0.0f;
const float _labelYMargin = 11.0f;
const float _labelHeight = 40.0f;
const float _tableXMargin = 11.0f;
const float _tableYMargin = 11.0f;
float _cellHeight;

@implementation PKNSelectionTableVew

#pragma mark - Synthesizing Properties

@synthesize delegate = _delegate;

@synthesize multipleSelection = _multipleSelection;
@synthesize editing = _editing;
@synthesize labelEnabled = _labelEnabeled;

@synthesize iconXMargin = _iconXMargin;
@synthesize iconYMargin = _iconYMargin;
@synthesize labelWidth = _labelWidth;
@synthesize cellHeight = _cellHeight;

@synthesize selectionCap = _selectionCap;
@synthesize cellsPerRow = _cellsPerRow;
@synthesize cellsPerRowPortrait = _cellsPerRowPortrait;
@synthesize cellsPerRowLandscape = _cellsPerRowLandscape;

@synthesize cells = _cells;
@synthesize semiExistentCells = _semiExistentCells;

@synthesize scrollView = _scrollView;

#pragma mark - Overriding UIView Methods

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        NSLog(@"init");
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        self.scrollView.delaysContentTouches = NO;
        
        self.cellsPerRowPortrait = 3;
        self.cellsPerRowLandscape = 4;
        
        [self addSubview:self.scrollView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.scrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    _iconXMargin=(((self.frame.size.width-(_tableXMargin*2))/self.cellsPerRow)-_iconWidth)/2;
    _iconYMargin=_iconXMargin;
    _labelWidth=((self.frame.size.width-(_tableXMargin*2))/self.cellsPerRow)-(_labelXMargin*2);
    _cellHeight = (_iconYMargin)+_iconHeight + ((self.labelEnabled)? 0 : _labelHeight + _labelYMargin);
    
    self.scrollView.contentSize = CGSizeMake(self.frame.size.width, _cellHeight);
}

#pragma mark - Getters & Setters

- (NSInteger)cellsPerRow
{
    return (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))? self.cellsPerRowLandscape : self.cellsPerRowPortrait;
}

- (void)setCells:(NSArray *)cells
{
    NSArray *cellsToAdd = [self.cells subtractArray:cells];
    NSArray *cellsToRemove = [cells subtractArray:self.cells];
    
    _cells = cells;
    
    for (PKNSelectionTableViewCell *cellToAdd in cellsToAdd) {
        //
    }
    
    for (PKNSelectionTableViewCell *cellToRemove in cellsToRemove) {
        [cellToRemove removeFromSuperview];
    }
}

- (void)setCells:(NSArray *)cells animated:(BOOL)animated
{
    if (animated) {
        NSArray *cellsToAdd = [self.cells subtractArray:cells];
        NSArray *cellsToRemove = [cells subtractArray:self.cells];
        
        _cells = cells;
        
        
        for (PKNSelectionTableViewCell *cellToAdd in cellsToAdd) {
            [self addCell:cellToAdd animated:animated];
        }
        
        for (PKNSelectionTableViewCell *cellToRemove in cellsToRemove) {
            [cellToRemove removeFromSuperview];
        }
        
    } else {
        [self setCells:cells];
    }
}

- (void)addCell:(PKNSelectionTableViewCell*)cell animated:(BOOL)animated
{
    
    if (animated) {
        [UIView transitionWithView:self
                          duration:0.5f
                           options:UIViewAnimationOptionLayoutSubviews
                        animations:^{
                            [self.scrollView addSubview:cell];
                            [cell setSemiExistent:YES];
                            _cells = [self.cells arrayByAddingObject:cell];
                        } completion:^(BOOL finished) {
                            [cell setSemiExistent:NO];
                        }];
    } else {
        
    }
    
}

- (void)removeCell:(PKNSelectionTableViewCell*)cell
{
    
}


#pragma mark - Methods


- (void)reload
{
    
}

- (void)layoutCells
{
    _iconXMargin=(((self.frame.size.width-(_tableXMargin*2))/self.cellsPerRow)-_iconWidth)/2;
    _iconYMargin=_iconXMargin;
    _labelWidth=((self.frame.size.width-(_tableXMargin*2))/self.cellsPerRow)-(_labelXMargin*2);
    _cellHeight = (_iconYMargin)+_iconHeight + ((self.labelEnabled)? 0 : _labelHeight + _labelYMargin);
    
    NSInteger visibleCellIndex = 0;
    for (PKNSelectionTableViewCell *cell in self.cells) {
        [cell setFrame:[self rectForVisibleCellAtIndex:visibleCellIndex]];
        if (!cell.semiExistent) {
            visibleCellIndex++;
        }
    }
    self.scrollView.contentSize = CGSizeMake(self.frame.size.width, _cellHeight);
}

- (CGRect)rectForVisibleCellAtIndex:(NSInteger)index
{
    float width = ((self.frame.size.width-(_tableXMargin*2))/(float)_cellsPerRow);
    int row=(int)floor(index/(float)_cellsPerRow);
    int column = index-(row*_cellsPerRow);
    float x=(column*width)+_tableXMargin;
    float y=(row*_cellHeight)+_tableYMargin;
    return CGRectMake(x, y, width, _cellHeight);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
