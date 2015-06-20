//
//  ViewController+Handler.h
//  Paste Dump
//
//  Created by Vishal Kuo on 2015-06-17.
//  Copyright (c) 2015 VishalKuo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (Handler)

- (BOOL)confirmNewUser:(NSArray *) jsonVal :(UIView *)view;

-(BOOL)stringIsNotNull:(NSString *)checkString;

-(NSString *)fetchMostRecentPasteString:(NSString *)username withBlock:(void (^)(NSString *myString))block;

-(void)saveLoginData:(NSString *)username;

@property (weak, nonatomic) NSString *pasteValue;

@end
