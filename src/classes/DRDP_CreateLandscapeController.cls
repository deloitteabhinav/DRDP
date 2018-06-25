/******************************************************************************************************************************************
 * Class Name   : DRDP_CreateLandscapeController
 * Description  : controller class for DRDP_CreateLandscape page
 * Created By   : Deloitte Consulting
 *
 *****************************************************************************************************************************************/
Public with sharing class DRDP_CreateLandscapeController {
    public Information_Landscape__c oLandscape {get; set;}
    public id currentRecordID;
    public id loggedInUserId;
    public boolean showEdit{get; set;}
    public list < Attachment > lAttachments1 {get; set;}
      public Transient Blob attachmentBody1 {
        get;
        set;
    }
    public String attachmentName1 {
        get;
        set;
    }
    public Transient Blob attachmentBody2 {
        get;
        set;
    }
    public String attachmentName2 {
        get;
        set;
    }
    public Transient Blob attachmentBody3 {
        get;
        set;
    }
    public String attachmentName3 {
        get;
        set;
    }
    //Loading the Constructor
    public DRDP_CreateLandscapeController(ApexPages.StandardController controller) {
        loggedInUserId =[select id from Profile where Name = 'Read Only User'].Id;
        if(loggedInUserId == UserInfo.getProfileId())
            showEdit = false;
        else
            showEdit = true;
        currentRecordID = ApexPages.currentPage().getParameters().get('id');
        if (currentRecordID != Null) {

            String SobjectApiName = 'Information_Landscape__c';
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
            oLandscape = Database.query(query);
            
            lAttachments1 = new list < Attachment > ();
            lAttachments1 = [select id, name, body from attachment where parentID =: oLandscape.Id];
        }

        else {
            oLandscape = new Information_Landscape__c();
        }
    }

    /*
     * @Method Name                    :  save
     * @Description                    :  Method to Save the LandscapeRecord record
     * @Return Type                    :  PageReference
     * @Parameters                     :  None
     */
    public PageReference save() {
    insertAttachments();
        
        pagereference pageref;
        try {
            upsert oLandscape oLandscape.Id;
            pageref = new pagereference('/apex/DRDP_CreateLandscape?id=' + oLandscape.id  + '&isEdit=false');
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
        pagereference pageref = new pagereference('/apex/DRDP_CreateLandscape?id=' + currentRecordID + '&isEdit=true');
        pageref.setredirect(true);
        return pageref;
    }
     public void insertAttachments() {
        list < Attachment > lAttachments = new list < Attachment > ();
        if (attachmentBody1 != null && attachmentName1 != NULL) {
            lAttachments.add(new attachment(name = attachmentName1, body = attachmentBody1, parentID = oLandscape.id));
        }
        if (attachmentBody2 != null && attachmentName2 != NULL) {
            lAttachments.add(new attachment(name = attachmentName2, body = attachmentBody2, parentID = oLandscape.id));
        }
        if (attachmentBody3 != null && attachmentName3 != NULL) {
            lAttachments.add(new attachment(name = attachmentName3, body = attachmentBody3, parentID = oLandscape.id));
        }
        if (lAttachments.size() > 0) {
            database.insert(lAttachments, false);
        }

    }
    }