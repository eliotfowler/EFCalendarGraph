//
//  EFCalendarGraph.m
//  EFCalendarGraph
//
//  Created by Eliot Fowler on 7/6/15.
//
//

#import "EFCalendarGraph.h"
#import "NSDate+Utilities.h"

const CGFloat EFCalendarGraphMinBoxSideLength = 1;
const CGFloat EFCalendarGraphInterBoxMargin = 1;
const NSInteger EFCalendarGraphDaysInWeek = 7;

@interface EFCalendarGraph ()

// Public properties
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, assign) CGFloat borderWidth;

// Private properties
@property (nonatomic, strong) NSArray *values;
@property (nonatomic, strong) NSArray *layers;
@property (nonatomic, strong) NSArray *dataByColumns;
@property (nonatomic, strong) NSArray *layersByColumns;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;

@property (nonatomic, assign, readonly) CGFloat minWidth;
@property (nonatomic, assign, readonly) CGFloat minHeight;
@property (nonatomic, assign, readonly) CGRect frameForViewInBounds;
@property (nonatomic, assign, readonly) CGSize boxSize;
@property (nonatomic, assign, readonly) NSInteger columns;
@property (nonatomic, assign, readonly) NSInteger rows;

@end

@implementation EFCalendarGraph

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate data:(NSArray *)data
{
    if ((self = [super initWithFrame:CGRectZero]))
    {
        self.values = data;
        self.startDate = startDate;
        self.endDate = endDate;
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    // Fake Data
    NSMutableArray *values = [NSMutableArray array];
    for (int i = 0; i < 365; i++)
    {
        
        [values addObject:arc4random() % 2 == 0 ? @0 : @(arc4random() % 5)];
    }
    self.values = values;
    
    NSMutableArray *columnData = [NSMutableArray array];
    for (int i = 0; i < 52; i++)
    {
        NSMutableArray *rowData = [NSMutableArray array];
        for (int j = 0; j < EFCalendarGraphDaysInWeek; j++)
        {
            [rowData addObject:values[i * EFCalendarGraphDaysInWeek + j]];
        }
        [columnData addObject:rowData];
    }
    self.dataByColumns = columnData;
    
    // Defaults
    self.backgroundColor = [UIColor clearColor];
    self.borderColor = [UIColor blackColor];
    self.borderWidth = 2;
    self.startDate = [NSDate new];
    
    [self createBoxes];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    for (int i = 0; i < self.layers.count; i++)
    {
        CALayer *layer = self.layers[i];
        layer.frame = [self rectForBoxWithDaysAfterStartDate:i];
    }
}

#pragma mark - UI Creation

- (void)createBoxes
{
    NSMutableArray *layers = [NSMutableArray array];
    NSMutableArray *layersByColumns = [NSMutableArray array];
    for (int i = 0; i < self.dataByColumns.count; i++)
    {
        NSMutableArray *column = [NSMutableArray array];
        for (int j = 0; j < EFCalendarGraphDaysInWeek; j++)
        {
            CALayer *layer = [CALayer layer];
            CGRect boxFrame = [self rectForBoxWithDaysAfterStartDate:i * EFCalendarGraphDaysInWeek + j];
            layer.frame = boxFrame;
            
            NSInteger value = [self.dataByColumns[i][j] integerValue];
            if (value > 0)
            {
                CGFloat alpha = value * .1 + .1;
                layer.backgroundColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:alpha].CGColor;
            }
            else
            {
                layer.backgroundColor = [UIColor colorWithRed:.9 green:.9 blue:.9 alpha:.5].CGColor;
            }
            [self.layer addSublayer:layer];
            [layers addObject:layer];
            [column addObject:layer];
        }
        [layersByColumns addObject:column];
    }
    
    self.layers = [layers copy];
    self.layersByColumns = [layersByColumns copy];
}

#pragma mark - Helpers

- (CGRect)rectForBoxWithDaysAfterStartDate:(NSInteger)daysAfterStartDate
{
    CGRect frame = self.frameForViewInBounds;
    NSInteger column = [self columnForDaysAfterStartDate:daysAfterStartDate];
    NSInteger row = [self rowForDaysAfterStartDate:daysAfterStartDate];
    CGFloat x = CGRectGetMinX(frame) +
                self.boxSize.width * column +
                EFCalendarGraphInterBoxMargin * column +
                self.borderWidth;
    NSLog(@"%f", CGRectGetMinY(frame));
    CGFloat y = CGRectGetMinY(frame) +
                self.boxSize.height * row +
                EFCalendarGraphInterBoxMargin * row +
                self.borderWidth;
    return CGRectMake(x, y, self.boxSize.width, self.boxSize.height);
}

