%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 版权声明：
%     本程序的详细中文注释请参考
%     黄小平，王岩，缪鹏程.粒子滤波原理及应用[M].电子工业出版社，2017.4
%     书中有原理介绍+例子+程序+中文注释
%     如果此程序有错误，请对提示修改
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 功能说明：S函数计算输入信号，并输出距离信息
function [sys,x0,str,ts]=GetDistanceFunction(t,x,u,flag)
switch flag
    case 0   
        [sys,x0,str,ts]=mdlInitializeSizes;
    case 2  
        sys=mdlUpdate(t,x,u);
    case 3  
        sys=mdlOutputs(t,x,u);
    case {1,4,9}
        sys=[];
    otherwise    
        error(['Unhandled flag = ',num2str(flag)]);
end
 
function [sys,x0,str,ts]=mdlInitializeSizes
sizes = simsizes;
sizes.NumContStates  = 0;   
sizes.NumDiscStates  = 1;    
sizes.NumOutputs     = 1;    
sizes.NumInputs      = 2;    
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 1;    
sys = simsizes(sizes);
x0  = [0]';              
str = [];               
ts  = [-1 0];   
 
function sys=mdlUpdate(t,x,u)
x0=0;y0=0;  
d=sqrt( (u(1)-x0)^2+(u(2)-y0)^2 );
sys=d;   
 
function sys=mdlOutputs(t,x,u)
sys = x;  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
