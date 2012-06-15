#import "SAFormCell.h"
#import "SAFormTableViewController.h"
#import "SAFormCellConfig.h"

@implementation SAFormCell 
@synthesize currentConfig = _currentConfig;
@synthesize formControl = _formControl;

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
    CGFloat percent = self.contentView.bounds.size.width * .35;
    CGRect formRect = CGRectMake(percent, 10, self.contentView.bounds.size.width-percent, self.contentView.bounds.size.height-20);
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
    CGFloat segWidth = self.segmentedControl.frame.size.width;
    CGFloat segHeight = self.segmentedControl.frame.size.height;
    CGRect segFrame = CGRectMake( (cellWidth - segWidth)/2, 
                                 (cellHeight - segHeight) / 2, 
                                 segWidth, 
                                 segHeight);
    
    
    
    self.segmentedControl.frame = segFrame;
}
@end

@implementation SAButtonCell
- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat cellHeight = self.contentView.bounds.size.height;
    CGFloat cellWidth = self.contentView.bounds.size.width;
    self.textLabel.textAlignment = UITextAlignmentCenter;
    self.textLabel.frame = CGRectMake(10, 10, cellWidth-20, cellHeight-20);
}
@end




