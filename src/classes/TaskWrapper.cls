/*
 * @author Victor Fuentes Sangabriel <vfuentessangabrie@deloitte.com>
 * class TaskWrapper
 * @description: used to wrap DRDW_Project & DRDW_Proj_Activity objects
 */
public class TaskWrapper{
    public Id id;
    public Id parent;
    public Id parentActivity;
    public Id owner;
    public String text;
    public String start_date;
    public String end_date;
    public Boolean open;
    public Decimal index;

    public TaskWrapper(DRDW_Project__c proj){
        this.id                = proj.id;
        this.text = proj.Name != null ? proj.Name : 'Unnamed task';
        this.start_date        = proj.Anticipated_Start_Date__c != null ? proj.Anticipated_Start_Date__c.format() : '';
        this.end_date          = proj.Anticipated_End_Date__c != null ? proj.Anticipated_End_Date__c.format() : '';
        this.open              = true; // have the project tab open on page load
    }
    
    /**
     * Specific fields for wrapping Project Activities
     */
    public TaskWrapper(DRDW_Proj_Activity__c proj){
        this.id         = proj.id;
        this.text       = proj.Name != null ? proj.Name : 'Unnamed task';
        this.start_date = proj.planned_start_date__c != null ? proj.planned_start_date__c.format() : '';
        this.end_date   = proj.planned_end_date__c != null ? proj.planned_end_date__c.format() : '';
        
        // Since dhtml API only supports tasks having a parent assign subtask their
        // parent task as the parent even tho in the backend the parent would be the project 
        this.parent     = proj.Parent_Activity__c != null ? proj.Parent_Activity__c : proj.Parent_Project__c;
        
        this.index 		= proj.Sequence__c;
        this.owner      = proj.Activity_Owner__c;
        this.open       = false;
    }
    
    public DRDW_Proj_Activity__c unwrap(){
        DRDW_Proj_Activity__c task = new DRDW_Proj_Activity__c();
        task.id   = this.id;
        task.name = this.text;
        task.Planned_Start_Date__c = Date.parse(this.start_date);
        task.Planned_End_Date__c   = Date.parse(this.end_date);
        task.Parent_Project__c 	   = this.parent;
        task.Parent_Activity__c    = this.parentActivity;
        task.Sequence__c           = this.index;
        task.Activity_Owner__c     = this.owner;
        return task;
    }
}