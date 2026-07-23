using System;
using Microsoft.EntityFrameworkCore;

namespace EFCore_RetailInventory
{
    public class AppDbContext : DbContext
    {
        public DbSet<Product> Products { get; set; } = null!;
        public DbSet<Category> Categories { get; set; } = null!;
        public DbSet<ProductDetail> ProductDetails { get; set; } = null!;
        public DbSet<Tag> Tags { get; set; } = null!;

        public AppDbContext()
        {
        }

        public AppDbContext(DbContextOptions<AppDbContext> options)
            : base(options)
        {
        }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (!optionsBuilder.IsConfigured)
            {
                // Use InMemory database for portable, self-contained hands-on execution
                optionsBuilder.UseInMemoryDatabase("RetailInventoryDb");
            }
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            // Configure One-to-One relationship between Product and ProductDetail
            modelBuilder.Entity<Product>()
                .HasOne(p => p.ProductDetail)
                .WithOne(pd => pd.Product)
                .HasForeignKey<ProductDetail>(pd => pd.ProductId);

            // Configure Many-to-Many relationship automatically handled in EF Core 8
            modelBuilder.Entity<Product>()
                .HasMany(p => p.Tags)
                .WithMany(t => t.Products);

            // Data Seeding via HasData
            modelBuilder.Entity<Category>().HasData(
                new Category { Id = 1, Name = "Electronics" },
                new Category { Id = 2, Name = "Groceries" }
            );

            modelBuilder.Entity<Product>().HasData(
                new Product { Id = 1, Name = "Smartphone", Price = 25000, CategoryId = 1, StockQuantity = 50 },
                new Product { Id = 2, Name = "Wheat Flour", Price = 800, CategoryId = 2, StockQuantity = 100 }
            );
        }
    }
}
