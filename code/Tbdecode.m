function y = Tbdecode(data,Indices)
%UNTITLED2 此处提供此函数的摘要
%   此处提供详细说明
persistent TurboDecoder;
Trellis=poly2trellis(4, [13 15], 13);
TurboDecoder=comm.TurboDecoder(...
        'TrellisStructure',Trellis,...
        'InterleaverIndices',Indices,...
        'NumIterations',8);

y = TurboDecoder.step(-data);
reset(TurboDecoder);