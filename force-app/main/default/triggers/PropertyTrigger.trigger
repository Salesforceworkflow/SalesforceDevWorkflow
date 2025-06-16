/**
 * @description Trigger for Property__c object
 * @author Salesforce Dev Workflow
 * @date 2025
 */
trigger PropertyTrigger on Property__c (after insert, after update) {
    
    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            PropertyTriggerHandler.handleAfterInsert(Trigger.new);
        } else if (Trigger.isUpdate) {
            PropertyTriggerHandler.handleAfterUpdate(Trigger.new, Trigger.oldMap);
        }
    }
} 