//
//  CompartilhaViewController.h
//  MasterGuide
//
//  Created by Lindolfo Lacerda on 14/09/12.
//  Copyright (c) 2012 Flip Design. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <Twitter/Twitter.h>

#import "SingletonManager.h"

@interface CompartilhaViewController : UITableViewController <MFMailComposeViewControllerDelegate>
{
    NSMutableArray *itens;
    UITableViewCell *cellFavoritar;
    
    Boolean favorito;
    SingletonManager *singleton;
    
}
@property (strong, nonatomic) UITableViewCell *cellFavoritar;
@property (strong, nonatomic) IBOutlet UITableView *tabela;
@property (strong, nonatomic) SingletonManager *singleton;
- (void) reloadMenu;
- (void) checkFavorito;

@end
