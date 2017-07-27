//
//  AppDelegate.m
//  MasterGuide
//
//  Created by Lindolfo Lacerda on 13/09/12.
//  Copyright (c) 2012 Flip Design. All rights reserved.
//

#import "AppDelegate.h"

#import "MenuViewController.h"
#import "CompartilhaViewController.h"

#import "HomeViewController.h"
#import "CidadeViewController.h"
#import "LocaisViewController.h"
#import "CameraViewController.h"
#import "AjustesViewController.h"

#import "IIViewDeckController.h"
#import "Language.h" 

#import "SHKConfiguration.h"
#import "MySHKConfigurator.h"

#import "SHKFacebook.h"
#import "Flurry.h"

@implementation AppDelegate
@synthesize menuController, compartilhaController;
@synthesize singleton;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Flurry startSession:@"7DBV5HKHMRP7H3YW25MR"];
    
    self.singleton = [SingletonManager sharedController];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    DefaultSHKConfigurator *configurator = [[MySHKConfigurator alloc] init];
    [SHKConfiguration sharedInstanceWithConfigurator:configurator];
    
    //CHECK USER DEFAULTS
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    int idioma = [prefs integerForKey:@"idioma"];
    if (idioma != 0)[self.singleton setIdioma:idioma];
    
    //IDIOMA
    if (idioma == 1) [Language setLanguage:@"pt"];
    else if (idioma == 2) [Language setLanguage:@"en"];
    
    id whatIsThis = [prefs objectForKey:@"favoritos"];
    if([whatIsThis isKindOfClass:[NSMutableArray class]])
    {
        if (whatIsThis != nil)
        {
            [singleton setFavoritos:whatIsThis];
        }
    }
    
    [self.singleton setSetFacebook:[prefs integerForKey:@"facebook"]];
    [self.singleton setSetTwitter:[prefs integerForKey:@"twitter"]];
    [self.singleton setSetFoursquare:[prefs integerForKey:@"foursquare"]];

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) { //IPHONE
        
        UIViewController *viewHome = [[HomeViewController alloc] initWithNibName:@"HomeViewController_iPhone" bundle:nil];
        UIViewController *viewCidade = [[CidadeViewController alloc] initWithNibName:@"CidadeViewController_iPhone" bundle:nil];
        UIViewController *viewLocais = [[LocaisViewController alloc] initWithNibName:@"LocaisViewController_iPhone" bundle:nil];
        UIViewController *viewCamera = [[CameraViewController alloc] initWithNibName:@"CameraViewController_iPhone" bundle:nil];
        UIViewController *viewAjustes = [[AjustesViewController alloc] initWithNibName:@"AjustesViewController_iPhone" bundle:nil];
        
        UINavigationController *navHome = [[UINavigationController alloc] initWithRootViewController:viewHome];
        UINavigationController *navCidade = [[UINavigationController alloc] initWithRootViewController:viewCidade];
        UINavigationController *navLocais = [[UINavigationController alloc] initWithRootViewController:viewLocais];
        UINavigationController *navCamera = [[UINavigationController alloc] initWithRootViewController:viewCamera];
        UINavigationController *navAjustes = [[UINavigationController alloc] initWithRootViewController:viewAjustes];
        
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"NavBar_Background.png"] forBarMetrics:UIBarMetricsDefault];
        
        self.tabBarController = [[UITabBarController alloc] init];
        self.tabBarController.viewControllers = [NSArray arrayWithObjects:navHome, navCidade, navLocais, navCamera, navAjustes, nil];
        
        [self.singleton setPrincipal:self.tabBarController];
    
        //GET TAB
        UITabBar *tabBar = self.tabBarController.tabBar;
        //[tabBar setFrame:CGRectMake(0, 430, 320, 50)];
        [tabBar setBackgroundImage:[UIImage imageNamed:@"TabBar_background.png"]];
        [tabBar setSelectionIndicatorImage:[UIImage imageNamed:@"Btn_Selected.png"]];
        
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            tabBar.frame=CGRectMake(0,430,320,50);
        }
        if(result.height == 568)
        {
            tabBar.frame=CGRectMake(0,519,320,50);
        }
        
        //TAB HOME
        UITabBarItem *itemHome = [tabBar.items objectAtIndex:0];
        [itemHome setTitle:[Language get:@"tabHome" alter:nil]];
        [itemHome setFinishedSelectedImage:[UIImage imageNamed:@"TabBar_Home_Icon.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"TabBar_Home_Icon.png"]];
        

        //TAB CIDADE
        UITabBarItem *itemCidade = [tabBar.items objectAtIndex:1];
        [itemCidade setTitle:[Language get:@"tabCidade" alter:nil]];
        [itemCidade setFinishedSelectedImage:[UIImage imageNamed:@"TabBar_Cidade_Icon.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"TabBar_Cidade_Icon.png"]];
        
        //TAB LOCAIS
        UITabBarItem *itemLocais = [tabBar.items objectAtIndex:2];
        [itemLocais setTitle:[Language get:@"tabLocais" alter:nil]];
        [itemLocais setFinishedSelectedImage:[UIImage imageNamed:@"TabBar_Locais_Icon.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"TabBar_Locais_Icon.png"]];
        
        //TAB CAMERA
        UITabBarItem *itemCamera = [tabBar.items objectAtIndex:3];
        [itemCamera setTitle:[Language get:@"tabCamera" alter:nil]];
        [itemCamera setFinishedSelectedImage:[UIImage imageNamed:@"TabBar_Camera_Icon.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"TabBar_Camera_Icon.png"]];
        
        //TAB AJUSTES
        UITabBarItem *itemAjustes = [tabBar.items objectAtIndex:4];
        [itemAjustes setTitle:[Language get:@"tabAjustes" alter:nil]];
        [itemAjustes setFinishedSelectedImage:[UIImage imageNamed:@"TabBar_Ajustes_Icon.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"TabBar_Ajustes_Icon.png"]];
        
        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor, [UIFont fontWithName:@"Zeppelin 33" size:11.0], UITextAttributeFont, nil] forState:UIControlStateNormal];
        
        
        self.menuController = [[MenuViewController alloc] initWithNibName:@"MenuViewController_iPhone" bundle:nil];
        self.compartilhaController = [[CompartilhaViewController alloc] initWithNibName:@"CompartilhaViewController_iPhone" bundle:nil];
        
        IIViewDeckController *deckController =  [[IIViewDeckController alloc] initWithCenterViewController:self.tabBarController
                                                                                        leftViewController:self.menuController
                                                                                       rightViewController:self.compartilhaController];
        
        deckController.leftLedge = 50;
        deckController.rightLedge = 50;
        
        self.window.rootViewController = deckController;
        
    } else { //IPAD
        
    }
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (BOOL)handleOpenURL:(NSURL*)url
{
    NSString* scheme = [url scheme];
    NSString* prefix = [NSString stringWithFormat:@"fb%@", SHKCONFIG(facebookAppId)];
    if ([scheme hasPrefix:prefix])
        return [SHKFacebook handleOpenURL:url];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [self handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [self handleOpenURL:url];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
