function [ T ] = globalthreshold( f )
%UNTITLED �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
count=0;
T = mean2(f);
T0=5;
done = false;
while ~done
    count = count +1;
    g=f>T;
    %disp(g);
    gT=0.5*(mean(f(g))+mean(f(~g)));
    done=abs(T-gT)<T0;
    T=gT;

end

