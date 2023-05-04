package hangangview.appserver.service;

import hangangview.appserver.repository.CreativityRepository;
import org.json.JSONObject;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.jdbc.AutoConfigureTestDatabase;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit.jupiter.SpringExtension;

@SpringBootTest
@ExtendWith(SpringExtension.class)
@AutoConfigureTestDatabase(replace = AutoConfigureTestDatabase.Replace.NONE)
public class QuestionServiceTest {
    @Autowired
    QuestionService questionService;

    @Test
    public void getQuestionListTest() {
        JSONObject jsonObject= null;
        try {
            jsonObject = questionService.getQuestionList("personality");
        } catch (Exception e) {
            System.out.println("Exception:" + e.getMessage());
        }
        System.out.println(jsonObject.toString());
    }
}
