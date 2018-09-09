//
//  PKNSelectionTableViewCell.m
//  Pechakucha Note
//
//  Created by Jean on 4/19/13.
//  Copyright (c) 2013 Pechakucha Note. All rights reserved.
//

#import "PKNSelectionTableViewCell.h"

@implementation PKNSelectionTableViewCell

@synthesize semiExistent = _semiExistent;
@synthesize iconIsNotLoaded = _iconIsNotLoadedl;
@synthesize textDisabled = _textDisabled;
@synthesize editing = _editing;

@synthesize value = _value;
@synthesize selectionTableView = _selectionTableView;

@synthesize text = _text;

@synthesize deleteButton = _deleteButton;
@synthesize iconView = _iconView;
@synthesize textLabel = _textLabel;
@synthesize icon = _icon;
@synthesize highlightedIcon = _highlightedIcon;


#pragma mark - Overriding UIView Methods

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithText:(NSString*)text icon:(UIImage*)icon highlightedIcon:(UIImage*)highlightedIcon value:(id)value
{
    self = [self initWithFrame:CGRectZero];
    if (self) {
        
        _labelHeight = 20.0f;
        
        //self.type = type;
        
        self.value = value;
        self.iconView=[[UIImageView alloc] init];
        
        self.iconIsNotLoaded = YES;
        self.loadingIcon = [UIImage imageNamed:@"noIconSelectionTableViewCell.png"];
        
        [self setIcon:icon highlightedIcon:highlightedIcon];

        [self.iconView setContentMode:UIViewContentModeScaleAspectFill];
        [self addSubview:self.iconView];
        [self.iconView setClipsToBounds:YES];
        self.textLabel=[[UILabel alloc] initWithFrame:CGRectZero];
        [self.textLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.0f]];
        [self.textLabel setTextColor:[UIColor colorWithRed:0.0f green:0.4862745098f blue:1.0f alpha:1.0f]];
        
        /*self.textLabel.layer.masksToBounds = NO;
        //self.textLabel.layer.cornerRadius = 8; // if you like rounded corners
        self.textLabel.layer.shadowOffset = CGSizeMake(0, 1);
        self.textLabel.layer.shadowRadius = 1;
        self.textLabel.layer.shadowOpacity = 0.4;
        self.textLabel.layer.shouldRasterize = YES;
        self.textLabel.layer.rasterizationScale = [UIScreen mainScreen].scale;*/
        
        
        [self.textLabel setTextAlignment:NSTextAlignmentCenter];
        [self.textLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.textLabel];
        self.text=text;
        
        self.autoresizesSubviews = NO;
        
        self.clipsToBounds = NO;
        
        self.iconView.layer.masksToBounds = NO;
        //self.iconView.layer.cornerRadius = 8; // if you like rounded corners
        self.iconView.layer.shadowOffset = CGSizeMake(0, 2);
        self.iconView.layer.shadowRadius = 2;
        self.iconView.layer.shadowOpacity = 0.4;
        // CGPathRef path = [UIBezierPath bezierPathWithRect:self.iconView.bounds].CGPath;
        self.iconView.layer.shouldRasterize = YES;
        // Don't forget the rasterization scale
        // I spent days trying to figure out why retina display assets weren't working as expected
        self.iconView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        //[self.iconView.layer setShadowPath:path];
        
        self.deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30.0f, 29.0f)];
        [self.deleteButton setImage:[UIImage imageNamed:@"closebox.png"] forState:UIControlStateNormal];
        [self.deleteButton setHidden:YES];
        [self.deleteButton addTarget:self action:@selector(deleteSelf) forControlEvents:UIControlEventTouchUpInside];
        //[self.deleteButton setFrame:CGRectMake(self.iconView.frame.origin.x, self.iconView.frame.origin.y, 10, 10)];
        [self addSubview:self.deleteButton];
        //        [self.deleteButton buttonType]
        //[self.deleteButton setFrame:CGRectMake(0, 0, 0, 0)];
        //[self.deleteButton setHidden:YES];
        //        [self addSubview:self.deleteButton];
        
        
        //        [self.textLabel setBackgroundColor:[UIColor greenColor]];
        //        [self.iconView setBackgroundColor:[UIColor redColor]];
        //[self setBackgroundColor:[UIColor blueColor]];
        
    }
    return self;
}

