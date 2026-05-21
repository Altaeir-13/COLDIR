package br.fadir.com.api.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

//class para testes
@RestController
public class TestController {

    @GetMapping("/test")
    public String test(){
        return "back end no ar";
    }
}
