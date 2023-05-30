package hangangview.appserver.controller;

import hangangview.appserver.service.ApiService;
import io.opencensus.resource.Resource;
import lombok.RequiredArgsConstructor;
import org.json.JSONObject;
import org.springframework.core.io.FileSystemResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;

@Controller
@RequiredArgsConstructor
public class ApiController {
    private final ApiService apiService;
    @ResponseBody
    @PostMapping("/stt") //굳이 PostMapping으로 해야되나 싶긴 함, enctype속성값을 "multipart/form-data" 로 해야함
    public String speechToText(@RequestParam("file") MultipartFile file){
        try {
            return apiService.stt(file,"kr");
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    @ResponseBody
    @PostMapping("/stt/eng") //굳이 PostMapping으로 해야되나 싶긴 함, enctype속성값을 "multipart/form-data" 로 해야함
    public String speechToTextEng(@RequestParam("file") MultipartFile file){
        try {
            return apiService.stt(file,"eng");
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    @PostMapping("/tts")
    public ResponseEntity<?> textToSpeech(@RequestBody HashMap<String, Object> map){
        String text=map.get("text").toString();
        try {
            apiService.tts(text,"kr");
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
        File audioFile = new File("output.mp3");
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.valueOf("audio/mpeg"));
        headers.setContentLength(audioFile.length());
        return new ResponseEntity<>(new FileSystemResource(audioFile), headers, HttpStatus.OK);
    }
    @PostMapping("/tts/eng")
    public ResponseEntity<?> textToSpeechEng(@RequestBody HashMap<String, Object> map){
        String text=map.get("text").toString();
        try {
            apiService.tts(text,"eng");
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
        File audioFile = new File("output.mp3");
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.valueOf("audio/mpeg"));
        headers.setContentLength(audioFile.length());
        return new ResponseEntity<>(new FileSystemResource(audioFile), headers, HttpStatus.OK);
    }
}
