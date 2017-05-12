function result = onlineAnalysis(rawdata,stimTime)
%
% -------------------------------------------------------------------------
% ²ÎÊý
weights = [1:10].^(-1.25)+.25; 
lDelay = 0.14;
nharmonics = 5;
condition = 40;
freq = [8:1:15 8.2:1:15.2 8.4:1:15.4 8.6:1:15.6 8.8:1:15.8];
N1 = 1000*(stimTime + lDelay);
% -------------------------------------------------------------------------
for chan = 1:9
    markData = rawdata(:,10);
    Diffmark = diff(markData,1);
    indexsMin = find(Diffmark~=0);
    iMin = max([0,indexsMin']);
    downsdata = downsample(rawdata(round(iMin+1):round(iMin+N1),chan),4);
    bpdatah1(:,chan) = bp40_FB3(downsdata,250,1);
    bpdatah2(:,chan) = bp40_FB3(downsdata,250,2);
    bpdatah3(:,chan) = bp40_FB3(downsdata,250,3);
    bpdatah4(:,chan) = bp40_FB3(downsdata,250,4);
    bpdatah5(:,chan) = bp40_FB3(downsdata,250,5);
    bpdatah6(:,chan) = bp40_FB3(downsdata,250,6);
    bpdatah7(:,chan) = bp40_FB3(downsdata,250,7);
end
testdata = bpdatah1;
testdatah = bpdatah2;
testdatah3 = bpdatah3;
testdatah4 = bpdatah4;
testdatah5 = bpdatah5;
testdatah6 = bpdatah6;
testdatah7 = bpdatah7;
% -------------------------------------------------------------------------
rfs = 250;
latencyDelay = lDelay*rfs;
w = 2;
N = round(stimTime*rfs);
% -------------------------------------------------------------------------
n = [1:N]/rfs;
for ii = 1:length(freq);
    s1 = sin(2*pi*freq(ii)*n);
    s2 = cos(2*pi*freq(ii)*n);
    s3 = sin(2*pi*2*freq(ii)*n);
    s4 = cos(2*pi*2*freq(ii)*n);
    s5 = sin(2*pi*3*freq(ii)*n);
    s6 = cos(2*pi*3*freq(ii)*n);
    s7 = sin(2*pi*4*freq(ii)*n);
    s8 = cos(2*pi*4*freq(ii)*n);
    s9 = sin(2*pi*5*freq(ii)*n);
    s10 = cos(2*pi*5*freq(ii)*n);
    s11 = sin(2*pi*6*freq(ii)*n);
    s12 = cos(2*pi*6*freq(ii)*n);
    s13 = sin(2*pi*7*freq(ii)*n);
    s14 = cos(2*pi*7*freq(ii)*n);
    s15 = sin(2*pi*8*freq(ii)*n);
    s16 = cos(2*pi*8*freq(ii)*n);
    s17 = sin(2*pi*9*freq(ii)*n);
    s18 = cos(2*pi*9*freq(ii)*n);
    s19 = sin(2*pi*10*freq(ii)*n);
    s20 = cos(2*pi*10*freq(ii)*n);
    condY(:,:,ii) = cat(2,s1',s2',s3',s4',s5',s6',s7',s8',s9',s10',s11',s12',s13',s14',s15',s16',s17',s18',s19',s20');   
end
X = testdata(1+latencyDelay:N+latencyDelay,:);
Xh = testdatah(1+latencyDelay:N+latencyDelay,:);
Xh3 = testdatah3(1+latencyDelay:N+latencyDelay,:);
Xh4 = testdatah4(1+latencyDelay:N+latencyDelay,:);
Xh5 = testdatah5(1+latencyDelay:N+latencyDelay,:);
Xh6 = testdatah6(1+latencyDelay:N+latencyDelay,:);
Xh7 = testdatah7(1+latencyDelay:N+latencyDelay,:);
for cond = 1:condition
    Y1 = condY(:,1:2*nharmonics,cond);                
    [A,B,r,U,V] = canoncorr(X,Y1);
    rr1(cond)=mean(r(1:1));
    [A,B,r,U,V] = canoncorr(Xh,Y1);
    rr2(cond)=mean(r(1:1));
    [A,B,r,U,V] = canoncorr(Xh3,Y1);
    rr3(cond)=mean(r(1:1));
    [A,B,r,U,V] = canoncorr(Xh4,Y1);
    rr4(cond)=mean(r(1:1));
    [A,B,r,U,V] = canoncorr(Xh5,Y1);
    rr5(cond)=mean(r(1:1));
    [A,B,r,U,V] = canoncorr(Xh6,Y1);
    rr6(cond)=mean(r(1:1));
    [A,B,r,U,V] = canoncorr(Xh7,Y1);
    rr7(cond)=mean(r(1:1));
end
rrr = weights(1)*rr1.^2 + weights(2)*rr2.^2 + weights(3)*rr3.^2 + weights(4)*rr4.^2 + weights(5)*rr5.^2 + weights(6)*rr6.^2 + weights(7)*rr7.^2;
result = find(rrr==max(rrr));    
% -------------------------------------------------------------------------