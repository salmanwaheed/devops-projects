package com.api;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HomeController {

  @GetMapping("/")
  public Message index() {
    return new Message("API is running!", 200);
  }

  record Message(String message, Integer status) {}
}
