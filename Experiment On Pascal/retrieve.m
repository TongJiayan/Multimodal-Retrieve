function [result_list] = retrieve(direction,testData,wout)
    text_feature = testData.text * wout{1}.Bases;
    image_feature = testData.image * wout{2}.Bases;
    if strcmp(direction,'text-to-image')
        dist = pdist2(single(text_feature), single(image_feature), 'cosine');
    elseif strcmp(direction,'image-to-text')
        dist = pdist2(single(image_feature), single(text_feature), 'cosine');
    end
    [~,result_list] = sort(dist,2,'ascend');
end

