//
//  ViewController.h
//  Paste Dump
//
//  Created by Vishal Kuo on 2015-05-10.
//  Copyright (c) 2015 VishalKuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import "AFNetworking.h"

@interface ViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) NSString *pasteValue;
@property (strong, nonatomic) NSString *userId;
@property (weak, nonatomic) NSString *username;
@property (weak, nonatomic) NSURLSessionUploadTask *uploadTask;
@property (weak, nonatomic) NSURLSessionUploadTask *pasteTask;

@property (weak, nonatomic) IBOutlet UILabel *loginStat;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
@property (nonatomic, retain) IBOutlet UITextView *mostRecentPaste;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIButton *makeAPasteButton;
@property (weak, nonatomic) IBOutlet UIButton *clipboardButton;
@property (weak, nonatomic) IBOutlet UITextField *makePasteField;
@property (weak, nonatomic) IBOutlet UIButton *refreshButton;
@property (weak, nonatomic) IBOutlet UIButton *fbShareButton;

@property (nonatomic, assign) BOOL isInPasteState;
@property (weak, nonatomic) NSDictionary *json;
@property (weak, nonatomic) NSArray *paste;
@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic) NSMutableURLRequest *req;
@property (weak, nonatomic) NSData *data;
@property (strong, nonatomic) NSURL *url;
@property (strong, nonatomic) FBSDKLoginManager* loginManager;
@property (nonatomic, assign) BOOL isLoggedIn;

@property (readonly) UIImage *bgImage;
@property (readonly) UIImage *fbBgImage;

-(void)startSpinning;
-(void)stopSpinning;
-(void)setPasteValueField:(NSString *)val;

@end

