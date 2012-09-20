//
//  STLStoreKitManager.h
//  HelloStaticline
//
//  Created by Carsten Witzke on 20.09.12.
//  Copyright (c) 2012 staticline. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>


extern NSString * const kSTLPurchaseConsumableFoo1;
extern NSString * const kSTLPurchaseNRenewingHappy1h;

@protocol STLStoreKitManagerProtocoll <SKProductsRequestDelegate, SKRequestDelegate, SKPaymentTransactionObserver>
/**
 NSSet of valid products in the Apple store
 */
@property (nonatomic, strong) NSArray *availableProducts;

/**
 Call for a fresh list of products
 */
- (void)requestProducts;
@end


@interface STLStoreKitManager : NSObject<STLStoreKitManagerProtocoll>
@property (nonatomic, strong) NSSet *productIdentifiers;

@end
