/**
 * Created by BRITENET on 27.11.2018.
 */
@isTest
public with sharing class Mech_ManageMechanicsSOAPControllerTest {


    @isTest
    public static void shouldPopulateMechanicsList(){
        //Given
        Mech_ManageMechanicsSOAPController controller = new Mech_ManageMechanicsSOAPController();
        Test.setMock(WebServiceMock.class, new Mech_SOAPResponseMockGenerator('getMechanics', ''));
        controller.searchedMechanic = new soapSforceComSchemasClassMechMechaServ.WebServiceMechanicWrapper();

        //When
        controller.searchMechanics();

        //Then
        System.assertEquals(controller.allMechanics.size(),2);
    }

    @isTest
    public static void shouldReturnSuccessOnDeleteMechanic(){
        //Given
        Mech_ManageMechanicsSOAPController controller = new Mech_ManageMechanicsSOAPController();
        Test.setMock(WebServiceMock.class, new Mech_SOAPResponseMockGenerator('deleteMechanic', 'Success'));
        List<Mechanic__c> mechanicsList = new List<Mechanic__c>();
        mechanicsList.add(new Mechanic__c(First_Name__c='fname1',Name='lname1', City__c='Warszawa', Country__c='Poland'));
        insert mechanicsList;
        System.assertEquals(1, mechanicsList.size());
        System.assertNotEquals(null, mechanicsList[0].Id);
        String id = mechanicsList[0].Id;
        controller.mechanicToDeleteId = id;

        //When
        Test.startTest();
        controller.deleteMechanic();
        Test.stopTest(); 

        //Then
        System.assertEquals(0, controller.allMechanics.size());
    }


    @isTest
    public static void shouldReturnSuccessCodeOnUpdateMechanic(){
        //Given
        Mech_ManageMechanicsSOAPController controller = new Mech_ManageMechanicsSOAPController();
        Test.setMock(WebServiceMock.class, new Mech_SOAPResponseMockGenerator('updateMechanic', 'Success', 'a021t000006FVBaAAO'));
        List<Mech_ManageMechanicsSOAPController.MechanicWrapper> wrapperList = new List<Mech_ManageMechanicsSOAPController.MechanicWrapper>();
        wrapperList.add(new Mech_ManageMechanicsSOAPController.MechanicWrapper('test','test','test','test'));
        System.assertEquals(1, wrapperList.size());
        controller.editedMechanic = wrapperList[0];

        //When
        Test.startTest();
        controller.updateMechanic();
        Test.stopTest();

        //Then
        System.assertNotEquals(null, controller.result);
    }

}