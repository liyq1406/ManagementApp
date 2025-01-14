//
//  ProductDetailCell.h
//  ManagementApp
//
//  Created by 邱成西 on 15/10/27.
//  Copyright © 2015年 suda_505. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModel.h"
#import "ProductStockModel.h"

@interface ProductDetailCell : UITableViewCell

@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, strong) ProductModel *productModel;

@property (nonatomic, strong) ProductStockModel *productStockModel;
@end
