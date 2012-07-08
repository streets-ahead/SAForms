//
// Copyright (c) 2012 Streets Ahead LLC.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy 
// of this software and associated documentation files (the "Software"), to deal 
// in the Software without restriction, including without limitation the rights to use, 
// copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the 
// Software, and to permit persons to whom the Software is furnished to do so, subject 
// to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all 
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
// INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR 
// A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR 
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER 
// IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION 
// WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

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





