//
//  ParceirosViewController.h
//  MasterGuide
//
//  Created by Juliana Lima on 15/09/12.
//  Copyright (c) 2012 Flip Design. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellParceiro.h"

#import "MBProgressHUD.h"
#import "SingletonManager.h"
#import "JSONFetcher.h"

@interface ParceirosViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MBProgressHUDDelegate>
{
    NSMutableArray *itens;
    
    MBProgressHUD *HUD;
    
    JSONFetcher *connectionJSON;
    SingletonManager *singleton;
}

@property (assign, nonatomic) IBOutlet CellParceiro *customCell;
@property (weak, nonatomic) IBOutlet UITableView *tabela;

@property (strong, nonatomic) JSONFetcher *connectionJSON;
@property (strong, nonatomic) SingletonManager *singleton;

@end
