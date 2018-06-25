/******************************************************************************************************************************************
 * Class Name   : DRDP_CreateContractController
 * Description  : controller class for DRDP_CreateContract page
 * Created By   : Deloitte Consulting
 *
 *****************************************************************************************************************************************/
Public with sharing class DRDP_CreateContractController {
    public Contracts__c oContract {get; set;}
    public id currentRecordID;

    //Loading the Constructor
    public DRDP_CreateContractController(ApexPages.StandardController controller) {
        currentRecordID = ApexPages.currentPage().getParameters().get('id');
        if (currentRecordID != Null) {

            String SobjectApiName = 'Contracts__c';
            Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
            Map < String, Schema.SObjectField > fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();

            String commaSeparatedFields = '';
            for (String fieldName : fieldMap.keyset()) {
                if (commaSeparatedFields == null || commaSeparatedFields == '') {
                    commaSeparatedFields = fieldName;
                } else {
                    commaSeparatedFields = commaSeparatedFields + ', ' + fieldName;
                }
            }
            
            string query = 'select ' + commaSeparatedFields + ' from ' + SobjectApiName + ' where id =\'' + currentRecordID + '\' limit 1';
            oContract = Database.query(query);

        }

        else {
            oContract = new Contracts__c();
        }
    }

    /*
     * @Method Name                    :  save
     * @Description                    :  Method to Save the ContractRecord record
     * @Return Type                    :  PageReference
     * @Parameters                     :  None
     */
    public PageReference save() {

        
        pagereference pageref;
        try {
            upsert oContract oContract.Id;
            pageref = new pagereference('/apex/CreateContract?id=' + oContract.id  + '&isEdit=false');
            pageref.setredirect(true);
            return pageref;
        }

        catch (exception e) {
            String error = e.getdmlMessage(0);
            addError(error);
            return null;
        }
    }

    /*
     * @Method Name                    :  addError
     * @Description                    :  Method for adding apex error
     * @Return Type                    :  void
     * @Parameters                     :  string
     */
    public void addError(string s) {
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, s);
        ApexPages.addMessage(myMsg);
    }


    public PageReference EditRecord() {
        pagereference pageref = new pagereference('/apex/CreateContract?id=' + currentRecordID + '&isEdit=true');
        pageref.setredirect(true);
        return pageref;
    }

    }