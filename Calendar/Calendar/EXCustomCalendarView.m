//
//  EXCustomCalendarView.m
//  test
//
//  Created by 许立强 on 2019/8/22.
//  Copyright © 2019 xlq. All rights reserved.
//

#import "EXCustomCalendarView.h"
#import "NSDate+EXCalendar.h"
#import "EXCustomCalendarCell.h"
#import "YYKit.h"


@interface EXCustomCalendarView ()<UICollectionViewDelegate, UICollectionViewDataSource>{
    UIView* _titleView;
    UILabel* _titleLabel;
    UIButton* _leftBtn;
    UIButton* _rightBtn;
    UIView* _weekView;
    
    CGFloat _itemWidth;
    CGFloat _leftMargin;
    NSString* _dateFormat;
}

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger selectIndex;  //当前索引
@property (nonatomic, copy) NSArray *showArr;   //当前显示的数据数组
@property (nonatomic, copy) NSString *minDateStr;    //最小日期
@property (nonatomic, strong) YYLabel *markLabel;   //标识

@end

@implementation EXCustomCalendarView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self configDatas];
        [self configSubviews];

        
    }
    return self;
}

#pragma mark - data
-(void)configDatas{
    _itemWidth = floor(self.width/7.f);
    _leftMargin = (self.width-_itemWidth*7)/2.f;
    self.dataSource = [NSMutableArray array];
    self.showArr = @[];
    _dateFormat = @"yyyy-MM-dd";

}

-(void)updateCalendarViewWithArrangeDates:(NSArray<NSString*>*)arrangeDates andStartDates:(NSArray<NSString*>*)startDates andRemoveDates:(NSArray<NSString*>*)removeDates{
    NSMutableArray* arrangeArr = [NSMutableArray arrayWithArray:arrangeDates];
    NSMutableArray* startArr = [NSMutableArray arrayWithArray:startDates];
    NSMutableArray* removeArr = [NSMutableArray arrayWithArray:removeDates];
    
    NSMutableArray* allDates = [NSMutableArray arrayWithArray:arrangeDates];
    [allDates addObjectsFromArray:startDates];
    [allDates addObjectsFromArray:removeDates];
    NSArray* minAndMaxArr = [NSDate getMaxDateAndMinDateWithDateArr:allDates andDateFormat:_dateFormat];
    NSString* minDateStr = minAndMaxArr[0];
    NSString* maxDateStr = minAndMaxArr[1];
    NSInteger arrCount = [NSDate computeMonthsWithStartDate:minDateStr andEndDate:maxDateStr andDateFormat:_dateFormat]+1;
    
    [self.dataSource removeAllObjects];
    for (NSInteger i = 0; i < arrCount; i++) {
        NSMutableArray* array = [NSMutableArray array];
        [self.dataSource addObject:array];
    }
    
    for (NSInteger i = 0; i < arrCount; i++) {
        NSString* currentDateStr = [NSDate getDestinationDateFromDate:minDateStr andMonth:i andDateFormat:_dateFormat];
        NSDate* currentDate = [NSDate convertDateStringToDate:currentDateStr andDateFormat:_dateFormat];
        //获取该月第一天星期几
        NSInteger firstDayInThisMounth = [NSDate firstWeekdayInThisMonth:currentDate];
        //获取该月一共多少天
        NSInteger totalDays = [NSDate totaldaysInThisMonth:currentDate];
        //筛选出属于当前月份的日期
        NSArray* destArrangeArr = [NSDate filterSameMonthDateWithDateArr:arrangeArr andDestinationDate:currentDateStr andDateFormat:_dateFormat];
        NSArray* destStartArr = [NSDate filterSameMonthDateWithDateArr:startArr andDestinationDate:currentDateStr andDateFormat:_dateFormat];
        NSArray* destRemoveArr = [NSDate filterSameMonthDateWithDateArr:removeArr andDestinationDate:currentDateStr andDateFormat:_dateFormat];
        //把属于当前月份的日期从总日期数组中移除
        [arrangeArr removeObjectsInArray:destArrangeArr];
        [startArr removeObjectsInArray:destStartArr];
        [removeArr removeObjectsInArray:destRemoveArr];
        //把属于当前月份的日期转换成model
        destArrangeArr = [self converseDestinationDateToModel:destArrangeArr andDateType:EXCalendarDateType_arrange andTotalDateArr:arrangeDates];
        destStartArr = [self converseDestinationDateToModel:destStartArr andDateType:EXCalendarDateType_start andTotalDateArr:startDates];
        destRemoveArr = [self converseDestinationDateToModel:destRemoveArr andDateType:EXCalendarDateType_remove andTotalDateArr:removeDates];
        
        for (NSInteger j = 0; j < 6*7; j++) {
            EXCustomCalendarCellModel* model = [EXCustomCalendarCellModel new];
            model.cellType = EXCalendarCellType_common;
            
            if (j < firstDayInThisMounth || j > totalDays+firstDayInThisMounth-1) {
                model.text = @"";
            }else{
                model.text = [NSString stringWithFormat:@"%ld", j-firstDayInThisMounth+1];
            }
            [[self.dataSource objectAtIndex:i] addObject:model];
        }
        
        for (EXCustomCalendarCellModel* model in destArrangeArr) {
            [[self.dataSource objectAtIndex:i] replaceObjectAtIndex:model.text.integerValue+firstDayInThisMounth-1 withObject:model];
        }
        for (EXCustomCalendarCellModel* model in destStartArr) {
            [[self.dataSource objectAtIndex:i] replaceObjectAtIndex:model.text.integerValue+firstDayInThisMounth-1 withObject:model];
        }
        for (EXCustomCalendarCellModel* model in destRemoveArr) {
            [[self.dataSource objectAtIndex:i] replaceObjectAtIndex:model.text.integerValue+firstDayInThisMounth-1 withObject:model];
        }
        
    }
    
    self.selectIndex = 0;
    self.minDateStr = minDateStr;
    [self refreshBtnState];
    
}

