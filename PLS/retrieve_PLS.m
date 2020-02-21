function [result_list] = retrieve_PLS(type,TF,BETA,config)
    if strcmp(type, 'tag-image')
        result_list = retrieve_by_tag(TF,BETA,config);
    elseif strcmp(type, 'image-tag')
        result_list = retrieve_by_image(TF,BETA,config);
    end

end

function [result_list] = retrieve_by_tag(TF,BETA,config)
   %% numOfRetrieved = config.test.numOfRetrieved;
    dataSize = config.test.dataSize;
    result_list = zeros(dataSize,dataSize);
    visual_fix = [ones(size(TF.wc,1),1) TF.wc]*BETA;
    visual = TF.gist;
    for n = 1:dataSize
        R = zeros([1 dataSize]);
        for m = 1:dataSize
            temp = corrcoef(transpose(visual_fix(n,:)),transpose(visual(m,:)));
            R(m) = temp(1,2);
        end
        [~,rank_list] = sort(R,'descend');
        result_list(n,:) = rank_list;
    end
end

%%% We don't use this for the moment
function [result_list] = retrieve_by_image(TD,TF,visual_coefficient_matrix,tag_coefficient_matrix,config)
end