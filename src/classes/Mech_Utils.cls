/**
 * Created by BRITENET on 30.11.2018.
 */

public with sharing class Mech_Utils {



    public static User getUserById(String userid){
        List<User> users = [SELECT id,name, Country FROM User WHERE id= :userid];
        if(users.isEmpty()){
            return null;
        }
        return users[0];
    }

    public static User getCurrentUser(){
        return getUserById(UserInfo.getUserId());
    }

    public static Boolean isCustomSettingEnabled(String CSName){
        return isCustomSettingEnabled(CSName, getCurrentUser().Country);
    }

    public static Boolean isCustomSettingEnabled(String CSName, String country){

        Mech_CustomSetting__c customSettingItem = Mech_CustomSetting__c.getInstance(CSName);
        if(customSettingItem == null){
            return false;
        }
        Set<String> values = new Set<String>(customSettingItem.Value__c.split(','));
        system.debug(values.contains(country));

        return values.contains(country);
    }

}