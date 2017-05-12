close all;
clear all;
clc;
% -------------------------------------------------------------------------
% �����Ļ��ˢ��Ƶ���Ƿ�Ϊ60Hz
if Screen('FrameRate',0)~=60
    disp('��Ļˢ��Ƶ�ʲ���60Hz');
    return;
end
frame_rate = 60;
% -------------------------------------------------------------------------
% ��Ŀ��Ĵ̼�Ƶ��
freq = [8:1:15 8.2:1:15.2 8.4:1:15.4 8.6:1:15.6 8.8:1:15.8];
f0 = 8;
% -------------------------------------------------------------------------
% �̼����ֵ�ʱ��
displayTime = 0.8; 
restDelay = 0.27;
trialnum = 40;
index_code = randperm(trialnum);
% -------------------------------------------------------------------------
% ����Ƶ�ļ�
sound_path = ['..\noTraining_1_25s\voice\'];
wavdata = zeros(10000,40);
for ii = 1:40
    filename = [sound_path,num2str(ii),'.wav'];
    [y,fs] = wavread(filename);
    leny(ii) = length(y); 
    wavdata(1:leny(ii),ii) = y;
end
channels = 1; 
InitializePsychSound;
Handle = PsychPortAudio('Open', [], [], [], fs, channels);
% -------------------------------------------------------------------------
% ʵʱ���ݴ���ʱ�Ĳ�������
params.chanNum = 9;
params.sampleRate = 1000;
params.dataLength = displayTime + restDelay;
params.serverPort = 4000;
params.ipAddress = '192.168.1.3';
buffSize = params.sampleRate*params.dataLength;
circBuff = zeros(buffSize,params.chanNum+1);
dataBuffer=((params.chanNum+1)*4*(40*params.sampleRate/1000)+12);
t = tcpip(params.ipAddress, params.serverPort);
set(t,'InputBufferSize',dataBuffer);
set(t,'ByteOrder','littleEndian');
fopen(t);
% -------------------------------------------------------------------------
% ��ʼ������
config_io;
outp(hex2dec('D010'),0);
AssertOpenGL;
% -------------------------------------------------------------------------
try
    % ---------------------------------------------------------------------
    % ʹ��matlab�����жԴ̼�����İ���������
    ListenChar(2);
    % ---------------------------------------------------------------------
    % ��screen 
    Screens = Screen('Screens'); 
    ScreenNum = max(Screens);   
    [w, rect] = Screen('OpenWindow', ScreenNum);           
    % ���˴̼�������CPUִ�ж����е����ȼ���ߵ���߼���
    Priority(MaxPriority(w));  
    % �õ���Ļ�Ĵ�ֱ�ֱ���
    params.vertical = rect(4);
    % �õ���Ļ��ˮƽ�ֱ���
    params.horiz = rect(3); 
    % ---------------------------------------------------------------------
    black = BlackIndex(w);
    white = WhiteIndex(w);
    HideCursor;
    Screen('TextColor', w,white);
    Screen('FillRect',w, black);
    % ---------------------------------------------------------------------
    % ��ʾ��ͼƬ
    stim_represent = imread('white.bmp');
    texturewhite = Screen('MakeTexture', w, stim_represent);
    stim_represent = imread('target.bmp');
    texturetarget = Screen('MakeTexture', w, stim_represent);
    stim_represent = imread('GUI.jpg');
    textureGUI = Screen('MakeTexture', w, stim_represent);
    % ����ͼƬ
    home_path = ['..\noTraining_1_25s\frame_pic\'];
    for ii = 1:displayTime*frame_rate
        file = [home_path,'frame_',num2str(ii),'.jpg'];
        stim_represent = imread(file);
        texture(ii) = Screen('MakeTexture', w,stim_represent);
    end
    % ---------------------------------------------------------------------
    % ͼƬ�Ĵ�С�����أ�
    rectp = [0 0 240 240]; 
    rectp1 = [140 140];
    % ͼƬ��ļ��
    interd = 50;
    % ͼƬ1����Ļ�ϵ�λ��
    % ��30��Ϊ������˸����������30������
    p1horiz = params.horiz/2 - interd/2 - 4*rectp1(1) - 3*interd;
    p1verti = params.vertical/2+30 - rectp1(2)/2 - 2*interd - 2*rectp1(2); 
    rect1 = [p1horiz p1verti p1horiz+rectp1(1) p1verti+rectp1(2)]; 
    %
    cond_horiz = {'p1horiz','p2horiz','p3horiz','p4horiz','p5horiz','p6horiz','p7horiz','p8horiz','p9horiz','p10horiz','p11horiz','p12horiz','p13horiz','p14horiz','p15horiz','p16horiz','p17horiz','p18horiz','p19horiz','p20horiz','p21horiz','p22horiz','p23horiz','p24horiz','p25horiz','p26horiz','p27horiz','p28horiz','p29horiz','p30horiz','p31horiz','p32horiz','p33horiz','p34horiz','p35horiz','p36horiz','p37horiz','p38horiz','p39horiz','p40horiz'};
    cond_verti = {'p1verti','p2verti','p3verti','p4verti','p5verti','p6verti','p7verti','p8verti','p9verti','p10verti','p11verti','p12verti','p13verti','p14verti','p15verti','p16verti','p17verti','p18verti','p19verti','p20verti','p21verti','p22verti','p23verti','p24verti','p25verti','p26verti','p27verti','p28verti','p29verti','p30verti','p31verti','p32verti','p33verti','p34verti','p35verti','p36verti','p37verti','p38verti','p39verti','p40verti'};
    for ii = 1:8
        str = cond_horiz{ii};
        eval([str,'=',num2str(p1horiz + (ii-1)*(rectp1(1) + interd)),';']);
        for jj = 1:5
            str = cond_horiz{ii + 8*(jj-1)};
            eval([str,'=',cond_horiz{ii},';']);
        end
    end
    for ii = 1:5
        str = cond_verti{1 + 8*(ii-1)};
        eval([str,'=',num2str(p1verti + (ii-1)*(rectp1(2) + interd)),';']);
        for jj = 1:8
            str = cond_verti{jj + 8*(ii-1)};
            eval([str,'=',cond_verti{1 + 8*(ii-1)},';']);
        end
    end
    recti = {'rect1','rect2','rect3','rect4','rect5','rect6','rect7','rect8','rect9','rect10','rect11','rect12','rect13','rect14','rect15','rect16','rect17','rect18','rect19','rect20','rect21','rect22','rect23','rect24','rect25','rect26','rect27','rect28','rect29','rect30','rect31','rect32','rect33','rect34','rect35','rect36','rect37','rect38','rect39','rect40'};
    for ii = 1:40
        str = recti{ii};
        eval([str,'=','[',cond_horiz{ii},' ',cond_verti{ii},' ',cond_horiz{ii},'+',num2str(rectp1(1)),' ',cond_verti{ii},'+',num2str(rectp1(2)),']',';']);
    end
    rei = {'re1','re2','re3','re4','re5','re6','re7','re8','re9','re10','re11','re12','re13','re14','re15','re16','re17','re18','re19','re20','re21','re22','re23','re24','re25','re26','re27','re28','re29','re30','re31','re32','re33','re34','re35','re36','re37','re38','re39','re40'};
    for ii = 1:40
        str = rei{ii};
        eval([str,'=','[',cond_horiz{ii},'+',num2str(rectp1(1)/2-15),' ',cond_verti{ii},'+',num2str(rectp1(2)+20),';',cond_horiz{ii},'+',num2str(rectp1(1)/2),' ',cond_verti{ii},'+',num2str(rectp1(2)),';',cond_horiz{ii},'+',num2str(rectp1(1)/2+15),' ',cond_verti{ii},'+',num2str(rectp1(2)+20),']',';']);
    end
    % ---------------------------------------------------------------------
    Screen('DrawTextures',w,textureGUI);
    Screen('Flip',w); 
    WaitSecs(3);
    % ---------------------------------------------------------------------
    fixTime= timer( 'Period', 0.02);
    set(fixTime, 'ExecutionMode', 'FixedRate');
    set(fixTime,'TimerFcn',['newset=pGetData(t,dataBuffer,params.chanNum,params.sampleRate);','if ~isempty(newset)',...
        'circBuff = [circBuff(0.04*params.sampleRate+1:end,:);newset];','end']);
    start(fixTime);
    % ---------------------------------------------------------------------
    showresult = '   '; 
    % ---------------------------------------------------------------------
    for ii = 1:trialnum
        % -----------------------------------------------------------------   
        % SSVEP����
        currentInterval = 0;
        count1 = 1;
        num = 0;
        % -----------------------------------------------------------------
        % �õ�ÿ֮֡���ʱ����
        ifi  = Screen('GetFlipInterval', w);
        % -----------------------------------------------------------------
        start1 = GetSecs();
        prevVbl = Screen('Flip',w);
        now1 = GetSecs();
        while(now1 < start1 + displayTime)
            % -------------------------------------------------------------
            Screen('DrawTextures',w,texture(count1));
            % �����ϴεķ���
            Screen('TextSize', w, 30);
            DrawFormattedText(w, showresult, p1horiz+10, p1verti-85,[0,0,0]);
            % -------------------------------------------------------------
            count1 = count1 + 1;
            currentInterval = 0;
            % -------------------------------------------------------------
            num = num + 1;
            if num==1
                outp(hex2dec('D010'),index_code(ii));
                % ��ʼ��������
                fwrite(t,[67 84 82 76 0 3 0 3 0 0 0 0],'uchar');
                % ���յ������ݴ���circBuff������
            end
            % -------------------------------------------------------------
            vbl = Screen('Flip',w);
            currentInterval = currentInterval + round((vbl-prevVbl)/ifi);
            prevVbl = vbl;
            now1 = GetSecs();
        end
        aa(ii) = num;
        % -----------------------------------------------------------------
        start2 = GetSecs();
        now2 = GetSecs();
        while(now2 < start2 + restDelay)
            Screen('DrawTextures',w,textureGUI);
            Screen('TextSize', w, 30);
            DrawFormattedText(w, showresult, p1horiz+10, p1verti-85,[0,0,0]);
            Screen('Flip',w);
            now2 = GetSecs();
        end
        % -----------------------------------------------------------------
        % ֹͣ��������
        fwrite(t,[67 84 82 76 0 3 0 4 0 0 0 0],'uchar');
        outp(hex2dec('D010'),0);
        % -----------------------------------------------------------------
        Screen('DrawTextures',w,textureGUI);
        data(:,:,ii) = circBuff;
        % ���ַ���
        resultnum = onlineAnalysis(circBuff,displayTime);
        y1 = wavdata(1:leny(resultnum),resultnum);
        PsychPortAudio('FillBuffer', Handle, y1');
        PsychPortAudio('Start', Handle);
        % -----------------------------------------------------------------
        if resultnum==40
            showresult(end)=[];
        else
            if resultnum>=1&&resultnum<=26
                resultlett = char(resultnum+64);
            elseif resultnum>=27&&resultnum<=36
                resultlett = char(resultnum+21);
            elseif resultnum==37
                resultlett = char(32);
            elseif resultnum==38
                resultlett = char(44);
            elseif resultnum==39
                resultlett = char(46);
            end
            showresult = [showresult,resultlett];
        end
        Screen('TextSize', w, 30);
        DrawFormattedText(w, showresult, p1horiz+10, p1verti-85,[0,0,0]);
        Screen('Flip',w); 
        %WaitSecs(0.05);
        WaitSecs(3);
    end
    WaitSecs(1);
    % ---------------------------------------------------------------------
    PsychPortAudio('Stop',Handle);
    PsychPortAudio('Close',Handle);
    ShowCursor
    Screen('CloseAll');  
    % �ͷ�mex��ִ���ļ����ڴ�����ռ�Ŀռ�
    clear mex;
    % �ָ����˳������е�ԭ�����ȼ���
    Priority(0);
    ListenChar(0);
    stop(fixTime);
    %�ر����������ӣ�ֹͣ�����Ե�����
    fwrite(t,[67 84 82 76 0 1 0 2 0 0 0 0],'uchar');
    fclose(t);
    delete(t);
    disp('the experiment is over');  
catch ME
    PsychPortAudio('Stop',Handle);
    PsychPortAudio('Close',Handle);
    ShowCursor;
    Screen('CloseAll');
    clear mex;
    Priority(0);
    ListenChar(0);
    stop(fixTime);
    %�ر����������ӣ�ֹͣ�����Ե�����
    fwrite(t,[67 84 82 76 0 1 0 2 0 0 0 0],'uchar');
    fclose(t);
    delete(t);
    rethrow(ME);
    psychrethrow(psychlasterror);
end
Screen('CloseAll');