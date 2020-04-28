function [data] = load_nuswide(config)
    rootPath = config.general.rootPath;
    trainDataSize = config.trainDataSize;
    testDataSize = config.testDataSize;
    if strcmp(config.general.image_feature,'VGG19')
        imgDataPath = strcat(rootPath, 'data\nuswide\nus_img_vgg19.mat');
    else  
        imgDataPath = strcat(rootPath, 'data\nuswide\nus_img_raw.mat');
    end  
    textRawDataPath = strcat(rootPath, 'data\nuswide\nus_text.mat');
    testGroundTruth = strcat(rootPath, 'data\nuswide\nus_test_groundtruth.mat');
    
    load(imgDataPath);
    load(textRawDataPath);
    load(testGroundTruth);
    
    data = {};
    data.train = {};
    data.test = {};
    data.test.groundTruth = ground_truth(1:testDataSize);
    data.train.text = pre_process(double(text_train(1:trainDataSize,:)));
    data.test.text = pre_process(double(text_test(1:testDataSize,:)));
    data.train.image = pre_process(double(img_train(1:trainDataSize,:)));
    data.test.image = pre_process(double(img_test(1:testDataSize,:)));
end

function[processed_data] = pre_process(raw_data)
    dataSize = size(raw_data,1);
    % Decentralization
    processed_data = raw_data - repmat(mean(raw_data),dataSize,1);
    % Normalize
    processed_data = processed_data * sqrt(diag(1./diag(processed_data'*processed_data)));
    processed_data(isnan(processed_data)==1)=0;
end
