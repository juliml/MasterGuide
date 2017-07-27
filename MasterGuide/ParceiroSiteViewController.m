//
//  ParceiroSiteViewController.m
//  MasterGuide
//
//  Created by Juliana Lima on 26/09/12.
//  Copyright (c) 2012 Flip Design. All rights reserved.
//

#import "ParceiroSiteViewController.h"
#import "Language.h"

@interface ParceiroSiteViewController ()

@end

@implementation ParceiroSiteViewController
@synthesize btnBack, titulo, webview, pageActionSheet, txtLink, txtTitulo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [btnBack setTitle:[Language get:@"btnCancelar" alter:nil] forState:UIControlStateNormal];
    
    self.titulo.text = txtTitulo;
    [self.titulo setFont:[UIFont fontWithName:@"Zeppelin 33" size:18.0]];
    
    NSString *urlAddress = txtLink;
    
    //Create a URL object.
    NSURL *url = [NSURL URLWithString:urlAddress];
    
    //URL Requst Object
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    //Load the request in the UIWebView.
    [webview loadRequest:requestObj];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setWebview:nil];
    [self setBtnBack:nil];
    [self setTitulo:nil];
    [super viewDidUnload];
}
- (IBAction)backView:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self dismissModalViewControllerAnimated:TRUE];
}

- (IBAction)openShared:(id)sender {
    
    pageActionSheet = [[UIActionSheet alloc]
                       initWithTitle:nil
                       delegate:self
                       cancelButtonTitle:nil
                       destructiveButtonTitle:nil
                       otherButtonTitles:nil];
    

    [pageActionSheet addButtonWithTitle:[Language get:@"btnShareLink" alter:nil]];
    [pageActionSheet addButtonWithTitle:[Language get:@"btnShareEmail" alter:nil]];
    
    [pageActionSheet addButtonWithTitle:[Language get:@"btnCancelar" alter:nil]];
    pageActionSheet.cancelButtonIndex = [self.pageActionSheet numberOfButtons]-1;
    
    [pageActionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
}

#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:[Language get:@"btnShareLink" alter:nil]]) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = txtLink;
    }
    
    else if([title isEqualToString:[Language get:@"btnShareEmail" alter:nil]]) {
        
		MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        mailViewController.mailComposeDelegate = self;
        
        [[mailViewController navigationBar] setTintColor:[UIColor colorWithRed:136/255.f green:2/255.f blue:22/255.f alpha:1.0]];
        
        [mailViewController setSubject:[Language get:@"txtShareEmail" alter:nil]];
        [mailViewController setMessageBody:txtLink isHTML:YES];
        
        [self presentViewController:mailViewController animated:YES completion:nil];
        //[self presentModalViewController:mailViewController animated:YES];
	}
    
    pageActionSheet = nil;
}

#pragma mark -
#pragma mark MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
	//[self dismissModalViewControllerAnimated:YES];
}

@end
