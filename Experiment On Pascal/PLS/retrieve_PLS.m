function [result_list] = retrieve_PLS(type,TF,BETA)
    text_feature = [ones(size(TF.wc,1),1) TF.wc]*BETA;
    if strcmp(type, 'tag-image')
        dist = pdist2(single(text_feature), single(TF.gist), 'cosine');
    elseif strcmp(type, 'image-tag')
        dist = pdist2(single(TF.gist), single(text_feature), 'cosine');
    end
    [~,result_list] = sort(dist,2,'ascend');
end
