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
end