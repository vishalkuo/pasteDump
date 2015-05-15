//
//  ViewController.m
//  Paste Dump
//
//  Created by Vishal Kuo on 2015-05-10.
//  Copyright (c) 2015 VishalKuo. All rights reserved.
//

#import "ViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>


@interface ViewController ()

-(void)setHide:(BOOL)isHidden;
-(void)startSpinning;
-(void)stopSpinning;

@end

@implementation ViewController  

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setHide:YES];
    // Do any additional setup after loading the view, typically from a nib.
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    CGPoint loginPos = self.view.center;
    loginPos.y += 200;
    loginButton.center = loginPos;
    [self.view addSubview:loginButton];

    NSURL *url = [NSURL URLWithString:@"http://www.vishalkuo.com/pastebin.php"];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:url];
    req.HTTPMethod = @"POST";
    
    NSDictionary *dictionary = @{@"id": @"1"};
    NSString *test = @"id=1";
    NSError *error = nil;
    NSData *data = [test dataUsingEncoding:NSUTF8StringEncoding];
    
    if(!error){
        NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:req fromData:data completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"%@", [json valueForKey:@"paste"]);
        }];
        
        [uploadTask resume];
    }
        
    
        
    
    
    if ([FBSDKAccessToken currentAccessToken]) {
        [self setHide:NO];
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 [self startSpinning];
                 NSString *output = [NSString stringWithFormat:@"Welcome, %@", result[@"name"]];
                 self.loginStat.text = output;
                 NSLog(@"fetched user:%@", result);
                 [self setHide:NO];
                 //[dataTask resume];
                 self.mostRecentPaste.text = @"Your most recent paste was: \n";
                 [self setHide:YES];
             }
         }];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setHide:(BOOL)isHidden{
    self.loginStat.hidden = isHidden;
    self.mostRecentPaste.hidden = isHidden;
    self.indicatorView.hidden = isHidden;
}


-(void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton{
    [self setHide:YES];
}

-(void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error{
    [self setHide:NO];
}

-(void)startSpinning{
    self.indicatorView.startAnimating;
}

-(void)stopSpinning{
    self.indicatorView.stopAnimating;
}





@end
