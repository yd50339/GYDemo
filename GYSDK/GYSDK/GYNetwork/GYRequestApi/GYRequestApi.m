//
//  RequestApi.m
//  MyProject
//
//  Created by yd on 2017/7/20.
//  Copyright © 2017年 yd. All rights reserved.
//

#import "GYRequestApi.h"

static NSString * const kCharactersToBeEscapedInQueryString = @":/?&=;+!@#$()',*";
static NSString * PercentEscapedQueryStringFromStringWithEncoding(NSString *string, NSStringEncoding encoding)
{
   return  [string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet  characterSetWithCharactersInString:kCharactersToBeEscapedInQueryString].invertedSet];
//    return (__bridge_transfer  NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)string, NULL, (__bridge CFStringRef)kCharactersToBeEscapedInQueryString, CFStringConvertNSStringEncodingToEncoding(encoding));
}


#pragma mark -
@interface QueryStringPair : NSObject
@property (readwrite, nonatomic, strong) id field;
@property (readwrite, nonatomic, strong) id value;

- (id)initWithField:(id)field value:(id)value;

- (NSString *)URLEncodedStringValueWithEncoding:(NSStringEncoding)stringEncoding;
@end

@implementation QueryStringPair

- (id)initWithField:(id)field value:(id)value
{
    self = [super init];
    if (!self)
    {
        return nil;
    }
    
    self.field = field;
    self.value = value;
    
    return self;
}

- (NSString *)URLEncodedStringValueWithEncoding:(NSStringEncoding)stringEncoding {
    if (!self.value || [self.value isEqual:[NSNull null]])
    {
        return  PercentEscapedQueryStringFromStringWithEncoding([self.field description], stringEncoding);
    }
    else
    {
        return [NSString stringWithFormat:@"%@=%@", PercentEscapedQueryStringFromStringWithEncoding([self.field description], stringEncoding), PercentEscapedQueryStringFromStringWithEncoding([self.value description], stringEncoding)];
    }
    
    return nil;
}

@end


@interface GYRequestApi()

@property (readwrite, nonatomic, strong) NSMutableDictionary *mutableHTTPRequestHeaders;

@property (nonatomic, strong) NSSet *HTTPMethodsEncodingParametersInURI;

@end

@implementation GYRequestApi


- (NSDictionary *)HTTPRequestHeaders
{
    return [NSDictionary dictionaryWithDictionary:self.mutableHTTPRequestHeaders];
}

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                 URLString:(NSString *)URLString
                                parameters:(NSDictionary *)parameters
                                     error:(NSError *__autoreleasing *)error
{
    NSParameterAssert(method);
    NSParameterAssert(URLString);
    
    NSURL *url = [NSURL URLWithString:URLString];
    
    NSParameterAssert(url);
    
    NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    mutableRequest.HTTPMethod = method;
    mutableRequest.timeoutInterval = 60;
    
    mutableRequest = [[self requestBySerializingRequest:mutableRequest
                                         withParameters:parameters
                                                  error:error] mutableCopy];
    return mutableRequest;
}


#pragma mark - AFURLRequestSerialization

#pragma mark -
static NSString * QueryStringFromParametersWithEncoding(NSDictionary *parameters, NSStringEncoding stringEncoding)
{
    NSMutableArray *mutablePairs = [NSMutableArray array];
    for (QueryStringPair *pair in QueryStringPairsFromDictionary(parameters)) {
        [mutablePairs addObject:[pair URLEncodedStringValueWithEncoding:stringEncoding]];
    }
    
    return [mutablePairs componentsJoinedByString:@"&"];
}

NSArray * QueryStringPairsFromDictionary(NSDictionary* dictionary)
{
    NSMutableArray *mutableQueryStringComponents = [NSMutableArray array];
    if ([dictionary isKindOfClass:[NSDictionary class]])
    {
        for (id key in dictionary.allKeys)
        {
            id value = [dictionary objectForKey:key];
            if (value)
            {
                [mutableQueryStringComponents addObject:[[QueryStringPair alloc] initWithField:key value:value]];
            }
        }
    }
    return mutableQueryStringComponents;
}


- (NSURLRequest *)requestBySerializingRequest:(NSURLRequest *)request
                               withParameters:(id)parameters
                                        error:(NSError *__autoreleasing *)error
{
    NSParameterAssert(request);
    
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    
    [self.HTTPRequestHeaders enumerateKeysAndObjectsUsingBlock:^(id field, id value, BOOL * __unused stop) {
        if (![request valueForHTTPHeaderField:field])
        {
            [mutableRequest setValue:value forHTTPHeaderField:field];
        }
    }];
    
    if (!parameters)
    {
        return mutableRequest;
    }
    
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    NSString * query =  [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    if ([self.HTTPMethodsEncodingParametersInURI containsObject:[[request HTTPMethod] uppercaseString]])
    {
        query = QueryStringFromParametersWithEncoding(parameters, NSUTF8StringEncoding);
        mutableRequest.URL = [NSURL URLWithString:[[mutableRequest.URL absoluteString] stringByAppendingFormat:mutableRequest.URL.query ? @"&%@" : @"?%@", query]];
    }
    else
    {
        NSString *charset = (__bridge NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
        [mutableRequest setValue:[NSString stringWithFormat:@"application/json; charset=%@", charset] forHTTPHeaderField:@"Content-Type"];
        [mutableRequest setHTTPBody:[query dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    return mutableRequest;
}



@end
