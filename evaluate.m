%%% Compute mAP according to algorithm provided on https://zhuanlan.zhihu.com/p/74429856
%%% If the object in prediction is same with gd, set it right.
function [mAP] = evaluate(D,TD, result_list, config)
    testDataSize = config.test.dataSize;
    numOfRetrieved = config.test.numOfRetrieved;
    AP = 0;
    for n = 1:testDataSize
        ground_truth_object = find(TD(n).objectcount ~= 0);
        i = 1;
        for m = 1:numOfRetrieved
            prediction_object = find(D(result_list(n,m)).objectcount ~= 0);
            if ground_truth_object == prediction_object
                AP = AP + i/m;
                i = i+1;
            end
        end
    end
    mAP = AP / testDataSize / numOfRetrieved;
end
