//
//  STLStoreKitManager.m
//  HelloStaticline
//
//  Created by Carsten Witzke on 20.09.12.
//  Copyright (c) 2012 staticline. All rights reserved.
//

#import "STLStoreKitManager.h"

NSString *const kSTLPurchaseConsumableFoo1 = @"de.staticline.hello.foo_1";
NSString *const kSTLPurchaseNRenewingHappy1h = @"de.staticline.hello.happiness_1h";


@interface STLStoreKitManager ()
@property (nonatomic, retain) SKProductsRequest *productRequest;
@end


@implementation STLStoreKitManager
@synthesize availableProducts = _availableProducts;
@synthesize productIdentifiers = _productIdentifiers;

- (NSSet *)productIdentifiers
{
    if (_productIdentifiers) {
        return _productIdentifiers;
    }
    NSMutableSet *tmp = [NSMutableSet setWithObjects:kSTLPurchaseConsumableFoo1, kSTLPurchaseNRenewingHappy1h, nil];
    self.productIdentifiers = [NSSet setWithSet:tmp];
    return _productIdentifiers;
}

#pragma mark - STLStoreKitManagerProtocoll

- (void)requestProducts
{
    self.productRequest = [[[SKProductsRequest alloc] initWithProductIdentifiers:self.productIdentifiers] autorelease];
    _productRequest.delegate = self;
    [_productRequest start];
}

#pragma mark - SKProductsRequestDelegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSLog(@"%s %@", __PRETTY_FUNCTION__, response);
}

#pragma mark - SKRequestDelegate

- (void)requestDidFinish:(SKRequest *)request
{
    NSLog(@"%s %@", __PRETTY_FUNCTION__, request);
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"%s %@", __PRETTY_FUNCTION__, error);
}

#pragma mark - SKPaymentTransactionObserver

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    NSLog(@"%s %@", __PRETTY_FUNCTION__, transactions);
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    NSLog(@"%s %@", __PRETTY_FUNCTION__, error);
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    NSLog(@"%s %@", __PRETTY_FUNCTION__, queue);
}

@end
