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

@interface ViewController ()

@property (nonatomic, strong) EFCalendarGraph *calendarGraph;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Fake Data
    NSMutableArray *values = [NSMutableArray array];
    for (int i = 0; i < 30; i++)
    {
        [values addObject:arc4random() % 2 == 0 ? @0 : @(arc4random() % 5)];
    }

    NSDate *startDate = [NSDate new];
    
    self.calendarGraph = [[EFCalendarGraph alloc] initWithStartDate:startDate data:[values copy]];
    self.calendarGraph.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.calendarGraph];
    [self.calendarGraph autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20];
    [self.calendarGraph autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20];
    [self.calendarGraph autoSetDimension:ALDimensionHeight toSize:120];
    [self.calendarGraph autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.view];

//    UIView *line = [UIView newAutoLayoutView];
//    line.backgroundColor = [UIColor greenColor];
//    [self.view addSubview:line];
//    [line autoAlignAxis:ALAxisVertical toSameAxisOfView:self.view];
//    [line autoSetDimension:ALDimensionWidth toSize:2];
//    [line autoPinEdgeToSuperviewEdge:ALEdgeTop];
//    [line autoPinEdgeToSuperviewEdge:ALEdgeBottom];
}

@end
