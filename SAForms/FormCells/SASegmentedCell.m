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
