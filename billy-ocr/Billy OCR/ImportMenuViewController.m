//
//  ImportMenuViewController.m
//  Billy OCR
//
//  Created by Pedago on 22/07/16.
//  Copyright (c) 2016 Etna. All rights reserved.
//

#import "ImportMenuViewController.h"

@interface ImportMenuViewController ()

@end

@implementation ImportMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)import:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        picker.allowsEditing = false;
        [self presentViewController:picker animated:true completion:nil];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    self._imageImport = info[UIImagePickerControllerOriginalImage];
    [self performSegueWithIdentifier:@"importMenuToAnalyseSegue" sender:self];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"importMenuToAnalyseSegue"]) {
        AnalyseViewController *vc = [segue destinationViewController];
        vc._contentType = @"application/octet-stream";
        vc._imageImport = self._imageImport;
    }
}

@end
