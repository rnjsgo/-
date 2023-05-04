package hangangview.appserver.service;

import hangangview.appserver.domain.Creativity;
import hangangview.appserver.domain.Question;
import hangangview.appserver.repository.CreativityRepository;
import hangangview.appserver.repository.PersonalityRepository;
import hangangview.appserver.repository.SocialRepository;
import hangangview.appserver.repository.SuitabilityRepository;
import lombok.RequiredArgsConstructor;
import org.json.JSONObject;
import org.springframework.stereotype.Service;

import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@RequiredArgsConstructor
@Service
public class QuestionService {
    private final CreativityRepository creativityRepository;
    private final PersonalityRepository personalityRepository;
    private final SocialRepository socialRepository;
    private final SuitabilityRepository suitabilityRepository;

    public JSONObject getQuestionList(String category) throws Exception {
        JSONObject jsonObject=new JSONObject();
        Question[] questionList;
        if(category.equals("creativity")){
            questionList=creativityRepository.findAll().toArray(new Question[0]);
        }
        else if(category.equals("personality")){
            questionList=personalityRepository.findAll().toArray(new Question[0]);
        }
        else if(category.equals("social")){
            questionList=socialRepository.findAll().toArray(new Question[0]);
        }
        else if(category.equals("suitability")){
            questionList=suitabilityRepository.findAll().toArray(new Question[0]);
        }
        else{
            throw new Exception();
        }
        for(Question question:questionList){
            jsonObject.put(question.getId().toString(),question.getQuestion());
        }
        return jsonObject;
    }
}
