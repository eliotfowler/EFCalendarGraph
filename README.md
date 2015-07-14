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
    return arc4random() % 2 == 0 ? @0 : @(arc4random() % 5;
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

Important Methods
-----------------

It's important to note that after changing any of the options or your data, you should call `[calendarGraph reloadData]`.

DataSource
----------

The EFCalendarGraphDataSource protocol defines 2 required methods that allow it to present your data:

`- (NSUInteger)numberOfDataPointsInCalendarGraph:(EFCalendarGraph *)calendarGraph`

This is very self explanatory, just return the number of squares that you want to show. This is important because it is how the view decides how big the boxes can be and still fit inside its bounds.

```
- (id)calendarGraph:(EFCalendarGraph *)calendarGraph
       valueForDate:(NSDate *)date
 daysAfterStartDate:(NSUInteger)daysAfterStartDate
  daysBeforeEndDate:(NSUInteger)daysBeforeEndDate;
```

This is the method where you will return the data points for each square when requested. **The return type says `id`, but is currently only accepting `NSNumber`.** In the future, I would like to support accepting any `id` and optinally delegating to the user to determine the denomination.

Options
-------

###Properties (default)

####EFCalendarGraphSquareModifier squareModifier (EFCalendarGraphSquareModifierAlpha)

Currently the only value, setting this to EFCalendarGraphSquareModifierAlpha will cause variance in value to change the alpha of each of the boxes.

####NSArray *modifierDenominations (@[@.3, @.4, @.5, @.6, @.7, @.9])

Seemingly random, but this set of numbers seems to work fairly well for most data sets that I've encountered so far. You can set this array to any set of numbers between 0 and 1. It does not have to be 6 numbers either, you can have as many or as few as you want.

####UIColor *baseColor ([UIColor greenColor])

This is the color that will fill the squares.

####UIColor *zeroColor ([UIColor colorWithRed:.9 green:.9 blue:.9 alpha:.5])

This is the color that the boxes will be when the value for the box is 0.

License (MIT)
-------------

Copyright (c) 2015 Eliot Fowler

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.