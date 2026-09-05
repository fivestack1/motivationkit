
#import "HcdProcessView.h"
#import "GlobalState.h"

@implementation HcdProcessView
{
    CGRect fullRect;
    CGRect scaleRect;
    CGRect waveRect;
    
    CGFloat currentLinePointY;
    CGFloat targetLinePointY;
    
    CGFloat currentPercent;
    
    CGFloat a;
    CGFloat b;
    
    BOOL increase;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        fullRect = frame;
        
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    _scaleDivisionsLength = 10;
    _scaleDivisionsWidth = 2;
    _scaleCount = 100;
    
    a = 1.5;
    b = 0;
    increase = NO;
    _waveLength = 180;
    _amplitude = 10;
    
    _frontWaterColor = main_color2;
    _backWaterColor = main_color2;
    _waterBgColor = main_color2;
    _lineBgColor = [UIColor colorWithRed:0.694 green:0.745 blue:0.867 alpha:1.00];
    _scaleColor = [UIColor colorWithRed:1.00 green:0.67 blue:0.00 alpha:1.0];
    _percent = 0.45;
    
    _scaleMargin = 30;
    _waveMargin = 18;
    _showBgLineView = NO;
    
    [self initDrawingRects];
    
    [NSTimer scheduledTimerWithTimeInterval:0.04 target:self selector:@selector(animateWave) userInfo:nil repeats:YES];
}

- (void)initDrawingRects
{
    CGFloat offset = _scaleMargin;
    scaleRect = CGRectMake(offset,
                           offset,
                           fullRect.size.width - 2 * offset,
                           fullRect.size.height - 2 * offset);
    
    offset = _scaleMargin + _waveMargin + _scaleDivisionsWidth;
    waveRect = CGRectMake(offset,
                          offset,
                          fullRect.size.width - 2 * offset,
                          fullRect.size.height - 2 * offset);
    
    currentLinePointY = waveRect.size.height;
    targetLinePointY = waveRect.size.height * (1 - _percent);
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self drawBackground:context];
    [self drawWave:context];
    [self drawLabel:context];
    [self drawScale:context];
    [self drawProcessScale:context];
    
}

- (void)drawScale:(CGContextRef)context {
    
    CGContextSetLineWidth(context, _scaleDivisionsWidth);

    CGContextTranslateCTM(context, fullRect.size.width / 2, fullRect.size.width / 2);
    
    CGContextSetStrokeColorWithColor(context, _lineBgColor.CGColor);

    for (int i = 0; i < _scaleCount; i++) {
        CGContextMoveToPoint(context, scaleRect.size.width/2 - _scaleDivisionsLength, 0);
        CGContextAddLineToPoint(context, scaleRect.size.width/2, 0);

        CGContextStrokePath(context);
        CGContextRotateCTM(context, 2 * M_PI / _scaleCount);
    }
    
    CGContextSetStrokeColorWithColor(context, _lineBgColor.CGColor);
    CGContextSetLineWidth(context, 0.5);
    CGContextAddArc (context, 0, 0, scaleRect.size.width/2 - _scaleDivisionsLength - 3, 0, M_PI* 2 , 0);
    CGContextStrokePath(context);
    
    CGContextTranslateCTM(context, -fullRect.size.width / 2, -fullRect.size.width / 2);
}

