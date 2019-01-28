/**
 * Created by BRITENET on 07.11.2018.
 */

public with sharing class Mech_MechanicsSearchController {
    public List<Mechanic__c> mechanics { get; private set; }
    public Mechanic__c mechanic { get; set; }
    private static final String DELIMITER = ';';
    public String sortType { get; set; }
    public String order { get; set; }
    public Integer queryLimit {get;set;}
    public Integer offset = 0;
    private Integer totalMechanics = 0;
    public String toFileType {get;set;}

    public Mech_MechanicsSearchController() {
        mechanics = new List<Mechanic__c>();
        mechanic = new Mechanic__c();
        mechanic.Name = ApexPages.currentPage().getParameters().get('name');
        mechanic.Email__c = ApexPages.currentPage().getParameters().get('email');
        mechanic.Phone_Number__c = ApexPages.currentPage().getParameters().get('phone');
        mechanic.Country__c = ApexPages.currentPage().getParameters().get('country');
        sortType = 'Name';
        order = 'ASC';
        totalMechanics = mechanics.size();
        queryLimit=5;
    }

    public PageReference searchMechanics() {
        String nameStr = '%' + mechanic.Name + '%';
        String emailStr = '%' + mechanic.Email__c + '%';
        String countryStr = '%' + mechanic.Country__c + '%';
        mechanics = Database.query('SELECT id, Name, Full_Name__c, Country__c, Email__c, Phone_Number__c ' +
                'FROM Mechanic__c WHERE Name LIKE \'' + nameStr + '\' AND Country__c LIKE \'' + countryStr +
                '\' AND Email__c LIKE \'' + emailStr + '\' ORDER BY ' + sortType + ' ' + order + ' LIMIT ' +
                queryLimit + ' OFFSET ' + offset);
        totalMechanics = mechanics.size();
        spin();
        return null;
    }

    public PageReference exportToCSV() {
        PageReference page = new PageReference('/apex/Mech_ExportToCSV');
        page.setRedirect(false);
        return page;
    }

    public PageReference exportToXls() {
        PageReference page = new PageReference('/apex/Mech_ExportToXLS');
        page.setRedirect(false);
        return page;
    }

    public String getCsvContent() {
        searchMechanics();
        List<String> csvrows = new List<String>();
        csvrows.add ('Name' + DELIMITER + 'Email' + DELIMITER + 'Phone' + DELIMITER + 'Country');
        for (Mechanic__c m : mechanics) {
            csvrows.add('\"' + m.Name + '\"' + DELIMITER + '\"' + m.Email__c + '\"' + DELIMITER + '\"' +
                    m.Phone_Number__c + '\"' + DELIMITER + '\"' + m.Country__c + '\"');
        }
        return String.join(csvrows, '\r\n');
    }

    public void sortByField() {
        if (order == 'ASC') {
            order = 'DESC';
        } else {
            order = 'ASC';
        }
        searchMechanics();
    }

    public void next() {
        offset = offset + queryLimit;
        searchMechanics();
    }

    public void previous() {
        offset = offset - queryLimit;
        searchMechanics();
    }

    public void beginning(){
        offset =0;
        searchMechanics();
    }

    public void end(){
        offset = totalMechanics - math.mod(totalMechanics,queryLimit);
        searchMechanics();
    }

    public boolean getPrev(){
        if(offset==0){
            return true;
        }else{
            return false;
        }
    }

    public boolean getNex(){
        if((offset+queryLimit)>totalMechanics){
            return true;
        }else{
            return false;
        }
    }

        public void spin() {
            long now = datetime.now().gettime();
            while(datetime.now().gettime()-now<2500);
        }
}