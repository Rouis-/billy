//
//  SigninViewController.m
//  Billy OCR
//
//  Created by Pedago on 22/07/16.
//  Copyright (c) 2016 Etna. All rights reserved.
//

#import "SigninViewController.h"

@interface SigninViewController ()

@end

@implementation SigninViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submit:(id)sender {
    NSString *username = [self username].text;
    NSString *password = [self password].text;
    NSDictionary *headers = @{ @"cache-control": @"no-cache",
                               @"content-type": @"application/x-www-form-urlencoded" };
    
    NSMutableData *postData = [[NSMutableData alloc] initWithData:[[NSString stringWithFormat:@"username=%@", username] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[[NSString stringWithFormat:@"&password=%@", password] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://billy-etna.cloudapp.net/api.php/login"]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        NSLog(@"%@", error);
                                                        NSLog(@"meuh2");
                                                    }
                                                    else {
                                                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                        NSLog(@"%@", httpResponse);
                                                        NSLog(@"meuh1");
                                                    }
                                                }];
    NSLog(@"Truc : %@", [dataTask error]);
    [dataTask resume];
    
    //[self performSegueWithIdentifier:@"signinInternToImportSegue" sender:self];
}

@end
