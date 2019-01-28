/**
 * Created by BRITENET on 07.11.2018.
 */

public with sharing class CustomSearchController {
    public List<Mechanic__c> mechanics { get; private set; }
    public Mechanic__c mechanic { get; set; }
    public string header { get; private set; }
    private static final String DELIMITER = ';';
    public static Integer pageSize { get; set; }
    public  String sortType { get; set; }
    public String sortByFieldNameParam { get; set; }
    public List<Mechanic__c> displayedResult { get; set; }
    public Boolean renderTable { get; set; }



    public CustomSearchController() {
        mechanics = new List<Mechanic__c>();
        mechanic = new Mechanic__c();
        header = 'Name;Email;Phone;Country';
        mechanic.Name = ApexPages.currentPage().getParameters().get('name');
        mechanic.Email__c = ApexPages.currentPage().getParameters().get('email');
        mechanic.Phone_Number__c = ApexPages.currentPage().getParameters().get('phone');
        mechanic.Country__c = ApexPages.currentPage().getParameters().get('country');
    }

    public PageReference searchMechanics() {
        System.debug('SortType SM: '+sortType);
        String nameStr = mechanic.Name + '%';
        String emailStr = mechanic.Email__c + '%';
        String countryStr = '%' + mechanic.Country__c + '%';
        mechanics = Database.query('SELECT id, Name, Country__c, Email__c, Phone_Number__c FROM Mechanic__c WHERE Name LIKE \'' + nameStr + '\' AND Country__c LIKE \'' + countryStr + '\' AND Email__c LIKE \'' + emailStr + '\' ORDER BY ' + sortType);
        return null;
    }

    public PageReference exportToCsv() {
        PageReference page = new PageReference('/apex/ExportToCsv');
        for (Mechanic__c m : mechanics) {
            page.getParameters().put('name', m.Name);
            page.getParameters().put('email', m.Email__c);
            page.getParameters().put('phone', m.Phone_Number__c);
            page.getParameters().put('country', m.Country__c);
            page.getParameters().put('sortType', sortType);
            System.debug('SortType PR: '+sortType);
        }
        page.setRedirect(false);
        return page;
    }

    public PageReference exportToXls() {
        PageReference page = new PageReference('/apex/ExportToXls');
        page.getParameters().put('name', mechanic.Name);
        page.getParameters().put('email', mechanic.Email__c);
        page.getParameters().put('phone', mechanic.Phone_Number__c);
        page.getParameters().put('country', mechanic.Country__c);
        page.getParameters().put('sortType', sortType);
        page.setRedirect(false);
        return page;
    }

    public String getCsvContent() {
        searchMechanics();
        String[] csvrows = new String[]{};
        csvrows.add ('Name' + DELIMITER + 'Email' + DELIMITER + 'Phone' + DELIMITER + 'Country');
        for (Mechanic__c m : mechanics) {
            csvrows.add('\"' + m.Name + '\"' + DELIMITER + '\"' + m.Email__c + '\"' + DELIMITER + '\"' + m.Phone_Number__c + '\"' + DELIMITER + '\"' + m.Country__c + '\"');
        }
        return String.join(csvrows, '\r\n');
    }
}