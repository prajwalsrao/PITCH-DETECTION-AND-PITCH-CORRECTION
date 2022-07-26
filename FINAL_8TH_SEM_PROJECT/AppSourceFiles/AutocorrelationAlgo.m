function [pitchplot,time] = AutocorrelationAlgo(xt,Fs)
    N = length(xt);
    win_len = 2048;
    rem = (floor(N/win_len)+1)*win_len - N;
    xt = [xt(:,1); zeros(rem,1)];
    N = length(xt);
    time = linspace(0,N/Fs,N);
    pitchplot = [];

    for i = 1:length(xt)/win_len
        wi =xt((i-1)*win_len+1:i*win_len);
        W = ifft(fft(wi).*fft(flipud(wi)));
        [peak,ind] = findpeaks(W,'MinPeakDistance',round(Fs/1000));
        [a,b] = max(peak(1:round(length(peak)/2)));
        if ind(b) ~= 0
            f=Fs/ind(b);    
        else
            f=0;
        end
        
        if f > 950 && i > 1
            f = pitchplot((i-1)*win_len);
        end
        
        pitchplot = [pitchplot f*(ones(1,win_len))];
    end
end