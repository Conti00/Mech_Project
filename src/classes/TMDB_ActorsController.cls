/**
 * Created by BRITENET on 10.01.2019.
 */

public with sharing class TMDB_ActorsController {
    @AuraEnabled
    public static List<TMDB_Wrapper.TMDB_ActorObject> getPopularActors(){
        String endpoint = 'https://api.themoviedb.org/3/';
        String api_key = '0afca1ac463aba632db1980912eebafa';
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint+'person/popular?'+'api_key='+api_key);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        if (response.getStatusCode() == 200) {
            TMDB_Wrapper.TMDB_Actor actors = (TMDB_Wrapper.TMDB_Actor)JSON.deserialize(response.getBody(), TMDB_Wrapper.TMDB_Actor.class);
            return actors.results;
        }else{
            return new List<TMDB_Wrapper.TMDB_ActorObject>();
        }
    }

    @AuraEnabled
    public static TMDB_Wrapper.TMDB_ActorDetails getActorDetailsById(String actorId){
        String endpoint = 'https://api.themoviedb.org/3/';
        String api_key = '0afca1ac463aba632db1980912eebafa';
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setEndpoint(endpoint+'person/'+actorId+'?api_key='+api_key);

        HttpResponse response = http.send(request);
        if (response.getStatusCode() == 200) {
            TMDB_Wrapper.TMDB_ActorDetails actorDetails = (TMDB_Wrapper.TMDB_ActorDetails)JSON.deserialize(response.getBody(), TMDB_Wrapper.TMDB_ActorDetails.class);
            return actorDetails;
        }else{
            return new TMDB_Wrapper.TMDB_ActorDetails();
        }
    }

    @AuraEnabled
    public static List<TMDB_Wrapper.TMDB_FilmographyItem> getActorFilmographyById(String actorId){
        String endpoint = 'https://api.themoviedb.org/3/';
        String api_key = '91d46718c8bf266eeeb372bb7d45a315';
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setEndpoint(endpoint+'person/'+actorId+'/movie_credits?api_key='+api_key);

        HttpResponse response = http.send(request);
        if (response.getStatusCode() == 200) {
            String responseObject = response.getBody();
            String replacedString = responseObject.replace('"cast":[', '"filmography":[');
            TMDB_Wrapper.TMDB_Filmography actorFilmography = (TMDB_Wrapper.TMDB_Filmography)JSON.deserialize(replacedString, TMDB_Wrapper.TMDB_Filmography.class);
            return actorFilmography.filmography;
        }else{
            return new List<TMDB_Wrapper.TMDB_FilmographyItem>();
        }
    }

    @AuraEnabled
    public static List<TMDB_Wrapper.TMDB_ActorObject> getActorsByName(String name){
        String endpoint = 'https://api.themoviedb.org/3/';
        String api_key = '91d46718c8bf266eeeb372bb7d45a315';
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint+'search/person?'+'api_key='+api_key+'&query='+name);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        if (response.getStatusCode() == 200) {
            TMDB_Wrapper.TMDB_Actor actors = (TMDB_Wrapper.TMDB_Actor)JSON.deserialize(response.getBody(), TMDB_Wrapper.TMDB_Actor.class);
            return actors.results;
        }else{
            return new List<TMDB_Wrapper.TMDB_ActorObject>();
        }
    }

}