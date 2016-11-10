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
#import "Filter.h"

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
@property (nonatomic) UIImage *lastImage;
@property (nonatomic) NSString *currentDescription;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Darth Bot";
    self.navigationController.navigationBar.translucent = NO;
    
    self.messages = [NSMutableArray array];
    
//    self.tableView.backgroundColor = [UIColor botLightBlue];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.contentOffset = CGPointMake(0, 100);
    
    [self.tableView registerNib:[UINib nibWithNibName:@"RightTextCell" bundle:nil] forCellReuseIdentifier:rightTextCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"LeftTextCell" bundle:nil] forCellReuseIdentifier:leftTextCellIdentifier];
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"RightImageCell" bundle:nil] forCellReuseIdentifier:rightImageCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"LeftImageCell" bundle:nil] forCellReuseIdentifier:leftImageCellIdentifier];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self sendMessage:@"Hi, I am the Darth Bot!\nI can help you to edit your photos faster. Just tell me if you want to choose photo from your photo gallery or take a new with camera?" image:nil bot:YES];
    
    self.tableView.estimatedRowHeight = 150.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

#pragma mark - Private

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    CGSize keyboardSize = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    CGFloat animationDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    UIViewAnimationCurve animationCurve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    [UIView animateWithDuration:animationDuration
                          delay:0
                        options:(animationCurve << 16)
                     animations:^{
                         self.bottomConstraint.constant = keyboardSize.height;
                         [self.view layoutIfNeeded];
                     } completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    CGFloat animationDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    UIViewAnimationCurve animationCurve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    [UIView animateWithDuration:animationDuration
                          delay:0
                        options:(animationCurve << 16)
                     animations:^{
                         self.bottomConstraint.constant = 0;
                         [self.view layoutIfNeeded];
                     } completion:nil];
}

