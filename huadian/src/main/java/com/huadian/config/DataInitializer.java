package com.huadian.config;

import com.huadian.entity.Flower;
import com.huadian.repository.FlowerRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.math.BigDecimal;
import java.util.Arrays;

@Component
public class DataInitializer implements CommandLineRunner {

    @Autowired
    private FlowerRepository flowerRepository;

    @Override
    public void run(String... args) throws Exception {
        // 检查是否已有数据
        if (flowerRepository.count() == 0) {
            initializeFlowers();
            System.out.println("示例花卉数据已初始化完成！");
        }
    }

    private void initializeFlowers() {
        Flower[] flowers = {
            new Flower() {{
                setName("红玫瑰");
                setDescription("经典红玫瑰，象征热情与爱情，是表达爱意的最佳选择");
                setPrice(new BigDecimal("15.99"));
                setStock(100);
                setCategory("玫瑰");
                setImageUrl("https://images.unsplash.com/photo-1549465220-1a8b9238cd48?w=300&h=200&fit=crop");
            }},
            new Flower() {{
                setName("白百合");
                setDescription("纯洁的白百合，适合各种场合，象征纯洁和高贵");
                setPrice(new BigDecimal("12.50"));
                setStock(80);
                setCategory("百合");
                setImageUrl("https://images.unsplash.com/photo-1589244159943-460088ed5c1b?w=300&h=200&fit=crop");
            }},
            new Flower() {{
                setName("向日葵");
                setDescription("阳光般的向日葵，给人温暖感觉，象征积极向上");
                setPrice(new BigDecimal("8.99"));
                setStock(120);
                setCategory("向日葵");
                setImageUrl("https://images.unsplash.com/photo-1470509037663-253afd7f0f51?w=300&h=200&fit=crop");
            }},
            new Flower() {{
                setName("粉玫瑰");
                setDescription("温柔的粉玫瑰，表达浪漫情感，适合送给心爱的人");
                setPrice(new BigDecimal("18.50"));
                setStock(90);
                setCategory("玫瑰");
                setImageUrl("https://images.unsplash.com/photo-1549465220-1a8b9238cd48?w=300&h=200&fit=crop");
            }},
            new Flower() {{
                setName("康乃馨");
                setDescription("母亲节首选，表达感恩之情，象征母爱");
                setPrice(new BigDecimal("10.99"));
                setStock(150);
                setCategory("康乃馨");
                setImageUrl("https://images.unsplash.com/photo-1589244159943-460088ed5c1b?w=300&h=200&fit=crop");
            }},
            new Flower() {{
                setName("郁金香");
                setDescription("优雅的郁金香，春季花卉代表，象征美好祝福");
                setPrice(new BigDecimal("14.99"));
                setStock(70);
                setCategory("郁金香");
                setImageUrl("https://images.unsplash.com/photo-1470509037663-253afd7f0f51?w=300&h=200&fit=crop");
            }},
            new Flower() {{
                setName("紫罗兰");
                setDescription("神秘的紫罗兰，独特的花香，象征永恒的爱");
                setPrice(new BigDecimal("16.50"));
                setStock(60);
                setCategory("紫罗兰");
                setImageUrl("https://images.unsplash.com/photo-1549465220-1a8b9238cd48?w=300&h=200&fit=crop");
            }},
            new Flower() {{
                setName("满天星");
                setDescription("小巧的满天星，完美的配花，象征纯洁和美好");
                setPrice(new BigDecimal("6.99"));
                setStock(200);
                setCategory("满天星");
                setImageUrl("https://images.unsplash.com/photo-1589244159943-460088ed5c1b?w=300&h=200&fit=crop");
            }}
        };

        flowerRepository.saveAll(Arrays.asList(flowers));
    }
} 