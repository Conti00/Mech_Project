/**
 * Created by BRITENET on 23.11.2018.
 */

global with sharing class Mech_APIUtils {

    global class RepairShopWrapper {
        webService String id;
        webService String name;
        webService String city;
        webService String country;
        webService String phone;
        webService String street;
        webService String website;

        public RepairShopWrapper(Repair_Shop__c repairShop) {
            this.id = repairShop.Id;
            this.Name = repairShop.Name;
            this.city = repairShop.City__c;
            this.country = repairShop.Country__c;
            this.phone = repairShop.Phone_Number__c;
            this.street = repairShop.Street__c;
            this.website = repairShop.Website__c;
        }
    }

    global class WebServiceRepairShopWrapper{
        webService Id id;
        webService String name;
        webService String city;
        webService String country;

        public Repair_Shop__c convertToRepairShopSObject(){
            return new Repair_Shop__c(
                    ExternalIdDev2__c = this.id,
                    Name = this.name,
                    City__c = this.city,
                    Country__c = this.country
            );
        }
    }
}