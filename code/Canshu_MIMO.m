function [PN,channelInput2]=Canshu_MIMO(Npn,modData)%���PN����(תΪ˫����֮���)��BPSK���ƺ������
%% ����
global K
K=510;%ÿ��pn���еĳ���255
% Npn=4;%%һ��N��pn����
guard_length=20;%�������г���
beishu=10;
%% Guard��������
guard=zeros(1,guard_length);
%% ofdma���ƺ������֡
guard2=modData;

%% PN��������

%h = commsrc.pn('GenPoly',[9 5 0],'NumBitsOut',K);%���ȣ�255  [9 5 0] [8 6 5 4 0]
h = commsrc.pn('GenPoly',[9 5 0],'NumBitsOut',K);
Hpn=generate(h);

datain=ones(Npn,1)*Hpn';%����pn����

Datain=reshape(datain',[],1);
Datain_G=[guard';Datain];
for i=1:beishu-1
Datain_G= [guard';Datain_G];%%%���뱣������+��������
end
%% BPSK����
pskModulator = comm.PSKModulator('ModulationOrder',2,'PhaseOffset',0);
channelInput = step(pskModulator,Datain_G);

PN= step(pskModulator,Hpn);
% scatterplot(channelInput)%show

channelInput2tep=[channelInput;modData;guard'];
for i=1:beishu-1
channelInput2tep= [channelInput2tep;guard'];%%%���뱣������+��������
end
channelInput2=channelInput2tep;
% lengthchannelInput=length(channelInput2)%show

