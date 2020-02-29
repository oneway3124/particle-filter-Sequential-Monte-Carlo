%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 版权声明：
%     本程序的详细中文注释请参考
%     黄小平，王岩，缪鹏程.粒子滤波原理及应用[M].电子工业出版社，2017.4
%     书中有原理介绍+例子+程序+中文注释
%     如果此程序有错误，请对提示修改
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 用UKF改进的粒子滤波算法--EPF
% 用UKF产生建议分布
% 输入参数说明：
%    Xiset是上t-1时刻的粒子集合，Z是t时刻的观测
%    Pin对应Xiset粒子集合的方差\
% 输出参数说明：
%    Xo是upf算法最终的估计结果
%    Xoset是k时刻的粒子集合，其均值就是Xo
%    Pout是Xoset对应的方差
function [Xo,Xoset,Pout]=upf(Xiset,Z,t,Pin,N,R,Qukf,Rukf,g1,g2)
 
resamplingScheme=1;

 
Xukf=ones(1,N);     
Xset_pre=ones(1,N);  
Zpre=ones(1,N); 
for i=1:N
 
    [Xukf(i),Pout(i)]=ukf(Xiset(i),Z,Pin(i),Qukf,Rukf,t);
  
    Xset_pre(i) = Xukf(i) + sqrtm(Pout(i))*randn;
end

 
for i=1:N
 
    Zpre(i) = feval('hfun',Xset_pre(i),t);
 
    lik = inv(sqrt(R)) * exp(-0.5*inv(R)*((Z-Zpre(i))^(2)))+1e-99;
    prior = ((Xset_pre(i)-Xiset(i))^(g1-1)) * exp(-g2*(Xset_pre(i)-Xiset(i)));
    proposal = inv(sqrt(Pout(i))) * ...
        exp(-0.5*inv(Pout(i)) *((Xset_pre(i)-Xukf(i))^(2)));
    w(i) = lik*prior/proposal;
end;
 
w = w./sum(w);

 
if resamplingScheme == 1
    outIndex = residualR(1:N,w');        
elseif resamplingScheme == 2
    outIndex = systematicR(1:N,w');      
else
    outIndex = multinomialR(1:N,w');     
end;

 
Xoset = Xset_pre(outIndex);  
Pout = Pout(outIndex);     
 
Xo = mean(Xoset);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


