//
//  EXCustomCalendarView.h
//  test
//
//  Created by 许立强 on 2019/8/22.
//  Copyright © 2019 xlq. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EXCustomCalendarView : UIView



/**
 更新日历的方法

 @param arrangeDates 布展日期
 @param startDates 开展日期
 @param removeDates 撤展日期
 */
-(void)updateCalendarViewWithArrangeDates:(NSArray<NSString*>*)arrangeDates andStartDates:(NSArray<NSString*>*)startDates andRemoveDates:(NSArray<NSString*>*)removeDates;



@end

NS_ASSUME_NONNULL_END
