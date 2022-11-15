function J=S_averfilter(Init,n)
Templete(1:n,1:n)=1;
[height,width]=size(Init);
Init1=double(Init);
Init2=Init1;
for i = 1:height-n+1
    for j = 1:width-n+1
        b=Init1(i:i+(n-1),j:j+(n-1)).*Templete;
        s=sum(sum(b));
        Init2(i+(n-1)/2,j+(n-1)/2)=s/(n^2);
    end
end
J=uint8(Init2);
end

