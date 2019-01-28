/**
 * Created by BRITENET on 04.01.2019.
 */

public with sharing class TMDB_DiscoverController {

//    private String endpoint = 'https://api.themoviedb.org/3/';
//    private String apiKey = '?api_key=0afca1ac463aba632db1980912eebafa';


    @AuraEnabled
    public static Boolean hasCurrentUserAdminProfile() {
        Profile profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        return UserInfo.getProfileId() == profile.Id ? true : false;
    }


    @AuraEnabled
    public static TMDB_Wrapper.TMDB_DiscoverMovie getMovies(String year, String genreId, String sortBy, String page) {
        System.debug('given params: |year|:' + year + ' |genreId|:' + genreId + ' |sortBy|:' + sortBy + ' |page|:' + page);
        String emptyString = '';
        page = page == null ? '1' : page;
        year = year == null ? emptyString : year;
        genreId = genreId == null ? emptyString : genreId;
        sortBy = sortBy == null ? 'popularity.desc' : sortBy;
        System.debug('given params after check: |year|:' + year + ' |genreId|:' + genreId + ' |sortBy|:' + sortBy + ' |page|:' + page);
        String endpoint = 'https://api.themoviedb.org/3/';
        String apiKey = '?api_key=91d46718c8bf266eeeb372bb7d45a315';
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint + 'discover/movie' + apiKey + '&language=en-US&sort_by=' + sortBy + '&include_adult=false&include_video=false&year=' + year + '&with_genres=' + genreId + '&page=' + page);
        request.setMethod('GET');
        system.debug('endpoint: ' + request.getEndpoint());
        HttpResponse response = http.send(request);
        system.debug('response: ' + response.getStatus());
        system.debug('response: ' + response.getBody());

        if (response.getStatusCode() == 200) {
            TMDB_Wrapper.TMDB_DiscoverMovie movies = (TMDB_Wrapper.TMDB_DiscoverMovie) JSON.deserialize(response.getBody(), TMDB_Wrapper.TMDB_DiscoverMovie.class);
//            String resultAsString = String.valueOf( JSON.deserializeUntyped(response.getBody()) );
//            resultAsString = resultAsString.replace('cast', 'cast_x');
//            System.debug('result as string||'+resultAsString);
            System.debug('deserializacja: ' + movies);
            return movies;
        } else {
            System.debug('Error');
            return new TMDB_Wrapper.TMDB_DiscoverMovie();
        }
    }

    @AuraEnabled
    public static List<TMDB_Wrapper.TMDB_Genre> getGenres() {
        String endpoint = 'https://api.themoviedb.org/3/';
        String apiKey = '?api_key=91d46718c8bf266eeeb372bb7d45a315';
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint + 'genre/movie/list' + apiKey);
        system.debug('GetGenres ENDPoint: ' + request.getEndpoint());
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        system.debug('getgenres response: ' + response.getStatus());
        system.debug('getgenres response: ' + response.getBody());
        if (response.getStatusCode() == 200) {
            TMDB_Wrapper.TMDB_Genres results = (TMDB_Wrapper.TMDB_Genres) JSON.deserialize(response.getBody(), TMDB_Wrapper.TMDB_Genres.class);
            System.debug('after parse: ' + results.genres);
            return results.genres;
        } else {
            return new List<TMDB_Wrapper.TMDB_Genre>();
        }

    }

    @AuraEnabled
    public static TMDB_Wrapper.TMDB_MovieDetails getMovieDetailsById(String movieId) {
        System.debug('GetMoviesDetailsById given param: ' + movieId);
        String endpoint = 'https://api.themoviedb.org/3/';
        String api_key = '91d46718c8bf266eeeb372bb7d45a315';
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setEndpoint(endpoint + 'movie/' + movieId + '?api_key=' + api_key);

        HttpResponse response = http.send(request);
        if (response.getStatusCode() == 200) {
            TMDB_Wrapper.TMDB_MovieDetails movieDetails = (TMDB_Wrapper.TMDB_MovieDetails) JSON.deserialize(response.getBody(), TMDB_Wrapper.TMDB_MovieDetails.class);
            return movieDetails;
        } else {
            return new TMDB_Wrapper.TMDB_MovieDetails();
        }
    }

    @AuraEnabled
    public static List<TMDB_Wrapper.TMDB_CastItem> getMovieCastById(String movieId) {
        String endpoint = 'https://api.themoviedb.org/3/';
        String api_key = '91d46718c8bf266eeeb372bb7d45a315';
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setEndpoint(endpoint + 'movie/' + movieId + '/credits?api_key=' + api_key);

        HttpResponse response = http.send(request);
        if (response.getStatusCode() == 200) {
            String responseObject = response.getBody();
            String replacedString = responseObject.replace('"cast":[', '"castCredits":[');
            TMDB_Wrapper.TMDB_Cast movieCast = (TMDB_Wrapper.TMDB_Cast) JSON.deserialize(replacedString, TMDB_Wrapper.TMDB_Cast.class);
            return movieCast.castCredits;
        } else {
            return new List<TMDB_Wrapper.TMDB_CastItem>();
        }
    }

    @AuraEnabled
    public static List<TMDB_Wrapper.TMDB_DiscoverMovieObject> getFavoriteMovies() {
        List<TMDB_FavouriteMovie__c> favorites = [
                SELECT Id, TMDB_Movie__c
                FROM TMDB_FavouriteMovie__c
                WHERE CreatedById = :UserInfo.getUserId()
        ];
        system.debug(favorites);

        List<TMDB_Wrapper.TMDB_DiscoverMovieObject> favoriteMovies = new List<TMDB_Wrapper.TMDB_DiscoverMovieObject>();
        String endpoint;
        String api_key;
        Http http;
        HttpRequest request;

        if (favorites != null) {
            for (TMDB_FavouriteMovie__c favorite : favorites) {
                endpoint = 'https://api.themoviedb.org/3/';
                api_key = '91d46718c8bf266eeeb372bb7d45a315';
                http = new Http();
                request = new HttpRequest();
                request.setMethod('GET');
                request.setEndpoint(endpoint + 'movie/' + favorite.TMDB_Movie__c + '?api_key=' + api_key);

                HttpResponse response = http.send(request);
                if (response.getStatusCode() == 200) {
                    TMDB_Wrapper.TMDB_DiscoverMovieObject movie = (TMDB_Wrapper.TMDB_DiscoverMovieObject) JSON.deserialize(response.getBody(), TMDB_Wrapper.TMDB_DiscoverMovieObject.class);
                    favoriteMovies.add(movie);
                }
            }

        }
        return favoriteMovies;
    }

    @AuraEnabled
    public static List<TMDB_Wrapper.TMDB_DiscoverMovieObject> getDislikeMovies() {
        List<TMDB_DislikeMovie__c> dislikes = [
                SELECT Id, TMDB_Movie__c
                FROM TMDB_DislikeMovie__c
                WHERE CreatedById = :UserInfo.getUserId()
        ];
        system.debug(dislikes);

        List<TMDB_Wrapper.TMDB_DiscoverMovieObject> dislikeMovies = new List<TMDB_Wrapper.TMDB_DiscoverMovieObject>();
        String endpoint;
        String api_key;
        Http http;
        HttpRequest request;

        if (dislikes != null) {
            for (TMDB_DislikeMovie__c dislike : dislikes) {
                endpoint = 'https://api.themoviedb.org/3/';
                api_key = '91d46718c8bf266eeeb372bb7d45a315';
                http = new Http();
                request = new HttpRequest();
                request.setMethod('GET');
                request.setEndpoint(endpoint + 'movie/' + dislike.TMDB_Movie__c + '?api_key=' + api_key);

                HttpResponse response = http.send(request);
                if (response.getStatusCode() == 200) {
                    TMDB_Wrapper.TMDB_DiscoverMovieObject movie = (TMDB_Wrapper.TMDB_DiscoverMovieObject) JSON.deserialize(response.getBody(), TMDB_Wrapper.TMDB_DiscoverMovieObject.class);
                    dislikeMovies.add(movie);
                }
            }

        }
        return dislikeMovies;
    }


    @AuraEnabled
    public static Boolean isOnFavoriteList(String movieId) {
        List<TMDB_FavouriteMovie__c> favorites = [
                SELECT Id, TMDB_Movie__c
                FROM TMDB_FavouriteMovie__c
                WHERE TMDB_Movie__c =: movieId
        ];

        if(favorites.isEmpty()){
            return false;
        }else{
            return true;
        }
    }

    @AuraEnabled
    public static Boolean isOnDislikeListApex(String movieId) {
        List<TMDB_DislikeMovie__c> dislikes = [
                SELECT Id, TMDB_Movie__c
                FROM TMDB_DislikeMovie__c
                WHERE TMDB_Movie__c =: movieId
        ];

        if(dislikes.isEmpty()){
            return false;
        }else{
            return true;
        }
    }

    @AuraEnabled
    public static String deleteMovieFromFavoriteListByApex (String movieId) {
        System.debug('test');
        List<TMDB_FavouriteMovie__c> favorites = [
                SELECT Id, TMDB_Movie__c
                FROM TMDB_FavouriteMovie__c
                WHERE TMDB_Movie__c = :movieId
        ];
        if (favorites != null) {
            try {
                delete favorites;
                return 'Success';
            } catch (DmlException e) {
                return 'Error deleting from favorites';
            }
        } else {
            return 'Error movie not found in favorites';
        }

    }

    @AuraEnabled
    public static String deleteMovieFromDislikeListByApex (String movieId) {
        System.debug('test');
        List<TMDB_DislikeMovie__c> dislikes = [
                SELECT Id, TMDB_Movie__c
                FROM TMDB_DislikeMovie__c
                WHERE TMDB_Movie__c = :movieId
        ];
        if (dislikes != null) {
            try {
                delete dislikes;
                return 'Success';
            } catch (DmlException e) {
                return 'Error deleting from favorites';
            }
        } else {
            return 'Error movie not found in favorites';
        }

    }

    @AuraEnabled
    public static List<TMDB_Wrapper.TMDB_ReviewsItem> getMovieReviewsById(String movieId) {
        String endpoint = 'https://api.themoviedb.org/3/';
        String api_key = '91d46718c8bf266eeeb372bb7d45a315';
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setEndpoint(endpoint + 'movie/' + movieId + '/reviews?api_key=' + api_key);

        HttpResponse response = http.send(request);
        if (response.getStatusCode() == 200) {
            TMDB_Wrapper.TMDB_Reviews movieReviews = (TMDB_Wrapper.TMDB_Reviews) JSON.deserialize(response.getBody(), TMDB_Wrapper.TMDB_Reviews.class);
            return movieReviews.results;
        } else {
            return new List<TMDB_Wrapper.TMDB_ReviewsItem>();
        }
    }

    @AuraEnabled
    public static List<TMDB_Review__c> getMovieLocalReviewsById(String movieId) {
        system.debug('!!get local reviews call!!');
        List<TMDB_Review__c> reviews = [
                SELECT Id, TMDB_Comment__c, TMDB_Rating__c, CreatedBy.Username, CreatedDate
                FROM TMDB_Review__c
                WHERE TMDB_Movie__c = :movieId
                ORDER BY CreatedDate DESC
        ];
        if (reviews != null) {
            return reviews;
        } else {
            return new List<TMDB_Review__c>();
        }
    }

    @AuraEnabled
    public static String deleteReviewById(String reviewId) {
        List<TMDB_Review__c> review = [
                SELECT Id
                FROM TMDB_Review__c
                WHERE Id = :reviewId
        ];
        if (review != null) {
            try {
                System.debug('dml');
                delete review;
                return 'Success';
            } catch (DmlException e) {
                return 'Error cannot delete review';
            }
        } else {
            return 'Error review not found';
        }
    }

    @AuraEnabled
    public static List<M_Wrapper.M_DiscoverMovieObject> getMoviesListByType(String listType) {
        String endpoint = 'https://api.themoviedb.org/3/';
        String api_key = '91d46718c8bf266eeeb372bb7d45a315';
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint + 'movie/' + listType + '?api_key=' + api_key);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        if (response.getStatusCode() == 200) {
            M_Wrapper.M_DiscoverMovie movies = (M_Wrapper.M_DiscoverMovie) JSON.deserialize(response.getBody(), M_Wrapper.M_DiscoverMovie.class);
            return movies.results;
        } else {
            return new List<M_Wrapper.M_DiscoverMovieObject>();
        }
    }

    @AuraEnabled
    public static List<M_Wrapper.M_DiscoverMovieObject> getMoviesByTitleSearchParams(Map<String, String> params) {
        String endpoint = 'https://api.themoviedb.org/3/';
        String api_key = '91d46718c8bf266eeeb372bb7d45a315';
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setEndpoint(endpoint + 'search/movie?' + 'api_key=' + api_key);
        if (params != null) {
            String paramsSection = '&query=';
            paramsSection += params.get('movieTitle');
            request.setEndpoint(request.getEndpoint() + paramsSection);
        }

        HttpResponse response = http.send(request);
        if (response.getStatusCode() == 200) {
            M_Wrapper.M_DiscoverMovie movies = (M_Wrapper.M_DiscoverMovie) JSON.deserialize(response.getBody(), M_Wrapper.M_DiscoverMovie.class);
            return movies.results;
        } else {
            return new List<M_Wrapper.M_DiscoverMovieObject>();
        }
    }

}