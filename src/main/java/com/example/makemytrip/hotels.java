package com.example.makemytrip;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class hotels {
    @GetMapping("/hotels")
    public String getData() {return "Book your hotels in Pune at 10% OFF!";}
}