- (void)drawWave:(CGContextRef)context {
    
    CGMutablePathRef frontPath = CGPathCreateMutable();
    CGMutablePathRef backPath = CGPathCreateMutable();
    
    CGContextSetLineWidth(context, 1);
    CGContextSetFillColorWithColor(context, [_frontWaterColor CGColor]);
    
    CGFloat offset = _scaleMargin + _waveMargin + _scaleDivisionsWidth;
    
    float frontY = currentLinePointY;
    float backY = currentLinePointY;
    
    CGFloat radius = waveRect.size.width / 2;
    
    CGPoint frontStartPoint = CGPointMake(offset, currentLinePointY + offset);
    CGPoint frontEndPoint = CGPointMake(offset, currentLinePointY + offset);
    
    CGPoint backStartPoint = CGPointMake(offset, currentLinePointY + offset);
    CGPoint backEndPoint = CGPointMake(offset, currentLinePointY + offset);
    
    for(float x = 0; x <= waveRect.size.width; x++){
        
        frontY = a * sin( x / (_waveLength / 2) * M_PI + 4 * b / M_PI ) * _amplitude + currentLinePointY;
        
        CGFloat frontCircleY = frontY;
        if (frontY < radius) {
            frontCircleY = radius - sqrt(pow(radius, 2) - pow((radius - x), 2));
            if (frontY < frontCircleY) {
                frontY = frontCircleY;
            }
        } else if (frontY > radius) {
            frontCircleY = radius + sqrt(pow(radius, 2) - pow((radius - x), 2));
            if (frontY > frontCircleY) {
                frontY = frontCircleY;
            }
        }
        
        if (fabs(0 - x) < 0.001) {
            frontStartPoint = CGPointMake(x + offset, frontY + offset);
            CGPathMoveToPoint(frontPath, NULL, frontStartPoint.x, frontStartPoint.y);
        }
        
        frontEndPoint = CGPointMake(x + offset, frontY + offset);
        CGPathAddLineToPoint(frontPath, nil, frontEndPoint.x, frontEndPoint.y);
        
        backY = a * cos( x / (_waveLength / 2) * M_PI + 3 * b / M_PI ) * _amplitude + currentLinePointY;
        CGFloat backCircleY = backY;
        if (backY < radius) {
            backCircleY = radius - sqrt(pow(radius, 2) - pow((radius - x), 2));
            if (backY < backCircleY) {
                backY = backCircleY;
            }
        } else if (backY > radius) {
            backCircleY = radius + sqrt(pow(radius, 2) - pow((radius - x), 2));
            if (backY > backCircleY) {
                backY = backCircleY;
            }
        }
        
        if (fabs(0 - x) < 0.001) {
            backStartPoint = CGPointMake(x + offset, backY + offset);
            CGPathMoveToPoint(backPath, NULL, backStartPoint.x, backStartPoint.y);
        }
        
        backEndPoint = CGPointMake(x + offset, backY + offset);
        CGPathAddLineToPoint(backPath, nil, backEndPoint.x, backEndPoint.y);
    }
    
    CGPoint centerPoint = CGPointMake(fullRect.size.width / 2, fullRect.size.height / 2);
    
    CGFloat frontStart = [self calculateRotateDegree:centerPoint point:frontStartPoint];
    CGFloat frontEnd = [self calculateRotateDegree:centerPoint point:frontEndPoint];
    
    CGPathAddArc(frontPath, nil, centerPoint.x, centerPoint.y, waveRect.size.width / 2, frontEnd, frontStart, 0);
    CGContextAddPath(context, frontPath);
    CGContextFillPath(context);
    CGContextSaveGState(context);
    CGContextDrawPath(context, kCGPathStroke);
    CGPathRelease(frontPath);
    
    
    CGFloat backStart = [self calculateRotateDegree:centerPoint point:backStartPoint];
    CGFloat backEnd = [self calculateRotateDegree:centerPoint point:backEndPoint];
    
    CGPathAddArc(backPath, nil, centerPoint.x, centerPoint.y, waveRect.size.width / 2, backEnd, backStart, 0);
    
    CGContextSetFillColorWithColor(context, [_backWaterColor CGColor]);
    CGContextAddPath(context, backPath);
    CGContextFillPath(context);

    CGContextSaveGState(context);
    CGContextDrawPath(context, kCGPathStroke);
    CGPathRelease(backPath);
    
}


