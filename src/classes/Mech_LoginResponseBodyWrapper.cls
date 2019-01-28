/**
 * Created by BRITENET on 05.12.2018.
 */

public with sharing class Mech_LoginResponseBodyWrapper {
    public String access_token {get; set;}
    public String instance_url {get; set;}
    public String id {get; set;}
    public String token_type {get; set;}
    public String issued_at {get; set;}
    public String signature {get; set;}

}