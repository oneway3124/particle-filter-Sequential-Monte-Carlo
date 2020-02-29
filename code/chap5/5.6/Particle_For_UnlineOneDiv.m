%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 版权声明：
%     本程序的详细中文注释请参考
%     黄小平，王岩，缪鹏程.粒子滤波原理及应用[M].电子工业出版社，2017.4
%     书中有原理介绍+例子+程序+中文注释
%     如果此程序有错误，请对提示修改
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 基本粒子滤波的一维系统仿真实例
% 状态方程：x(k)=0.5x(k-1)+2.5x(k-1)/(1+x(k-1)^2)+8cos(1.2k) + w(k)
% 观测方程：z(k)=x(k)^2/20 + v(k)
function Particle_For_UnlineOneDiv
 
randn('seed',1);    
 error('下面的参数T请参考书中的值设置，然后删除本行代码')
T =0;                
dt=1;                  
Q=10;                 
R=1;                    
v=sqrt(R)*randn(T,1);  
w=sqrt(Q)*randn(T,1);   
numSamples=100;         
ResampleStrategy=2;     
 
x0=0.1;                
 
X=zeros(T,1);          
Z=zeros(T,1);          
X(1,1)=x0;             
Z(1,1)=(X(1,1)^2)./20 + v(1,1); 
for k=2:T
 
    X(k,1)=0.5*X(k-1,1) + 2.5*X(k-1,1)/(1+X(k-1,1)^(2))...
        + 8*cos(1.2*k)+ w(k-1,1);
 
    Z(k,1)=(X(k,1).^(2))./20 + v(k,1);
end
 
Xpf=zeros(numSamples,T);      
Xparticles=zeros(numSamples,T);  
Zpre_pf=zeros(numSamples,T);   
weight=zeros(numSamples,T);     
 
Xpf(:,1)=x0+sqrt(Q)*randn(numSamples,1);
Zpre_pf(:,1)=Xpf(:,1).^2/20;
 
for k=2:T
    
    for i=1:numSamples
        QQ=Q;    
        net=sqrt(QQ)*randn;  
        Xparticles(i,k)=0.5.*Xpf(i,k-1) + 2.5.*Xpf(i,k-1)./(1+Xpf(i,k-1).^2)...
            + 8*cos(1.2*k) + net;
    end
     
    for i=1:numSamples
        Zpre_pf(i,k)=Xparticles(i,k)^2/20;
        weight(i,k)=exp(-.5*R^(-1)*(Z(k,1)- Zpre_pf(i,k))^2); 
    weight(:,k)=weight(:,k)./sum(weight(:,k)); 
 
    if ResampleStrategy==1
        outIndex = randomR(weight(:,k));  
    elseif ResampleStrategy==2
        outIndex = residualR(weight(:,k)');  
    elseif ResampleStrategy==3
        outIndex = systematicR(weight(:,k)'); 
    elseif ResampleStrategy==4
        outIndex = multinomialR(weight(:,k));  
     
    Xpf(:,k)= Xparticles(outIndex,k);
    end
 
Xmean_pf=mean(Xpf);  
bins=20;
Xmap_pf=zeros(T,1);
for k=1:T
    [p,pos]=hist(Xpf(:,k,1),bins);
    map=find(p==max(p));
    Xmap_pf(k,1)=pos(map(1));  
end
for k=1:T
    Xstd_pf(1,k)=std(Xpf(:,k)-X(k,1)); 
end
 
figure(1);clf;  
subplot(221);
plot(v);   
xlabel('时间');
ylabel('测量噪声','fontsize',15);
subplot(222);
plot(w);    
xlabel('时间');
ylabel('过程噪声','fontsize',15);
subplot(223);
plot(X);   
xlabel('时间','fontsize',15);
ylabel('状态X','fontsize',15);
subplot(224);
plot(Z);   
xlabel('时间','fontsize',15);
ylabel('观测Z','fontsize',15);
 
figure(2);clf;  
k=1:dt:T;
plot(k,X,'b',k,Xmean_pf,'r',k,Xmap_pf,'g'); 
legend('系统真实状态值','后验均值估计','最大后验概率估计');
xlabel('时间','fontsize',15);
ylabel('状态估计','fontsize',15);
 
figure(3);
subplot(121);
plot(Xmean_pf,X,'+');  
xlabel('后验均值估计','fontsize',15);
ylabel('真值','fontsize',15)
hold on;
c=-25:1:25;
plot(c,c,'r');  
axis([-25 25 -25 25]);
hold off;
subplot(122);  
plot(Xmap_pf,X,'+')
ylabel('真值','fontsize',15)
xlabel('MAP估计','fontsize',15)
hold on;
c=-25:1:25;
plot(c,c,'r');  
axis([-25 25 -25 25]);
hold off;
 
domain=zeros(numSamples,1);
range=zeros(numSamples,1);
bins=10;
support=[-20:1:20];
figure(4);hold on; 
xlabel('样本空间','fontsize',15);
ylabel('时间','fontsize',15);
zlabel('后验密度','fontsize',15);
vect=[0 1];
caxis(vect);
for k=1:T
  
    [range,domain]=hist(Xpf(:,k),support);
   
    waterfall(domain,k,range);
end
axis([-20 20 0 T 0 100]);
 
figure(5);
hold on; box on;
xlabel('样本空间','fontsize',15);
ylabel('后验密度','fontsize',15); 
k=30;   
[range,domain]=hist(Xpf(:,k),support);
plot(domain,range);
 
XXX=[X(k,1),X(k,1)];
YYY=[0,max(range)+10]
line(XXX,YYY,'Color','r');
axis([min(domain) max(domain) 0 max(range)+10]);
 
figure(6);  
k=1:dt:T;
plot(k,Xstd_pf,'-');
xlabel('时间（t/s）');ylabel('状态估计误差标准差');
axis([0,T,0,10]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

