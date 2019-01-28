/**
 * Created by BRITENET on 06.12.2018.
 */

public with sharing class Mech_RestHandler {

    public static String instance_url {get;set;}

    public static HttpRequest getRequestMethod(String method, String authorization, String token, String endpoint, String requestBodyString){
        HttpRequest req = new HttpRequest();
        req.setHeader('Content-Type', 'application/json');
        req.setMethod(method);
        req.setHeader(authorization, token);
        req.setEndpoint(endpoint);
        if(requestBodyString!=null) {
            req.setBody(requestBodyString);
        }
        return req;
    }

    public static String getExternalServiceAccessToken() {
        Mech_ExternalServiceOAuth2Credentials__c externalCredentials = Mech_ExternalServiceOAuth2Credentials__c.getInstance('JakKat');
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint(externalCredentials.loginUri__c);
        req.setBody('grant_type=' + externalCredentials.grant_type__c+
                '&client_id=' + externalCredentials.client_id__c +
                '&client_secret=' + externalCredentials.client_secret__c +
                '&redirect='+ externalCredentials.redirect__c +
                '&username=' + externalCredentials.username__c +
                '&password=' + externalCredentials.password__c);

        Http http = new Http();
        HTTPResponse response = http.send(req);
        Mech_LoginResponseBodyWrapper loginResponseBody = (Mech_LoginResponseBodyWrapper)JSON.deserialize(response.getBody(), Mech_LoginResponseBodyWrapper.class);
        instance_url = loginResponseBody.instance_url;
        return loginResponseBody.access_token;
    }

    public class RestLogWrapper{
         public Date logDate;
         public Boolean tokenOrEndpointWasBlank;
    }
}