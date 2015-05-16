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

@interface ViewController : UIViewController <FBSDKLoginButtonDelegate>

@property (weak, nonatomic) NSString *pasteValue;
@property (weak, nonatomic) NSString *userId;
@property (weak, nonatomic) NSString *username;
@property (weak, nonatomic) NSURLSessionUploadTask *uploadTask;

@property (weak, nonatomic) IBOutlet UILabel *loginStat;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
@property (weak, nonatomic) IBOutlet UILabel *recentHeaderTitle;
@property (nonatomic, retain) IBOutlet UITextView *mostRecentPaste;
@property (weak, nonatomic) NSDictionary *json;

-(void)startSpinning;
-(void)stopSpinning;
-(void)setPasteValueField:(NSString *)val;

@end