- (void)drawBackground:(CGContextRef)context {
    

    CGMutablePathRef path = CGPathCreateMutable();
    CGContextSetLineWidth(context, 1);
    CGContextSetFillColorWithColor(context, [_waterBgColor CGColor]);
    
    CGPoint centerPoint = CGPointMake(fullRect.size.width / 2, fullRect.size.height / 2);
    CGPathAddArc(path, nil, centerPoint.x, centerPoint.y, waveRect.size.width / 2, 0, 2 * M_PI, 0);
    
    CGContextAddPath(context, path);
    CGContextFillPath(context);
    CGContextDrawPath(context, kCGPathStroke);
    CGPathRelease(path);
    
    if (_showBgLineView) {

        CGContextTranslateCTM(context, fullRect.size.width / 2, fullRect.size.width / 2);
        
        CGContextSetStrokeColorWithColor(context, _lineBgColor.CGColor);
        CGContextSetLineWidth(context, 1);
        CGContextAddArc (context, 0, 0, fullRect.size.width/2 - 4, -M_PI / 4, M_PI / 4, 0);
        CGContextStrokePath(context);
        
        CGContextRotateCTM(context, M_PI / 4);
        CGContextMoveToPoint(context, fullRect.size.width/2 - 4, 0);
        CGContextAddLineToPoint(context, fullRect.size.width/2, 0);

        CGContextStrokePath(context);
        CGContextRotateCTM(context, -M_PI / 4);
        
        CGContextSetStrokeColorWithColor(context, _lineBgColor.CGColor);
        CGContextSetLineWidth(context, 1);
        CGContextAddArc (context, 0, 0, fullRect.size.width/2 - 4, M_PI * 3 / 4, M_PI * 5 / 4, 0);
        CGContextStrokePath(context);
        
        CGContextRotateCTM(context, M_PI * 5 / 4);
        CGContextMoveToPoint(context, fullRect.size.width/2 - 4, 0);
        CGContextAddLineToPoint(context, fullRect.size.width/2, 0);

        CGContextStrokePath(context);
        CGContextRotateCTM(context, -M_PI * 5 / 4);
        
        CGContextSetStrokeColorWithColor(context, _lineBgColor.CGColor);
        CGContextSetLineWidth(context, 6);
        CGContextAddArc (context, 0, 0, fullRect.size.width/2 - _scaleMargin / 2, M_PI * 4 / 10, M_PI * 6 / 10, 0);
        CGContextStrokePath(context);
        
        CGContextSetStrokeColorWithColor(context, _lineBgColor.CGColor);
        CGContextSetLineWidth(context, 6);
        CGContextAddArc (context, 0, 0, fullRect.size.width/2 - _scaleMargin / 2, M_PI * 14 / 10, M_PI * 16 / 10, 0);
        CGContextStrokePath(context);
        
        CGContextTranslateCTM(context, -fullRect.size.width / 2, -fullRect.size.width / 2);
    }
}

- (void)drawProcessScale:(CGContextRef)context {
    
    CGContextSetLineWidth(context, _scaleDivisionsWidth);

    CGContextTranslateCTM(context, fullRect.size.width / 2, fullRect.size.width / 2);
    
    CGContextSetStrokeColorWithColor(context, _scaleColor.CGColor);
    
    int count = (_scaleCount / 2 + 1) * currentPercent;
    CGFloat scaleAngle = 2 * M_PI / _scaleCount;
    

    for (int i = 0; i < count; i++) {
        CGContextMoveToPoint(context, 0, scaleRect.size.width/2 - _scaleDivisionsLength);
        CGContextAddLineToPoint(context, 0, scaleRect.size.width/2);

        CGContextStrokePath(context);
        CGContextRotateCTM(context, scaleAngle);
    }
    
    CGContextRotateCTM(context, -count * scaleAngle);
    
    for (int i = 0; i < count; i++) {
        CGContextMoveToPoint(context, 0, scaleRect.size.width/2 - _scaleDivisionsLength);
        CGContextAddLineToPoint(context, 0, scaleRect.size.width/2);

        CGContextStrokePath(context);
        CGContextRotateCTM(context, -scaleAngle);
    }
    
    
    CGContextTranslateCTM(context, -fullRect.size.width / 2, -fullRect.size.width / 2);
}

