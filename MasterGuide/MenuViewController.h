//
//  MenuViewController.h
//  MasterGuide
//
//  Created by Lindolfo Lacerda on 14/09/12.
//  Copyright (c) 2012 Flip Design. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingletonManager.h"

@interface MenuViewController : UITableViewController
{
    NSMutableArray *itens;
    
}
@property (strong, nonatomic) SingletonManager *singleton;
@property (strong, nonatomic) IBOutlet UITableView *tabela;
- (void) reloadMenu;
@end
