%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 版权声明：
%     本程序的详细中文注释请参考
%     黄小平，王岩，缪鹏程.粒子滤波原理及应用[M].电子工业出版社，2017.4
%     书中有原理介绍+例子+程序+中文注释
%     如果此程序有错误，请对提示修改
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 功能说明：在图像上散列均匀分布白噪声点
function genUnifNoise
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%error('下面的参数N请参考书中的值设置，然后删除本行代码')
N=0;           
x=zeros(1,N);    
y=zeros(1,N);      
image=imread('baby.jpg');    
imageNew=image;               
imageSize=imresize(image,1); 
[height width channel]=size(imageSize);  
for k=1:N;
   
    x(k)=ceil(unifrnd(0,height));
    y(k)=ceil(unifrnd(0,width));
    for i=1:channel
      
        imageNew(x(k),y(k),i)=255;
    end
end
figure  
subplot(1,2,1);
imshow(image);  
axis([0 width 0 height]);
subplot(1,2,2);
imshow(imageNew);  
axis([0 width 0 height]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%