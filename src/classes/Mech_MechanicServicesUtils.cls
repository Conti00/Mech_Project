/**
 * Created by BRITENET on 19.11.2018.
 */

global with sharing class Mech_MechanicServicesUtils {

    global class WebServiceMechanicWrapper {
        webService Id id;
        webService String firstName;
        webService String lastName;
        webService String city;
        webService String country;
        
        public WebServiceMechanicWrapper(Mechanic__c mechanic) {
            this.id = mechanic.Id;
            this.firstName = mechanic.First_Name__c;
            this.lastName = mechanic.Name;
            this.city = mechanic.City__c;
            this.country = mechanic.Country__c;
        }

        public Mechanic__c convertToMechanicSObject(){
            return new Mechanic__c(
                    Id = this.id,
                    First_Name__c = this.firstName,
                    Name = this.lastName,
                    City__c = this.city,
                    Country__c = this.country
            );
        }
    }

}