%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 版权声明：
%     本程序的详细中文注释请参考
%     黄小平，王岩，缪鹏程.粒子滤波原理及应用[M].电子工业出版社，2017.4
%     书中有原理介绍+例子+程序+中文注释
%     如果此程序有错误，请对提示修改
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 功能说明：S函数仿真系统的状态方程X(k+1)=F*x(k)+G*w(k)
function [sys,x0,str,ts]=SimuStateFunction(t,x,u,flag)
global Xstate;
switch flag
    case 0   
        [sys,x0,str,ts]=mdlInitializeSizes;
    case 2  
        sys=mdlUpdate(t,x,u);
    case 3  
        sys=mdlOutputs(t,x,u);
    case {1,4}
        sys=[];
    case 9    
        save('Xstate','Xstate');
    otherwise  
        error(['Unhandled flag = ',num2str(flag)]);
end
 
function [sys,x0,str,ts]=mdlInitializeSizes
sizes = simsizes;
sizes.NumContStates  = 0;   
sizes.NumDiscStates  = 4;   
sizes.NumOutputs     = 4;   
sizes.NumInputs      = 2;    
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 1;   
sys = simsizes(sizes);
x0  = [10,10,12,10]';            
str = [];             
ts  = [-1 0];  
global Xstate;
Xstate=[];
Xstate=[Xstate,x0];
 
function sys=mdlUpdate(t,x,u)
G=[0.5,0;1,0;0,0.5;0,1];
F=[1,1,0,0;0,1,0,0;0,0,1,1;0,0,0,1];
x_next=F*x+G*u;
sys=x_next;
global Xstate;
Xstate=[Xstate,x_next];
 
function sys=mdlOutputs(t,x,u)
sys = x; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
