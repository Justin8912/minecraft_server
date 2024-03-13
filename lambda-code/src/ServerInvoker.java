public class ServerInvoker {
    public static void main (String[] args) {
        // Should probably initialize whatever variables I need to access the ec2 instance
        System.out.println("Hello world");
    }

    public void handleRequest(String request) {
        System.out.println("Hello World!");
        // Based on the request string, I would like to either:
            // Get the status of the server
            // Start the server
            // Stop the server

    }
}
