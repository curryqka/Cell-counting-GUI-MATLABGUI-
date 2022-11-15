function image_out=Trans_Rot(image,angle)
image_matrix=image(:,:,1);
image_matrix=double(image_matrix);
[height,width,~]=size(image);
% input angle
RotMatrix=[cos(angle),-sin(angle);sin(angle),cos(angle)];
halfH = floor(height/2);
halfW = floor(width/2);
for i = 1:height
    for j = 1:width
        temp = [i-halfH,j-halfW]*RotMatrix;
        x = round(temp(1))+halfH;
        y = round(temp(2))+halfW;
        if x > 0 & x<=height & y>0 & y<=width
            image_out(i,j)=image(x,y);
        end
    end
end
end