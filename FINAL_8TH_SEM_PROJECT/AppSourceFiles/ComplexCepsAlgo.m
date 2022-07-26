function [pitchplot,time] = ComplexCepsAlgo(xt,Fs)
    N = length(xt);
    win_len = 2048;
    rem = (floor(N/win_len)+1)*win_len - N;
    xt = [xt(:,1); zeros(rem,1)];
    N = length(xt);
    time = linspace(0,N/Fs,N);
    pitchplot = [];
    time = (0:N-1)/Fs;
    win_len=2048;
    w=hamming(win_len);
    start=1;
    while (start) <= N
        x=xt(start:start+win_len-1);
        Y=fft(x.*w);
        C=ifft(log(abs(Y)+eps));
        [c,fxval]=max(abs(C(round(Fs/1000):win_len/2)));
        
        if sum(x.*x) > 0.2
            f = Fs / (fxval+round(Fs/1000));
        else
            f = 0;
        end
        
        if f > 950 && i > 1
            f = pitchPlot((i-1)*win_len);
        end
        pitchplot = [pitchplot f*(ones(1,win_len))];
        start=start+win_len;
 
    end

end