function [standard_feature] = decent_standard_data(type,F,config)
%DECENT_STANDARD_DATA 此处显示有关此函数的摘要
%   此处显示详细说明
if strcmp(type, 'train')
    dataSize = config.train.dataSize;
elseif strcmp(type,'test')
    dataSize = config.test.dataSize;
else
    disp('Parameter type needs to be train or test.');
    return
end
F.wc = F.wc - repmat(mean(F.wc),dataSize,1);
F.rel = F.rel - repmat(mean(F.rel),dataSize,1);
F.abs = F.abs - repmat(mean(F.abs),dataSize,1);
F.gist = F.gist - repmat(mean(F.gist),dataSize,1);
F.hsv = F.hsv - repmat(mean(F.hsv),dataSize,1);
F.bow = F.bow - repmat(mean(F.bow),dataSize,1);


% normalize variance (to improve anisotropy) or any other preprocessing

F.wc = F.wc*sqrt(diag(1./diag(F.wc'*F.wc)));
F.wc(isnan(F.wc)==1)=0;
F.rel = F.rel*sqrt(diag(1./diag(F.rel'*F.rel)));
F.rel(isnan(F.rel)==1)=0;
F.abs = F.abs*sqrt(diag(1./diag(F.abs'*F.abs)));
F.abs(isnan(F.abs)==1)=0;
F.gist = F.gist*sqrt(diag(1./diag(F.gist'*F.gist)));
F.gist(isnan(F.gist)==1)=0;
F.hsv = F.hsv*sqrt(diag(1./diag(F.hsv'*F.hsv)));
F.hsv(isnan(F.hsv)==1)=0;
F.bow = F.bow*sqrt(diag(1./diag(F.bow'*F.bow)));
F.bow(isnan(F.bow)==1)=0;

standard_feature = F;
end

