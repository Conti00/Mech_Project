//Generated by wsdl2apex

public class AsyncA {
    public class getMechanicsResponse_elementFuture extends System.WebServiceCalloutFuture {
        public soapSforceComSchemasClassMechMecha.WebServiceMechanicWrapper[] getValue() {
            a.getMechanicsResponse_element response = (a.getMechanicsResponse_element)System.WebServiceCallout.endInvoke(this);
            return response.result;
        }
    }
    public class deleteSingleMechanicResponse_elementFuture extends System.WebServiceCalloutFuture {
        public String getValue() {
            a.deleteSingleMechanicResponse_element response = (a.deleteSingleMechanicResponse_element)System.WebServiceCallout.endInvoke(this);
            return response.result;
        }
    }
    public class updateSingleMechanicResponse_elementFuture extends System.WebServiceCalloutFuture {
        public String getValue() {
            a.updateSingleMechanicResponse_element response = (a.updateSingleMechanicResponse_element)System.WebServiceCallout.endInvoke(this);
            return response.result;
        }
    }
    public class AsyncMech_MechanicWebService {
        public String endpoint_x = 'https://eu16.salesforce.com/services/Soap/class/Mech_MechanicWebService';
        public Map<String,String> inputHttpHeaders_x;
        public String clientCertName_x;
        public Integer timeout_x;
        public a.SessionHeader_element SessionHeader;
        public a.DebuggingHeader_element DebuggingHeader;
        public a.AllowFieldTruncationHeader_element AllowFieldTruncationHeader;
        public a.CallOptions_element CallOptions;
        public a.DebuggingInfo_element DebuggingInfo;
        private String SessionHeader_hns = 'SessionHeader=http://soap.sforce.com/schemas/class/Mech_MechanicWebService';
        private String DebuggingHeader_hns = 'DebuggingHeader=http://soap.sforce.com/schemas/class/Mech_MechanicWebService';
        private String AllowFieldTruncationHeader_hns = 'AllowFieldTruncationHeader=http://soap.sforce.com/schemas/class/Mech_MechanicWebService';
        private String CallOptions_hns = 'CallOptions=http://soap.sforce.com/schemas/class/Mech_MechanicWebService';
        private String DebuggingInfo_hns = 'DebuggingInfo=http://soap.sforce.com/schemas/class/Mech_MechanicWebService';
        private String[] ns_map_type_info = new String[]{'http://soap.sforce.com/schemas/class/Mech_MechanicWebService', 'a', 'http://soap.sforce.com/schemas/class/Mech_MechanicServicesUtils', 'soapSforceComSchemasClassMechMecha'};
        public AsyncA.getMechanicsResponse_elementFuture beginGetMechanics(System.Continuation continuation,String firstName,String lastName,String city,String country) {
            a.getMechanics_element request_x = new a.getMechanics_element();
            request_x.firstName = firstName;
            request_x.lastName = lastName;
            request_x.city = city;
            request_x.country = country;
            return (AsyncA.getMechanicsResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncA.getMechanicsResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              '',
              'http://soap.sforce.com/schemas/class/Mech_MechanicWebService',
              'getMechanics',
              'http://soap.sforce.com/schemas/class/Mech_MechanicWebService',
              'getMechanicsResponse',
              'a.getMechanicsResponse_element'}
            );
        }
        public AsyncA.deleteSingleMechanicResponse_elementFuture beginDeleteSingleMechanic(System.Continuation continuation,String mechanicId) {
            a.deleteSingleMechanic_element request_x = new a.deleteSingleMechanic_element();
            request_x.mechanicId = mechanicId;
            return (AsyncA.deleteSingleMechanicResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncA.deleteSingleMechanicResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              '',
              'http://soap.sforce.com/schemas/class/Mech_MechanicWebService',
              'deleteSingleMechanic',
              'http://soap.sforce.com/schemas/class/Mech_MechanicWebService',
              'deleteSingleMechanicResponse',
              'a.deleteSingleMechanicResponse_element'}
            );
        }
        public AsyncA.updateSingleMechanicResponse_elementFuture beginUpdateSingleMechanic(System.Continuation continuation,soapSforceComSchemasClassMechMecha.WebServiceMechanicWrapper mechanicToUpdateWrapper) {
            a.updateSingleMechanic_element request_x = new a.updateSingleMechanic_element();
            request_x.mechanicToUpdateWrapper = mechanicToUpdateWrapper;
            return (AsyncA.updateSingleMechanicResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncA.updateSingleMechanicResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              '',
              'http://soap.sforce.com/schemas/class/Mech_MechanicWebService',
              'updateSingleMechanic',
              'http://soap.sforce.com/schemas/class/Mech_MechanicWebService',
              'updateSingleMechanicResponse',
              'a.updateSingleMechanicResponse_element'}
            );
        }
    }
}