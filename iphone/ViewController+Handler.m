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

-(void)confirmNewUser:(NSArray *)jsonVal :(UIView *)view{
    NSDictionary *dict = jsonVal[0];
    NSString *response = [dict valueForKey:@"COUNT(1)"];
    if ([response isEqualToString:@"0"]){
        
        [ToastView showToast:view withText:@"Success!" withDuaration:1.0];
    }else{
        [ToastView showToast:view withText:@"This username is taken!" withDuaration:1.0];   
    }
}

-(BOOL)stringIsNotNull:(NSString *)checkString{
    if (checkString == (id)[NSNull null] || checkString.length == 0){
        return NO;
    }else{
        return YES;
    }
}

@end
