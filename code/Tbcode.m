function [bits] = Tbcode(datain,Indices)
%UNTITLED2 此处提供此函数的摘要
%   此处提供详细说明
persistent TurboEncoder;
Trellis = poly2trellis(4, [13 15], 13);

TurboEncoder=comm.TurboEncoder(...
        'TrellisStructure',Trellis,...
        'InterleaverIndices',Indices);
bits  = TurboEncoder.step(datain);
reset(TurboEncoder);