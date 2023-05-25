import Foundation
import Alamofire
//(1) 라이브러리 추가

class TTS {
    
    static let shared = TTS()
//(2)싱글통 객체를 선언해서 앱 어디에서든지 접근가능하도록 한다
    private init() {}
    
    func getSpeech(from text:String, completion: @escaping(URL) -> Void)async
    {
        var url=APIConstants.getTTSURL
        
        
        //HTTP Headers : 요청 헤더
        let header : HTTPHeaders = ["Content-Type" : "application/json"]
        
//        요청 바디
        let body : Parameters = [
            "text" : text
        ]
        
        //요청서 //Request 생성
        //통신할 주소, HTTP메소드, 요청방식, 인코딩방식, 요청헤더
        let dataRequest = AF.request(url,
                                    method: .post,
                                    parameters: body,
                                    encoding: JSONEncoding.default,
                                    headers: header)
        
        //request 시작 ,responseData를 호출하면서 데이터 통신 시작
        dataRequest.responseData{
            response in //데이터 통신의 결과가 response에 담기게 된다
            let data=response.data
            let fileManager = FileManager.default
//            let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let documentURL = fileManager.urls(for:.documentDirectory, in:.userDomainMask).first!
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateFormat="YYYYMMDDHHMMSS"
            //저장될 파일 이름
            let fileName = documentURL.appendingPathComponent(dateFormatter.string(from:Date())+"A.mp3")
            do{try data?.write(to: fileName)}
            catch{print("실패~")}
            completion(fileName)
        }
    }
   
}
