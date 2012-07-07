#import "SAFormCell.h"
#import "SAFormTableViewController.h"
#import "SAFormCellConfig.h"

@interface SAFormCell ()
- (void) drawOrMoveToX:(CGFloat)x y:(CGFloat)y forMask:(int)mask withContext:(CGContextRef)context;
@end

@implementation SAFormCell {
    UIView* _clearBackgroundView;
}
@synthesize clearBackground = _squareStyle;
@synthesize currentConfig = _currentConfig;
@synthesize formControl = _formControl;
@synthesize borderColor = _borderColor;
@synthesize border = _border;

- (void)layoutSubviews {
    [super layoutSubviews];
        
    if(self.clearBackground && _clearBackgroundView == nil) {
        _clearBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        self.backgroundView = _clearBackgroundView;
        self.backgroundView.backgroundColor = [UIColor clearColor];
    }
}

- (void) drawOrMoveToX:(CGFloat)x y:(CGFloat)y forMask:(int)mask withContext:(CGContextRef)context {
    if(self.border & mask) {
        CGContextAddLineToPoint(context, x, y);
    } else {
        CGContextMoveToPoint(context, x, y);
    }
}

- (void) setTextFieldDelegate:(id<UITextFieldDelegate>)delegate {
    
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if(_border) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGFloat minx = CGRectGetMinX(self.contentView.frame);
        CGFloat maxx = CGRectGetMaxX(self.contentView.frame);
        CGFloat miny = CGRectGetMinY(self.contentView.frame);
        CGFloat maxy = CGRectGetMaxY(self.contentView.frame);
        
        CGContextBeginPath(context);    
        CGContextMoveToPoint(context, minx, miny);
        [self drawOrMoveToX:maxx y:miny forMask:SAFormCellBorderTop withContext:context];
        [self drawOrMoveToX:maxx y:maxy forMask:SAFormCellBorderRight withContext:context];
        [self drawOrMoveToX:minx y:maxy forMask:SAFormCellBorderBottom withContext:context];
        [self drawOrMoveToX:minx y:miny forMask:SAFormCellBorderLeft withContext:context];
        
        CGContextSetStrokeColorWithColor(context, _borderColor.CGColor);
        CGContextSetLineWidth(context, 1);
        CGContextStrokePath(context);
    }
}

- (void) setControlValue:(id) value {
    @throw [NSException exceptionWithName:@"Subclass must implement this method" reason:@"" userInfo:nil];    
}

- (void)valueChanged {
    @throw [NSException exceptionWithName:@"Subclass must implement this method" reason:@"" userInfo:nil];
}
@end





