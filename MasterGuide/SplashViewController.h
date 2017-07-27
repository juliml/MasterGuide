//
//  SplashViewController.h
//  MasterGuide
//
//  Created by Juliana Lima on 17/10/12.
//  Copyright (c) 2012 Flip Design. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingletonManager.h"
#import "JSONFetcher.h"

@interface SplashViewController : UIViewController <ProcessDataDelegate>
{
    JSONFetcher *connectionJSON;
    SingletonManager *singleton;
}
@property (strong, nonatomic) JSONFetcher *connectionJSON;
@property (strong, nonatomic) SingletonManager *singleton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *carregador;
@property (weak, nonatomic) IBOutlet UIImageView *imagemFundo;

- (BOOL) checkConexaoInternet;

@end
