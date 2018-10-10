/**
 * Class GanntChartTest
 * Author Victor Fuentes Sangabriel <vfuentessangabrie@deloitte.com> 
 */
public class GanttChartTest {
    @RemoteAction
    public static List<ProjectWrapper> getProjectInfo(Id projectId) {
        DRDW_Project__c proj = [SELECT Id, Name, Description__c FROM DRDW_Project__c WHERE Id=:projectId];
        List<ProjectWrapper> projects = new List<ProjectWrapper>();
        projects.add(new ProjectWrapper(proj));
        return projects;
    }
    
    private class ProjectWrapper{
        public Integer id;
        public String text;
        public String start_date;
        public Integer duration;
        public Integer order;
        public Double progress;
        public Boolean open;
        
        public ProjectWrapper(DRDW_Project__c proj){
            this.id = 1;//proj.id;
            this.text = proj.Name;
            this.start_date = '01-04-2018';
            this.duration = 18;
            this.order = 10;
            this.progress = 0.4;
            this.open = true;
        }
    }
}