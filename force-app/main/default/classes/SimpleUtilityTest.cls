/**
 * @description Test class for SimpleUtility
 * @author Salesforce Dev Workflow  
 * @date 2025
 */
@isTest
public class SimpleUtilityTest {
    
    @isTest
    static void testGetGreeting() {
        // Test with name
        String result1 = SimpleUtility.getGreeting('Kaleem');
        System.assertEquals('Hello, Kaleem!', result1, 'Greeting with name should work');
        
        // Test without name
        String result2 = SimpleUtility.getGreeting('');
        System.assertEquals('Hello, World!', result2, 'Greeting without name should return default');
        
        // Test with null
        String result3 = SimpleUtility.getGreeting(null);
        System.assertEquals('Hello, World!', result3, 'Greeting with null should return default');
    }
    
    @isTest
    static void testCalculatePercentage() {
        // Test normal calculation
        Decimal result1 = SimpleUtility.calculatePercentage(25, 100);
        System.assertEquals(25, result1, 'Percentage calculation should work');
        
        // Test zero total
        Decimal result2 = SimpleUtility.calculatePercentage(10, 0);
        System.assertEquals(0, result2, 'Percentage with zero total should return 0');
        
        // Test null total
        Decimal result3 = SimpleUtility.calculatePercentage(10, null);
        System.assertEquals(0, result3, 'Percentage with null total should return 0');
    }
    
    @isTest
    static void testFormatCurrency() {
        // Test normal amount
        String result1 = SimpleUtility.formatCurrency(123.456);
        System.assertEquals('$123.46', result1, 'Currency formatting should work');
        
        // Test null amount
        String result2 = SimpleUtility.formatCurrency(null);
        System.assertEquals('$0.00', result2, 'Null amount should return $0.00');
        
        // Test zero amount
        String result3 = SimpleUtility.formatCurrency(0);
        System.assertEquals('$0.00', result3, 'Zero amount should return $0.00');
    }
    
    @isTest
    static void testGetCurrentTimestamp() {
        String timestamp = SimpleUtility.getCurrentTimestamp();
        System.assertNotEquals(null, timestamp, 'Timestamp should not be null');
        System.assert(timestamp.length() > 0, 'Timestamp should not be empty');
    }
} 