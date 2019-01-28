/**
 * Created by BRITENET on 12.11.2018.
 */

public class CsvImporter {

    private static final String CR = '\r';
    private static final String LF = '\n';
    private static final String CRLF = CR + LF;
    private static final String LFCR = LF + CR;

    private Map<String, SObject> extIdMap = new Map<String, SObject>();
    private static Map<String, Map<String, RecordType>> recordTypes = new Map<String, Map<String, RecordType>>();

    public CsvImporter(){}

    public List<sObject> parseAndReturn(String dataBody, String sObjectName, String externalField){
        ImportCSVFile icsvfile = new ImportCSVFile(sObjectName, externalField)
                .setExternalMap(extIdMap)
                .setData(dataBody)
                .parse();
        return icsvfile.objsToInsert;
    }

    public class ParserException extends Exception{}

    public class ImportCSVFile {

        private final String sObjectType;
        private String externalIdFieldName;

        private Map<String, SObject> extIdMap = new Map<String, SObject>();

        private String quoteChar = '"';
        private String doubleQuote = quoteChar + quoteChar;
        private String commaChar = ',';
        private String rowDelimiter = null;

        private String fileString = null;
        private List<String> headers = null;
        private List<List<String>> dataToImport;
        private Map<String, Integer> colIndx;
        private List<SObject> objsToInsert = new List<SObject>();
        private Set<String> excludedFields = new Set<String>{'systemmodstamp', 'createdbyid', 'createddate', 'lastmodifiedbyid', 'lastmodifieddate', 'isdeleted', 'currencyisocode', 'isvisibleinselfservice'};

        public ImportCSVFile(String sObjectName, String externalIdFieldName){
            this.sObjectType = sObjectName;
            this.externalIdFieldName = externalIdFieldName != null ? externalIdFieldName.toLowerCase() : null;
        }
        public ImportCSVFile setExternalMap(Map<String, SObject> extIdMap){
            this.extIdMap = extIdMap;
            return this;
        }
        public ImportCSVFile setData(String dataBody){
            dataToImport = new List<List<String>>();
            fileString = dataBody;

            if(fileString == null || fileString.trim() == ''){
                throw new ParserException('Empty data source');
            }
            fileString = fileString.trim();

            rowDelimiter = rowDelimiter != null ? rowDelimiter : dataBody.endsWith(CRLF) ? CRLF : dataBody.endsWith(LF) ? LF : CRLF;
            if(!fileString.endsWith(rowDelimiter)) {
                fileString = fileString + rowDelimiter;
            }

            headers = readRow();
            colIndx = new Map<String, Integer>();
            for (Integer i = 0; i < headers.size(); i++) {
                headers[i] = headers[i].trim().toLowerCase();
                colIndx.put(headers.get(i), i);
            }

            List<String> line = readRow();
            while (!line.isEmpty()) {
                dataToImport.add(line);
                line = readRow();
            }
            return this;
        }

        private ImportCSVFile parse(){
            objsToInsert = new List<SObject>();
            if(extIdMap == null){
                extIdMap = new Map<String, SObject>();
            }

            for (List<String> line : dataToImport) {
                parseSObject(parseLine(line));
            }

            return this;
        }

        private List<String> readRow() {
            if (fileString == null || fileString == '') {
                return new List<String>();
            }

            String tokenValue;
            Boolean tokenEnclosed;
            String tokenDelimiter;
            Integer tokenLength;
            List<String> rowValues = new List<String>();
            List<String> rowValuesNull = new List<String>();
            while (true) {
                if (quoteChar != '' && fileString.startsWith(quoteChar)) {
                    Integer searchIndex = 1, dquoteIndex = -1, dquotesIndex = -1;

                    while (true) {
                        dquoteIndex = fileString.indexOf(quoteChar, searchIndex);
                        dquotesIndex = fileString.indexOf(doubleQuote, searchIndex);

                        if (dquoteIndex == dquotesIndex) {
                            searchIndex = dquotesIndex + doubleQuote.length();
                        } else {
                            break;
                        }
                    }

                    Integer commaIndex = fileString.indexOf(commaChar, dquoteIndex);
                    Integer terminatorIndex = fileString.indexOf(rowDelimiter, dquoteIndex);

                    tokenEnclosed = true;
                    tokenDelimiter = commaIndex != -1 && commaIndex < terminatorIndex ? commaChar : rowDelimiter;
                    tokenValue = fileString.substring(quoteChar.length(), dquoteIndex).replaceAll(doubleQuote, quoteChar);
                } else {
                    tokenEnclosed = false;

                    Integer commaIndex = fileString.indexOf(commaChar);
                    Integer terminatorIndex = fileString.indexOf(rowDelimiter);

                    if (commaIndex != -1 && commaIndex < terminatorIndex) {
                        tokenValue = fileString.substring(0, commaIndex);
                        tokenDelimiter = commaChar;
                    } else {
                        tokenValue = fileString.substring(0, terminatorIndex);
                        tokenDelimiter = rowDelimiter;
                    }

                }

                tokenLength = tokenValue.replaceAll(quoteChar, doubleQuote).length() + tokenDelimiter.length() + (tokenEnclosed ? quoteChar.length() * 2 : 0);
                rowValues.add(tokenValue);

                if (tokenDelimiter == rowDelimiter) {
                    if (tokenValue.length() == 0 && !tokenEnclosed && rowValues.size() == 1) {
                        fileString = '';
                        return new List<String>();
                    } else if (colIndx != null && colIndx.size() != rowValues.size()) {
                       //throw new ParserException('CSV File is broken.');
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'CSV File is broken. Column missing.'));
                        //return rowValuesNull;
                        //return rowValues;
                    }
                }

