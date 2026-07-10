import java.util.Scanner;

public class FinancialForecast {

    public static void main(String[] args) {

        Scanner sc = new Scanner(System.in);

        System.out.print("Enter current revenue: ");
        double revenue = sc.nextDouble();

        System.out.print("Enter annual growth rate (%): ");
        double rate = sc.nextDouble();

        System.out.print("Enter forecast years: ");
        int years = sc.nextInt();

        System.out.println("\nFinancial Forecast:");

        for (int i = 1; i <= years; i++) {

            revenue = revenue * (1 + rate / 100);

            System.out.printf(
                "Year %d : %.2f%n",
                i,
                revenue
            );
        }

        sc.close();
    }
}