/**
 * @description Handler class for Property__c triggers
 * @author Salesforce Dev Workflow
 * @date 2025
 */
public with sharing class PropertyTriggerHandler {
    
    /**
     * @description Handles after insert operations
     * @param newProperties List of newly inserted properties
     */
    public static void handleAfterInsert(List<Property__c> newProperties) {
        calculateCommissions(newProperties);
        sendNotificationToAgents(newProperties);
    }
    
    /**
     * @description Handles after update operations
     * @param newProperties List of updated properties
     * @param oldPropertiesMap Map of old property values
     */
    public static void handleAfterUpdate(List<Property__c> newProperties, Map<Id, Property__c> oldPropertiesMap) {
        List<Property__c> statusChangedProperties = new List<Property__c>();
        
        for (Property__c prop : newProperties) {
            Property__c oldProp = oldPropertiesMap.get(prop.Id);
            if (prop.Status__c != oldProp.Status__c) {
                statusChangedProperties.add(prop);
            }
        }
        
        if (!statusChangedProperties.isEmpty()) {
            calculateCommissions(statusChangedProperties);
            handleStatusChanges(statusChangedProperties, oldPropertiesMap);
        }
    }
    
    /**
     * @description Calculates commission based on property price and status
     * @param properties List of properties to calculate commission for
     */
    private static void calculateCommissions(List<Property__c> properties) {
        List<Property__c> propertiesToUpdate = new List<Property__c>();
        
        for (Property__c prop : properties) {
            if (prop.Price__c != null && prop.Status__c == 'Sold') {
                Decimal commissionRate = 0.06; // 6% commission
                Decimal commission = prop.Price__c * commissionRate;
                
                Property__c propToUpdate = new Property__c(
                    Id = prop.Id
                );
                propertiesToUpdate.add(propToUpdate);
            }
        }
        
        if (!propertiesToUpdate.isEmpty()) {
            try {
                update propertiesToUpdate;
            } catch (DmlException e) {
                System.debug('Error updating property commissions: ' + e.getMessage());
            }
        }
    }
    
    /**
     * @description Sends notifications to listing agents when properties are created
     * @param properties List of new properties
     */
    private static void sendNotificationToAgents(List<Property__c> properties) {
        for (Property__c prop : properties) {
            if (prop.Listing_Agent__c != null) {
                System.debug('New property listed: ' + prop.Name + ' by agent: ' + prop.Listing_Agent__c);
            }
        }
    }
    
    /**
     * @description Handles property status changes
     * @param properties List of properties with status changes
     * @param oldPropertiesMap Map of old property values
     */
    private static void handleStatusChanges(List<Property__c> properties, Map<Id, Property__c> oldPropertiesMap) {
        for (Property__c prop : properties) {
            Property__c oldProp = oldPropertiesMap.get(prop.Id);
            
            if (prop.Status__c == 'Sold' && oldProp.Status__c != 'Sold') {
                System.debug('Property sold: ' + prop.Name);
            } else if (prop.Status__c == 'Under Contract' && oldProp.Status__c == 'Available') {
                System.debug('Property under contract: ' + prop.Name);
            }
        }
    }
} 