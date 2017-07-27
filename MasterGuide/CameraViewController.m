//
//  CameraViewController.m
//  MasterGuide
//
//  Created by Lindolfo Lacerda on 14/09/12.
//  Copyright (c) 2012 Flip Design. All rights reserved.
//

#import "CameraViewController.h"
#import "IIViewDeckController.h"

#import "Language.h"

#import "SHK.h"
#import "SHKTwitter.h"

@interface CameraViewController ()

@end

@implementation CameraViewController
@synthesize singleton;

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
    
    singleton = [SingletonManager sharedController];
    
    //BOTAO MENU
    UIButton *btnMenu =[[UIButton alloc] init];
    [btnMenu setBackgroundImage:[UIImage imageNamed:@"NavBar_MenuBtn.png"] forState:UIControlStateNormal];
    
    btnMenu.frame = CGRectMake(100, 100, 40, 31);
    UIBarButtonItem *barBtnMenu =[[UIBarButtonItem alloc] initWithCustomView:btnMenu];
    [btnMenu addTarget:self.viewDeckController action:@selector(toggleLeftView) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = barBtnMenu;
    [[self.tabBarController viewDeckController] setEnabled:FALSE];
    
    //TITULO
    CGRect frame = CGRectMake(0, 0, 120, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Zeppelin 33" size:18.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = [Language get:@"titCamera" alter:nil];
    
    self.navigationItem.titleView = label;

}

- (void) viewDidAppear:(BOOL)animated
{
    UILabel *label = (UILabel *) self.navigationItem.titleView;
    label.text = [Language get:@"titCamera" alter:nil];
    
    [self.texto setFont:[UIFont fontWithName:@"Zeppelin 32" size:17.0]];
    self.texto.text = [Language get:@"txtCamera" alter:nil];
    [self.btnFoto setTitle:[Language get:@"btnCamera" alter:nil] forState:UIControlStateNormal];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)openCamera:(id)sender {
    
    if ([singleton setTwitter])
    {
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:HUD];
        HUD.dimBackground = YES;
        HUD.delegate = self;
        [HUD show:YES];
        
        if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            return;
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.allowsEditing = YES;
        [self presentViewController:picker animated:YES completion:nil];
        
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Language get:@"alertSociaisTitulo" alter:nil] message:[Language get:@"alertSociaisTexto" alter:nil] delegate:self cancelButtonTitle:[Language get:@"btnCancelar" alter:nil] otherButtonTitles:[Language get:@"btnConfirmar" alter:nil],nil];
        [alert setTag:1];
        [alert show];
    }
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        NSLog(@"Cancel Tapped.");
    }
    else if (buttonIndex == 1)
    {
        if ([alertView tag] == 1) //ALERT CONFIGURA
        {
            [self.tabBarController setSelectedIndex:4];
        }
    }
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // Access the uncropped image from info dictionary
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    // Save image
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    
}

-(void)imagePickerControllerDidCancel:
(UIImagePickerController *)picker
{
    [HUD hide:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    UIAlertView *alert;
    [HUD hide:YES];
    
    // Unable to save the image
    if (error) {
        alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                           message:@"Unable to save image to Photo Album."
                                          delegate:self cancelButtonTitle:@"Ok"
                                 otherButtonTitles:nil];
    } else { // All is well
        
        SHKItem *item = [SHKItem image:image title:@"via @masterguideapp"];
        [SHKTwitter shareItem:item];
        
    }
}

@end
