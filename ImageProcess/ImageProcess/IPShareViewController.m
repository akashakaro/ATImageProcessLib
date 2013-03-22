//
//  IPShareViewController.m
//  ImageProcess
//
//  Created by Rakesh Kumar on 12/03/13.
//  Copyright (c) 2013 Akaro Technologies. All rights reserved.
//

#import "IPShareViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface IPShareViewController ()

@end

@implementation IPShareViewController
@synthesize imgViewPreview;
@synthesize imgPreview;
@synthesize dic;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    perfs = [NSUserDefaults standardUserDefaults];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonClicked)];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.imgViewPreview.image = self.imgPreview;
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- Bar Seletors

- (void)doneButtonClicked {
    [self dismissViewControllerAnimated:TRUE completion:nil];
}


#pragma mark- Actions

- (IBAction)actionFBTapped:(id)sender {
    [self imFbLogin];
}


- (IBAction)actionEmailTapped:(id)sender {
    [self sendByEmail:self.imgPreview];
}

- (IBAction)actionSaveToLibTapped:(id)sender {
    UIImageWriteToSavedPhotosAlbum(self.imgPreview, appDelegate, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (IBAction)actionSMSTapped:(id)sender {
    [self sendMMS:self.imgPreview];
}


#pragma mark- Action Methods
- (void)sendByEmail:(UIImage *)image {
    
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        mailViewController.navigationBar.tintColor = [UIColor blackColor];
        mailViewController.navigationController.navigationBar.barStyle = UIBarStyleBlack;
        NSArray *mRecepients = nil;
        mailViewController.title = @"My Edited Image";
        mailViewController.mailComposeDelegate = self;
        [mailViewController setToRecipients:mRecepients];
        [mailViewController setSubject:@"My Edited Image"];
        
        NSString *strMsg = [NSString string];
        //Exercise
        strMsg =  [strMsg stringByAppendingFormat:@"Check This Pic"];
        
        
        strMsg = [strMsg stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
        [mailViewController setMessageBody:strMsg isHTML:FALSE];
        
        //Convert the image into data
        NSData *imageProd = [NSData dataWithData:UIImagePNGRepresentation(image)];
        
        [mailViewController addAttachmentData:imageProd mimeType:@"image/png" fileName:@"image"];
        
        
        
        [self presentViewController:mailViewController animated:TRUE completion:nil];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"\"Service Not Available" message:@"You cannot send the mail, Please try later !" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}

- (void)sendMMS:(UIImage *)image {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.persistent = YES;
    pasteboard.image = image;
    
    NSString *phoneToCall = @"sms:";
    NSString *phoneToCallEncoded = [phoneToCall stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSURL *url = [[NSURL alloc] initWithString:phoneToCallEncoded];
    [[UIApplication sharedApplication] openURL:url];
    
}


- (void)imFbLogin {
    if ([perfs boolForKey:kUDFaceBookLoggedIn] &&[[appDelegate facebook] isSessionValid]) {
        
        self.navigationItem.rightBarButtonItem = nil;
        [self uploadImageToFacebook:self.imgPreview caption:@"Image Editing Test..."];
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:TRUE];
        
    }
    else {
        NSArray* permissions = [[NSArray alloc] initWithObjects:
                                @"publish_stream", nil];
        [[appDelegate facebook] authorize:permissions delegate:self];
    }
}


- (void)uploadImageToFacebook:(UIImage *)image caption:(NSString *)caption {
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:TRUE];
    
    NSData *imgData = UIImagePNGRepresentation(image);
    
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:imgData forKey:@"image"];
	[params setObject:caption forKey:@"caption"];
    
    [[appDelegate facebook] requestWithGraphPath:@"me/photos" andParams:params andHttpMethod:@"POST" andDelegate:appDelegate];
}



#pragma mark-  MFMailComposeViewController Delegate Method

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	switch (result) {
		case MFMailComposeResultCancelled:
			break;
		case MFMailComposeResultSaved:
			break;
		case MFMailComposeResultSent:{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"\"Success \"" message:@"Mail successfully sent" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
			break;
        }
		case MFMailComposeResultFailed:
			break;
		default: {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email" message:@"Sending Failed – Unknown Error  "
														   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
			[alert show];
		}
			break;
	}
    
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:0.0],UITextAttributeFont,nil];
    
	[self dismissViewControllerAnimated:TRUE completion:nil];
}


