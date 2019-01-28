/**
 * Created by BRITENET on 27.11.2018.
 */

global with sharing class Mech_HTTPRESTResponseMockGenerator implements HttpCalloutMock{

    private String responseBody {get; set;}
    private Integer responseStatusCode {get; set;}

    global Mech_HTTPRESTResponseMockGenerator(String responseBody, Integer responseStatusCode){
        this.responseBody = responseBody;
        this.responseStatusCode = responseStatusCode;
    }

    global HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody(responseBody);
        response.setStatusCode(responseStatusCode);
        return response;
    }
}