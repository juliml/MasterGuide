//
//  CameraViewController.h
//  MasterGuide
//
//  Created by Lindolfo Lacerda on 14/09/12.
//  Copyright (c) 2012 Flip Design. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Twitter/Twitter.h>
#import "MBProgressHUD.h"
#import "SingletonManager.h"

@interface CameraViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    SingletonManager *singleton;
}
@property (strong, nonatomic) SingletonManager *singleton;
@property (weak, nonatomic) IBOutlet UILabel *texto;
@property (weak, nonatomic) IBOutlet UIButton *btnFoto;

- (IBAction)openCamera:(id)sender;

@end
