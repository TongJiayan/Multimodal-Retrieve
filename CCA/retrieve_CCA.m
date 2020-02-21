function [result_list] = retrieve_CCA(type,TF,visual_coefficient_matrix,tag_coefficient_matrix,config)
    if strcmp(type, 'tag-image')
        result_list = retrieve_by_tag(TF,visual_coefficient_matrix,tag_coefficient_matrix,config);
    elseif strcmp(type, 'image-tag')
        result_list = retrieve_by_image(TF,visual_coefficient_matrix,tag_coefficient_matrix,config);
    end

end

function [result_list] = retrieve_by_tag(TF,visual_coefficient_matrix,tag_coefficient_matrix,config)
   %% numOfRetrieved = config.test.numOfRetrieved;
    dataSize = config.test.dataSize;
    result_list = zeros(dataSize,dataSize);
    visual_feature_projected_space = TF.gist * visual_coefficient_matrix;
    tag_feature_projected_space = TF.wc * tag_coefficient_matrix;
    for n = 1:dataSize
        R = zeros([1 dataSize]);
        if any(TF.wc(n,:))
            %%% Set wordcount as tag_feature for the moment
            tag_feature = tag_feature_projected_space(n,:);
            for m = 1:dataSize
                %%% Set gist as visual_feature for the moment
                visual_feature = visual_feature_projected_space(m,:);
                temp = corrcoef(transpose(tag_feature),transpose(visual_feature));
                R(m) = temp(1,2);
            end
        end
        [~,rank_list] = sort(R,'descend');
        result_list(n,:) = rank_list;
    end
end

%%% We don't use this for the moment
function [result_list] = retrieve_by_image(TD,TF,visual_coefficient_matrix,tag_coefficient_matrix,config)
end