-(NSArray<EXCustomCalendarCellModel*>*)converseDestinationDateToModel:(NSArray<NSString*>*)dateArr andDateType:(EXCalendarDateType)dateType andTotalDateArr:(NSArray<NSString*>*)totalDateArr{
    NSMutableArray* modelArr = [NSMutableArray array];
    
    for (NSString* dateStr in dateArr) {
        NSDate* date = [NSDate convertDateStringToDate:dateStr andDateFormat:_dateFormat];
        EXCustomCalendarCellModel* model = [EXCustomCalendarCellModel new];
        model.dateType = dateType;
        NSDateComponents* comps = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:date];
        model.text = [NSString stringWithFormat:@"%ld", comps.day];
        
        //计算dateStr的前一天和后一天日期
        NSCalendar* currentCalendar = [NSCalendar currentCalendar];
        NSDateComponents* dateComps = [[NSDateComponents alloc]init];
        [dateComps setDay:-1];
        NSDate* lastDate = [currentCalendar dateByAddingComponents:dateComps toDate:date options:0];
        NSString* lastDateStr = [NSDate convertDateToDateString:lastDate andDateFormat:_dateFormat];
        [dateComps setDay:1];
        NSDate* nextDate = [currentCalendar dateByAddingComponents:dateComps toDate:date options:0];
        NSString* nextDateStr = [NSDate convertDateToDateString:nextDate andDateFormat:_dateFormat];
        
        //计算date是星期几
        NSInteger weekday = [NSDate weekdayOfDestinationDate:date];
        //计算date，当月的第一天日期
        NSString* firstDay = [NSDate convertDateToDateString:[NSDate getFirstDayofThisMonthWithDate:date] andDateFormat:_dateFormat];
        //计算date，当月的最后一天日期
        NSString* lastDay = [NSDate convertDateToDateString:[NSDate getLastDayOfThisMonthWithDate:date andDateFormat:_dateFormat] andDateFormat:_dateFormat];

        if ([totalDateArr containsObject:lastDateStr] && [totalDateArr containsObject:nextDateStr]) {
            //中间点（前后都有日期）
            if (weekday == 6 || [dateStr isEqualToString:lastDay]) {
                model.cellType = EXCalendarCellType_rectangleAndRightCorner;
            }else if (weekday == 0 || [dateStr isEqualToString:firstDay]){
                model.cellType = EXCalendarCellType_rectangleAndLeftCorner;
            }else{
                model.cellType = EXCalendarCellType_rectangle;
            }
        }else if (![totalDateArr containsObject:lastDateStr] && ![totalDateArr containsObject:nextDateStr]){
            //孤点 (前后都没有日期)
            model.cellType = EXCalendarCellType_circle;
        }else if (![totalDateArr containsObject:lastDateStr] && [totalDateArr containsObject:nextDateStr]){
            //起点（只有后面有日期）
            if (weekday == 6 || [dateStr isEqualToString:lastDay]) {
                model.cellType = EXCalendarCellType_circle;
            }else{
                model.cellType = EXCalendarCellType_circleAndRightRectangle;
            }
        }else if ([totalDateArr containsObject:lastDateStr] && ![totalDateArr containsObject:nextDateStr]){
            //终点（只有前面有日期）
            if (weekday == 0 || [dateStr isEqualToString:firstDay]) {
                model.cellType = EXCalendarCellType_circle;
            }else{
                model.cellType = EXCalendarCellType_circleAndLeftRectangle;
            }
        }
        
        
        [modelArr addObject:model];
    }
    
    return modelArr;
}

