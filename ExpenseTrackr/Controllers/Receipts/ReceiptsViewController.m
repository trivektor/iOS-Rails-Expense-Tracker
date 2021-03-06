//
//  ReceiptsViewController.m
//  ExpenseTrackr
//
//  Created by Tri Vuong on 11/9/12.
//  Copyright (c) 2012 Crafted By Tri. All rights reserved.
//

#import "ReceiptsViewController.h"
#import "KeychainHelper.h"
#import "AppConfig.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "SpinnerView.h"
#import "SVPullToRefresh.h"
#import "Receipt.h"
#import "ReceiptImageCell.h"
#import "AQGridViewController.h"
#import "AQGridViewCell.h"
#import "ReceiptViewController.h"

@interface ReceiptsViewController ()

@end

@implementation ReceiptsViewController

@synthesize spinnerView, receipts, receiptsGridView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.receipts = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setDelegates];
    [self performHouseKeepingTasks];
    [self setupPullToRefresh];
    [self fetchReceiptsFromServer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)performHouseKeepingTasks
{
    [self.navigationItem setTitle:@"Receipts"];
    
    UIBarButtonItem *newReceipt = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:@selector(showNewReceiptForm)];
    [newReceipt setImage:[UIImage imageNamed:@"camera_icon.png"]];
    [newReceipt setTintColor:[UIColor blackColor]];
    
    [self.navigationItem setRightBarButtonItem:newReceipt];
    
    self.receiptsGridView = [[AQGridView alloc] initWithFrame:CGRectMake(0, 0, 320, 548)];
    self.receiptsGridView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.receiptsGridView.autoresizesSubviews = NO;
    self.receiptsGridView.dataSource = self;
    self.receiptsGridView.delegate = self;
    [self.view addSubview:self.receiptsGridView];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"gray_jean.png"]]];
}

- (void)setDelegates
{
}

- (void)setupPullToRefresh
{
}

- (void)fetchReceiptsFromServer
{
    NSString *authToken = [KeychainHelper getAuthenticationToken];
    
    NSURL *receiptsIndexURL = [NSURL URLWithString:[AppConfig getConfigValue:@"ReceiptsIndexPath"]];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:receiptsIndexURL];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   authToken, @"token",
                                   nil];
    
    NSMutableURLRequest *getRequest = [httpClient requestWithMethod:@"GET" path:receiptsIndexURL.absoluteString parameters:params];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:getRequest];
    
    [operation setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject){
         
         [self.receipts removeAllObjects];
         
         NSString *response = [operation responseString];
         
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
         
         NSArray *receiptsJSON = [json valueForKey:@"receipts"];
         
         Receipt *r;
         
         for (NSDictionary *receipt in receiptsJSON) {
             
             r = [[Receipt alloc] init];
             r.receiptId        = [[receipt valueForKey:@"id"] intValue];
             r.name             = [receipt valueForKey:@"name"];
             r.description      = [receipt valueForKey:@"description"];
             r.createdAt        = [receipt valueForKey:@"created_at"];
             r.thumbImageURL    = [receipt valueForKey:@"thumb_image_url"];
             r.mediumImageURL   = [receipt valueForKey:@"medium_image_url"];
             r.fullImageURL     = [receipt valueForKey:@"full_image_url"];
             [self.receipts addObject:r];
         }
         
         [self.receiptsGridView reloadData];
         [self.spinnerView removeFromSuperview];

     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [self.spinnerView removeFromSuperview];
     }];
    
    self.spinnerView = [SpinnerView loadSpinnerIntoView:self.view];
    [operation start];
}

