//
//  ArquivoTabela.h
//  CompareForMe
//
//  Created by Narlei Moreira on 03/02/15.
//  Copyright (c) 2015 NarleiMoreira. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Arquivo.h"
@interface ArquivoTabela : NSObject
@property (nonatomic,strong) Arquivo *arquivoLeft;
@property (nonatomic,strong) Arquivo *arquivoRigth;
@property (nonatomic)   BOOL identicos;
@end
