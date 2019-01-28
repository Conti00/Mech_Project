/**
 * Created by BRITENET on 20.11.2018.
 */
@isTest
public with sharing class Mech_MechanicWebServiceTest {

    @isTest
    static void shouldDeleteMechanic(){
        //Given
        Mechanic__c mechanic = new Mechanic__c();
        mechanic.First_Name__c = 'Tadeusz';
        mechanic.Name = 'Kowalski';
        mechanic.City__c = 'Kielce';
        mechanic.Country__c = 'Poland';
        mechanic.Phone_Number__c='111222333';
        insert mechanic;

        List<Mechanic__c> mechanicsList = [SELECT Id, Name FROM Mechanic__c WHERE Id=:mechanic.Id];
        System.assertEquals(1,mechanicsList.size());

        //When
        Test.startTest();
        Mech_MechanicWebService.deleteSingleMechanic(mechanic.Id);
        Test.stopTest();
        //Then
        mechanicsList = [SELECT Id, Name FROM Mechanic__c WHERE Id=:mechanic.Id];
        System.assertEquals(0,mechanicsList.size());
    }

    @isTest
    static void shouldUpdateMechanicName(){
        //Given
        Mechanic__c mechanic = new Mechanic__c();
        mechanic.First_Name__c = 'Tadeusz';
        mechanic.Name = 'Kowalski';
        mechanic.City__c = 'Kielce';
        mechanic.Country__c = 'Poland';
        mechanic.Phone_Number__c='111222333';
        insert mechanic;
        mechanic.First_Name__c='Mateusz';
        Mech_MechanicServicesUtils.WebServiceMechanicWrapper mechanicWrapper = new Mech_MechanicServicesUtils.WebServiceMechanicWrapper(mechanic);

        List<Mechanic__c> mechanicsList = [SELECT Id, Name FROM Mechanic__c WHERE Id=:mechanic.Id];
        System.assertEquals(1,mechanicsList.size());

        //When
        Test.startTest();
        Mech_MechanicWebService.updateSingleMechanic(mechanicWrapper);
        Test.stopTest();

        //Then
        mechanicsList = [SELECT Id, Name, First_Name__c FROM Mechanic__c WHERE Id=:mechanic.Id];
        System.assertEquals(1,mechanicsList.size());
        System.assertEquals('Mateusz',mechanicsList.get(0).First_Name__c);
    }

    @isTest
    static void shouldReturnMechanics(){
        //Given
        Mechanic__c mechanic = new Mechanic__c();
        mechanic.First_Name__c = 'Adam';
        mechanic.Name = 'Kowalski';
        mechanic.City__c = 'Kielce';
        mechanic.Country__c = 'Poland';
        mechanic.Phone_Number__c='111222333';
        insert mechanic;
        Mech_MechanicServicesUtils.WebServiceMechanicWrapper mechanicWrapper = new Mech_MechanicServicesUtils.WebServiceMechanicWrapper(mechanic);

        List<Mechanic__c> mechanicsList = [SELECT Id, Name FROM Mechanic__c WHERE Id=:mechanic.Id];
        System.assertEquals(1,mechanicsList.size());

        //When
        Test.startTest();
        List<Mech_MechanicServicesUtils.WebServiceMechanicWrapper> result = Mech_MechanicWebService.getMechanics('Adam','Kowalski','Kielce','Poland');
        Test.stopTest();

        //Then
        System.assertEquals(1,result.size());
        System.assertEquals('Kielce',result.get(0).city);
    }

    @isTest
    static void shouldReturnUnknownRecordIdWhenDelete(){
        //Given
        Mechanic__c mechanic = new Mechanic__c();
        mechanic.First_Name__c = 'Tadeusz';
        mechanic.Name = 'Kowalski';
        mechanic.City__c = 'Kielce';
        mechanic.Country__c = 'Poland';
        mechanic.Phone_Number__c='111222333';
        insert mechanic;

        List<Mechanic__c> mechanicsList = [SELECT Id, Name FROM Mechanic__c WHERE Id=:mechanic.Id];
        System.assertEquals(1,mechanicsList.size());

        //When
        Test.startTest();
        Mech_MechanicWebService.deleteSingleMechanic(mechanic.Id+'1');
        Test.stopTest();
        //Then
        mechanicsList = [SELECT Id, Name FROM Mechanic__c WHERE Id=:mechanic.Id];
        System.assertEquals(1,mechanicsList.size());
    }

}