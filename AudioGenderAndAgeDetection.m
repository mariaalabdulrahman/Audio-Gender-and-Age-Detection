function AudioGenderAndAgeDetection()
 fig = figure('Position', [100, 100, 800, 600], 'Color', [0.8 0.9843 1]);
 uicontrol('Style', 'pushbutton', 'String', 'Upload Audio',...
     'Position', [10, 570, 100, 30], 'Callback', @uploadAudio,...
     'BackgroundColor', [1, 1, 0]);
 audioData = [];
 Fs = [];
 function plotAudio(audioData, Fs)
     t = (0:length(audioData)-1) / Fs;
  
     subplot(3,1,1);
     plot(t, audioData);
     xlabel('Time (s)');
     ylabel('Amplitude');
     title('Original Audio Signal');
  
     cutoff_frequency = 250;
     normalized_cutoff_frequency = cutoff_frequency / (Fs/2);
     [b, a] = butter(6, normalized_cutoff_frequency, 'low');
     audioData_denoised = filtfilt(b, a, audioData);
  
     subplot(3,1,3);
     plot(t, audioData_denoised);
     xlabel('Time (s)');
     ylabel('Amplitude');
     title('Denoised Audio Signal');
  
     N = length(audioData_denoised);
     Y = fft(audioData_denoised);
     f = (0:N-1)*(Fs/N);
  
     subplot(3,1,2);
     plot(f, abs(Y));
     xlabel('Frequency (Hz)');
     ylabel('Magnitude');
     title('Fourier Transform (Original)');
  
     Y_denoised = fft(audioData_denoised);
     [~, idx] = max(abs(Y_denoised(1:N/2))); 
     avgFrequency = f(idx);
     fprintf('Average Frequency (after denoising): %.2f Hz\n', avgFrequency);
     if avgFrequency < 180 
         disp('Speaker is likely male.');
         if avgFrequency<94
             disp('Speaker is likely a child.');
         elseif avgFrequency>94 && avgFrequency<105
             disp('Speaker is likely old.');
         elseif avgFrequency>119 && avgFrequency<146
             disp('Speaker is likely a young adult');
         else
             disp('Speaker is likely an adult.');
         end
     else
         disp('Speaker is likely female.');
         if avgFrequency>262
             disp('Speaker is likely a child.');
         elseif avgFrequency>212 && avgFrequency<224
             disp('Speaker is likely a young adult');
         elseif avgFrequency>224 && avgFrequency<234
             disp('Speaker is likely old.');
         else
             disp('Speaker is likely an adult.');
         end
     end
 end

 function uploadAudio(~, ~)
     [filename, pathname] = uigetfile({'*.wav;*.mp3;*.ogg;*.flac;*.m4a', 'All Audio Files (*.wav, *.mp3, *.ogg, *.flac, *.m4a)'},'Select Audio File');
     if filename ~= 0
         fullpath = fullfile(pathname, filename);
         [audioData, Fs] = audioread(fullpath);
         plotAudio(audioData, Fs);
     end
 end
end
