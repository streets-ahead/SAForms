#import "SATextFieldCell.h"

@implementation SATextFieldCell

@synthesize textField = _textField;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		[self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

- (void) setTextField:(UIControl *) field {
	if(_textField != nil) {
		[_textField removeFromSuperview];
	}
	_textField = field;
	[self addSubview:_textField];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	CGRect rect2 = CGRectMake(self.textLabel.frame.origin.x+10, 
							  self.textLabel.frame.origin.y+13, 
							  self.textLabel.frame.size.width-20, 
							  self.textLabel.frame.size.height-20);
	
	[self.textField setFrame:rect2];
	[(UITextField*)self.textField setPlaceholder:self.textLabel.text];
	
	CGRect rect = CGRectMake(0, 
							 0, 
							 0, 
							 0);
	[self.textLabel setFrame:rect];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
}

@end
