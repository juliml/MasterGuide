//
//  CellTelefone.h
//  MasterGuide
//
//  Created by Juliana Lima on 24/09/12.
//  Copyright (c) 2012 Flip Design. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellTelefone : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lb_nome;
@property (weak, nonatomic) IBOutlet UILabel *lb_fone;
+ (NSString *)reuseIdentifier;

@end
