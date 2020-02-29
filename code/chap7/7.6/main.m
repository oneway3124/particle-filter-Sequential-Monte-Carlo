%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 版权声明：
%     本程序的详细中文注释请参考
%     黄小平，王岩，缪鹏程.粒子滤波原理及应用[M].电子工业出版社，2017.4
%     书中有原理介绍+例子+程序+中文注释
%     如果此程序有错误，请对提示修改
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%说明：运用PF算法处理闪烁噪声情况下的雷达目标跟踪问题。
%     设目标作匀速直线运动，雷达位于(x0,y0)．
%     状态方程为:X(k)=PHI*X(k-1)+G*w(k-1);
%     雷达观测方程为:Z(k)=h(X(k))+v(k);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function main
 
M=100;                  
T=1;   
N=100;                  
number=10;             
x0=50000;y0=50000;vx=300;vy=-100;  
delta_w=0.1;           
delta_r=50;            
delta_theta1=1*pi/180;   
delta_theta2=5*pi/180;   
eta=0.3;                
Q=delta_w^2*eye(2);                
R1=diag([delta_r^2,delta_theta1^2]);
R2=diag([delta_r^2,delta_theta2^2]);
R=(1-eta)*R1+eta*R2;               
G=[T^2/2,0;T,0;0,T^2/2;0,T];
 
X=zeros(4,M);
Z=zeros(2,M);
Xn=zeros(2,M);
w=sqrtm(Q)*randn(2,M);
v=sqrtm(R)*randn(2,M);
X(:,1)=[x0,vx,y0,vy]'; 
Z(:,1)=feval('hfun',X(:,1),x0,y0)+v(:,1);
Xn(:,1)=ffun(Z(:,1),x0,y0);
for t=2:M
    X(:,t)=feval('sfun',X(:,t-1),T)+G*w(:,t); 
    Z(:,t)=feval('hfun',X(:,t),x0,y0)+v(:,t);
    Xn(:,t)=ffun(Z(:,t),x0,y0); 
end
 
Xmean_pf=zeros(number,4,M);
for i=1:number
    Xmean_pf(i,:,1)=X(:,1)+randn(4,1);
end
 
for j=1:number
 
    Xparticle_pf=zeros(4,M,N);
    XparticlePred_pf=zeros(4,M,N);
    zPred_pf=zeros(2,M,N);
    weight=zeros(M,N);   
    for i=1:N
        Xparticle_pf(:,1,i)=[x0,vx,y0,vy]'+20*randn(4,1);
    end
    ww=randn(2,M);
    for t=2:M
        for i=1:N
            XparticlePred_pf(:,t,i)=feval('sfun',Xparticle_pf(:,t-1,i),T)...
                +G*sqrtm(Q)*ww(:,t-1);
        end
        for i=1:N
            zPred_pf(:,t,i)=feval('hfun',XparticlePred_pf(:,t,i),x0,y0);
            weight(t,i)=(1-eta)*inv(sqrt(2*pi*det(R1)))*exp(-.5*(Z(:,t)...
                -zPred_pf(:,t,i))'*inv(R1)*(Z(:,t)-zPred_pf(:,t,i)))...
                +eta*inv(sqrt(2*pi*det(R2)))*exp(-.5*(Z(:,t)-...
                zPred_pf(:,t,i))'*inv(R2)*(Z(:,t)-zPred_pf(:,t,i)))...
                + 1e-99; 
        end
        weight(t,:)=weight(t,:)./sum(weight(t,:)); 
        outIndex = randomR(1:N,weight(t,:)');          
        Xparticle_pf(:,t,:) = XparticlePred_pf(:,t,outIndex); 
 
        mx=mean(Xparticle_pf(1,t,:));
        my=mean(Xparticle_pf(3,t,:));
        mvx=mean(Xparticle_pf(2,t,:));
        mvy=mean(Xparticle_pf(4,t,:));
        Xmean_pf(j,:,t)=[mx,mvx,my,mvy]';
    end
end
 
Xpf=zeros(4,M);
for k=1:M
    Xpf(:,k)=[mean(Xmean_pf(:,1,k)),mean(Xmean_pf(:,2,k)),...
        mean(Xmean_pf(:,3,k)),mean(Xmean_pf(:,4,k))]';
end
 
Div_Of_Xpf_X=Xpf-X;
 
for k=1:M
    sumX=zeros(4,1);
    for j=1:number
        sumX=sumX+(Xmean_pf(j,:,k)'-X(:,k)).^2;
    end
    RMSE(:,k)=sumX/number;
    Div_Std_Xpf(:,k)=sqrt(RMSE(:,k)-Div_Of_Xpf_X(:,k).^2);
end
 figure(1);   
plot(X(1,:),X(3,:),'b',Xn(1,:),Xn(2,:),'g',Xpf(1,:),Xpf(3,:),'r');
legend('真实轨迹','观测轨迹','估计轨迹');
xlabel('X/m');ylabel('X/m');
figure(2);
subplot(2,2,1);plot(Div_Of_Xpf_X(1,:),'b');
ylabel('value/m');xlabel('(a) x方向位置估计误差均值曲线');
subplot(2,2,2);plot(Div_Of_Xpf_X(2,:),'b');
ylabel('value');xlabel('(b) x方向速度估计误差均值曲线');
subplot(2,2,3);plot(Div_Of_Xpf_X(3,:),'b');
ylabel('value/m');xlabel('(c) y方向位置估计误差均值曲线');
subplot(2,2,4);plot(Div_Of_Xpf_X(4,:),'b');
ylabel('value');xlabel('(d) y方向速度估计误差均值曲线');
figure(3);
subplot(2,2,1);plot(Div_Std_Xpf(1,:),'b');
ylabel('value');xlabel('(a) x方向位置估计误差标准差曲线');
subplot(2,2,2);plot(Div_Std_Xpf(2,:),'b');
ylabel('value');xlabel('(b) x方向速度估计误差标准差曲线');
subplot(2,2,3);plot(Div_Std_Xpf(3,:),'b');
ylabel('value');xlabel('(c) y方向位置估计误差标准差曲线');
subplot(2,2,4);plot(Div_Std_Xpf(4,:),'b');
ylabel('value');xlabel('(d) y方向速度估计误差标准差曲线');
figure(4);
subplot(2,2,1);plot(RMSE(1,:),'b');
ylabel('value');xlabel('(a) x方向位置估计误差均方根曲线');
subplot(2,2,2);plot(RMSE(2,:),'b');
ylabel('value');xlabel('(b) x方向速度估计误差均方根曲线');
subplot(2,2,3);plot(RMSE(3,:),'b');
ylabel('value');xlabel('(c) y方向位置估计误差均方根曲线');
subplot(2,2,4);plot(RMSE(4,:),'b');
ylabel('value');xlabel('(d) y方向速度估计误差均方根曲线');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

