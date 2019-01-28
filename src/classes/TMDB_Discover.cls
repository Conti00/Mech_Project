/**
 * Created by BRITENET on 04.01.2019.
 */

public with sharing class TMDB_Discover {

    @AuraEnabled
    public static List<TMDB_Wrapper.TMDB_Genre> getGenres(){
        String endpoint = 'https://api.themoviedb.org/3/';
        String api_key = '91d46718c8bf266eeeb372bb7d45a315';
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint+'genre/movie/list?'+'api_key='+api_key);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        if(response.getStatusCode()==200){
            TMDB_Wrapper.TMDB_Genres genres = (TMDB_Wrapper.TMDB_Genres)JSON.deserialize(response.getBody(), TMDB_Wrapper.TMDB_Genres.class);
            return genres.genres;
        }else{
            return new List<TMDB_Wrapper.TMDB_Genre>();
        }
    }
}