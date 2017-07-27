//
//  TelefonesViewController.h
//  MasterGuide
//
//  Created by Juliana Lima on 18/09/12.
//  Copyright (c) 2012 Flip Design. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingletonManager.h"
#import "CellTelefone.h"
#import "JSONFetcher.h"
#import "MBProgressHUD.h"

@interface TelefonesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MBProgressHUDDelegate>
{
    NSMutableArray *itens;
    NSString *telefone;
    
    JSONFetcher *connectionJSON;
    SingletonManager *singleton;
    
    MBProgressHUD *HUD;
}
@property (strong, nonatomic) NSString *telefone;
@property (weak, nonatomic) IBOutlet UITableView *tabela;
@property (assign, nonatomic) IBOutlet CellTelefone *customCell;

@property (strong, nonatomic) JSONFetcher *connectionJSON;
@property (strong, nonatomic) SingletonManager *singleton;

@end
