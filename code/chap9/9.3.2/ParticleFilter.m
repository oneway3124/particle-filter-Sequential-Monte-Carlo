%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 版权声明：
%     本程序的详细中文注释请参考
%     黄小平，王岩，缪鹏程.粒子滤波原理及应用[M].电子工业出版社，2017.4
%     书中有原理介绍+例子+程序+中文注释
%     如果此程序有错误，请对提示修改
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 功能说明：基于观测距离，粒子滤波完成对目标状态估计
function [sys,x0,str,ts]=ParticleFilter(t,x,u,flag)
global Zdist;  
global Xpf;      
global Xpfset;  
randn('seed',20);
N=200;  
NETQ=diag([0.0001,0.0009]); 
 
NETR=0.01;
switch flag
    case 0  
        [sys,x0,str,ts]=mdlInitializeSizes(N);
    case 2  
        sys=mdlUpdate(t,x,u,N,NETQ,NETR);
    case 3   
        sys=mdlOutputs(t,x,u);
    case {1,4}
        sys=[];
    case 9   
        save('Xpf','Xpf');
        save('Zdist','Zdist');
    otherwise   
        error(['Unhandled flag = ',num2str(flag)]);
end
 
function [sys,x0,str,ts]=mdlInitializeSizes(N)
sizes = simsizes;
sizes.NumContStates  = 0;   
sizes.NumDiscStates  = 4;   
sizes.NumOutputs     = 4;    
sizes.NumInputs      = 1;   
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 1;    
sys = simsizes(sizes);
x0  = [10,10,12,10]';             
str = [];           
ts  = [-1 0];  
 
global Xpfset;
Xpfset=zeros(4,N);
for i=1:N
    Xpfset(:,i)=x0+0.1*randn(4,1);
end
global Zdist;   
Zdist=[];
global Xpf;     
Xpf=[x0];
 
function sys=mdlUpdate(t,x,u,N,NETQ,NETR)
global Zdist;  
global Xpf;
global Xpfset;  
Zdist=[Zdist,u];  
 
G=[0.5,0;1,0;0,0.5;0,1];
F=[1,1,0,0;0,1,0,0;0,0,1,1;0,0,0,1];
x0=0;y0=0;  
 
for i=1:N
    Xpfset(:,i)=F*Xpfset(:,i)+G*sqrt(NETQ)*randn(2,1);
end
 
for i=1:N
    zPred(1,i)=hfun(Xpfset(:,i),x0,y0);
    weight(1,i)=exp( -0.5*NETR^(-1)*( zPred(1,i)-u )^2 )+1e-99;
end
 
weight=weight./sum(weight);
 
outIndex=randomR(1:N,weight');
 
Xpfset=Xpfset(:,outIndex);
 
Xnew=[mean(Xpfset(1,:)),mean(Xpfset(2,:)),...
    mean(Xpfset(3,:)),mean(Xpfset(4,:))]';
 
Xpf=[Xpf,Xnew];
sys=Xnew;   
 
function sys=mdlOutputs(t,x,u)
sys = x;  
function d=hfun(X,x0,y0)
d=sqrt( (X(1)-x0)^2+(X(3)-y0)^2 );
 
function outIndex = randomR(inIndex,q)
outIndex=zeros(size(inIndex));
[num,col]=size(q);
u=rand(num,1);
u=sort(u);
l=cumsum(q);
i=1;
for j=1:num
    while (i<=num)&(u(i)<=l(j))
        outIndex(i)=j;
        i=i+1;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