- (NSInteger)columnForDaysAfterStartDate:(NSInteger)daysAfterStartDate
{
    // 1 is Sunday and I want 0 to be Sunday
    NSInteger startDateWeekOffset = self.startDate.weekday - 1;
    return (daysAfterStartDate + startDateWeekOffset) / EFCalendarGraphDaysInWeek - 1;
}

- (NSInteger)rowForDaysAfterStartDate:(NSInteger)daysAfterStartDate
{
    NSDate *rowDate = [self.startDate dateByAddingDays:daysAfterStartDate];
    
    // 1 is Sunday and I want 0 to be Sunday
    return rowDate.weekday - 1;
}

#pragma mark - Read-only property getters

- (CGRect)frameForViewInBounds
{
    if (CGRectEqualToRect(self.bounds, CGRectZero))
    {
        return CGRectZero;
    }
    
    CGFloat width = self.minWidth;
    CGFloat height = self.minHeight;
    CGFloat x = 0;
    CGFloat y = 0;
    
    if (width > height && width < CGRectGetWidth(self.bounds))
    {
        width = CGRectGetWidth(self.bounds);
        CGFloat boxWidth = [self boxWidthBasedOnBoundsWidth:width];
        height = 2 * self.borderWidth +
                 EFCalendarGraphDaysInWeek * boxWidth +
                 (self.rows - 1) * EFCalendarGraphInterBoxMargin;
    }
    else if (height > width && height < CGRectGetHeight(self.bounds))
    {
        height = CGRectGetHeight(self.bounds);
        CGFloat boxHeight = [self boxHeightBasedOnBoundsHeight:height];
        width = 2 * self.borderWidth +
                self.dataByColumns.count * boxHeight +
                self.dataByColumns.count - 1 * EFCalendarGraphInterBoxMargin;
    }
    
    // Now that we know for sure that one of the edges is touching its bounds edge,
    // we need to check again if one of the edges is still off so we can center in
    // that dimension
    if (width < CGRectGetWidth(self.bounds))
    {
        CGFloat widthDifference = CGRectGetWidth(self.bounds) - width;
        x = widthDifference/2 - width/2;
    }
    else if (height < CGRectGetHeight(self.bounds))
    {
        CGFloat heightDifference = CGRectGetHeight(self.bounds) - height;
        y = heightDifference/2;
    }
    
    return CGRectMake(x, y, width, height);
}

- (CGFloat)boxWidthBasedOnBoundsWidth:(CGFloat)width
{
    return MAX((width -
                EFCalendarGraphInterBoxMargin * (self.columns - 1) -
                self.borderWidth * 2) / self.columns, EFCalendarGraphMinBoxSideLength);
}

- (CGFloat)boxHeightBasedOnBoundsHeight:(CGFloat)height
{
    return MAX((height -
                EFCalendarGraphInterBoxMargin * (self.rows - 1) -
                self.borderWidth * 2) / self.rows, EFCalendarGraphMinBoxSideLength);
}

- (CGSize)boxSize
{
    CGRect frame = self.frameForViewInBounds;
    CGFloat width = [self boxWidthBasedOnBoundsWidth:CGRectGetWidth(frame)];
    CGFloat height = [self boxHeightBasedOnBoundsHeight:CGRectGetHeight(frame)];

    NSAssert(width == height, @"Box not square; width: %f, height: %f", width, height);
    
    return CGSizeMake(width, height);
}

- (CGFloat)minWidth
{
    return 2 * self.borderWidth +
           self.dataByColumns.count * EFCalendarGraphMinBoxSideLength +
           self.dataByColumns.count - 1 * EFCalendarGraphInterBoxMargin;
}

- (CGFloat)minHeight
{
    return 2 * self.borderWidth +
           EFCalendarGraphDaysInWeek * EFCalendarGraphMinBoxSideLength +
           (EFCalendarGraphDaysInWeek - 1) * EFCalendarGraphInterBoxMargin;
}

- (NSInteger)columns
{
    return [self columnForDaysAfterStartDate:(self.dataByColumns.count - 1) * EFCalendarGraphDaysInWeek + EFCalendarGraphDaysInWeek - 1] + 1;
}

- (NSInteger)rows
{
    return EFCalendarGraphDaysInWeek;
}

@end