                if (tokenLength == fileString.length()) {
                    fileString = '';
                    return rowValues;
                } else {
                    fileString = fileString.substring(tokenLength);
                }
                if (tokenDelimiter == rowDelimiter) {
                    break;
                }
            }
            return rowValues;
        }

        private Map<String, String> parseLine(List<String> line) {
            Map<String, String> row = new Map<String, String>();

            for (Integer i = 0; i < line.size(); i++) {
                row.put(headers[i], line[i].trim());
            }
            return row;
        }

        private void parseSObject(Map<String, String> rowData) {
            SObject obj = createSObject();
            objsToInsert.add(obj);

            addToExternalRecordsMap(rowData);

            for (String fieldName: rowData.keySet()){
                String val = rowData.get(fieldName);
                if (String.isBlank(val) || excludedFields.contains(fieldName)) {
                    //obj.put(fieldName, val);

                } else if(fieldName == 'id'){
                    obj.put(externalIdFieldName, val);

                } else if(fieldName == 'OwnerId'){
                    obj.put('OwnerId', UserInfo.getUserId());

                } else if (fieldName == 'RecordTypeId') {
                    obj.put(fieldName, getRecordTypeId(val));

                } else {
                    Schema.DescribeFieldResult fieldDesc = getFieldDescribe(fieldName);

                    if (fieldDesc != null && fieldDesc.isCreateable() && !fieldDesc.isCalculated()) {

                        Schema.DisplayType fieldType = fieldDesc.getType();

                        if (fieldType == Schema.DisplayType.Double || fieldType == Schema.DisplayType.Currency || fieldType == Schema.DisplayType.Percent) {
                            obj.put(fieldName, Double.valueOf(val));
                        } else if (fieldType == Schema.DisplayType.Integer) {
                            obj.put(fieldName, Integer.valueOf(val));
                        } else if (fieldType == Schema.DisplayType.Boolean || fieldType == Schema.DisplayType.Combobox) {
                            obj.put(fieldName, Boolean.valueOf(val));
                        } else if (fieldType == Schema.DisplayType.Reference) {
                            obj.putSObject(fieldDesc.getRelationshipName(), extIdMap.get(val));
                        } else if (fieldType == Schema.DisplayType.Date) {
                            String[] d = val.replace(' 00:00:00', '').split('-');
                            obj.put(fieldName, Date.newInstance(Integer.valueOf(d[0]), Integer.valueOf(d[1]), Integer.valueOf(d[2])));
                        } else if (fieldType == Schema.DisplayType.DateTime) {
                            String[] dt = val.split(' ');
                            String[] d = dt[0].split('-');
                            String[] t = dt[1].split(':');
                            obj.put(fieldName, DateTime.newInstance(Integer.valueOf(d[0]), Integer.valueOf(d[1]), Integer.valueOf(d[2]),
                                    Integer.valueOf(t[0]), Integer.valueOf(t[1]), 0));
                        } else {
                            obj.put(fieldName, val);
                        }
                    }
                }
            }
        }

        private SObject createSObject(){
            Map<String, Schema.SObjectType> t = Schema.getGlobalDescribe();
            if (!t.containsKey(sObjectType)) {
                throw new ParserException('Object "' + sObjectType + '" does not exists');
            }
            SObject s = t.get(sObjectType).newSObject();
            return s;
        }

        private void addToExternalRecordsMap(Map<String, String> rowData) {
            if (externalIdFieldName != null) {
                if (rowData.containsKey('id')) {
                    String val = rowData.get('id');
                    SObject extRef = createSObject();
                    extRef.put(externalIdFieldName, val);
                    extIdMap.put(val, extRef);
                }
            }
        }

        private Id getRecordTypeId(String devName) {
            return getRecordType(devName).Id;
        }

        private RecordType getRecordType(String devName) {
            if (CsvImporter.recordTypes.isEmpty()) {
                for (RecordType rt : [SELECT Id, SObjectType, DeveloperName FROM RecordType]) {
                    if (!CsvImporter.recordTypes.containsKey(rt.SObjectType)) {
                        CsvImporter.recordTypes.put(rt.SObjectType, new Map<String, RecordType>());
                    }
                    CsvImporter.recordTypes.get(rt.SObjectType).put(rt.DeveloperName, rt);
                }
            }
            return CsvImporter.recordTypes.get(sObjectType).get(devName);
        }

        private Schema.DescribeFieldResult getFieldDescribe(String fieldName) {
            Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(sObjectType).getDescribe().fields.getMap();
            if (!fieldMap.containsKey(fieldName)) {
                System.debug(LoggingLevel.ERROR, 'Field "' + fieldName + '" does not exists');
                return null;
            }
            return fieldMap.get(fieldName).getDescribe();
        }
    }
}