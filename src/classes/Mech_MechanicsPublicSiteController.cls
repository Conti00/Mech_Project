/**
 * Created by BRITENET on 15.11.2018.
 */

public with sharing class Mech_MechanicsPublicSiteController {

    public List<Mechanic__c> mechanics { get; private set; }
    public Mechanic__c mechanic { get; set; }
    public Integer queryLimit {get;set;}
    public Integer count =([SELECT COUNT() FROM Mechanic__c]) -4;
    public Integer offset = Math.floor(Math.random() * count).intValue();
    
    public Mech_MechanicsPublicSiteController(){
        mechanics = new List<Mechanic__c>();
        mechanic = new Mechanic__c();
        queryLimit=5;
       // mechanics = Database.query('SELECT id, Name, Country__c, Email__c, Phone_Number__c FROM Mechanic__c  LIMIT ' + queryLimit + ' OFFSET ' + offset);
    }
}