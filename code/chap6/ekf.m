%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 版权声明：
%     本程序的详细中文注释请参考
%     黄小平，王岩，缪鹏程.粒子滤波原理及应用[M].电子工业出版社，2017.4
%     书中有原理介绍+例子+程序+中文注释
%     如果此程序有错误，请对提示修改
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Xekf,Pout]=ekf(Xin,Z,Pin,t,Qekf,Rekf)

Xpre=feval('ffun',Xin,t);
Jx=0.5;
 
Pekfpre = Qekf + Jx*Pin*Jx';
 
Zekfpre= feval('hfun',Xpre,t);
 
if t<=30
    Jy = 2*0.2*Xpre;
else
    Jy = 0.5;
end
 
M = Rekf + Jy*Pekfpre*Jy';
 
K = Pekfpre*Jy'*inv(M);
 
 
Xekf=Xpre+K*(Z-Zekfpre);
 
 
Pout = Pekfpre - K*Jy*Pekfpre;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
