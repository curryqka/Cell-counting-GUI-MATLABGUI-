function [NUM] = CellNum(Col_Image)

% 显示原图
hh=2;
 
%% 显示灰度图像
Gray_Image=rgb2gray(Col_Image);%彩色变灰色
% figure;imshow(Gray_Image);
% title('灰度图像');
 
%% 去噪后的图像
Original_Image=im2double(Gray_Image);
Denoi_Image=Original_Image;                             
[m,n]=size(Denoi_Image);
h = fspecial('gaussian',[3 3], 2);
Denoi_Image=imfilter(Denoi_Image,h,'replicate'); 
% figure;imshow(Denoi_Image);
% title('去噪后的图像');
 
%% 二值化图像
M=graythresh(Col_Image(:,:,3)); 
binary_Image=im2bw(Col_Image(:,:,3),M);     
binary_Image=~binary_Image;
% figure;imshow(binary_Image);
% title('二值化图像');
 
%% Canny边缘检测
ROI_edge_canny=edge(Denoi_Image,'canny',0.3);
% figure;imshow(ROI_edge_canny);
% title('canny边缘检测');
 
%% Prewitt边缘检测
ROI_edge_prewitt=edge(Denoi_Image,'prewitt');
% figure;imshow(ROI_edge_prewitt);
% title('prewitt边缘检测');
 
%% Roberts边缘检测
ROI_edge_roberts=edge(Denoi_Image,'roberts');
% figure;imshow(ROI_edge_roberts);
% title('roberts边缘检测');
 
%% Sobel边缘检测
ROI_edge_sobel=edge(Denoi_Image,'sobel');
% figure;imshow(ROI_edge_sobel);
% title('sobel边缘检测');
 
%% canny prewitt roberts sobel边缘检测
ROI_edge=ROI_edge_canny|ROI_edge_prewitt|ROI_edge_roberts|ROI_edge_sobel;
% figure;imshow(ROI_edge);
% title('canny _ prewitt _ roberts _ sobel边缘检测图像');

%% Kirsch分割图像
W{1,1}=[5,5,5;-3,0,-3;-3,-3,-3]; %模板1
W{1,2}=[5,5,-3;5,0,-3;-3,-3,-3]; %模板2
W{1,3}=[5,-3,-3;5,0,-3;5,-3,-3]; %模板3
W{1,4}=[-3,-3,-3;5,0,-3;5,5,-3]; %模板4
W{1,5}=[-3,-3,-3;-3,0,-3;5,5,5]; %模板5
W{1,6}=[-3,-3,-3;-3,0,5;-3,5,5]; %模板6
W{1,7}=[-3,-3,5;-3,0,5;-3,-3,5]; %模板7
W{1,8}=[-3,5,5;-3,0,5;-3,-3,-3]; %模板8
for hh=1:8
    I{1,hh}=filter2(W{1,hh},Denoi_Image);
    I{1,hh}=im2bw(I{1,hh},graythresh(I{1,hh}));
end
I9=I{1,1}|I{1,2}|I{1,3}|I{1,4}|I{1,5}|I{1,6}|I{1,7}|I{1,8};
% figure;imshow(I9);
% title('Kirsch分割图像1');

se = strel('disk',1); %创建形态学结构元素（形态学模板disk形状）
I9=imerode(I9,se);%腐蚀运算
I9 = imclose(I9,se);%闭运算
% figure;imshow(I9);title('Kirsch分割图像2');

 
%% 利用OR运算结合二值化图像和边缘信息
ROI_Seg=ROI_edge_canny|I9;%|binary_Image;%进行多个边界提取结果的“或”逻辑运算
% figure;imshow(ROI_Seg);title('运算分割图像1');
ROI_Seg=ROI_edge_canny|I9|binary_Image;%进行多个边界提取结果的“或”逻辑运算
% figure;imshow(ROI_Seg);title('运算分割图像2');
 
se = strel('disk',3); %盘型结构元素
Fina_Seg = imclose(ROI_Seg,se);%闭运算
Fina_Seg=bwmorph(Fina_Seg,'remove');%移除中心的像素使其近似为细线状的边界
% figure;imshow(Fina_Seg);
% title('形态学操作 移除');

%Fina_Seg = imfill(Fina_Seg,8,'holes');
Fina_Seg = imfill(Fina_Seg,4,'holes');%采用四邻域填充方式填充孔洞
% figure;imshow(Fina_Seg);
% title('孔洞填充');

%% 对二值图初步筛选
Fina_Seg=bwareaopen(Fina_Seg,100);%移除二值图中过小的结构（如小像素点团块）
Fina_Seg=bwmorph(Fina_Seg,'spur',8);%移除畸变点，具体见matlabhelp样例
Fina_Seg=bwmorph(Fina_Seg,'clean');%移除连通区域为0的孤立点
% figure;imshow(Fina_Seg);title('填充后');

%% 标签化二值图，记录分割数据
[Lab_Image1, XNum]=bwlabeln(Fina_Seg,4);%标记图像Lab_Image1，标记区域的个数XNum，这里的4表示四邻域方式
% Lab_Image=Lab_Image1(3:end-3,3:end-3);
[m1,n1]=size(Lab_Image1);
stats=regionprops(Lab_Image1,'all');%求基本特征参数
%figure;imshow(Lab_Image1);title('标签化');
 
RGBX=label2rgb(Lab_Image1,@jet,'k');
%figure;imshow(RGBX);title('彩色标签化图像');%这里的彩色标签化图像仅仅是为了显示，是一个伪色彩处理，可以反映出label计算过程中的计算顺序；
 
[L_BW,NUM]=bwlabel(Fina_Seg,4);
figure;imshow(L_BW);
stats=regionprops(L_BW,'all');%利用regionprops，记录了所有labe后的图像内的分割信息。stats通过sturct存放了boundingbox坐标等信息，里面内容很多，大致了解意思即可。

%% 此程序为进一步优化筛选，同时在原图中框出检测出的细胞个数
figure;imshow(Col_Image);%显示原图供后续画图使用

for i=1:NUM %这里的num表示初步通过bwlabel，筛选出来的细胞个数
    [r,c]=find(L_BW==i);%二值图L_BW中已经按照顺序标记了分割结果，相同的分割区域数值均为对应的label数字。r、c分别记录对应的原图内的位置
    S(i)=stats(i).Area;%区域，记录了区域内像素点的个数
    L(i)=stats(i).Perimeter;%区域的周长
    C(i)=(L(i)*L(i)) /(4*pi*S(i));%近似计算平均密度类的形式（不严谨理解）
  %   if 600<stats(i).Area && stats(i).Area<5000  %  加上面积，一些连接在一起的细胞就会圈不出来。
  if 1200<S(i)&& S(i)<5900 %这里为一些筛选条件。筛除极小细胞和连载一起的大团块的干扰。
  if 100<L(i)&& L(i)<300
  if 0.8<C(i)&& C(i)<1.8
% if   C(i)>1.5
    % 这里根据分割结果，计算画矩形框的大小
    rmin=min(r);rmax=max(r);
    cmin=min(c);cmax=max(c);
    w=cmax-cmin+1;
    h=rmax-rmin+1;
    hold on
    if (h>w && 1.5*w>h) || (w>h && 1.5*h>w)||(w==h)
%         if (h>w && 1.5*w<h) || (w>h && 1.5*h<w) 
        rectangle('Position',[cmin,rmin,w,h]);%画一个正方形
        drawnow;%将正方形画在打开的figure即原图中
    end 
  end                                       
    end
  end
end
end

