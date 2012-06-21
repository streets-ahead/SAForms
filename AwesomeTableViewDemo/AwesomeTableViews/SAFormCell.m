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

@implementation SATextCell : SAFormCell
@synthesize textField = _textField;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSLog(@"init text cell");
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.textField = [[UITextField alloc] initWithFrame:CGRectZero];     
        self.textField.borderStyle = UITextBorderStyleNone;
        self.textField.font = [UIFont systemFontOfSize:17];
        self.textField.textColor = [UIColor colorWithWhite:.4 alpha:1];
        self.textField.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [self.textField addTarget:self action:@selector(valueChanged) forControlEvents:UIControlEventEditingChanged];
        [self.contentView addSubview:self.textField];
        self.formControl = self.textField;
    }
    return self;
}

- (void)valueChanged {
    [self.currentConfig valueUpdated:self.textField.text];
}

- (void) setControlValue:(id) value {
    self.textField.text = value;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat percent = 10;
    NSLog(@"%@", self.textLabel.text);
    if(self.textLabel.text != nil && ![self.textLabel.text isEqualToString:@""]) {
        percent = self.contentView.bounds.size.width * .35;
    }
    CGRect formRect = CGRectMake(percent, 5, 
                                 self.contentView.bounds.size.width - percent - 10, 
                                 self.contentView.bounds.size.height - 10);
    self.textField.frame = formRect;
    [self.contentView bringSubviewToFront:self.textField];
}
@end


@implementation SASegmentedCell 
@synthesize segmentedControl = _segmentedControl;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"something", @"blah", nil]];
        self.segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        self.segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
        [self.segmentedControl addTarget:self action:@selector(valueChanged) forControlEvents:UIControlEventValueChanged];
        [self.contentView addSubview:self.segmentedControl];
        self.formControl = self.segmentedControl;
    }
    return self;
}

- (void) setControlValue:(id) value {
    self.segmentedControl.selectedSegmentIndex = [value intValue];
}

- (void)valueChanged {
    NSNumber* index = [NSNumber numberWithInt:[self.segmentedControl selectedSegmentIndex]];
    [self.currentConfig valueUpdated:index];
}

- (void) setSegmentTitles:(NSArray*) segments {
    [self.segmentedControl removeAllSegments];
    for (int i = 0; i < segments.count; i++) {
        NSString* title = [segments objectAtIndex:i];
        [self.segmentedControl insertSegmentWithTitle:title atIndex:i animated:NO];
    }
}

- (void) setSegmentImages:(NSArray*) segments {
        [self.segmentedControl removeAllSegments];
    for (int i = 0; i < segments.count; i++) {
        UIImage* image = [segments objectAtIndex:i];
        [self.segmentedControl insertSegmentWithImage:image atIndex:i animated:NO];
    }    
}

- (void) layoutSubviews {
    [super layoutSubviews];
    CGFloat cellHeight = self.contentView.bounds.size.height;
    CGFloat cellWidth = self.contentView.bounds.size.width;
    CGRect segFrame = CGRectMake( 0, 0, cellWidth, cellHeight);
    
    self.segmentedControl.frame = segFrame;
}
@end

@implementation SAButtonCell
- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat cellHeight = self.contentView.bounds.size.height;
    CGFloat cellWidth = self.contentView.bounds.size.width;
    self.textLabel.textAlignment = UITextAlignmentCenter;
    self.textLabel.frame = CGRectMake(5, 5, cellWidth-10, cellHeight-10);
}
@end




