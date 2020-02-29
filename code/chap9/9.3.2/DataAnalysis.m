%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 版权声明：
%     本程序的详细中文注释请参考
%     黄小平，王岩，缪鹏程.粒子滤波原理及应用[M].电子工业出版社，2017.4
%     书中有原理介绍+例子+程序+中文注释
%     如果此程序有错误，请对提示修改
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 功能说明：数据分析程序
function DataAnalysis
 
load Xstate;
load Zdist;
load Xpf;
 
T1=length(Xstate(1,:));
T2=length(Zdist(1,:));
T=min(T1,T2);
for k=1:T
    Dev_PF(1,k)=sqrt( (Xpf(1,k)-Xstate(1,k))^2+(Xpf(3,k)-Xstate(3,k))^2 );
end
 
figure  
hold on;box on;
plot(Xstate(1,:),Xstate(3,:),'-b.');
plot(Xpf(1,:),Xpf(3,:),'-r+');
legend('true','pf');
xlabel('X/m');ylabel('Y/m');

figure  
hold on;box on;
plot(Dev_PF,'-ko','MarkerFace','g');
xlabel('Time/s');ylabel('Value of the Deviation/m');
figure  
subplot(121);hold on;box on;
plot(Xstate(2,:),'-k.')
plot(Xpf(2,:),'-r+');
axis([0 T 9 11]);
subplot(122);hold on;box on;
plot(Xstate(4,:),'-k.')
plot(Xpf(4,:),'-r+');
axis([0 T 9 11]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%