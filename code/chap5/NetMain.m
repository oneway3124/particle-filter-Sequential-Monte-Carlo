%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 版权声明：
%     本程序的详细中文注释请参考
%     黄小平，王岩，缪鹏程.粒子滤波原理及应用[M].电子工业出版社，2017.4
%     书中有原理介绍+例子+程序+中文注释
%     如果此程序有错误，请对提示修改
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 粒子集合半径问题
function NetMain

x0=5;
y0=5;
r1=2;
r2=4;
Net=4;  
error('下面的参数N请参考书中的值设置，然后删除本行代码')
N=0;  
for i=1:N
    X(i)=x0+sqrt(Net)*randn;
    Y(i)=y0+sqrt(Net)*randn;
end
 
figure
hold on;box on;
 
plot(X,Y,'k+');
 
plot(x0,y0,'ko','MarkerFaceColor','g')
 
sita=0:pi/20:2*pi;
plot(x0+r1*cos(sita),y0+r1*sin(sita),'Color','r','LineWidth',5);  
plot(x0+r2*cos(sita),y0+r2*sin(sita),'Color','b','LineWidth',5); 
axis([0,10,0,10]);
 
figure
support=-10:1:20
[range,domain]=hist(X,support);  
subplot(121)
plot(domain,range,'r-');
xlabel('X样本域')
ylabel('密度')
subplot(122)
[range,domain]=hist(Y,support);   
plot(domain,range,'b-');
xlabel('Y样本域')
ylabel('密度')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
