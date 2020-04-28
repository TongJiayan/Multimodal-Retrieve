function [mAP] = evaluate(testData, result_list,config)
    if strcmp(config.general.dataset,'PASCAL')
        mAP = evaluate_pascal(testData,result_list,config);
    elseif strcmp(config.general.dataset,'WIKI')
        mAP = evaluate_wiki(testData.cat_list,result_list,config);
    elseif strcmp(config.general.dataset,'NUSWIDE')
        mAP = evaluate_nuswide(testData,result_list,config);
    end
end

function [mAP] = evaluate_pascal(testData, result_list,config)
    testDataSize = config.testDataSize;
    theSizeOfEachObject = getSizeOfEachObject(testData);
    AP = zeros([1,testDataSize]);
    for n = 1:testDataSize
        ground_truth_object = find(testData.objectcount(n,:) ~= 0);
        allGroundTruth = theSizeOfEachObject(ground_truth_object);
        truePositive = 0;
        for m = 1:testDataSize
            prediction_object = find(testData.objectcount(result_list(n,m),:) ~= 0);
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

function [mAP] = evaluate_wiki(catList, result_list,config)

    testDataSize = config.testDataSize;
    theSizeOfEachClass = getSizeOfEachClass(catList);
    AP = zeros([1,testDataSize]);
    for n = 1:testDataSize
        ground_truth_class = catList(n);
        allGroundTruth = theSizeOfEachClass(ground_truth_class);
        truePositive = 0;
        for m = 1:testDataSize
            prediction_class = catList(result_list(n,m));
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

function [mAP] = evaluate_nuswide(testData, result_list,config)
    testDataSize = config.testDataSize;
    theSizeOfEachConcept = getSizeOfEachConcept(testData.groundTruth);
    AP = zeros([1,testDataSize]);
    for n = 1:testDataSize
        ground_truth_object = testData.groundTruth(n);
        allGroundTruth = theSizeOfEachConcept(ground_truth_object);
        truePositive = 0;
        for m = 1:testDataSize
            prediction_object = testData.groundTruth(result_list(n,m));
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

% For Nuswide
function [theSizeOfEachConcept] = getSizeOfEachConcept(groundTruth)
    conceptNumber = 81; % Divide samples into 10 classes
    theSizeOfEachConcept = zeros([1,conceptNumber]);
    for i = 1:conceptNumber
        theSizeOfEachConcept(i) = length(find(groundTruth == i));
    end
end

% For Pascal
function [theSizeOfEachObject] = getSizeOfEachObject(testData)
    theSizeOfEachObject = zeros([1,20]);
    objectcount = testData.objectcount;
    for n=1:20
        theSizeOfEachObject(n) = length(find(objectcount(:,n)~=0));
    end    
end

% For Wiki
function [theSizeOfEachClass] = getSizeOfEachClass(testCatList)
    classNumber = 10; % Divide samples into 10 classes
    theSizeOfEachClass = zeros([1,classNumber]);
    for i = 1:classNumber
        theSizeOfEachClass(i) = length(find(testCatList == i));
    end
end