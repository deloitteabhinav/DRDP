/**
 * Class GanttChartDev
 * Author Victor Fuentes Sangabriel <vfuentessangabrie@deloitte.com> 
 */
public class GanttChartDev {
    private static String SUBQUERY = '(SELECT Id, Name, planned_start_date__c, planned_end_date__c, Parent_Activity__c, Parent_Project__c, Sequence__c, Activity_Owner__c, Previous_Proj_Activity__c, Next_Proj_Activity__c, Type__c FROM Proj_Activities__r ORDER BY Sequence__c ASC)';
    private static String PROJECT_QUERY = 'SELECT Id, name, Description__c, Anticipated_start_date__c, Anticipated_end_date__c, '+SUBQUERY+' FROM DRDW_Project__c WHERE Id =:projectId';
    private static String SUBTASK_QUERY = 'SELECT Id, Name, planned_start_date__c, planned_end_date__c, Parent_Activity__c, Parent_Project__c, Sequence__c, Activity_Owner__c, Previous_Proj_Activity__c, Next_Proj_Activity__c, Type__c FROM DRDW_Proj_Activity__c WHERE Parent_Activity__c IN: ids ORDER BY Sequence__c ASC';
    
    /***********************************************************************************************
                                         REMOTE ACTIONS
     **********************************************************************************************/
    /**
     * @name: getProjectInfo
     * @description: Get project, tasks, links, and owner picklistvalues
     */
    @RemoteAction
    public static DataWrapper getProjectInfo(Id projectId) {
        try{
            List<TaskWrapper> tasks = createTaskWrappers(Database.query(PROJECT_QUERY));
			List<Link> links = createLinks(tasks);
            List<Option> users = getUsers();
            return new DataWrapper(tasks, links, users);
        }catch(Exception  e){
            System.debug(e.getMessage() + 'line: ' +e.getLineNumber());
            return new DataWrapper(null, null, null);
        }
    }
    /**
     * @name upsertTaskWrapper
     */
    @RemoteAction
    public static TaskWrapper upsertTask(TaskWrapper t){
        try{
            DRDW_Proj_Activity__c task = t.unwrap();
            upsert task;
            System.debug('upserted task = ' + task);
            return new TaskWrapper(task);
        }catch(Exception e){
            System.debug(e.getMessage() + 'line: ' +e.getLineNumber());
            return null;
        }
    }
    /**
     * @name deleteTask
     */
    @RemoteAction
    public static void deleteTask(List<Id> listOfTasksToDel){
        try{
            System.debug('listOfTasksToDel ' + listOfTasksToDel);
            delete [SELECT Id FROM DRDW_Proj_Activity__c WHERE Id IN: listOfTasksToDel];
        }catch(Exception e){
            System.debug(e.getMessage() + 'line: ' +e.getLineNumber());
        }
    }
    /***********************************************************************************************
     *                                      HELPER METHODS
     **********************************************************************************************/
    /**
     * @name createTaskWrappers
     */
    private static List<TaskWrapper> createTaskWrappers(DRDW_Project__c proj){
		List<TaskWrapper> tasks = new List<TaskWrapper>();
        
        // add the project which can be represented as a task
        tasks.add(new TaskWrapper(proj));
        
        List<DRDW_Proj_Activity__c> allActiviesAndSubActivies = proj.Proj_Activities__r;
        
        Set<Id> projActIds = (new Map<Id, DRDW_Proj_Activity__c>(allActiviesAndSubActivies)).keySet();

        allActiviesAndSubActivies.addAll( getAllSubtasks(projActIds) );

        tasks.addAll(createTaskWrappersHelper(allActiviesAndSubActivies));
        return tasks;
    }
    /**
     * @name createTaskWrappers
     */
    private static List<TaskWrapper> createTaskWrappersHelper(List<DRDW_Proj_Activity__c> actList){
        List<TaskWrapper> tasks = new List<TaskWrapper>();

        // wrap up all project activities & subactivities as tasks
        for(DRDW_Proj_Activity__c act : actList){
            tasks.add(new TaskWrapper(act));
        }
        return tasks;
    }
    /**
     * @name getAllSubtasks
     */
    private static List<DRDW_Proj_Activity__c> getAllSubtasks(Set<Id> ids){
        if(ids.size() == 0) return new List<DRDW_Proj_Activity__c>();
        List<DRDW_Proj_Activity__c> subTasks = Database.query(SUBTASK_QUERY);
        subTasks.addAll(getAllSubtasks((new Map<Id, DRDW_Proj_Activity__c>(subTasks)).keySet()));
        return subTasks;
    }
    /**
     * @name createLinks
     */
    private static List<Link> createLinks(List<TaskWrapper> tasks){
        List<Link> links = new List<Link>();

        for( Integer i=1; i < tasks.size(); i++){
        	links.add(new Link(tasks[i]));
        }
        
        return links;
    }
    /**
     * @name getUsers
     */
    private static List<Option> getUsers(){
        List<Option> allUsers = new List<Option>();
        for(User user : [SELECT Id, Name FROM User WHERE IsActive=true ORDER BY Name]){
        	allUsers.add(new Option(user.Id, user.Name));
        }
        System.debug('All users = ' + allUsers);
        return allUsers;
    }
}