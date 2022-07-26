function [pitchplot,time] = AvgMagDifferenceAlgo(xt,Fs)
    N = length(xt);
    win_len = 2048;
    rem = (floor(N/win_len)+1)*win_len - N;
    xt = [xt(:,1); zeros(rem,1)];
    N = length(xt);
    time = (0:N-1)/Fs;
    pitchplot = [];
    minimum_value = [];
    for i = 1:length(xt)/win_len
        wi = xt((i-1)*win_len+1:i*win_len);
        for j = 1:win_len
            y = wi - circshift(wi,j);
            y = (abs(y));
            minimum_value(j) = sum(y);
        end
        [v, index] = min(minimum_value(round(Fs/1000):win_len/2));
        if sum(wi.*wi) > 0.2
            f = Fs / (index+round(Fs/1000));
        else
            f = 0;
        end
        
        if f > 950 && i > 1
            f = pitchplot((i-1)*win_len);
        end
        
        pitchplot = [pitchplot f*(ones(1,win_len))];
    end
end