- (void)drawLabel:(CGContextRef)context {
    
    NSMutableAttributedString *attriButedText = [self formatBatteryLevel:_percent * 100];
    CGRect textSize = [attriButedText boundingRectWithSize:CGSizeMake(400, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    
    NSMutableAttributedString *attriLabelText = [self formatLabel:@"TODAY GOAL"];
    CGRect labelSize = [attriLabelText boundingRectWithSize:CGSizeMake(400, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    
    CGPoint textPoint = CGPointMake(fullRect.size.width / 2 - textSize.size.width / 2, fullRect.size.height / 2 - textSize.size.height / 2 - labelSize.size.height / 2);
    CGPoint labelPoint = CGPointMake(fullRect.size.width / 2 - labelSize.size.width / 2, textPoint.y + textSize.size.height);
    
    [attriButedText drawAtPoint:textPoint];
    [attriLabelText drawAtPoint:labelPoint];
    

    CGContextSaveGState(context);
}


-(void)animateWave
{
    if (targetLinePointY == self.frame.size.height ||
        currentLinePointY == 0) {
        return;
    }
    
    if (targetLinePointY < currentLinePointY) {
        currentLinePointY -= 1;
        currentPercent = (waveRect.size.height - currentLinePointY) / waveRect.size.height;
    }
    
    if (targetLinePointY > currentLinePointY) {
        currentLinePointY += 1;
        currentPercent = (waveRect.size.height - currentLinePointY) / waveRect.size.height;
    }
    
    if (increase) {
        a += 0.01;
    } else {
        a -= 0.01;
    }
    
    
    if (a <= 1) {
        increase = YES;
    }
    
    if (a >= 1.5) {
        increase = NO;
    }
    
    b += 0.1;
    
    [self setNeedsDisplay];
}

/**
 * Core Graphics rotation in context
 */
- (void)rotateContext:(CGContextRef)context fromCenter:(CGPoint)center_ withAngle:(CGFloat)angle
{
    CGContextTranslateCTM(context, center_.x, center_.y);
    CGContextRotateCTM(context, angle);
    CGContextTranslateCTM(context, -center_.x, -center_.y);
}

- (CGFloat)calculateRotateDegree:(CGPoint)centerPoint point:(CGPoint)point {
    
    CGFloat rotateDegree = asin(fabs(point.y - centerPoint.y) / (sqrt(pow(point.x - centerPoint.x, 2) + pow(point.y - centerPoint.y, 2))));
    

    if (point.y > centerPoint.y) {

        if (point.x >= centerPoint.x) {
            rotateDegree = rotateDegree;
        }

        else {
            rotateDegree = M_PI - rotateDegree;
        }
    } else
    {
        if (point.x <= centerPoint.x)
        {
            rotateDegree = M_PI + rotateDegree;
        }
        else
        {
            rotateDegree = 2 * M_PI - rotateDegree;
        }
    }
    return rotateDegree;
}

-(NSMutableAttributedString *) formatBatteryLevel:(NSInteger)percent
{
    UIColor *textColor = [UIColor labelColor];
    NSMutableAttributedString *attrText;
    
    NSString *percentText=[NSString stringWithFormat:@"%ld%%",(long)percent];
    
    NSMutableParagraphStyle *paragrahStyle = [[NSMutableParagraphStyle alloc] init];
    [paragrahStyle setAlignment:NSTextAlignmentCenter];
    if (percent<10) {
        attrText=[[NSMutableAttributedString alloc] initWithString:percentText];
        UIFont *capacityNumberFont=[UIFont systemFontOfSize:60];
        UIFont *capacityPercentFont=[UIFont systemFontOfSize:30];
        [attrText addAttribute:NSFontAttributeName value:capacityNumberFont range:NSMakeRange(0, 1)];
        [attrText addAttribute:NSFontAttributeName value:capacityPercentFont range:NSMakeRange(1, 1)];
        [attrText addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0, 2)];
        [attrText  addAttribute:NSParagraphStyleAttributeName value:paragrahStyle range:NSMakeRange(0, 2)];
        
    } else {
        attrText=[[NSMutableAttributedString alloc] initWithString:percentText];
        UIFont *capacityNumberFont=[UIFont systemFontOfSize:60];
        UIFont *capacityPercentFont=[UIFont systemFontOfSize:30];
        
        
        if (percent>=100) {
            
            [attrText addAttribute:NSFontAttributeName value:capacityNumberFont range:NSMakeRange(0, 3)];
            [attrText addAttribute:NSFontAttributeName value:capacityPercentFont range:NSMakeRange(3, 1)];
            [attrText addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0, 4)];
            [attrText addAttribute:NSParagraphStyleAttributeName value:paragrahStyle range:NSMakeRange(0, 4)];
        } else {
            [attrText addAttribute:NSFontAttributeName value:capacityNumberFont range:NSMakeRange(0, 2)];
            [attrText addAttribute:NSFontAttributeName value:capacityPercentFont range:NSMakeRange(2, 1)];
            [attrText addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0, 3)];
            [attrText  addAttribute:NSParagraphStyleAttributeName value:paragrahStyle range:NSMakeRange(0, 3)];
        }
        
    }
    
    
    return attrText;
}

-(NSMutableAttributedString *) formatLabel:(NSString*)text
{
    UIColor *textColor = [UIColor labelColor];
    NSMutableAttributedString *attrText;
    NSMutableParagraphStyle *paragrahStyle = [[NSMutableParagraphStyle alloc] init];
    [paragrahStyle setAlignment:NSTextAlignmentCenter];
 
    UIFont *font = [UIFont systemFontOfSize:14];
    
    attrText=[[NSMutableAttributedString alloc] initWithString:text];
    [attrText addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, text.length)];
    [attrText addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0, text.length)];
    [attrText  addAttribute:NSParagraphStyleAttributeName value:paragrahStyle range:NSMakeRange(0, text.length)];
    
    return attrText;
}

