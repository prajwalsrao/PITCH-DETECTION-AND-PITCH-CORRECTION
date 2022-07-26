function y = Vibrato(xt,Fs,Modfreq,Width)
    if size(xt,1) <= 2
        xt = xt';
end
        xt = xt(:,1);
    ya_alt = 0;
    Delay=Width;                                    % basic delay of input sample in sec
    DELAY=round(Delay*Fs);                          % basic delay in # samples
    WIDTH=round(Width*Fs);                          % modulation width in # samples
    if WIDTH>DELAY
        error('delay greater than basic delay !!!');
        return;
    end;
    MODFREQ=Modfreq/Fs;                             % modulation frequency in # samples -> can keep arange of 1-10Hz
    LEN=length(xt);
    L=2+DELAY+WIDTH*2;
    % length of the entire delay
    Delayline=zeros(L,1);                           % memory allocation for delay -> can keep a range of 0.75 to 4 msec
    y=zeros(size(xt));
    % memory allocation for output vector
    for n=1:(LEN-1)
        M=MODFREQ;
        MOD=sin(M*2*pi*n);
        ZEIGER=1+DELAY+WIDTH*MOD;
        i=floor(ZEIGER);
        frac=ZEIGER-i;
        Delayline=[xt(n);Delayline(1:L-1)];
        %---Linear Interpolation-----------------------------
        y(n,1)=Delayline(i+1)*frac+Delayline(i)*(1-frac);
        %---Allpass Interpolation------------------------------
        %y(n,1)=(Delayline(i+1)+(1-frac)*Delayline(i)-(1-frac)*ya_alt);
        %ya_alt=ya(n,1);
    end
end