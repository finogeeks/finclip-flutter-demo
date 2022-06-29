//
//  FATFlutterViewController.m
//  Runner
//
//  Created by Haley on 2022/6/29.
//  Copyright © 2022 The Chromium Authors. All rights reserved.
//

#import "FATFlutterViewController.h"

@interface FATFlutterViewController ()

@end

@implementation FATFlutterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    if (self.presentedViewController) {
        return;
    }
    [super touchesBegan:touches withEvent:event];
  
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
    if (self.presentedViewController) {
        return;
    }
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
    if (self.presentedViewController) {
        return;
    }
    [super touchesEnded:touches withEvent:event];
}

@end
