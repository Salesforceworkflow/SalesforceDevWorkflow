/**
 * @description Simple utility class for testing CI/CD deployment
 * @author Salesforce Dev Workflow
 * @date 2025
 */
public with sharing class SimpleUtility {
    
    /**
     * @description Returns a greeting message
     * @param name The name to include in greeting
     * @return String greeting message
     */
    public static String getGreeting(String name) {
        if (String.isBlank(name)) {
            return 'Hello, World!';
        }
        return 'Hello, ' + name + '!';
    }
    
    /**
     * @description Calculates percentage
     * @param part The part value
     * @param total The total value
     * @return Decimal percentage value
     */
    public static Decimal calculatePercentage(Decimal part, Decimal total) {
        if (total == null || total == 0) {
            return 0;
        }
        return (part / total) * 100;
    }
    
    /**
     * @description Formats currency amount
     * @param amount The amount to format
     * @return String formatted currency
     */
    public static String formatCurrency(Decimal amount) {
        if (amount == null) {
            return '$0.00';
        }
        return '$' + amount.setScale(2).format();
    }
    
    /**
     * @description Current timestamp
     * @return String current date time
     */
    public static String getCurrentTimestamp() {
        return System.now().format('yyyy-MM-dd HH:mm:ss');
    }
} 