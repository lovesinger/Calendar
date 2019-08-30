//
//  EXCustomCalendarCell.h
//  test
//
//  Created by 许立强 on 2019/8/22.
//  Copyright © 2019 xlq. All rights reserved.
//

#import <UIKit/UIKit.h>

//日期类型
typedef NS_ENUM(NSInteger, EXCalendarDateType){
    EXCalendarDateType_arrange,         //布展日期
    EXCalendarDateType_start,           //开展日期
    EXCalendarDateType_remove           //撤展日期
};

//cell显示样式
typedef NS_ENUM(NSInteger, EXCalendarCellType) {
    EXCalendarCellType_circle,                         //一个圆
    EXCalendarCellType_rectangleAndRightCorner,        //长方形带右边圆角
    EXCalendarCellType_rectangleAndLeftCorner,         //长方形带左边圆角
    EXCalendarCellType_rectangle,                      //长方形
    EXCalendarCellType_circleAndRightRectangle,        //圆和右半边长方形
    EXCalendarCellType_circleAndLeftRectangle,         //圆和左半边长方形
    EXCalendarCellType_common                          //普通
};


@interface EXCustomCalendarCellModel : NSObject

@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) EXCalendarDateType dateType;
@property (nonatomic, assign) EXCalendarCellType cellType;

+(instancetype)createCommonModelWithText:(NSString*)text;


@end


@interface EXCustomCalendarCell : UICollectionViewCell

-(void)loadDataWithModel:(EXCustomCalendarCellModel*)model;



@end

