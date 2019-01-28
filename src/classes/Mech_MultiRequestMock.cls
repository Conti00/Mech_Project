/**
 * Created by BRITENET on 27.11.2018.
 */

public with sharing class Mech_MultiRequestMock implements HttpCalloutMock{

        Map<String, HttpCalloutMock> requests;

        public Mech_MultiRequestMock(Map<String, HttpCalloutMock> requests) {
            this.requests = requests;
        }

        public void addRequestMock(String url, HttpCalloutMock mock) {
            requests.put(url, mock);
        }
        public HTTPResponse respond(HTTPRequest req) {
            HttpCalloutMock mock = requests.get(req.getEndpoint());
            if (mock != null) {
                return mock.respond(req);
            } else {
                throw new System.EmailException('HTTP callout not supported for test methods');
            }
        }

    }