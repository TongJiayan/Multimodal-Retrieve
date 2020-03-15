function [F] = extract_features(D, taglist, config,type)  
    numOfWords = config.general.numOfWords;
    if strcmp(type, 'train')
        dataSize = config.train.dataSize;
    elseif strcmp(type, 'test')
        dataSize = config.test.dataSize;
    end
    
    F = {};
    
    if ~isempty(taglist)
        F.wc = extract_tag_feature(taglist, 'wordcount', dataSize, numOfWords);
        F.rel = extract_tag_feature(taglist, 'relrank', dataSize, numOfWords);
        F.abs = extract_tag_feature(taglist, 'absrank', dataSize, numOfWords);
    end
    
    F.gist = extract_visual_feature('gist',dataSize,D);
    F.hsv = extract_visual_feature('hsv',dataSize,D);
    F.bow = extract_visual_feature('bow',dataSize,D);
    
    % Decentralization
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
    
end