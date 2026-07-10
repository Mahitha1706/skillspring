import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

public class Main {

    public static void main(String[] args) {

        Scanner sc = new Scanner(System.in);

        List<Product> products = new ArrayList<>();

        products.add(new Product(1, "iPhone 15", 79999));
        products.add(new Product(2, "Samsung Galaxy S24", 74999));
        products.add(new Product(3, "Apple Watch", 39999));
        products.add(new Product(4, "Boat Earbuds", 1999));
        products.add(new Product(5, "Apple Headphones", 2999));

        System.out.print("Enter product name: ");
        String keyword = sc.nextLine();

        List<Product> result =
                SearchService.searchProducts(products, keyword);

        if(result.isEmpty()) {
            System.out.println("No products found");
        } else {
            System.out.println("Products found:");

            for(Product p : result) {
                System.out.println(p);
            }
        }

        sc.close();
    }
}