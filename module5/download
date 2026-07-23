using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace EFCore_RetailInventory
{
    public class Category
    {
        public int Id { get; set; }
        public string Name { get; set; } = string.Empty;
        public List<Product> Products { get; set; } = new List<Product>();
    }

    public class Product
    {
        public int Id { get; set; }
        public string Name { get; set; } = string.Empty;
        public decimal Price { get; set; }
        public int CategoryId { get; set; }
        public Category? Category { get; set; }
        public int StockQuantity { get; set; }

        // Navigation for One-to-One
        public ProductDetail? ProductDetail { get; set; }

        // Navigation for Many-to-Many
        public List<Tag> Tags { get; set; } = new List<Tag>();

        // RowVersion for Concurrency Handling
        [Timestamp]
        public byte[]? RowVersion { get; set; }
    }

    public class ProductDetail
    {
        public int ProductDetailId { get; set; }
        public string WarrantyInfo { get; set; } = string.Empty;
        public int ProductId { get; set; }
        public Product? Product { get; set; }
    }

    public class Tag
    {
        public int Id { get; set; }
        public string Name { get; set; } = string.Empty;
        public List<Product> Products { get; set; } = new List<Product>();
    }

    public class ProductDTO
    {
        public string Name { get; set; } = string.Empty;
        public string CategoryName { get; set; } = string.Empty;
        public decimal Price { get; set; }
    }
}
