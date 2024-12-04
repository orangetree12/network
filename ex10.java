import java.util.Scanner;

public class ex10 {
    // Method to perform XOR operation
    public static String xor(String a, String b) {
        StringBuilder result = new StringBuilder();
        for (int i = 1; i < b.length(); i++) {
            result.append(a.charAt(i) == b.charAt(i) ? '0' : '1');
        }
        return result.toString();
    }

    // Method to perform the CRC division algorithm
    public static String divide(String dividend, String divisor) {
        int pick = divisor.length();
        String tmp = dividend.substring(0, pick);

        while (pick < dividend.length()) {
            if (tmp.charAt(0) == '1') {
                tmp = xor(divisor, tmp) + dividend.charAt(pick);
            } else {
                tmp = xor("0".repeat(pick), tmp) + dividend.charAt(pick);
            }
            pick += 1;
        }

        if (tmp.charAt(0) == '1') {
            tmp = xor(divisor, tmp);
        } else {
            tmp = xor("0".repeat(pick), tmp);
        }

        return tmp;
    }

    // Method to encode data using CRC
    public static String encodeData(String data, String generator) {
        int generatorLength = generator.length();
        String appendedData = data + "0".repeat(generatorLength - 1);
        String remainder = divide(appendedData, generator);
        return data + remainder;
    }

    // Method to check if received data is error-free
    public static boolean checkData(String receivedData, String generator) {
        String remainder = divide(receivedData, generator);
        return !remainder.contains("1");
    }

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        System.out.print("Enter binary data: ");
        String data = scanner.next();

        System.out.print("Enter generator polynomial: ");
        String generator = scanner.next();

        // Encode data using CRC
        String encodedData = encodeData(data, generator);
        System.out.println("Encoded data (data + CRC): " + encodedData);

        // Verify the received data
        System.out.print("Enter received data to check: ");
        String receivedData = scanner.next();

        boolean isValid = checkData(receivedData, generator);
        if (isValid) {
            System.out.println("No error detected in received data.");
        } else {
            System.out.println("Error detected in received data.");
        }

        scanner.close();
    }
}

