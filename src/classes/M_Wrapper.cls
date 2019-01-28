/**
 * Created by BRITENET on 07.01.2019.
 */

public with sharing class M_Wrapper {
    public with sharing class M_Genres {
        public List<M_Genre> genres {get; set;}
    }

    public with sharing class M_Genre {
        @AuraEnabled
        public String id {get; set;}
        @AuraEnabled
        public String name {get; set;}
    }

    public with sharing class M_DiscoverMovie{
        public Integer page {get; set;}
        public Integer total_results {get; set;}
        public Integer total_pages {get; set;}
        public List<M_DiscoverMovieObject> results {get; set;}
    }

    public with sharing class M_DiscoverMovieObject {
        @AuraEnabled
        public Integer vote_count {get; set;}
        @AuraEnabled
        public Integer id {get; set;}
        @AuraEnabled
        public boolean video {get; set;}
        @AuraEnabled
        public Double vote_average {get; set;}
        @AuraEnabled
        public String title {get; set;}
        @AuraEnabled
        public Double popularity {get; set;}
        @AuraEnabled
        public String poster_path {get; set;}
        @AuraEnabled
        public String original_language {get; set;}
        @AuraEnabled
        public String original_title {get; set;}
        @AuraEnabled
        public String backdrop_path {get; set;}
        @AuraEnabled
        public boolean adult {get; set;}
        @AuraEnabled
        public String overview {get; set;}
        @AuraEnabled
        public String release_date {get; set;}
        @AuraEnabled
        public String[] genre_ids {get; set;}
    }

    public with sharing class M_DiscoverTVSeries{
        public Integer page {get; set;}
        public Integer total_results {get; set;}
        public Integer total_pages {get; set;}
        public List<M_DiscoverTVSeriesObject> results {get; set;}
    }

    public with sharing class M_DiscoverTVSeriesObject{
        @AuraEnabled
        public String original_name;
        @AuraEnabled
        public String name;
        @AuraEnabled
        public Double popularity;
        @AuraEnabled
        public String [] origin_country;
        @AuraEnabled
        public Integer vote_count;
        @AuraEnabled
        public String first_air_date;
        @AuraEnabled
        public String backdrop_path;
        @AuraEnabled
        public String original_language;
        @AuraEnabled
        public Integer id;
        @AuraEnabled
        public Double vote_average;
        @AuraEnabled
        public String overview;
        @AuraEnabled
        public String poster_path;
        @AuraEnabled
        public String[] genre_ids;
    }

    public with sharing class M_Actor{
        public Integer page {get; set;}
        public Integer total_results {get; set;}
        public Integer total_pages {get; set;}
        public List<M_ActorObject> results {get; set;}
    }

    public with sharing class M_ActorObject{
        @AuraEnabled
        public Double popularity;
        @AuraEnabled
        public String id;
        @AuraEnabled
        public String name;
        @AuraEnabled
        public String profile_path;
    }

    public with sharing class M_ProductionCompany{
        @AuraEnabled
        public String id;
        @AuraEnabled
        public String logo_path;
        @AuraEnabled
        public String name;
        @AuraEnabled
        public String origin_country;
    }

    public with sharing class M_ProductionCountry{
        @AuraEnabled
        public String iso_3166_1;
        @AuraEnabled
        public String name;
    }

    public with sharing class M_SpokenLanguage{
        @AuraEnabled
        public String iso_639_1;
        @AuraEnabled
        public String name;
    }

    public with sharing class M_MovieDetails{
        @AuraEnabled
        public String id;
        @AuraEnabled
        public String budget;
        @AuraEnabled
        public M_Genre[] genres;
        @AuraEnabled
        public String homepage;
        @AuraEnabled
        public String overview;
        @AuraEnabled
        public String poster_path;
        @AuraEnabled
        public M_ProductionCompany[] production_companies;
        @AuraEnabled
        public M_ProductionCountry[] production_countries;
        @AuraEnabled
        public String release_date;
        @AuraEnabled
        public String revenue;
        @AuraEnabled
        public String runtime;
        @AuraEnabled
        public M_SpokenLanguage[] spoken_languages;
        @AuraEnabled
        public String title;
        @AuraEnabled
        public String vote_average;
        @AuraEnabled
        public String vote_count;
    }

    public with sharing class M_CastItem{
        @AuraEnabled
        public String cast_id;
        @AuraEnabled
        public String character;
        @AuraEnabled
        public String credit_id;
        @AuraEnabled
        public String gender;
        @AuraEnabled
        public String id;
        @AuraEnabled
        public String name;
        @AuraEnabled
        public String order;
        @AuraEnabled
        public String profile_path;
    }

    public with sharing class M_Cast{
        @AuraEnabled
        public String id;
        @AuraEnabled
        public M_CastItem[] castCredits;
    }

    public with sharing class M_Reviews{
        public Integer page {get; set;}
        public Integer total_results {get; set;}
        public Integer total_pages {get; set;}
        public List<M_ReviewsItem> results {get; set;}
    }

    public with sharing class M_ReviewsItem{
        @AuraEnabled
        public String id;
        @AuraEnabled
        public String author;
        @AuraEnabled
        public String content;
        @AuraEnabled
        public String url;
    }

    public with sharing class M_ActorDetails{
        @AuraEnabled
        public String biography;
        @AuraEnabled
        public String birthday;
        @AuraEnabled
        public String deathday;
        @AuraEnabled
        public String gender;
        @AuraEnabled
        public String homepage;
        @AuraEnabled
        public String id;
        @AuraEnabled
        public String name;
        @AuraEnabled
        public String place_of_birth;
        @AuraEnabled
        public String popularity;
        @AuraEnabled
        public String profile_path;
    }

    public with sharing class M_Filmography{
        public M_FilmographyItem[] filmography {get; set;}
    }

    public with sharing class M_FilmographyItem{
        @AuraEnabled
        public String character;
        @AuraEnabled
        public String release_date;
        @AuraEnabled
        public String vote_average;
        @AuraEnabled
        public String backdrop_path;
        @AuraEnabled
        public String title;
        @AuraEnabled
        public String id;
        @AuraEnabled
        public String overview;
        @AuraEnabled
        public String poster_path;
    }
}