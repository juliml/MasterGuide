//
//  CidadeViewController.h
//  MasterGuide
//
//  Created by Lindolfo Lacerda on 14/09/12.
//  Copyright (c) 2012 Flip Design. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EGOImageView.h"
#import <QuartzCore/QuartzCore.h>

#import "SingletonManager.h"
#import "JSONFetcher.h"
#import "MBProgressHUD.h"

@class EGOImageView;
@interface CidadeViewController : UIViewController <UIScrollViewDelegate, MBProgressHUDDelegate>
{
    UITextView *texto;
    
    JSONFetcher *connectionJSON;
    SingletonManager *singleton;
    
    Cidade *cidade;
    
    MBProgressHUD *HUD;
    
    NSMutableArray *arrayImages;
    UIScrollView *images;
    UIPageControl *pageControl;

}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (strong, nonatomic) UITextView *texto;
@property (strong, nonatomic) Cidade *cidade;

@property (nonatomic, retain) UIScrollView *images;
@property (nonatomic, retain) UIPageControl *pageControl;
@property (nonatomic, retain) NSMutableArray *arrayImages;

@property (strong, nonatomic) JSONFetcher *connectionJSON;
@property (strong, nonatomic) SingletonManager *singleton;

@end
