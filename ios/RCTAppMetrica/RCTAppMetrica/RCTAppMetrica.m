#import "RCTAppMetrica.h"
#import <YandexMobileMetrica/YandexMobileMetrica.h>

@implementation RCTAppMetrica {

}

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(activateWithApiKey:(NSString *)apiKey)
{
    YMMYandexMetricaConfiguration *configuration = [[YMMYandexMetricaConfiguration alloc] initWithApiKey:apiKey];
    [YMMYandexMetrica activateWithConfiguration:configuration];
}

RCT_EXPORT_METHOD(activateWithConfig:(NSDictionary *)config) {
    YMMYandexMetricaConfiguration *configuration = [[YMMYandexMetricaConfiguration alloc] initWithApiKey:config[@"apiKey"]];
    if (config[@"sessionTimeout"] != (id)[NSNull null]) {
        [configuration setSessionTimeout:[config[@"sessionTimeout"] intValue]];
    }
    if (config[@"firstActivationAsUpdate"] != (id)[NSNull null]) {
        [configuration setHandleFirstActivationAsUpdate:[config[@"firstActivationAsUpdate"] boolValue]];
    }
    [YMMYandexMetrica activateWithConfiguration:configuration];
}

RCT_EXPORT_METHOD(reportEvent:(NSString *)message)
{
    [YMMYandexMetrica reportEvent:message onFailure:NULL];
}

RCT_EXPORT_METHOD(reportEvent:(NSString *)message parameters:(nullable NSDictionary *)params)
{
    [YMMYandexMetrica reportEvent:message parameters:params onFailure:NULL];
}

RCT_EXPORT_METHOD(reportRevenue:(NSString *)productId price:(nonnull NSNumber *)price quantity:(NSUInteger)quantity)
{
    NSDecimalNumber *decimalPrice = [NSDecimalNumber decimalNumberWithDecimal:[price decimalValue]];
    YMMMutableRevenueInfo *revenueInfo = [[YMMMutableRevenueInfo alloc] initWithPriceDecimal:decimalPrice currency:@"RUB" quantity:quantity productID:productId  transactionID:NULL receiptData:NULL payload:NULL];

    [YMMYandexMetrica reportRevenue:[revenueInfo copy] onFailure:^(NSError *error) {
        NSLog(@"Revenue error: %@", error);
    }];
}

RCT_EXPORT_METHOD(reportError:(NSString *)message) {
    NSException *exception = [[NSException alloc] initWithName:message reason:nil userInfo:nil];
    [YMMYandexMetrica reportError:message exception:exception onFailure:NULL];
}

RCT_EXPORT_METHOD(setUserProfileID:(NSString *)userProfileID) {
    [YMMYandexMetrica setUserProfileID:userProfileID];
}
@end
