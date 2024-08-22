function main_ALL(modulation,delayValues,powerValues,jingzhen,ebn0,kongkou,visual_flag)
% pathDelays = [0 1.5e-6 4e-6 6e-6 9e-6];    % sec
%avgPathGains = [0 -3 -6 -9 -15];      % dB
delayValues=delayValues./1e6;
jingzhen=2000;
kongkou=kongkou./1e6;
%% Parameter

while(1)
    %������
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
    % m = 4;%���Ʒ�ʽ%2=>bpsk,4=>qpsk,16=>16QAM,64=>64QAM
    stp=4;%%%%��Ƶ�����5
    N_subcarrier=1602;%���ز���128,1024
    N_guard = 402;
    N_frame = 10;
    Npn=4;%%һ��N��pn����

    % delay = (2.5 + (5 - 2.5) * rand())*1e-6;%�տ�ʱ��
    delay=kongkou;
    %fs = 2048*15e3;
    fs = 4e7;
    %EbNo = 0:10;
    EbNo = ebn0;%Ebn0=5
    data_length_psm  = 960;%ÿ��ofdm�����ϵ�������

    switch m
        case 2
            data_length = 4476;%ÿһ֡��������      
        case 4
            data_length = 8956;%ÿһ֡��������
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

    %% 1.1����ofdm����֡��
    % ����ofdm���ƽ��ģ��
    kk=1:stp+1:(N_subcarrier-N_guard);%(stp-1)/2:stp+1:1024;%��ǰ���15
    mod = comm.OFDMModulator('FFTLength',2048,...
    'NumGuardBandCarriers',[0;N_guard],...
    'PilotInputPort',true, ...%�Ƿ���뵼Ƶ
    'FFTLength',N_subcarrier,...
    'PilotCarrierIndices',[kk'], ...%���뵼Ƶ��λ������
    'NumSymbols',14, ...
    'CyclicPrefixLength',106,...%ѭ��ǰ׺�ĳ���
    'InsertDCNull',false);

    demod = comm.OFDMDemodulator(mod);
    modDim = info(mod); 
    %showResourceMapping(mod)
    % showResourceMapping(mod)  %show
    % ��������datain����Ƶ֡
    rng(2024);

    % Rayleigh�ŵ�1
                                         % Hz
    pathDelays = delayValues;    % sec                                     
    % pathDelays = [0 1.5e-6 4e-6 6e-6 9e-6];    % sec
    %avgPathGains = [0 -3 -6 -9 -15];      % dB
    avgPathGains =powerValues;
    fD = 111;                                         % 111Hz%60km/h ���ٶ�


    % Create a Rayleigh channel System object
    rchan1 = comm.RayleighChannel('SampleRate',fs, ...
        'PathDelays',pathDelays, ...
        'AveragePathGains',avgPathGains, ...
        'MaximumDopplerShift',fD);
        %'Visualization','Impulse and frequency responses');

    BitError = comm.ErrorRate;
    Ber_out = zeros(1);
    %%
    %��������
    data = randi([0 1],N_frame*data_length,1);
    crc_cnt =0;
    %%
    n =1;
    crc_cnt_sum = zeros(N_frame,1);
    while (n <= N_frame)&&(crc_cnt <= arq_limit)

        dain = data((n-1)*data_length+1:n*data_length);
        %%
        %�ŵ�����
        Indices = randperm(length(dain));%��ţ�����Turbo�еĽ�֯��ʹ��
        dain_aftchannelCoding = Tbcode(dain,Indices);

        %%
        %Modulate
        %
        dain_aftModulation  = Modulator(dain_aftchannelCoding,m);

        dain_aftModulation = dain_aftModulation.*sqrt(k);
        %scatterplot(dain_aftModulation)

        %%
        %%��֯
        %
        interlv_depth=6;
        dain_aftInterlv = matintrlv(dain_aftModulation,interlv_depth, length(dain_aftModulation)/interlv_depth);
        for i = 2:1:14
            dataIn(:,i) = dain_aftInterlv((i-1)*data_length_psm+1:i*data_length_psm);
        end
        dataIn(:,1) = dain_aftInterlv(1:data_length_psm);
        %%
        %%OFDM����
        reset(mod);
        % Create a pilot signal that has the correct dimensions. ��״��Ƶ
        pilotIn = complex(ones(modDim.PilotInputSize),ones(modDim.PilotInputSize)); % ���ɵ�Ƶ֡
        % Apply OFDM modulation to the data and pilot signals. 
        modData = step(mod,dataIn,pilotIn).*sqrt(N_subcarrier);%%%%%%%%%%ofdm������ɵ�����  ��128+106ѭ��ǰ׺��
    %% 1.2�����PN���е�֡��
        [PN,datain_ALL]=Canshu(Npn,modData,m);%%%%datain_ALL��ɵ�֡��
    %% ���ŵ�
        after_Ray = rchan1(datain_ALL);
        datain_ALL = awgn(after_Ray,snr);%%%%%%%%aafterfm2:ͨ��Rayleigh�ŵ���aafterfm:��ͨ��Rayleigh�ŵ�
    %datain_ALL = awgn(datain_ALL,snr);%ֻͨ��awgn

        %% ��Ƶƫ
        fd= jingzhen;         % pathDelays = [0 1.5e-6 4e-6 6e-6 9e-6];    % sec
    %avgPathGains = [0 -3 -6 -9 -15];      % dB;%HZƵƫ%�����ȶ���1ppm
        %Rb=20e6;%%%%%%%%%��Դ��������
        Ts=1/fs;

        cont=1:length(datain_ALL);%%%%%%%%%%ÿһ��Ķ���Ƶƫ
        phase_pian = 2j*pi*fd.*Ts.*cont;%%��Ƶƫ���飺phase_pian = 2j*pi*fd.*Ts.*cont*0
        datain_ALL=datain_ALL.*exp(phase_pian');
        %%
        %�ӿտ�ʱ��
        Delay = complex(zeros(floor(delay*fs),1),zeros(floor(delay*fs),1));
        datain_ALL_after_dealy = [Delay',datain_ALL']';

        %% ʱ��ͬ��
        [Data_atertimelock,judg,PN_atertimelock]=TimeLockFun(PN,datain_ALL_after_dealy,length(modData),m);

    % if (judg==1)
    %     !echo TIME LOCK success    
    % else
    %     !echo TIME LOCK Failed����
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
        %% �ŵ�����
        H_gu = pilotOut./pilotIn;
        desired_length = data_length_psm;
        original_indices = 1:numel(H_gu(:,1));
        desired_indices = linspace(1, numel(H_gu(:,1)), desired_length);

        for i=1:14
            temp_lx(:,i) = interp1(original_indices, H_gu(:,i), desired_indices, 'linear');
        end
        H_real = dataOut./dataIn;

        %% �ŵ�����

        [data_aftequa,Eq] = Equalizer(dataOut,temp_lx,noise_var,2);

        %% �⽻֯
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
        %�����������
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