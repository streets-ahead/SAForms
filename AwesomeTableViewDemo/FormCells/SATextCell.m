#import "SATextCell.h"
#import "SAFormCellConfig.h"
#import "SAFormTableViewController.h"

@implementation SATextCell : SAFormCell
@synthesize textField = _textField;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSLog(@"init text cell");
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _textField = [[UITextField alloc] initWithFrame:CGRectZero];     
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.font = [UIFont systemFontOfSize:17];
        _textField.textColor = [UIColor colorWithWhite:.4 alpha:1];
        _textField.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        _textField.delegate = self;
        [_textField addTarget:self action:@selector(valueChanged) forControlEvents:UIControlEventEditingChanged];
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

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    id supr = self.superview;
    if(supr != nil && [supr isKindOfClass:[UITableView class]]) {   
        if([[supr delegate] respondsToSelector:@selector(registerFirstResponder:)]) {
            [[supr delegate] registerFirstResponder:self];
        }
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    id supr = self.superview;
    if(supr != nil && [supr isKindOfClass:[UITableView class]]) {   
        if([[supr delegate] respondsToSelector:@selector(deRegisterFirstResponder:)]) {
            [[supr delegate] deRegisterFirstResponder:self];
        }
    }
}


@end
