//
//  CellAjustes.h
//  MasterGuide
//
//  Created by Juliana Lima on 15/09/12.
//  Copyright (c) 2012 Flip Design. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellAjustes : UITableViewCell
+ (NSString *)reuseIdentifier;
@property (strong, nonatomic) IBOutlet UILabel *titulo;
@property (weak, nonatomic) IBOutlet UISwitch *habilita;


@end
