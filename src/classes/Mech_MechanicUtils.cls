public with sharing class Mech_MechanicUtils {

    public static String ALREADY_HIRED = 'Already Hired';
    public static String SUCCESS = 'Success';
    public class MechanicWrapper {

        public Mechanic__c mechanic{get; set;}
        public Mechanics_Job__c newContract{get;set;}
        public Boolean selectToImport {get; set;}
        public String saveSuccess {get; set;}
        public List<Id> alreadyHiredContractIds {get; set;}
        public String contractCreationSuccess {get; set;}
        public Boolean editContractDates {get; set;}

        public Mechanic__c convertToMechanicSObject(){
            return mechanic;
        }

        public MechanicWrapper(Mechanic__c mechanic) {
            this.mechanic = mechanic;
            this.newContract = new Mechanics_Job__c();
    }}

    public static List<Mechanic__c> getMechanicsObjects(List<MechanicWrapper> mechanicsWrappers){
        List<Mechanic__c> mechanicsToImport = new List<Mechanic__c>();
        for(MechanicWrapper wrapper : mechanicsWrappers){
            mechanicsToImport.add(wrapper.convertToMechanicSObject());
        }
        return mechanicsToImport;
    }

    public static List<Mechanic__c> getMechanicsObjectsToImport(List<MechanicWrapper> mechanicsWrappers){
        List<Mechanic__c> mechanicsToImport = new List<Mechanic__c>();
        for(MechanicWrapper wrapper : mechanicsWrappers){
            mechanicsToImport.add(wrapper.convertToMechanicSObject());
        }
        return mechanicsToImport;
    }

    public static List<Mechanics_Job__c> getNewContractsForMechanicsAvailableToHire(List<MechanicWrapper> mechanicWrappers, Id workshopId){
        List<Mechanics_Job__c> contracts = new List<Mechanics_Job__c>();
        for(Mech_MechanicUtils.MechanicWrapper mechanicWrapper : mechanicWrappers){
            if(mechanicWrapper.contractCreationSuccess != ALREADY_HIRED){
                if(mechanicWrapper.newContract.Mechanic__c != null){
                    Mechanics_Job__c tempContract = new Mechanics_Job__c();
                    tempContract.Start_Day__c = mechanicWrapper.newContract.Start_Day__c;
                    tempContract.End_Day__c = mechanicWrapper.newContract.End_Day__c;
                    mechanicWrapper.newContract = tempContract;
                }
                mechanicWrapper.newContract.Repair_Shop__c = workshopId;
                mechanicWrapper.newContract.Mechanic__c = mechanicWrapper.mechanic.Id;
                contracts.add(mechanicWrapper.newContract);
            }
        }
        return contracts;
    }
}