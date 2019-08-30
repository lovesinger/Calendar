//
//  EXCustomCalendarCell.m
//  test
//
//  Created by 许立强 on 2019/8/22.
//  Copyright © 2019 xlq. All rights reserved.
//

#import "EXCustomCalendarCell.h"


@implementation EXCustomCalendarCellModel
+(instancetype)createCommonModelWithText:(NSString*)text{
    EXCustomCalendarCellModel* model = [EXCustomCalendarCellModel new];
    model.text = text;
    model.cellType = EXCalendarCellType_common;
    
    return model;
}






@end



@interface EXCustomCalendarCell ()

@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIView *backView;


@end


@implementation EXCustomCalendarCell
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.backView];
        [self addSubview:self.dateLabel];
        
    }
    return self;
}

-(void)loadDataWithModel:(EXCustomCalendarCellModel *)model{
    self.dateLabel.text = model.text;
    self.dateLabel.layer.masksToBounds = YES;
    
    switch (model.cellType) {
        case EXCalendarCellType_common:{
            self.dateLabel.backgroundColor = [UIColor clearColor];
            self.dateLabel.layer.cornerRadius = 0;
            self.backView.hidden = YES;
        }
            break;
            
        case EXCalendarCellType_circle:{
            self.dateLabel.layer.cornerRadius = self.dateLabel.width/2.f;
            self.backView.hidden = YES;
            
            switch (model.dateType) {
                case EXCalendarDateType_arrange:{
                    self.dateLabel.backgroundColor = COLOR_HEX(0x9780FF);
                }
                    break;
                    
                case EXCalendarDateType_start:{
                    self.dateLabel.backgroundColor = COLOR_HEX(0x3165EC);
                }
                    break;
                    
                case EXCalendarDateType_remove:{
                    self.dateLabel.backgroundColor = COLOR_HEX(0xFFCF39);
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        case EXCalendarCellType_circleAndLeftRectangle:{
            self.dateLabel.layer.cornerRadius = self.dateLabel.width/2.f;
            self.backView.hidden = NO;
            self.backView.frame = CGRectMake(0, (self.height-30)/2.f, self.width/2.f, 30);
            self.backView.layer.mask = nil;

            switch (model.dateType) {
                case EXCalendarDateType_arrange:{
                    self.dateLabel.backgroundColor = COLOR_HEX(0x9780FF);
                    self.backView.backgroundColor = COLOR_HEX(0xC2B5FE);
                }
                    break;
                    
                case EXCalendarDateType_start:{
                    self.dateLabel.backgroundColor = COLOR_HEX(0x3165EC);
                    self.backView.backgroundColor = COLOR_HEX(0x99B3F5);
                }
                    break;
                    
                case EXCalendarDateType_remove:{
                    self.dateLabel.backgroundColor = COLOR_HEX(0xFFCF39);
                    self.backView.backgroundColor = COLOR_HEX(0xFFEAA8);
                }
                    break;
                    
                default:
                    break;
            }
            
        }
            break;
            
        case EXCalendarCellType_circleAndRightRectangle:{
            self.dateLabel.layer.cornerRadius = self.dateLabel.width/2.f;
            self.backView.hidden = NO;
            self.backView.frame = CGRectMake(self.width/2.f, (self.height-30)/2.f, self.width/2.f, 30);
            self.backView.layer.mask = nil;

            switch (model.dateType) {
                case EXCalendarDateType_arrange:{
                    self.dateLabel.backgroundColor = COLOR_HEX(0x9780FF);
                    self.backView.backgroundColor = COLOR_HEX(0xC2B5FE);
                }
                    break;
                    
                case EXCalendarDateType_start:{
                    self.dateLabel.backgroundColor = COLOR_HEX(0x3165EC);
                    self.backView.backgroundColor = COLOR_HEX(0x99B3F5);
                }
                    break;
                    
                case EXCalendarDateType_remove:{
                    self.dateLabel.backgroundColor = COLOR_HEX(0xFFCF39);
                    self.backView.backgroundColor = COLOR_HEX(0xFFEAA8);
                }
                    break;
                    
                default:
                    break;
            }
            
        }
            break;
            
        case EXCalendarCellType_rectangle:{
            self.dateLabel.layer.cornerRadius = 0;
            self.dateLabel.backgroundColor = [UIColor clearColor];
            self.backView.hidden = NO;
            self.backView.frame = CGRectMake(0, (self.height-30)/2.f, self.width, 30);
            self.backView.layer.mask = nil;
            
            switch (model.dateType) {
                case EXCalendarDateType_arrange:{
                    self.backView.backgroundColor = COLOR_HEX(0xC2B5FE);
                }
                    break;
                    
                case EXCalendarDateType_start:{
                    self.backView.backgroundColor = COLOR_HEX(0x99B3F5);
                }
                    break;
                    
                case EXCalendarDateType_remove:{
                    self.backView.backgroundColor = COLOR_HEX(0xFFEAA8);
                }
                    break;
                    
                default:
                    break;
            }
            
        }
            break;
            
        case EXCalendarCellType_rectangleAndLeftCorner:{
            self.dateLabel.layer.cornerRadius = 0;
            self.dateLabel.backgroundColor = [UIColor clearColor];
            self.backView.hidden = NO;
            self.backView.frame = CGRectMake((self.width-self.dateLabel.width)/2.f, (self.height-30)/2.f, (self.dateLabel.width+self.width)/2.f, 30);
            self.backView.layer.mask = [self createCornerLayerWithDirection:UIRectCornerTopLeft|UIRectCornerBottomLeft andRect:self.backView.bounds andCornerRadii:CGSizeMake(self.backView.height/2.f, 0)];

            switch (model.dateType) {
                case EXCalendarDateType_arrange:{
                    self.backView.backgroundColor = COLOR_HEX(0xC2B5FE);
                }
                    break;
                    
                case EXCalendarDateType_start:{
                    self.backView.backgroundColor = COLOR_HEX(0x99B3F5);
                }
                    break;
                    
                case EXCalendarDateType_remove:{
                    self.backView.backgroundColor = COLOR_HEX(0xFFEAA8);
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        case EXCalendarCellType_rectangleAndRightCorner:{
            self.dateLabel.layer.cornerRadius = 0;
            self.dateLabel.backgroundColor = [UIColor clearColor];
            self.backView.hidden = NO;
            self.backView.frame = CGRectMake(0, (self.height-30)/2.f, (self.dateLabel.width+self.width)/2.f, 30);
            self.backView.layer.mask = [self createCornerLayerWithDirection:UIRectCornerTopRight|UIRectCornerBottomRight andRect:self.backView.bounds andCornerRadii:CGSizeMake(self.backView.height/2.f, 0)];
            
            switch (model.dateType) {
                case EXCalendarDateType_arrange:{
                    self.backView.backgroundColor = COLOR_HEX(0xC2B5FE);
                }
                    break;
                    
                case EXCalendarDateType_start:{
                    self.backView.backgroundColor = COLOR_HEX(0x99B3F5);
                }
                    break;
                    
                case EXCalendarDateType_remove:{
                    self.backView.backgroundColor = COLOR_HEX(0xFFEAA8);
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
    
    if (model.cellType == EXCalendarCellType_common) {
        self.dateLabel.textColor = COLOR_HEX(0x626B81);
    }else{
        self.dateLabel.textColor = COLOR_HEX(0xffffff);
    }
    
}

//指定方向添加圆角遮罩
-(CAShapeLayer*)createCornerLayerWithDirection:(UIRectCorner)corner andRect:(CGRect)rect andCornerRadii:(CGSize)cornerRadii{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corner cornerRadii:cornerRadii];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = rect;
    maskLayer.path = maskPath.CGPath;
    return maskLayer;
}

-(UILabel *)dateLabel{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc]initWithFrame:CGRectMake((self.width-35)/2.f, (self.height-35)/2.f, 35, 35)];
        _dateLabel.font = EX_PING_MEDIUM(14);
        _dateLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _dateLabel;
}

-(UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]init];
    }
    return _backView;
}



@end
