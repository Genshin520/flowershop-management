package com.huadian.controller;

import com.huadian.entity.Flower;
import com.huadian.service.FlowerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/flowers")
@CrossOrigin(origins = "*")
public class FlowerController {
    
    @Autowired
    private FlowerService flowerService;
    
    @GetMapping
    public ResponseEntity<List<Flower>> getAllFlowers() {
        return ResponseEntity.ok(flowerService.getAllFlowers());
    }
    
    @GetMapping("/{id}")
    public ResponseEntity<Flower> getFlowerById(@PathVariable Long id) {
        Optional<Flower> flower = flowerService.getFlowerById(id);
        return flower.map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }
    
    @PostMapping
    public ResponseEntity<Flower> createFlower(@RequestBody Flower flower) {
        try {
            Flower createdFlower = flowerService.createFlower(flower);
            return ResponseEntity.ok(createdFlower);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().build();
        }
    }
    
    @PutMapping("/{id}")
    public ResponseEntity<Flower> updateFlower(@PathVariable Long id, @RequestBody Flower flower) {
        try {
            flower.setId(id);
            Flower updatedFlower = flowerService.updateFlower(flower);
            return ResponseEntity.ok(updatedFlower);
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }
    
    @PutMapping("/{id}/category")
    public ResponseEntity<?> updateFlowerCategory(@PathVariable Long id, @RequestBody Map<String, Object> request) {
        try {
            Long categoryId = request.get("categoryId") != null ? 
                Long.valueOf(request.get("categoryId").toString()) : null;
            Flower updatedFlower = flowerService.updateFlowerCategory(id, categoryId);
            return ResponseEntity.ok(updatedFlower);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }
    
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteFlower(@PathVariable Long id) {
        Optional<Flower> flower = flowerService.getFlowerById(id);
        if (flower.isPresent()) {
            flowerService.deleteFlower(id);
            return ResponseEntity.ok().build();
        }
        return ResponseEntity.notFound().build();
    }
    
    @GetMapping("/search")
    public ResponseEntity<List<Flower>> searchFlowers(@RequestParam String keyword) {
        List<Flower> flowers = flowerService.searchFlowers(keyword);
        return ResponseEntity.ok(flowers);
    }
    
    @GetMapping("/category/{category}")
    public ResponseEntity<List<Flower>> getFlowersByCategory(@PathVariable String category) {
        List<Flower> flowers = flowerService.getFlowersByCategory(category);
        return ResponseEntity.ok(flowers);
    }
    
    @GetMapping("/available")
    public ResponseEntity<List<Flower>> getAvailableFlowers() {
        List<Flower> flowers = flowerService.getAvailableFlowers();
        return ResponseEntity.ok(flowers);
    }
    
    @GetMapping("/category-id/{categoryId}")
    public ResponseEntity<List<Flower>> getFlowersByCategoryId(@PathVariable Long categoryId) {
        List<Flower> flowers = flowerService.getFlowersByCategoryId(categoryId);
        return ResponseEntity.ok(flowers);
    }
} 