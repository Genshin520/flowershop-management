package com.huadian.service;

import com.huadian.entity.Category;
import com.huadian.entity.Flower;
import com.huadian.repository.CategoryRepository;
import com.huadian.repository.FlowerRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class FlowerService {
    
    @Autowired
    private FlowerRepository flowerRepository;
    
    @Autowired
    private CategoryRepository categoryRepository;
    
    public List<Flower> getAllFlowers() {
        return flowerRepository.findAll();
    }
    
    public Optional<Flower> getFlowerById(Long id) {
        return flowerRepository.findById(id);
    }
    
    public Flower saveFlower(Flower flower) {
        return flowerRepository.save(flower);
    }
    
    public void deleteFlower(Long id) {
        flowerRepository.deleteById(id);
    }
    
    public List<Flower> getFlowersByCategory(String category) {
        return flowerRepository.findByCategory(category);
    }
    
    public List<Flower> searchFlowersByName(String name) {
        return flowerRepository.findByNameContainingIgnoreCase(name);
    }
    
    public List<Flower> getAvailableFlowers() {
        return flowerRepository.findAvailableFlowers();
    }
    
    public List<Flower> getFlowersByPriceRange(Double minPrice, Double maxPrice) {
        return flowerRepository.findByPriceRange(minPrice, maxPrice);
    }
    
    public List<String> getAllCategories() {
        return flowerRepository.findAllCategories();
    }
    
    public boolean updateStock(Long flowerId, Integer quantity) {
        Optional<Flower> flowerOpt = flowerRepository.findById(flowerId);
        if (flowerOpt.isPresent()) {
            Flower flower = flowerOpt.get();
            if (flower.getStock() >= quantity) {
                flower.setStock(flower.getStock() - quantity);
                flowerRepository.save(flower);
                return true;
            }
        }
        return false;
    }
    
    public Flower createFlower(Flower flower) {
        return flowerRepository.save(flower);
    }
    
    public Flower updateFlower(Flower flower) {
        return flowerRepository.save(flower);
    }
    
    public Flower updateFlowerCategory(Long flowerId, Long categoryId) {
        Optional<Flower> flowerOpt = flowerRepository.findById(flowerId);
        if (flowerOpt.isPresent()) {
            Flower flower = flowerOpt.get();
            
            // 如果提供了分类ID，更新分类信息
            if (categoryId != null) {
                Optional<Category> categoryOpt = categoryRepository.findById(categoryId);
                if (categoryOpt.isPresent()) {
                    Category category = categoryOpt.get();
                    flower.setCategoryId(categoryId);
                    flower.setCategory(category.getName());
                }
            } else {
                // 如果分类ID为null，清除分类信息
                flower.setCategoryId(null);
                flower.setCategory(null);
            }
            
            return flowerRepository.save(flower);
        }
        throw new RuntimeException("花卉不存在");
    }
    
    public List<Flower> searchFlowers(String keyword) {
        return flowerRepository.findByNameContainingIgnoreCase(keyword);
    }
    
    public List<Flower> getFlowersByCategoryId(Long categoryId) {
        return flowerRepository.findByCategoryId(categoryId);
    }
} 