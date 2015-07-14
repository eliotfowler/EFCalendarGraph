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

