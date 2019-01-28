/**
 * Created by BRITENET on 23.11.2018.
 */

public with sharing class Mech_ManageRepairShopsRESTController {

    public List<Repair_Shop__c> selectedRepairShops { get; set; }
    public Repair_Shop__c searchedRepairShop { get; set; }
    public Repair_Shop__c editedRepairShop { get; set; }
    public Repair_Shop__c insertedRepairShop { get; set; }
    public List<Mech_APIUtils.WebServiceRepairShopWrapper> repairShopWrappers { get; set; }
    public String repairShopToDeleteId { get; set; }
    public String editedRepairShopId { get; set; }
    public Boolean deleteRepairShopSuccess { get; set; }
    public Boolean updateRepairShopSuccess { get; set; }
    public String endpoint { get; set; }
    public String token { get; set; }
    private Boolean isPreviousTokenAttemptFailed { get; set; }
    public static Logger__c logger { get; set; }
    public static Boolean tokenOrEndpointWasBlank { get; set; }
    public static Boolean tokenOrEndpointWasInvalid { get; set; }
    public static String methodName { get; set; }

    public Mech_ManageRepairShopsRESTController() {
        searchedRepairShop = new Repair_Shop__c();
        selectedRepairShops = new List<Repair_Shop__c>();
        insertedRepairShop = new Repair_Shop__c();
        editedRepairShop = new Repair_Shop__c();
        endpoint = (String) Cache.Session.get('endpoint');
        token = (String) Cache.Session.get('token');
        isPreviousTokenAttemptFailed = false;
    }

    public void getRepairShops() {

        tokenOrEndpointWasBlank = false;
        tokenOrEndpointWasInvalid = false;
        methodName = 'Search';
        Http http = new Http();
        String requestBodyString = '{"parameters": {'
                + '"Country__c":"' + searchedRepairShop.Country__c
                + '","City__c":"' + searchedRepairShop.City__c
                + '","Name":"' + searchedRepairShop.Name
                + '"}}';

        if (String.isBlank(token) || String.isBlank(endpoint)) {
            if (!isPreviousTokenAttemptFailed) {
                endpointOrTokenIsInvalid();
                isPreviousTokenAttemptFailed = true;
                getRepairShops();
                tokenOrEndpointWasBlank = true;
               // setLog(tokenOrEndpointWasBlank, tokenOrEndpointWasInvalid, null, null, null, methodName);
                sendEmailToPublicGroup('Token or Endpoint was Blank');
            }
        } else {

            HttpRequest request = Mech_RestHandler.getRequestMethod('POST', 'Authorization', token, endpoint, requestBodyString);
            HttpResponse response;

            try {
                response = http.send(request);
                if (response.getStatusCode() == 200) {
                    repairShopWrappers = (List<Mech_APIUtils.WebServiceRepairShopWrapper>) JSON.deserialize(response.getBody(),
                            List<Mech_APIUtils.WebServiceRepairShopWrapper>.class);

                    selectedRepairShops = new List<Repair_Shop__c>();
                    Repair_Shop__c tempRepairShop;
                    for (Mech_APIUtils.WebServiceRepairShopWrapper wrapper : repairShopWrappers) {
                        tempRepairShop = wrapper.convertToRepairShopSObject();
                        if (tempRepairShop.ExternalIdDev2__c != null) {
                            selectedRepairShops.add(tempRepairShop);
                        }
                    }
                }
                setLog(tokenOrEndpointWasBlank, tokenOrEndpointWasInvalid, requestBodyString, token, endpoint, methodName);
            } catch (Exception e) {
                if (!isPreviousTokenAttemptFailed) {
                    endpointOrTokenIsInvalid();
                    isPreviousTokenAttemptFailed = true;
                    getRepairShops();
                    tokenOrEndpointWasInvalid = true;
                    setLog(tokenOrEndpointWasBlank, tokenOrEndpointWasInvalid, null, null, null, methodName);
                    sendEmailToPublicGroup('Token or Endpoint was Invalid.');
                }
            }
        }

    }


    public void deleteRepairShop() {

        tokenOrEndpointWasBlank = false;
        tokenOrEndpointWasInvalid = false;
        methodName = 'Delete';
        Http http = new Http();
        HttpRequest request;

        if (String.isBlank(token) || String.isBlank(endpoint)) {
            if (!isPreviousTokenAttemptFailed) {
                endpointOrTokenIsInvalid();
                isPreviousTokenAttemptFailed = true;
                deleteRepairShop();
                tokenOrEndpointWasBlank = true;
                setLog(tokenOrEndpointWasBlank, tokenOrEndpointWasInvalid, null, null, null, methodName);
            }

        } else {
            try {
                request = Mech_RestHandler.getRequestMethod('DELETE', 'Authorization', token, endpoint
                        + '?id='
                        + repairShopToDeleteId, null);

                HttpResponse response = http.send(request);
                if (response.getStatusCode() == 200) {
                    deleteRepairShopSuccess = true;
                } else {
                    if (response.getStatusCode() == 404) {
                        deleteRepairShopSuccess = false;
                    }
                }
                setLog(tokenOrEndpointWasBlank, tokenOrEndpointWasInvalid, repairShopToDeleteId, token, endpoint, methodName);
            } catch (Exception e) {
                if (!isPreviousTokenAttemptFailed) {
                    endpointOrTokenIsInvalid();
                    isPreviousTokenAttemptFailed = true;
                    deleteRepairShop();
                    tokenOrEndpointWasInvalid = true;
                    setLog(tokenOrEndpointWasBlank, tokenOrEndpointWasInvalid, null, null, null, methodName);
                }
            }
        }
    }

    public void updateRepairShop() {

        tokenOrEndpointWasBlank = false;
        tokenOrEndpointWasInvalid = false;
        methodName = 'Upsert';
        Http http = new Http();
        HttpRequest request;
        String requestBodyString;

        if (editedRepairShop == null  ) {
            requestBodyString = '{"repairShopWrapper": [{'
                    + '"id":"'
                    + ''
                    + '","repairShopName":"' + insertedRepairShop.name
                    + '","repairShopCity":"' + insertedRepairShop.City__c
                    + '","repairShopCountry":"' + insertedRepairShop.Country__c
                    + '"}]}';
        } else {
            requestBodyString = '{"repairShopWrapper": [{'
                    + '"id":"' + editedRepairShop.ExternalIdDev2__c
                    + '","repairShopName":"' + editedRepairShop.name
                    + '","repairShopCity":"' + editedRepairShop.City__c
                    + '","repairShopCountry":"' + editedRepairShop.Country__c
                    + '"}]}';
        }

        if (String.isBlank(token) || String.isBlank(endpoint)) {
            if (!isPreviousTokenAttemptFailed) {
                endpointOrTokenIsInvalid();
                isPreviousTokenAttemptFailed = true;
                updateRepairShop();
                tokenOrEndpointWasBlank = true;
                setLog(tokenOrEndpointWasBlank, tokenOrEndpointWasInvalid, null, null, null, methodName);
            }
        } else {
            try {
                System.debug(requestBodyString);
                request = Mech_RestHandler.getRequestMethod('PUT', 'Authorization', token, endpoint, requestBodyString);
                HttpResponse response = http.send(request);
                if (response.getStatusCode() == 200) {
                    updateRepairShopSuccess = true;
                } else {
                    updateRepairShopSuccess = false;
                }
                editedRepairShop = null;
                insertedRepairShop.clear();

                setLog(tokenOrEndpointWasBlank, tokenOrEndpointWasInvalid, requestBodyString, token, endpoint, methodName);
            } catch (Exception e) {
                if (!isPreviousTokenAttemptFailed) {
                    endpointOrTokenIsInvalid();
                    isPreviousTokenAttemptFailed = true;
                    updateRepairShop();
                    tokenOrEndpointWasInvalid = true;
                    setLog(tokenOrEndpointWasBlank, tokenOrEndpointWasInvalid, null, null, null, methodName);
                }
            }
        }
    }

    public void searchRepairShops() {
        searchedRepairShop.Name = searchedRepairShop.Name == null ? '' : searchedRepairShop.Name;
        searchedRepairShop.City__c = searchedRepairShop.City__c == null ? '' : searchedRepairShop.City__c;
        searchedRepairShop.Country__c = searchedRepairShop.Country__c == null ? '' : searchedRepairShop.Country__c;
        getRepairShops();
    }

    public void setEditedRepairShop() {
        for (Repair_Shop__c repairShop : selectedRepairShops) {
            if (repairShop.ExternalIdDev2__c == editedRepairShopId) {
                editedRepairShop = repairShop;
            }
        }
    }

    public void clear() {
        searchedRepairShop = new Repair_Shop__c();
        if (selectedRepairShops != null) {
            selectedRepairShops.clear();
        }
    }

    public void clearAddUpdateModal() {
        insertedRepairShop = new Repair_Shop__c();
        editedRepairShop = new Repair_Shop__c();
    }


    public void updateSessionCache(String token, String endpoint) {
        Cache.Session.put('token', token, 28800);
        Cache.Session.put('endpoint', endpoint, 28800);

    }

    public void endpointOrTokenIsInvalid() {
        token = 'Bearer ' + Mech_RestHandler.getExternalServiceAccessToken();
        endpoint = Mech_RestHandler.instance_url + '/services/apexrest/repairShop';
        updateSessionCache(token, endpoint);
    }

    @future
    public static void setLog(Boolean tokenOrEndpointWasBlank, Boolean tokenOrEndpointWasInvalid, String requestBodyString, String token, String endpoint, String methodName) {
        logger = new Logger__c();
        logger.Date__c = system.now();
        logger.userId__c = UserInfo.getUserId();
        logger.requestBodyString__c = requestBodyString;
        logger.tokenOrEndpointWasBlank__c = tokenOrEndpointWasBlank;
        logger.tokenOrEndpointWasInvalid__c = tokenOrEndpointWasInvalid;
        logger.token__c = token;
        logger.endpoint__c = endpoint;
        logger.methodName__c = methodName;

        insert logger;
    }

    @future
    public static void sendEmailToPublicGroup(String contentOfMessage) {

        List<String> mailToAddresses = new List<String>();

        User[] usr = [SELECT Email FROM User WHERE Id IN (
        SELECT UserOrGroupId
        FROM GroupMember WHERE Group.Name='Admins Group')];
        for(User u : usr) {
            mailToAddresses.add(u.email);
        }

        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = mailToAddresses;
        message.subject = contentOfMessage;
        message.plainTextBody = contentOfMessage;
        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage>{
                message
        };
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);

    }


}