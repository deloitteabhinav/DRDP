/*
 * class Link
 * @description: used to wrap TaskWrapper objects
 */
public class Link{
    public Id id;
    public Id source;
    public Id target;
    public String type;
    public Boolean readonly;
    
    public Link(TaskWrapper t){
        this.id = t.id;
        this.source = t.parent;
        this.target = t.id;
        this.type = '1';
        this.readonly = true;
    }
}