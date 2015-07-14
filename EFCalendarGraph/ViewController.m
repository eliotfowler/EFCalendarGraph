//
//  ViewController.m
//  EFCalendarGraph
//
//  Created by Eliot Fowler on 7/6/15.
//
//

#import "ViewController.h"
#import "EFCalendarGraph.h"
#import "PureLayout.h"
#import "NSDate+Utilities.h"

@interface ViewController () <EFCalendarGraphDataSource>

@property (nonatomic, strong) EFCalendarGraph *calendarGraph;
@property (nonatomic, strong) NSArray *values;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Fake Data
    NSMutableArray *values = [NSMutableArray array];
    for (int i = 0; i < 365; i++)
    {
        [values addObject:arc4random() % 2 == 0 ? @0 : @(arc4random() % 5)];
    }
    self.values = values;

    NSDate *endDate = [NSDate new];
    
    self.calendarGraph = [[EFCalendarGraph alloc] initWithEndDate:endDate];
    self.calendarGraph.dataSource = self;
    self.calendarGraph.baseColor = [UIColor blueColor];
    self.calendarGraph.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.calendarGraph];
    [self.calendarGraph autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20];
    [self.calendarGraph autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20];
    [self.calendarGraph autoSetDimension:ALDimensionHeight toSize:120];
    [self.calendarGraph autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.view];
    
    [self.calendarGraph reloadData];
}

#pragma mark - EFCalendarGraph Data Source

- (NSUInteger)numberOfDataPointsInCalendarGraph:(EFCalendarGraph *)calendarGraph
{
    return self.values.count;
}

-(id)calendarGraph:(EFCalendarGraph *)calendarGraph
      valueForDate:(NSDate *)date
daysAfterStartDate:(NSUInteger)daysAfterStartDate
 daysBeforeEndDate:(NSUInteger)daysBeforeEndDate
{
    return self.values[daysAfterStartDate];
}

@end