- (void)showNewReceiptForm
{
    UIImagePickerController *p = [[UIImagePickerController alloc] init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [p setSourceType:UIImagePickerControllerSourceTypeCamera];
    } else {
        [p setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    [p setDelegate:self];
    
    [self presentViewController:p animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    @try {
        UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        //UIImage *scaledImage = [ReceiptsViewController imageWithImage:image scaledToSize:CGSizeMake(320, 480)];
        //UIImage *scaledImage = [ReceiptsViewController imageWithImage:originalImage scaledToSizeWithSameAspectRatio:CGSizeMake(960, 1440)];
        [self postReceiptImage:originalImage];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception.description);
    }
    @finally {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)postReceiptImage:(UIImage *)image
{
    NSData *imageData = [NSData dataWithData:UIImageJPEGRepresentation(image, .1)];
    
    NSString *imageString = [NSString stringWithFormat:@"%@", imageData];
    imageString = [imageString stringByReplacingOccurrencesOfString:@" " withString:@""];
    imageString = [imageString substringWithRange:NSMakeRange(1, [imageString length]-2)];
    
    NSString *authToken = [KeychainHelper getAuthenticationToken];
    
    NSURL *createReceiptURL = [NSURL URLWithString:[AppConfig getConfigValue:@"CreateReceiptPath"]];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:createReceiptURL];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   authToken, @"token",
                                   //receiptParams, @"receipt",
                                   nil];

    NSMutableURLRequest *postRequest = [httpClient multipartFormRequestWithMethod:@"POST" path:createReceiptURL.absoluteString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:@"receipt[image]" fileName:@"receipt.jpg" mimeType:@"image/jpeg"];
    }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:postRequest];
    
    [operation setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject){
         NSString *response = [operation responseString];
         
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
         
         [self.spinnerView removeFromSuperview];
     }
    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.spinnerView removeFromSuperview];
    }];
    
    self.spinnerView = [SpinnerView loadSpinnerIntoView:self.view];
    [operation start];
    
}

