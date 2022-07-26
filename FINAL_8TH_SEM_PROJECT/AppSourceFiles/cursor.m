
        [xt ,fs]= audioread('piano.wav');
[p,t] = YinAlgo(xt,fs)
                %time=(0:length(xt)-1)/fs;
                plot(t,p)
                end_time = length(xt)/fs;
                
                h=line([0,0],[-2,2],'color','r');
                
                sound(xt, fs) 
                tic 
                t=toc; 
                while t<end_time
                   set(h, 'xdata', t*[1,1]) 
                   drawnow 
                   t=toc; 
                end