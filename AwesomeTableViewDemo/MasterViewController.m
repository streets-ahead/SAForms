#import "MasterViewController.h"
#import "SAFormCell.h"
#import "SAFormCellConfig.h"

@interface MasterViewController () 
- (SAFormSection*) loginSection;
- (SAFormSection*) registerSection;
- (SAFormSection*) buttonSection;
@end

@implementation MasterViewController {
    NSMutableDictionary* _loginModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Login";
    self.tableView.backgroundColor = [UIColor colorWithRed:0.310 green:0.741 blue:0.820 alpha:1.000];
    
    SAFormSection* mainSection = [self addSection:[[SAFormSection alloc] init]];
    
    UIImage* logoImage = [UIImage imageNamed:@"logo.png"];
    UIImageView* logo = [[UIImageView alloc] initWithImage:logoImage];
    mainSection.header = [[SAFormHeaderFooter alloc] initWithView:logo];
    
    FormatBlock cellFormat = ^(SAFormCell* cell) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    };

    SAFormCellConfig* loginReg = [[SAFormCellConfig alloc] initWithLabel:@"Login or Register"];    
    SAFormCellConfig* twitter = [[SAFormCellConfig alloc] initWithLabel:@"Sign in With Twitter"];
    loginReg.cellFormatterBlock = cellFormat;
    twitter.cellFormatterBlock = cellFormat;
    
    [mainSection addCell:loginReg];
    [mainSection addCell:twitter];
    
    _loginModel = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:0] forKey:@"tab"];
    SAFormSection* loginSection = [self loginSection];
    SAFormSection* registerSection = [self registerSection];
    
    loginReg.selectedBlock = ^(UITableView* tv, UITableViewCell* cell, NSIndexPath* indexPath) {
        SAFormTableViewController* detail = [[SAFormTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        detail.tableView.backgroundColor = [UIColor colorWithRed:0.310 green:0.741 blue:0.820 alpha:1.000];
        detail.title = @"Login or Register";
        SAFormSection* optSect = [detail addSection:[[SAFormSection alloc] init]];
        SAFormCellConfig* segCell = [[SAFormCellConfig alloc] initWithCellClass:[SASegmentedCell class]];
        segCell.boundObject = _loginModel;
        segCell.boundObjectKeyPath = @"tab";
        segCell.selectionStyle = UITableViewCellSeparatorStyleNone;
        segCell.cellFormatterBlock = ^(SAFormCell* cell) {
            SASegmentedCell* s = ((SASegmentedCell*)cell);
            [s setSegmentTitles:[NSArray arrayWithObjects:@"Login", @"Register", nil]];
            cell.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
            cell.backgroundColor = [UIColor clearColor];
        };
        
        if([[_loginModel valueForKey:@"tab"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
            [detail addSection:registerSection];
        } else {
            [detail addSection:loginSection];
        }
        
        segCell.valueChangedBlock = ^(id value) {
            if([[_loginModel valueForKey:@"tab"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                [detail replaceSection:loginSection withSection:registerSection];
            } else {
                [detail replaceSection:registerSection withSection:loginSection];
            }
        };
        [optSect addCell:segCell];
        [self.navigationController pushViewController:detail animated:YES];
        [detail addSection:[self buttonSection]];
    };
}

- (SAFormSection*) buttonSection {
    SAFormSection* buttonSection = [[SAFormSection alloc] init];
    SAFormCellConfig* login = [buttonSection addCell:[[SAFormCellConfig alloc] initWithCellClass:[SAButtonCell class]]];
    login.defaultLabel = @"Login";
    login.selectedBlock = ^(UITableView* tableView, UITableViewCell* cell, NSIndexPath* indexPath) {
        NSString* str = [NSString stringWithFormat:@"your username is %@", [_loginModel valueForKey:@"username"]];
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"alert" message:str delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    };
    return buttonSection;
}


- (SAFormSection*) loginSection {
    SAFormSection* section = [[SAFormSection alloc] init];
    SAFormCellConfig* username = [section addCell:[[SAFormCellConfig alloc] initWithCellClass:[SATextCell class]]];
    username.defaultLabel = @"Username";
    username.selectionStyle = UITableViewCellSelectionStyleNone;
    username.boundObject = _loginModel;
    username.boundObjectKeyPath = @"username";
    username.cellFormatterBlock = ^(SAFormCell* cell) {
        [(SATextCell*)cell textField].secureTextEntry = NO;
    };
    username.formControlFormatBlock = ^(id formControl) {
        [formControl setPlaceholder:@"username"];
    };
    
    SAFormCellConfig* password = [section addCell:[[SAFormCellConfig alloc] initWithCellClass:[SATextCell class]]];
    password.defaultLabel = @"Password";
    password.boundObject = _loginModel;
    password.boundObjectKeyPath = @"password";
    password.selectionStyle = UITableViewCellSelectionStyleNone;
    password.cellFormatterBlock = ^(SAFormCell* cell) {
        [(SATextCell*)cell textField].secureTextEntry = YES;
    };
    password.formControlFormatBlock = ^(id formControl) {
        [formControl setPlaceholder:@"password"];
    };
    
    return section;    
}

- (SAFormSection*) registerSection {
    SAFormSection* section = [[SAFormSection alloc] init];
    SAFormCellConfig* username = [section addCell:[[SAFormCellConfig alloc] initWithCellClass:[SATextCell class]]];
    username.defaultLabel = @"Username";
    username.cellFormatterBlock = ^(SAFormCell* cell) {
        [(SATextCell*)cell textField].secureTextEntry = NO;
    };
    
    
    SAFormCellConfig* password = [section addCell:[[SAFormCellConfig alloc] initWithCellClass:[SATextCell class]]];
    password.defaultLabel = @"Password";
    password.cellFormatterBlock = ^(SAFormCell* cell) {
        [(SATextCell*)cell textField].secureTextEntry = YES;
    };
    
    SAFormCellConfig* conf = [section addCell:[[SAFormCellConfig alloc] initWithCellClass:[SATextCell class]]];
    conf.defaultLabel = @"Confirm Password";
    conf.cellFormatterBlock = ^(SAFormCell* cell) {
        [(SATextCell*)cell textField].secureTextEntry = YES;
    };
    
    
    SAFormCellConfig* email = [section addCell:[[SAFormCellConfig alloc] initWithCellClass:[SATextCell class]]];
    email.defaultLabel = @"Email";
    email.cellFormatterBlock = ^(SAFormCell* cell) {
        [(SATextCell*)cell textField].secureTextEntry = NO;
    };
    
    return section;
}

@end