#pragma mark - init
-(void)configSubviews{
    [self configTitleView];
    [self configWeekView];
    [self addSubview:self.collectionView];
    [self addSubview:self.markLabel];
}

-(void)configTitleView{
    _titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 24)];
    [self addSubview:_titleView];
    
    _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftBtn.frame = CGRectMake(0, 0, _leftMargin*2+_itemWidth, _titleView.height);
    [_leftBtn addTarget:self action:@selector(clickLeftBtn) forControlEvents:UIControlEventTouchUpInside];
    [_titleView addSubview:_leftBtn];
    
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBtn.frame = CGRectMake(self.width-_leftBtn.width, 0, _leftBtn.width, _titleView.height);
    [_rightBtn addTarget:self action:@selector(clickRightBtn) forControlEvents:UIControlEventTouchUpInside];
    [_titleView addSubview:_rightBtn];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(_leftBtn.right+10, 0, _rightBtn.left-_leftBtn.right-10-10, _titleView.height)];
    _titleLabel.textColor = COLOR_HEX(0x333333);
    _titleLabel.font = EX_PING_MEDIUM(18);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_titleView addSubview:_titleLabel];
    
}

-(void)configWeekView{
    _weekView = [[UIView alloc]initWithFrame:CGRectMake(0, _titleView.bottom+15, self.width, 20)];
    [self addSubview:_weekView];
    
    NSArray* weekArr = @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"];
    for (NSInteger i = 0; i < 7; i++) {
        UILabel* weekLabel = [[UILabel alloc]initWithFrame:CGRectMake(_leftMargin+_itemWidth*i, 0, _itemWidth, _weekView.height)];
        weekLabel.textColor = COLOR_HEX(0x626B82);
        weekLabel.font = EX_PING_MEDIUM(12);
        weekLabel.text = weekArr[i];
        weekLabel.textAlignment = NSTextAlignmentCenter;
        [_weekView addSubview:weekLabel];
    }
    
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.itemSize = CGSizeMake(_itemWidth, 40);
        layout.sectionInset = UIEdgeInsetsMake(0, _leftMargin, 0, _leftMargin);
        
        _collectionView = [[UICollectionView alloc] initWithFrame: CGRectMake(0, _weekView.bottom, self.width, 6*40) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[EXCustomCalendarCell class] forCellWithReuseIdentifier:NSStringFromClass(EXCustomCalendarCell.class)];
    }
    return _collectionView;
}

