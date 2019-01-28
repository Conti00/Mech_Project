/**
 * Created by BRITENET on 23.11.2018.
 */
@RestResource(urlMapping='/repairShop/*')
global with sharing class Mech_RestRepairShopService {

    @HttpGet
    global static List<Mech_APIUtils.RepairShopWrapper> getRepairShop() {
        Map<String, String> paramsMap = RestContext.request.params;

        List<Repair_Shop__c> selectedRepairShops = [
                SELECT id,name,City__c,Country__c, Website__c, Phone_Number__c, Street__c
                FROM Repair_Shop__c
                WHERE City__c LIKE :'%' + paramsMap.get('city') + '%' OR
                name LIKE :'%' + paramsMap.get('name') + '%' OR
                Country__c LIKE :'%' + paramsMap.get('country') + '%' OR
                Website__c LIKE :'%' + paramsMap.get('website') + '%' OR
                Phone_Number__c LIKE :'%' + paramsMap.get('phone') + '%' OR
                Street__c LIKE :'%' + paramsMap.get('street') + '%'
        ];
        if (selectedRepairShops.isEmpty()) {
            return new List<Mech_APIUtils.RepairShopWrapper>{
                    new Mech_APIUtils.RepairShopWrapper(new Repair_Shop__c())
            };
        }
        List<Mech_APIUtils.RepairShopWrapper> wrappers = new List<Mech_APIUtils.RepairShopWrapper>();
        for (Repair_Shop__c repairShop : selectedRepairShops) {
            wrappers.add(new Mech_APIUtils.RepairShopWrapper(repairShop));
        }
        System.debug(wrappers);
        return wrappers;
    }

    @HttpDelete
    global static String deleteRepairShop() {
        String id = RestContext.request.params.get('id');
        String name = RestContext.request.params.get('name');
        String city = RestContext.request.params.get('city');
        String country = RestContext.request.params.get('country');


        List<Repair_Shop__c> repairShopToDelete = [
                SELECT Id, Name
                FROM Repair_Shop__c
                WHERE Id = :id OR
                Name LIKE :'%' + name + '%' OR
                City__c LIKE :'%' + city + '%' OR
                Country__c LIKE :'%' + country + '%'
        ];

        if (!repairShopToDelete.isEmpty()) {
            try {
                delete repairShopToDelete;
                return System.Label.Mech_RepairShop + ' ' + id + ' ' + System.Label.Mech_deleted;
            } catch (DmlException e) {
                return System.Label.Mech_ErrorOccurred;
            }
        } else {
            return System.Label.Mech_RecordWithId + ' ' + id + ' ' + System.Label.Mech_doesnTexist;
        }
    }

    @HttpPut
    global static String updateRepairShop(Map<String, String> repairShopWrapper) {

        System.debug('WEBS: '+repairShopWrapper);
        List<Repair_Shop__c> listRepairShopsToUpsert = [SELECT id FROM Repair_Shop__c WHERE id = :repairShopWrapper.get('id')];
        if (repairShopWrapper != null) {
            Repair_Shop__c repairShopToUpdate = new Repair_Shop__c();

            if (listRepairShopsToUpsert.size() != 0) {
                repairShopToUpdate.Id = repairShopWrapper.get('id');
                repairShopToUpdate.Name = repairShopWrapper.get('repairShopName');
                repairShopToUpdate.City__c = repairShopWrapper.get('repairShopCity');
                repairShopToUpdate.Country__c = repairShopWrapper.get('repairShopCountry');

            } else if (repairShopWrapper.get('id') == '') {
                repairShopToUpdate.Name = repairShopWrapper.get('repairShopName');
                repairShopToUpdate.City__c = repairShopWrapper.get('repairShopCity');
                repairShopToUpdate.Country__c = repairShopWrapper.get('repairShopCountry');

            } else {
                return System.Label.Mech_RecordWithGivenId + ' ' + System.Label.Mech_doesnTexist;
            }

            try {
                upsert repairShopToUpdate;
                return System.Label.Mech_RepairShop + ' ' + repairShopToUpdate.id + ' ' + System.Label.Mech_SuccessfullyUpdatedorUpserted;
            } catch (DmlException e) {
                return System.Label.Mech_ErrorWhileUpdatingRecord;
            }

        } else {
            return System.Label.Mech_RecordWithGivenId + ' WRAPPER ' + System.Label.Mech_doesnTexist;
        }
    }

}