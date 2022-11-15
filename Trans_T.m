function J = Trans_T(Init)
result=Init;
image_matrix=double(Init);
[height,width,channels]=size(Init);
for i = 1:height
    for j = 1:width
        result(j,i)=image_matrix(i,j);
    end
end
J = uint8(result);
end

