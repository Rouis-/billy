//
//  SigninDolibarrViewController.m
//  Billy OCR
//
//  Created by Pedago on 22/07/16.
//  Copyright (c) 2016 Etna. All rights reserved.
//

#import "SigninDolibarrViewController.h"

@interface SigninDolibarrViewController ()

@end

@implementation SigninDolibarrViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submit:(id)sender {
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@%@",@"http://billy-etna.cloudapp.net/dolibarr/api/index.php/login?login=",self.username.text,@"&password=",self.password.text];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSError __block *err = NULL;
    NSData __block *data;
    BOOL __block reqProcessed = false;
    NSURLResponse __block *resp;
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable _data, NSURLResponse * _Nullable _response, NSError * _Nullable _error) {
        resp = _response;
        err = _error;
        data = _data;
        reqProcessed = true;
    }] resume];
    while (!reqProcessed) {
        [NSThread sleepForTimeInterval:0];
    }
    NSLog(@"RESPONSE : %lu", data.length);
    if ([self username].text.length > 0 && [self password].text.length > 0 && data.length == 143)
    {
        NSDictionary *greeting = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:0
                                                                   error:NULL];
        if([greeting objectForKey:@"success"]){
            NSDictionary *token =[greeting  objectForKey:@"success"];
            [[NSUserDefaults standardUserDefaults] setObject:[token objectForKey:@"token" ]forKey:@"token"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self performSegueWithIdentifier:@"signinDolibarrToImportSegue" sender:self];
        }
        else {
            [self errorLabel].text = @"Identifiants incorrects";
        }
    }
    else {
        [self errorLabel].text = @"Identifiants incorrects";
    }
}

@end
