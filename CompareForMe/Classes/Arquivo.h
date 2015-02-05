//
//  Arquivo.h
//  CompareForMe
//
//  Created by Narlei Moreira on 02/02/15.
//  Copyright (c) 2015 NarleiMoreira. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSData+MD5.h"
@interface Arquivo : NSObject
@property (nonatomic,strong) NSString *nome;
@property (nonatomic,strong) NSString *path;
@property (nonatomic,strong) NSDictionary *attributes;
@property (nonatomic,strong) NSString *md5;

@end
