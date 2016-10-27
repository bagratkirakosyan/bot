//
//  ChatViewController.m
//  Bot
//
//  Created by Aram Sargsyan on 10/28/16.
//  Copyright © 2016 PicsArt. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatMessageData.h"
#import "RightTextCell.h"
#import "LeftTextCell.h"
#import "UIColor+BotColors.h"

static NSString *const rightTextCellIdentifier = @"rightTextCellID";
static NSString *const leftTextCellIdentifier = @"leftTextCellID";

@interface ChatViewController () <UITableViewDataSource, UITableViewDelegate>

@property IBOutlet UITableView *tableView;
@property IBOutlet UITextField *textField;
@property IBOutlet NSLayoutConstraint *bottomConstraint;

@property NSMutableArray<ChatMessageData *> *messages;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Aziz Bot";
    self.navigationController.navigationBar.translucent = NO;
    
    self.messages = [NSMutableArray array];
    
    self.tableView.backgroundColor = [UIColor botLightBlue];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.contentOffset = CGPointMake(0, 100);
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"RightTextCell" bundle:nil] forCellReuseIdentifier:rightTextCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"LeftTextCell" bundle:nil] forCellReuseIdentifier:leftTextCellIdentifier];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    
}

#pragma mark - Private


- (void)keyboardWillShow:(NSNotification *)notification {
    
    CGSize keyboardSize = [(NSValue *)notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    [UIView animateWithDuration:1/3 animations:^{
        self.bottomConstraint.constant = keyboardSize.height;
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView animateWithDuration:0.25 animations:^{
        self.bottomConstraint.constant = 0;
    }];
}

- (void)sendMessage:(NSString *)message bot:(BOOL)bot {
    [self.messages addObject:[[ChatMessageData alloc] initWith:message bot:bot maxTextWidth:250]];
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messages.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    self.textField.text = @"";
    
}

- (IBAction)send:(UIButton *)sender {
    [self sendMessage:self.textField.text bot:NO];
    
    //[self sendMessage:@"bari gisher" bot:YES];
    
    
    
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.messages[indexPath.row].bot) {
        LeftTextCell *cell = (LeftTextCell *)[tableView dequeueReusableCellWithIdentifier:leftTextCellIdentifier forIndexPath:indexPath];
        
        if (cell == nil) {
            cell = [[LeftTextCell alloc] init];
        }
        
        [cell setMessage:self.messages[indexPath.row].message];
        
        return cell;
        
    } else {
        
        RightTextCell *cell = (RightTextCell *)[tableView dequeueReusableCellWithIdentifier:rightTextCellIdentifier forIndexPath:indexPath];
        
        if (cell == nil) {
            cell = [[RightTextCell alloc] init];
        }
        
        [cell setMessage:self.messages[indexPath.row].message];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.messages[indexPath.row].textSize.height + 55;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
