/**
 * Created by BRITENET on 27.11.2018.
 */

global with sharing class Mech_SOAPResponseMockGenerator implements WebServiceMock {
    private String webServiceMethodName{get;set;}
    private String responseStatus{get;set;}
    private String id{get;set;}

    global Mech_SOAPResponseMockGenerator(String webserviceMethodName, String responseStatus ){
        this.webserviceMethodName = webserviceMethodName;
        this.responseStatus = responseStatus;
    }
    global Mech_SOAPResponseMockGenerator(String webserviceMethodName, String responseStatus, String id ){
        this.webserviceMethodName = webserviceMethodName;
        this.responseStatus = responseStatus;
        this.id = id;
    }

    global void doInvoke(Object stub, Object request, Map<String, Object> response, String endpoint,
            String soapAction, String requestName, String responseNS, String responseName, String responseType) {

        if(webserviceMethodName == 'getMechanics'){
            soapSforceComSchemasClassMechMechaWebSer.getMechanicsResponse_element response_x = new soapSforceComSchemasClassMechMechaWebSer.getMechanicsResponse_element();
            response_x.result = new List<soapSforceComSchemasClassMechMechaServ.WebServiceMechanicWrapper>();
            soapSforceComSchemasClassMechMechaServ.WebServiceMechanicWrapper wraper;

            wraper = new soapSforceComSchemasClassMechMechaServ.WebServiceMechanicWrapper();
            wraper.firstName = 'Mechanic1';
            wraper.lastName = 'Nazwisko1';
            wraper.city = 'Warszawa';
            wraper.country = 'USA';
            response_x.result.add(wraper);

            wraper = new soapSforceComSchemasClassMechMechaServ.WebServiceMechanicWrapper();
            wraper.firstName = 'Mechanic1';
            wraper.lastName = 'Nazwisko1';
            wraper.city = 'Warszawa';
            wraper.country = 'USA';
            response_x.result.add(wraper);

            response.put('response_x', response_x);
        }else{
            if(webserviceMethodName == 'deleteMechanic'){
                soapSforceComSchemasClassMechMechaWebSer.deleteSingleMechanicResponse_element  response_x = new soapSforceComSchemasClassMechMechaWebSer.deleteSingleMechanicResponse_element();

                if(responseStatus == 'Success'){
                    response_x.result = true;
                }else{
                    response_x.result = false;
                }

                response.put('response_x', response_x);
            }else{
                soapSforceComSchemasClassMechMechaWebSer.updateSingleMechanicResponse_element   response_x = new soapSforceComSchemasClassMechMechaWebSer.updateSingleMechanicResponse_element();

                if(responseStatus == 'Success'){
                    response_x.result = id;
                }else{
                response_x.result = null;
                }

                response.put('response_x', response_x);
            }
        }
    }
}