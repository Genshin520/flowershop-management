package com.huadian.dto;

public class CategoryDTO {
    private Long id;
    private String name;
    private String description;
    private Long flowerCount;

    public CategoryDTO() {}

    public CategoryDTO(Long id, String name, String description, Long flowerCount) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.flowerCount = flowerCount;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Long getFlowerCount() {
        return flowerCount;
    }

    public void setFlowerCount(Long flowerCount) {
        this.flowerCount = flowerCount;
    }
} 