- (void)sendMessage:(NSString *)message image:(UIImage *)image bot:(BOOL)bot {
    if (!message.length && !image) {
        return;
    }
    [self.messages addObject:[[ChatMessageData alloc] initWith:message image:image bot:bot maxTextWidth:self.view.frame.size.width - 300]];
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messages.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    self.textField.text = @"";
    
    if (message) {
        if (!bot) {
            [[Networking sharedInstance] analyzeMessage:message withCompletion:^(NSDictionary *result) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    NSString *action = result[@"action"];
                    NSString *type = result[@"type"];
                    
                    if ([action isEqualToString:@"cameraFront"]) {
                        
                        [self sendMessage:@"Qucik take a selfie while the moment is still alive. Don't forget to smile :)" image:nil bot:YES];
                        
                        UIImagePickerController *picker = [UIImagePickerController new];
                        picker.delegate = self;
                        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                        picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
                        [self presentViewController:picker animated:YES completion:nil];
                        
                    } else if ([action isEqualToString:@"cameraRear"]) {
                        
                        [self sendMessage:@"Take a nice photo with camera and then let's edit together." image:nil bot:YES];
                        
                        UIImagePickerController *picker = [UIImagePickerController new];
                        picker.delegate = self;
                        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                        picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
                        [self presentViewController:picker animated:YES completion:nil];
                        
                    } else if ([action isEqualToString:@"gallery"]) {
                        
                        [self sendMessage:@"I will open your image gallery so you can choose your next masterpiece." image:nil bot:YES];
                        
                        UIImagePickerController *picker = [UIImagePickerController new];
                        picker.delegate = self;
                        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                        [self presentViewController:picker animated:YES completion:nil];
                        
                    } else if ([action isEqualToString:@"crop"]) {
                        
                        if (!self.currentImage) {
                            [self sendMessage:@"You didn't choose any photo yet. Choose one and then let's edit!" image:nil bot:YES];
                            return;
                        }
                        
                        self.lastImage = self.currentImage;
                        
                        CGFloat min = MIN(self.currentImage.size.width, self.currentImage.size.height);
                        self.currentImage = [self imageByCroppingImage:self.currentImage toSize:CGSizeMake(min, min)];
                        [self sendMessage:nil image:self.currentImage bot:YES];
                        [self sendMessage:@"Alright I cropped your photo square. What else you would like to do?" image:nil bot:YES];
                        
                    } else if ([action isEqualToString:@"effect"]) {
                        
                        if (!self.currentImage) {
                            [self sendMessage:@"You didn't choose any photo yet. Choose one and then let's edit!" image:nil bot:YES];
                            return;
                        }
                        
                        self.lastImage = self.currentImage;
                        
                        if ([type isEqualToString:@"black and white"]) {
                            self.currentImage = [Filter BlackAndWhite:self.currentImage];
                            [self sendMessage:nil image:self.currentImage bot:YES];
                            [self sendMessage:@"Awesome effect is ready. What's next?" image:nil bot:YES];
                        } else if ([type isEqualToString:@"sepia"]) {
                            self.currentImage = [Filter Sepia:self.currentImage];
                            [self sendMessage:nil image:self.currentImage bot:YES];
                            [self sendMessage:@"Awesome effect is ready. What's next?" image:nil bot:YES];
                        } else if ([type isEqualToString:@"chrome"]) {
                            self.currentImage = [Filter Chrome:self.currentImage];
                            [self sendMessage:nil image:self.currentImage bot:YES];
                            [self sendMessage:@"Awesome effect is ready. What's next?" image:nil bot:YES];
                        } else {
                            [self sendMessage:@"I don't have that effect in my library now. Would you like to choose from available ones?\n1. Sepia\n2. Chrome\n3. Black and White" image:nil bot:YES];
                        }
                        
                    } else if ([action isEqualToString:@"hashtag"]) {
                        
                        if (!self.currentImage) {
                            [self sendMessage:@"You didn't choose any photo yet. Choose one and then let's edit!" image:nil bot:YES];
                            return;
                        }
                        
                        [self sendMessage:@"Wait a second I will think something cool..." image:nil bot:YES];
                        NSData *fileData = UIImageJPEGRepresentation(self.currentImage, 1.0);
                        
                        if (!fileData) {
                            fileData = UIImagePNGRepresentation(self.currentImage);
                        }
                        
                        [[Networking sharedInstance] analyzeImage:fileData withCompletion:^(NSString *result) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                if (result) {
                                    self.currentDescription = result;
                                    [self sendMessage:result image:nil bot:YES];
                                } else {
                                    [self sendMessage:@"Image tagging went wrong. Try again." image:nil bot:YES];
                                }
                                
                            });
                        }];
                        
                    } else if ([action isEqualToString:@"share"]) {
                        
                        if (!self.currentImage) {
                            [self sendMessage:@"You didn't choose any photo yet. Choose one and then let's edit!" image:nil bot:YES];
                            return;
                        }
                        
                        [self sendMessage:@"Great photo to share! I am sure people will love this." image:nil bot:YES];
                        
                        NSMutableArray *items = [NSMutableArray array];
                        
                        if (self.currentImage) {
                            [items addObject:self.currentImage];
                        }
                        
                        if (self.currentDescription) {
                            [items addObject:self.currentDescription];
                        }
                        UIActivityViewController *controller = [[UIActivityViewController alloc]initWithActivityItems:items applicationActivities:nil];
                        [self presentViewController:controller animated:YES completion:nil];
                    } else if ([action isEqualToString:@"greeting"]) {
                        
                         [self sendMessage:@"Hola Amigo! Let's make some really awesome photos together!" image:nil bot:YES];
                        
                    } else if ([action isEqualToString:@"undo"]) {
                        
                        if (!self.currentImage) {
                            [self sendMessage:@"You didn't choose any photo yet. Choose one and then let's edit!" image:nil bot:YES];
                            return;
                        }
                        
                        if (!self.lastImage) {
                            [self sendMessage:@"You don't have any recent changes. Play a little bit with photos and if you don't like your change let me revert it for you!" image:nil bot:YES];
                            return;
                        }
                        
                        self.currentImage = self.lastImage;
                        self.lastImage = nil;
                        [self sendMessage:nil image:self.currentImage bot:YES];
                        [self sendMessage:@"I dicarded you last change and now you can go for anohter try." image:nil bot:YES];
                        
                    } else {
                        
                       [self sendMessage:@"I don't how to help you with this. I can do things like:\n1. Apply effects\n2. Crop photos\n3. Auto add hashtags\n4. Smart description\n5. Share photos" image:nil bot:YES];
                        
                    }
                });
            }];
        }
    }
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
            LeftImageCell *cell = (LeftImageCell *)[tableView dequeueReusableCellWithIdentifier:leftImageCellIdentifier forIndexPath:indexPath];
            [cell setMessage:self.messages[row]];
            return cell;
        } else {
            LeftTextCell *cell = (LeftTextCell *)[tableView dequeueReusableCellWithIdentifier:leftTextCellIdentifier forIndexPath:indexPath];
            [cell setMessage:self.messages[indexPath.row]];
            return cell;
        }
    } else {
        if (self.messages[row].image) {
            RightImageCell *cell = (RightImageCell *)[tableView dequeueReusableCellWithIdentifier:rightImageCellIdentifier forIndexPath:indexPath];
            [cell setMessage:self.messages[indexPath.row]];
            return cell;
        } else {
            RightTextCell *cell = (RightTextCell *)[tableView dequeueReusableCellWithIdentifier:rightTextCellIdentifier forIndexPath:indexPath];
            [cell setMessage:self.messages[indexPath.row]];
            return cell;
        }
        
    }
}

#pragma mark - UITableViewDelegate

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    [self.view endEditing:YES];
//}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    self.currentImage = [self normalizedImage:chosenImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        [self sendMessage:nil image:self.currentImage bot:YES];
        [self sendMessage:@"Here we go with your great photo. What you wanna do next?" image:nil bot:YES];
    }];
}

#pragma mark - Image Effects

- (UIImage *)normalizedImage:(UIImage *)image {
    if (image.imageOrientation == UIImageOrientationUp) return image;
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    [image drawInRect:(CGRect){0, 0, image.size}];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return normalizedImage;
}

- (UIImage *)imageByCroppingImage:(UIImage *)image toSize:(CGSize)size {
    double refWidth = CGImageGetWidth(image.CGImage);
    double refHeight = CGImageGetHeight(image.CGImage);
    
    double x = (refWidth - size.width) / 2.0;
    double y = (refHeight - size.height) / 2.0;
    
    CGRect cropRect = CGRectMake(x, y, size.height, size.width);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);
    
    UIImage *cropped = [UIImage imageWithCGImage:imageRef scale:0.0 orientation:image.imageOrientation];
    CGImageRelease(imageRef);
    
    return cropped;
}

@end
