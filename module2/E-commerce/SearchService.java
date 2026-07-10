import java.util.ArrayList;
import java.util.List;

public class SearchService {

    public static List<Product> searchProducts(
            List<Product> products,
            String keyword) {

        List<Product> result = new ArrayList<>();

        for (Product product : products) {

            if (product.getName()
                    .toLowerCase()
                    .contains(keyword.toLowerCase())) {

                result.add(product);
            }
        }

        return result;
    }
}