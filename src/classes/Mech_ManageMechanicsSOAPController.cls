/**
 * Created by BRITENET on 21.11.2018.
 */

public with sharing class Mech_ManageMechanicsSOAPController {

    public String result{get;set;}

    public class MechanicWrapper {
        public String firstName{get;set;}
        public String lastName{get;set;}
        public String city{get;set;}
        public String country{get;set;}
        public String id{get;set;}

        public MechanicWrapper(String firstName, String lastName, String city, String Country) {
            this.firstName = firstName;
            this.lastName = lastName;
            this.city = city;
            this.country = country;
        }

        public MechanicWrapper() {
        }
    }

    public String mechanicToDeleteId { get; set; }
    public String editedMechanicId { get; set; }
    public MechanicWrapper editedMechanic { get; set; }
    public soapSforceComSchemasClassMechMechaServ.WebServiceMechanicWrapper searchedMechanic { get; set; }
    public soapSforceComSchemasClassMechMechaWebSer.SessionHeader_element header { get; set; }
    public soapSforceComSchemasClassMechMechaWebSer.Mech_MechanicWebService soapmechanicService { get; set; }
    public Boolean deleteMechanicSuccess { get; set; }
    public Boolean updateMechanicSuccess { get; set; }
    public String firstName { get; set; }
    public String lastName { get; set; }
    public String city { get; set; }
    public String country { get; set; }
    public List<soapSforceComSchemasClassMechMechaServ.WebServiceMechanicWrapper> wrapers { get; set; }
    public List<MechanicWrapper> allMechanics { get; set; }
    public MechanicWrapper mechanicWrapper { get; set; }

    public Mech_ManageMechanicsSOAPController() {
        searchedMechanic = new soapSforceComSchemasClassMechMechaServ.WebServiceMechanicWrapper();
        header = new soapSforceComSchemasClassMechMechaWebSer.SessionHeader_element();
        header.sessionId = '00D1t000000sI9h!AQcAQHe2UIKzyUsr9BW_DihynwvC3I6nxSIprAX0sEWsiZt11b9yEiLrY6DjTLCuGEVX3P9g3f_SZujSE8NGhxbYMdXOJt1P';
        soapmechanicService = new soapSforceComSchemasClassMechMechaWebSer.Mech_MechanicWebService();
        soapmechanicService.SessionHeader = header;
        allMechanics = new List<MechanicWrapper>();
    }

    public void getMechanics(String firstName, String lastName, String city, String country) {
        wrapers = soapmechanicService.getMechanics(firstName, lastName, city, country);
        if (wrapers != null) {

            for (soapSforceComSchemasClassMechMechaServ.WebServiceMechanicWrapper wraper : wrapers) {
                mechanicWrapper = new MechanicWrapper();
                mechanicWrapper.id=wraper.id;
                mechanicWrapper.firstName = wraper.firstName;
                mechanicWrapper.lastName = wraper.lastName;
                mechanicWrapper.city = wraper.city;
                mechanicWrapper.country = wraper.country;
                allMechanics.add(mechanicWrapper);
            }
        }
    }

    public void deleteMechanic(){
        Boolean result =  soapmechanicService.deleteSingleMechanic(mechanicToDeleteId);
    }

    public void updateMechanic(){
        soapSforceComSchemasClassMechMechaServ.WebServiceMechanicWrapper mechanicToUpdateWrapper = new soapSforceComSchemasClassMechMechaServ.WebServiceMechanicWrapper();
        mechanicToUpdateWrapper.Id = editedMechanic.id;
        mechanicToUpdateWrapper.firstName = editedMechanic.firstName;
        mechanicToUpdateWrapper.lastName = editedMechanic.lastName;
        mechanicToUpdateWrapper.city = editedMechanic.city;
        mechanicToUpdateWrapper.country = editedMechanic.country;
        result = soapmechanicService.updateSingleMechanic(mechanicToUpdateWrapper);
    }

    public void setEditedMechanic() {
        for (MechanicWrapper mechanic : allMechanics) {
            if (mechanic.id == editedMechanicId) {
                editedMechanic = mechanic;
                break;
            }
        }
    }

    public void searchMechanics() {
        allMechanics.clear();
        searchedMechanic.firstname = searchedMechanic.firstname == null ? '' : searchedMechanic.firstname;
        searchedMechanic.lastname = searchedMechanic.lastname == null ? '' : searchedMechanic.lastname;
        searchedMechanic.city = searchedMechanic.city == null ? '' : searchedMechanic.city;
        searchedMechanic.country = searchedMechanic.country == null ? '' : searchedMechanic.country;
        getMechanics(firstName, lastName, city, country);
    }

    public void clearSearchForm() {
        allMechanics.clear();
        wrapers.clear();
    }
}