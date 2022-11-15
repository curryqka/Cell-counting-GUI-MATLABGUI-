function [J] = Trans_Move(InitImage,deltX,deltY)
[m,n,c]=size(InitImage);
%J=zeros(m,n,c);
J=InitImage;
transformation = [1 0 deltX;0 1 deltY;0 0 1];
 
for i = 1:m
    for j = 1:n
        temp = [i;j;1];
        temp = transformation * temp;
        x = temp(1);
        y = temp(2);
        if(x<=m)&(y<=n)&(x>=1)&(y>=1)
            J(x,y)=InitImage(i,j);
        end
    end
end
end