-(YYLabel *)markLabel{
    if (!_markLabel) {
        _markLabel = [[YYLabel alloc]initWithFrame:CGRectMake(0, self.collectionView.bottom+10, self.width, 20)];
        
        UIView* purpleCircle = [[UIView alloc]initWithFrame:CGRectMake(0, (_markLabel.height-7)/2.f, 7, 7)];
        purpleCircle.backgroundColor = COLOR_HEX(0x9780FF);
        purpleCircle.layer.cornerRadius = purpleCircle.width/2.f;
        
        UIView* blueCircle = [[UIView alloc]initWithFrame:CGRectMake(0, (_markLabel.height-7)/2.f, 7, 7)];
        blueCircle.backgroundColor = COLOR_HEX(0x3C7AFF);
        blueCircle.layer.cornerRadius = blueCircle.width/2.f;
        
        UIView* yellowCircle = [[UIView alloc]initWithFrame:CGRectMake(0, (_markLabel.height-7)/2.f, 7, 7)];
        yellowCircle.backgroundColor = COLOR_HEX(0xFFCF39);
        yellowCircle.layer.cornerRadius = yellowCircle.width/2.f;
        
        NSMutableAttributedString* str = [NSMutableAttributedString attachmentStringWithContent:purpleCircle contentMode:UIViewContentModeCenter attachmentSize:purpleCircle.size alignToFont:EX_PING_REGULAR(14) alignment:YYTextVerticalAlignmentCenter];
        [str appendString:@" 布展日期    "];
        [str appendAttributedString:[NSAttributedString attachmentStringWithContent:blueCircle contentMode:UIViewContentModeCenter attachmentSize:blueCircle.size alignToFont:EX_PING_REGULAR(14) alignment:YYTextVerticalAlignmentCenter]];
        [str appendString:@" 展会日期    "];
        [str appendAttributedString:[NSAttributedString attachmentStringWithContent:yellowCircle contentMode:UIViewContentModeCenter attachmentSize:yellowCircle.size alignToFont:EX_PING_REGULAR(14) alignment:YYTextVerticalAlignmentCenter]];
        [str appendString:@" 撤展日期"];
        _markLabel.attributedText = str;
        
        _markLabel.textAlignment = NSTextAlignmentCenter;
        _markLabel.font = EX_PING_REGULAR(14);
        _markLabel.textColor = COLOR_HEX(0x6C7381);

    }
    return _markLabel;
}

#pragma mark - UICollectionView
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.showArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    EXCustomCalendarCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(EXCustomCalendarCell.class) forIndexPath:indexPath];
    if (self.showArr.count > indexPath.item) {
        [cell loadDataWithModel:self.showArr[indexPath.item]];
    }
    return cell;
}

#pragma mark - event
-(void)clickLeftBtn{
    self.selectIndex--;
    [self refreshBtnState];
}

-(void)clickRightBtn{
    self.selectIndex++;
    [self refreshBtnState];
}

-(void)refreshBtnState{
    if (self.selectIndex == 0) {
        [_leftBtn setImage:[UIImage imageNamed:@"calendar_leftarrow_gray"] forState:UIControlStateNormal];
        _leftBtn.userInteractionEnabled = NO;
    }else{
        [_leftBtn setImage:[UIImage imageNamed:@"calendar_leftarrow_blue"] forState:UIControlStateNormal];
        _leftBtn.userInteractionEnabled = YES;
    }
    
    if (self.selectIndex == self.dataSource.count-1) {
        [_rightBtn setImage:[UIImage imageNamed:@"calendar_rightarrow_gray"] forState:UIControlStateNormal];
        _rightBtn.userInteractionEnabled = NO;
    }else{
        [_rightBtn setImage:[UIImage imageNamed:@"calendar_rightarrow_blue"] forState:UIControlStateNormal];
        _rightBtn.userInteractionEnabled = YES;
    }
    
    self.showArr = self.dataSource[self.selectIndex];
    [self.collectionView reloadData];
    
    NSString* currentDateStr = [NSDate getDestinationDateFromDate:self.minDateStr andMonth:self.selectIndex andDateFormat:_dateFormat];
    NSDateComponents* components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:[NSDate convertDateStringToDate:currentDateStr andDateFormat:_dateFormat]];
    _titleLabel.text = [NSString stringWithFormat:@"%ld年  %ld月", (long)components.year, (long)components.month];
    
}



@end
