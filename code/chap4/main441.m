%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 版权声明：
%     本程序的详细中文注释请参考
%     黄小平，王岩，缪鹏程.粒子滤波原理及应用[M].电子工业出版社，2017.4
%     书中有原理介绍+例子+程序+中文注释
%     如果此程序有错误，请对提示修改
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 文件名称：main441.m
% 功能说明：用蒙特卡洛方法计算圆周率π
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function main441
 error('下面的参数N请参考书中的值设置，然后删除本行代码')
N=0;
 
needles=1000;
 
length=0.6;  
 
PAI=zeros(1,N);
 
for k=1:N
 
    PAI(k)=buffon(length,needles);   
end
 
PAI_ave=mean(PAI)
 
figure 
hold on;
box on;
plot(PAI);
 
line([0,N],[PAI_ave,PAI_ave],'LineWidth',5,'Color','r');
xlabel('k');
ylabel('π的估计值');
 
function pai=buffon(length,N)
frq=0; 
for k=1:N
  
    d=unifrnd(0,0.5);
  
    cita=unifrnd(0,pi);
 
    if (d <= (length*sin(cita)/2) )
        frq=frq+1;  
    end    
end 
 
p=frq/N;
 
pai=2*length/p;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
