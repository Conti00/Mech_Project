/**
 * Created by BRITENET on 17.12.2018.
 */

public with sharing class Mech_OrgInfoController {
    public List<User> allUsers { get; set; }
    public Integer numberOfActiveUsers { get; set; }
    public Integer numberOfInactiveUsers { get; set; }
    public String userHistoryId { get; set; }
    public String userGroupsId { get; set; }
    public List<LoginHistory> loginHistory { get; set; }
    public List<GroupMember> groupMembers { get; set; }
    public List<ApexClass> allClasses { get; set; }
    public List<ApexPage> allPages { get; set; }
    public String SalesforceURL { get; set; }
    public List<Organization> OrganizationList { get; set; }
    public String InstanceName { get; set; }
    public String Session { get; set; }
    public Boolean hasNotLoginHistory { get; set; }
    public Boolean hasNotGroupMember { get; set; }
    public Boolean showClasses { get; set; }
    public Boolean showPages { get; set; }
    public Integer numberOfLicenses { get; set; }
    public List<UserLicense> userLicenses { get; set; }
    public List<LicenseWithPercent> allLicenses { get; set; }

    public Mech_OrgInfoController() {
        searchUsers();
        searchClasses();
        searchPages();
        searchUserLicenses();
        SalesforceURL = URL.getSalesforceBaseUrl().getHost();
        OrganizationList = [SELECT InstanceName FROM Organization LIMIT 1];
        InstanceName = OrganizationList.get(0).InstanceName;
        Session = UserInfo.getSessionId();
        userLicenses = [SELECT TotalLicenses FROM UserLicense WHERE Name = 'Salesforce'];
        numberOfLicenses = userLicenses.get(0).TotalLicenses;
    }

    public void searchUsers() {
        allUsers = [
                SELECT Id, Username, FirstName, LastName, isActive
                FROM User
        ];

        numberOfActiveUsers = [SELECT Count() FROM User WHERE isActive = true];
        numberOfInactiveUsers = allUsers.size() - numberOfActiveUsers;
    }

    public void searchClasses() {
        allClasses = [SELECT Id, Name, ApiVersion, CreatedDate, LastModifiedDate, CreatedBy.Name FROM ApexClass];
    }

    public void searchPages() {
        allPages = [SELECT Id, Name, ApiVersion, CreatedDate, LastModifiedDate, CreatedBy.Name FROM ApexPage];
    }

    public void getUserLoginHistoryById() {
        loginHistory = new List<LoginHistory>();
        loginHistory = [
                SELECT Id, LoginTime, Status, SourceIp, Browser, Platform
                FROM LoginHistory
                WHERE UserId = :userHistoryId
                ORDER BY LoginTime DESC
                LIMIT 10
        ];
        hasNotLoginHistory = loginHistory.size() <= 0 ? true : false;
    }

    public void getUserGroupsById() {
        groupMembers = new List<GroupMember>();
        groupMembers = [
                SELECT Group.Name
                FROM GroupMember
                WHERE UserOrGroupId = :userGroupsId
        ];
        hasNotGroupMember = groupMembers.size() <= 0 ? true : false;
    }

    public void showClasses() {
        showClasses = showClasses == true ? false : true;
    }

    public void showPages() {
        showPages = showPages == true ? false : true;
    }

    public void searchUserLicenses() {
        List<UserLicense> licenses = [SELECT Name, UsedLicenses, TotalLicenses FROM UserLicense];
        allLicenses = new List<LicenseWithPercent>();
        for (UserLicense userLic : licenses) {
            LicenseWithPercent licenseWithPercent = new LicenseWithPercent(userLic);
            if (userLic.TotalLicenses != 0) {
                licenseWithPercent.percent = (userLic.UsedLicenses / (Double) userLic.TotalLicenses) * 100;
            } else {
                licenseWithPercent.percent = 0;
            }
            allLicenses.add(licenseWithPercent);
        }
    }

    public class LicenseWithPercent {
        public UserLicense license { get; set; }
        public Double percent { get; set; }

        public LicenseWithPercent(UserLicense license) {
            this.license = license;
        }
    }
}