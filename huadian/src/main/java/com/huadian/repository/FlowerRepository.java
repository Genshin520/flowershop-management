package com.huadian.repository;

import com.huadian.entity.Flower;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface FlowerRepository extends JpaRepository<Flower, Long> {
    
    List<Flower> findByCategory(String category);
    
    List<Flower> findByNameContainingIgnoreCase(String name);
    
    @Query("SELECT f FROM Flower f WHERE f.stock > 0")
    List<Flower> findAvailableFlowers();
    
    @Query("SELECT f FROM Flower f WHERE f.price BETWEEN :minPrice AND :maxPrice")
    List<Flower> findByPriceRange(@Param("minPrice") Double minPrice, @Param("maxPrice") Double maxPrice);
    
    @Query("SELECT DISTINCT f.category FROM Flower f")
    List<String> findAllCategories();

    List<Flower> findByCategoryId(Long categoryId);
} 