/**
 * Created by BRITENET on 06.11.2018.
 */

public with sharing class Mech_MechanicInfoController {

    public Boolean displayPopup { get; set; }
    public Mechanic__c mechanic { get; set; }
    public List<Mechanics_Job__c> mechanicContracts { get; set; }
    public Attachment attachment { get; set; }
    public Id dismissedContractId { get; set; }
    public String dismissedContractStartDate { get; set; }
    public String dismissedContractEndDate { get; set; }
    public Map<Id, Mechanics_Job__c> contractsMap { set; get; }
    public Repair_Shop__c searchedRepair_Shop { get; set; }
    public Mechanics_Job__c newContract { get; set; }
    public Id selectedRepair_ShopId { get; set; }
    public List<Repair_Shop__c> availableRepair_Shops { get; set; }
    public Map<Id, Repair_Shop__c> availableRepair_ShopsMap { get; set; }
    public Boolean hiringSuccess { get; set; }
    public Integer HireFlag { get; set; }

    public Mech_MechanicInfoController(ApexPages.standardController controller) {
        controller.addFields(new List<String>{
                'First_Name__c', 'Name', 'Email__c', 'Street__c',
                'City__c', 'Country__c'
        });
        HireFlag = 0;
        mechanic = (Mechanic__c) controller.getRecord();
        getMechanicContracts();
        clear();
        setLastAttachment();
    }

    public static Boolean getIsStreetFieldAvailable(){
        return Mech_Utils.isCustomSettingEnabled('MechanicStreetFieldAvailable');
    }

    public void getMechanicContracts() {
        Id currentRecordId = ApexPages.currentPage().getParameters().get('id');
        mechanicContracts = [
                SELECT Id, Repair_Shop__r.Name, Start_Day__c, End_Day__c
                FROM Mechanics_Job__c
                WHERE Mechanic__c = :currentRecordId
        ];
        contractsMap = new Map<Id, Mechanics_Job__c>(mechanicContracts);
    }

    public void dismiss() {
        Date todayDate = Date.TODAY();
        if (Date.valueOf(dismissedContractStartDate) >= todayDate
                && Date.valueOf(dismissedContractEndDate) >= todayDate) {
            delete contractsMap.get(dismissedContractId);
            getMechanicContracts();
        } else {
            contractsMap.get(dismissedContractId).End_Day__c = todayDate;
            upsert contractsMap.get(dismissedContractId);
            getMechanicContracts();
        }
    }

    public void tryToHire() {
        newContract.Mechanic__c = mechanic.Id;
        try {
            insert newContract;
            hiringSuccess = true;
        } catch (DmlException e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error - DML Exception. Cannot insert new Contract.'));
            ApexPages.addMessages(e);
            hiringSuccess = false;
        }
        getMechanicContracts();
        clear();
    }

    public void hire() {
        if ((mechanicContracts.size() == 0)) {
            tryToHire();
            HireFlag = 1;
        } else {
            for (Mechanics_Job__c mj : mechanicContracts) {
                if (((newContract.Start_Day__c <= mj.Start_Day__c) && (newContract.End_Day__c >= mj.End_Day__c))
                        || ((newContract.Start_Day__c <= mj.Start_Day__c) && (newContract.End_Day__c >= mj.Start_Day__c) && (newContract.End_Day__c <= mj.End_Day__c))
                        || ((newContract.Start_Day__c >= mj.Start_Day__c) && (newContract.Start_Day__c <= mj.End_Day__c) && (newContract.End_Day__c >= mj.Start_Day__c) && (newContract.End_Day__c < mj.End_Day__c))
                        || ((newContract.Start_Day__c >= mj.Start_Day__c) && (newContract.Start_Day__c <= mj.End_Day__c) && (newContract.End_Day__c >= mj.End_Day__c))) {
                    String StartDate = '' + mj.Start_Day__c.year() + '-' + mj.Start_Day__c.month() + '-' + mj.Start_Day__c.day();
                    String EndDate = '' + mj.End_Day__c.year() + '-' + mj.End_Day__c.month() + '-' + mj.End_Day__c.day();
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Wrong Date! Mechanic has valid contract from: ' + StartDate + ' to: ' + EndDate));
                    HireFlag -= 1;
                }
            }
        }
        if (HireFlag == 0) {
            tryToHire();
        }
        HireFlag = 0;
    }

    public void clear() {
        searchedRepair_Shop = new Repair_Shop__c();
        newContract = new Mechanics_Job__c();
        if (availableRepair_Shops != null) {
            availableRepair_Shops.clear();
        }
    }

    public void searchForAvailableRepair_Shops() {
        availableRepair_Shops = Database.query(generateQueryStringForSearchedRepair_Shops());
        availableRepair_ShopsMap = new Map<Id, Repair_Shop__c>(availableRepair_Shops);
        selectedRepair_ShopId = null;
    }

    public void selectRepair_Shop() {
    }

    private String generateQueryStringForSearchedRepair_Shops() {
        String queryString;
        String conditionsSection = '';
        queryString = 'SELECT Name, Website__c, Country__c FROM Repair_Shop__c ';

        queryString +=
                (String.isBlank(searchedRepair_Shop.Name) &&
                        String.isBlank(searchedRepair_Shop.Website__c) &&
                        String.isBlank(searchedRepair_Shop.Country__c)) ? '' : 'WHERE ';
        conditionsSection += String.isBlank(searchedRepair_Shop.Name) ? '' : 'Name LIKE \'%' + searchedRepair_Shop.Name + '%\'';
        conditionsSection += String.isNotBlank(conditionsSection) && String.isNotBlank(searchedRepair_Shop.Website__c) ? ' AND ' : '' ;
        conditionsSection += String.isBlank(searchedRepair_Shop.Website__c) ? '' : 'Website__c LIKE \'%' + searchedRepair_Shop.Website__c + '%\'';
        conditionsSection += String.isNotBlank(conditionsSection) && String.isNotBlank(searchedRepair_Shop.Country__c) ? ' AND ' : '' ;
        conditionsSection += String.isBlank(searchedRepair_Shop.Country__c) ? '' : 'Country__c = \'' + searchedRepair_Shop.Country__c + '\'';
        queryString += conditionsSection == null ? '' : conditionsSection;
        return queryString;
    }

    public void showPopup() {
        displayPopup = true;
    }
    public void closePopup() {
        displayPopup = false;
    }

    public void deleteImages() {
        List<Attachment> attachmentsToDelete = getAllAttachedPhotos();

        try {
            if (String.isNotBlank(attachment.Id)) {
                delete attachmentsToDelete;
                attachment = new Attachment();
            }
        } catch (DmlException e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Error uploading image'));
        }
    }

    public void clearPictureDialog() {
    }

    public void setLastAttachment() {
        List<Attachment> attachments = [
                SELECT Id,Name,Parent.Name
                FROM Attachment
                WHERE ParentId = :mechanic.Id
                ORDER BY LastModifiedDate DESC
                LIMIT 1
        ];
        if (attachments.size() > 0 && attachments != null) {
            attachment = attachments[0];
        }
    }

    private List<Attachment> getAllAttachedPhotos() {
        List<Attachment> attachments = [
                SELECT Id,Name
                FROM Attachment
                WHERE ParentId = :mechanic.Id
        ];
        return attachments;
    }

    @RemoteAction public static Id saveImage(String name, String contentType, String data, String parent) {
        Attachment attachedPhoto = new Attachment(Name = name, OwnerId = UserInfo.getUserId(), contentType = contentType, Body = EncodingUtil.base64Decode(data), ParentId = parent);
        Database.insert(attachedPhoto, true);
        return attachedPhoto.Id;
    }
}