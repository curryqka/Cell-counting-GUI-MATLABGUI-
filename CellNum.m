function [NUM] = CellNum(Col_Image)

% ��ʾԭͼ
hh=2;
 
%% ��ʾ�Ҷ�ͼ��
Gray_Image=rgb2gray(Col_Image);%��ɫ���ɫ
% figure;imshow(Gray_Image);
% title('�Ҷ�ͼ��');
 
%% ȥ����ͼ��
Original_Image=im2double(Gray_Image);
Denoi_Image=Original_Image;                             
[m,n]=size(Denoi_Image);
h = fspecial('gaussian',[3 3], 2);
Denoi_Image=imfilter(Denoi_Image,h,'replicate'); 
% figure;imshow(Denoi_Image);
% title('ȥ����ͼ��');
 
%% ��ֵ��ͼ��
M=graythresh(Col_Image(:,:,3)); 
binary_Image=im2bw(Col_Image(:,:,3),M);     
binary_Image=~binary_Image;
% figure;imshow(binary_Image);
% title('��ֵ��ͼ��');
 
%% Canny��Ե���
ROI_edge_canny=edge(Denoi_Image,'canny',0.3);
% figure;imshow(ROI_edge_canny);
% title('canny��Ե���');
 
%% Prewitt��Ե���
ROI_edge_prewitt=edge(Denoi_Image,'prewitt');
% figure;imshow(ROI_edge_prewitt);
% title('prewitt��Ե���');
 
%% Roberts��Ե���
ROI_edge_roberts=edge(Denoi_Image,'roberts');
% figure;imshow(ROI_edge_roberts);
% title('roberts��Ե���');
 
%% Sobel��Ե���
ROI_edge_sobel=edge(Denoi_Image,'sobel');
% figure;imshow(ROI_edge_sobel);
% title('sobel��Ե���');
 
%% canny prewitt roberts sobel��Ե���
ROI_edge=ROI_edge_canny|ROI_edge_prewitt|ROI_edge_roberts|ROI_edge_sobel;
% figure;imshow(ROI_edge);
% title('canny _ prewitt _ roberts _ sobel��Ե���ͼ��');

%% Kirsch�ָ�ͼ��
W{1,1}=[5,5,5;-3,0,-3;-3,-3,-3]; %ģ��1
W{1,2}=[5,5,-3;5,0,-3;-3,-3,-3]; %ģ��2
W{1,3}=[5,-3,-3;5,0,-3;5,-3,-3]; %ģ��3
W{1,4}=[-3,-3,-3;5,0,-3;5,5,-3]; %ģ��4
W{1,5}=[-3,-3,-3;-3,0,-3;5,5,5]; %ģ��5
W{1,6}=[-3,-3,-3;-3,0,5;-3,5,5]; %ģ��6
W{1,7}=[-3,-3,5;-3,0,5;-3,-3,5]; %ģ��7
W{1,8}=[-3,5,5;-3,0,5;-3,-3,-3]; %ģ��8
for hh=1:8
    I{1,hh}=filter2(W{1,hh},Denoi_Image);
    I{1,hh}=im2bw(I{1,hh},graythresh(I{1,hh}));
end
I9=I{1,1}|I{1,2}|I{1,3}|I{1,4}|I{1,5}|I{1,6}|I{1,7}|I{1,8};
% figure;imshow(I9);
% title('Kirsch�ָ�ͼ��1');

se = strel('disk',1); %������̬ѧ�ṹԪ�أ���̬ѧģ��disk��״��
I9=imerode(I9,se);%��ʴ����
I9 = imclose(I9,se);%������
% figure;imshow(I9);title('Kirsch�ָ�ͼ��2');

 
%% ����OR�����϶�ֵ��ͼ��ͱ�Ե��Ϣ
ROI_Seg=ROI_edge_canny|I9;%|binary_Image;%���ж���߽���ȡ����ġ����߼�����
% figure;imshow(ROI_Seg);title('����ָ�ͼ��1');
ROI_Seg=ROI_edge_canny|I9|binary_Image;%���ж���߽���ȡ����ġ����߼�����
% figure;imshow(ROI_Seg);title('����ָ�ͼ��2');
 
