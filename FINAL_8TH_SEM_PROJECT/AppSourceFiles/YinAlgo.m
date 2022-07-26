function [frequencyPlot,t2] = yinAlgo(xt,Fs)
    N = length(xt);
    win_len = 2048;
    rem = (floor(N/win_len)+1)*win_len - N;
    xt = [xt(:,1); zeros(rem,1)];
    N = length(xt);
    t2 = (0:N-1)/Fs;
    frequencyPlot = [];
    minimum_value = [];
%     yt = [];
    for i = 1:length(xt)/win_len
        wi = xt((i-1)*win_len+1:i*win_len);
        for j = 1:win_len
            y = wi - circshift(wi,j);
            y = (abs(y)).^2;
            minimum_value(j) = sum(y);
        end
        [~, index] = min(minimum_value(round(Fs/1000):win_len/2));
        if sum(wi.*wi) > 0.01
            f = Fs / (index+round(Fs/1000));
        else
            f = 0;
        end
        
        if f > 800 && i > 1
            f = frequencyPlot((i-1)*win_len);
        end
        
        frequencyPlot = [frequencyPlot f*(ones(1,win_len))];
    end
end