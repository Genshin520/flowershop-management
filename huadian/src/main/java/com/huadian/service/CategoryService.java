package com.huadian.service;

import com.huadian.dto.CategoryDTO;
import com.huadian.entity.Category;
import com.huadian.repository.CategoryRepository;
import com.huadian.repository.FlowerRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class CategoryService {
    @Autowired
    private CategoryRepository categoryRepository;
    
    @Autowired
    private FlowerRepository flowerRepository;

    public List<CategoryDTO> getAllCategoriesWithFlowerCount() {
        List<Category> categories = categoryRepository.findAll();
        return categories.stream()
                .map(category -> {
                    Long flowerCount = categoryRepository.countFlowersByCategoryId(category.getId());
                    return new CategoryDTO(
                            category.getId(),
                            category.getName(),
                            category.getDescription(),
                            flowerCount
                    );
                })
                .collect(Collectors.toList());
    }

    public List<Category> getAllCategories() {
        return categoryRepository.findAll();
    }

    public Optional<Category> getCategoryById(Long id) {
        return categoryRepository.findById(id);
    }

    public Category createCategory(Category category) {
        // 检查分类名称是否已存在
        Category existingCategory = categoryRepository.findByName(category.getName());
        if (existingCategory != null) {
            throw new RuntimeException("分类名称已存在");
        }
        return categoryRepository.save(category);
    }

    public Category updateCategory(Long id, Category category) {
        // 检查分类名称是否已存在（排除当前分类）
        Category existingCategory = categoryRepository.findByName(category.getName());
        if (existingCategory != null && !existingCategory.getId().equals(id)) {
            throw new RuntimeException("分类名称已存在");
        }
        category.setId(id);
        return categoryRepository.save(category);
    }

    public void deleteCategory(Long id) {
        // 检查分类下是否有花卉
        Long flowerCount = categoryRepository.countFlowersByCategoryId(id);
        if (flowerCount > 0) {
            throw new RuntimeException("该分类下还有" + flowerCount + "个花卉，无法删除");
        }
        categoryRepository.deleteById(id);
    }

    public Category getCategoryByName(String name) {
        return categoryRepository.findByName(name);
    }
} 