#pragma mark- Facebook delegates
- (void)fbDidLogin {
    self.navigationItem.rightBarButtonItem = nil;
     [self uploadImageToFacebook:self.imgPreview caption:@"Image Editing Test..."];
    
    [perfs setBool:TRUE forKey:kUDFaceBookLoggedIn];
    [perfs synchronize];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:TRUE];
}


-(void)fbDidNotLogin:(BOOL)cancelled {
    
    [[appDelegate facebook] logout:self];
    [perfs setBool:FALSE forKey:kUDFaceBookLoggedIn];
    [perfs synchronize];
    
	NSLog(@"did not login");
}

- (IBAction)actionShareOnInstagramTapped:(id)sender {
   
    NSURL *instagramURL = [NSURL URLWithString:@"instagram://media?id=MEDIA_ID"];
    if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
    CGRect rect = CGRectMake(0 ,0 , 0, 0);
    
    self.dic.UTI = @"com.instagram.photo";
    
    NSURL *urlFile = [NSURL fileURLWithPath:[self imSaveImage:self.imgPreview]];
                      
    self.dic = [self setupControllerWithURL:urlFile usingDelegate:self];
    
    self.dic = [UIDocumentInteractionController interactionControllerWithURL:urlFile];
   
    
    [self.dic presentOpenInMenuFromRect: rect inView: self.view animated: YES ];
    }
}


- (UIDocumentInteractionController *) setupControllerWithURL: (NSURL*) fileURL usingDelegate: (id <UIDocumentInteractionControllerDelegate>) interactionDelegate {
    UIDocumentInteractionController *interactionController = [UIDocumentInteractionController interactionControllerWithURL: fileURL];
    interactionController.delegate = interactionDelegate;
    return interactionController;
}

#pragma mark- UIDocumentInteractionController delegates

- (void)documentInteractionController:(UIDocumentInteractionController *)controller willBeginSendingToApplication:(NSString *)application {
    MPNotificationView *notificationCustom = [MPNotificationView notifyWithText:@"Start..." andDetail:@"Sending Started..."];
    notificationCustom.delegate = nil;
}


- (void)documentInteractionController:(UIDocumentInteractionController *)controller didEndSendingToApplication:(NSString *)application {
    MPNotificationView *notificationCustom = [MPNotificationView notifyWithText:@"Success!" andDetail:@"Sending Done."];
    notificationCustom.delegate = nil;
}


#pragma mark- Instnace Methods

- (NSString *)imSaveImage:(UIImage *)image {
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *tempPath = [docPaths objectAtIndex:0];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSFileManager *fileMGR = [NSFileManager defaultManager];
    
    BOOL isDir= TRUE;
    if (![fileMGR fileExistsAtPath:[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",@"ProcessedImages"]] isDirectory:&isDir]) {
        [fileMGR createDirectoryAtPath:[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",@"ProcessedImages"]]  withIntermediateDirectories:FALSE attributes:nil error:nil];
    }
    
    
    NSString *fileName = [NSString stringWithFormat:@"%@/%@/%@.igo",tempPath,@"ProcessedImages",@"myImage"];
    
    UIImage *tempImage = nil;
    tempImage = image;
    NSData *pngData = UIImagePNGRepresentation(tempImage);
    
    [pngData writeToFile:fileName atomically:YES]; //Write the file
    
    return fileName;
}


@end
