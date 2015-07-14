//
//  EFCalendarGraph.h
//  EFCalendarGraph
//
//  Created by Eliot Fowler on 7/6/15.
//
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, EFCalendarGraphSquareModifier) {
    EFCalendarGraphSquareModifierAlpha = 0,
    EFCalendarGraphSquareModifierColor
};

@protocol EFCalendarGraphDataSource;

IB_DESIGNABLE
@interface EFCalendarGraph : UIView

@property (nonatomic, weak) id<EFCalendarGraphDataSource> dataSource;
@property (nonatomic, assign) EFCalendarGraphSquareModifier squareModifier;
@property (nonatomic, strong) NSArray *modifierDenominations;
@property (nonatomic, strong) UIColor *baseColor;
@property (nonatomic, strong) UIColor *zeroColor;

- (instancetype)initWithStartDate:(NSDate *)startDate;
- (instancetype)initWithEndDate:(NSDate *)endDate;

- (void)reloadData;

@end

@protocol EFCalendarGraphDataSource <NSObject>

- (NSUInteger)numberOfDataPointsInCalendarGraph:(EFCalendarGraph *)calendarGraph;

- (id)calendarGraph:(EFCalendarGraph *)calendarGraph
       valueForDate:(NSDate *)date
 daysAfterStartDate:(NSUInteger)daysAfterStartDate
  daysBeforeEndDate:(NSUInteger)daysBeforeEndDate;

@end
