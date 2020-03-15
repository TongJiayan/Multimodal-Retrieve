function [result_list] = retrieve_PLS(type,testData,BETA)
    text_feature = [ones(size(testData.text,1),1) testData.text]*BETA;
    if strcmp(type, 'text-to-image')
        dist = pdist2(single(text_feature), single(testData.image), 'cosine');
    elseif strcmp(type, 'image-to-text')
        dist = pdist2(single(testData.image), single(text_feature), 'cosine');
    end
    [~,result_list] = sort(dist,2,'ascend');
end
