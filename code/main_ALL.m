function main_ALL(modulation,delayValues,powerValues,jingzhen,ebn0,kongkou,visual_flag)
% pathDelays = [0 1.5e-6 4e-6 6e-6 9e-6];    % sec
%avgPathGains = [0 -3 -6 -9 -15];      % dB
delayValues=delayValues./1e6;
jingzhen=2000;
kongkou=kongkou./1e6;
%% Parameter

while(1)
    %参数设
    switch modulation
        case 1 
            m=2;
        case 2 
            m=2;
        case 3 
            m=4;
        case 4 
            m=16; 
        case 5 
            m=64;
    end
    % m = 4;%调制方式%2=>bpsk,4=>qpsk,16=>16QAM,64=>64QAM
    stp=4;%%%%导频间隔：5
    N_subcarrier=1602;%子载波数128,1024
    N_guard = 402;
    N_frame = 10;
    Npn=4;%%一共N段pn序列

    % delay = (2.5 + (5 - 2.5) * rand())*1e-6;%空口时延
    delay=kongkou;
    %fs = 2048*15e3;
    fs = 4e7;
    %EbNo = 0:10;
    EbNo = ebn0;%Ebn0=5
    data_length_psm  = 960;%每个ofdm符号上的数据量

    switch m
        case 2
            data_length = 4476;%每一帧的数据量      
        case 4
            data_length = 8956;%每一帧的数据量
        case 16
            data_length = 17916;
        case 64
            data_length = 26876;
    end

    R = data_length/(3*data_length + 12);
    k = log2(m);
    snr = EbNo + 10*log10(k) + 10*log10(R);
    noise_var = 10.^(-snr/10);

    arq_limit=10;

    %% 1.1构造ofdm数据帧包
    % 设置ofdm调制解调模块
    kk=1:stp+1:(N_subcarrier-N_guard);%(stp-1)/2:stp+1:1024;%当前间隔15
    mod = comm.OFDMModulator('FFTLength',2048,...
    'NumGuardBandCarriers',[0;N_guard],...
    'PilotInputPort',true, ...%是否加入导频
    'FFTLength',N_subcarrier,...
    'PilotCarrierIndices',[kk'], ...%加入导频的位置序列
    'NumSymbols',14, ...
    'CyclicPrefixLength',106,...%循环前缀的长度
    'InsertDCNull',false);

    demod = comm.OFDMDemodulator(mod);
    modDim = info(mod); 
    %showResourceMapping(mod)
    % showResourceMapping(mod)  %show
    % 生成数据datain，导频帧
    rng(2024);

    % Rayleigh信道1
                                         % Hz
    pathDelays = delayValues;    % sec                                     
    % pathDelays = [0 1.5e-6 4e-6 6e-6 9e-6];    % sec
    %avgPathGains = [0 -3 -6 -9 -15];      % dB
    avgPathGains =powerValues;
    fD = 111;                                         % 111Hz%60km/h 的速度


    % Create a Rayleigh channel System object
    rchan1 = comm.RayleighChannel('SampleRate',fs, ...
        'PathDelays',pathDelays, ...
        'AveragePathGains',avgPathGains, ...
        'MaximumDopplerShift',fD);
        %'Visualization','Impulse and frequency responses');

    BitError = comm.ErrorRate;
    Ber_out = zeros(1);
    %%
    %生成数据
    data = randi([0 1],N_frame*data_length,1);
    crc_cnt =0;
    %%
    n =1;
    crc_cnt_sum = zeros(N_frame,1);
    while (n <= N_frame)&&(crc_cnt <= arq_limit)

        dain = data((n-1)*data_length+1:n*data_length);
        %%
        %信道编码
        Indices = randperm(length(dain));%序号，用于Turbo中的交织器使用
        dain_aftchannelCoding = Tbcode(dain,Indices);

        %%
        %Modulate
        %
        dain_aftModulation  = Modulator(dain_aftchannelCoding,m);

        dain_aftModulation = dain_aftModulation.*sqrt(k);
        %scatterplot(dain_aftModulation)

        %%
        %%交织
        %
        interlv_depth=6;
        dain_aftInterlv = matintrlv(dain_aftModulation,interlv_depth, length(dain_aftModulation)/interlv_depth);
        for i = 2:1:14
            dataIn(:,i) = dain_aftInterlv((i-1)*data_length_psm+1:i*data_length_psm);
        end
        dataIn(:,1) = dain_aftInterlv(1:data_length_psm);
        %%
        %%OFDM调制
        reset(mod);
        % Create a pilot signal that has the correct dimensions. 梳状导频
        pilotIn = complex(ones(modDim.PilotInputSize),ones(modDim.PilotInputSize)); % 生成导频帧
        % Apply OFDM modulation to the data and pilot signals. 
        modData = step(mod,dataIn,pilotIn).*sqrt(N_subcarrier);%%%%%%%%%%ofdm调制完成的数据  （128+106循环前缀）
    %% 1.2构造加PN序列的帧包
        [PN,datain_ALL]=Canshu(Npn,modData,m);%%%%datain_ALL完成的帧包
    %% 过信道
        after_Ray = rchan1(datain_ALL);
        datain_ALL = awgn(after_Ray,snr);%%%%%%%%aafterfm2:通过Rayleigh信道，aafterfm:不通过Rayleigh信道
    %datain_ALL = awgn(datain_ALL,snr);%只通过awgn

        %% 加频偏
        fd= jingzhen;         % pathDelays = [0 1.5e-6 4e-6 6e-6 9e-6];    % sec
    %avgPathGains = [0 -3 -6 -9 -15];      % dB;%HZ频偏%晶振稳定度1ppm
        %Rb=20e6;%%%%%%%%%信源比特速率
        Ts=1/fs;

        cont=1:length(datain_ALL);%%%%%%%%%%每一项的都会频偏
        phase_pian = 2j*pi*fd.*Ts.*cont;%%无频偏检验：phase_pian = 2j*pi*fd.*Ts.*cont*0
        datain_ALL=datain_ALL.*exp(phase_pian');
        %%
        %加空口时延
        Delay = complex(zeros(floor(delay*fs),1),zeros(floor(delay*fs),1));
        datain_ALL_after_dealy = [Delay',datain_ALL']';

        %% 时间同步
        [Data_atertimelock,judg,PN_atertimelock]=TimeLockFun(PN,datain_ALL_after_dealy,length(modData),m);

    % if (judg==1)
    %     !echo TIME LOCK success    
    % else
    %     !echo TIME LOCK Failed！！
    % end

        %%
        [f_averge,Data_atertFrelock]=frequencLock(Data_atertimelock,PN_atertimelock,Npn,720/k,Ts);
    %Data_atertFrelock = Data_atertimelock;
        %%
        %de MyOFDM
        [dataOut, pilotOut] = step(demod,Data_atertFrelock);
        dataOut = dataOut ./sqrt(N_subcarrier);
        pilotOut = pilotOut ./sqrt(N_subcarrier);
        %scatterplot(dataOut(:,1))
        %% 信道估计
        H_gu = pilotOut./pilotIn;
        desired_length = data_length_psm;
        original_indices = 1:numel(H_gu(:,1));
        desired_indices = linspace(1, numel(H_gu(:,1)), desired_length);

        for i=1:14
            temp_lx(:,i) = interp1(original_indices, H_gu(:,i), desired_indices, 'linear');
        end
        H_real = dataOut./dataIn;

        %% 信道均衡

        [data_aftequa,Eq] = Equalizer(dataOut,temp_lx,noise_var,2);

        %% 解交织
        ND_OUT = [data_aftequa(:,1)',data_aftequa(:,2)',data_aftequa(:,3)',data_aftequa(:,4)',data_aftequa(:,5)',data_aftequa(:,6)',...
                  data_aftequa(:,7)',data_aftequa(:,8)',data_aftequa(:,9)',data_aftequa(:,10)',data_aftequa(:,11)',data_aftequa(:,12)', data_aftequa(:,13)',data_aftequa(:,14)']';
        ND_OUT = matdeintrlv(ND_OUT,interlv_depth, length(dain_aftModulation)/interlv_depth);
        %scatterplot(ND_OUT)
        %%
        %de Modulation
        dataOut_aftdemod = DemodulatorSoft(ND_OUT, m, noise_var)./sqrt(k);
        %%
        %Decode
        %
        dataOut_aftdecode = Tbdecode(dataOut_aftdemod,Indices);
        dataOut_aftdecode = dataOut_aftdecode(1:data_length);
        %%
        %计算误比特率
        %
        reset(BitError);
        results   = BitError.step(dain, dataOut_aftdecode);
        Ber = results(1);

        if Ber > 0.00001
            Ber_out = Ber_out;
            disp("NAK")
            crc_cnt = crc_cnt + 1;
        else
            Ber_out = Ber_out + Ber;
            disp("ACK");
            fprintf( "Frame %d arrived, ARQ time is %d. \n ",n,crc_cnt);
            crc_cnt_sum(n) = crc_cnt;
            crc_cnt = 0;
            n = n+1;

        end 

        if crc_cnt >arq_limit
            fprintf('miss frame %d .\n',n);
            if modulation>2
                crc_cnt = 0;
                modulation = modulation-1;
                fprintf("Low Down Modulator Order \n");
                break;
            end
            Ber_out = Ber_out + Ber;
        end


        clear dain Indices dain_aftchannelCoding R dain_aftModulation BER;
    end
    Ber_out = Ber_out/N_frame;
    reset(BitError);
    
    %%
    mse=mse_G(Eq,H_real);
    if ((Ber_out == 0)||(modulation == 2))&&(n>10)
        fprintf("BER = %d .\n", Ber_out);
        break;
        
    end
    
    if(Ber_out > 0)&&(modulation == 2)
        disp("Too bad channel!!!!!!!");
        break;
    end
    reset(rchan1);
end
end