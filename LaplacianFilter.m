function J=LaplacianFilter(Init,alpha)
Init0=double(Init);
%alpha=2;
[height,width]=size(Init0);
B=double(Init);
for i = 2:height-1
    for j = 2:width-1
        B(i,j)=alpha*(-Init0(i+1,j)-Init0(i-1,j)-Init0(i-1,j-1)-Init0(i,j-1)-Init0(i+1,j-1)-...
            Init0(i-1,j+1)-Init0(i,j+1)-Init0(i+1,j+1)+8*Init0(i,j));
    end
end
J=uint8(B);
end
