public class LocalDeploymentTest {
    
    public static String getMessage() {
        return 'Local deployment successful at: ' + System.now().format();
    }
    
    public static Boolean isDeploymentWorking() {
        return true;
    }
} 