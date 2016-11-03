#import "LoginManager.h"

@interface LoginManager () {
    RKObjectManager *_objectManager;
    RequestToken *_token;
    SessionIDResponse *_sessionIDResponse;
}

@end
@implementation LoginManager
-(void)loginWithLoginRequest:(LoginRequest *)loginData delegate:(id<LoginManagerDelegate>)delegate{
    self.delegate=delegate;
    _objectManager=[RKObjectManager sharedManager];
    [self configure];
    [self createRequestTokenForLoginRequest:loginData];
    
}

-(void)configure{
    RKObjectMapping *loginResponseMapping=[RKObjectMapping mappingForClass:[LoginResponse class]];
    RKObjectMapping *tokenResponseMapping=[RKObjectMapping mappingForClass:[RequestToken class]];
    RKObjectMapping *sessionResponseMapping=[RKObjectMapping mappingForClass:[SessionIDResponse class]];
    
    [loginResponseMapping addAttributeMappingsFromDictionary:[LoginResponse propertiesMapping]];
    [tokenResponseMapping addAttributeMappingsFromDictionary:[RequestToken propertiesMapping]];
    [sessionResponseMapping addAttributeMappingsFromDictionary:[SessionIDResponse propertiesMapping]];
    
    [self addResponseDescriptorWithMapping:loginResponseMapping pathPattern:ValidateTokenSubpath keyPath:nil];
    [self addResponseDescriptorWithMapping:tokenResponseMapping pathPattern:CreateNewTokenSubpath keyPath:nil];
    [self addResponseDescriptorWithMapping:sessionResponseMapping pathPattern:CreateNewSessionSubpath keyPath:nil];

}

-(void)createRequestTokenForLoginRequest:(LoginRequest *)loginData{
    NSDictionary *queryParams = @{APIKeyParameterName : [MovieAppConfiguration getApiKey]};

    [[RKObjectManager sharedManager] getObjectsAtPath:CreateNewTokenSubpath
                                           parameters:queryParams
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  RequestToken *response=mappingResult.array[0];
                                                  if(response.success){
                                                      [self validateRequestToken:response withLogin:loginData];
                                                  }
                                                  else{
                                                      [self.delegate loginFailedWithError:nil];
                                                  }
                                                  
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  [self.delegate loginFailedWithError:error];
                                              }];
    
}

-(void)validateRequestToken:(RequestToken *)token withLogin:(LoginRequest *)loginData{
    NSDictionary *queryParams = @{APIKeyParameterName : [MovieAppConfiguration getApiKey],
                                  UsernameParameterName : loginData.username,
                                  PasswordParameterName : loginData.password,
                                  RequestTokenParameterName : token.requestToken};
    
    [[RKObjectManager sharedManager] getObjectsAtPath:ValidateTokenSubpath
                                           parameters:queryParams
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  LoginResponse *response=mappingResult.array[0];
                                                  if(response.success){
                                                      [self createSessionIDForToken:response.requestToken];
                                                  }
                                                  else{
                                                      [self.delegate loginFailedWithError:nil];
                                                  }
                                                  
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  [self.delegate loginFailedWithError:error];
                                              }];
}

-(void)createSessionIDForToken:(NSString *)token{
    NSDictionary *queryParams = @{APIKeyParameterName : [MovieAppConfiguration getApiKey],
                                  RequestTokenParameterName : token };
    
    [[RKObjectManager sharedManager] getObjectsAtPath:CreateNewSessionSubpath
                                           parameters:queryParams
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  SessionIDResponse *response=mappingResult.array[0];
                                                  [self.delegate loginSucceededWithSessionID:response.sessionID];
                                                  
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  [self.delegate loginFailedWithError:error];
                                              }];
}

-(void)addResponseDescriptorWithMapping:(RKObjectMapping *)mapping pathPattern:(NSString *)pathPattern keyPath:(NSString *)keyPath{
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:mapping
                                                 method:RKRequestMethodGET
                                            pathPattern:pathPattern
                                                keyPath:keyPath
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [_objectManager addResponseDescriptor:responseDescriptor];
}
@end
