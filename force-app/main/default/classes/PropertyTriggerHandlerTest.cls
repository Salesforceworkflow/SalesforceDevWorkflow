/**
 * @description Test class for PropertyTriggerHandler
 * @author Salesforce Dev Workflow
 * @date 2025
 */
@isTest
public class PropertyTriggerHandlerTest {
    
    @testSetup
    static void setupTestData() {
        // Create test user for listing agent
        User testUser = new User(
            FirstName = 'Test',
            LastName = 'Agent',
            Email = 'testagent@example.com',
            Username = 'testagent@example.com.test',
            Alias = 'tagent',
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1].Id,
            LanguageLocaleKey = 'en_US'
        );
        insert testUser;
    }
    
    @isTest
    static void testPropertyInsert() {
        User testAgent = [SELECT Id FROM User WHERE Email = 'testagent@example.com' LIMIT 1];
        
        Test.startTest();
        
        Property__c testProperty = new Property__c(
            Name = 'Test Property',
            Address__c = '123 Test Street',
            Price__c = 500000,
            Property_Type__c = 'House',
            Status__c = 'Available',
            Bedrooms__c = 3,
            Bathrooms__c = 2,
            Square_Feet__c = 2000,
            Listing_Agent__c = testAgent.Id
        );
        
        insert testProperty;
        
        Test.stopTest();
        
        // Verify the property was created successfully
        Property__c insertedProperty = [SELECT Id, Name, Status__c FROM Property__c WHERE Id = :testProperty.Id];
        System.assertEquals('Available', insertedProperty.Status__c);
        System.assertEquals('Test Property', insertedProperty.Name);
    }
    
    @isTest
    static void testPropertyStatusUpdate() {
        User testAgent = [SELECT Id FROM User WHERE Email = 'testagent@example.com' LIMIT 1];
        
        // Create a property
        Property__c testProperty = new Property__c(
            Name = 'Test Property for Update',
            Address__c = '456 Update Street',
            Price__c = 750000,
            Property_Type__c = 'Condo',
            Status__c = 'Available',
            Bedrooms__c = 2,
            Bathrooms__c = 2,
            Square_Feet__c = 1500,
            Listing_Agent__c = testAgent.Id
        );
        insert testProperty;
        
        Test.startTest();
        
        // Update property status to Sold
        testProperty.Status__c = 'Sold';
        update testProperty;
        
        Test.stopTest();
        
        // Verify the property status was updated
        Property__c updatedProperty = [SELECT Id, Status__c FROM Property__c WHERE Id = :testProperty.Id];
        System.assertEquals('Sold', updatedProperty.Status__c);
    }
    
    @isTest
    static void testMultiplePropertiesInsert() {
        User testAgent = [SELECT Id FROM User WHERE Email = 'testagent@example.com' LIMIT 1];
        
        List<Property__c> testProperties = new List<Property__c>();
        
        for (Integer i = 1; i <= 5; i++) {
            Property__c prop = new Property__c(
                Name = 'Bulk Test Property ' + i,
                Address__c = i + ' Bulk Test Street',
                Price__c = 300000 + (i * 50000),
                Property_Type__c = 'House',
                Status__c = 'Available',
                Bedrooms__c = 2 + i,
                Bathrooms__c = 1 + i,
                Square_Feet__c = 1000 + (i * 200),
                Listing_Agent__c = testAgent.Id
            );
            testProperties.add(prop);
        }
        
        Test.startTest();
        insert testProperties;
        Test.stopTest();
        
        // Verify all properties were created
        List<Property__c> insertedProperties = [SELECT Id, Name FROM Property__c WHERE Name LIKE 'Bulk Test Property%'];
        System.assertEquals(5, insertedProperties.size());
    }
} 