EFCalendarGraph
===============

Demo
----

This code:

~~~objectivec    
- (void)viewDidLoad
{
	EFCalendarGraph *calendarGraph = [[EFCalendarGraph alloc] initWithEndDate:[NSDate new]];
	self.calendarGraph.dataSource = self;
	[self.view addSubview:calendarGraph];
	self.calendarGraph.frame = CGRectMake(20, CGRectGetHeight(self.view.bounds)/2 - 60, CGRectGetWidth(self.view.bounds) - 40, 120);
	
	[self.calendarGraph reloadData];
}

- (NSUInteger)numberOfDataPointsInCalendarGraph:(EFCalendarGraph *)calendarGraph
{
    return 14;
}

-(id)calendarGraph:(EFCalendarGraph *)calendarGraph
      valueForDate:(NSDate *)date
daysAfterStartDate:(NSUInteger)daysAfterStartDate
 daysBeforeEndDate:(NSUInteger)daysBeforeEndDate
{
    return @[@0, @1, @2, @3, @4, @5, @6, @0, @1, @2, @3, @4, @5, @6];
}

~~~

will produce this:

![14 Days Calendar Graph](https://github.com/eliotfowler/EFCalendarGraph/blob/master/Images/14Days.png)

or with 365 days:

![365 Days Calendar Graph](https://github.com/eliotfowler/EFCalendarGraph/blob/master/Images/365Days.png)

Also, note that I am uploading this on a Monday. Since we are setting this up with an end date `initWithEndDate...`, you'll see the last box is the second from the top. The days start with Sunday at the top and each day follows normally. This will be configurable in the future.

Installation
------------

Until the first CocoaPods release, clone the project and copy the EFCalendarGraph/NSDate+Utilities.{h,m} files into your project.

Options
---------------


