#import "SASegmentedCell.h"
#import "SAFormCellConfig.h"

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
