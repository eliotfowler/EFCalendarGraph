//
//  EFCalendarGraph.h
//  EFCalendarGraph
//
//  Created by Eliot Fowler on 7/6/15.
//
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface EFCalendarGraph : UIView

@property (nonatomic, strong) NSArray *values;
@property (nonatomic, strong) NSDate *startDate;

- (instancetype)initWithStartDate:(NSDate *)startDate data:(NSArray *)data;
- (instancetype)initWithEndDate:(NSDate *)endDate data:(NSArray *)data;

@end
