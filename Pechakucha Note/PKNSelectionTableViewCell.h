//
//  PKNSelectionTableViewCell.h
//  Pechakucha Note
//
//  Created by Jean on 4/19/13.
//  Copyright (c) 2013 Pechakucha Note. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
//#import "UIImage+MUImage.h"
#import "NSArray+PKArray.h"
#import <CoreImage/CoreImage.h>


#import "PKNSelectionTableView.h"

@interface PKNSelectionTableViewCell : UIView
{
    BOOL _touchStartedOnIcon;
    BOOL _touchOnIconShouldTriggerAction;
    BOOL _touchStartedOnTextLabel;
    BOOL _semiExistent;
    BOOL _iconIsNotLoaded;
    BOOL _textDisabled;
    BOOL _editing;
    
    float _iconWidth;
    float _iconHeight;
    float _iconXMargin;
    float _iconYMargin;
    float _labelXMargin;
    float _labelWidth;
    float _labelHeight;
    float _labelYMargin;
    float _tableXMargin;
    float _tableYMargin;
    float _cellHeight;
    
    id __weak _value;
    PKNSelectionTableView *__weak _selectionTableView;
    
    NSString *_text;
    
    UIImageView *_iconView;
    UILabel *_textLabel;
    UIImage *_icon;
    UIImage *_highlightedIcon;
    UIImage *_loadingIcon;

}

@property (nonatomic, readwrite) BOOL semiExistent;
@property (nonatomic, readwrite) BOOL iconIsNotLoaded;
@property (nonatomic, readwrite) BOOL textDisabled;
@property (nonatomic, readwrite) BOOL editing;

@property (weak, nonatomic) id value;
@property (weak, nonatomic) PKNSelectionTableView *selectionTableView;

@property (nonatomic, strong) NSString *text;

@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, strong) UIImage *highlightedIcon;
@property (nonatomic, strong) UIImage *loadingIcon;

- (id)initWithText:(NSString*)text icon:(UIImage*)icon highlightedIcon:(UIImage*)highlightedIcon value:(id)value;
- (void)setIcon:(UIImage *)icon highlightedIcon:(UIImage *)highlightedIcon;
- (void)deleteSelf;

@end
