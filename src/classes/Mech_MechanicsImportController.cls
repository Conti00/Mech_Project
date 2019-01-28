/**
 * Created by BRITENET on 12.11.2018.
 */

public with sharing class Mech_MechanicsImportController {
    
    public List<Mechanic__c> displayedMechanics {get; set;}
    public List<Mech_MechanicUtils.MechanicWrapper> allMechanicsWrappers {get; set;}
    public string csvAsString{get;set;}
    public String[] csvFileLines{get;set;}
    public Boolean enableImport {get; set;}

    public Mech_MechanicsImportController(ApexPages.StandardController controller){
        csvFileLines = new String[]{};
        clear();
    }

    public void importCSVFile(){
        allMechanicsWrappers = new List<Mech_MechanicUtils.MechanicWrapper>();
        List<sObject> parsedObjects = new CsvImporter().parseAndReturn(csvAsString, 'Mechanic__c', null);
        for(sObject parsedMechanic : parsedObjects){
            allMechanicsWrappers.add(new Mech_MechanicUtils.MechanicWrapper((Mechanic__c)parsedMechanic));
        }
    }

    public void insertImportedMechanics(){
        Database.SaveResult[] saveResults;
        try{
            saveResults = Database.insert(Mech_MechanicUtils.getMechanicsObjectsToImport(allMechanicsWrappers), false);
        }catch(Exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Cannot insert Mechanics'));
            e.getMessage();
        }

        for (Database.SaveResult saveResultsItem : saveResults) {
            for(Mech_MechanicUtils.MechanicWrapper wrapper : allMechanicsWrappers){
                if(wrapper.selectToImport == true) {
                    if (wrapper.mechanic.Id == null) {
                        if(saveResultsItem.isSuccess()==false){
                            wrapper.saveSuccess = saveResultsItem.getErrors()[0].getMessage();
                        }
                    }
                else {
                        wrapper.saveSuccess = 'true';
                    }
                }else{
                    wrapper.saveSuccess = null;
                }
            }
        }
    }

    public void clear(){
        allMechanicsWrappers = new List<Mech_MechanicUtils.MechanicWrapper>();
        displayedMechanics = new List<Mechanic__c>();
        enableImport = false;
    }

    public void selectAllToImport(){
        for(Mech_MechanicUtils.MechanicWrapper wrapper : allMechanicsWrappers){
            wrapper.selectToImport = true;
        }
        if(!allMechanicsWrappers.isEmpty()){
            enableImport = true;
        }
    }

    public void deselectAllToImport(){
        for(Mech_MechanicUtils.MechanicWrapper wrapper : allMechanicsWrappers){
            wrapper.selectToImport = false;
        }
        enableImport = false;
    }

    public void reverseToImportSelection(){
        for(Mech_MechanicUtils.MechanicWrapper wrapper : allMechanicsWrappers){
            wrapper.selectToImport = wrapper.selectToImport == true ? false : true;
        }
        changeImportAvailability();
    }

    public PageReference changeImportAvailability(){
        for(Mech_MechanicUtils.MechanicWrapper wrapper : allMechanicsWrappers){
            if(wrapper.selectToImport){
                enableImport = true;
                return null;
            }
        }
        enableImport = false;
        return null;
    }
}