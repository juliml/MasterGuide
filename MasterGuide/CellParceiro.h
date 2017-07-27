//
//  CellParceiro.h
//  MasterGuide
//
//  Created by Juliana Lima on 26/09/12.
//  Copyright (c) 2012 Flip Design. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EGOImageView;
@interface CellParceiro : UITableViewCell
{
    EGOImageView* imageView;
}
@property (weak, nonatomic) IBOutlet UIImageView *imagem;
@property (weak, nonatomic) IBOutlet UILabel *titulo;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *carregador;

+ (NSString *)reuseIdentifier;

- (void)initCell;
- (void)setThumbPhoto:(NSString*)photo;

@end
