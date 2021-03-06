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
        _textField.font = [UIFont systemFontOfSize:22];
        _textField.textColor = [UIColor colorWithWhite:.4 alpha:1];
        _textField.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [_textField addTarget:self action:@selector(valueChanged) forControlEvents:UIControlEventEditingChanged];
        [self.contentView addSubview:self.textField];
        self.formControl = self.textField;
    }
    return self;
}

- (void) setTextFieldDelegate:(id)delegate {
    self.textField.delegate = delegate;
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
    CGRect formRect = CGRectMake(percent, 8, 
                                 self.contentView.bounds.size.width - percent - 10, 
                                 self.contentView.bounds.size.height - 16);
    self.textField.frame = formRect;
    [self.contentView bringSubviewToFront:self.textField];
}


@end