se = strel('disk',3); %���ͽṹԪ��
Fina_Seg = imclose(ROI_Seg,se);%������
Fina_Seg=bwmorph(Fina_Seg,'remove');%�Ƴ����ĵ�����ʹ�����Ϊϸ��״�ı߽�
% figure;imshow(Fina_Seg);
% title('��̬ѧ���� �Ƴ�');

%Fina_Seg = imfill(Fina_Seg,8,'holes');
Fina_Seg = imfill(Fina_Seg,4,'holes');%������������䷽ʽ���׶�
% figure;imshow(Fina_Seg);
% title('�׶����');

%% �Զ�ֵͼ����ɸѡ
Fina_Seg=bwareaopen(Fina_Seg,100);%�Ƴ���ֵͼ�й�С�Ľṹ����С���ص��ſ飩
Fina_Seg=bwmorph(Fina_Seg,'spur',8);%�Ƴ�����㣬�����matlabhelp����
Fina_Seg=bwmorph(Fina_Seg,'clean');%�Ƴ���ͨ����Ϊ0�Ĺ�����
% figure;imshow(Fina_Seg);title('����');

%% ��ǩ����ֵͼ����¼�ָ�����
[Lab_Image1, XNum]=bwlabeln(Fina_Seg,4);%���ͼ��Lab_Image1���������ĸ���XNum�������4��ʾ������ʽ
% Lab_Image=Lab_Image1(3:end-3,3:end-3);
[m1,n1]=size(Lab_Image1);
stats=regionprops(Lab_Image1,'all');%�������������
%figure;imshow(Lab_Image1);title('��ǩ��');
 
RGBX=label2rgb(Lab_Image1,@jet,'k');
%figure;imshow(RGBX);title('��ɫ��ǩ��ͼ��');%����Ĳ�ɫ��ǩ��ͼ�������Ϊ����ʾ����һ��αɫ�ʴ������Է�ӳ��label��������еļ���˳��
 
[L_BW,NUM]=bwlabel(Fina_Seg,4);
figure;imshow(L_BW);
stats=regionprops(L_BW,'all');%����regionprops����¼������labe���ͼ���ڵķָ���Ϣ��statsͨ��sturct�����boundingbox�������Ϣ���������ݺܶ࣬�����˽���˼���ɡ�

%% �˳���Ϊ��һ���Ż�ɸѡ��ͬʱ��ԭͼ�п��������ϸ������
figure;imshow(Col_Image);%��ʾԭͼ��������ͼʹ��

for i=1:NUM %�����num��ʾ����ͨ��bwlabel��ɸѡ������ϸ������
    [r,c]=find(L_BW==i);%��ֵͼL_BW���Ѿ�����˳�����˷ָ�������ͬ�ķָ�������ֵ��Ϊ��Ӧ��label���֡�r��c�ֱ��¼��Ӧ��ԭͼ�ڵ�λ��
    S(i)=stats(i).Area;%���򣬼�¼�����������ص�ĸ���
    L(i)=stats(i).Perimeter;%������ܳ�
    C(i)=(L(i)*L(i)) /(4*pi*S(i));%���Ƽ���ƽ���ܶ������ʽ�����Ͻ���⣩
  %   if 600<stats(i).Area && stats(i).Area<5000  %  ���������һЩ������һ���ϸ���ͻ�Ȧ��������
  if 1200<S(i)&& S(i)<5900 %����ΪһЩɸѡ������ɸ����Сϸ��������һ��Ĵ��ſ�ĸ��š�
  if 100<L(i)&& L(i)<300
  if 0.8<C(i)&& C(i)<1.8
% if   C(i)>1.5
    % ������ݷָ��������㻭���ο�Ĵ�С
    rmin=min(r);rmax=max(r);
    cmin=min(c);cmax=max(c);
    w=cmax-cmin+1;
    h=rmax-rmin+1;
    hold on
    if (h>w && 1.5*w>h) || (w>h && 1.5*h>w)||(w==h)
%         if (h>w && 1.5*w<h) || (w>h && 1.5*h<w) 
        rectangle('Position',[cmin,rmin,w,h]);%��һ��������
        drawnow;%�������λ��ڴ򿪵�figure��ԭͼ��
    end 
  end                                       
    end
  end
end
end

