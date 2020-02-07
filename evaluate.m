%%% Compute mAP according to algorithm provided on https://zhuanlan.zhihu.com/p/74429856
%%% the variable 'score' means the percent that how many taglist elements in ground truth
%%% was included in prediction result.
%%% When the score over the threshold value, we think this result is right
function [mAP] = evaluate(D,TD, result_list, threshold_value, config)
    dataSize = config.test.dataSize;
    numOfRetrieved = config.test.numOfRetrieved;
    AP = 0;
    for n = 1:dataSize
        ground_truth = TD(n).taglist;
        if size(ground_truth,1)==0
            continue;
        end
        i = 1;
        for m = 1:numOfRetrieved
            prediction = D(result_list(n,m)).taglist;
            if size(prediction,1)==0
                continue;
            end
            score = getScore(ground_truth,prediction);
            if score >= threshold_value
                AP = AP + i/m;
                i = i+1;
            end
        end
    end
    mAP = AP / dataSize / numOfRetrieved;
end

function [score] = getScore(ground_truth_list, prediction_list)    
    intersection = intersect(ground_truth_list, prediction_list);
    common_element_count = 0;
    for n = 1:size(intersection,2)
        element_count_gd = length(find(ground_truth_list == intersection(n)));
        element_count_pred = length(find(prediction_list == intersection(n)));
        common_element_count = common_element_count + min(element_count_gd,element_count_pred);
    end
    score = common_element_count / size(ground_truth_list,2);
end