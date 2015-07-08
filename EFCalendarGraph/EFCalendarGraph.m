//
//  EFCalendarGraph.m
//  EFCalendarGraph
//
//  Created by Eliot Fowler on 7/6/15.
//
//

#import "EFCalendarGraph.h"
#import "NSDate+Utilities.h"

const CGFloat EFCalendarGraphMinBoxSideLength = 3;
const CGFloat EFCalendarGraphInterBoxMargin = 1;
const NSInteger EFCalendarGraphDaysInWeek = 7;

@interface EFCalendarGraph ()

// Public properties
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, assign) CGFloat borderWidth;

// Private properties
@property (nonatomic, strong) NSArray *values;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, strong) NSArray *dataByColumns;

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

- (void)initialize
{
    // Fake Data
    NSMutableArray *values = [NSMutableArray array];
    for (int i = 0; i < 365; i++)
    {
        [values addObject:@(arc4random() % 5)];
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
    self.backgroundColor = [UIColor lightGrayColor];
    self.borderColor = [UIColor blackColor];
    self.borderWidth = 2;
    self.startDate = [NSDate new];
}

- (void)drawRect:(CGRect)rect
{
    [self drawBoxes];
}

#pragma mark - Drawing

- (void)drawBoxes
{
    for (int i = 0; i < self.dataByColumns.count; i++)
    {
        for (int j = 0; j < EFCalendarGraphDaysInWeek; j++)
        {
            NSInteger value = [self.dataByColumns[i][j] integerValue];
            if (value > 0)
            {
                CGRect boxFrame = [self rectForBoxWithDaysAfterStartDate:i * EFCalendarGraphDaysInWeek + j];
                CGFloat alpha = value * .1 + .1;
                [[UIColor colorWithRed:0 green:1 blue:0 alpha:alpha] setFill];
                UIRectFillUsingBlendMode(boxFrame, kCGBlendModeNormal);
            }
            else
            {
                CGRect boxFrame = [self rectForBoxWithDaysAfterStartDate:i * EFCalendarGraphDaysInWeek + j];
                [[UIColor colorWithRed:.9 green:.9 blue:.9 alpha:.5] setFill];
                UIRectFillUsingBlendMode(boxFrame, kCGBlendModeNormal);
            }
        }
    }
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
    return (daysAfterStartDate + startDateWeekOffset) / EFCalendarGraphDaysInWeek;
}

- (NSInteger)rowForDaysAfterStartDate:(NSInteger)daysAfterStartDate
{
    NSDate *rowDate = [self.startDate dateByAddingDays:daysAfterStartDate];
    
    // 1 is Sunday and I want 0 to be Sunday
    return rowDate.weekday;
}

#pragma mark - Read-only property getters

- (CGRect)frameForViewInBounds
{
    CGFloat width = self.minWidth;
    CGFloat height = self.minHeight;
    CGFloat x = 0;
    CGFloat y = 0;
    
    if (width > height && width < CGRectGetWidth(self.bounds))
    {
        width = CGRectGetWidth(self.bounds);
        CGFloat boxWidth = (width -
                            EFCalendarGraphInterBoxMargin * (self.columns - 1) -
                            self.borderWidth * 2) / self.columns;
        height = 2 * self.borderWidth +
        EFCalendarGraphDaysInWeek * boxWidth +
        (self.rows - 1) * EFCalendarGraphInterBoxMargin;
    }
    else if (height > width && height < CGRectGetHeight(self.bounds))
    {
        NSAssert(false, @"Bad");
        CGFloat heightDifference = CGRectGetHeight(self.bounds) - height;
        height += heightDifference;
        CGFloat boxHeight = (height -
                             (EFCalendarGraphDaysInWeek - 1) * EFCalendarGraphInterBoxMargin -
                             self.borderWidth * 2) / self.rows;
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

- (CGSize)boxSize
{
    CGRect frame = self.frameForViewInBounds;
    CGFloat width = (CGRectGetWidth(frame) -
                    EFCalendarGraphInterBoxMargin * (self.columns - 1) -
                    self.borderWidth * 2) / self.columns;
    CGFloat height = (CGRectGetHeight(frame) -
                     (self.rows - 1) * EFCalendarGraphInterBoxMargin -
                     self.borderWidth * 2) / self.rows;
    
    NSAssert(width == height, @"Box should be square");
    
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
    for (int i = ((int)self.dataByColumns.count - 1); i >= 0; i--)
    {
        for (int j = EFCalendarGraphDaysInWeek - 1; j >= 0; j--)
        {
            if ([self.dataByColumns[i][j] integerValue] > 0)
            {
                return [self columnForDaysAfterStartDate:i * EFCalendarGraphDaysInWeek + j] + 1;
            }
        }
    }
    
    return -1;
}

- (NSInteger)rows
{
    return EFCalendarGraphDaysInWeek;
}

@end
