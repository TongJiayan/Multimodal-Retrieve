function [result_list] = retrieve_CCA(type,testData,visual_coef,text_coef)
    text_feature = testData.text * text_coef;
    image_feature = testData.image * visual_coef;
    if strcmp(type, 'text-to-image')
        dist = pdist2(single(text_feature), single(image_feature), 'cosine');
    elseif strcmp(type, 'image-to-text')
        dist = pdist2(single(image_feature), single(text_feature) , 'cosine');
    end
    [~,result_list] = sort(dist,2,'ascend');
end