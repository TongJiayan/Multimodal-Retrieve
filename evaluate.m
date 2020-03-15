function [mAP] = evaluate(TD, result_list, theNumberOfEachObject,config)

    testDataSize = config.test.dataSize;
    AP = zeros([1,testDataSize]);
    for n = 1:testDataSize
        ground_truth_object = find(TD(n).objectcount ~= 0);
        allGroundTruth = theNumberOfEachObject(ground_truth_object);
        truePositive = 0;
        for m = 1:testDataSize
            prediction_object = find(TD(result_list(n,m)).objectcount ~= 0);
            if ground_truth_object == prediction_object
                truePositive = truePositive+1;
                AP(n)=AP(n)+ truePositive/m; 
                if truePositive ==  allGroundTruth % recall = 1
                    AP(n) = AP(n)/ allGroundTruth;
                    break;
                end 
            end     
        end
    end
    mAP = mean(AP);
end

