function [f_averge,dataout]=frequencLock(Data_atertimelock,Datain_PN,Npn,K,Ts)%%%%传入数据：datain,频率同步使用PN序列个数
cont=1:length(Data_atertimelock);
%% 相邻PN序列进行互相关

%pure_pn=aw_out(guard_length+1:(end-guard_length));%除去保护序列提取pn序列
pure_PN=reshape(Datain_PN,[],Npn);%重组为Npn个pn序列

pure_PN_c=conj(pure_PN);%共轭

for i=1:Npn-1
    P(:,i)=pure_PN(:,i).*pure_PN_c(:,i+1);
end

PP=sum(P);
T=K.*Ts;
f=(2*pi*T).^(-1).*(atan2(imag(PP),real(PP)));

f_averge=mean(f);%%%估计的频偏

%% 消除频偏影响
phase_pian_xiao = -2j*pi*f_averge.*Ts.*cont;%%无频偏检验：phase_pian = 2j*pi*fd.*Ts.*cont*0
dataout=Data_atertimelock.*exp(phase_pian_xiao');
% scatterplot(dataout);
% 
% 
% %% 验证：BPSK解调，误码率
% pskDemodulator = comm.PSKDemodulator('ModulationOrder',2,'PhaseOffset',0);
% data_FINI = step(pskDemodulator,dataout);
% 
% errorRate = comm.ErrorRate;
% 
% %   rxData = pskDemodulator(rxSig);
%         % Collect the error statistics
%         errVec = errorRate(data_FINI,Datain_G);
% 


