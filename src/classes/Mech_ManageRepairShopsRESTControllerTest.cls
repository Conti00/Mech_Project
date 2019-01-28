/**
 * Created by BRITENET on 27.11.2018.
 */

@isTest
public with sharing class Mech_ManageRepairShopsRESTControllerTest {

    @isTest
    public static void shouldPopulateWorkshopsList(){
        //Given
        Mech_ManageRepairShopsRESTController controller = new Mech_ManageRepairShopsRESTController();
//        SingleRequestMock fakeAccountResp = new SingleRequestMock(200,
//                'Complete',
//                '[{"name": "Car Shop","id": "a021r00000eYVedAAG","country": "Ukraine","city": "Kielce"},{"name": "Gas Monkey","id": "a021r00000eYVeTAAW","country": "Ukraine","city": "Houston"}]',
//                null);
//
//        Map<String, HttpCalloutMock> endpointToTestResp = new Map<String,HttpCalloutMock>();
//        endpointToTestResp.put('',fakeAccountResp);
//        HttpCalloutMock multiCalloutMock = new Mech_MultiRequestMock(endpointToTestResp);
//        Test.setMock(HttpCalloutMock.class, multiCalloutMock);

        Test.setMock(HttpCalloutMock.class, new Mech_HTTPRESTResponseMockGenerator('[{"name": "Car Shop","id": "a021r00000eYVedAAG","country": "Ukraine","city": "Kielce"},{"name": "Gas Monkey","id": "a021r00000eYVeTAAW","country": "Ukraine","city": "Houston"}]', 200));
        controller.searchedRepairShop = new Repair_Shop__c(Name='', City__c='', Country__c='');

        //When
        controller.searchRepairShops();

        //Then
        System.assertEquals(controller.selectedRepairShops.size(),2);
    }

    @isTest
    public static void shouldReturnSuccessCodeOnDeleteWorkshop(){
        //Given
        Mech_ManageRepairShopsRESTController controller = new Mech_ManageRepairShopsRESTController();
        Test.setMock(HttpCalloutMock.class, new Mech_HTTPRESTResponseMockGenerator('Successfully deleted record', 200));
        List<Repair_Shop__c> repairShopsList = new List<Repair_Shop__c>();
        repairShopsList.add(new Repair_Shop__c(Name='Workshop1', City__c='Warszawa', Country__c='Poland'));
        insert repairShopsList;
        System.assertEquals(1, repairShopsList.size());
        System.assertNotEquals(null, repairShopsList[0].Id);
        String id = repairShopsList[0].Id;
        controller.repairShopToDeleteId = id;

        //When
        Test.startTest();
        controller.deleteRepairShop();
        Test.stopTest();

        //Then
        System.assertEquals(true, controller.deleteRepairShopSuccess);
    }

    @isTest
    public static void shouldReturnErrorCodeOnDeleteWorkshop(){
        //Given
        Mech_ManageRepairShopsRESTController controller = new Mech_ManageRepairShopsRESTController();
        Test.setMock(HttpCalloutMock.class, new Mech_HTTPRESTResponseMockGenerator('Record with given Id doesnt exist', 404));
        List<Repair_Shop__c> repairShopsList = new List<Repair_Shop__c>();
        repairShopsList.add(new Repair_Shop__c(Name='Workshop1', City__c='Warszawa', Country__c='Poland'));
        insert repairShopsList;
        System.assertEquals(1, repairShopsList.size());
        System.assertNotEquals(null, repairShopsList[0].Id);
        String id = repairShopsList[0].Id;
        controller.repairShopToDeleteId = 'xxx';

        //When
        Test.startTest();
        controller.deleteRepairShop();
        Test.stopTest();

        //Then
        System.assertEquals(false, controller.deleteRepairShopSuccess);
    }

    @isTest
    public static void shouldReturnSuccessCodeOnUpdateWorkshop(){
        //Given
        Mech_ManageRepairShopsRESTController controller = new Mech_ManageRepairShopsRESTController();
        Test.setMock(HttpCalloutMock.class, new Mech_HTTPRESTResponseMockGenerator('Updating record was successfull', 200));
        List<Repair_Shop__c> repairShopsList = new List<Repair_Shop__c>();
        repairShopsList.add(new Repair_Shop__c(Name='Workshop1', City__c='Warszawa', Country__c='Poland'));
        insert repairShopsList;
        System.assertEquals(1, repairShopsList.size());
        System.assertNotEquals(null, repairShopsList[0].Id);
        String id = repairShopsList[0].Id;
        controller.editedRepairShop = repairShopsList[0];

        //When
        Test.startTest();
        controller.updateRepairShop();
        Test.stopTest();

        //Then
        System.assertEquals(true, controller.updateRepairShopSuccess);
    }

    @isTest
    public static void shouldClearSearchForm(){
        Mech_ManageRepairShopsRESTController controller = new Mech_ManageRepairShopsRESTController();
        System.assertEquals(new Repair_Shop__c(), controller.searchedRepairShop);
        controller.searchedRepairShop.Name = 'XXX';
        System.assertNotEquals(new Repair_Shop__c(), controller.searchedRepairShop);
        controller.clear();
        System.assertEquals(new Repair_Shop__c(), controller.searchedRepairShop);
    }
}