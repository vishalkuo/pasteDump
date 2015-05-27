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
#import "ToastView.h"
#import "Reachability.h"

@interface ViewController ()

-(void)setHide:(BOOL)isHidden;
-(void)startSpinning;
-(void)stopSpinning;
-(void)fbMethod;
-(void)setButtonTitle;
-(void)copyToClipboard;
-(void)togglePaste;
-(void)loginProcedure;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isInPasteState = NO;
    [_makePasteField setReturnKeyType:UIReturnKeySend];
    
    self.makePasteField.delegate = self;
    //=====UI DECLARATION=====//
    [self setPasteValue:@""];
    [self initHide];
    _bgImage = [UIImage imageNamed:@"ButtonBg.png"];
    _fbBgImage = [UIImage imageNamed:@"ButtonBgFb.png"];
    _loginManager = [[FBSDKLoginManager alloc] init];
    
    
    
    [_facebookButton addTarget:self
               action:@selector(fbMethod)
     forControlEvents:UIControlEventTouchUpInside];
    
    [_clipboardButton addTarget:self action:@selector(copyToClipboard) forControlEvents:UIControlEventTouchUpInside];
    
    [_makeAPasteButton addTarget:self action:@selector(togglePaste) forControlEvents:UIControlEventTouchUpInside];
    
    [_refreshButton addTarget:self action:@selector(refreshScreen) forControlEvents:UIControlEventTouchUpInside];
    
    //=====POST INFO=====//
    _url = [NSURL URLWithString:@"http://www.vishalkuo.com/pastebin.php"];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    _session = [NSURLSession sessionWithConfiguration:config];
    _req = [[NSMutableURLRequest alloc] initWithURL:_url];
    _req.HTTPMethod = @"POST";
    
    //=====STATE ADJUSTMENT=====//
    if ([FBSDKAccessToken currentAccessToken]) {
        [self loginProcedure];
    }else{
        [self stopSpinning];
        [self setHide:YES];
    }
        [self setButtonTitle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setHide:(BOOL)isHidden{
    if (isHidden){
        [self fadeOutAnimation:_loginStat];
        [self fadeOutAnimation:_makeAPasteButton];
        [self fadeOutAnimation:_mostRecentPaste];
        [self fadeOutAnimation:_clipboardButton];
        [self fadeOutAnimation:_makePasteField];
        [self fadeOutAnimation:_refreshButton];
        [self stopSpinning];
    }else{
        _loginStat.alpha = 1.0f;
        _makeAPasteButton.alpha = 1.0f;
        _mostRecentPaste.alpha = 1.0f;
        _clipboardButton.alpha = 1.0f;
        _refreshButton.alpha = 1.0f;
    }

}
-(void)togglePaste{
    if(!_isInPasteState){
        _mostRecentPaste.alpha = 0;
        _makePasteField.alpha = 1;
        _loginStat.alpha = 0;
        _refreshButton.alpha = 0;
        _makePasteField.text = @"";
        [_clipboardButton setTitle:@"Send" forState:UIControlStateNormal];
        [_makeAPasteButton setTitle:@"Back" forState:UIControlStateNormal];
    }else{
        _mostRecentPaste.alpha = 1;
        _makePasteField.alpha = 0;
        _loginStat.alpha = 1;
        _refreshButton.alpha = 1;
        [_clipboardButton setTitle:@"Copy to Clipboard" forState:UIControlStateNormal];
        [_makeAPasteButton setTitle:@"Make a Paste" forState:UIControlStateNormal];
    }
    _isInPasteState = !_isInPasteState;
}


-(void)fadeOutAnimation:(UIView *)target{
    [UIView animateWithDuration:0.2 animations:^{target.alpha = 0.0;}];
}

-(void)startSpinning{
    [_indicatorView startAnimating];
    _indicatorView.hidden = NO;
}

-(void)stopSpinning{
    _indicatorView.hidden = YES;
    [_indicatorView stopAnimating];
}

-(void)setPasteValueField:(NSString *)val{
    _mostRecentPaste.text = val;
}

-(void)loginProcedure{
    //=====FACEBOOK AUTHENTICATION=====//
    if ([self isConnected]){
        [self startSpinning];
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 _loginStat.text = [NSString stringWithFormat:@"Welcome, %@. \n Your most recent paste was: ", result[@"first_name"]];
                 _userId = result[@"id"];
                 
                 //=====DECLARATION FOR POST REQUEST=====//
                 NSString *postString =  [NSString stringWithFormat:@"id=%@&code=0", _userId];
                 NSData *data = [postString dataUsingEncoding:NSUTF8StringEncoding];
                 if(!error){
                     _uploadTask = [_session uploadTaskWithRequest:_req fromData:data completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                         _json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                         NSArray *paste = [_json valueForKey:@"paste"];
                         NSArray *res = [_json valueForKey:@"response"];
                         (dispatch_async(dispatch_get_main_queue(), ^{
                            [self setHide:NO];
                            _facebookButton.alpha = 1.0f;
                             _pasteValue = paste[0];
                             [self stopSpinning];
                             if([res[0] integerValue] == 100){
                                 _mostRecentPaste.text = @"No pastes found";
                             }else{
                                 _mostRecentPaste.text = _pasteValue;
                            }

                         }));
                     }];
                 }
                 [_uploadTask resume];
             }
         }];
    }else{
        [self setHide:NO];
        _loginStat.text = @"No internet connection.\n Please try again later.";
    }
            [self stopSpinning];


}

