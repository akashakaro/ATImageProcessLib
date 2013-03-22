//
//  IPShareViewController.h
//  ImageProcess
//
//  Created by Rakesh Kumar on 12/03/13.
//  Copyright (c) 2013 Akaro Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "MPNotificationView.h"

@interface IPShareViewController : UIViewController <MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate,FBRequestDelegate, FBSessionDelegate,UIDocumentInteractionControllerDelegate> {
    
    UIImageView *imgViewPreview;
    UIImage *imgPreview;
    NSUserDefaults *perfs;
    UIDocumentInteractionController *dic;
}

@property (nonatomic, strong) IBOutlet UIImageView *imgViewPreview;
@property (nonatomic, strong) UIImage *imgPreview;
@property (nonatomic, retain) UIDocumentInteractionController *dic;

//Actions
- (IBAction)actionFBTapped:(id)sender;
- (IBAction)actionEmailTapped:(id)sender;
- (IBAction)actionSaveToLibTapped:(id)sender;
- (IBAction)actionSMSTapped:(id)sender;
- (IBAction)actionShareOnInstagramTapped:(id)sender;

@end
