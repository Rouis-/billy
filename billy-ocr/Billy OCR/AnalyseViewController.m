//
//  AnalyseViewController.m
//  Billy OCR
//
//  Created by Kevin VALAT on 26/07/16.
//  Copyright © 2016 Etna. All rights reserved.
//

#import "AnalyseViewController.h"
#import <Foundation/Foundation.h>

@interface AnalyseViewController ()

@end

@implementation AnalyseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"Image1 : %@", self._imageImport);
    
    float height = [[UIScreen mainScreen] bounds].size.height;
    float width = [[UIScreen mainScreen] bounds].size.width;
    UIImageView *imageview = [[UIImageView alloc] initWithImage:self._imageImport];
    imageview.frame = CGRectMake(0, 75, width, height - 75);
    [self.view addSubview:imageview];
    [self traceRectangle];

    NSDictionary *parameters;
    NSData *postData;
    NSMutableURLRequest *request;
    
    NSDictionary *headers = @{ @"content-type": self._contentType,
                               @"ocp-apim-subscription-key": @"e001fc07be4e4855bbc79a4d97be504b",
                               @"cache-control": @"no-cache",
                               @"postman-token": @"bcfd9e2e-f31c-9baa-3f29-a83aa6a6b97c" };
    
    if ([self._contentType isEqual: @"application/octet-stream"]) {
        postData = UIImagePNGRepresentation(self._imageImport);
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://api.projectoxford.ai/vision/v1.0/ocr?language=fr&detectOrientation=true"]
                                          cachePolicy:NSURLRequestUseProtocolCachePolicy
                                      timeoutInterval:10.0];
        [request setHTTPMethod:@"POST"];
        [request setAllHTTPHeaderFields:headers];
        [request setHTTPBody:postData];
    }
    else if ([self._contentType isEqual: @"application/json"]) {
        parameters = @{ @"url": @"http://www.i-manuel.fr/GA_animer/GA_animerpart1dos1AC1doc2img1.jpg" };
        postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://api.projectoxford.ai/vision/v1.0/ocr?language=fr&detectOrientation=true"]
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:10.0];
        [request setHTTPMethod:@"POST"];
        [request setAllHTTPHeaderFields:headers];
        [request setHTTPBody:postData];
    }
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        NSLog(@"%@", error);
                                                    } else {
                                                        self._dataJson = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: nil];
                                                        NSLog(@"%@", self._dataJson);
                                                    }
                                                }];
    [dataTask resume];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (int)traceRectangle {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    path = [path stringByAppendingPathComponent:@"vision.json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    if (!data) {
        NSLog(@"Data not here. No data. No data is bad. Bad bad data. Bad human. Unable to use data.");
        return (1);
    }
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    NSArray *regions = [json objectForKey:@"regions"];
    for (int i = 0; i < 2; ++i) {
        NSDictionary *test = [regions objectAtIndex:i];
        NSArray *bounds = [[test objectForKey:@"boundingBox"] componentsSeparatedByString:@","];
        
        UIView *rect  = [[UIView alloc] initWithFrame:CGRectMake((long)[[bounds objectAtIndex:0] integerValue], (long)[[bounds objectAtIndex:1] integerValue] + 75, (long)[[bounds objectAtIndex:2] integerValue], (long)[[bounds objectAtIndex:3] integerValue] -75)];
        rect.backgroundColor = [UIColor colorWithRed: 0.0 green: 0.0 blue: 1.0 alpha: 0.3];
        rect.layer.borderColor = [UIColor colorWithRed: 0.0 green: 0.0 blue: 1.0 alpha: 1].CGColor;
        rect.layer.borderWidth = 2.0f;
        [self.view addSubview:rect];
    }
    return (0);
}

- (IBAction)validate:(id)sender {
    [self performSegueWithIdentifier:@"analyseToVerificationSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"analyseToVerificationSegue"]) {
        VerificationViewController *vc = [segue destinationViewController];
        vc._dataJson = self._dataJson;
    }
}
@end