// Nice solution to scale image from http://stackoverflow.com/questions/1282830/uiimagepickercontroller-uiimage-memory-and-more
+ (UIImage *)imageWithImage:(UIImage *)sourceImage scaledToSize:(CGSize)newSize
{
    CGFloat targetWidth = newSize.width;
    CGFloat targetHeight = newSize.height;
    
    CGImageRef imageRef = [sourceImage CGImage];
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);
    
    if (bitmapInfo == kCGImageAlphaNone) {
        bitmapInfo = kCGImageAlphaNoneSkipLast;
    }
    
    CGContextRef bitmap;
    
    if (sourceImage.imageOrientation == UIImageOrientationUp || sourceImage.imageOrientation == UIImageOrientationDown) {
        bitmap = CGBitmapContextCreate(NULL, targetWidth, targetHeight, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
        
    } else {
        bitmap = CGBitmapContextCreate(NULL, targetHeight, targetWidth, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
        
    }
    
    if (sourceImage.imageOrientation == UIImageOrientationLeft) {
        CGContextRotateCTM (bitmap, 90*M_PI/180);
        CGContextTranslateCTM (bitmap, 0, -targetHeight);
        
    } else if (sourceImage.imageOrientation == UIImageOrientationRight) {
        CGContextRotateCTM (bitmap, -90*M_PI/180);
        CGContextTranslateCTM (bitmap, -targetWidth, 0);
        
    } else if (sourceImage.imageOrientation == UIImageOrientationUp) {
        // NOTHING
    } else if (sourceImage.imageOrientation == UIImageOrientationDown) {
        CGContextTranslateCTM (bitmap, targetWidth, targetHeight);
        CGContextRotateCTM (bitmap, -180*M_PI/180);
    }
    
    CGContextDrawImage(bitmap, CGRectMake(0, 0, targetWidth, targetHeight), imageRef);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage* newImage = [UIImage imageWithCGImage:ref];
    
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    
    return newImage;
}

// Nice solution to scale image from http://stackoverflow.com/questions/1282830/uiimagepickercontroller-uiimage-memory-and-more
+ (UIImage*)imageWithImage:(UIImage*)sourceImage scaledToSizeWithSameAspectRatio:(CGSize)targetSize;
{
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor) {
            scaleFactor = widthFactor; // scale to fit height
        }
        else {
            scaleFactor = heightFactor; // scale to fit width
        }
        
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    CGImageRef imageRef = [sourceImage CGImage];
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);
    
    if (bitmapInfo == kCGImageAlphaNone) {
        bitmapInfo = kCGImageAlphaNoneSkipLast;
    }
    
    CGContextRef bitmap;
    
    if (sourceImage.imageOrientation == UIImageOrientationUp || sourceImage.imageOrientation == UIImageOrientationDown) {
        bitmap = CGBitmapContextCreate(NULL, targetWidth, targetHeight, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
        
    } else {
        bitmap = CGBitmapContextCreate(NULL, targetHeight, targetWidth, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
        
    }
    
    // In the right or left cases, we need to switch scaledWidth and scaledHeight,
    // and also the thumbnail point
    if (sourceImage.imageOrientation == UIImageOrientationLeft) {
        thumbnailPoint = CGPointMake(thumbnailPoint.y, thumbnailPoint.x);
        CGFloat oldScaledWidth = scaledWidth;
        scaledWidth = scaledHeight;
        scaledHeight = oldScaledWidth;
        
        CGContextRotateCTM (bitmap, 90*M_PI/180);
        CGContextTranslateCTM (bitmap, 0, -targetHeight);
        
    } else if (sourceImage.imageOrientation == UIImageOrientationRight) {
        thumbnailPoint = CGPointMake(thumbnailPoint.y, thumbnailPoint.x);
        CGFloat oldScaledWidth = scaledWidth;
        scaledWidth = scaledHeight;
        scaledHeight = oldScaledWidth;
        
        CGContextRotateCTM (bitmap, -90*M_PI/180);
        CGContextTranslateCTM (bitmap, -targetWidth, 0);
        
    } else if (sourceImage.imageOrientation == UIImageOrientationUp) {
        // NOTHING
    } else if (sourceImage.imageOrientation == UIImageOrientationDown) {
        CGContextTranslateCTM (bitmap, targetWidth, targetHeight);
        CGContextRotateCTM (bitmap, -180*M_PI/180);
    }
    
    CGContextDrawImage(bitmap, CGRectMake(thumbnailPoint.x, thumbnailPoint.y, scaledWidth, scaledHeight), imageRef);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage* newImage = [UIImage imageWithCGImage:ref];
    
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    
    return newImage;
}

- (CGSize)portraitGridCellSizeForGridView:(AQGridView *)gridView
{
    return CGSizeMake(140, 140);
}

- (NSUInteger)numberOfItemsInGridView:(AQGridView *)gridView
{
    return receipts.count;
}

- (AQGridViewCell *)gridView:(AQGridView *)gridView cellForItemAtIndex:(NSUInteger)index
{
    Receipt *r = [self.receipts objectAtIndex:index];
    
    ReceiptImageCell *cell = (ReceiptImageCell *)[gridView dequeueReusableCellWithIdentifier:@"ReceiptImageCell"];
    if (cell == NULL) {
        cell = [[ReceiptImageCell alloc] initWithFrame:CGRectMake(0.0, 0.0, 110, 85) reuseIdentifier:@"ReceiptImageCell"];
    }
    
    NSString *thumbImageURL = [r.thumbImageURL stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:thumbImageURL]];
    
    [cell.receiptThumb setImage:[UIImage imageWithData:imageData]];
    
    return cell;
}

- (void)gridView:(AQGridView *)gridView didDeselectItemAtIndex:(NSUInteger)index
{
    ReceiptViewController *receiptController = [[ReceiptViewController alloc] init];
    
    receiptController.receipt = [self.receipts objectAtIndex:index];
    receiptController.modalPresentationStyle = UIModalTransitionStyleCoverVertical;
    
    UINavigationController *newNavController = [[UINavigationController alloc] initWithRootViewController:receiptController];
    
    [self presentViewController:newNavController animated:YES completion:nil];
}

@end
