/**
 * Created by BRITENET on 04.01.2019.
 */

public with sharing class TMDB_Wrapper {
    
        public with sharing class TMDB_Genres {
            public List<TMDB_Genre> genres {get; set;}
        }

        public with sharing class TMDB_Genre {
            @AuraEnabled
            public String id {get; set;}
            @AuraEnabled
            public String name {get; set;}
        }

        public with sharing class TMDB_DiscoverMovieObject {
            @AuraEnabled
            public Integer vote_count {get; set;}
            @AuraEnabled
            public Integer id {get; set;}
//
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

        public with sharing class TMDB_DiscoverMovie{
            @AuraEnabled
            public Integer page {get; set;}
            @AuraEnabled
            public Integer total_results {get; set;}
            @AuraEnabled
            public Integer total_pages {get; set;}
            @AuraEnabled
            public List<TMDB_DiscoverMovieObject> results {get; set;}
        }

        public with sharing class TMDB_MovieDetails{
            @AuraEnabled
            public String id;
            @AuraEnabled
            public String budget;
            @AuraEnabled
            public TMDB_Genre[] genres;
            @AuraEnabled
            public String homepage;
            @AuraEnabled
            public String overview;
            @AuraEnabled
            public String poster_path;
            @AuraEnabled
            public TMDB_ProductionCompany[] production_companies;
            @AuraEnabled
            public TMDB_ProductionCountry[] production_countries;
            @AuraEnabled
            public String release_date;
            @AuraEnabled
            public String revenue;
            @AuraEnabled
            public String runtime;
            @AuraEnabled
            public TMDB_SpokenLanguage[] spoken_languages;
            @AuraEnabled
            public String title;
            @AuraEnabled
            public String vote_average;
            @AuraEnabled
            public String vote_count;
        }

        public with sharing class TMDB_Actor{
            public Integer page {get; set;}
            public Integer total_results {get; set;}
            public Integer total_pages {get; set;}
            public List<TMDB_ActorObject> results {get; set;}
        }

        public with sharing class TMDB_ActorObject{
            @AuraEnabled
            public Double popularity;
            @AuraEnabled
            public String id;
            @AuraEnabled
            public String name;
            @AuraEnabled
            public String profile_path;
        }

        public with sharing class TMDB_ProductionCompany{
            @AuraEnabled
            public String id;
            @AuraEnabled
            public String logo_path;
            @AuraEnabled
            public String name;
            @AuraEnabled
            public String origin_country;
        }

        public with sharing class TMDB_ProductionCountry{
            @AuraEnabled
            public String iso_3166_1;
            @AuraEnabled
            public String name;
        }

        public with sharing class TMDB_SpokenLanguage{
            @AuraEnabled
            public String iso_639_1;
            @AuraEnabled
            public String name;
        }

        public with sharing class TMDB_CastItem{
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

        public with sharing class TMDB_Cast{
            @AuraEnabled
            public String id;
            @AuraEnabled
            public TMDB_CastItem[] castCredits;
        }

        public with sharing class TMDB_ActorDetails{
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

        public with sharing class TMDB_Filmography{
            public TMDB_FilmographyItem[] filmography {get; set;}
        }

        public with sharing class TMDB_FilmographyItem{
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

        public with sharing class TMDB_Reviews{
            public Integer page {get; set;}
            public Integer total_results {get; set;}
            public Integer total_pages {get; set;}
            public List<TMDB_ReviewsItem> results {get; set;}
        }

        public with sharing class TMDB_ReviewsItem{
            @AuraEnabled
            public String id;
            @AuraEnabled
            public String author;
            @AuraEnabled
            public String content;
            @AuraEnabled
            public String url;
        }


    }