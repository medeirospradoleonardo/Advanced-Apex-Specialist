/**
 * @name orderTrigger
 * @description
**/
trigger orderTrigger on Order (after update) {
   
    if(Trigger.new == null) {
        return;
    }   
        
    OrderHelper.AfterUpdate(Trigger.new, Trigger.oldMap);
}