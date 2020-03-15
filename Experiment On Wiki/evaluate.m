function [mAP] = evaluate(result_list,catList,config)

    testDataSize = config.test.dataSize;
    theSizeOfEachClass = getSizeOfEachClass(catList.test);
    AP = zeros([1,testDataSize]);
    for n = 1:testDataSize
        ground_truth_class = catList.test(n);
        allGroundTruth = theSizeOfEachClass(ground_truth_class);
        truePositive = 0;
        for m = 1:testDataSize
            prediction_class = catList.test(result_list(n,m));
            if ground_truth_class == prediction_class
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

function [theSizeOfEachClass] = getSizeOfEachClass(testCatList)
    classNumber = 10; % Divide samples into 10 classes
    theSizeOfEachClass = zeros([1,classNumber]);
    for i = 1:classNumber
        theSizeOfEachClass(i) = length(find(testCatList == i));
    end
end