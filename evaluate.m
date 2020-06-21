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
    % selected_testcase_idx = 25; % Select the result of 100th test data to draw PR curve 
    for n = 1:testDataSize
        ground_truth_object = find(testData.objectcount(n,:) ~= 0);
        allGroundTruth = theSizeOfEachObject(ground_truth_object);
        truePositive = 0;
        %falsePositive = 0;
        %tmp_R = [];
        %tmp_P = [];
        for m = 1:testDataSize
            prediction_object = find(testData.objectcount(result_list(n,m),:) ~= 0);
            if ground_truth_object == prediction_object
                truePositive = truePositive+1;
                AP(n)=AP(n)+ truePositive/m; 
                recall = truePositive / allGroundTruth;
                %if n == selected_testcase_idx
                %    precision = truePositive / (truePositive + falsePositive);
                %    tmp_R = [tmp_R, recall];
                %    tmp_P = [tmp_P, precision];
                %end
                if recall == 1
                    AP(n) = AP(n)/ allGroundTruth;
                    %if n == selected_testcase_idx
                    %    save(strcat(config.general.algorithm,config.general.pca,config.general.direction,config.general.image_feature,'PASCAL_PR.mat'),'tmp_R', 'tmp_P');
                    %    plot(tmp_R, tmp_P);
                    %end 
                    break;
                end
            else
                % falsePositive = falsePositive + 1;   
            end 
        end
    end
    mAP = mean(AP);
end

% function [mAP] = evaluate_wiki(catList, result_list,config)
% 
%     testDataSize = config.testDataSize;
%     theSizeOfEachClass = getSizeOfEachClass(catList);
%     AP = zeros([1,testDataSize]);
%     for n = 1:testDataSize
%         ground_truth_class = catList(n);
%         allGroundTruth = theSizeOfEachClass(ground_truth_class);
%         truePositive = 0;
%         for m = 1:testDataSize
%             prediction_class = catList(result_list(n,m));
%             if ground_truth_class == prediction_class
%                 truePositive = truePositive+1;
%                 AP(n)=AP(n)+ truePositive/m; 
%                 if truePositive ==  allGroundTruth % recall = 1
%                     AP(n) = AP(n)/ allGroundTruth;
%                     break;
%                 end 
%             end     
%         end
%     end
%     mAP = mean(AP);
% end

% function [mAP] = evaluate_nuswide(testData, result_list,config)
%     testDataSize = config.testDataSize;
%     theSizeOfEachConcept = getSizeOfEachConcept(testData.groundTruth);
%     AP = zeros([1,testDataSize]);
%     for n = 1:testDataSize
%         ground_truth_object = testData.groundTruth(n);
%         allGroundTruth = theSizeOfEachConcept(ground_truth_object);
%         truePositive = 0;
%         for m = 1:testDataSize
%             prediction_object = testData.groundTruth(result_list(n,m));
%             if ground_truth_object == prediction_object
%                 truePositive = truePositive+1;
%                 AP(n)=AP(n)+ truePositive/m; 
%                 if truePositive ==  allGroundTruth 
%                     AP(n) = AP(n)/ allGroundTruth;
%                     break;
%                 end 
%             end     
%         end
%     end
%     mAP = mean(AP);
% end
% 

function [mAP] = evaluate_wiki(catList, result_list,config)

    testDataSize = config.testDataSize;
    theSizeOfEachClass = getSizeOfEachClass(catList);
    AP = zeros([1,testDataSize]);
    recall = zeros(1,10);
    precision = zeros(1,10);
    for n = 1:testDataSize
        ground_truth_class = catList(n);
        allGroundTruth = theSizeOfEachClass(ground_truth_class);
        truePositive = 0;
        recall_for_one_case = [];
        precision_for_one_case = [];
        next_recall = 0.1;
        for m = 1:testDataSize
            prediction_class = catList(result_list(n,m));
            if ground_truth_class == prediction_class
                truePositive = truePositive+1;
                AP(n)=AP(n)+ truePositive/m; 
                recall_current = truePositive / allGroundTruth;
                if recall_current >= next_recall
                    recall_for_one_case = [recall_for_one_case, recall_current];
                    precision_slave = truePositive / m;
                    precision_for_one_case = [precision_for_one_case, precision_slave];
                    next_recall = next_recall + 0.1;
                end
                if truePositive ==  allGroundTruth % recall = 1
                    AP(n) = AP(n)/ allGroundTruth;
                    break;
                end 
            end     
        end
        if allGroundTruth < 8
            continue;
        end
        recall = [recall;recall_for_one_case];
        precision = [precision;precision_for_one_case];
    end
    mAP = mean(AP);
    recall = mean(recall,1);
    precision = mean(precision,1);
    savePRPoints(config,recall,precision);
end

function [mAP] = evaluate_nuswide(testData, result_list,config)
    testDataSize = config.testDataSize;
    theSizeOfEachConcept = getSizeOfEachConcept(testData.groundTruth);
    AP = zeros([1,testDataSize]);
    recall = zeros(1,19);
    precision = zeros(1,19);
    for n = 1:testDataSize
        ground_truth_object = testData.groundTruth(n);
        allGroundTruth = theSizeOfEachConcept(ground_truth_object);
        truePositive = 0;
        recall_for_one_case = [];
        precision_for_one_case = [];
        next_recall = 0.05;
        for m = 1:testDataSize
            prediction_object = testData.groundTruth(result_list(n,m));
            if ground_truth_object == prediction_object
                truePositive = truePositive+1;
                AP(n)=AP(n)+ truePositive/m; 
                recall_current = truePositive / allGroundTruth;
                if recall_current >= next_recall
                    recall_for_one_case = [recall_for_one_case, recall_current];
                    precision_slave = truePositive / m;
                    precision_for_one_case = [precision_for_one_case, precision_slave];
                    next_recall = next_recall + 0.05;
                end
                if truePositive ==  allGroundTruth % recall = 1
                    AP(n) = AP(n)/ allGroundTruth;
                    break;
                end 
            end     
        end
        if allGroundTruth < 19
            continue;
        end
        recall = [recall;recall_for_one_case];
        precision = [precision;precision_for_one_case];
    end
    mAP = mean(AP);
    recall = mean(recall(1,:),1);
    precision = mean(precision(1,:),1);
    savePRPoints(config,recall,precision);
end

function [] = savePRPoints(config,recall,precision)
    method = [config.general.algorithm,'_', config.general.image_feature];
    direction = config.general.direction;
    savePath = ['./results/',method,direction,'.mat'];
    save(savePath,'recall','precision');
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

% For Nuswide
function [theSizeOfEachConcept] = getSizeOfEachConcept(groundTruth)
    conceptNumber = 81; % Divide samples into 10 classes
    theSizeOfEachConcept = zeros([1,conceptNumber]);
    for i = 1:conceptNumber
        theSizeOfEachConcept(i) = length(find(groundTruth == i));
    end
end