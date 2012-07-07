#import "SAButtonCell.h"

@implementation SAButtonCell
- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat cellHeight = self.contentView.bounds.size.height;
    CGFloat cellWidth = self.contentView.bounds.size.width;
    self.textLabel.textAlignment = UITextAlignmentCenter;
    self.textLabel.frame = CGRectMake(5, 5, cellWidth-10, cellHeight-10);
}
@end