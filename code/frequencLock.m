function [f_averge,dataout]=frequencLock(Data_atertimelock,Datain_PN,Npn,K,Ts)%%%%�������ݣ�datain,Ƶ��ͬ��ʹ��PN���и���
cont=1:length(Data_atertimelock);
%% ����PN���н��л����

%pure_pn=aw_out(guard_length+1:(end-guard_length));%��ȥ����������ȡpn����
pure_PN=reshape(Datain_PN,[],Npn);%����ΪNpn��pn����

pure_PN_c=conj(pure_PN);%����

for i=1:Npn-1
    P(:,i)=pure_PN(:,i).*pure_PN_c(:,i+1);
end

PP=sum(P);
T=K.*Ts;
f=(2*pi*T).^(-1).*(atan2(imag(PP),real(PP)));

f_averge=mean(f);%%%���Ƶ�Ƶƫ

%% ����ƵƫӰ��
phase_pian_xiao = -2j*pi*f_averge.*Ts.*cont;%%��Ƶƫ���飺phase_pian = 2j*pi*fd.*Ts.*cont*0
dataout=Data_atertimelock.*exp(phase_pian_xiao');
% scatterplot(dataout);
% 
% 
% %% ��֤��BPSK�����������
% pskDemodulator = comm.PSKDemodulator('ModulationOrder',2,'PhaseOffset',0);
% data_FINI = step(pskDemodulator,dataout);
% 
% errorRate = comm.ErrorRate;
% 
% %   rxData = pskDemodulator(rxSig);
%         % Collect the error statistics
%         errVec = errorRate(data_FINI,Datain_G);
% 


