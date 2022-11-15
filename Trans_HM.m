function J = Trans_HM(Init)
result=Init;
image_matrix=double(Init);
[height,width,channels]=size(Init);
for i = 1:height
    for j = 1:width
        result(i,j)=image_matrix(i,width-j+1);
    end
end
J = uint8(result);
end

