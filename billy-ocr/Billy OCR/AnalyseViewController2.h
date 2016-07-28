//
//  AnalyseViewController.h
//  Billy OCR
//
//  Created by Pedago on 22/07/16.
//  Copyright (c) 2016 Etna. All rights reserved.
//

#import "ViewController.h"

#import "GTMOAuth2ViewControllerTouch.h"
#import "GTLDrive.h"

@interface AnalyseViewController : ViewController

@property (nonatomic, strong) GTLServiceDrive *service;
@property (nonatomic, strong) UITextView *output;

@end
