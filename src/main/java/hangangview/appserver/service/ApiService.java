package hangangview.appserver.service;

import com.google.cloud.speech.v1.*;
import com.google.cloud.texttospeech.v1.*;
import com.google.protobuf.ByteString;
import net.bramp.ffmpeg.FFmpeg;
import net.bramp.ffmpeg.FFmpegExecutor;
import net.bramp.ffmpeg.FFprobe;
import net.bramp.ffmpeg.builder.FFmpegBuilder;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

@Service
public class ApiService {
    private String lang;
    public String stt(MultipartFile multipartFile,String lang) throws IOException {
        this.lang=lang;
        File file = new File(multipartFile.getOriginalFilename());
        file.createNewFile();
        FileOutputStream fos=new FileOutputStream(file);
        fos.write(multipartFile.getBytes());
        fos.close();
        m4aToWav(file.getName());
        return recognitionSpeech("test.wav");
    }

    public void tts(String text,String lang) throws IOException {
        try (TextToSpeechClient textToSpeechClient = TextToSpeechClient.create()) {
            // Set the text input to be synthesized
            SynthesisInput input = SynthesisInput.newBuilder().setText(text).build();

            // Build the voice request, select the language code ("en-US") and the ssml voice gender
            // ("neutral")
            VoiceSelectionParams voice;
            if(lang.equals("kr")) {
                voice=VoiceSelectionParams.newBuilder()
                            .setName("ko-KR-Standard-C")
                            .setLanguageCode("ko-KR")
                            .build();
            }
            else{
                voice=VoiceSelectionParams.newBuilder()
                        .setName("en-US-Standard-C")
                        .setLanguageCode("en-US")
                        .build();
            }

            // Select the type of audio file you want returned
            AudioConfig audioConfig =
                    AudioConfig.newBuilder().setVolumeGainDb(6.0).setSpeakingRate(1.0).setAudioEncoding(AudioEncoding.MP3).build();

            // Perform the text-to-speech request on the text input with the selected voice parameters and
            // audio file type
            SynthesizeSpeechResponse response =
                    textToSpeechClient.synthesizeSpeech(input, voice, audioConfig);

            // Get the audio contents from the response
            ByteString audioContents = response.getAudioContent();

            // Write the response to the output file.
            try (OutputStream out = new FileOutputStream("output.mp3")) {
                out.write(audioContents.toByteArray());
//                System.out.println("Audio content written to file \"output.mp3\"");
            }
        }
    }
    public void m4aToWav(String filePath) throws IOException {
        FFmpeg ffmpeg = new FFmpeg("/opt/homebrew/bin/ffmpeg");  // ffmpeg 리눅스 경로
        FFprobe ffprobe = new FFprobe("/opt/homebrew/bin/ffprobe");  // ffprobe 리눅스 경로

        FFmpegBuilder builder = new FFmpegBuilder().setInput(filePath) // 파일경로
                .overrideOutputFiles(true) // 오버라이드
                .addOutput("test.wav") // 저장 경로 ( mov to mp4 )
                .setFormat("wav") // 포맷 ( 확장자 )
                .disableSubtitle() // 서브타이틀 제거
                .setAudioChannels(1) // 오디오 채널 ( 1 : 모노 , 2 : 스테레오 )
                .setStrict(FFmpegBuilder.Strict.EXPERIMENTAL) // ffmpeg 빌더 실행 허용
                .done();

        FFmpegExecutor executor = new FFmpegExecutor(ffmpeg, ffprobe);
        executor.createJob(builder).run();
    }

    public String recognitionSpeech(String filePath) {
        StringBuilder text= new StringBuilder();
        try {
            SpeechClient speech = SpeechClient.create(); // Client 생성
            RecognitionConfig config;
            // 오디오 파일에 대한 설정부분
            if(lang.equals("kr")) {
                config = RecognitionConfig.newBuilder()
                        .setEncoding(RecognitionConfig.AudioEncoding.ENCODING_UNSPECIFIED)
//                    .setSampleRateHertz(12000)
                        .setLanguageCode("ko-KR")
                        .build();
            }
            else{
                config = RecognitionConfig.newBuilder()
                        .setEncoding(RecognitionConfig.AudioEncoding.ENCODING_UNSPECIFIED)
//                    .setSampleRateHertz(12000)
                        .setLanguageCode("en-US")
                        .build();
            }
            RecognitionAudio audio = getRecognitionAudio(filePath); // Audio 파일에 대한 RecognitionAudio 인스턴스 생성
            RecognizeResponse response = speech.recognize(config, audio); // 요청에 대한 응답

            List<SpeechRecognitionResult> results = response.getResultsList(); // 응답 결과들
            for (SpeechRecognitionResult result: results) {
                SpeechRecognitionAlternative alternative = result.getAlternativesList().get(0);
                text.append(alternative.getTranscript());
                System.out.printf("Transcription: %s%n", alternative.getTranscript());
            }
//            result=results.get(0).getAlternatives(0).getTranscript();
            speech.close();
        }
        catch (Exception e) {
            e.printStackTrace();
            text.append(e.getMessage());
        }
        return text.toString();

    }

    public RecognitionAudio getRecognitionAudio(String filePath) throws IOException {
        RecognitionAudio recognitionAudio;

            //파일이 GCS에 있는 경우
//        if (filePath.startsWith("gs://")) {
//            recognitionAudio = RecognitionAudio.newBuilder()
//                    .setUri(filePath)
//                    .build();
//        }
//        else { // 파일이 로컬에 있는 경우
            Path path = Paths.get(filePath);
            byte[] data = Files.readAllBytes(path);
            ByteString audioBytes = ByteString.copyFrom(data);

            recognitionAudio = RecognitionAudio.newBuilder()
                    .setContent(audioBytes)
                    .build();
//        }

        return recognitionAudio;
    }
}
