/**
 * Created by BRITENET on 13.01.2019.
 */

public with sharing class TMDB_OwnVideoController {
        @AuraEnabled
        public static TMDB_Movie__c saveMovie (TMDB_Movie__c movie) {

            upsert movie;
            return movie;
        }

        @AuraEnabled
        public static list<TMDB_Movie__c> getMovies(){
            return [ SELECT Id, TMDB_Title__c, TMDB_Description__c, TMDB_Genres__c, TMDB_Budget__c, TMDB_ReleaseDate__c
            FROM TMDB_Movie__c
            ];
        }
    }