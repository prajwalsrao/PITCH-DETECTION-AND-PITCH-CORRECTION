function y=CompExp(xt,Fs,comp)
% Compressor/expander
% comp - compression: 0>comp>-1, expansion: 0<comp<1
% a- filter parameter <1
if size(xt,1) <= 2
        xt = xt';
end
        xt = xt(:,1);
a = 0.5;
h=filter([(1-a)^2],[1.0000 -2*a a^2],abs(xt));
h=h/max(h);
h=h.^comp;
y=xt.*h;
y=y.*max(abs(xt))/max(abs(y));
end