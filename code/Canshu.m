function [PN,channelInput2]=Canshu(Npn,modData,m)%���PN����(תΪ˫����֮���)��BPSK���ƺ������
%% ����
K=720;%ÿ��pn���еĳ���255
% Npn=4;%%һ��N��pn����
guard_length=24;%�������г���

%% Guard��������
guard=zeros(1,guard_length);
%% ofdma���ƺ������֡

%% PN��������
h = commsrc.pn('GenPoly',[9 5 0],'NumBitsOut',K);%���ȣ�510  [9 5 0]
Hpn=generate(h);

datain=ones(Npn,1)*Hpn';%����pn����

Datain=reshape(datain',[],1);

Datain_G= [guard';Datain];%%%���뱣������+��������
%% BPSK����
% pskModulator = comm.PSKModulator('ModulationOrder',4,'PhaseOffset',pi/4);
% channelInput = step(pskModulator,Datain_G);
channelInput = Modulator(Datain_G,m);

%PN= step(pskModulator,Hpn);
PN= Modulator(Hpn,m);
% scatterplot(channelInput)%show

channelInput2=[channelInput;modData;guard'];

% lengthchannelInput=length(channelInput2)%show

