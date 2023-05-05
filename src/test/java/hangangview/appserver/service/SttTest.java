package hangangview.appserver.service;

import org.apache.commons.fileupload.disk.DiskFileItem;
import org.apache.commons.io.IOUtils;
import org.apache.tomcat.util.http.fileupload.FileItem;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.commons.CommonsMultipartFile;

import java.io.*;
import java.nio.file.Files;

@SpringBootTest
@ExtendWith(SpringExtension.class)
public class SttTest {
    @Autowired
    ApiService apiService;

    @Test
    public void stt() throws IOException {
        apiService.m4aToWav("test.m4a");
        System.out.println(apiService.recognitionSpeech("test.wav"));
    }
}
