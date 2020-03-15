function [result_list] = retrieve_BLM(type, TF, Wout)
    text_feature = TF.wc * Wout{1}.Bases;
    image_feature = TF.gist * Wout{2}.Bases;
    if strcmp(type,'tag-image')
        dist = pdist2(single(text_feature), single(image_feature), 'cosine');
    elseif strcmp(type,'image-tag')
        dist = pdist2(single(image_feature), single(text_feature), 'cosine');
    end
    [~,result_list] = sort(dist,2,'ascend');
end

