package hangangview.appserver.controller;

import hangangview.appserver.service.QuestionService;
import lombok.RequiredArgsConstructor;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequiredArgsConstructor
public class QuestionController {
    private final QuestionService questionService;

    @GetMapping("/question/{category}")
    public String question(@PathVariable("category")String category){
        JSONObject jsonObject=new JSONObject();
        try {
            jsonObject=questionService.getQuestionList(category);
        } catch (Exception e) {
        }
        return jsonObject.toString();
    }
}
