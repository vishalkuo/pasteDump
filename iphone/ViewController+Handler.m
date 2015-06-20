//
//  ViewController+Handler.m
//  Paste Dump
//
//  Created by Vishal Kuo on 2015-06-17.
//  Copyright (c) 2015 VishalKuo. All rights reserved.
//

#import "ViewController+Handler.h"
#import "ToastView.h"

@implementation ViewController (Handler)

-(BOOL)confirmNewUser:(NSArray *)jsonVal :(UIView *)view{
    NSDictionary *dict = jsonVal[0];
    NSString *response = [dict valueForKey:@"COUNT(1)"];
    if ([response isEqualToString:@"0"]){
        [ToastView showToast:view withText:@"Success!" withDuaration:1.0];
        return YES;
    }else{
        [ToastView showToast:view withText:@"This username is taken!" withDuaration:1.0];
        return NO;
    }
}

-(BOOL)stringIsNotNull:(NSString *)checkString{
    if (checkString == (id)[NSNull null] || checkString.length == 0){
        return NO;
    }else{
        return YES;
    }
}

-(NSString *)fetchMostRecentPasteString:(NSString *)username withBlock:(void (^)(NSString *myString))block{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *userString = [NSString stringWithFormat:@"'%@'", username];
    NSDictionary *params = @{@"id":userString, @"code": @"0"};
    [manager POST:@"http://vishalkuo.com/pastebin.php" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *resp = responseObject;
        NSDictionary *dict = resp[0];
        NSString *response = [dict valueForKey:@"response"];
        if ([response integerValue] == 0){
            NSString *test = [dict valueForKey:@"paste"];
            block(test);
        }else{
            NSString *test = @"No Recent Pastes Found";
            block(test);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [ToastView showToast:self.view withText:@"Something went wrong!" withDuaration:1.0];
    }];
    return @"No Recent Pastes Found";
    
}


-(void)saveLoginData:(NSString *)username{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:@"isLoggedIn"];
    [defaults setValue:username forKey:@"Username"];
}

@end
