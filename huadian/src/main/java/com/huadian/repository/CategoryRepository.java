package com.huadian.repository;

import com.huadian.entity.Category;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface CategoryRepository extends JpaRepository<Category, Long> {
    Category findByName(String name);
    
    @Query("SELECT COUNT(f) FROM Flower f WHERE f.categoryId = :categoryId")
    Long countFlowersByCategoryId(@Param("categoryId") Long categoryId);
} 