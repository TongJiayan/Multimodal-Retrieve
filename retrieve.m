function [result_list] = retrieve(type,TF,visual_coefficient_matrix,tag_coefficient_matrix,config)
    if strcmp(type, 'tag-image')
        result_list = retrieve_by_tag(TF,visual_coefficient_matrix,tag_coefficient_matrix,config);
    elseif strcmp(type, 'image-tag')
        result_list = retrieve_by_image(TF,visual_coefficient_matrix,tag_coefficient_matrix,config);
    end

end

function [result_list] = retrieve_by_tag(TF,visual_coefficient_matrix,tag_coefficient_matrix,config)
   
    numOfRetrieved = config.test.numOfRetrieved;
    dataSize = config.test.dataSize;
    result_list = zeros(dataSize,numOfRetrieved);
    
    for n = 1:dataSize
        R = zeros(dataSize);
        if any(TF.wc(n,:))
            %%% Set wordcount as tag_feature for the moment
            tag_feature = TF.abs(n,:);
            tag_feature_projected_space = transpose(tag_feature * tag_coefficient_matrix);
            for m = 1:dataSize
                %%% Set gist as visual_feature for the moment
                visual_feature_projected_space = transpose(TF.bow(m,:) * visual_coefficient_matrix);
                temp = corrcoef(tag_feature_projected_space,visual_feature_projected_space);
                R(m) = temp(1,2);
            end
        end
        [~,rank_list] = sort(R,'descend');
        result_list(n,:) = rank_list(1:numOfRetrieved);
    end
end

%%% We don't use this for the moment
function [result_list] = retrieve_by_image(TD,TF,visual_coefficient_matrix,tag_coefficient_matrix,config)
end