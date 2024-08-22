function [PN,channelInput2]=Canshu(Npn,modData,m)%输出PN序列(转为双极性之后的)、BPSK调制后的数据
%% 参数
K=720;%每个pn序列的长度255
% Npn=4;%%一共N段pn序列
guard_length=24;%保护序列长度

%% Guard保护序列
guard=zeros(1,guard_length);
%% ofdma调制后的数据帧

%% PN序列生成
h = commsrc.pn('GenPoly',[9 5 0],'NumBitsOut',K);%长度：510  [9 5 0]
Hpn=generate(h);

datain=ones(Npn,1)*Hpn';%多重pn序列

Datain=reshape(datain',[],1);

Datain_G= [guard';Datain];%%%加入保护序列+有用数据
%% BPSK调制
% pskModulator = comm.PSKModulator('ModulationOrder',4,'PhaseOffset',pi/4);
% channelInput = step(pskModulator,Datain_G);
channelInput = Modulator(Datain_G,m);

%PN= step(pskModulator,Hpn);
PN= Modulator(Hpn,m);
% scatterplot(channelInput)%show

channelInput2=[channelInput;modData;guard'];

% lengthchannelInput=length(channelInput2)%show

