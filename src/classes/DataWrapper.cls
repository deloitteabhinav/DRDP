/**
 * class DataWrapper
 * @description: used to wrap tasks and links
 */
public class DataWrapper{
    List<TaskWrapper> data;
    List<Link> links;
    List<Option> users;
    
    public DataWrapper(List<TaskWrapper> data, List<Link> links, List<Option> users){
        this.data  = data;
        this.links = links;
        this.users = users;
    }
}