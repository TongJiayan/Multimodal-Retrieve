%%% Compute mAP according to algorithm provided on https://zhuanlan.zhihu.com/p/74429856
%%% If the object in prediction is same with gd, set it right.
function [mAP_trapz,mAP_direct] = evaluate(TD, result_list, theNumberOfEachObject,config)
    mAP_trapz = evaluate1(TD, result_list, theNumberOfEachObject,config);
    mAP_direct = evaluate2(TD, result_list, theNumberOfEachObject,config);
end
function [mAP] = evaluate1(TD, result_list, theNumberOfEachObject,config)
    testDataSize = config.test.dataSize;
    AP = zeros([1,testDataSize]);
    for n = 1:testDataSize
        rec = zeros([1,testDataSize]);
        prec = zeros([1,testDataSize]);
        ground_truth_object = find(TD(n).objectcount ~= 0);
        allGroundTruth = theNumberOfEachObject(ground_truth_object);
        truePositive = 0;
        for m = 1:testDataSize
            prediction_object = find(TD(result_list(n,m)).objectcount ~= 0);
            if ground_truth_object == prediction_object
                truePositive = truePositive+1;
            end
            rec(m) = truePositive/allGroundTruth;
            prec(m) = truePositive/m; 
            if truePositive ==  allGroundTruth % recall = 1
                AP(n) = trapz(rec(1:m),prec(1:m)); % https://ww2.mathworks.cn/help/matlab/ref/trapz.html
                break;
            end   
        end
    end
    mAP = mean(AP);
end


function [mAP] = evaluate2(TD, result_list, theNumberOfEachObject,config)
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
