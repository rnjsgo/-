//
//  Context.swift
//  XCAChatGPT
//
//  Created by 허현준 on 2023/05/17.
//

import Foundation

struct ContextFlow{
    enum DialogType:String{
        case real
        case single
        case english
    }
    var dialogType:DialogType?
    
    enum QuestionCategory:String{
        case personality
        case creativity
        case social
        case job
    }
    var questionCategory:QuestionCategory?
    
    var selectedQuestion:String?=""
    
    var jobCategory:String?
    
    var coverLetterQuestion:String?="문항이 존재하지 않습니다."
    var coverLetterAnswer:String?="답변이 존재하지 않습니다."
    var dialogueCase:String?="상황이 선택되지 않았습니다."
    
    public func setSelectedQuestion(question: String)->ContextFlow{
        var cf = self
        cf.selectedQuestion = question
        return cf
    }
    public func setQuestionCategory(questionCategory:QuestionCategory)->ContextFlow{
        var cf = self
        cf.questionCategory = questionCategory
        return cf
    }
    
    public func setJobCategory(jobCategory:String)->ContextFlow{
        var cf = self
        cf.jobCategory = jobCategory
        return cf
    }
    
    public func setDialogueCase(dialogueCase:String)->ContextFlow{
        var cf = self
        cf.dialogueCase = dialogueCase
        return cf
    }
    
    public func setCoverLetterAnswer(answer:String)->ContextFlow{
        var cf = self
        cf.coverLetterAnswer=answer
        return cf
    }
    
    public func setCoverLetterQuestion(question:String)->ContextFlow{
        var cf = self
        cf.coverLetterQuestion=question
        return cf
    }
    
}
