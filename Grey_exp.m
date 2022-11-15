function J = Grey_exp(Init,mi)
I = rgb2gray(Init);
I = double(Init);
J=1.5.^(I*mi)-1;
J(find(J>255))=255;
J=uint8(J);
end

