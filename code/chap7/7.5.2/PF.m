%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 版权声明：
%     本程序的详细中文注释请参考
%     黄小平，王岩，缪鹏程.粒子滤波原理及应用[M].电子工业出版社，2017.4
%     书中有原理介绍+例子+程序+中文注释
%     如果此程序有错误，请对提示修改
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Xout,Tpf]=PF(Z,NodePostion,canshu)
  
M=canshu.M;
Q=canshu.Q;
R=canshu.R;
F=canshu.F;
T=canshu.T;
state0=canshu.state0;
Node_number=canshu.Node_number;
 
N=100;       
zPred=zeros(1,N);
Weight=zeros(1,N);
xparticlePred=zeros(4,N);
Xout=zeros(4,M);
Xout(:,1)=state0;
Tpf=zeros(1,M);
for i=1:Node_number
    xparticle{i}=zeros(4,N);
    for j=1:N    
        xparticle{i}(:,j)=state0;
    end
    Xpf{i}=zeros(4,N);
    Xpf{i}(:,1)=state0;
end
 
for t=2:M
    tic;
    XX=0;
    for i=1:Node_number
        x0=NodePostion(1,i);
        y0=NodePostion(2,i);
 
        for k=1:N
            xparticlePred(:,k)=feval('sfun',xparticle{i}(:,k),T,F)+5*sqrtm(Q)*randn(4,1);
        end
 
        for k=1:N
            zPred(1,k)=feval('hfun',xparticlePred(:,k),x0,y0);
            z1=Z(i,t)-zPred(1,k);
            Weight(1,k)=inv(sqrt(2*pi*det(R)))*exp(-.5*(z1)'*inv(R)*(z1))+ 1e-99; 
        end
 
        Weight(1,:)=Weight(1,:)./sum(Weight(1,:));
 
        outIndex = randomR(1:N,Weight(1,:)');        
        xparticle{i}= xparticlePred(:,outIndex);  
        target=[mean(xparticle{i}(1,:)),mean(xparticle{i}(2,:)),...
            mean(xparticle{i}(3,:)),mean(xparticle{i}(4,:))]';
        Xpf{i}(:,t)=target;
      
        XX=XX+Xpf{i}(:,t);
    end
    Xout(:,t)=XX/Node_number;
    Tpf(1,t)=toc;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
