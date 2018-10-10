trigger setCheckboxOnProject on Attachment (before insert, after insert,before update, after update,before delete, after delete) {
    if (Trigger.isBefore) {
    if (Trigger.isInsert) {
      // Call class logic here!
    } 
    if (Trigger.isUpdate) {
      // Call class logic here!
    }
    if (Trigger.isDelete) {
      // Call class logic here!
    }
  }

  if (Trigger.IsAfter) {
    if (Trigger.isInsert) {
      // Call class logic here!
      attachmentTriggerHelper.setCheckBoxOnProject(Trigger.new);
    } 
    if (Trigger.isUpdate) {
      // Call class logic here!
    }
    if (Trigger.isDelete) {
      // Call class logic here!
       attachmentTriggerHelper.unSetCheckBoxOnProject(Trigger.old);
    }
  }    
}