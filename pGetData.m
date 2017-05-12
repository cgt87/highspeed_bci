function data=pGetData(t,dataBuffer,chanNum,sampleRate)
%  
%
if (get(t, 'BytesAvailable')==dataBuffer)
    dataOri=fread(t,dataBuffer/4,'int32')*0.15;      
    dataOri(1:3,:)=[];
    temp2=reshape(dataOri,chanNum+1,0.04*sampleRate);
    data=temp2';
else
    data=[];
end