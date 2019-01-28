/**
 * Created by BRITENET on 17.01.2019.
 */

public with sharing class Q_QuestionController {

    @AuraEnabled
    public static List<Q_CollectionOfQuestions__c> getQuestionFromDatabase(List<String> listOfCategories) {

        List<Q_CollectionOfQuestions__c> listOfQuestions;
        final String DELIMITER = '\'';
        String queryOfListOfCategories = ' WHERE ';

        for (integer i = 0; i < listOfCategories.size(); i++) {
            queryOfListOfCategories += ' Q_StageOfTraining__c LIKE ';
            queryOfListOfCategories += DELIMITER;
            queryOfListOfCategories += listOfCategories[i];
            queryOfListOfCategories += DELIMITER;
            queryOfListOfCategories += ' OR ';
        }

        if (queryOfListOfCategories.length() < 10) {
            queryOfListOfCategories = queryOfListOfCategories.substring(0, queryOfListOfCategories.length() - 6);
        } else {
            queryOfListOfCategories = queryOfListOfCategories.substring(0, queryOfListOfCategories.length() - 3);

        }



        Integer count = Database.countQuery('SELECT COUNT() FROM Q_CollectionOfQuestions__c ' + queryOfListOfCategories);
        Integer rand = Math.floor(Math.random() * count).intValue();

        return Database.query('SELECT id, Q_StageOfTraining__c, Name, Q_Question__C, Q_Answer__c FROM Q_CollectionOfQuestions__c ' + queryOfListOfCategories + ' LIMIT 1 OFFSET ' + rand);

    }

    @AuraEnabled
    public static Q_CollectionOfQuestions__c saveQuestion (Q_CollectionOfQuestions__c question) {
        upsert question;
        return question;
    }

}