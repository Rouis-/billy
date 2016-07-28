//
//  AnalyseViewController.h
//  Billy OCR
//
//  Created by Kevin VALAT on 26/07/16.
//  Copyright © 2016 Etna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VerificationViewController.h"

@interface AnalyseViewController : UIViewController

@property(copy, nonatomic) NSMutableArray *_dataJson;
@property(copy, nonatomic) NSString *_contentType;
@property(copy, nonatomic) UIImage *_imageImport;

@end
