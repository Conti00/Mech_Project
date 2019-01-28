/**
 * Created by BRITENET on 07.11.2018.
 */

public with sharing class Mech_RepairShopInfoController {
    public Repair_Shop__c repairShop { get; set; }
    public List<Mechanics_Job__c> RepairShopContracts { get; set; }
    public Boolean displayPopup { set; get; }
    public Mechanic__c searchedMechanic { get; set; }
    public List<Mechanic__c> availableMechanics { get; set; }
    public Id selectedMechanicId { get; set; }
    public Boolean applyDatesToAllContracts { get; set; }
    public Boolean activateHireButton { get; set; }
    public List<Mech_MechanicUtils.MechanicWrapper> availableMechanicsWrappers { get; set; }
    public List<Mech_MechanicUtils.MechanicWrapper> selectedMechanicsWrappers { get; set; }
    public Date startDate { get; set; }
    public Date endDate { get; set; }

    public Mech_RepairShopInfoController(ApexPages.standardController controller) {
        repairShop = (Repair_Shop__c) controller.getRecord();
        getRepairShopContracts();
        selectedMechanicsWrappers = new List<Mech_MechanicUtils.MechanicWrapper>();
        clear();
    }

    public void clear() {
        searchedMechanic = new Mechanic__c();
        availableMechanicsWrappers = new List<Mech_MechanicUtils.MechanicWrapper>();
        selectedMechanicsWrappers = new List<Mech_MechanicUtils.MechanicWrapper>();
    }

    public void hire() {
        Map<Id, Mechanic__c> mechanicIdsMap = new Map<Id, Mechanic__c>(Mech_MechanicUtils.getMechanicsObjects(selectedMechanicsWrappers));
        Set<Id> mechanicIds = mechanicIdsMap.keySet();
        List<Mechanics_Job__c> mechanicsContractsForCurrentWorkshop = getMechanicsContractsByRepairShop(mechanicIds, repairShop.Id);
        for (Mech_MechanicUtils.MechanicWrapper wrapper : selectedMechanicsWrappers) {
            for (Mechanics_Job__c contract : mechanicsContractsForCurrentWorkshop) {
                if (contract.Start_Day__c <= wrapper.newContract.End_Day__c && contract.End_Day__c >= wrapper.newContract.Start_Day__c && contract.Mechanic__c == wrapper.mechanic.Id && wrapper.newContract.End_Day__c >= wrapper.newContract.Start_Day__c) {
                    if (wrapper.alreadyHiredContractIds == null) {
                        wrapper.alreadyHiredContractIds = new List<Id>();
                        wrapper.contractCreationSuccess = Mech_MechanicUtils.ALREADY_HIRED;
                    }
                    wrapper.alreadyHiredContractIds.add(contract.Id);
                }
            }
        }
        insertNewContractsAndProcessResults(Mech_MechanicUtils.getNewContractsForMechanicsAvailableToHire(selectedMechanicsWrappers, repairShop.Id));
    }

    private void insertNewContractsAndProcessResults(List<Mechanics_Job__c> newContractsForMechanicsAvailableToHire) {
        Database.SaveResult[] saveResults;
        try {
            saveResults = Database.insert(newContractsForMechanicsAvailableToHire, false);
        } catch (Exception e) {
            system.debug(e.getMessage());
        }

        for (Database.SaveResult saveResultsItem : saveResults) {
            for (Mech_MechanicUtils.MechanicWrapper wrapper : selectedMechanicsWrappers) {
                if (wrapper.contractCreationSuccess != Mech_MechanicUtils.ALREADY_HIRED) {
                    if (wrapper.newContract.Id == null) {
                        wrapper.contractCreationSuccess = saveResultsItem.getErrors()[0].getMessage().length() >= 100 ?
                                saveResultsItem.getErrors()[0].getMessage().substring(0, 100) :
                                saveResultsItem.getErrors()[0].getMessage().substring(0, saveResultsItem.getErrors()[0].getMessage().length());
                    } else {
                        wrapper.contractCreationSuccess = Mech_MechanicUtils.SUCCESS;
                    }
                }
            }
        }
    }

    private List<Mechanics_Job__c> getMechanicsContractsByRepairShop(Set<Id> mechanicsIds, Id repairShopId) {
        List<Mechanics_Job__c> contractsToReturn = new List<Mechanics_Job__c>();
        contractsToReturn = [
                SELECT Id, Start_Day__c, End_Day__c, Mechanic__c
                FROM Mechanics_Job__c
                WHERE Mechanic__c IN :mechanicsIds AND
                Repair_Shop__c = :repairShopId
        ];
        return contractsToReturn;
    }

    public void editMechanicContractDates() {
        activateHireButton = false;
        for (Mech_MechanicUtils.MechanicWrapper mechanicWrapper : selectedMechanicsWrappers) {
            if (mechanicWrapper.mechanic.Id == selectedMechanicId) {
                mechanicWrapper.editContractDates = true;
                if (mechanicWrapper.newContract.Mechanic__c != null) {
                    mechanicWrapper.newContract = new Mechanics_Job__c();
                }
                break;
            }
        }
    }

    public void saveContractDates() {

        for (Mech_MechanicUtils.MechanicWrapper mechanicWrapper : selectedMechanicsWrappers) {
            if (mechanicWrapper.mechanic.Id == selectedMechanicId) {
                mechanicWrapper.editContractDates = false;
                startDate = mechanicWrapper.newContract.Start_Day__c;
                endDate = mechanicWrapper.newContract.End_Day__c;
            }
        }
        if (applyDatesToAllContracts == true) {
            for (Mech_MechanicUtils.MechanicWrapper mechanicWrapper : selectedMechanicsWrappers) {
                mechanicWrapper.newContract.Start_Day__c = startDate;
                mechanicWrapper.newContract.End_Day__c = endDate;
                mechanicWrapper.editContractDates = false;
            }
        }
        checkHireButtonActiveStatus();
    }

    private void checkHireButtonActiveStatus() {
        activateHireButton = true;
        for (Mech_MechanicUtils.MechanicWrapper mechanicWrapper : selectedMechanicsWrappers) {
            if (mechanicWrapper.editContractDates == true || mechanicWrapper.newContract.Start_Day__c == null || mechanicWrapper.newContract.End_Day__c == null) {
                activateHireButton = false;
            }
        }
    }

    public void selectMechanic() {
        activateHireButton = false;
        for (Integer i = availableMechanicsWrappers.size() - 1; i >= 0; i--) {
            if (availableMechanicsWrappers[i].mechanic.Id == selectedMechanicId) {
                selectedMechanicsWrappers.add(availableMechanicsWrappers[i]);
                availableMechanicsWrappers.remove(i);
                break;
            }
        }
    }

    public void removeMechanic() {
        for (Integer i = selectedMechanicsWrappers.size() - 1; i >= 0; i--) {
            if (selectedMechanicsWrappers[i].mechanic.Id == selectedMechanicId) {
                selectedMechanicsWrappers[i].contractCreationSuccess = null;
                selectedMechanicsWrappers[i].newContract = new Mechanics_Job__c();
                availableMechanicsWrappers.add(selectedMechanicsWrappers[i]);
                selectedMechanicsWrappers.remove(i);
                break;
            }
        }
        checkHireButtonActiveStatus();
    }

    public void searchForAvailableMechanics() {
        availableMechanics = Database.query(generateQueryStringForSearchedMechanics());
        availableMechanicsWrappers = new List<Mech_MechanicUtils.MechanicWrapper>();
        for (Mechanic__c mechanicItem : availableMechanics) {
            availableMechanicsWrappers.add(new Mech_MechanicUtils.MechanicWrapper(mechanicItem));
        }
    }

    public void getRepairShopContracts() {
        Id currentRecordId = ApexPages.currentPage().getParameters().get('id');
        repairShopContracts = [
                SELECT Id, Mechanic__r.Name, Name, Start_Day__C, End_Day__c
                FROM Mechanics_Job__c
                WHERE Repair_Shop__c = :currentRecordId
        ];
    }

    private String generateQueryStringForSearchedMechanics() {
        String queryString;
        String conditionsSection = '';
        queryString = 'SELECT First_Name__c, Name, Country__c, Email__c FROM Mechanic__c ';
        queryString += (String.isBlank(searchedMechanic.First_Name__c) &&
                String.isBlank(searchedMechanic.Name) &&
                String.isBlank(searchedMechanic.Country__c) &&
                String.isBlank(searchedMechanic.Email__c)) ? '' : 'WHERE ';
        conditionsSection += String.isBlank(searchedMechanic.First_Name__c) ? '' : 'First_Name__c LIKE \'%' + searchedMechanic.First_Name__c + '%\'';
        conditionsSection += String.isNotBlank(conditionsSection) && String.isNotBlank(searchedMechanic.Name) ? ' AND ' : '' ;
        conditionsSection += String.isBlank(searchedMechanic.Name) ? '' : 'Name LIKE \'%' + searchedMechanic.Name + '%\'';
        conditionsSection += String.isNotBlank(conditionsSection) && String.isNotBlank(searchedMechanic.Email__c) ? ' AND ' : '' ;
        conditionsSection += String.isBlank(searchedMechanic.Email__c) ? '' : 'Email__c LIKE \'%' + searchedMechanic.Email__c + '%\'';
        conditionsSection += String.isNotBlank(conditionsSection) && String.isNotBlank(searchedMechanic.Country__c) ? ' AND ' : '' ;
        conditionsSection += String.isBlank(searchedMechanic.Country__c) ? '' : 'Country__c = \'' + searchedMechanic.Country__c + '\'';

        queryString += conditionsSection == null ? '' : conditionsSection;
        queryString += ' LIMIT 100';
 
        return queryString;
    }

    public void showPopup() {
        displayPopup = true;
    }

    public void closePopup() {
        displayPopup = false;
    }
}