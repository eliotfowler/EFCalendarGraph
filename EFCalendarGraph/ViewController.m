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

@interface ViewController ()

@property (nonatomic, strong) EFCalendarGraph *calendarGraph;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    self.calendarGraph = [[EFCalendarGraph alloc] initForAutoLayout];
    [self.view addSubview:self.calendarGraph];
    [self.calendarGraph autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.calendarGraph autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.calendarGraph autoSetDimension:ALDimensionHeight toSize:120];
    [self.calendarGraph autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.view];
}

@end
