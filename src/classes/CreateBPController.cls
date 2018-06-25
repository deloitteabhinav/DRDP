/******************************************************************************************************************************************
 * Class Name   : CreateBPController
 * Description  : controller class for CreateBP page
 * Created By   : Deloitte Consulting
 *
 *****************************************************************************************************************************************/
Public with sharing class CreateBPController {
    public Business_Planning__c oBP {get; set;}
    public BP_Molecule__c oBPMolecule {get; set;}
    Public BP_Proposed_TPO__c oBPTPO {get;set;}
    public RWE_BP_Benefitting_Region__c oBPBenefitingCountry {get; set;}
    public list<BP_Molecule__c> lBPMolecules {get; set;}
    Public list<BP_Proposed_TPO__c> lBPTPOs {get;set;}
    public list<RWE_BP_Benefitting_Region__c> lBPBenefitingCountries {get; set;}
    public BPRelated_Data_Asset__c oRelatedDataAsset {get; set;}
    public list < BPRelated_Data_Asset__c > lRelatedDataAsset {get; set;}
    public boolean isError {get; set;}
    public boolean isMoleculeError {get; set;}
    Public boolean isProposedTPO {get;set;}
    public boolean isBPBnftCError {get; set;}
    public boolean isRelatedDataAssetError {get; set;}

    public id genericID {get; set;}
    public id currentRecordID;
    public string currentBPType {get; set;}

    //Loading the Constructor
    public CreateBPController(ApexPages.StandardController controller) {
        currentBPType = ApexPages.currentPage().getParameters().get('BPType');
        currentRecordID = ApexPages.currentPage().getParameters().get('id');

        isMoleculeError = false;
        isProposedTPO = false;
        isBPBnftCError = false;
        isRelatedDataAssetError = false;

        if (currentRecordID != Null) {
            //Querying Molecules, Benifiting countries and BP Conducting countries for the current BP
            oBPMolecule = new BP_Molecule__c();
            oBPTPO = new BP_Proposed_TPO__c();
            oBPBenefitingCountry = new RWE_BP_Benefitting_Region__c();
            oRelatedDataAsset = new BPRelated_Data_Asset__c();
            lBPMolecules = new list <BP_Molecule__c> ();
            lBPTPOs = new list<BP_Proposed_TPO__c>();
            lBPBenefitingCountries = new list <RWE_BP_Benefitting_Region__c> ();
            lRelatedDataAsset = new list < BPRelated_Data_Asset__c > ();

            lBPBenefitingCountries = [select id, RWE_Country__c, RWE_Country__r.Name, RWE_Business_Planning__r.name from RWE_BP_Benefitting_Region__c Where RWE_Business_Planning__c = : currentRecordID];
            lBPMolecules = [select id, RWE_Molecule__c, RWE_Molecule__r.name, RWE_Business_Planning__r.name from BP_Molecule__c Where RWE_Business_Planning__c = : currentRecordID];
            lBPTPOs = [select id, RWE_TPO_Location__c, RWE_TPO_Location__r.name, RWE_Business_Planning__r.name from BP_Proposed_TPO__c Where RWE_Business_Planning__c = : currentRecordID];
            lRelatedDataAsset = [select id, RWD_Data_Asset__c, RWD_Data_Asset__r.name from BPRelated_Data_Asset__c Where RWE_Business_Planning__c = : currentRecordID];

            String SobjectApiName = 'Business_Planning__c';
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
            oBP = Database.query(query);
            if (oBP.BPType__c == 'Research Project') {
                currentBPType = 'Research_BP';
            } else if (oBP.BPType__c == 'Non-Research Project') {
                currentBPType = 'Non_Research_BP';
            } else {
                currentBPType = 'Study_BP';
            }

        }

        else {
            oBP = new Business_Planning__c();
            if (currentBPType == 'Research_BP') {
                oBP.BPType__c = 'Research Project';
            } else if (currentBPType == 'Non_Research_BP') {
                oBP.BPType__c = 'Non-Research Project';
            } else {
                oBP.BPType__c = 'Study';
            }
        }
    }

    /*
     * @Method Name                    :  save
     * @Description                    :  Method to Save the Business Plan record
     * @Return Type                    :  PageReference
     * @Parameters                     :  None
     */
    public PageReference save() {

        list<BPRelated_Data_Asset__c > lBPRelatedDataAssets = new list<BPRelated_Data_Asset__c >();
        lBPRelatedDataAssets = [select id from BPRelated_Data_Asset__c Where RWE_Business_Planning__c = :currentRecordID];
           If(oBP.Is_the_Data_Asset_Known__c == 'Yes' && lBPRelatedDataAssets.size() == 0 ) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please add Related Data Assets to your Business Planning.');
                ApexPages.addMessage(myMsg);
                isError = TRUE;
                return null;
            }
                
        pagereference pageref;
        try {
            if (oBP.BPType__c == 'Research Project') {
                currentBPType = 'Research_BP';
            } else if (oBP.BPType__c == 'Non-Research Project') {
                currentBPType = 'Non_Research_BP';
            } else {
                currentBPType = 'Study_BP';
            }
            upsert oBP oBP.id;


            if (currentRecordID == NULL) {
                pageref = new pagereference('/apex/CreateBP?id=' + oBP.id + '&BPType=' + currentBPType + '&isEdit=true&AutoDistribute=true');

            } else {
                pageref = new pagereference('/apex/CreateBP?id=' + oBP.id + '&BPType=' + currentBPType + '&isEdit=false');
            }

            /*Creating Estimates when the BP is created for the First Time
            If(ApexPages.currentPage().getParameters().get('AutoDistribute') == 'true') {
                BPAutoDistribute.PassBusinessEstimates(oBp);
            }*/
            pageref.setredirect(true);
        } catch (exception e) {
            String error = e.getdmlMessage(0);
            addError(error);
            isError = TRUE;
            return null;
        }
        return pageref;
    }


    /*
        * @Method Name                    :  AddMolecule
        * @Description                    :  Method to add a new BP Molecule
        * @Return Type                    :  void
        * @Parameters                     :  None
        */
    Public void AddMolecule() {
        if (currentRecordID != NULL) {
            try {
                oBPMolecule.RWE_Business_Planning__c = currentRecordID;
                insert oBPMolecule;
                lBPMolecules = [select id, RWE_Molecule__c, RWE_Molecule__r.name from BP_Molecule__c Where RWE_Business_Planning__c = : currentRecordID];
                oBPMolecule = new BP_Molecule__c();
            } catch (exception e) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'There was an error adding Molecule. Please contact your Administrator');
                ApexPages.addMessage(myMsg);
                isMoleculeError = true;
            }
        }
    }
   
    /*
     * @Method Name                    :  RemoveMolecule
     * @Description                    :  Method to remove a BP Molecule
     * @Return Type                    :  void
     * @Parameters                     :  None
     */

    Public void RemoveMolecule() {
        try {
            lBPMolecules = [select id, RWE_Molecule__c, RWE_Molecule__r.name from BP_Molecule__c Where RWE_Business_Planning__c = : currentRecordID];
            BP_Molecule__c oMol = [Select id from BP_Molecule__c where RWE_Business_Planning__c = : currentRecordID AND RWE_Molecule__c = : genericID];
            delete oMol;
            lBPMolecules = [select id, RWE_Molecule__c, RWE_Molecule__r.name from BP_Molecule__c Where RWE_Business_Planning__c = : currentRecordID];
        } catch (exception e) {
            addError(e.getmessage());
            isMoleculeError = true;
        }

    }

     /*
        * @Method Name                    :  AddTPO
        * @Description                    :  Method to add a new TPO Location
        * @Return Type                    :  void
        * @Parameters                     :  None
        */
    Public void AddTPO() {
        if (currentRecordID != NULL) {
            try {
                oBPTPO.RWE_Business_Planning__c = currentRecordID;
                insert oBPTPO;
                lBPTPOs = [select id, RWE_TPO_Location__c, RWE_TPO_Location__r.name from BP_Proposed_TPO__c Where RWE_Business_Planning__c = : currentRecordID];
                oBPTPO = new BP_Proposed_TPO__c();
            } catch (exception e) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'There was an error adding TPO. Please contact your Administrator');
                ApexPages.addMessage(myMsg);
                isProposedTPO = true;
            }
        }
    }
    /*
     * @Method Name                    :  RemoveBPTPO
     * @Description                    :  Method to remove a TPO Location
     * @Return Type                    :  void
     * @Parameters                     :  None
     */

    Public void RemoveBPTPO() {
        try {
            lBPTPOs = [select id, RWE_TPO_Location__c, RWE_TPO_Location__r.name from BP_Proposed_TPO__c Where RWE_Business_Planning__c = : currentRecordID];
            BP_Proposed_TPO__c oBPProTPO = [Select id from BP_Proposed_TPO__c where RWE_Business_Planning__c = : currentRecordID AND RWE_TPO_Location__c = : genericID];
            delete oBPProTPO;
            lBPTPOs = [select id, RWE_TPO_Location__c, RWE_TPO_Location__r.name from BP_Proposed_TPO__c Where RWE_Business_Planning__c = : currentRecordID];
        } catch (exception e) {
            addError(e.getmessage());
            isProposedTPO = true;
        }

    }
    
    /*
    * @Method Name                    :  AddBPBenefitingCountry
    * @Description                    :  Method to add a new Benefiting Country to a BP
    * @Return Type                    :  void
    * @Parameters                     :  None
    */
    Public void AddBPBenefitingCountry() {
        if (currentRecordID != NULL) {
            try {
                oBPBenefitingCountry.RWE_Business_Planning__c = currentRecordID;
                insert oBPBenefitingCountry;
                lBPBenefitingCountries = [select id, RWE_Country__c, RWE_Country__r.name from RWE_BP_Benefitting_Region__c Where RWE_Business_Planning__c = : currentRecordID];
                oBPBenefitingCountry = new RWE_BP_Benefitting_Region__c();
            } catch (exception e) {    
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'There was an error adding country. Please contact your Administrator');
                ApexPages.addMessage(myMsg);
                isBPBnftCError = true;
            }
        }
    }
    /*
     * @Method Name                    :  RemoveBPBenefitingCountry
     * @Description                    :  Method to remove a BP Benefiting Country
     * @Return Type                    :  void
     * @Parameters                     :  None
     */

    Public void RemoveBPBenefitingCountry() {
        try {
            lBPBenefitingCountries = [select id, RWE_Country__c, RWE_Country__r.name from RWE_BP_Benefitting_Region__c Where RWE_Business_Planning__c = : currentRecordID];
            RWE_BP_Benefitting_Region__c oBPBnftC = [Select id from RWE_BP_Benefitting_Region__c where RWE_Business_Planning__c = : currentRecordID AND RWE_Country__c = : genericID];
            delete oBPBnftC;
            lBPBenefitingCountries = [select id, RWE_Country__c, RWE_Country__r.name from RWE_BP_Benefitting_Region__c Where RWE_Business_Planning__c = : currentRecordID];
        } catch (exception e) {
            addError(e.getmessage());
            isBPBnftCError = true;
        }

    }

    /*
             * @Method Name                    :  AddRelatedDataAsset
             * @Description                    :  Method to add a new BP Related Data Asset
             * @Return Type                    :  void
             * @Parameters                     :  None
             */
    Public void AddRelatedDataAsset() {
        if (currentRecordID != NULL) {
            try {
                oRelatedDataAsset.RWE_Business_Planning__c = currentRecordID;
                insert oRelatedDataAsset;
                lRelatedDataAsset = [select id, RWD_Data_Asset__c, RWD_Data_Asset__r.name from BPRelated_Data_Asset__c Where RWE_Business_Planning__c = : currentRecordID];
                oRelatedDataAsset = new BPRelated_Data_Asset__c();
            } catch (exception e) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'There was an error adding Data Asset. Please Contact your Administrator ');
                ApexPages.addMessage(myMsg);
                isRelatedDataAssetError = true;
            }
        }
    }
    /*
     * @Method Name                    :  RemoveRelatedDataAsset
     * @Description                    :  Method to remove a BP Related Data Asset
     * @Return Type                    :  void
     * @Parameters                     :  None
     */

    Public void RemoveRelatedDataAsset() {
        try {

            lRelatedDataAsset = [select id, RWD_Data_Asset__c, RWD_Data_Asset__r.name from BPRelated_Data_Asset__c Where RWE_Business_Planning__c = : currentRecordID];

            BPRelated_Data_Asset__c oRelDataAsset = [Select id from BPRelated_Data_Asset__c where RWE_Business_Planning__c = : currentRecordID AND RWD_Data_Asset__c = : genericID];
            delete oRelDataAsset;

            lRelatedDataAsset = [select id, RWD_Data_Asset__c, RWD_Data_Asset__r.name from BPRelated_Data_Asset__c Where RWE_Business_Planning__c = : currentRecordID];

        } catch (exception e) {
            addError(e.getmessage());
            isRelatedDataAssetError = true;
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


    /*
     * @Method Name                    :  ResetGPORWE
     * @Description                    :  Method for Resetting GPORWE_Functional_Area__c field
     * @Return Type                    :  void
     * @Parameters                     :  none
     */
    public void ResetGPORWE() {
        oBP.GPORWE_Functional_Area__c = NULL;
    }

    /*
     * @Method Name                    :  EditRecord
     * @Description                    :  Method for editing and existing BP record
     * @Return Type                    :  PageReference
     * @Parameters                     :  None
     */
    public PageReference EditRecord() {
        pagereference pageref = new pagereference('/apex/CreateBP?id=' + currentRecordID + '&BPType=' + currentBPType + '&isEdit=true');
        pageref.setredirect(true);
        return pageref;
    }


}