function [result_list] = retrieve_CCA(type,TF,visual_coefficient_matrix,tag_coefficient_matrix)
    text_feature = TF.wc * tag_coefficient_matrix;
    image_feature = TF.gist * visual_coefficient_matrix;
    if strcmp(type, 'tag-image')
        dist = pdist2(single(text_feature), single(image_feature), 'cosine');
    elseif strcmp(type, 'image-tag')
        dist = pdist2(single(image_feature), single(text_feature) , 'cosine');
    end
    [~,result_list] = sort(dist,2,'ascend');
end