-(void)setButtonTitle{
    if ([FBSDKAccessToken currentAccessToken]) {
        [_facebookButton setTitle:@"Logout" forState:UIControlStateNormal];
        [_facebookButton setBackgroundImage:_bgImage forState:UIControlStateNormal];
    }else{
        [_facebookButton setTitle:@"" forState:UIControlStateNormal];
        [_facebookButton setBackgroundImage:_fbBgImage forState:UIControlStateNormal];
    }
}

-(void)fbMethod{
    //Double declaration because of race conditions
    if ([FBSDKAccessToken currentAccessToken]){
        [_loginManager logOut];
        _isInPasteState = YES;
        [self togglePaste];
        [self setHide:YES];
        [self setButtonTitle];
    }
    else if ([self isConnected]){
        [_loginManager logInWithReadPermissions:@[@"email"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            if (error){
            } else if (result.isCancelled){
            }else{
                [self loginProcedure];
                [self setButtonTitle];
            }
        }];
    }else{
        [ToastView showToast:self.view withText:@"No Internet!" withDuaration:1.0];
    }
}
-(void)initHide{
    _loginStat.alpha = 0;
    _makeAPasteButton.alpha = 0;
    _mostRecentPaste.alpha = 0;
    _clipboardButton.alpha = 0;
    _refreshButton.alpha = 0;
}

-(void)copyToClipboard{
    if (!_isInPasteState){
        NSString *copyValue = _mostRecentPaste.text;
        UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
        [pasteBoard setString:copyValue];
        [ToastView showToast:self.view withText:@"Copied to Clipboard!" withDuaration:0.75];
    }else{
        [self sendPasteWithText:_makePasteField.text];
    }
   
}

- (IBAction)unwindFromConfirmationForm:(UIStoryboardSegue *)segue {
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self sendPasteWithText:textField.text];
    return YES;
}

-(void)sendPasteWithText:(NSString *)sendValue{
    NSString *postString = [NSString stringWithFormat:@"id=%@&code=1&paste=%@", _userId, sendValue];
    NSData *data = [postString dataUsingEncoding:NSUTF8StringEncoding];
    _pasteTask = [_session uploadTaskWithRequest:_req fromData:data completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        (dispatch_async(dispatch_get_main_queue(), ^{
            [ToastView showToast:self.view withText:@"Sent!" withDuaration:0.75];
        }));
    }];
    if ([self isConnected]){
        [_pasteTask resume];
        _makePasteField.text = @"";
    }else{
        [ToastView showToast:self.view withText:@"No Internet!" withDuaration:1.0];
    }
    
}
- (void)  loginButton:(FBSDKLoginButton *)loginButton
didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
                error:(NSError *)error{
    
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton{
    
}

-(BOOL)canBecomeFirstResponder{
    return YES;
}

-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    if(motion == UIEventSubtypeMotionShake && [FBSDKAccessToken currentAccessToken]){
        [self refreshScreen];
    }
}

-(void)refreshScreen{
    if ([self isConnected] && [FBSDKAccessToken currentAccessToken]){
        [ToastView showToast:self.view withText:@"Refreshing!" withDuaration:0.75];
            [self loginProcedure];
    }
}

-(BOOL)isConnected{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus stat = [networkReachability currentReachabilityStatus];
    if (stat == NotReachable){
        return NO;
    }else{
        return YES;
    }
}


@end
