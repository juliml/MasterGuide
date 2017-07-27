//
//  AppDelegate.h
//  MasterGuide
//
//  Created by Lindolfo Lacerda on 13/09/12.
//  Copyright (c) 2012 Flip Design. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingletonManager.h"
#import "JSONFetcher.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    UIViewController *menuController;
    UIViewController *compartilhaController;
    
    SingletonManager *singleton;
}

@property (strong, nonatomic) SingletonManager *singleton;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;
@property (retain, nonatomic) UIViewController *menuController;
@property (retain, nonatomic) UIViewController *compartilhaController;

@end
