//
//  LayerAnimation.m
//  TestLayerAnamation
//
//  Created by HLINK010 on 2016/12/27.
//  Copyright © 2016年 HLINK010. All rights reserved.
//

#import "LayerAnimation.h"
#define BEGINANGLE  ((-210) / 180.0 * M_PI) //以0度为基准，开始位置所偏移的弧度
#define ENDANGLE ((30) / 180.0 * M_PI)

#define ROUNDBACKCOLOR [[UIColor grayColor] colorWithAlphaComponent:0.7] //环形圈背景颜色
#define ROUNDBACKGROUNDCOLOR [[UIColor grayColor] colorWithAlphaComponent:0.5] //环形圈背景颜色
#define ROUNDSECTIONCOLOR [[UIColor blueColor] colorWithAlphaComponent:0.5] //分区点颜色
#define WHITECOLOR [[UIColor whiteColor] colorWithAlphaComponent:1] //环形圈背景颜色

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)  //角度转弧度
@interface LayerAnimation ()
@property (nonatomic ,assign)float height;
@property (nonatomic ,assign)float width;
@end
@implementation LayerAnimation
{
    UIImageView *centerImgV; //指针
    float anagle;//每次偏移到的弧度
    NSTimer *animationTimer; //动画timer
    float _progress;//当前进度值
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.width = frame.size.width;
        self.height = frame.size.height;
        //添加表刻度
        NSArray *arr = @[@"0",@"25",@"50",@"75",@"100"];
        for (int i = 5; i >0; i--) {
            NSString *tickText = [NSString stringWithFormat:@"%@",arr[i-1]];
            UILabel * text      = [[UILabel alloc] init];
            text.center = [self getTextCenter:DEGREES_TO_RADIANS(-(360-90-i*60)) center:CGPointMake(_width/2.0, _height/2.0) radius:90];
            text.bounds = CGRectMake(0, 0, 54, 14);
            text.text          = tickText;
            text.font          = [UIFont systemFontOfSize:13];
            text.textColor     = [UIColor colorWithRed:0.54 green:0.78 blue:0.91 alpha:1.0];
            text.textAlignment = NSTextAlignmentCenter;
            [self addSubview:text];
        }
        
        //创建最外层环形
        UIBezierPath *path=[UIBezierPath bezierPath];
        [path addArcWithCenter:CGPointMake(_width/2,_height/2) radius:150 startAngle:BEGINANGLE endAngle:ENDANGLE clockwise:YES];
        CAShapeLayer *arcLayer=[CAShapeLayer layer];
        arcLayer.path=path.CGPath;//46,169,230
        arcLayer.fillColor=[UIColor clearColor].CGColor;
        arcLayer.strokeColor=ROUNDBACKGROUNDCOLOR.CGColor;
        arcLayer.lineWidth=3;
        arcLayer.lineCap = kCALineCapRound;
        arcLayer.frame=self.bounds;
        [self.layer addSublayer:arcLayer];
        
        anagle = 0;
        _progress = 0;
        
        centerImgV =[[UIImageView alloc]init];
        centerImgV.center = CGPointMake(frame.size.width/2.0, frame.size.height/2.0);
        centerImgV.bounds = CGRectMake(0, 0, (frame.size.width-80)/2.0, 15);
        centerImgV.layer.anchorPoint = CGPointMake(0, 0.5);
        centerImgV.image = [UIImage imageNamed:@"0001"];
        [self addSubview:centerImgV];
        CGAffineTransform endAngle = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-210));
        centerImgV.transform = endAngle;
        
        UIImageView *centerImgVs =[[UIImageView alloc]init];
        centerImgVs.center = CGPointMake(frame.size.width/2.0, frame.size.height/2.0);
        centerImgVs.bounds = CGRectMake(0, 0, 25, 25);
        centerImgVs.image = [UIImage imageNamed:@"000"];
        [self addSubview:centerImgVs];
    }
    return self;
}
- (void)setProgress:(float)progress
{
    if (progress < 0) {
        _progress = 0;
    }else if (progress > 1) {
        _progress = 1.0;
    }else
    {
        _progress = progress;
    }
    
    anagle = 0;
    
    if (animationTimer) {
        [animationTimer invalidate];
        animationTimer = nil;
    }
    if (_progress == 0) {
        //刻度执为0，指针同时也归0位
        CGAffineTransform endAngle = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-210));
        centerImgV.transform = endAngle;
        [self setNeedsDisplay];
    }
    [self setAnimation];
}
- (void)animationMethod
{
    if (anagle > (_progress*100)) {
        [animationTimer invalidate];
        animationTimer = nil;
        return;
    }
    
    anagle += 2.4; //指针，刻度，每次移动角度
    
    CGAffineTransform endAngle = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-210+(2.4*anagle)));
    [self setNeedsDisplay];
    [UIView animateWithDuration:0.001 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        centerImgV.transform = endAngle;
    } completion:^(BOOL finished) {
        
    }];
}
                                                            
- (void)setAnimation
{
    if (!animationTimer) {
        animationTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(animationMethod) userInfo:nil repeats:YES];
        [animationTimer fire];
    }
}

-(CGPoint) getTextCenter :(float) angle center:(CGPoint)point radius:(float)rad
{
    CGFloat x = 0.0;
    CGFloat y = 0.0;
    x = point.x + cosf(angle) * rad;
    y = point.y + sinf(angle) * rad;
    return CGPointMake(x, y);
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    //表盘中间虚线
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGFloat radius = self.width * 0.5;
    CGFloat perimeter = M_PI * radius * 2 / 3.0 * 2;
    CGFloat width = perimeter / 20.0 / 6.0;
    //设置线条的宽度
    CGContextSetLineWidth(ctx, 15);
    //设置线条的起始点样式
    CGContextSetLineCap(ctx, kCGLineCapButt);
    //虚实切换 ，实线5虚线10
    CGFloat length[] = {0.7, width - 0.7};
    CGContextSetLineDash(ctx, 0, length, 2);
    //设置颜色
    [ROUNDBACKGROUNDCOLOR set];
    //设置路径
    CGContextAddArc(ctx, self.width *0.5, self.width * 0.5, self.width * 0.42, BEGINANGLE, ENDANGLE, 0);
    //绘制
    CGContextStrokePath(ctx);
    
//    表盘内侧虚线
    CGFloat radiusd = self.width * 0.5, perimeterd = M_PI * radiusd * 2 / 3.65 * 2;
    CGFloat widthd = perimeterd / 9;
    CGContextSetLineWidth(ctx, 5);
    CGContextSetLineCap(ctx, kCGLineCapButt);
    CGFloat lengthd[] = {1.2, widthd - 1.2};
    CGContextSetLineDash(ctx, 0, lengthd, 2);
    [ROUNDSECTIONCOLOR set];
    CGContextAddArc(ctx, self.width *0.5, self.width * 0.5, self.width * 0.37, BEGINANGLE, ENDANGLE, 0);
    CGContextStrokePath(ctx);
    
//    当前进度刻度
    CGContextSetLineWidth(ctx, 15);
    CGContextSetLineCap(ctx, kCGLineCapButt);
    CGContextSetLineDash(ctx, 0, length, 2);
    [WHITECOLOR set];
    CGContextAddArc(ctx, self.width *0.5, self.width * 0.5, self.width * 0.42, BEGINANGLE, DEGREES_TO_RADIANS(-210+(2.4*anagle)), 0);
    CGContextStrokePath(ctx);
}


@end
