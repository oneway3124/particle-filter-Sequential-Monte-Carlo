%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 版权声明：
%     本程序的详细中文注释请参考
%     黄小平，王岩，缪鹏程.粒子滤波原理及应用[M].电子工业出版社，2017.4
%     书中有原理介绍+例子+程序+中文注释
%     如果此程序有错误，请对提示修改
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  函数功能：粒子滤波用于电源寿命预测
function main
 
load Battery_Capacity
N=length(A12Cycle); 
error('下面的参数M请参考书中的值设置，然后删除本行代码')
M=0;  
Future_Cycle=100; 
if N>260
    N=260;   
end
 
cita=1e-4
wa=0.000001;wb=0.01;wc=0.1;wd=0.0001;
Q=cita*diag([wa,wb,wc,wd]);
 
F=eye(4);
 
R=0.001;
 
a=-0.0000083499;b=0.055237;c=0.90097;d=-0.00088543;
X0=[a,b,c,d]';
 
Xpf=zeros(4,N);
Xpf(:,1)=X0;
 
Xm=zeros(4,M,N);
for i=1:M
    Xm(:,i,1)=X0+sqrtm(Q)*randn(4,1);
end
 
Z(1,1:N)=A12Capacity(1:N,:)';
 
Zm=zeros(1,M,N);
 
Zpf=zeros(1,N);
 
W=zeros(N,M);
 
for k=2:N
  
    for i=1:M
        Xm(:,i,k)=F*Xm(:,i,k-1)+sqrtm(Q)*randn(4,1);
    end
 
    for i=1:M
   
        Zm(1,i,k)=feval('hfun',Xm(:,i,k),k);
       
        W(k,i)=exp(-(Z(1,k)-Zm(1,i,k))^2/2/R)+1e-99;
    end
 
    W(k,:)=W(k,:)./sum(W(k,:));
  
    outIndex = residualR(1:M,W(k,:)');        
     
    Xm(:,:,k)=Xm(:,outIndex,k);
 
    Xpf(:,k)=[mean(Xm(1,:,k));mean(Xm(2,:,k));mean(Xm(3,:,k));mean(Xm(4,:,k))];
    
    Zpf(1,k)=feval('hfun',Xpf(:,k),k);
end
 
start=N-Future_Cycle
for k=start:N
    Zf(1,k-start+1)=feval('hfun',Xpf(:,start),k);
    Xf(1,k-start+1)=k;
end
 
Xreal=[a*ones(1,M);b*ones(1,M);c*ones(1,M);d*ones(1,M)];
figure
subplot(2,2,1);
hold on;box on;
plot(Xpf(1,:),'-r.');plot(Xreal(1,:),'-b.')
legend('粒子滤波后的a','平均值a')
subplot(2,2,2);
hold on;box on;
plot(Xpf(2,:),'-r.');plot(Xreal(2,:),'-b.')
legend('粒子滤波后的b','平均值b')
subplot(2,2,3);
hold on;box on;
plot(Xpf(3,:),'-r.');plot(Xreal(3,:),'-b.')
legend('粒子滤波后的c','平均值c')
subplot(2,2,4);
hold on;box on;
plot(Xpf(4,:),'-r.');plot(Xreal(4,:),'-b.')
legend('粒子滤波后的d','平均值d')
 
figure
hold on;box on;
plot(Z,'-b.')   
plot(Zpf,'-r.')  
plot(Xf,Zf,'-g.') 
bar(start,1,'y')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%