- (void)layoutSubviews
{
    if (self.superview) {
        NSInteger _cellsPerRow = [(PKNSelectionTableView*)self.selectionTableView cellsPerRow];
        //NSLog(@"tableCell: cellsPerRow: %i", _cellsPerRow);
        float contentWidth = (self.superview.frame.size.width?self.superview.frame.size.width:320);
        _tableXMargin = 11.0f;
        _tableYMargin = 11.0f;
        _iconWidth=80.0f;
        _iconHeight=120.0f;
        _iconXMargin=(((contentWidth-(_tableXMargin*2))/_cellsPerRow)-_iconWidth)/2;
        _iconYMargin=_iconXMargin;
        _labelXMargin=0.0f;
        _labelWidth=((contentWidth-(_tableXMargin*2))/_cellsPerRow)-(_labelXMargin*2);
        _labelYMargin=11.0f;
        
        //_cellHeight = 150;
        self.iconView.frame = CGRectMake(_iconXMargin, _iconYMargin, _iconWidth, _iconHeight);
        self.textLabel.frame = CGRectMake(_labelXMargin, (_iconYMargin*2)+_iconHeight, _labelWidth, _labelHeight);
        self.deleteButton.frame = CGRectMake(_iconXMargin-(self.deleteButton.frame.size.width/2), _iconYMargin-(self.deleteButton.frame.size.height/2), self.deleteButton.frame.size.width, self.deleteButton.frame.size.width);
    }
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    CGPoint touchLocation = [touch locationInView:self];
    //NSLog(@"location:%@, %@", NSStringFromCGPoint(touchLocation), NSStringFromCGRect(self.iconView.frame));
    if (CGRectContainsPoint(self.iconView.frame, touchLocation))
    {
        _touchStartedOnIcon = YES;
        _touchOnIconShouldTriggerAction = YES;
        [self.iconView setHighlighted:YES];
        NSLog(@"setHighlighted");
    }else{
        _touchOnIconShouldTriggerAction = NO;
        _touchStartedOnIcon = NO;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    CGPoint touchLocation = [touch locationInView:self];
    float radius=20.0;
    CGRect touchBounds = CGRectInset(self.iconView.frame, radius, radius);
    if (!CGRectContainsPoint(touchBounds, touchLocation))
    {
        if (_touchStartedOnIcon == YES || _touchOnIconShouldTriggerAction == YES) {
            _touchOnIconShouldTriggerAction = NO;
            _touchStartedOnIcon = NO;
        }
    }
    if (self.iconView.highlighted != CGRectContainsPoint(touchBounds, touchLocation)) {
        self.iconView.highlighted = CGRectContainsPoint(touchBounds, touchLocation);
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    CGPoint touchLocation = [touch locationInView:self];
    float radius=20.0;
    CGRect touchBounds = CGRectInset(self.iconView.frame, radius, radius);
    if (CGRectContainsPoint(touchBounds, touchLocation))
    {
        if (_touchStartedOnIcon&&_touchOnIconShouldTriggerAction&&[[self.selectionTableView delegate] respondsToSelector:@selector(touchUpInsideCell:)]) {
            [[self.selectionTableView delegate] touchUpInsideCell:self];
        }
        NSLog(@"touchUpInsideCell");
    }
    
    _touchOnIconShouldTriggerAction = NO;
    _touchStartedOnIcon = NO;
    self.iconView.highlighted = NO;
}

- (void)didMoveToSuperview
{
    //scrollView is superview
    if ([self.superview.superview.class isSubclassOfClass:[PKNSelectionTableView class]]) {
        self.selectionTableView = (PKNSelectionTableView*)self.superview.superview;
        if (self.selectionTableView.loadingIcon) {
            self.loadingIcon = self.selectionTableView.loadingIcon;
        }
        self.textDisabled = self.selectionTableView.textDisabled;
        self.editing = self.selectionTableView.editing;
    }
}


#pragma mark - Getters & Setters

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}

- (void)setSemiExistent:(BOOL)semiExistent
{
    _semiExistent = semiExistent;
    if (semiExistent) {
        self.layer.anchorPoint = CGPointMake(0.5f, 0.5f);
        [self setAlpha:0.0f];
        [self setTransform:CGAffineTransformMakeScale(0.01, 0.01)];
        
        PKNSelectionTableView *stv = (PKNSelectionTableView*)self.selectionTableView;
        [stv setSemiExistentCells:[stv.semiExistentCells arrayByAddingObject:self]];
    }else{
        self.layer.anchorPoint = CGPointMake(0.5f, 0.5f);
        [self setAlpha:1.0f];
        [self setTransform:CGAffineTransformMakeScale(1.0f, 1.0f)];
        
        PKNSelectionTableView *stv = (PKNSelectionTableView*)self.selectionTableView;
        
        [stv setSemiExistentCells:[stv.semiExistentCells arrayByRemovingObject:self]];
    }
    
    //NSLog(@"semiExistent: %c x: %f y: %f width: %f height: %f", self.semiExistent, self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);

}

- (void)setText:(NSString *)text
{
    _textLabel.text = text;
    _text = text;
}

- (void)setTextDisabled:(BOOL)textDisabled
{
    _textDisabled = textDisabled;
    if (textDisabled) {
        [self.textLabel removeFromSuperview];
    }else{
        [self addSubview:self.textLabel];
    }
    //NSLog(@"setTextDisabled");
}

- (void)setIcon:(UIImage *)icon
{
    self.iconIsNotLoaded = (icon)? NO : YES;
    _icon = icon;
    
    //set image to loading icon if icon is nil
    UIImage *displayedImage = (self.iconIsNotLoaded)? self.loadingIcon : icon;
    [self.iconView setImage:displayedImage];
}

- (void)setHighlightedIcon:(UIImage *)highlightedIcon
{
    _highlightedIcon = highlightedIcon;
    
    //set highlightedImage to generated highlightedImage if highlightedIcon is nil
    UIImage *displayedHighlightedImage = (highlightedIcon)? highlightedIcon : [self highlightedImageFromImage:self.icon];
    [self.iconView setHighlightedImage:displayedHighlightedImage];
    NSLog(@"setHighlightedIcon:%@", highlightedIcon);
}

- (void)setIcon:(UIImage *)icon highlightedIcon:(UIImage *)highlightedIcon
{
    self.icon = icon;
    self.highlightedIcon = highlightedIcon;
}


- (void)setLoadingIcon:(UIImage *)loadingIcon
{
    _loadingIcon = loadingIcon;
    if (self.iconIsNotLoaded) {
        UIImage *displayedImage = (self.icon)? self.icon : self.loadingIcon;
        [self.iconView setImage:displayedImage];
    }
}

- (void)setEditing:(BOOL)editing
{
    _editing = editing;
    [self.deleteButton setHidden:!editing];
}

#pragma mark - Methods

- (UIImage *)highlightedImageFromImage:(UIImage *)image
{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [[CIImage alloc] initWithImage:image]; //your input image
    
    CIFilter *filter= [CIFilter filterWithName:@"CIColorControls"];
    [filter setValue:inputImage forKey:@"inputImage"];
    [filter setValue:[NSNumber numberWithFloat:-0.3] forKey:@"inputBrightness"];
    [filter setValue:[NSNumber numberWithFloat:0.4] forKey:@"inputContrast"];
    [filter setValue:[NSNumber numberWithFloat:1.6] forKey:@"inputSaturation"];
    
    UIImage *outputImage = [UIImage imageWithCGImage:[context createCGImage:filter.outputImage fromRect:filter.outputImage.extent]];
    
    return outputImage;
}

- (void)deleteSelf
{
    [self.selectionTableView removeCell:self animated:YES];
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
