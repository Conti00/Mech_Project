/**
 * Created by BRITENET on 12.11.2018.
 */

public with sharing class MechanicImportController {
    
    public List<Mechanic__c> displayedMechanics {get; set;}
    public List<MechanicUtils.MechanicWrapper> allMechanicsWrappers {get; set;}
    public Blob csvFileBody{get;set;}
    public string csvAsString{get;set;}
    public String[] csvFileLines{get;set;}
    public Boolean enableImport {get; set;}

    public MechanicImportController(ApexPages.StandardController controller){
        csvFileLines = new String[]{};
        clear();
    }

    public void importCSVFile(){
        allMechanicsWrappers = new List<MechanicUtils.MechanicWrapper>();
        List<sObject> parsedObjects = new CsvImporter().parseAndReturn(csvAsString, 'Mechanic__c', null);
        system.debug(csvAsString);
        for(sObject parsedMechanic : parsedObjects){
            system.debug('parsed: '+parsedMechanic);
            allMechanicsWrappers.add(new MechanicUtils.MechanicWrapper((Mechanic__c)parsedMechanic));
            system.debug(allMechanicsWrappers);
        }
    }

    public void insertImportedMechanics(){
        system.debug('insert imported');
        Database.SaveResult[] saveResults;
        try{
            saveResults = Database.insert(MechanicUtils.getMechanicsObjectsToImport(allMechanicsWrappers), false);
        }catch(Exception e) {
            system.debug(e.getMessage());
        }

        system.debug(saveResults);

        Integer ii = 0;
        for (Database.SaveResult saveResultsItem : saveResults) {
            for(MechanicUtils.MechanicWrapper wrapper : allMechanicsWrappers){
                if(wrapper.selectToImport == true) {
                    if (wrapper.mechanic.Id == null) {
                        wrapper.saveSuccess = saveResultsItem.getErrors()[0].getMessage().length() >= 100 ?
                                saveResultsItem.getErrors()[0].getMessage().substring(0, 100) :
                                saveResultsItem.getErrors()[0].getMessage().substring(0, saveResultsItem.getErrors()[0].getMessage().length());
                    } else {
                        wrapper.saveSuccess = 'true';
                    }
                }else{
                    wrapper.saveSuccess = null;
                }
            }
        }
    }

    public void clear(){
        allMechanicsWrappers = new List<MechanicUtils.MechanicWrapper>();
        displayedMechanics = new List<Mechanic__c>();
        enableImport = false;
    }

    public void selectAllToImport(){
        for(MechanicUtils.MechanicWrapper wrapper : allMechanicsWrappers){
            wrapper.selectToImport = true;
        }
        if(!allMechanicsWrappers.isEmpty()){
            enableImport = true;
        }
    }

    public void deselectAllToImport(){
        for(MechanicUtils.MechanicWrapper wrapper : allMechanicsWrappers){
            wrapper.selectToImport = false;
        }
        enableImport = false;
    }

    public void reverseToImportSelection(){
        for(MechanicUtils.MechanicWrapper wrapper : allMechanicsWrappers){
            wrapper.selectToImport = wrapper.selectToImport == true ? false : true;
        }
        changeImportAvailability();
    }

    public PageReference changeImportAvailability(){
        system.debug('123');
        for(MechanicUtils.MechanicWrapper wrapper : allMechanicsWrappers){
            if(wrapper.selectToImport){
                system.debug('enable');
                enableImport = true;
                return null;
            }
        }
        enableImport = false;
        return null;
    }
}