//
//  PKNSelectionTableView.m
//  Pechakucha Note
//
//  Created by Jean on 4/19/13.
//  Copyright (c) 2013 Pechakucha Note. All rights reserved.
//

#import "PKNSelectionTableView.h"
#import "PKNSelectionTableViewCell.h"
#import "NSArray+PKArray.h"

const float _iconWidth = 80.0f;
const float _iconHeight = 120.0f;
const float _labelXMargin = 0.0f;
const float _labelYMargin = 11.0f;
const float _labelHeight = 40.0f;
const float _tableXMargin = 11.0f;
const float _tableYMargin = 11.0f;
float _cellHeight;

@implementation PKNSelectionTableView

#pragma mark - Synthesizing Properties

@synthesize delegate = _delegate;

@synthesize multipleSelection = _multipleSelection;
@synthesize editing = _editing;
@synthesize textDisabled = _textDisabled;

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

@synthesize loadingIcon = _loadingIcon;
@synthesize scrollView = _scrollView;

#pragma mark - Overriding UIView Methods

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self additionalInitialization];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self additionalInitialization];
    }
    return self;
}

- (void)additionalInitialization
{
    if (self) {
        self.cellsPerRowPortrait = 3;
        self.cellsPerRowLandscape = 4;
        //self.cells = [[NSArray alloc] initWithObjects: nil];
        [self addScrollView];
    }
}

- (void)addScrollView
{
    if (!self.scrollView) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        self.scrollView.delaysContentTouches = NO;
        //[self.scrollView setBackgroundColor:[UIColor redColor]];
        self.autoresizesSubviews = NO;
        self.scrollView.autoresizesSubviews = NO;
        [self addSubview:self.scrollView];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.scrollView.frame = CGRectMake(self.scrollView.frame.origin.x, self.scrollView.frame.origin.y, self.frame.size.width, self.frame.size.height);
    [self layoutCells];
}

- (void)didMoveToSuperview
{

}

#pragma mark - Getters & Setters

- (NSInteger)cellsPerRow
{
    _cellsPerRow = (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))? self.cellsPerRowLandscape : self.cellsPerRowPortrait;
    return _cellsPerRow;
}

- (void)setCells:(NSArray *)cells
{
    [self setCells:cells animated:NO];
}

- (void)setCells:(NSArray *)cells animated:(BOOL)animated
{
    NSArray *cellsToAdd = [cells arrayByRemovingObjectsFromArray:self.cells];
    NSArray *cellsToRemove = [self.cells arrayByRemovingObjectsFromArray:cells];
    
    _cells = cells;
    if (self.superview) {
        if (animated) {
            
            //add
            if (cellsToAdd.count > 0) {
                for (PKNSelectionTableViewCell *cellToAdd in cellsToAdd) {
                    [self.scrollView addSubview:cellToAdd];
                    [self layoutCells];
                    [cellToAdd setSemiExistent:YES];
                }
            }
            //NSLog(@"/////start animation");
            {
                [UIView animateWithDuration:0.3f
                             animations:^{
                                 //add
                                 for (PKNSelectionTableViewCell *cellToAdd in cellsToAdd) {
                                     [cellToAdd setSemiExistent:NO];
                                 }
                                 
                                 //remove
                                 for (PKNSelectionTableViewCell *cellToRemove in cellsToRemove) {
                                     [cellToRemove setSemiExistent:YES];
                                 }
                                 [self layoutCells];
                             } completion:^(BOOL finished) {
                                 
                                 //remove
                                 for (PKNSelectionTableViewCell *cellToRemove in cellsToRemove) {
                                     [cellToRemove removeFromSuperview];
                                 }
                                 
                                 [self layoutCells];
                             }];
            
            }
        } else {
            
            //add
            for (PKNSelectionTableViewCell *cellToAdd in cellsToAdd) {
                [cellToAdd setSemiExistent:NO];
                [self.scrollView addSubview:cellToAdd];
            }
            
            //remove
            for (PKNSelectionTableViewCell *cellToRemove in cellsToRemove) {
                [cellToRemove setSemiExistent:YES];
                [cellToRemove removeFromSuperview];
            }
            [self layoutSubviews];
        }
    }
}

- (void)setLoadingIcon:(UIImage *)loadingIcon
{
    _loadingIcon = loadingIcon;
    for (PKNSelectionTableViewCell *cell in self.cells) {
        cell.loadingIcon = loadingIcon;
    }
}

- (void)setTextDisabled:(BOOL)textDisabled
{
    _textDisabled = textDisabled;
    
    for (PKNSelectionTableViewCell *cell in self.cells) {
        [cell setTextDisabled:textDisabled];
    }
}

- (void)setEditing:(BOOL)editing
{
    _editing = editing;
    for (PKNSelectionTableViewCell *cell in self.cells) {
        [cell setEditing:editing];
    }
}

- (void)addCell:(id)cell animated:(BOOL)animated
{
    if ([[cell class] isSubclassOfClass:[PKNSelectionTableViewCell class]]) {
        if ([self.delegate respondsToSelector:@selector(willCreateCell:)]) {
            [self.delegate willCreateCell:cell];
        }
        
        [self setCells:[self.cells arrayByAddingObject:cell] animated:animated];
        
        if ([self.delegate respondsToSelector:@selector(didCreateCell:)]) {
            [self.delegate didCreateCell:cell];
        }
    }
}

- (void)removeCell:(id)cell animated:(BOOL)animated
{
    if ([[cell class] isSubclassOfClass:[PKNSelectionTableViewCell class]]) {
        if ([self.delegate respondsToSelector:@selector(willDeleteCell:)]) {
            [self.delegate willDeleteCell:cell];
        }
        
        [self setCells:[self.cells arrayByRemovingObject:cell] animated:animated];
        
        if ([self.delegate respondsToSelector:@selector(didDeleteCell:)]) {
            [self.delegate didDeleteCell:cell];
        }
    }
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
    _cellHeight = (_iconYMargin)+_iconHeight + ((self.textDisabled)? 10.0f : _labelHeight + _labelYMargin);

    
    NSInteger visibleCellIndex = 0;
    NSInteger cellIndex = 0;
    for (PKNSelectionTableViewCell *cell in self.cells) {
        if (!cell.semiExistent) {
            [cell setFrame:[self rectForCellAtIndex:visibleCellIndex]];
            //NSLog(@"vis:%@", [self rectForCellAtIndex:visibleCellIndex]);
            visibleCellIndex++;
        }else{
            [cell setFrame:[self rectForCellAtIndex:cellIndex]];
            //NSLog(@"semi:%@", [self rectForCellAtIndex:cellIndex]);
        }
        cellIndex++;
    }
    
    int rows=(int)ceil(visibleCellIndex/(float)_cellsPerRow);
    float contentHeight=(rows*_cellHeight)+(_tableYMargin*2);
    self.scrollView.contentSize = CGSizeMake(self.frame.size.width, (self.scrollView.frame.size.height < contentHeight)? contentHeight : self.scrollView.frame.size.height);
}

- (CGRect)rectForCellAtIndex:(NSInteger)index
{
    float width = ((self.frame.size.width-(_tableXMargin*2))/(float)_cellsPerRow);
    int row=(int)floor(index/(float)_cellsPerRow);
    int column = index-(row*_cellsPerRow);
    float x=(column*width)+_tableXMargin;
    float y=(row*_cellHeight)+_tableYMargin;
    return CGRectMake(roundf(x), roundf(y), roundf(width), roundf(_cellHeight));
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
