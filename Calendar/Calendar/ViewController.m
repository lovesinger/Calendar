//
//  ViewController.m
//  Calendar
//
//  Created by 许立强 on 2019/8/30.
//  Copyright © 2019 xlq. All rights reserved.
//

#import "ViewController.h"
#import "NSDate+EXCalendar.h"
#import "EXCustomCalendarView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    
    EXCustomCalendarView* view = [[EXCustomCalendarView alloc]initWithFrame:CGRectMake(30, 100, EX_SCREEN_WIDTH-30*2, 24+15+20+40*6+10+20+10)];
    [self.view addSubview:view];
    
    
    [view updateCalendarViewWithArrangeDates:@[@"2019-02-20", @"2019-07-21", @"2019-07-22", @"2019-08-03"] andStartDates:@[@"2019-08-10", @"2019-08-12", @"2019-08-13", @"2019-08-14", @"2019-08-16"] andRemoveDates:@[@"2019-08-22", @"2019-08-23", @"2019-08-24", @"2019-08-25"]];
    
    
}


@end
