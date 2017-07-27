//
//  ParceiroSiteViewController.h
//  MasterGuide
//
//  Created by Juliana Lima on 26/09/12.
//  Copyright (c) 2012 Flip Design. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface ParceiroSiteViewController : UIViewController <MFMailComposeViewControllerDelegate, UIActionSheetDelegate>
{
    NSString *txtTitulo;
    NSString *txtLink;
}
@property (strong, nonatomic) NSString *txtTitulo;
@property (strong, nonatomic) NSString *txtLink;

@property (weak, nonatomic) IBOutlet UIWebView *webview;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UILabel *titulo;

@property (nonatomic, strong, readonly) UIActionSheet *pageActionSheet;

- (IBAction)backView:(id)sender;
- (IBAction)openShared:(id)sender;

@end
