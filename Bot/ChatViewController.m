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
#import "RightImageCell.h"
#import "LeftImageCell.h"
#import "UIColor+BotColors.h"
#import "Networking.h"

static NSString * const rightTextCellIdentifier = @"rightTextCellID";
static NSString * const leftTextCellIdentifier = @"leftTextCellID";

static NSString * const rightImageCellIdentifier = @"rightImageCellID";
static NSString * const leftImageCellIdentifier = @"leftImagetCellID";

@interface ChatViewController () <UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property NSMutableArray <ChatMessageData *> *messages;
@property (nonatomic) UIImage *currentImage;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"E Bot";
    self.navigationController.navigationBar.translucent = NO;
    
    self.messages = [NSMutableArray array];
    
    self.tableView.backgroundColor = [UIColor botLightBlue];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.contentOffset = CGPointMake(0, 100);
    
    [self.tableView registerNib:[UINib nibWithNibName:@"RightTextCell" bundle:nil] forCellReuseIdentifier:rightTextCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"LeftTextCell" bundle:nil] forCellReuseIdentifier:leftTextCellIdentifier];
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"RightImageCell" bundle:nil] forCellReuseIdentifier:rightImageCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"LeftImageCell" bundle:nil] forCellReuseIdentifier:leftImageCellIdentifier];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self sendMessage:@"Hi, I am the E bot!" image:nil bot:YES];
    [self sendMessage:@"I can help you to edit your photos faster" image:nil bot:YES];
    [self sendMessage:@"Just tell me if you want to open camera or gallery?" image:nil bot:YES];
    
    //    [self sendMessage:nil image:[UIImage imageNamed:@"street.jpg"] bot:YES];
}

#pragma mark - Private

- (void)keyboardWillShow:(NSNotification *)notification {
    CGSize keyboardSize = [(NSValue *)notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomConstraint.constant = keyboardSize.height;
        [self.containerView layoutIfNeeded];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomConstraint.constant = 0;
        [self.containerView layoutIfNeeded];
    }];
}

- (void)sendMessage:(NSString *)message image:(UIImage *)image bot:(BOOL)bot {
    if (!message.length && !image) {
        return;
    }
    [self.messages addObject:[[ChatMessageData alloc] initWith:message image:image bot:bot maxTextWidth:250]];
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messages.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    self.textField.text = @"";
    
    if (message) {
        if (!bot) {
            [[Networking sharedInstance] analyzeMessage:message withCompletion:^(NSDictionary *result) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString *action = result[@"action"];
                    NSString *type = result[@"type"];
                    if ([action isEqualToString:@"open"]) {
                        
                        if ([type isEqualToString:@"camera"]) {
                            UIImagePickerController *picker = [UIImagePickerController new];
                            picker.delegate = self;
                            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                            [self presentViewController:picker animated:YES completion:nil];
                        } else if ([type isEqualToString:@"gallery"]) {
                            UIImagePickerController *picker = [UIImagePickerController new];
                            picker.delegate = self;
                            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                            [self presentViewController:picker animated:YES completion:nil];
                        } else {
                            [self sendMessage:@"I don't really know where you actually want to get your photo from. Can you say that again?" image:nil bot:YES];
                        }
                        
                    } else if ([action isEqualToString:@"crop"]) {
                        
                    } else if ([action isEqualToString:@"effect"]) {
                        
                    } else if ([action isEqualToString:@"hashtag"]) {
                        
                    } else if ([action isEqualToString:@"share"]) {
                        
                    } else {
                        
                    }
                });
            }];
        }
    }
    
//    else {
//        NSData *fileData = UIImageJPEGRepresentation(image, 1.0);
//        [[Networking sharedInstance] analyzeImage:fileData withCompletion:^(NSString *result) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self sendMessage:result image:nil bot:YES];
//            });
//        }];
//    }
}

- (IBAction)send:(UIButton *)sender {
    [self sendMessage:self.textField.text image:nil bot:NO];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    if (self.messages[row].bot) {
        if (self.messages[row].image) {
            RightImageCell *cell = (RightImageCell *)[tableView dequeueReusableCellWithIdentifier:rightImageCellIdentifier forIndexPath:indexPath];
            [cell setMessage:self.messages[indexPath.row]];
            return cell;
        } else {
            LeftTextCell *cell = (LeftTextCell *)[tableView dequeueReusableCellWithIdentifier:leftTextCellIdentifier forIndexPath:indexPath];
            [cell setMessage:self.messages[indexPath.row]];
            return cell;
        }
    } else {
        if (self.messages[row].image) {
            LeftImageCell *cell = (LeftImageCell *)[tableView dequeueReusableCellWithIdentifier:leftImageCellIdentifier forIndexPath:indexPath];
            [cell setMessage:self.messages[row]];
            return cell;
        } else {
            RightTextCell *cell = (RightTextCell *)[tableView dequeueReusableCellWithIdentifier:rightTextCellIdentifier forIndexPath:indexPath];
            [cell setMessage:self.messages[indexPath.row]];
            return cell;
        }
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.messages[indexPath.row].image) {
        return 300;
    } else {
        return self.messages[indexPath.row].textSize.height + 55;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    self.currentImage = chosenImage;
    [picker dismissViewControllerAnimated:YES completion:^{
        [self sendMessage:nil image:self.currentImage bot:YES];
        [self sendMessage:@"Here we got your photo. What you wanna do next?" image:nil bot:YES];
    }];
}

@end
