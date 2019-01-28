/**
 * Created by BRITENET on 06.11.2018.
 */

public with sharing class CustomMechanicController {

    public Boolean displayPopup { get; set; }
    public Mechanic__c mechanic { get; set; }
    public String subject { get; set; }
    public List<Mechanics_Job__c> mechanicContracts { get; set; }
    public Attachment attachment { get; set; }
    public Boolean deletePhotoSuccess {get; set;}

    public CustomMechanicController(ApexPages.standardController controller) {
        controller.addFields(new List<String>{
                'First_Name__c', 'Name', 'Email__c', 'Street__c',
                'City__c', 'Country__c'
        });
        mechanic = (Mechanic__c) controller.getRecord();
        getMechanicContracts();
        setLastAttachment();
    }

    public void getMechanicContracts() {
        Id currentRecordId = ApexPages.currentPage().getParameters().get('id');
        mechanicContracts = [
                SELECT Id, Repair_Shop__r.Name, Name, Start_Day__C, End_Day__c
                FROM Mechanics_Job__c
                WHERE Mechanic__c = :currentRecordId
        ];
    }
    public void showPopup() {
        displayPopup = true;
    }
    public void closePopup() {
        displayPopup = false;
    }

    public PageReference save() {
        try {
            update this.mechanic;
        } catch (Exception e) {
        }
        PageReference page = new PageReference('/apex/Mechanic?Id=' + mechanic.Id);
        page.setRedirect(true);
        return page;
    }
    public Pagereference cancel() {
        ApexPages.StandardController std = new ApexPages.standardController(mechanic);
        return std.cancel();
    }


    public void deleteImages(){
        List<Attachment> attachmentsToDelete = getAllAttachedPhotos();

        try{
            if(String.isNotBlank(attachment.Id)){
                delete attachmentsToDelete;
                attachment = new Attachment();
            }
        }catch (DmlException e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading image'));
        }
    }

    public void deleteAllPhotos(){
        List<Attachment> attachmentsToDelete = getAllAttachedPhotos();

        try {
            delete attachmentsToDelete;
            deletePhotoSuccess = true;
            //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Photo deleted successfully'));
        } catch (DmlException e){
            deletePhotoSuccess = false;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error deleting photo'));
        }
    }

    public void setLastAttachment(){
        List<Attachment> attachments = [SELECT id,name,parent.name FROM Attachment
        WHERE ParentId = :mechanic.Id
        ORDER BY LastModifiedDate DESC
        LIMIT 1];
        if(attachments.size()>0 && attachments != null){
            attachment = attachments[0];
        }
    }

    private List<Attachment> getAllAttachedPhotos(){
        List<Attachment> attachments = [SELECT id,name
        FROM Attachment
        WHERE ParentId = :mechanic.Id ];
        return attachments;
    }

    @RemoteAction public static Id saveImage(String name, String contentType, String data, String parent) {
        System.debug('name '+name);
        System.debug('contentType '+contentType);
        System.debug('data '+data);
        System.debug('parentID '+parent);
        Attachment attachedPhoto = new Attachment(Name=name, OwnerId=UserInfo.getUserId(), contentType=contentType, Body=EncodingUtil.base64Decode(data), ParentId=parent);
        Database.insert(attachedPhoto, true);
        return attachedPhoto.id;
    }
}