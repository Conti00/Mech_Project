/**
 * Created by BRITENET on 19.11.2018.
 */

global with sharing class Mech_MechanicWebService {

    webService static List<Mech_MechanicServicesUtils.WebServiceMechanicWrapper> getMechanics(String firstName, String lastName, String city, String country) {
        List<Mechanic__c> selectedMechanics = [
                SELECT id,name,City__c,Country__c,First_Name__c
                FROM Mechanic__c
                WHERE Country__c LIKE :'%' + country + '%' AND
                city__c LIKE :'%' + city + '%' AND
                name LIKE :'%' + lastName + '%' AND
                First_Name__c LIKE :'%' + firstName + '%'
        ];
        List<Mech_MechanicServicesUtils.WebServiceMechanicWrapper> mechanicWrappers = new List<Mech_MechanicServicesUtils.WebServiceMechanicWrapper>();
        for(Mechanic__c mechanic : selectedMechanics){
            mechanicWrappers.add(new Mech_MechanicServicesUtils.WebServiceMechanicWrapper(mechanic));
        }
        return mechanicWrappers;
    }

    webservice static Id updateSingleMechanic(Mech_MechanicServicesUtils.WebServiceMechanicWrapper mechanicToUpdateWrapper){
        Mechanic__c mechanicToUpdate;
        Id result = null;
        if(mechanicToUpdateWrapper != null){
            mechanicToUpdate = mechanicToUpdateWrapper.convertToMechanicSObject();
            try {
                Database.SaveResult resultOfSave = Database.update(mechanicToUpdate);
                if (resultOfSave.isSuccess()) {
                    result = resultOfSave.getId();
                }
            } catch (DmlException e) {e.getMessage();}
        }
        return result;
    }

    webService static Boolean deleteSingleMechanic(String mechanicId) {

        Boolean result=null;
        if (!checkIfMechanicExist(mechanicId)) {
            return result;
        }

        try {
            Database.DeleteResult delResult = Database.delete(getMechanicById(mechanicId));
            return delResult.isSuccess();
        } catch (DmlException e) {return false;}
    }

    private static Mechanic__c getMechanicById(String mechanicId) {
        List<Mechanic__c> mechanics = [SELECT id FROM Mechanic__c WHERE id = :mechanicId LIMIT 1];
        if (mechanics.isEmpty()) {
            return null;
        }
        return mechanics[0];
    }

    private static Boolean checkIfMechanicExist(String mechanicId) {
        if (getMechanicById(mechanicId) == null) {
            return false;
        }
        return true;
    }
}