#pragma mark - Setter

- (void)setPercent:(CGFloat)percent {
    _percent = percent;
    currentPercent = percent;
    targetLinePointY = waveRect.size.height * (1 - _percent);
    [self initDrawingRects];
}

- (void)setWaterBgColor:(UIColor *)waterBgColor {
    _waterBgColor = waterBgColor;
    [self initDrawingRects];
}

- (void)setFrontWaterColor:(UIColor *)frontWaterColor {
    _frontWaterColor = frontWaterColor;
    [self initDrawingRects];
}

- (void)setBackWaterColor:(UIColor *)backWaterColor {
    _backWaterColor = backWaterColor;
    [self initDrawingRects];
}

- (void)setLineBgColor:(UIColor *)lineBgColor {
    _lineBgColor = lineBgColor;
    [self initDrawingRects];
}

- (void)setScaleColor:(UIColor *)scaleColor {
    _scaleColor = scaleColor;
    [self initDrawingRects];
}

- (void)setShowBgLineView:(BOOL)showBgLineView {
    _showBgLineView = showBgLineView;
    [self initDrawingRects];
}

- (void)setAmplitude:(CGFloat)amplitude {
    _amplitude = amplitude;
    [self initDrawingRects];
}

- (void)setWaveLength:(CGFloat)waveLength {
    _waveLength = waveLength;
    [self initDrawingRects];
}

- (void)setWaveMargin:(CGFloat)waveMargin {
    _waveMargin = waveMargin;
    [self initDrawingRects];
}

@end
