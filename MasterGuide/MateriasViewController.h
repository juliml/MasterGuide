//
//  MateriasViewController.h
//  MasterGuide
//
//  Created by Juliana Lima on 15/09/12.
//  Copyright (c) 2012 Flip Design. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellMateria.h"

#import "MBProgressHUD.h"
#import "SingletonManager.h"
#import "JSONFetcher.h"

@interface MateriasViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MBProgressHUDDelegate>
{
    NSMutableArray *itens;
    MBProgressHUD *HUD;
    
    JSONFetcher *connectionJSON;
    SingletonManager *singleton;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tabela;
@property (assign, nonatomic) IBOutlet CellMateria *customCell;

@property (strong, nonatomic) JSONFetcher *connectionJSON;
@property (strong, nonatomic) SingletonManager *singleton;

@end
